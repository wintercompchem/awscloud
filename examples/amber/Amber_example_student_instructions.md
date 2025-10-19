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


	3.1. First we need to upload the necessary input files to our instance (as provided in Supporting Information from the above article). Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://12.34.56.78`. Sign in with the same username and password you used to sign into the AWS console. Click the "Upload" button, browse to the appropriate directory and select the following files:
	
	- 1\_min.in
	- 2\_defrost.in
	- 3\_equil.in
	- 4\_md.in
	- ice.pdb
	- process\_mdout.pl
	- diffusion.spce.in
	- rdf.spce.in
	
	
	Copy these files to the home directory:
	
	>Note: The uploaded files must be copied (not moved) into the home directory to ensure file ownership and permissions are correct.

	
	```sh
	cp /var/www/html/files/* .
	``` 

	Since we are using a newer version of Amber the water-water cutoff needs to be adjusted accordingly. Adjust the cutoff in two of the input files with the following command:
	
	```sh
	sed -i 's/9.287/8.287/g' 3_equil.in 4_md.in
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
	
	3.6. Process output of equilibration (creates multiple output files in directory `EQUIL`):
	
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
	
	To download the data output files we need to copy them into the `/var/www/html/files` directory. (See Step 4 for out how download to local computer.)

	```sh
 	cp summary.PRESS summary.TEMP summary.DENSITY /var/www/html/files
	```
	Move back up into the home directory:
	
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
	cpptraj wat_spce.prmtop diffusion.spce.in
	```
	
	Radial distribution function (creates output file rdf\_spce):
	
	```sh
	cpptraj wat_spce.prmtop rdf.spce.in
	```
	To download the data output files we need to copy them into the `/var/www/html/files` directory:

	```sh
 	cp diff_spce rdf_spce /var/www/html/files
	```

4.	Download output files. Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://12.34.56.78`. Sign in with the same username and password you used to sign into the AWS console. Right click on each file and save it to disk.




   
  

