## _Student Instructions for Running Example GAMESS Calculation on a Linux Instance in the Amazon Web Services Cloud_

1.	Open a browser and navigate to [https://aws.amazon.com/console/](https://aws.amazon.com/console/)
	1. Log in with the Account ID and credentials (username and password) provided by your instructor
	2. Click EC2 or type EC2 into the search bar
	3. Click Instances (running)
	4. Find your Instance (labeled with your username) and click on the Instance ID value
	5. Click Connect
	6. Click Session Manager
	7. Click Connect to open a command line terminal in a new browser tab

2.	In the terminal the default shell is the Bourne shell. We recommend switching to the Bash shell by typing `bash` on the command line. Then type `cd` to navigate to the home directory.

3.	To illustrate running [GAMESS](https://www.msg.chem.iastate.edu/GAMESS/) we will do a simple geometry optimization of ethane.

	3.1. First we need to upload the necessary input files to our instance (as provided [here](https://github.com/wintercompchem/byodcloud/tree/main/examples/gamess) in our Github repository). Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://12.34.56.78`. Sign in with the same username and password you used to sign into the AWS console. Click the "Upload" button, browse to the appropriate directory and select the following file:
	
	- ethane.inp
	
	Copy the input file to the home directory:
	
	>Note: The uploaded files must be copied (not moved) into the home directory to ensure file ownership and permissions are correct.

	
	```sh
	cp /var/www/html/files/ethane.inp .
	``` 

	3.2. Run the calculation in GAMESS:
	
	```sh
 	./gamess/rungms ethane.inp >& ethane.log &
	```
		
	3.3. To download the data output files (if desired) we need to copy them into the `/var/www/html/files` directory:

	```sh
 	cp ethane.log /var/www/html/files
	```

4.	Download output files. Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://12.34.56.78`. Sign in with the same username and password you used to sign into the AWS console. Right click on each file and save it to disk.




   
  

