# PiSlide OS
PiSlide OS is the simplest way to get photo slideshows working on a Raspberry Pi. It supports most common image formats (JPG, PNG, WEBP, AVIF, JXL, HEIF, HEIC, SVG, BMP, TIFF, and QOI) with plans for animated GIFs and maybe even videos in the future! 

- Images are provided for all Raspberry Pis
- It has currently been tested and works well on a Pi 0, 3, and 4.
- We currently don't have all Pi revisions to test with, so if there are any issues, please let us know!

## Installation
1. Go to the [releases](https://github.com/JarvyJ/pislide-os/releases) section in GitHub
2. Download the latest release for your given Raspberry Pi
3. Flash the image using the Raspberry Pi Imager](https://www.raspberrypi.com/software/operating-systems/) (or your imager of choice)
    - Under "Operating System", choose "Use Custom" on the bottom of the list and select the image you downloaded
    - We currently do not support any customizations (ssh, wifi, etc)
4. When flashing is complete, plug the SD card in and boot it up!
    - First boot can take ~20-60s (depending on the Pi), and you will be greeted by a slideshow when completed

## Slideshow Setup
Now that the system has been setup, you can go ahead and setup your own images!
1. Unplug the Raspberry Pi
2. Insert the SD Card into your computer, a new disk called `PHOTOS` should show up
3. Create a new folder for your slideshow inside `PHOTOS`
4. Add any images you want into that folder
5. Add a `slide_settings.ini` file to that folder. You can copy the existing one from `PHOTOS/setup_instructions`. Or use the example below:
```ini
# duration to show each slide in seconds
Duration = 7

# how long the crossfade should happen
# can set to 0 to disable fade
TransitionDuration = 3.3

# set to true (without quotes) if there are sub-folders in this directory that have images to display
Recursive = false

# can be "none", "filename", or "caption" to display various text over the images
# a "caption" is simply the exact filename (including extension) with .txt on the end
# ex: The caption for bird.jpg would be in bird.jpg.txt
Display = "none"

# can be "filename", "natural", or "random"
# "natural" sorts mostly alphabetically, but tries to handle numbers correctly.
# Ex "filename": f-1.jpg, f-10.jpg, f-2.jpg
# Ex "natural": f-1.jpg, f-2.jpg, f-10.jpg
Sort = "natural"
```
6. Point the system to your new slideshow by updating `PHOTOS/active_slideshow.txt` and put in the name of the folder you would like the system to load
7. Eject the SD Card, re-insert it into your Raspberry Pi, and boot up!

If all goes well, your new slideshow should be showing up on screen with the settings specified. If not, you should get an error message in big text on screen that hopefully helps solve the issue.

## Good to know
- Most of the operating system is setup as read-only (exception is a few configs and the cached resized images)
  - SD Cards still wear down over time due to reads/writes, and a higher quality SD card should last longer
- Due to how the OS is setup, it is _generally safe_ to unplug the Pi after PiSlide OS has started
  - Ideally it would be powered off with the `shutdown` command, but there is currently no easy way to issue the command (network access should allow for it, or adding support for a shutdown button, but neither are currently implemented)
- The image viewer we use will automatically resize images based on the screen resolution. These are stored in `_cache` in `PHOTOS`. This directory gets cleared on every boot, so you shouldn't have to worry about it!

## Future Plans
- Animated GIF Support (https://github.com/JarvyJ/rayimg/issues/3)
- Optional [web interface](https://github.com/JarvyJ/pislide-api) for uploading images and managing settings
- Basic HW video support? We'll see how difficult this ends up being

## Community
Honestly I would love to see/hear about how folks use this. Feel free to post in our [GitHub Discussions](https://github.com/JarvyJ/pislide-os/discussions) section. Also for any features suggestions or questions!
