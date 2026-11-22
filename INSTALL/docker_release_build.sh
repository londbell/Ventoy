#!/bin/sh

VTOY_PATH=$PWD/..

date +"%Y/%m/%d %H:%M:%S"
echo downloading environment ...

wget -P $VTOY_PATH/DOC/ https://github.com/ventoy/vtoytoolchain/releases/download/1.0/dietlibc-0.34.tar.xz
wget -P $VTOY_PATH/DOC/ https://github.com/ventoy/vtoytoolchain/releases/download/1.0/musl-1.2.1.tar.gz
wget -P $VTOY_PATH/GRUB2/ https://github.com/ventoy/vtoytoolchain/releases/download/1.0/grub-2.04.tar.xz
wget -O $VTOY_PATH/EDK2/edk2-edk2-stable201911.zip https://codeload.github.com/tianocore/edk2/zip/edk2-stable201911
wget -P /opt/ https://github.com/ventoy/vtoytoolchain/releases/download/1.0/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz
wget -P /opt/ https://github.com/ventoy/vtoytoolchain/releases/download/1.0/aarch64--uclibc--stable-2020.08-1.tar.bz2
wget -P /opt/ https://github.com/ventoy/vtoytoolchain/releases/download/1.0/mips-loongson-gcc7.3-2019.06-29-linux-gnu.tar.gz

wget -O $VTOY_PATH/ExFAT/exfat-1.3.0.zip  https://codeload.github.com/relan/exfat/zip/v1.3.0
wget -O $VTOY_PATH/ExFAT/libfuse-fuse-2.9.9.zip  https://codeload.github.com/libfuse/libfuse/zip/fuse-2.9.9


date +"%Y/%m/%d %H:%M:%S"
echo downloading environment finish...



date +"%Y/%m/%d %H:%M:%S"
echo downloading upstream pre-built binrary files ...

#7za.exe 
echo "download 7za.exe"
mkdir -p $VTOY_PATH/INSTALL/ventoy/7z/64  $VTOY_PATH/INSTALL/ventoy/7z/32
wget -O $VTOY_PATH/INSTALL/ventoy/7z/64/7za  https://github.com/ventoy/7zip/releases/download/ventoy-7zip-2605/7za-x64.exe
wget -O $VTOY_PATH/INSTALL/ventoy/7z/32/7za  https://github.com/ventoy/7zip/releases/download/ventoy-7zip-2605/7za-x86.exe
wget -O /tmp/7z-checksum  https://github.com/ventoy/7zip/releases/download/ventoy-7zip-2605/SHA256SUMS
sed "s#7za-x64.exe#$VTOY_PATH/INSTALL/ventoy/7z/64/7za#g"  -i /tmp/7z-checksum
sed "s#7za-x86.exe#$VTOY_PATH/INSTALL/ventoy/7z/32/7za#g"  -i /tmp/7z-checksum
sha256sum -c /tmp/7z-checksum || exit 1
echo "7za checksum success"
xz --check=crc32 $VTOY_PATH/INSTALL/ventoy/7z/64/7za
xz --check=crc32 $VTOY_PATH/INSTALL/ventoy/7z/32/7za


#



echo downloading upstream pre-built binrary files finish...


# 版本号加自己的 -X 后缀（幂等：先去掉已有的 -X 再加，重复运行不会变成 -X-X）
sed -i -E 's/^(set VENTOY_VERSION=")([^"]*)-X"/\1\2"/' ./grub/grub.cfg
sed -i -E 's/^(set VENTOY_VERSION=")([^"]*)"/\1\2-X"/' ./grub/grub.cfg
grep -n 'set VENTOY_VERSION' ./grub/grub.cfg

# 不带 CI 参数：版本号保持上面设置的值，不会被覆盖成日期串
sh all_in_one.sh
