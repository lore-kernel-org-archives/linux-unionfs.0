From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: ovl: mounting two times the same mount overlayfs will not list any
 directory entry anymore
Date: Tue, 12 Sep 2017 11:38:53 +0200
Message-ID: <20170912113853.05b08228@localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/AAac3f_AWsg4s5jigrHWmyg"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:34396 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751326AbdILJjA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2017 05:39:00 -0400
Received: by mail-wr0-f169.google.com with SMTP id v109so19778551wrc.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2017 02:39:00 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>

--MP_/AAac3f_AWsg4s5jigrHWmyg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

Maybe this is another overlayfs error, only for v4.13; it works well in
previous version 4.12.

When mounting two times the same mount, overlayfs will not list any
directory entry anymore.

Attached is the script log,

Look for the line:
+lnet-remaster:361:_chroot_mount: mount -o
bind /tmp/ /tmp/live-net-remaster-Fg9o5x/chroot/tmp/

Comments:

/tmp/ is already mounted in /tmp/live-net-remaster-Fg9o5x/chroot/tmp/

after mounting /tmp another time in the same location all overlay
entries in the chroot directory disappear,
no errors are listed in the log file, dmesg or journalctl.

Thanks,

Jordi Pujol i Palomer

--MP_/AAac3f_AWsg4s5jigrHWmyg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=lnet-remaster-_chroot_mount.txt

