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
#   # specify Build root passwd 
#     docker build --build-arg PASSWD='xxxx' -t kanalfred/centos6 .
# 
##############################

FROM centos:centos6
MAINTAINER Alfred Kan <kanalfred@gmail.com>

ARG PASSWD @Docker!

#################
# Users
#ENV USER alfred
#ENV PASSWD @Docker!

#RUN adduser --uid 1000 --gid 50 $USER \
#        && echo $PASSWD | passwd $USER --stdin
#RUN adduser --uid 500 hostadmin \
#        && echo $PASSWD | passwd hostadmin --stdin

# Sudoer
#ADD wheel_sudo.conf /etc/sudoers.d/wheel
#RUN chmod 0600 /etc/sudoers.d/wheel \
#        && usermod -a -G wheel $USER
#################


# Add key for root user
ADD container-files/key/authorized_keys2 /root/.ssh/authorized_keys2

# root password
RUN echo "root:$PASSWD" | chpasswd

# Epel
ADD container-files/rpm/epel-release-6-8.noarch.rpm /tmp/epel-release-6-8.noarch.rpm

#sudo yum install epel-release
#RUN yum update -y && yum clean all \
#RUN rpm -Uvh /tmp/epel-release-6-8.noarch.rpm \

# Install require packages
RUN \ 
    yum install -y \
	# EPEL Repo
        /tmp/epel-release-6-8.noarch.rpm \

	# Packages
	openssh-server \
        sudo 


# SSH setup
RUN chkconfig sshd on

# disalbe GSSAPIAuthentication=no for ssh

# EXPOSE
EXPOSE 22

# Clean YUM caches to minimise Docker image size
RUN yum clean all && rm -rf /tmp/yum*

# CMD
#CMD ["/usr/sbin/sshd", "-D"]
# start all register services
CMD ["/sbin/init", "-D"]

# Docker compose Env var 1.5 >
#image: "postgres:${POSTGRES_VERSION}"

# Run
#docker run -h centos6 -e USER='alfred' -e PASSWD='xxxx' -P -d --name centos6 --restart=always kanalfred/centos6
#docker run -h centos6 -p 2200:22 -d --name centos6 -v /home/alfred/docker/data/centos6:/home/alfred/doc kanalfred/centos6
#docker run -h centos6 -p 192.168.3.129:22:22 -d --name centos6 -v /home/alfred/docker/data/centos6:/home/alfred/doc kanalfred/centos6

# Mysql
#docker run --name mysql -p 3307:3306 -v /home/alfred/docker/data/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD='xxxx' -d mysql
#docker run --name mysql -p 192.168.3.128:3307:3306 -v /home/alfred/docker/data/db:/var/lib/mysql -e MYSQL_ROOT_PASSWORD='xxxx' -d mysql
