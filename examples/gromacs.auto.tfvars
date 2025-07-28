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
init_commands = <<END
# Install Gromacs.
# Script adapted from https://manual.gromacs.org/current/install-guide/index.html. 
cd /root
apt -y install make gcc g++ cmake
wget https://ftp.gromacs.org/gromacs/gromacs-2025.2.tar.gz
tar xzf gromacs-2025.2.tar.gz
cd gromacs-2025.2
mkdir build
cd build
cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON
make
make install
echo source /usr/local/gromacs/bin/GMXRC.bash >> /home/ssm-user/.bashrc
END
