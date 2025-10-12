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
# NOTE: The script below compiles Gromacs from source, which can be
# a lengthy process. Allow approximately 30 minutes after 
# instance launch for installation to complete before logging 
# into the instance.
# 
init_commands = <<END
# Install Gromacs.
# Script adapted from https://manual.gromacs.org/current/install-guide/index.html. 
cd /root
apt -y install make gcc g++ cmake

# Download and verify. If md5 doesn't match, retry with exponential backoff
# for a couple of minutes.
GROMACS_MD5=5a2315b6f6e13b091bbbbfddee9eb62b
for s in 0 1 2 4 8 16 32 64 128
do
  sleep $s
  wget https://ftp.gromacs.org/gromacs/gromacs-2025.3.tar.gz
  echo $${GROMACS_MD5}  gromacs-2025.3.tar.gz | md5sum -c && break
done

tar xzf gromacs-2025.3.tar.gz
cd gromacs-2025.3
mkdir build
cd build
cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON
make
make install
echo source /usr/local/gromacs/bin/GMXRC.bash >> /home/ssm-user/.bashrc
END
