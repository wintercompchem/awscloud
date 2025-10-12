## _Student Instructions for Running Example Amber Molecular Dynamics Lab on a Linux Instance in the Amazon Web Services Cloud_

1.	Open a browser and navigate to [https://aws.amazon.com/console/](https://aws.amazon.com/console/)
	1. Log in with the Account ID and credentials (username and password) provided by your instructor
	2. Click EC2 or type EC2 into the search bar
	3. Click Instances (running)
	4. Find your Instance (labeled with your username) and click on the Instance ID value
	5. Click Connect
	6. Click Session Manager
	7. Click Connect to open a command line terminal in a new browser tab

2.	In the terminal the default shell is the Bourne shell. We recommend switching to the Bash shell by typing `bash` on the command line. Then type `cd` to navigate to the home directory.

3.	To illustrate running Amber we will walk through Part 1 of the lab "Comparing Classical Water Models Using Molecular Dynamics to Find Bulk Properties" as described in this [article](https://pubs.acs.org/doi/full/10.1021/acs.jchemed.7b00385):

	Laura J. Kinnaman, Rachel M. Roller, and Carrie S. Miller
_Journal of Chemical Education_ **2018** _95_ (5), 888-894.
DOI: 10.1021/acs.jchemed.7b00385


	3.1. First we need to upload the necessary files to our instance (as provided in Supporting Information from the above article). Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://52.14.208.231`. Sign in with the same username and password you used to sign into the AWS console. Click the "Upload" button, browse to the appropriate directory and select the following files:
	
	- 1\_min.in
	- 2\_defrost.in
	- 3\_equil.in
	- 4\_md.in
	- ice.pdb
	- process\_mdout.pl
	
	
	Move these files to the home directory:
	
	```sh
		mv /var/www/html/files/* .
	``` 

	3.2. Prepare the system with `tleap` by importing a box of SPCE water:
	
	To start tleap:

	```sh
 		tleap -s -f /opt/ambertools25/dat/leap/cmd/leaprc.water.spce
	```
	Run the following commands in tleap
	
	```sh
		ice=loadpdb ice.pdb
	```
	
	```sh
		solvatebox ice SPCBOX 0 100.0
	```
	
	```sh
		saveamberparm ice wat_spce.prmtop wat_spce.inpcrd
	```
	
	```sh
		quit
	```
	
	3.3. Minimize the energy of the system:
	
	```sh
		sander -O -i 1_min.in -o wat_spce_min.out -p wat_spce.prmtop -c wat_spce.inpcrd -r wat_spce_min.rst
	```
	
	3.4. Defrost (melt) the system:
	
	```sh
		sander -O -i 2_defrost.in -o wat_spce_defrost.out -p wat_spce.prmtop -c wat_spce_min.rst -r wat_spce_defrost.rst
	```
	
	3.5. Equilibrate the system:
	
	```sh
		sander -O -i 3_equil.in -o wat_spce_equil.out -p wat_spce.prmtop -c wat_spce_defrost.rst -r wat_spce_equil.rst
	```
	
	3.6. Process output of equilibration:
	
	```sh
		mkdir EQUIL
	```
	
	```sh
		cp process_mdout.pl EQUIL/
	```
	
	```sh
		cd EQUIL
	```
	
	```sh
		perl process_mdout.pl ../wat_spce_equil.out
	```
	
	```sh
		cd ..
	```
	
	3.7. Run the production molecular dynamics:
	
	```sh
		sander -O -i 4_md.in -o wat_spce_md.out -p wat_spce.prmtop -c wat_spce_equil.rst -r wat_spce_md.rst -x water_spce.mdcrd
	```
	
	3.8. Data analysis:
	
	Diffusion coefficient (creates output file diff\_spce):
	
	```sh
		cpptraj wat_spce.prmtop diffusion_spce.in
	```
	
	Radial distribution function (creates output file rdf\_spce):
	
	```sh
		cpptraj wat_spce.prmtop rdf_spce.in
	```
	
	
	
4. To download the data output files we need to move them into another directory:

	```sh
 		mv wat_spce_equil.out diff_spce rdf_spce /var/www/html/files
	```

5.	Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://52.14.208.231`. Sign in with the same username and password you used to sign into the AWS console. Right click on each file and save it to disk.




   
  

