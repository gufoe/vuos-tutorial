# What is this
This contains a set of scripts to install and experiment with VUOS and its related projects (VDE etc).

## Install VUOS
Just run the `vuos/install.sh` script on a Debian installation.  
Remember to
```bash
echo 0 > /proc/sys/kernel/yama/ptrace_scope
echo 1 > /proc/sys/kernel/unprivileged_userns_clone
```
## Run it with Docker
Build the image: `docker build -t vuos .`  
Run it: `docker run -ti --cap-add=SYS_PTRACE vuos`  
