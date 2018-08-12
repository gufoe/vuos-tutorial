# Running in docker
Build it:
```bash
docker build -t vuos .
```
Run it:
```bash
docker run -ti --cap-add=SYS_PTRACE vuos
```

If on debian, remember to `echo 0 > /proc/sys/kernel/yama/ptrace_scope`
