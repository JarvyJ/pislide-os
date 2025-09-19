################################################################################
#
# rayimg
#
################################################################################

LUA_RAYIMG_VERSION = 1.0.0-1
LUA_RAYIMG_NAME_UPSTREAM = rayimg
LUA_RAYIMG_SITE = https://github.com/JarvyJ/rayimg/releases/download/1.0.0
LUA_RAYIMG_LICENSE = AGPL
LUA_RAYIMG_SUBDIR = rayimg
LUA_RAYIMG_LICENSE_FILES = $(LUA_RAYIMG_SUBDIR)/LICENSE
LUA_RAYIMG_INSTALL_TARGET_CMDS = y

define LUA_RAYIMG_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(LUA_RAYIMG_SUBDIR)/static/rayimg $(TARGET_DIR)/usr/bin/rayimg
endef

$(eval $(luarocks-package))
