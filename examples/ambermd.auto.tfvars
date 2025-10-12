# Installation and configuration of software is done here
# Any bash commands between
# init_commands = <<END
# and
# END
# will be executed (as root) on instance creation.
# 
# Terraform will attempt to interpret and
# substitute any Terraform variables it finds.
# Terraform variables look like: ${variable_name}
# If you use this form for bash variables,
# you will need an additional dollar sign.
# For bash to see ${variable_name} specify $${variable_name}
# If you are not using the braces, doubling the dollar sign
# is not needed. $variable_name here will be passed to bash
# unmodified.
#
# NOTE: The script below compiles Amber from source, which can be
# a lengthy process. Allow approximately 45 minutes after 
# instance launch for installation to complete before logging 
# into the instance.
# 
init_commands = <<END
# Script adapted from https://ambermd.org/GetAmber.php and https://ambermd.org/InstUbuntu.php

# You MUST fill out NAME and INSTITUTION for the download to work
NAME="Alexandra Richards"
INSTITUTION="Self"

# Install dependencies
apt-get -y install bzip2 cmake tcsh make gcc g++ gfortran flex bison patch bc wget xorg-dev libz-dev libbz2-dev openmpi-bin libopenmpi-dev python-is-python3

# Download Amber
cd /opt

# Download and verify. If md5 doesn't match, retry with exponential backoff
# for a couple of minutes.
AMBER_MD5=999d2bb64c97d3849938c6b4e35aa36f
for s in 0 1 2 4 8 16 32 64 128
do
  sleep $s
  curl -X POST --data-urlencode "Name=$${NAME}" --data-urlencode "Institution=$${INSTITUTION}" https://ambermd.org/cgi-bin/Amber24free-get.pl > pmemd24.tar.bz2
  echo $${AMBER_MD5}  pmemd24.tar.bz2 | md5sum -c && break
done

bunzip2 pmemd24.tar.bz2
tar xvf pmemd24.tar

# Install Amber
cd /opt/pmemd24_src
./update_pmemd --update
cd build
# Disable CUDA. Remove this sed command if using a GPU instance family
sed -i 's/-DCUDA=TRUE/-DCUDA=FALSE/g' run_cmake
./run_cmake
make install
echo "source /opt/pmemd24/amber.sh" >> /home/ssm-user/.bashrc
echo "export PATH=$${PATH}:/opt/pmemd24/bin" >> /home/ssm-user/.bashrc

# Download AmberTools
cd /opt

# Download and verify. If md5 doesn't match, retry with exponential backoff
# for a couple of minutes.
AMBERTOOLS_MD5=1787f8a819717bf9443fcefd696a5861
for s in 0 1 2 4 8 16 32 64
do
  sleep $s
  curl -X POST --data-urlencode "Name=$${NAME}" --data-urlencode "Institution=$${INSTITUTION}" https://ambermd.org/cgi-bin/AmberTools25-get.pl > ambertools25.tar.bz2
  echo $${AMBERTOOLS_MD5}  ambertools25.tar.bz2 | md5sum -c && break
done

bunzip2 ambertools25.tar.bz2
tar xvf ambertools25.tar

# Install AmberTools
cd /opt/ambertools25_src
./update_amber --update
cd build
./run_cmake
make install
echo "source /opt/ambertools25/amber.sh" >> /home/ssm-user/.bashrc
echo "export PATH=$${PATH}:/opt/ambertools25/bin" >> /home/ssm-user/.bashrc
END
