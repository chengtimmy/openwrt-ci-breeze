#!/bin/bash
set -e

# 修改默认IP
sed -i 's/192.168.1.1/10.1.0.1/g' package/base-files/files/bin/config_generate

# 避免目录重复导致克隆失败
rm -rf package/luci-app-mosdns package/mosdns package/geo2txt
rm -rf feeds/luci/applications/luci-app-mosdns feeds/packages/net/mosdns

# 仅引入 MosDNS 相关源码
git clone --depth=1 -b v5 --single-branch --filter=blob:none --sparse https://github.com/sbwml/luci-app-mosdns.git mosdns-src
(
  cd mosdns-src
  git sparse-checkout set luci-app-mosdns mosdns geo2txt
)
mv -f mosdns-src/luci-app-mosdns mosdns-src/mosdns mosdns-src/geo2txt package/
rm -rf mosdns-src
