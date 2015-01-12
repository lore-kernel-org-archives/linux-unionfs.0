From: Fabian Sturm <fabian.sturm@aduu.de>
Subject: PROBLEM: Mounting multiple lowerdirs with "lowerdir=/tmp/a0,/tmp/a" returns 32
Date: Mon, 12 Jan 2015 22:59:45 +0100
Message-ID: <3603873.tCNzyKeON0@debian-desktop-mine>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx01.mykolab.com ([95.128.36.1]:58262 "EHLO mx04.mykolab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbALWAL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Jan 2015 17:00:11 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org

1. If one lowerdir-folder path includes a number, fails to mount.

3. Keywords: overlayfs, overlay

4. Linux version 3.18.0+ (user@localhost) (gcc version 4.9.1=20
(Debian 4.9.1-19) ) #4 SMP Mon Jan 12 19:31:53 CET 2015

6. The following script reproduces the behaviour on my machine:

#! /bin/bash

mkdir -p /tmp/a
mkdir -p /tmp/b0/b
mkdir -p /tmp/merged

mkdir -p /tmp/a0
mkdir -p /tmp/0a
mkdir -p /tmp/a0a

touch /tmp/a/A
touch /tmp/a0/A
touch /tmp/0a/A
touch /tmp/a0a/A

touch /tmp/b0/b/A

sudo mount -t overlay -o lowerdir=3D/tmp/a,/tmp/a0 overlay /tmp/merged
ret=3D$(echo $?)
echo $ret
if [[ "$ret" =3D=3D "0" ]]; then
    sudo umount /tmp/merged
fi

sudo mount -t overlay -o lowerdir=3D/tmp/a,/tmp/0a overlay /tmp/merged
ret=3D$(echo $?)
echo $ret
if [[ "$ret" =3D=3D "0" ]]; then
    sudo umount /tmp/merged
fi

sudo mount -t overlay -o lowerdir=3D/tmp/a,/tmp/a0a overlay /tmp/merged=

ret=3D$(echo $?)
echo $ret
if [[ "$ret" =3D=3D "0" ]]; then
    sudo umount /tmp/merged
fi

sudo mount -t overlay -o lowerdir=3D/tmp/a,/tmp/b0/b overlay /tmp/merge=
d
ret=3D$(echo $?)
echo $ret
if [[ "$ret" =3D=3D "0" ]]; then
    sudo umount /tmp/merged
fi

7. Environment

TERM=3Dxterm
LS_COLORS=3Drs=3D0:di=3D01;34:ln=3D01;36:mh=3D00:pi=3D40;33:so=3D01;35:=
do=3D01;35:bd=3D40;33;01:cd=3D40;33;01:or=3D40;31;01:su=3D37;41:sg=3D30=
;43:ca=3D30;41:tw=3D30;42:ow=3D34;42:st=3D37;44:ex=3D01;32:*.tar=3D01;3=
1:*.tgz=3D01;31:*.arc=3D01;31:*.arj=3D01;31:*.taz=3D01;31:*.lha=3D01;31=
:*.lz4=3D01;31:*.lzh=3D01;31:*.lzma=3D01;31:*.tlz=3D01;31:*.txz=3D01;31=
:*.tzo=3D01;31:*.t7z=3D01;31:*.zip=3D01;31:*.z=3D01;31:*.Z=3D01;31:*.dz=
=3D01;31:*.gz=3D01;31:*.lrz=3D01;31:*.lz=3D01;31:*.lzo=3D01;31:*.xz=3D0=
1;31:*.bz2=3D01;31:*.bz=3D01;31:*.tbz=3D01;31:*.tbz2=3D01;31:*.tz=3D01;=
31:*.deb=3D01;31:*.rpm=3D01;31:*.jar=3D01;31:*.war=3D01;31:*.ear=3D01;3=
1:*.sar=3D01;31:*.rar=3D01;31:*.alz=3D01;31:*.ace=3D01;31:*.zoo=3D01;31=
:*.cpio=3D01;31:*.7z=3D01;31:*.rz=3D01;31:*.cab=3D01;31:*.jpg=3D01;35:*=
.jpeg=3D01;35:*.gif=3D01;35:*.bmp=3D01;35:*.pbm=3D01;35:*.pgm=3D01;35:*=
.ppm=3D01;35:*.tga=3D01;35:*.xbm=3D01;35:*.xpm=3D01;35:*.tif=3D01;35:*.=
tiff=3D01;35:*.png=3D01;35:*.svg=3D01;35:*.svgz=3D01;35:*.mng=3D01;35:*=
.pcx=3D01;35:*.mov=3D01;35:*.mpg=3D01;35:*.mpeg=3D01;35:*.m2v=3D01;35:*=
.mkv=3D01;35:*.webm=3D01;35:*.ogm=3D01;35:*.mp4=3D01;35:*.m4v=3D01;35:*=
.mp4v=3D01;35:*.vob=3D01;35:*.qt=3D01;35:*.nuv=3D01;35:*.wmv=3D01;35:*.=
asf=3D01;35:*.rm=3D01;35:*.rmvb=3D01;35:*.flc=3D01;35:*.avi=3D01;35:*.f=
li=3D01;35:*.flv=3D01;35:*.gl=3D01;35:*.dl=3D01;35:*.xcf=3D01;35:*.xwd=3D=
01;35:*.yuv=3D01;35:*.cgm=3D01;35:*.emf=3D01;35:*.axv=3D01;35:*.anx=3D0=
1;35:*.ogv=3D01;35:*.ogx=3D01;35:*.aac=3D00;36:*.au=3D00;36:*.flac=3D00=
;36:*.m4a=3D00;36:*.mid=3D00;36:*.midi=3D00;36:*.mka=3D00;36:*.mp3=3D00=
;36:*.mpc=3D00;36:*.ogg=3D00;36:*.ra=3D00;36:*.wav=3D00;36:*.axa=3D00;3=
6:*.oga=3D00;36:*.spx=3D00;36:*.xspf=3D00;36:
PATH=3D/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LANG=3Dde_DE.UTF-8
PS1=3D\[\e[1;32m\]\u@\h:\w${text}$\[\e[m\]
LANGUAGE=3D
DISPLAY=3D:0
SHELL=3D/bin/bash
MAIL=3D/var/mail/root
LOGNAME=3Droot
USER=3Droot
USERNAME=3Droot
HOME=3D/root
SUDO_COMMAND=3D/usr/bin/env
SUDO_USER=3Dzeroxray
SUDO_UID=3D1000
SUDO_GID=3D1000

7.1 what does ver_linux do? made overlayfs builtin dunno wether it matt=
ers..

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux debian-desktop-mine 3.18.0+ #4 SMP Mon Jan 12 19:31:53 CET 2015 x=
86_64=20
GNU/Linux

Gnu C                  4.9.1
Gnu make               4.0
binutils               2.24.90.20141023
util-linux             scripts/ver_linux: 23: scripts/ver_linux: fdform=
at: not=20
found
mount                  debug
module-init-tools      found
Linux C Library        2.19
Dynamic linker (ldd)   2.19
Procps                 3.3.9
Kbd                    1.15.5
Sh-utils               8.23
Modules Loaded         vfat fat bnep bridge stp llc nfnetlink_queue=20
nfnetlink_log nfnetlink bluetooth cfg80211 binfmt_misc rfkill crc16=20
iptable_filter ip_tables x_tables nfsd auth_rpcgss oid_registry nfs_acl=
 nfs=20
lockd grace fscache sunrpc x86_pkg_temp_thermal intel_powerclamp intel_=
rapl=20
coretemp kvm_intel iTCO_wdt snd_hda_codec_realtek snd_hda_codec_generic=
=20
snd_hda_codec_hdmi kvm iTCO_vendor_support nouveau video ttm snd_hda_in=
tel=20
mxm_wmi xhci_pci joydev evdev drm_kms_helper snd_hda_controller snd_hda=
_codec=20
psmouse snd_hwdep serio_raw xhci_hcd drm lpc_ich mei_me snd_pcm snd_tim=
er snd=20
i2c_algo_bit i2c_i801 soundcore i2c_core mei mfd_core tpm_infineon tpm_=
tis tpm=20
wmi pcspkr shpchp processor button thermal_sys cuse fuse parport_pc ppd=
ev lp=20
parport loop autofs4 algif_skcipher af_alg dm_crypt dm_mod hid_cherry=20=

hid_generic usbhid hid sg sr_mod cdrom sd_mod crct10dif_pclmul crc32_pc=
lmul=20
crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul=20=

glue_helper ablk_helper cryptd ahci libahci libata firewire_ohci scsi_m=
od=20
firewire_core ehci_pci crc_itu_t r8169 ehci_hcd mii usbcore usb_common



If more stuff is needed tell me, but I cant see what other things would=
 have to=20
do with the problem.

The used tree comes from=20
https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overla=
yfs-
next commit 4330397e4e8a662f36d101659e2a59ce32e76ff4
