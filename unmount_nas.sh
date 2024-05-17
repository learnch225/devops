# Find the NAS entry in /etc/fstab
NAS_ENTRY=$(grep -e "^${NAS_URL_V}" -e "^${NAS_V_DRIVE}" /etc/fstab)

# If NAS entry exists, unmount and remove from /etc/fstab
if [ -n "$NAS_ENTRY" ]; then
    NAS_MOUNT_POINT=$(echo "$NAS_ENTRY" | awk '{print $2}')
    sudo umount "$NAS_MOUNT_POINT"
    if [ $? -eq 0 ]; then
        echo "NAS mounted at $NAS_MOUNT_POINT has been successfully unmounted."
        sudo sed -i "/^${NAS_URL_V}\|^${NAS_V_DRIVE}/d" /etc/fstab
        echo "NAS entry removed from /etc/fstab."
    else
        echo "Error: Failed to unmount NAS mounted at $NAS_MOUNT_POINT."
    fi
else
    echo "NAS entry not found in /etc/fstab."
fi
