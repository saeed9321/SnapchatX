ARCHS := arm64 arm64e
TARGET = iphone::14.4:14.4
THEOS_DEVICE_IP = 127.0.0.1
THEOS_DEVICE_PORT = 2222
GO_EASY_ON_ME = 1
FINALPACKAGE = 1
DEBUG = 0

INSTALL_TARGET_PROCESSES = Snapchat

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SnapchatX

$(TWEAK_NAME)_FILES = Tweak.x $(shell find Snapchat -name '*.x*') $(shell find Snapchat -name '*.m*')
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_LIBRARIES = SMHookMemory

include $(THEOS_MAKE_PATH)/tweak.mk

# Thanks to opa334 for this trick to make this dylib runs before all tweaks
internal-stage::
	$(ECHO_NOTHING)mv "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/SnapchatX.dylib" "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/   	SnapchatX.dylib" $(ECHO_END)
	$(ECHO_NOTHING)mv "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/SnapchatX.plist" "$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/   	SnapchatX.plist" $(ECHO_END)
