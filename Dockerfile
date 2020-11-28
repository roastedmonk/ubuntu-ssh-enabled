FROM ubuntu:20.10

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:Passw0rd' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN sudo apt-get install cf-cli nano -y

RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN sudo bash nodesource_setup.sh
RUN sudo apt-get install nodejs -y

EXPOSE 22 19000 19001 19002 19003 19004 19005 19006 19007 19008 19009 20000
CMD ["/usr/sbin/sshd", "-D"]
