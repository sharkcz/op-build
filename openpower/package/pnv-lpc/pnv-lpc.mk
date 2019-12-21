################################################################################
#
# pnv-lpc - builds lpc utility from skiboot source
#
################################################################################

PNV_LPC_VERSION = v6.5
PNV_LPC_SITE = $(call github,open-power,skiboot,$(PNV_LPC_VERSION))

PNV_LPC_INSTALL_TARGET = YES

PNV_LPC_LICENSE_FILES = LICENCE

PNV_LPC_MAKE_OPTS += CC="$(TARGET_CC)" LD="$(TARGET_LD)" \
		     AS="$(TARGET_AS)" AR="$(TARGET_AR)" NM="$(TARGET_NM)" \
		     OBJCOPY="$(TARGET_OBJCOPY)" OBJDUMP="$(TARGET_OBJDUMP)" \
		     SIZE="$(TARGET_CROSS)size"

PNV_LPC_MAKE_ENV = \
	SKIBOOT_VERSION=$(PNV_LPC_VERSION) \
	       $(MAKE1) $(PNV_LPC_MAKE_OPTS) CROSS_COMPILE=$(TARGET_CROSS)


define PNV_LPC_BUILD_CMDS
	PREFIX=$(STAGING_DIR)/usr $(PNV_LPC_MAKE_ENV) -C $(@D)/external/lpc
endef

define PNV_LPC_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/external/lpc/lpc $(TARGET_DIR)/sbin/pnv-lpc
endef

define PNV_LPC_POST_INSTALL
	$(INSTALL) -D -m 0755 $(BR2_EXTERNAL_OP_BUILD_PATH)/package/pnv-lpc/S99signal-linux-complete \
	        $(TARGET_DIR)/etc/init.d/
endef

PNV_LPC_POST_INSTALL_TARGET_HOOKS += PNV_LPC_POST_INSTALL

$(eval $(generic-package))
