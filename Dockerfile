# Global args
ARG BASE_DEBIAN=bookworm-slim

################################################################################
# We utilize this small alpine layer to cache the downloaded xampp installer
################################################################################

FROM alpine/curl as xampp_downloader
# Get xampp installation from url, requires to download It every time we build
#ARG XAMPP_URL
#RUN curl -Lo xampp-linux-installer.run $XAMPP_URL
# Or copy xamp installation from directory 
ARG XAMPP_PATH
COPY $XAMPP_PATH xampp-linux-installer.run 

################################################################################
# Here, we build the xampp image
################################################################################
FROM debian:${BASE_DEBIAN}

ENV DEBIAN_FRONTEND noninteractive

# Set root password to root, format is 'user:password'.
RUN echo 'root:root' | chpasswd

# See https://docs.docker.com/develop/develop-images/instructions/#apt-get for apt-get guidelines
RUN apt-get update --fix-missing && \
  # curl is needed to download the xampp installer, net-tools provides netstat command for xampp
  apt-get install -y --no-install-recommends curl net-tools openssh-server \
      supervisor nano vim less && \
  rm -rf /var/lib/apt/lists/*

COPY --from=xampp_downloader xampp-linux-installer.run .
RUN chmod +x xampp-linux-installer.run && \
  bash -c './xampp-linux-installer.run' && \
  # Delete the installer after it's done to make the resulting image smaller
  rm xampp-linux-installer.run && \
  ln -sf /opt/lampp/lampp /usr/bin/lampp && \
  # Enable XAMPP web interface(remove security checks)
  sed -i.bak s'/Require local/Require all granted/g' /opt/lampp/etc/extra/httpd-xampp.conf && \
  # Enable error display in php
  sed -i.bak s'/display_errors=Off/display_errors=On/g' /opt/lampp/etc/php.ini && \
  # Enable includes of several configuration files
  mkdir /opt/lampp/apache2/conf.d && \
  echo "IncludeOptional /opt/lampp/apache2/conf.d/*.conf" >> /opt/lampp/etc/httpd.conf && \
  # Create a /www folder and a symbolic link to it in /opt/lampp/htdocs. It'll be accessible via http://localhost:[port]/www/
  # This is convenient because it doesn't interfere with xampp, phpmyadmin or other tools in /opt/lampp/htdocs
  mkdir /www && \
  ln -s /www /opt/lampp/htdocs && \
  # SSH server
  mkdir -p /var/run/sshd && \
  # Allow root login via password
  sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config


################################################################################
# Here, we build tomcat
################################################################################

RUN echo "Installing java" && \
    apt-get update && \
    apt-get install -y --no-install-recommends default-jdk wget tmux && \
    # It is not advisable to run Tomcat under a root account.
    # Hence we need to create a new user where we run the Tomcat 
    # server on our system
    echo "Adding user tomcat" && \
    useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat && \
    # Getting Tomcat
    echo "Downloading Tomcat 8.5.79" && \
    wget -c https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.79/bin/apache-tomcat-8.5.79.tar.gz && \
    echo "Tomcat Downloaded, unpacking" && \
    # TODO chech checksum 
    tar xf apache-tomcat-8.5.79.tar.gz -C /opt/tomcat && \
    # Now we need to provide the user Tomcat with access for the Tomcat installation 
    # directory. We would use the chown command to change the directory ownership.
    echo "Setting up permissions" && \
    chown -R tomcat: /opt/tomcat/* && \
    # Finally, we will use the chmod command to provide all executable flags to all 
    # scripts within the bin directory.
    # Configure admin users
    echo "Writing /opt/tomcat/apache-tomcat-8.5.79/conf/tomcat-users.xml" && \
    echo "\
<tomcat-users xmlns=\"http://tomcat.apache.org/xml\"\n\
          xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n\
          xsi:schemaLocation=\"http://tomcat.apache.org/xml tomcat-users.xsd\"\n\
          version=\"1.0\">\
<role rolename=\"manager-gui\" />\n\
<user username=\"manager\" password=\"manager\" roles=\"manager-gui\" />\n\n\
<role rolename=\"admin-gui\" />\n\
<user username=\"admin\" password=\"admin\" roles=\"manager-gui,admin-gui\" />\n\
</tomcat-users>" \
   > /opt/tomcat/apache-tomcat-8.5.79/conf/tomcat-users.xml && \
   # Allow access from browsers
   echo "\
<Context antiResourceLocking=\"false\" privileged=\"true\" >\n\
  <CookieProcessor className=\"org.apache.tomcat.util.http.Rfc6265CookieProcessor\"\n\
                   sameSiteCookies=\"strict\" />\n\
  <Manager sessionAttributeValueClassNameFilter=\"java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap\"/>\n\
</Context>\n\
   " > /opt/tomcat/apache-tomcat-8.5.79/webapps/manager/META-INF/context.xml && \
   echo "Cleaning Up" && \
   rm apache-tomcat-8.5.79.tar.gz && \
   echo "Installation Completed!"

# TODO copy the tomcat servlet template 



# copy supervisor config file to start openssh-server
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME [ "/var/log/mysql/", "/var/log/apache2/", "/www", "/opt/lampp/apache2/conf.d/" ]

# Listen to those ports 

EXPOSE 3306
# SSH
EXPOSE 22
# Main
EXPOSE 80
# Tomcat
EXPOSE 8080

CMD ["/usr/bin/supervisord", "-n"]

# Added path to acces lampp programs
ENV PATH=/opt/lampp/bin:$PATH


