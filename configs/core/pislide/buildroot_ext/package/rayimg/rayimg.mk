RAYIMG_VERSION = 0.0.0
RAYIMG_SITE = https://github.com/JarvyJ/rayimg
RAYIMG_SITE_METHOD = git
RAYIMG_GOMOD = github.com/JarvyJ/rayimg
RAYIMG_BUILD_TARGETS += cmd/rayimg
RAYIMG_INSTALL_BINS += rayimg
RAYIMG_DEPENDENCIES += libgbm libdrm
RAYIMG_TAGS += drm,noaudio
$(eval $(golang-package))
