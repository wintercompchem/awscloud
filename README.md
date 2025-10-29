# _Using Infrastructure as Code to Provision Cloud Resources for Computational Labs_



Content may be periodically updated to fix bugs and make enhancements.

## Abstract
In this work we provide an infrastructure as code (IaC) template for running computational labs in the cloud in an effort to improve access to computational resources for both students and instructors. Specifically, we provide a Terraform code that provisions resources in Amazon Web Services (AWS). The instructor can create a virtual
machine (an "instance") per student and have the necessary software automatically installed upon instance creation using a customizable script. Students can access the instance using a command line interface using AWS Console within any standard web browser on any device. Files can be uploaded (downloaded) to (from) the instance by the student via a web browser. We outline example workloads including open-source molecular dynamics and quantum chemistry programs. The Terraform code, including
associated documentation and example workload files, can be obtained through GitHub [(https://github.com/wintercompchem/awscloud)](https://github.com/wintercompchem/awscloud).

## We include the following documentation for the code:

- Detailed instructions for instructors on how to use the code can be found [here](https://github.com/wintercompchem/awscloud/blob/main/documentation/instructions_for_use_instructor.md).
- A set of instructions for how a student can access their instance can be found [here](https://github.com/wintercompchem/awscloud/blob/main/documentation/instructions_for_use_student.md).
- An introduction to some key aspects of Terraform can be found [here](https://github.com/wintercompchem/awscloud/blob/main/documentation/intro_to_terraform.md).
- Several example applications can be found in the [Examples](https://github.com/wintercompchem/awscloud/tree/main/examples) folder.


## Authors

[Nicolas D. Winter](mailto:nwinter@dom.edu)<br>
Department of Physical Sciences<br>
Dominican University<br>
River Forest, Illinois, 60305

Alexandra R. Richards<br>
Private Consultant for Dominican University<br>
Forest Park, Illinois, 60130

## Cite us!
If you use our Terraform code in your teaching/research, please cite us!


