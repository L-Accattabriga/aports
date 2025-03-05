#!/bin/sh -e

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
	echo "usage: $0 hostname"
	exit 1
fi

cleanup() {
	rm -rf "$tmp"
}

makefile() {
	OWNER="$1"
	PERMS="$2"
	FILENAME="$3"
	cat > "$FILENAME"
	chown "$OWNER" "$FILENAME"
	chmod "$PERMS" "$FILENAME"
}

rc_add() {
	mkdir -p "$tmp"/etc/runlevels/"$2"
	ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

mkdir -p "$tmp"/etc
makefile root:root 0644 "$tmp"/etc/hostname <<EOF
$HOSTNAME
EOF

mkdir -p "$tmp"/etc/conf.d
makefile root:root 0644 "$tmp"/etc/conf.d/consolefont <<EOF

# The consolefont service is not activated by default. If you need to
# use it, you should run "rc-update add consolefont boot" as root.
#
# consolefont specifies the default font that you'd like Linux to use on the
# console.  You can find a good selection of fonts in /usr/share/consolefonts;
consolefont="gr928-8x16-thin.psfu.gz"

# consoletranslation is the charset map file to use.  Leave commented to use
# the default one.  Have a look in /usr/share/consoletrans for a selection of
# map files you can use.
#consoletranslation="8859-1_to_uni.trans"
EOF

mkdir -p "$tmp"/etc/network
makefile root:root 0644 "$tmp"/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet dhcp
EOF

mkdir -p "$tmp"/etc/apk
makefile root:root 0644 "$tmp"/etc/apk/world <<EOF
alpine-base
apk-cron
busybox 
chrony 
dhcpcd 
doas 
e2fsprogs
kbd-bkeymaps 
openntpd 
openssl 
openssh
tzdata 
wget 
iw 
wpa_supplicant 
vim 
tmux 
kbd
EOF

rc_add devfs sysinit
rc_add dmesg sysinit
rc_add mdev sysinit
rc_add hwdrivers sysinit
rc_add modloop sysinit

rc_add chrony boot
rc_add dhcpcd boot
rc_add doas boot
rc_add e2fsprogs boot
rc_add kbd-bkeymaps boot
rc_add openntpd boot
rc_add openssl boot
rc_add openssh boot
rc_add tzdata boot
rc_add wget boot
rc_add iw boot
rc_add wpa_supplicant boot
rc_add vim
rc_add tmux
rc_add kbd

rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

tar -c -C "$tmp" etc | gzip -9n > $HOSTNAME.apkovl.tar.gz
