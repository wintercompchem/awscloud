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
# Setup an upload/download directory
# so students can place their output files for download
# or upload via a web browser
# 
# Use the AWS console password to configure authentication,
# so the student only has to use one password
configure_apache() {
  $${APT_GET} -y install apache2 libcgi-pm-perl unzip
  mkdir /var/www/html/files
  groupadd uploader
  usermod -a -G uploader ssm-user
  usermod -a -G uploader www-data
  chown ssm-user:uploader /var/www/html/files
  chmod 2775 /var/www/html/files
  cat > /root/password.in << 'PW'
${password}
PW
  echo ${student}:$(openssl passwd -apr1 -in /root/password.in) > /etc/apache2/.htpasswd
  rm /root/password.in

  cat > /etc/apache2/sites-available/000-default.conf << 'CONF'
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/html
  ErrorLog /var/log/apache2/error.log
  CustomLog /var/log/apache2/access.log combined
  <Directory "/var/www/">
    AuthType Basic
    AuthName "${student} data"
    AuthUserFile /etc/apache2/.htpasswd
    Require valid-user
    IndexIgnore ..
  </Directory>
  ScriptAlias /uploader /var/www/uploader.cgi
</VirtualHost>
CONF

  # enable cgi-bin for file upload
  cd /etc/apache2/mods-enabled
  ln -s ../mods-available/cgi.load

  # setup an upload script
  cat > /var/www/uploader.cgi << 'UPLOADER'
#!/usr/bin/perl -w

use warnings;
use strict;
use CGI;

my $query = new CGI;

my ($msg, $title);

my $upload_dir = "/var/www/html/files";

print $query->header();

my @files = $query->param("files");
my @upload_filehandles = $query->upload("files");
my $upload_count = 0;
my $filename;

foreach my $file(@files) {
  $filename = $file;
  $filename =~ s/.*[\/\\](.*)/$1/;
  my $upload_filehandle = shift @upload_filehandles;
  next unless defined($upload_filehandle);
  
  open UPLOADFILE, ">$upload_dir/$filename";
  while ( <$upload_filehandle> )
  {
    print UPLOADFILE;
  }
  close UPLOADFILE;
  $upload_count++;
}
if ($upload_count > 0) {
  $msg = "$upload_count files have been uploaded";
  $title = "$upload_count files uploaded";
} else {
  $msg = "Please select files to upload";
  $title = "no files specified";
}

print qq|
<html>
  <head>
  <title>${student}: $title</title>
  </head>
  <body>
  <form action="/" method="GET" enctype="multipart/form-data">
  <b>$msg</b> <br /><br />
  <input type="submit" name="Ok" value="Ok">
  </form>
  </body>
</html>
|;
UPLOADER
  chmod +x /var/www/uploader.cgi

  # create an index file to allow upload or download
  cat > /var/www/html/index.html << 'INDEX'
<html>
  <head>
  <title>${student}: file upload or download</title>
  </head>
  <body>
  <form action="/uploader" method="POST" enctype="multipart/form-data">
  <b>Select a file to upload:</b>
  <input type="file" name="files" multiple="multiple">
  <input type="submit" name="Submit" value="Upload">
  </form>
  <iframe src="files/" title="Files" height="480" width="640"></iframe>
  </body>
</html>
INDEX

  # reload configuration
  systemctl reload apache2.service
}

# ensure latest packages are available
$${APT_GET} update

configure_ssm_user
configure_apache

# User-defined workload setup
# If this is not defined, it will run '/bin/true', so the script will exit success
${init_commands}
