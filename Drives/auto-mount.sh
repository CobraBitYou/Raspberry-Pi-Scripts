#! /bin/bash

# This specific script can be downloaded and started with the following commands: 
# wget https://raw.githubusercontent.com/CobraBitYou/Raspberry-Pi-Scripts/main/auto-mount-drives.sh
# chmod +x auto-mount-drives.sh 
# ./auto-mount-drives.sh

# Backup the fstab file
if [ ! -f "/etc/fstab.bak" ]; then
	echo "Backing up the fstab configuration file...."
	sudo cp /etc/fstab /etc/fstab.bak
fi

# Cleanup the screen
clear

# Ask what the user wants to do
echo "Do you want to setup automatic mounting or reset fstab to the default?"
read -p "Enter your choice (setup or reset): " choice

# Cleanup the screen
clear

# Based on the answer, setup the fstab file
if [[ "$choice" = [Ss][Ee][Tt][Uu][Pp] ]]; then

	# List the drives for the user
	echo
	sudo blkid
	echo
	
	# Get the name of the drive from the user
	echo "From the above list, copy the name of the drive you want to automatically mount at boot."
	echo "The drive name is the part that is similar to /dev/sda1 in the above list."
	read -p "Enter the name of the drive you want to mount automatically at boot: " drive
	echo
	
	# Get the folder location to mount the drive/partition to
	echo "You need to specify a folder to mount the drive to at boot. (i.e. /home/bill/Music)"
	read -p "Enter the folder that you want the drive to be mounted to: " folder
	echo 
	
	# Ask what the user wants to do
	echo "Do you want to mount an entire drive or just a partition at reboot?"
	read -p "Enter your choice (drive or part): " mount
	
	# Based on the answer, setup a drive
	if [[ "$mount" = [Dd][Rr][Ii][Vv][Ee] ]]; then
	
		# Set the mount type to the drive UUID
		type="UUID"
		
		# Get the UUID of the drive
		uuid=$(blkid -s UUID -o value $drive)
	fi
	
	# Based on the answer, setup a partition
	if [[ "$mount" = [Pp][Aa][Rr][Tt] ]]; then
	
		# Set the mount type to the partition UUID
		type="PARTUUID"
		
		# Get the UUID of the drive
		uuid=$(blkid -s PARTUUID -o value $drive)
	fi
	
	# Get the drive filesystem type
	format=$(blkid -s TYPE -o value $drive)
	echo 
	
	# Edit the fstab file
	echo "Editing the fstab configuration file...."
	echo "The following has been added to the /etc/fstab file:"
	echo ""$type"="$uuid" "$folder" "$format" defaults,nofail 0 0" | sudo tee -a /etc/fstab

fi

# Based on the answer, reset the fstab file
if [[ "$choice" = [Rr][Ee][Ss][Ee][Tt] ]]; then
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
		sleep 2
		exit
	fi
fi

exit
