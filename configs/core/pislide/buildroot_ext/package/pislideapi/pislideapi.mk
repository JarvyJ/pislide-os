PISLIDEAPI_VERSION = 0.0.0
PISLIDEAPI_SITE = https://github.com/JarvyJ/pislide-api
PISLIDEAPI_SITE_METHOD = git
PISLIDEAPI_GOMOD = github.com/JarvyJ/pislide-api
PISLIDEAPI_BUILD_TARGETS += cmd/pislide-api
PISLIDEAPI_INSTALL_BINS += pislide-api

define PISLIDEAPI_FRONTEND_INSTALL
	mkdir -p $(TARGET_DIR)/opt/pislide/frontend
	cp -r $(@D)/frontend/build/* $(TARGET_DIR)/opt/pislide/frontend
endef

PISLIDEAPI_PRE_INSTALL_TARGET_HOOKS += PISLIDEAPI_FRONTEND_INSTALL

$(eval $(golang-package))
