# Introduction
View OS (aka __vuos__) is a set of tools that make use of Linux user namespaces to
allow virtualization of resources. The aim of the project is to give
unprivileged users the full control over those things that they could do but
have been restricted from doing for the pure lack of perspective in the way
things have been built.

From the integration of virtual services, new possible applications emerged and limits imposed by existing virtualization tools became clear. It is the case of partial virtual machines. The possibility to have systems where only some parts are virtual appeared as a new and interesting perspective.

Nowadays modern unix-like operating systems provide several tools that give some specific kind of partial virtuality but they have never been used seriously with the partial virtual machine in mind. System calls like the Posix *chroot* or tools like *fakeroot* act partially modifying the view that a process has of the underlying operating system. A wider idea of partial virtuality is not compatible with these tools, that were designed to accomplish specific and independent tasks. Like for virtual machines there is the __need of a common framework__, so new ideas were developed.


## A process with a view

Focusing on partial virtual machines and on the idea that they could be build as basic components of operating systems and networking stacks arises the View OS thesis: each process running on an operating system should have its own perspective, its own view. From file systems to networking, devices and inter process communication infrastructure should be redefine-able on every process and by process basis.


## Process view vs Global view

Considering the view of two processes running on two different computers the same pathname generally address different files, they have a different perception of the network, different resource ownership and permission. On the other hand two processes running on the same computer have an implicit global view of it: they must share the same network stack and therefore the same network address, the same file system and so on. View OS aims to free the processes from this assumption.


## Why View OS?

### Optimization of resources utilization
Although it is possible to give to processes running on the same physical computer a completely different view of the system running processes inside virtual machines, this way of operate is extremely expensive in terms of time and resources. This means that to give a process its own view of the running environment an entire operating system kernel must be loaded into memory, a big chunk of memory must be allocated to emulate virtual machine main memory and so on. This results in a superfluous waste of resources.

### Drawbacks of global view approach
- Global filesystem view  
In an environment where there is an implicit global view assumption for processes a strict boundary separates system calls that modify processes' view from other less dangerous calls. The former are usually restricted for system administration use while the latter are available also for normal user usage. These restrictions are often due to the global view assumption rather than to a real security issue. In many cases the restrictions appear to be lack in operating system design. For example it is not possible for a user without administrative permissions to mount its own file system images.

- Global network view  
Global network address within the same physical computer and unique shared network stack provided by the operating system kernel are other aspects of the global view problem. In real world applications the possibility for a process to have its own network stack and network address may be extremely useful. For example it allows processes that act as network servers to be completely independent from the computer where they are running.

View OS aims to overcome this limitations. Each process should be able to define its own view of the world in terms of file system, networking, devices, permissions, users, time and so on. View OS can be seen as a configurable, modular and general process virtual machine.


## The virtualizer
UMview is a View OS implementation as a System Call Virtual machine, or to be more precise as a Partial Virtual Machine. A Partial Virtual Machine is a System Call Virtual machine that provides the same set of system calls of the hosting kernel. Having the same interface from process to Partial Virtual Machine, and from Partial Virtual Machine and hosting kernel it is also possible to combine several partial virtual machines together, applying them one on top of the other.


# Requirements
You will need user namespaces enabled and ptrace scope disabled:
```bash
# This configuration will not survive a system reboot
echo 0 > /proc/sys/kernel/yama/ptrace_scope
echo 1 > /proc/sys/kernel/unprivileged_userns_clone
```
```bash
# This is the same as before but is persistent
sysctl -w kernel.yama.ptrace_scope=0
sysctl -w kernel.unprivileged_userns_clone=1
```

# Install
Two options are given to install or try out the full suite of software.  
The bare metal option works on any Debian Buster (the current testing edition as of Sep. 2018) and the second will work in any Docker instance.  
Both methods will compile all the tools from source, downloading it from the respective git repositories.

