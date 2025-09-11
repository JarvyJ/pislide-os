################################################################################
#
# lua-lpath
#
################################################################################

LUA_LPATH_VERSION = 0.4.0-1
LUA_LPATH_NAME_UPSTREAM = lpath
LUA_LPATH_LICENSE = MIT
LUA_LPATH_SUBDIR = lpath
LUA_LPATH_LICENSE_FILES = $(LUA_LPATH_SUBDIR)/LICENSE

$(eval $(luarocks-package))