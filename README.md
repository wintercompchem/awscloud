# _Using Cloud Resources to Address Challenges Associated with BYOD in Computational Labs_

Content may be periodically updated to fix bugs and make enhancements.

## Abstract
In this work we provide a template for running computational labs in the cloud in an effort to improve access to computational resources for both students and instructors. Specifically, we provide a Terraform code that provisions resources in Amazon Web Services (AWS). The instructor can spin up an instance per student and have the necessary software automatically installed upon instance creation using a customizable script. Students can access the instance using a command line interface within any standard web browser on any device. Any generated data files can also be downloaded via the same web browser. We outline example workloads including open-source molecular dynamics and quantum chemistry programs.

## We include the following documentation for the code:

- Detailed instructions for instructors on how to use the code can be found [here](documentation/instructions_for_use_instructor.md).
- A set of instructions for how a student can access their instance can be found [here](documentation/instructions_for_use_student.md).
- An introduction to some key aspects of Terraform can be found [here](documentation/intro_to_terraform.md).


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