## Debian Buster
Just git clone the and run the installer script on a Debian Testing installation.
It will download, build and install all the software for the project.
You can find the list of the packages required to successfully build and run
the software in the [Dockerfile](https://github.com/gufoe/vuos-tutorial/blob/master/Dockerfile)
```bash
git clone git@github.com:gufoe/vuos-tutorial.git
cd vuos-tutorial/
sudo ./vuos/install.sh
```

## Docker Image
A `Dockerfile` is available for testing the programs in an isolated manner (remember you will have to give the umvu command yourself).
All you need to do is:
1. build the image: `docker build -t vuos .`  
2. run it: `docker run -ti --cap-add=SYS_PTRACE vuos`  


# Quick Start

## Basic Commands
- `umvu`: starts the virtualization process (usage: `umvu sh`)
- `vu_insmod`: enables a module inside the virtualized process (usage: `vu_insmod mod1 [mod2 [mod3 [...]]]`)
- `vu_rmmod`: disables a module (usage: `vu_rmmod mod`)
- `vu_lsmod`: lists the modules enabled for the current process

A list of modules can be found listing the files in `/usr/local/lib/vu/modules/`

The following sections will make reference to files in this repository so that you can have an easy way to tweak the parameters.



## Modules
The following commands will assume the shell on which they run has already been virtualized by umvu:
```bash
umvu sh
```

### VUFUSE for file systems
`vu_insmod vufuse`
Now we are (not really, you'll see) able to mount any filesystem for which an implementation exists.
You can find a few example files in the `meta/` directory.  
`mkdir mnt/`
The following command will fail:  
`mount -t vufuseext2 ./meta/file-ext2.img mnt/`  
with `mount: only root can use "--types" option` and this is because the implementation of mount does more than it should and checks that the user is root __before__ actually trying to use the system call. This is why we will need to add an additional module that will fake our user id (kind of how fakeroot works) to let mount actually do its job.  
```bash
vu_insmod unrealuidgid
vusu -p -s /usr/bin/sh
```
Now we are finally able to mount file-ext2.img into `mnt/` and list its contents as normal with `ls -l mnt/`.  

__TODO:__  
- compile drivers for other filesystems  
*maybe taking fuse an recompiling it using our own dynamically linked library to minimize the work*


### VUNET for networking
`vu_insmod vunet`  
`mount -t vunetvdestack vxvde:// /dev/net/mynet`  
where `vxvde://` is any VDE valid url and `/dev/net/mynet` the mount name.
Processes will use the default network stack, so if you call `ip addr` you won't see the VDE interface. To let a process use a different network stack, you can pass the command to `vustack` as follows:
```bash
vustack /dev/net/mynet ip addr
```
__TODO:__
- insert link to documentation


### BINFMT for running foreign code
```bash
vu_insmod vubinfmt
mount -t vubinfmt none /proc/sys/fs/binfmt_misc
echo ':ppc:M::\x7fELF\x01\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x14:\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff:/usr/bin/qemu-ppc:' \
     > /proc/sys/fs/binfmt_misc/register
echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm:' \
     > /proc/sys/fs/binfmt_misc/register
```
these two echo commands define the emulators to be invoked when an exec system call tries to load ppc or arm executables. (each echo command must be typed on a single line.  
It is now possible to run foreign executables:  
```bash
uname -a
file meta/bash
./meta/bash -c "ls -l /"
```


### Other Modules
__*This is a STUB*__




# Documentation about the documentation
This chapter illustrates how this documentation has been generated and how it can be maintained.  

## Editing existing documentation
This is straight forward and all is needed is to modify the markdown files `.md` in this directory.

## Going deeper
This html page is produced using [docsify](https://docsify.js.org): you'll find there how to configure the whole site.  
Docsify does not generate static HTML, its working is super simple: it generates this HTML file which:
1. Loads the CSS for styling
2. Loads the JS that will do the magic
3. The JS loads and renders the markdown files as specified in the `index.html`

So the HTML does not need to be changed and the whole system can be hosted as static files.
