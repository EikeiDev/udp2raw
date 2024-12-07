include $(TOPDIR)/rules.mk

PKG_NAME:=udp2raw
PKG_VERSION:=2024.12.07
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/wangyu-/udp2raw.git
PKG_SOURCE_VERSION:=HEAD
PKG_MIRROR_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Your Name <your.email@example.com>

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/udp2raw
  SECTION:=net
  CATEGORY:=Network
  TITLE:=udp2raw tunnel
  URL:=https://github.com/wangyu-/udp2raw
  DEPENDS:=+libpthread +librt
endef

define Package/udp2raw/description
  udp2raw is a tunnel which turns UDP traffic into encrypted FakeTCP/UDP/ICMP traffic. Supports multiple instances.
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC=$(TARGET_CXX) \
		CFLAGS="$(TARGET_CFLAGS) -std=c++11 -Wall -Wextra -Wno-unused-variable -Wno-unused-parameter -Wno-missing-field-initializers" \
		LDFLAGS="$(TARGET_LDFLAGS) -lpthread -lrt -static" \
		PLATFORM=$(ARCH) \
		udp2raw
endef

define Package/udp2raw/conffiles
/etc/config/udp2raw
endef

define Package/udp2raw/install
	# 安装二进制文件
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/udp2raw $(1)/usr/bin/udp2raw

	# 安装配置文件
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/udp2raw $(1)/etc/config/udp2raw

	# 安装启动脚本
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/udp2raw $(1)/etc/init.d/udp2raw
endef

$(eval $(call BuildPackage,udp2raw))
