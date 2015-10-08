FROM centos
MAINTAINER Sthapaun Patinthu <contact@sthapaun.com>
MAINTAINER Krishna Pennacchioni <krishna@agentelinux.com.br>


# Install emacs
RUN yum update; yum -y install emacs; yum -y install wget; yum -y install zip; yum -y install unzip; cd ~/; mkdir Desktop; cd Desktop; wget https://storage.googleapis.com/ddd-cdn/dev/editors/emacs.tar.gz; tar -zxvf emacs.tar.gz; cd emacs; cp emacs ~/.emacs; cp -r emacs.d ~/.emacs.d; rm ~/Desktop/emacs.tar.gz; rm -r ~/Desktop/emacs;

# Download importance packages then install
RUN yum update; yum -y install gcc-c++ patch openssl-devel libjpeg-devel libxslt-devel readline-devel make which python-devel; yum -y install sudo bzip2; 

# Edit sudoers file
# From https://hub.docker.com/r/liubin/fluentd-agent/~/dockerfile/
# To avoid error: sudo: sorry, you must have a tty to run sudo
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

RUN useradd -m plone; su plone; cd ~/Desktop; wget https://launchpad.net/plone/5.0/5.0/+download/Plone-5.0-UnifiedInstaller.tgz; tar -zxvf Plone-5.0-UnifiedInstaller.tgz; mv Plone-5.0-UnifiedInstaller plone5; cd plone5; sudo ./install.sh standalone; sudo -u plone_daemon /opt/plone/zinstance/bin/plonectl start;

# run bottle webapp
RUN cd ~/; mkdir Dev; cd Dev; wget https://pypi.python.org/packages/source/b/bottle/bottle-0.12.8.tar.gz#md5=13132c0a8f607bf860810a6ee9064c5b; tar -zxvf bottle-0.12.8.tar.gz; mv bottle-0.12.8 bottle; cd bottle; echo "from bottle import route, run, template" > app.py; echo "@route('/hello/<name>')" >> app.py; echo "def index(name):" >> app.py; echo "    return template('<b>Hello {{name}}</b>!', name=name)" >> app.py; echo "run(host='localhost', port=80)" >> app.py; 

EXPOSE 8080

CMD ["python", "/root/Dev/bottle/app.py"]
