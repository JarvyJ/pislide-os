# pislide-os
pislide-os is a Raspberry Pi operating system designed for easily displaying photos on a Raspberry Pi. It's currently in a very early state and we've _just barely_ got everything working together. It can one day be used to create digital photo frames, digital signage, or just constantly playing a gifs fun.

It has currently been tested and works well on a Pi 3.

## Installation
1. Go to the [releases](https://github.com/JarvyJ/pislide-os/releases) section in GitHub
2. Download the latest release for your given Raspberry Pi
3. Flash the image using the Raspberry Pi Imager](https://www.raspberrypi.com/software/operating-systems/) (or your imager of choice)
  - Under "Operating System", choose "Use Custom" on the bottom of the list and select the image you downloaded
  - We currently do not support any customizations (ssh, wifi, etc)
4. When flashing is complete, plug the SD card in and boot it up!
  - First boot can take 30-60s, and you will be greeted by a slideshow when completed

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
TransitionDuration = 3

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
- Most of the operating system is setup as read-only (exception is a few configs)
  - SD Cards still wear down over time due to reads/writes, and a higher quality SD card should last longer
- Due to how the OS is setup, it is _generally safe_ to unplug the Pi after PiSlide OS has started
  - Ideally it would be powered off with the `shutdown` command, but there is currently no easy way to issue the command (network access should allow for it, or adding support for a shutdown button, but neither are currently implemented)
- The image viewer we use will automatically resize images based on the screen resolution. You may see a folder called `_cache` in `PHOTOS`, that is where these are stored. This directory gets cleared on every boot, so you shouldn't have to worry about it!