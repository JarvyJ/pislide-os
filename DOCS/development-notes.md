# Development Notes
pislide-os is based on [SkiffOS](https://github.com/skiffos/SkiffOS) which uses [Buildroot](https://buildroot.org/), so it's good to read their README to understand some of the basics on how the OS is built.

## Modifications
There are a couple of patches/changes that needed to be made to get everything built and running

### libdrm changes
This modification feels a little too hacky. We might look into better/different ways to include libdrm in the future. Had to modify the header files to point at slightly different directions:
- skiffos/workspaces/default/host/arm-buildroot-linux-gnueabihf/sysroot/usr/include/xf86drmMode.h
- skiffos/workspaces/default/host/arm-buildroot-linux-gnueabihf/sysroot/usr/include/xf86drm.h

Patch file: `pislide-os/configs/core/pislide/buildroot_patches/libdrm/0002-include-additional-headers.patch`

### raylib-go change
Had to remove the hard coded path (buildroot didn't like it): `-I/usr/lib/libdrm from raylib-go` in `vendor/github.com/gen2brain/raylib-go/raylib/cgo_linux_drm.go`

Patch file: `pislide-os/configs/core/pislide/buildroot_ext/package/rayimg/0001-remove-hardcoded-libdrm.patch`

### libvips
The version of libvips in buildroot is a little out of date and didn't have JPEGXL support and is still using the old build system. I've included a modified version with JPEGXL support (assuming libjxl is specified) that uses meson. This should probably be upstreamed at some point.

libvips folder: `pislide-os/configs/core/pislide/buildroot_ext/package/libvips-meson`

## Vendoring

###  Handling CGO dependencies correctly...
For rayimg buildroot doesn't seem to play nice with the go.mod/go.sum files. We think it's because `go mod vendor` doesn't pull in all the .c/.h files. So we're using [`vend`](github.com/nomad-software/vend) to bundle in [rayimg](https://github.com/JarvyJ/rayimg) make that happen. It may also have been an artifact of how it was initially implemented when developing locally. Should maybe revisit at some point

```bash
go get github.com/nomad-software/vend
go install github.com/nomad-software/vend
vend # (instead of go mod vendor)
```

## Cleaning for rebuild
To remove libraries to rebuild:
```
rm -rf ./skiffos/workspaces/default/build/[library name]
```

To remove rayimg to rebuild:
```
rm -rf ./skiffos/workspaces/default/build/lua-rayimg-[version]
rm -rf ./skiffos/buildroot/dl/lua-rayimg
```

The big one:
`make clean` - will remove everything. I had to do this when i switched from rpi-userland to the mesa driver for gbm.h to be found.

## Building
```
export SKIFF_CONFIG=pi/3,core/pislide
make configure # munges all the config together and spits out a conf file. Can check to see if things are going to be added to the image
make compile # compiles all the bits and bobs
```

## Deploying
Subsequent deploys are fast, since you can push the new image to the SD card, reboot, and be good to go. Check out the SkiffOS deployment [section](https://github.com/skiffos/skiffos?tab=readme-ov-file#flashing-the-sd-card) for more information.
