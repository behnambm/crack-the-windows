#!/usr/bin/env bash

path_to_sam="Windows/System32/config/SAM"

G="\033[92m"
R="\033[31m"
D="\033[39m"

if [[ ! $(command -v chntpw) ]]; then
	echo -e "$R you need to install 'chntpw' package first. (apt install chntpw) $D"
	exit 127
fi

# don't continue the script if there are no NTFS partitions
if [[ ! $(lsblk -f | grep ntfs) ]]; then
	echo -e "$R" "\bNo NTFS partitions found." " $D" 
	exit
fi

# get list of all NTFS file systems.
for i in $(lsblk -if | grep ntfs | grep --invert-match 'Reserved' | awk -F '-' '{print $2}' | awk '{print $1}' | xargs -L 1 printf '/dev/%s\n'); do
	# create a mount point in /tmp/mnt
	if [[ ! -d /tmp/mnt ]]; then
		mkdir -p /tmp/mnt
	else
		# if the mount point is already mounted, unmout it. 
		if [[ $(fuser --verbose /tmp/mnt/ | grep -q root) ]]; then
			umount /tmp/mnt
		fi
	fi

	echo Trying: "$i"

	mount "$i" /tmp/mnt/ -o rw
	if [[ ! -e /tmp/mnt/$path_to_sam ]]; then
		echo -e "$R SAM file not found in: $i$D"
		cd "$HOME" || exit
		umount /tmp/mnt
	else
		echo -e "$G" "\bfound SAM file in: $i$D"

		if [[ ! $1 ]]; then
			echo -e "$G----------------------------------------------------------------------$D"
			chntpw -l /tmp/mnt/$path_to_sam | grep '|'
			echo -e "$G----------------------------------------------------------------------$D"
		else
			if ! chntpw -l /tmp/mnt/$path_to_sam | grep -q "$1"; then
				echo -e "$R\n" "\bCannot find user. $D"
			else
				chntpw -u "$1" /tmp/mnt/$path_to_sam
				
				echo -e "$G" "\bPassword cleared successfully.$D"
			fi
		fi

		cd "$HOME" || exit
		umount /tmp/mnt
		break
	fi

done
