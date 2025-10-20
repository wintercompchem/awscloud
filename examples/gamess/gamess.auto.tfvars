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
# Once you have the appropriate URL and credentials, fill them in here, along with the
# MD5 of the file. This is listed at https://www.msg.chem.iastate.edu/GAMESS/download/dist.source.shtml
GAMESS_URL=https://www.msg.chem.iastate.edu/GAMESS/download/source/gamess-current.tar.gz
GAMESS_MD5=6210613bddd3930e67b7a7eba8c24e4c
GAMESS_USER=
GAMESS_PASSWORD=

# Download the GAMESS source code into the /home/ssm-user directly where it will be used.
# Ubuntu's CA store apparently does not trust www.msg.chem.iastate.edu, so
# we'll use --no-check-certificate here. If you are downloading from your own
# web server you can remove the flag, if you'd like to.
cd /home/ssm-user

# Download and verify. If md5 doesn't match, retry with exponential backoff
# for a couple of minutes.
for s in 0 1 2 4 8 16 32 64 128
do
  sleep $s
  wget --user $${GAMESS_USER} --password $${GAMESS_PASSWORD} --no-check-certificate $${GAMESS_URL}
  echo $${GAMESS_MD5}  gamess-current.tar.gz | md5sum -c && break
done

# Install build tools and library dependencies
apt-get -y install csh gfortran make libatlas-base-dev liblapack-dev libblas-dev libxc-dev libxc9 cmake g++

# Decompress the code
tar xzvf gamess-current.tar.gz
rm gamess-current.tar.gz
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

# create scratch and restart directories
mkdir scratch restart

# rungms appears to contain an error when checking for OMP_NUM_THREADS
# the code, appearing on Line 164 contains a bash variable for checking
# the number of arguments:
#   if($# > 5)
# However, because it is a csh script, it needs to be written as:
#   if($#argv > 5)
# This sed command makes the needed change.
sed -i 's/if($# > 5)/if($#argv > 5)/g' rungms

# Set ownership to ssm-user
cd ..
chown -R ssm-user:ssm-user gamess

# Ensure GMS_PATH and JOB_PATH variables are set
echo export GMS_PATH=/home/ssm-user/gamess >> /home/ssm-user/.bashrc 
echo export JOB_PATH=. >> /home/ssm-user/.bashrc
END
