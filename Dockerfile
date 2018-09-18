FROM debian:sid
RUN apt-get update
RUN apt-get -y install git python3
RUN apt-get -y install build-essential cmake make
RUN apt-get -y install autogen autoconf libtool
RUN apt-get -y install libcap-dev libattr1-dev libfuse-dev libexecs-dev
RUN apt-get -y install libssl1.0-dev libmhash-dev libpam0g-dev
RUN useradd -ms /bin/bash user
WORKDIR /home/user
COPY vuos ./vuos
RUN ./vuos/install.sh
RUN chown -R user:user vuos
RUN apt install busybox
USER user
ENTRYPOINT ["sh", "-c", "echo Available vuos commands: $(ls vuos/gits/vuos/build/bin/) && sh"]
