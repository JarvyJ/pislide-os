################################################################################
#
# rayimg
#
################################################################################

LUA_RAYIMG_VERSION = 1.0.0-1
LUA_RAYIMG_NAME_UPSTREAM = rayimg
LUA_RAYIMG_SITE = https://github.com/JarvyJ/rayimg/releases/download/1.0.0-pre
LUA_RAYIMG_LICENSE = AGPL
LUA_RAYIMG_SUBDIR = rayimg
LUA_RAYIMG_LICENSE_FILES = $(LUA_RAYIMG_SUBDIR)/LICENSE

$(eval $(luarocks-package))