#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# unlock 1200Mhz
sed -i \
-e 's/^@@.*@@ static struct rt2880_pmx_group mt7621_pi/@@ -113,49 +113,93 @@ static struct rt2880_pmx_group mt7621_pi/' \
-e 's/^+\tu32 xtal_clk, cpu_clk, bus_clk;/+\tu32 xtal_clk, cpu_clk, bus_clk, i;/' \
-e '/^+\t\tpll = rt_memc_r32(MEMC_REG_CPU_PLL);/a\
+\t\tpll &= ~(0x7ff);\
+\t\tpll |=  (0x3B2);\
+\t\trt_memc_w32(pll,MEMC_REG_CPU_PLL);\
+\t\tfor(i=0;i<1024;i++);' \
target/linux/ramips/patches-4.14/102-mt7621-fix-cpu-clk-add-clkdev.patch
