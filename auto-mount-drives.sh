#! /bin/bash

# This script was created by CobraBitYou and is hosted on the GitHub repository https://github.com/CobraBitYou/Raspberry-Pi-Scripts
# This specific script can be downloaded with the following command: wget https://raw.githubusercontent.com/CobraBitYou/Raspberry-Pi-Scripts/main/auto-mount-drives.sh
# Run the script by running chmod +x auto-mount-drives.sh AND ./auto-mount-drives.sh

# Backup the fstab file
if [ ! -f "/etc/fstab.bak" ]; then
	echo "Backing up the fstab configuration file...."
	sudo cp /etc/fstab /etc/fstab.bak
fi

# Cleanup the screen
clear

# Ask what the user wants to do
echo "Do you want to setup automatic mounting or reset fstab to the default?"
read -p "Enter your option (setup or reset): " option

# Cleanup the screen
clear

# Based on the answer, setup the fstab file
if [[ "$option" = [Ss][Ee][Tt][Uu][Pp] ]]; then

	# Ask what the user wants to do
	echo "Do you want to mount an entire drive or just a partition at reboot?"
	read -p "Enter your option (drive or part): " mount

	# Based on the answer, setup a drive
	if [[ "$mount" = [Dd][Rr][Ii][Vv][Ee] ]]; then

		# Cleanup the screen
		clear
		
		# List the drives for the user
		echo
		sudo blkid | grep "sda"
		echo
		
		# Get the UUID of the drive from the user
		echo "From the above list, copy the UUID of the drive you want to automatically mount at boot."
		echo "Note: Use the UUID not the PARTUUID or this will not work as intended."
		read -p "Enter the UUID of the drive you want to mount automatically at boot: " uuid
		echo
		
		# Get the folder location to mount the drive/partition to
		echo "You need to specify a folder to mount the drive to at boot. (i.e. /home/bill/Music)"
		read -p "Enter the folder that you want the drive to be mounted to: " uuidfolder
		echo 
		
		# Edit the fstab file
		echo "Editing the fstab configuration file...."
		echo "The following has been added to the /etc/fstab file:"
		echo "UUID="$uuid" "$uuidfolder" ntfs defaults,nofail 0 0" | sudo tee -a /etc/fstab
	fi

	# Based on the answer, setup a partition
	if [[ "$mount" = [Pp][Aa][Rr][Tt] ]]; then
		
		# Cleanup the screen
		clear
		
		# List the drives for the user
		echo
		sudo blkid | grep "sda"
		echo
		
		# Get the PARTUUID of the drive from the user
		echo "From the above list, copy the PARTUUID of the partition you want to automatically mount at boot."
		echo "Note: Use the PARTUUID not the UUID or this will not work as intended."
		read -p "Enter the PARTUUID of the partition you want to mount automatically at boot: " partuuid
		echo
		
		# Get the folder location to mount the drive/partition to
		echo "You need to specify a folder to mount the partition to at boot. (i.e. /home/bill/Music)"
		read -p "Enter the folder that you want the partition to be mounted to: " partfolder
		echo 
		
		# Edit the fstab file
		echo "Editing the fstab configuration file...."
		echo "The following has been added to the /etc/fstab file:"
		echo "PARTUUID="$partuuid" "$partfolder" ntfs defaults,nofail 0 0" | sudo tee -a /etc/fstab
	fi
	
fi

# Based on the answer, reset the fstab file
if [[ "$option" = [Rr][Ee][Ss][Ee][Tt] ]]; then
	read -p "Are you sure you want to reset your fstab configuration? This cannot be undone. (Y/n) " reset

	# If user wants to reset
	if [[ "$reset" = [Yy] ]]; then
		echo "Resetting fstab to the default in 5 seconds (use Ctrl + C to stop)...."
		sleep 5
		sudo cp /etc/fstab.bak /etc/fstab 
		echo "The fstab configuration has been reset."
	fi
	
	# If user does not want to reset
	if [[ "$reset" = [Nn] ]]; then
		echo "The fstab configuration will not be reset. Exiting...."
		exit
	fi
fi

exit
