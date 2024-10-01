# pislide-os
pislide-os is a Raspberry Pi operating system designed for easily displaying photos on a Raspberry Pi. It's currently in a very early state and we've _just barely_ got everything working together. It can one day be used to create digital photo frames, digital signage, or just constantly playing a gifs fun.

It has currently been tested and works well on a Pi 3.

## Installation
TODO: write instructions on flashing to SD Card
<!---

1. Go to the [releases](https://github.com/JarvyJ/pislide-os/releases) section in GitHub
2. Download the latest release for your given Raspberry Pi
3. Flash the image using the Raspberry Pi Imager](https://www.raspberrypi.com/software/operating-systems/) (or your imager of choice)
  - Under "Operating System", choose "Use Custom" on the bottom of the list and select the image you downloaded
  - We currently do not support any customizations (ssh, wifi, etc)
4. When flashing is complete, plug the SD card in and boot it up!
  - First boot can take 30-60s, and you will be greeted by a slideshow when completed
-->

## Slideshow Setup
TODO: include instructions on setting up new slideshows

## Good to know
- Most of the operating system is setup as read-only (exception is a few configs)
  - SD Cards still wear down over time due to reads/writes, and a higher quality SD card should last longer
- Due to how the OS is setup, it is _generally safe_ to unplug the Pi after PiSlide OS has started
  - Ideally it would be powered off with the `shutdown` command, but there is currently no easy way to issue the command (network access should allow for it, or adding a shutdown button, but neither are currently implemented)
