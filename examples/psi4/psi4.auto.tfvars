# This file is part of https://github.com/wintercompchem/awscloud 
#
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
# NOTE: The script below downloads and configures Psi4. 
# Allow approximately 5 minutes after 
# instance launch for installation to complete before
# logging into the instance.
#
init_commands = <<END
# Install Psi4 
# Script adapted from https://psicode.org/installs/v191/
curl https://vergil.chemistry.gatech.edu/psicode-download/Psi4conda-1.9.1-py312-Linux-x86_64.sh -o /home/ssm-user/Psi4conda-1.9.1-py312-Linux-x86_64.sh
cd /home/ssm-user
chown ssm-user:ssm-user Psi4conda-1.9.1-py312-Linux-x86_64.sh
su - ssm-user -c "bash Psi4conda-1.9.1-py312-Linux-x86_64.sh -b -p /home/ssm-user/psi4conda"
echo $'. /home/ssm-user/psi4conda/etc/profile.d/conda.sh\nconda activate' >> /home/ssm-user/.bashrc
END
