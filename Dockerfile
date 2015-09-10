FROM centos
MAINTAINER Sthapaun Patinthu <contact@sthapaun.com>


# Install emacs
RUN yum update; yum -y install emacs; yum -y install wget; yum -y install zip; yum -y install unzip; cd ~/; mkdir Desktop; cd Desktop; wget https://storage.googleapis.com/ddd-cdn/dev/editors/emacs.tar.gz; tar -zxvf emacs.tar.gz; cd emacs; cp emacs ~/.emacs; cp -r emacs.d ~/.emacs.d; rm ~/Desktop/emacs.tar.gz; rm -r ~/Desktop/emacs;

# Download importance packages then install
RUN yum update; yum -y install gcc-c++ patch openssl-devel libjpeg-devel libxslt-devel readline-devel make which python-devel; yum -y install sudo bzip2; 

# Edit sudoers file
# From https://hub.docker.com/r/liubin/fluentd-agent/~/dockerfile/
# To avoid error: sudo: sorry, you must have a tty to run sudo
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

# useradd -m plone; su plone;
RUN cd ~/Desktop; wget https://launchpad.net/plone/5.0/5.0rc1/+download/Plone-5.0rc1-UnifiedInstaller.tgz; tar -zxvf Plone-5.0rc1-UnifiedInstaller.tgz; mv Plone-5.0rc1-UnifiedInstaller.tgz plone5; cd plone5; sudo ./install.sh standalone; sudo -u plone_daemon /opt/plone/zeocluster/bin/plonectl start;

EXPOSE 8080

CMD /bin/bash