PKG_NAME="n1-boot"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain u-boot-tools-aml"
PKG_TOOLCHAIN="manual"

make_target() {
  for src in $PKG_DIR/instboot/*autoscript.src ; do
    $TOOLCHAIN/bin/mkimage -A $TARGET_KERNEL_ARCH -O linux -T script -C none -d "$src" "$(basename $src .src)" > /dev/null
  done
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader
  cp -a $PKG_BUILD/*autoscript $INSTALL/usr/share/bootloader/
  cp -a $PKG_DIR/instboot/uEnv.ini $INSTALL/usr/share/bootloader/
  for src in $INSTALL/usr/share/bootloader/*.ini ; do
      sed -e "s/@BOOT_LABEL@/$DISTRO_BOOTLABEL/g" \
          -e "s/@DISK_LABEL@/$DISTRO_DISKLABEL/g" \
          -i "$src"

      sed -e "s/@DTB_NAME@/$DEFAULT_DTB_NAME/g" \
          -i "$src"
  done
  
  # Always install the update script
  cp -a $PKG_DIR/instboot/update.sh $INSTALL/usr/share/bootloader/
  find_file_path bootloader/update.sh && sed -e "s/@KERNEL_NAME@/$KERNEL_NAME/g" \
      -e "s/@LEGACY_KERNEL_NAME@/$LEGACY_KERNEL_NAME/g" \
      -e "s/@LEGACY_DTB_NAME@/$LEGACY_DTB_NAME/g" \
      -i $INSTALL/usr/share/bootloader/update.sh
      
}
