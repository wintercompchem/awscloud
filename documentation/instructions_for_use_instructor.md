
## _Instructor Supplementary Information_
Contents:

- [Creating an AWS Account](#creating-an-aws-account)
- [Requesting a Quota Increase in AWS](#requesting-a-quota-increase-in-aws)
- [Running Terraform in AWS CloudShell](#running-terraform-in-aws-cloudshell)

### Creating an AWS Account
To get started with AWS it is a good idea to first review the [prerequisites](https://docs.aws.amazon.com/accounts/latest/reference/getting-started-prerequisites.html) for creating a new AWS account.

Then follow these steps:

1.	Create an [AWS account](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html).
2.	[Activate MFA](https://docs.aws.amazon.com/accounts/latest/reference/getting-started-step3.html) for your root user.
3.	Create an [administrator user](https://docs.aws.amazon.com/accounts/latest/reference/getting-started-step4.html). 

> Note: Since you cannot restrict what a root user can do, AWS strongly recommends that you do not use your root user for any tasks that do not explicitly require the root user. Instead, it is recommended you assign administrative access to an administrative user in IAM Identity Center and use it to create your student instances. 
This [link](https://docs.aws.amazon.com/accounts/latest/reference/accounts-access-account.html) discusses ways of accessing your AWS account. We assume the instructor will access AWS via the [AWS console] (https://console.aws.amazon.com/) which can be accessed through a browser.

### Requesting a Quota Increase in AWS
The default limit on the number of instances that can be requested by a new user may be too small for your class needs. To request an increase in the number of instances that can be allocated please see the following [AWS documentation](https://docs.aws.amazon.com/servicequotas/latest/userguide/request-quota-increase.html). Make sure the AWS region that you want to use is selected at the top of the page. A separate request must be made for each region you want to use.
In step 3 search for Amazon Elastic Compute Cloud (Amazon EC2) in the AWS service search box.
Under service quotas click on quota name “Running On-Demand Standard (A, C, D, H, I, M, R, T, Z) instances” and then click “Request increase at account level” and enter in the total amount that you want the quota to be. The request is for vCPUs so for example if you have 10 students and need each to have a 4-core machine then you would want to request a limit of at least 40.

### Running Terraform in AWS CloudShell
AWS CloudShell is a browser-based shell that gives command-line access to your AWS resources in a specified AWS region.
Access CloudShell [here](https://console.aws.amazon.com/cloudshell/home).

1. Install Terraform on CloudShell by running the following commands:

	```sh
		git clone https://github.com/tfutils/tfenv.git ~/.tfenv
		mkdir ~/bin
		ln -s ~/.tfenv/bin/* ~/bin/
		tfenv use latest
	```

2. Download the Terraform code from github and change to the byodcloud directory:

	```sh
		git clone https://github.com/wintercompchem/byodcloud.git
		cd byodcloud
	```

3. Using a command line editor such as vim, edit `instance_params.auto.tfvars` to specify the desired [AWS region](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html), [instance type](https://aws.amazon.com/ec2/instance-types/), and volume size which specifies the disk size for the instance. In our example we allocate 100 GB. The maximum value per instance is 2048 GB. In AWS the disk performance is tied to the volume size. We recommend not using less than 100 GB to avoid degradation of disk performance.

4. Edit `students.auto.tfvars` to reflect your class roster.

5. Copy one of the .auto.tfvars “workload” files from the `examples` folder into the `byodcloud` directory. For example, from the `byodcloud` directory type:

	```sh
		cp examples/foleylab.auto.tfvars .
	```

6. Edit the workload file to specify the setup script which installs the desired software.

7. Terraform needs to be initialized if this is the first time you are using it. This only must be done once. This step creates a `.terraform` directory and a `.terraform.lock.hcl` file. To initialize Terraform:

	```sh
		terraform init
	```

8. When you are ready to run the lab you will provision the student instances by typing:

	```sh
		terraform apply
	```
> Note: At any point, student instances can be added or removed by adjusting the students.auto.tfvars file accordingly and re-running terraform apply.  

9. When the lab is done you must destroy all resources with the following command:

	```sh
		terraform destroy
	```
> **WARNING!** If resources are not destroyed, you will continue to get charged!!! It is a good idea to always run terraform destroy even if terraform apply gives you an error as partial resources may have been created.




   
  
