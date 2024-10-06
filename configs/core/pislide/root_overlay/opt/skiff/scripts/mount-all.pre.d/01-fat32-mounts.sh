#!/bin/bash
set -a

SD_CARD=/dev/mmcblk0
PHOTO_DEV_DEVICE=${SD_CARD}p4
PHOTOS_DEVICE="LABEL=PHOTOS"
PHOTOS_MNT=/mnt/photos

first_boot=false

if ! findfs $PHOTOS_DEVICE; then
  echo "Creating the PHOTOS device"
  parted -a optimal $SD_CARD -- mkpart primary fat32 500MB "-1s"
  partprobe $SD_CARD
  sleep 2

  echo "Creating the PHOTOS filesystem"
  mkfs.vfat -n PHOTOS -F 32 $PHOTO_DEV_DEVICE
  partprobe $SD_CARD
  sleep 2

  first_boot=true
fi

# Mount photos device, if applicable.
mkdir -p $PHOTOS_MNT
if ! mountpoint -q ${PHOTOS_MNT}; then
    attempts=0
    while ! mountpoint -q ${PHOTOS_MNT}; do
        echo "Mounting ${PHOTOS_DEVICE} to ${PHOTOS_MNT}"
        mount $PHOTOS_DEVICE $PHOTOS_MNT || echo "Failed to mount ${PHOTOS_DEVICE}"
        attempts=$((attempts + 1))
        if [ $attempts -gt 60 ]; then
            echo "Waited too long for ${PHOTOS_DEVICE}, continuing without."
            break
        fi
        echo "Will retry mounting ${PHOTOS_DEVICE}..."
        sleep 1
    done


    # clear cache if it exists
    if [ -d "${PHOTOS_MNT}/_cache" ]; then
        rm -rf ${PHOTOS_MNT}/_cache
    fi
fi

if [ "$first_boot" = true ] ; then
    echo 'Copying initial images'
    echo "setup_instructions" > $PHOTOS_MNT/active_slideshow.txt
    cp -r /opt/pislide-os/setup_instructions $PHOTOS_MNT/
fi


export DISABLE_RESIZE_PERSIST="true"
