#!/bin/sh

IMAGE=$1

if [ -z "$IMAGE" ]; then
printf "ERROR: Enter name of Image\n"
printf "Usage: gen-iso.sh <IMAGE>"
exit 1
fi
xorriso -as mkisofs \
  -o /home/build/iso/$IMAGE.iso \
  -isohybrid-mbr image-b5c981919b5d9558925571863a2f705c0e6f0bca-x86_64-standard/boot/syslinux/isohdpfx.bin \
  -c boot/syslinux/boot.cat \
  -b boot/syslinux/isolinux.bin \
     -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e boot/grub/efi.img \
     -no-emul-boot -isohybrid-gpt-basdat \
  -isohybrid-apm-hfsplus \
  -V "ALPINE_CUSTOM" \
  -J -R -l \
  image-b5c981919b5d9558925571863a2f705c0e6f0bca-x86_64-standard/
