################################################################################
#
# libraylib
#
################################################################################

LIBRAYLIB_VERSION = 5.5
LIBRAYLIB_SITE = $(call github,raysan5,raylib,$(LIBRAYLIB_VERSION))
LIBRAYLIB_INSTALL_STAGING = YES
LIBFOO_INSTALL_TARGET = NO
LIBRAYLIB_LICENSE = Zlib
LIBRAYLIB_LICENSE_FILES = LICENSE

LIBRAYLIB_DEPENDENCIES += libdrm libegl libgles libgbm
LIBRAYLIB_CONF_OPTS += -DPLATFORM=DRM -DBUILD_SHARED_LIBS=ON


$(eval $(cmake-package))