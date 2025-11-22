#!/bin/bash
# firstboot-prepare-usb-root.sh
# Detect an attached USB block device (non-mmcard), copy rootfs there,
# update /boot/cmdline.txt to use the USB root PARTUUID, and disable the service.
#
# Usage: put this file in /usr/local/bin/ and enable the systemd service
# systemd unit name: firstboot-prepare-us.service (see repo's systemd/)

set -euo pipefail
LOG=/var/log/firstboot-prepare-usb.log
exec > >(tee -a "${LOG}") 2>&1

echo "Starting firstboot USB root preparation: $(date)"

# find candidate block devices: /dev/sdX with at least 2 partitions or ext4
# skip devices that look like mmc (mmcblk) or loop devices
candidates=()
while read -r dev; do
  # ignore mmc and loop
  [[ "$dev" =~ mmcblk ]] && continue
  [[ "$dev" =~ loop ]] && continue
  candidates+=("$dev")
done < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk" {print "/dev/"$1}')

if [ ${#candidates[@]} -eq 0 ]; then
  echo "No USB block device candidates found. Exiting."
  exit 0
fi

echo "Candidates: ${candidates[*]}"

# Choose first candidate with a partition 2 (common layout: p1=boot p2=root) or any ext4 partition
choose_partition() {
  dev="$1"
  # try common partitions e.g. /dev/sda2 or /dev/sda1
  if [ -b "${dev}2" ]; then
    echo "${dev}2"
    return
  fi
  # fallback: search for ext4 partition on device
  for p in $(ls ${dev}?* 2>/dev/null || true); do
    # only partitions (not device itself)
    if [ -b "$p" ]; then
      fstype=$(blkid -o value -s TYPE "$p" || true)
      if [ "$fstype" = "ext4" ] || [ "$fstype" = "ext3" ] || [ "$fstype" = "ext2" ]; then
        echo "$p"
        return
      fi
    fi
  done
  return 1
}

usb_root_part=""
for dev in "${candidates[@]}"; do
  p=$(choose_partition "$dev" || true)
  if [ -n "$p" ]; then
    usb_root_part="$p"
    break
  fi
done

if [ -z "$usb_root_part" ]; then
  echo "No suitable ext4 partition found on USB candidate devices. Exiting."
  exit 0
fi

echo "Selected USB root partition: $usb_root_part"

# mount target
MNT=/mnt/usb-root
mkdir -p "$MNT"
mount "$usb_root_part" "$MNT"
if [ $? -ne 0 ]; then
  echo "Failed mounting $usb_root_part"
  exit 1
fi

# Basic safety check: ensure we're not copying onto the same root
CURRENT_ROOT_DEVICE=$(findmnt -n -o SOURCE /)
if [ "$CURRENT_ROOT_DEVICE" = "$usb_root_part" ] || [ "$CURRENT_ROOT_DEVICE" = "${usb_root_part%[0-9]}" ]; then
  echo "USB root equals current root: nothing to do."
  umount "$MNT" || true
  exit 0
fi

# Rsync root (exclude mounts and /boot)
echo "Copying root filesystem to USB (this may take a while)..."
rsync -aAX --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/boot/*"} / "$MNT"

# Get PARTUUID for the USB partition
PARTUUID=$(blkid -s PARTUUID -o value "$usb_root_part" || true)
if [ -z "$PARTUUID" ]; then
  echo "Could not determine PARTUUID; falling back to using device node in cmdline (less portable)"
fi

# Update /boot/cmdline.txt to point root to the USB partition
CMDLINE=/boot/cmdline.txt
if [ -f "$CMDLINE" ]; then
  # read into a variable
  OLD=$(cat "$CMDLINE")
  # replace root=... token
  if [ -n "$PARTUUID" ]; then
    NEW=$(echo "$OLD" | sed -E "s/root=([^ ]+)/root=PARTUUID=${PARTUUID}/")
  else
    # use device node (e.g., root=/dev/sda2)
    NEW=$(echo "$OLD" | sed -E "s/root=([^ ]+)/root=${usb_root_part}/")
  fi
  echo "Old cmdline: $OLD"
  echo "New cmdline: $NEW"
  echo "$NEW" > "$CMDLINE"
else
  echo "/boot/cmdline.txt not found; cannot update boot root. Exiting."
  umount "$MNT"
  exit 1
fi

# Optionally update /etc/fstab on the target filesystem so / mounts correctly by PARTUUID
if [ -f "$MNT/etc/fstab" ]; then
  if [ -n "$PARTUUID" ]; then
    cat >> "$MNT/etc/fstab" <<EOF

# Added by firstboot-prepare-usb: verify root entry on first boot
# If necessary, update the '/' entry to use PARTUUID=$PARTUUID
EOF
  else
    echo "# Please check /etc/fstab and update root device if necessary" >> "$MNT/etc/fstab"
  fi
fi

# Create a marker file so this script won't run again when the service stays enabled
touch /etc/firstboot-prepare-usb.done

sync
umount "$MNT"

echo "USB root setup finished. The system will use the USB partition as root after next reboot." 
