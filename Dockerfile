##############################
# Alfred Centos 6 Base
#
# use docker pull the keep image updated
#   docker pull centos:6
#
# Run:
#     -h hostname centos
#     -e env var 
#     -P expose all ports
#     -d run as demon
#     --name container's name
#   # default user & passwd
#      docker run -h centos6 --name centos6 -p 192.168.3.129:22:22 -d -v /home/alfred/docker/data/centos6:/home/alfred/doc --restart=always kanalfred/centos6
#   # specify own user & passwd 
#      docker run -h centos6 --name centos6 -e USER='alfred' -e PASSWD='xxxx' -p 192.168.3.129:22:22 -d -v /home/alfred/docker/data/centos6:/home/alfred/doc --restart=always kanalfred/centos6
# 
##############################

FROM centos:centos6
MAINTAINER Alfred Kan <kanalfred@gmail.com>

# Users
#RUN useradd -ms /bin/bash newuser
#RUN usermod -u 1000 hostadmin
ENV USER alfred
ENV PASSWD landmark5!

RUN adduser --uid 1000 --gid 50 $USER \
        && echo $PASSWD | passwd $USER --stdin
RUN adduser --uid 500 hostadmin \
        && echo $PASSWD | passwd hostadmin --stdin

# add user pub key
#ADD authorized_keys2 /home/$USERRUN/.ssh/authorized_keys2

# root password
# RUN echo 'root:screencast' | chpasswd

# Epel
ADD epel-release-6-8.noarch.rpm /tmp/epel-release-6-8.noarch.rpm

#sudo yum install epel-release
# Install require packages
#RUN yum update -y && yum clean all \
RUN yum install -y /tmp/epel-release-6-8.noarch.rpm \
        && yum install -y sudo

# Sudoer
ADD wheel_sudo.conf /etc/sudoers.d/wheel
RUN chmod 0600 /etc/sudoers.d/wheel \
        && usermod -a -G wheel $USER

# SSH setup
RUN yum -y install openssh-server \
    && chkconfig sshd on

# disalbe GSSAPIAuthentication=no for ssh


# EXPOSE
EXPOSE 22

# Clean YUM caches to minimise Docker image size
yum clean all && rm -rf /tmp/yum*

# CMD
#CMD ["/usr/sbin/sshd", "-D"]
# start all register services
CMD ["/sbin/init", "-D"]

# Docker compose Env var 1.5 >
#image: "postgres:${POSTGRES_VERSION}"

# Run
#docker run -h centos6 -e USER='alfred' -e PASSWD='landmarkxx' -P -d --name centos6 --restart=always kanalfred/centos6
#docker run -h centos6 -p 2200:22 -d --name centos6 -v /home/alfred/docker/data/centos6:/home/alfred/doc kanalfred/centos6
#docker run -h centos6 -p 192.168.3.129:22:22 -d --name centos6 -v /home/alfred/docker/data/centos6:/home/alfred/doc kanalfred/centos6

# Mysql
#docker run --name mysql -p 3307:3306 -v /home/alfred/docker/data/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD='landmark5!' -d mysql
#docker run --name mysql -p 192.168.3.128:3307:3306 -v /home/alfred/docker/data/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD='landmark5!' -d mysql
