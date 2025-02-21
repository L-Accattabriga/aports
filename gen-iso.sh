#!/bin/sh

IMAGE=$1

xorriso -as mkisofs \
  -o /home/build/iso/$IMAGE.iso \
  -isohybrid-mbr syslinux_b1db609243c8a56d3a840a0750c5d8482011bb60/boot/syslinux/isohdpfx.bin \
  -c image-b5c981919b5d9558925571863a2f705c0e6f0bca-x86_64-standard/boot/syslinux/boot.cat \
  -b image-b5c981919b5d9558925571863a2f705c0e6f0bca-x86_64-standard/boot/syslinux/isolinux.bin \
     -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot -e image-b5c981919b5d9558925571863a2f705c0e6f0bca-x86_64-standard/efi/boot/bootx64.efi \
     -no-emul-boot -isohybrid-gpt-basdat \
  -isohybrid-apm-hfsplus \
  -V "ALPINE_CUSTOM" \
  -J -R -l \
  image-b5c981919b5d9558925571863a2f705c0e6f0bca-x86_64-standard/
