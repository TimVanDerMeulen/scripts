FROM ubuntu

RUN apt-get update

# install sudo
RUN apt-get install sudo

# test user
RUN groupadd -r test && useradd --no-log-init -r -g test test
RUN adduser test sudo
RUN install -d -m 0755 -o test -g test /home/test

# install ssh server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# the ssh password
RUN echo 'test:testpw' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]