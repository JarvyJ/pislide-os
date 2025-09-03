################################################################################
#
# lua-vips
#
################################################################################

LUA_VIPS_VERSION = 1.1-12
LUA_VIPS_NAME_UPSTREAM = lua-vips
LUA_VIPS_LICENSE = MIT
LUA_VIPS_SUBDIR = lua-vips
LUA_VIPS_LICENSE_FILES = $(LUA_VIPS_SUBDIR)/LICENSE

$(eval $(luarocks-package))