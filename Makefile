include $(TOPDIR)/rules.mk

PKG_NAME:=udp2raw
PKG_VERSION:=20230206.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/wangyu-/udp2raw.git
PKG_SOURCE_VERSION:=4623f878e08bc8f6f9253d4670569724d4c0a1b7
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Your Name <your.email@example.com>

include $(INCLUDE_DIR)/package.mk

define Package/udp2raw
	SECTION:=net
	CATEGORY:=Network
	TITLE:=udp2raw tunnel
	URL:=https://github.com/wangyu-/udp2raw
	DEPENDS:=+libstdcpp +libpthread +librt
endef

define Package/udp2raw/description
	udp2raw is a tunnel which turns UDP traffic into encrypted FakeTCP/UDP/ICMP traffic.
	Supports multiple instances.
endef
	
define Build/Configure
	$(call Build/Configure/Default)
	$(SED) 's/cc_local[[:space:]]*=.*/cc_local=$(TARGET_CXX)/' \
		-e 's/\\".*shell git rev-parse HEAD.*\\"/\\"$(PKG_SOURCE_VERSION)\\"/' \
		-e 's/cc_amd64[[:space:]]*=.*/cc_amd64=$(TARGET_CXX)/' \
		$(PKG_BUILD_DIR)/makefile
endef

define Build/Compile
	$(if $(CONFIG_TARGET_x86_64),\
		$(MAKE) -C $(PKG_BUILD_DIR) amd64_hw_aes,\
		$(MAKE) -C $(PKG_BUILD_DIR)\
	)
endef

define Package/udp2raw/conffiles
/etc/config/udp2raw
endef

define Package/udp2raw/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/udp2raw $(1)/usr/bin/udp2raw
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/udp2raw $(1)/etc/config/udp2raw
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/udp2raw $(1)/etc/init.d/udp2raw
endef

$(eval $(call BuildPackage,udp2raw))