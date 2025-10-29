# This file is part of https://github.com/wintercompchem/awscloud 
#
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
init_commands = <<END
# Install basic development packages.
apt -y install make gcc g++ git
# Move to the ssm-user home directory.
cd /home/ssm-user
# Clone the code into the /home/ssm-user directory.
git clone https://github.com/FoleyLab/MolecularDynamics.git
# Move to the MolecularDynamics directory.
cd MolecularDynamics
# Compile the MD code with make.
make
# Move back up to the /home/ssm-user directory.
cd ..
# Note that students will be logged in as "ssm-user" 
# when running the lab.
# Set ownership to ssm-user.
chown -R ssm-user:ssm-user MolecularDynamics
END