+lnet-remaster:353:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 24
drwxr-xr-x  2 root root 2398 ago 26 09:40 bin
drwxr-xr-x  2 root root  148 set 12 10:44 boot
drwxr-xr-x  2 root root    3 set 12 10:40 dev
drwxr-xr-x  1 root root 4096 set 12 11:06 etc
drwxr-xr-x  1 root root 4096 set 12 11:06 home
lrwxrwxrwx  1 root root   33 jun 11  2016 initrd.img -> /boot/initrd.img-4.6.2-1-lnet-686
drwxr-xr-x 15 root root  399 ago  8 08:08 lib
drwxr-xr-x  2 root root    3 set 24  2009 media
drwxr-xr-x  2 root root    3 nov 26  2014 mnt
drwxr-xr-x  2 root root    3 set  4  2009 opt
dr-xr-xr-x  2 root root    3 set 12 10:40 proc
drwxr-xr-x  1 root root 4096 set 12 11:06 root
drwxr-xr-x  1 root root 4096 set 12 11:06 run
drwxr-xr-x  2 root root 3304 ago 26 09:46 sbin
drwxr-xr-x  2 root root    3 set  4  2009 srv
dr-xr-xr-x 13 root root    0 set 12 11:06 sys
drwxrwxrwt 11 root root  260 set 12 11:07 tmp
drwxr-xr-x  1 root root 4096 des 19  2011 usr
drwxr-xr-x  1 root root 4096 jun 30  2011 var
lrwxrwxrwx  1 root root   29 jun 11  2016 vmlinuz -> boot/vmlinuz-4.6.2-1-lnet-686
+lnet-remaster:354:_chroot_mount: mount -o bind /dev/ /tmp/live-net-remaster-Fg9o5x/chroot/dev
+lnet-remaster:355:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 24
drwxr-xr-x  2 root root 2398 ago 26 09:40 bin
drwxr-xr-x  2 root root  148 set 12 10:44 boot
drwxr-xr-x 19 root root 3420 set 12 11:06 dev
drwxr-xr-x  1 root root 4096 set 12 11:06 etc
drwxr-xr-x  1 root root 4096 set 12 11:06 home
lrwxrwxrwx  1 root root   33 jun 11  2016 initrd.img -> /boot/initrd.img-4.6.2-1-lnet-686
drwxr-xr-x 15 root root  399 ago  8 08:08 lib
drwxr-xr-x  2 root root    3 set 24  2009 media
drwxr-xr-x  2 root root    3 nov 26  2014 mnt
drwxr-xr-x  2 root root    3 set  4  2009 opt
dr-xr-xr-x  2 root root    3 set 12 10:40 proc
drwxr-xr-x  1 root root 4096 set 12 11:06 root
drwxr-xr-x  1 root root 4096 set 12 11:06 run
drwxr-xr-x  2 root root 3304 ago 26 09:46 sbin
drwxr-xr-x  2 root root    3 set  4  2009 srv
dr-xr-xr-x 13 root root    0 set 12 11:06 sys
drwxrwxrwt 11 root root  260 set 12 11:07 tmp
drwxr-xr-x  1 root root 4096 des 19  2011 usr
drwxr-xr-x  1 root root 4096 jun 30  2011 var
lrwxrwxrwx  1 root root   29 jun 11  2016 vmlinuz -> boot/vmlinuz-4.6.2-1-lnet-686
+lnet-remaster:356:_chroot_mount: mount -o bind /dev/pts /tmp/live-net-remaster-Fg9o5x/chroot/dev/pts
+lnet-remaster:357:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 24
drwxr-xr-x  2 root root 2398 ago 26 09:40 bin
drwxr-xr-x  2 root root  148 set 12 10:44 boot
drwxr-xr-x 19 root root 3420 set 12 11:06 dev
drwxr-xr-x  1 root root 4096 set 12 11:06 etc
drwxr-xr-x  1 root root 4096 set 12 11:06 home
lrwxrwxrwx  1 root root   33 jun 11  2016 initrd.img -> /boot/initrd.img-4.6.2-1-lnet-686
drwxr-xr-x 15 root root  399 ago  8 08:08 lib
drwxr-xr-x  2 root root    3 set 24  2009 media
drwxr-xr-x  2 root root    3 nov 26  2014 mnt
drwxr-xr-x  2 root root    3 set  4  2009 opt
dr-xr-xr-x  2 root root    3 set 12 10:40 proc
drwxr-xr-x  1 root root 4096 set 12 11:06 root
drwxr-xr-x  1 root root 4096 set 12 11:06 run
drwxr-xr-x  2 root root 3304 ago 26 09:46 sbin
drwxr-xr-x  2 root root    3 set  4  2009 srv
dr-xr-xr-x 13 root root    0 set 12 11:06 sys
drwxrwxrwt 11 root root  260 set 12 11:07 tmp
drwxr-xr-x  1 root root 4096 des 19  2011 usr
drwxr-xr-x  1 root root 4096 jun 30  2011 var
lrwxrwxrwx  1 root root   29 jun 11  2016 vmlinuz -> boot/vmlinuz-4.6.2-1-lnet-686
+lnet-remaster:358:_chroot_mount: mount -o bind /sys /tmp/live-net-remaster-Fg9o5x/chroot/sys
+lnet-remaster:359:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 24
drwxr-xr-x  2 root root 2398 ago 26 09:40 bin
drwxr-xr-x  2 root root  148 set 12 10:44 boot
drwxr-xr-x 19 root root 3420 set 12 11:06 dev
drwxr-xr-x  1 root root 4096 set 12 11:06 etc
drwxr-xr-x  1 root root 4096 set 12 11:06 home
lrwxrwxrwx  1 root root   33 jun 11  2016 initrd.img -> /boot/initrd.img-4.6.2-1-lnet-686
drwxr-xr-x 15 root root  399 ago  8 08:08 lib
drwxr-xr-x  2 root root    3 set 24  2009 media
drwxr-xr-x  2 root root    3 nov 26  2014 mnt
drwxr-xr-x  2 root root    3 set  4  2009 opt
dr-xr-xr-x  2 root root    3 set 12 10:40 proc
drwxr-xr-x  1 root root 4096 set 12 11:06 root
drwxr-xr-x  1 root root 4096 set 12 11:06 run
drwxr-xr-x  2 root root 3304 ago 26 09:46 sbin
drwxr-xr-x  2 root root    3 set  4  2009 srv
dr-xr-xr-x 13 root root    0 set 12 11:06 sys
drwxrwxrwt 11 root root  260 set 12 11:07 tmp
drwxr-xr-x  1 root root 4096 des 19  2011 usr
drwxr-xr-x  1 root root 4096 jun 30  2011 var
lrwxrwxrwx  1 root root   29 jun 11  2016 vmlinuz -> boot/vmlinuz-4.6.2-1-lnet-686
+lnet-remaster:360:_chroot_mount: mount-list
sysfs	/sys	sysfs	nodev,noexec,nosuid,relatime,rw	sysfs	0:17
proc	/proc	proc	nodev,noexec,nosuid,relatime,rw	proc	0:5
udev	/dev	devtmpfs	mode=755,nosuid,nr_inodes=978526,relatime,rw,size=3914104k	udev	0:6
devpts	/dev/pts	devpts	gid=5,mode=620,noexec,nosuid,ptmxmode=000,relatime,rw	devpts	0:18
tmpfs	/run	tmpfs	mode=755,noexec,nosuid,relatime,rw,size=786156k	tmpfs	0:19
tmpfs	/lnet	tmpfs	mode=755,relatime,rw,size=7861540k	tmpfs	0:20
/dev/sda1	/lnet/image	ext2	errors=continue,noacl,noatime,nouser_xattr,ro	/dev/sda1	8:1
/lnet/image/LneTXFCE64/00filesystem.squashfs	/lnet/00filesystem.squashfs	squashfs	noatime,ro,loop=/dev/loop0	/dev/loop0	7:0
/lnet/image/LneTXFCE64/10interfaces.squashfs	/lnet/10interfaces.squashfs	squashfs	noatime,ro,loop=/dev/loop1	/dev/loop1	7:1
/dev/sda2	/lnet/cowroot	ext4	data=ordered,relatime,rw	/dev/sda2	8:2
overlay	/	overlay	index=off,lowerdir=/lnet/00filesystem.squashfs:/lnet/10interfaces.squashfs,relatime,rw,upperdir=/lnet/cowroot/LneTXFCECOW/upper,workdir=/lnet/cowroot/LneTXFCECOW/work	overlay	0:21
tmpfs	/tmp	tmpfs	nodev,nosuid,relatime,rw,size=7861540k,mode=1777	tmpfs	0:22
tmpfs	/var/log	tmpfs	mode=755,nosuid,relatime,rw,size=7861540k	tmpfs	0:23
tmpfs	/var/tmp	tmpfs	nodev,nosuid,relatime,rw,size=7861540k,mode=1777	tmpfs	0:24
securityfs	/sys/kernel/security	securityfs	nodev,noexec,nosuid,relatime,rw	securityfs	0:7
tmpfs	/dev/shm	tmpfs	nodev,nosuid,rw,mode=1777	tmpfs	0:25
tmpfs	/run/lock	tmpfs	nodev,noexec,nosuid,relatime,rw,size=5120k,mode=1777	tmpfs	0:26
tmpfs	/sys/fs/cgroup	tmpfs	mode=755,nodev,noexec,nosuid,ro	tmpfs	0:27
cgroup	/sys/fs/cgroup/unified	cgroup2	nodev,noexec,nosuid,relatime,rw	cgroup	0:28
cgroup	/sys/fs/cgroup/systemd	cgroup	name=systemd,nodev,noexec,nosuid,relatime,rw,xattr	cgroup	0:29
pstore	/sys/fs/pstore	pstore	nodev,noexec,nosuid,relatime,rw	pstore	0:30
cgroup	/sys/fs/cgroup/cpu	cgroup	cpu,nodev,noexec,nosuid,relatime,rw	cgroup	0:31
systemd-1	/proc/sys/fs/binfmt_misc	autofs	direct,fd=32,maxproto=5,minproto=5,pgrp=1,relatime,rw,timeout=0	systemd-1	0:32
/lnet/cowroot/LneTXFCEhome	/home	none	rw,bind	/dev/sda2	8:2
/lnet/image/LneTXFCE64	/boot	none	ro,bind	/dev/sda1	8:1
debugfs	/sys/kernel/debug	debugfs	relatime,rw	debugfs	0:8
mqueue	/dev/mqueue	mqueue	relatime,rw	mqueue	0:16
hugetlbfs	/dev/hugepages	hugetlbfs	pagesize=2M,relatime,rw	hugetlbfs	0:33
/lnet/image/grub	/boot/grub	none	ro,bind	/dev/sda1	8:1
/lnet/image/grub	/lnet/image/LneTXFCE64/grub	none	ro,bind	/dev/sda1	8:1
/lnet/cowroot/JPLive	/home/JPLive	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive	/lnet/cowroot/LneTXFCEhome/JPLive	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/apt-cache-amd64	/var/cache/apt	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/apt-lib-amd64	/var/lib/apt	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/LneTXFCEhome/root	/root	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/var-spool	/var/spool	none	rw,bind	/dev/sda2	8:2
tmpfs	/run/user/1001	tmpfs	gid=100,mode=700,nodev,nosuid,relatime,rw,size=786152k,uid=1001	tmpfs	0:37
/home/JPLive/LneT-Lite-686/iso/LneT-Lite/00filesystem.squashfs	/tmp/live-net-remaster-Fg9o5x/image/00filesystem.squashfs	squashfs	relatime,ro,loop=/dev/loop2	/dev/loop2	7:2
overlay	/tmp/live-net-remaster-Fg9o5x/chroot	overlay	index=off,lowerdir=/tmp/live-net-remaster-Fg9o5x/image/00filesystem.squashfs,relatime,rw,upperdir=/home/tmp.uqIFpoBStR/upper,workdir=/home/tmp.uqIFpoBStR/work	overlay	0:39
/sys/	/tmp/live-net-remaster-Fg9o5x/chroot/sys	none	rw,bind	sysfs	0:17
/tmp/	/tmp/live-net-remaster-Fg9o5x/chroot/tmp	none	rw,bind	tmpfs	0:22
/dev/	/tmp/live-net-remaster-Fg9o5x/chroot/dev	none	rw,bind	udev	0:6
/dev/pts/	/tmp/live-net-remaster-Fg9o5x/chroot/dev/pts	none	rw,bind	devpts	0:18
/dev/pts/	/dev/pts	none	rw,bind	devpts	0:18
/sys/	/tmp/live-net-remaster-Fg9o5x/chroot/sys	none	rw,bind	sysfs	0:17
/sys/	/sys	none	rw,bind	sysfs	0:17
+lnet-remaster:361:_chroot_mount: mount -o bind /tmp/ /tmp/live-net-remaster-Fg9o5x/chroot/tmp/
+lnet-remaster:362:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 0
+lnet-remaster:363:_chroot_mount: mount-list
sysfs	/sys	sysfs	nodev,noexec,nosuid,relatime,rw	sysfs	0:17
proc	/proc	proc	nodev,noexec,nosuid,relatime,rw	proc	0:5
udev	/dev	devtmpfs	mode=755,nosuid,nr_inodes=978526,relatime,rw,size=3914104k	udev	0:6
devpts	/dev/pts	devpts	gid=5,mode=620,noexec,nosuid,ptmxmode=000,relatime,rw	devpts	0:18
tmpfs	/run	tmpfs	mode=755,noexec,nosuid,relatime,rw,size=786156k	tmpfs	0:19
tmpfs	/lnet	tmpfs	mode=755,relatime,rw,size=7861540k	tmpfs	0:20
/dev/sda1	/lnet/image	ext2	errors=continue,noacl,noatime,nouser_xattr,ro	/dev/sda1	8:1
/lnet/image/LneTXFCE64/00filesystem.squashfs	/lnet/00filesystem.squashfs	squashfs	noatime,ro,loop=/dev/loop0	/dev/loop0	7:0
/lnet/image/LneTXFCE64/10interfaces.squashfs	/lnet/10interfaces.squashfs	squashfs	noatime,ro,loop=/dev/loop1	/dev/loop1	7:1
/dev/sda2	/lnet/cowroot	ext4	data=ordered,relatime,rw	/dev/sda2	8:2
overlay	/	overlay	index=off,lowerdir=/lnet/00filesystem.squashfs:/lnet/10interfaces.squashfs,relatime,rw,upperdir=/lnet/cowroot/LneTXFCECOW/upper,workdir=/lnet/cowroot/LneTXFCECOW/work	overlay	0:21
tmpfs	/tmp	tmpfs	nodev,nosuid,relatime,rw,size=7861540k,mode=1777	tmpfs	0:22
tmpfs	/var/log	tmpfs	mode=755,nosuid,relatime,rw,size=7861540k	tmpfs	0:23
tmpfs	/var/tmp	tmpfs	nodev,nosuid,relatime,rw,size=7861540k,mode=1777	tmpfs	0:24
securityfs	/sys/kernel/security	securityfs	nodev,noexec,nosuid,relatime,rw	securityfs	0:7
tmpfs	/dev/shm	tmpfs	nodev,nosuid,rw,mode=1777	tmpfs	0:25
tmpfs	/run/lock	tmpfs	nodev,noexec,nosuid,relatime,rw,size=5120k,mode=1777	tmpfs	0:26
tmpfs	/sys/fs/cgroup	tmpfs	mode=755,nodev,noexec,nosuid,ro	tmpfs	0:27
cgroup	/sys/fs/cgroup/unified	cgroup2	nodev,noexec,nosuid,relatime,rw	cgroup	0:28
cgroup	/sys/fs/cgroup/systemd	cgroup	name=systemd,nodev,noexec,nosuid,relatime,rw,xattr	cgroup	0:29
pstore	/sys/fs/pstore	pstore	nodev,noexec,nosuid,relatime,rw	pstore	0:30
cgroup	/sys/fs/cgroup/cpu	cgroup	cpu,nodev,noexec,nosuid,relatime,rw	cgroup	0:31
systemd-1	/proc/sys/fs/binfmt_misc	autofs	direct,fd=32,maxproto=5,minproto=5,pgrp=1,relatime,rw,timeout=0	systemd-1	0:32
/lnet/cowroot/LneTXFCEhome	/home	none	rw,bind	/dev/sda2	8:2
/lnet/image/LneTXFCE64	/boot	none	ro,bind	/dev/sda1	8:1
debugfs	/sys/kernel/debug	debugfs	relatime,rw	debugfs	0:8
mqueue	/dev/mqueue	mqueue	relatime,rw	mqueue	0:16
hugetlbfs	/dev/hugepages	hugetlbfs	pagesize=2M,relatime,rw	hugetlbfs	0:33
/lnet/image/grub	/boot/grub	none	ro,bind	/dev/sda1	8:1
/lnet/image/grub	/lnet/image/LneTXFCE64/grub	none	ro,bind	/dev/sda1	8:1
/lnet/cowroot/JPLive	/home/JPLive	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive	/lnet/cowroot/LneTXFCEhome/JPLive	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/apt-cache-amd64	/var/cache/apt	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/apt-lib-amd64	/var/lib/apt	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/LneTXFCEhome/root	/root	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/var-spool	/var/spool	none	rw,bind	/dev/sda2	8:2
tmpfs	/run/user/1001	tmpfs	gid=100,mode=700,nodev,nosuid,relatime,rw,size=786152k,uid=1001	tmpfs	0:37
/home/JPLive/LneT-Lite-686/iso/LneT-Lite/00filesystem.squashfs	/tmp/live-net-remaster-Fg9o5x/image/00filesystem.squashfs	squashfs	relatime,ro,loop=/dev/loop2	/dev/loop2	7:2
overlay	/tmp/live-net-remaster-Fg9o5x/chroot	overlay	index=off,lowerdir=/tmp/live-net-remaster-Fg9o5x/image/00filesystem.squashfs,relatime,rw,upperdir=/home/tmp.uqIFpoBStR/upper,workdir=/home/tmp.uqIFpoBStR/work	overlay	0:39
/sys/	/tmp/live-net-remaster-Fg9o5x/chroot/sys	none	rw,bind	sysfs	0:17
/tmp/	/tmp/live-net-remaster-Fg9o5x/chroot/tmp	none	rw,bind	tmpfs	0:22
/dev/	/tmp/live-net-remaster-Fg9o5x/chroot/dev	none	rw,bind	udev	0:6
/dev/pts/	/tmp/live-net-remaster-Fg9o5x/chroot/dev/pts	none	rw,bind	devpts	0:18
/dev/pts/	/dev/pts	none	rw,bind	devpts	0:18
/sys/	/tmp/live-net-remaster-Fg9o5x/chroot/sys	none	rw,bind	sysfs	0:17
/sys/	/sys	none	rw,bind	sysfs	0:17
/tmp/	/tmp/live-net-remaster-Fg9o5x/chroot/tmp	none	rw,bind	tmpfs	0:22
/tmp/	/tmp	none	rw,bind	tmpfs	0:22
+lnet-remaster:364:_chroot_mount: '[' -z 'mkdir -p ${BASE_CHROOT}/home/JPLive; mount -o bind /home/JPLive ${BASE_CHROOT}/home/JPLive' ']'
+lnet-remaster:365:_chroot_mount: eval mkdir -p '${BASE_CHROOT}/home/JPLive;' mount -o bind /home/JPLive '${BASE_CHROOT}/home/JPLive'
++lnet-remaster:365:_chroot_mount: mkdir -p /tmp/live-net-remaster-Fg9o5x/chroot/home/JPLive
++lnet-remaster:365:_chroot_mount: mount -o bind /home/JPLive /tmp/live-net-remaster-Fg9o5x/chroot/home/JPLive
+lnet-remaster:366:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 0
drwxr-xr-x 3 root root 60 set 12 11:07 home
+lnet-remaster:368:_chroot_mount: export DISPLAY=:0.0
+lnet-remaster:368:_chroot_mount: DISPLAY=:0.0
+lnet-remaster:369:_chroot_mount: export HOME=/root
+lnet-remaster:369:_chroot_mount: HOME=/root
+lnet-remaster:370:_chroot_mount: export LC_ALL=C
+lnet-remaster:370:_chroot_mount: LC_ALL=C
+lnet-remaster:372:_chroot_mount: '[' '!' -L /tmp/live-net-remaster-Fg9o5x/chroot/etc/mtab ']'
+lnet-remaster:374:_chroot_mount: rm -f /tmp/live-net-remaster-Fg9o5x/chroot/etc/mtab
+lnet-remaster:375:_chroot_mount: ln -fs /proc/mounts /tmp/live-net-remaster-Fg9o5x/chroot/etc/mtab
+lnet-remaster:375:_chroot_mount: :
+lnet-remaster:377:_chroot_mount: cp /etc/hosts /tmp/live-net-remaster-Fg9o5x/chroot/etc/
+lnet-remaster:378:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 0
drwxr-xr-x 3 root root 60 Sep 12 11:07 home
+lnet-remaster:380:_chroot_mount: chroot /tmp/live-net-remaster-Fg9o5x/chroot/ mount -t proc none /proc
+lnet-remaster:381:_chroot_mount: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 0
drwxr-xr-x 3 root root 60 Sep 12 11:07 home
+lnet-remaster:382:_chroot_mount: :
+lnet-remaster:736:_prepare_web_database: _chroot_mount_compress
+lnet-remaster:395:_chroot_mount_compress: mkdir -p /tmp/live-net-remaster-Fg9o5x/chroot/var/tmp/mnt/
+lnet-remaster:396:_chroot_mount_compress: mount -o bind /home/JPLive/LneT-Lite-686 /tmp/live-net-remaster-Fg9o5x/chroot/var/tmp/mnt/
+lnet-remaster:397:_chroot_mount_compress: ls -lA /tmp/live-net-remaster-Fg9o5x/chroot
total 0
drwxr-xr-x 3 root root 60 Sep 12 11:07 home
drwxr-xr-x 3 root root 60 Sep 12 11:07 var
+lnet-remaster:398:_chroot_mount_compress: :
+lnet-remaster:737:_prepare_web_database: chroot /tmp/live-net-remaster-Fg9o5x/chroot/ sh
+lnet-remaster:857:_prepare_web_database: echo 'Error: when preparing web database.'
+lnet-remaster:858:_prepare_web_database: return 1
+lnet-remaster:1505: exit 1

--MP_/AAac3f_AWsg4s5jigrHWmyg--
