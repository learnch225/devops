#!/bin/bash
exec >> /tmp/day1/unmount.log
source /etc/environment

USER=$1
GROUP_V=$2
GROUP_O=$3
NAS_URL_V=$4
NAS_URL_O=$5

# Function to remove NAS entry from /etc/fstab
remove_fstab_entry() {
    NAS_URL=$1
    sed -i "\|$NAS_URL|d" /etc/fstab
}

# Function to unmount NAS
unmount_nas() {
    MOUNT_POINT=$1
    if mountpoint -q $MOUNT_POINT; then
        sudo umount $MOUNT_POINT
        echo "$MOUNT_POINT has been unmounted."
    else
        echo "$MOUNT_POINT is not mounted."
    fi
}

# Unmount primary NAS and remove fstab entry
MOUNT_POINT_V=$(echo $NAS_URL_V | awk -F'/' '{print $NF}')
MOUNT_POINT_V="/mnt/$MOUNT_POINT_V"

unmount_nas $MOUNT_POINT_V
remove_fstab_entry $NAS_URL_V

# Optionally handle the secondary NAS if specified
if [ "$NAS_URL_O" != "$NAS_URL_V" ]; then
    MOUNT_POINT_O=$(echo $NAS_URL_O | awk -F'/' '{print $NF}')
    MOUNT_POINT_O="/mnt/$MOUNT_POINT_O"
    
    unmount_nas $MOUNT_POINT_O
    remove_fstab_entry $NAS_URL_O
fi

# Remove NAS credentials file
if [ -f /etc/NAS_credentials ]; then
    sudo rm /etc/NAS_credentials
    echo "NAS credentials file has been removed."
else
    echo "NAS credentials file does not exist."
fi

# Remove user if needed
if id -u $USER >/dev/null 2>&1; then
    sudo userdel $USER
    echo "User $USER has been deleted."
else
    echo "User $USER does not exist."
fi

# Remove groups if needed
if grep -q "^$GROUP_V:" /etc/group; then
    sudo groupdel $GROUP_V
    echo "Group $GROUP_V has been deleted."
else
    echo "Group $GROUP_V does not exist."
fi

if [ "$GROUP_O" != "$GROUP_V" ] && grep -q "^$GROUP_O:" /etc/group; then
    sudo groupdel $GROUP_O
    echo "Group $GROUP_O has been deleted."
else
    echo "Group $GROUP_O does not exist."
fi
