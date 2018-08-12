FROM debian:sid
RUN apt-get update
RUN apt-get -y install git python3
RUN apt-get -y install build-essential cmake make
RUN apt-get -y install autogen autoconf libtool
RUN apt-get -y install libcap-dev libattr1-dev libfuse-dev libexecs-dev
COPY vuos /root/vuos
RUN /root/vuos/install.sh
ENTRYPOINT ["bash", "-c", "cd /root && echo Available vuos commands: $(ls vuos/gits/vuos/build/bin/) && bash"]
