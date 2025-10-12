## _Student Instructions for Running GROMACS Lysozyme in Water Tutorial on a Linux Instance in the Amazon Web Services Cloud_

1.	Open a browser and navigate to [https://aws.amazon.com/console/](https://aws.amazon.com/console/)
	1. Log in with the Account ID and credentials (username and password) provided by your instructor
	2. Click EC2 or type EC2 into the search bar
	3. Click Instances (running)
	4. Find your Instance (labeled with your username) and click on the Instance ID value
	5. Click Connect
	6. Click Session Manager
	7. Click Connect to open a command line terminal in a new browser tab

2.	In the terminal the default shell is the Bourne shell. We recommend switching to the Bash shell by typing `bash` on the command line. Then type `cd` to navigate to the home directory.

3.	Begin the GROMACS Lysozyme in Water tutorial adapted from [http://www.mdtutorials.com/gmx/lysozyme/index.html](http://www.mdtutorials.com/gmx/lysozyme/index.html). For more details on each step please refer to the original tutorial.

	3.1. Make a directory to hold the input files:

	```sh
 		mkdir inputs
	```
	
	3.2. Download the PDB file along with other necessary input files:

	```sh
		wget https://files.rcsb.org/download/1AKI.pdb 
	```
	
	```sh
		wget https://mackerell.umaryland.edu/download.php?filename=CHARMM_ff_params_files/charmm36-jul2022.ff.tgz -O charmm36-jul2022.ff.tgz 
	```

	```sh
		wget http://www.mdtutorials.com/gmx/lysozyme/Files/ions.mdp -O inputs/ions.mdp
	```
	
	```sh
		wget http://www.mdtutorials.com/gmx/lysozyme/Files/minim.mdp -O inputs/minim.mdp
	```
	
	```sh
		wget http://www.mdtutorials.com/gmx/lysozyme/Files/nvt.mdp -O inputs/nvt.mdp
	```
	
	```sh
		wget http://www.mdtutorials.com/gmx/lysozyme/Files/npt.mdp -O inputs/npt.mdp
	```
	
	```sh
		wget http://www.mdtutorials.com/gmx/lysozyme/Files/md.mdp -O inputs/md.mdp
	```
	
	3.3. Unzip the forcefield file:
	
	```sh
		tar xzvf charmm36-jul2022.ff.tgz
	```

	3.4. Strip out the crystal waters from the PDB file:

	```sh
		grep -v HOH 1AKI.pdb > 1AKI_clean.pdb 
	```
	
	3.5. Have GROMACS process the PDB file and solvate protein with waters:
	
	Choose option 1 for `pdb2gmx` command:
	
	```sh
		gmx pdb2gmx -f 1AKI_clean.pdb -o 1AKI_processed.gro -water tip3p
	```
	
	```sh
		gmx editconf -f 1AKI_processed.gro -o 1AKI_newbox.gro -c -d 1.2 -bt cubic
	```
	
	```sh
		gmx solvate -cp 1AKI_newbox.gro -cs spc216.gro -o 1AKI_solv.gro -p topol.top
	```
	
	3.6. Add ions to the system:
	
	```sh
		gmx grompp -f inputs/ions.mdp -c 1AKI_solv.gro -p topol.top -o ions.tpr
	```
	
	Select Group 13 for the `genion` command:
	
	```sh
		gmx genion -s ions.tpr -o 1AKI_solv_ions.gro -p topol.top -pname NA -nname CL -neutral
	```
	
	3.7. Do an energy minimization run and save the potential energy as a function of time in `potential.xvg`. For `gmx energy` choose the potential energy option by typing "11 0".
	
	```sh
		gmx grompp -f inputs/minim.mdp -c 1AKI_solv_ions.gro -p topol.top -o em.tpr
	```
	
	```sh
		gmx mdrun -v -deffnm em
	```
	
	```sh
		gmx energy -f em.edr -o potential.xvg
	```
	
	3.8. Do an equilibration run in the NVT ensemble and save the temperature as a function of time in `temperature.xvg`. For `gmx energy` choose the temperature option by typing "16 0".
	
	```sh
		gmx grompp -f inputs/nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
	```
	
	```sh
		gmx mdrun -deffnm nvt
	```
	
	```sh
		gmx energy -f nvt.edr -o temperature.xvg
	```

	3.9. Do an equilibration run in the NPT ensemble and save the pressure (option 17) and density (option 23) as a function of time using `gmx energy`.
	
	```sh
		gmx grompp -f inputs/npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
	```
	
	```sh
		gmx mdrun -deffnm npt
	```
	
	```sh
		gmx energy -f npt.edr -o pressure.xvg
	```
	
	```sh
		gmx energy -f npt.edr -o density.xvg
	```
	
	3.10. Run the 10 nanosecond production MD trajectory:
	
	```sh
		gmx grompp -f inputs/md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_10.tpr
	```
	
	```sh
		gmx mdrun -deffnm md_0_10
	```
	
	3.11. Run the following commands to complete the data analysis:
	
	Use `trjconv` to account for any periodicity in the system. Select Group 1 for centering and Group 0 for output:
	
	```sh
		gmx trjconv -s md_0_10.tpr -f md_0_10.xtc -o md_0_10_noPBC.xtc -pbc mol -center
	```
	
	We want the Root-Mean-Square Deviation (RMSD) of the atom positions relative to the structure in the minimized, equilibrated system. Choose 4 ("Backbone") for both the least-squares fit and the group for RMSD calculation:
	
	```sh	
		gmx rms -s md_0_10.tpr -f md_0_10_noPBC.xtc -o rmsd.xvg -tu ns
	```

	Calculate RMSD relative to the crystal structure for comparison:

	```sh
		gmx rms -s em.tpr -f md_0_10_noPBC.xtc -o rmsd_xtal.xvg -tu ns
	```
	
	Calculate the radius of gyration of the protein:

	```sh
		gmx gyrate -s md_0_10.tpr -f md_0_10_noPBC.xtc -o gyrate.xvg -sel Protein -tu ns
	```

	Invoke the Dictionary of Secondary Structure of Proteins (DSSP) algorithm to assign secondary structure to each residue in the protein:

	```sh
		gmx dssp -s md_0_10.tpr -f md_0_10_noPBC.xtc -tu ns -o dssp.dat -num dssp_num.xvg
	```

	Compute the number of hydrogen bonds within the backbone of the protein. Select the "MainChain+H" group (7) for both selections when prompted:

	```sh
		gmx hbond -s md_0_10.tpr -f md_0_10_noPBC.xtc -tu ns -num hbnum_mainchain.xvg
	```

	Compute hydrogen bonds formed among sidechain atoms. Select the "SideChain" group (8) for both selections:

	```sh
		gmx hbond -s md_0_10.tpr -f md_0_10_noPBC.xtc -tu ns -num hbnum_sidechain.xvg
	```

	Finally, compute hydrogen bonds between the protein and water. Select Protein (1) and Water (12) as the two groups:

	```sh
		gmx hbond -s md_0_10.tpr -f md_0_10_noPBC.xtc -tu ns -num hbnum_prot_wat.xvg
	```

4. To download the data output files we need to move them into another directory:

	```sh
 		mv *.xvg /var/www/html/files
	```

5.	Go back to the other browser tab with the AWS console and copy the IP address of your instance to the clipboard by clicking on the copy icon. Open a new browser tab and click on the search bar. Type `http://` then paste the IP address and hit enter. For example, it would look like: `http://52.14.208.231`. Sign in with the same username and password you used to sign into the AWS console. Right click on each file and save it to disk.




   
  

