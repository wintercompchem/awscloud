# Installation and configuration of software is done here.
# Any bash commands between
# init_commands = <<END
# and
# END
# will be executed (as root) upon instance creation.
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
# NOTE: The script below compiles GAMESS from source, which can be
# a lengthy process. Allow approximately 15 minutes after 
# instance launch for installation to complete before logging 
# into the instance.

init_commands = <<END
# you have two options for downloading GAMESS onto EC2 instances
# 1) You may work with your IT team to create a password protected website
# and upload the source code to it. If you chose this option you MUST
# protect the source or you will be in violation of the GAMESS license.
# 2) You may download directly from the GAMESS website.
# If you chose this option you must fill out the form at: https://www.msg.chem.iastate.edu/gamess/License_Agreement.html
# to obtain an email with the current credentials
#
# Once you have the appropriate URL and credentials, fill them in here
GAMESS_URL=https://www.msg.chem.iastate.edu/GAMESS/download/source/gamess.Jul152024R2.tar.gz
GAMESS_USER=
GAMESS_PASSWORD=

# Download the GAMESS source code into the /home/ssm-user directly where it will be used.
# Ubuntu's CA store apparently does not trust www.msg.chem.iastate.edu, so
# we'll use --no-check-certificate here. If you are downloading from your own
# web server you can remove the flag, if you'd like to.
cd /home/ssm-user
wget --user $${GAMESS_USER} --password $${GAMESS_PASSWORD} --no-check-certificate $${GAMESS_URL}

# Install build tools and library dependencies
apt-get -y install csh gfortran make libatlas-base-dev liblapack-dev libblas-dev libxc-dev libxc9 cmake g++

# Decompress the code
tar xzvf gamess.Jul152024R2.tar.gz
rm gamess.Jul152024R2.tar.gz
cd gamess

# Determine the version of FORTRAN and pass it to the install info script
# This appears to be a required flag, even though it can be determined programatically
FORTRAN_VERSION=$(gfortran --version | head -1 | awk '{print $NF}')
./bin/create-install-info.py --fortran_version $${FORTRAN_VERSION}

# Build DDI and LAPACK
make ddi
./tools/lapack/download-lapack.csh
make lapack

# Build GAMESS
make

# Set ownership to ssm-user
cd ..
chown -R ssm-user:ssm-user gamess

# Ensure GMS_PATH and JOB_PATH variables are set
echo export GMS_PATH=/home/ssm-user/gamess >> /home/ssm-user/.bashrc 
echo export JOB_PATH=. >> /home/ssm-user/.bashrc
END
