FROM ubuntu:latest
RUN apt-get update -y > /dev/null 2>&1 && apt-get upgrade -y > /dev/null 2>&1 \
&& apt-get install -y locales git curl nano screen ffmpeg python3-pip
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash -
RUN apt-get install -y nodejs
ENV LANG en_US.utf8
ARG NGROK_TOKEN
ENV NGROK_TOKEN=${NGROK_TOKEN}
RUN apt-get install ssh wget unzip -y > /dev/null 2>&1
RUN wget -O ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
RUN unzip ngrok.zip
RUN echo "./ngrok config add-authtoken ${NGROK_TOKEN} &&" >>/start
RUN echo "./ngrok tcp --region ap 22 &>/dev/null &" >>/start
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/start
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:kaal|chpasswd
RUN service ssh start
RUN chmod 755 /start
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD  /start
