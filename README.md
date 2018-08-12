# What is this
This contains a set of scripts to install and experiment with VUOS and its related projects (VDE etc).

## Install VUOS
Just run the vuos/install.sh script on a Debian installation.

## Run it with Docker
Build the image:
```bash
docker build -t vuos .
```
Run it:
```bash
docker run -ti --cap-add=SYS_PTRACE vuos
```

If on debian, remember to `echo 0 > /proc/sys/kernel/yama/ptrace_scope`
