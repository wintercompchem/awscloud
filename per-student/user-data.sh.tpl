#!/bin/bash
# This file is not meant to be modified
# This is a template for a bash script that is filled in by terraform
# The bash script will be run on each instance 

# wait 5 minutes to be sure the package manager is free
APT_GET="apt-get -o DPkg::Lock::Timeout=300"

# Create ssm-user and disallow sudo
configure_ssm_user() {
  useradd -m ssm-user
  echo "# User rules for ssm-user" > /etc/sudoers.d/ssm-agent-users
  %{if debug}
  echo "ssm-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ssm-agent-users
  %{endif}
}

# Install apache httpd
#
# Set the ownership of the document root to ssm-user,
# so students can place their output files for download
# 
# Use the AWS console password to configure authentication,
# so the student only has to use one password
configure_apache() {
  $${APT_GET} -y install apache2
  rm /var/www/html/index.html
  chown ssm-user:ssm-user /var/www/html
  cat > /root/password.in << 'EOF'
${password}
EOF
  echo ${student}:$(openssl passwd -apr1 -in /root/password.in) > /etc/apache2/.htpasswd
  rm /root/password.in
  cat > /etc/apache2/sites-available/000-default.conf << 'END'
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/html
  ErrorLog /var/log/apache2/error.log
  CustomLog /var/log/apache2/access.log combined
  <Directory "/var/www/html">
    AuthType Basic
    AuthName "${student} data download"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
  </Directory>
</VirtualHost>
END
  systemctl reload apache2.service
}

# ensure latest packages are available
$${APT_GET} update

configure_ssm_user
configure_apache

# User-defined workload setup
# If this is not defined, it will run '/bin/true', so the script will exit success
${init_commands}
