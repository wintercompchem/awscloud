## _Student Instructions for Accessing a Linux Instance in the Amazon Web Services Cloud_

1.	Open a browser and navigate to [https://aws.amazon.com/console/](https://aws.amazon.com/console/)
	1. Log in with the Account ID and credentials (username and password) provided by your instructor
	2. Click EC2 or type EC2 into the search bar
	3. Click Instances (running)
	4. Find your Instance (labeled with your username) and click on the Instance ID value
	5. Click Connect
	6. Click Session Manager
	7. Click Connect to open a command line terminal in a new browser tab

2.	In the terminal the default shell is the Bourne shell. We recommend switching to the Bash shell by typing `bash` on the command line. Then type `cd` to navigate to the home directory.

3.	At this point students would follow the lab-specific instructions to generate data.

4.	To download data output files we need to move them into another directory. To move a file to the directory located at /var/www/html/files, type the following in the command line shell:

	```sh
 		mv <filename> /var/www/html/files
	```

5.	Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://12.34.56.78`. Sign in with the same username and password you used to sign into the AWS console. Right click on each file and save it to disk.




   
  
