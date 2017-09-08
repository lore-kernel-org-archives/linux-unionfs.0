From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: v4.13 overlay fs: sometimes fails when creating or moving files
Date: Fri, 8 Sep 2017 14:37:04 +0200
Message-ID: <20170908143704.3c74d20f@localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/c+knolb_6ocNPth23etHT7s"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:47075 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755217AbdIHMhK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2017 08:37:10 -0400
Received: by mail-wm0-f47.google.com with SMTP id i189so4056253wmf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2017 05:37:09 -0700 (PDT)
Received: from localdomain (39.red-88-1-91.dynamicip.rima-tde.net. [88.1.91.39])
        by smtp.gmail.com with ESMTPSA id v73sm1553088wmv.15.2017.09.08.05.37.07
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Sep 2017 05:37:08 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

--MP_/c+knolb_6ocNPth23etHT7s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

Found some errors when doing a remaster of a filesystem image in Linux v
4.13,
the filesystem is mounted in overlay and then modifying the
system into the chroot.
The upgrade process fails when renaming or moving files.
Sometimes the same process runs right and sometimes wrong, 

screen dump to chroot.txt

# mount-list > mount-list.txt

Thanks,

Jordi Pujol i Palomer

--MP_/c+knolb_6ocNPth23etHT7s
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=chroot.txt

# uname -a
Linux pcjordi 4.13.0-2-haswell-lnet-amd64 #1 SMP PREEMPT Thu Sep 7 04:30:57 CEST 2017 x86_64 GNU/Linux

root@pcjordi:LneT-LXQT-amd64# /home/JPLive/git/live-net-remaster/lnet-remaster -pr
The Original source file or dir is 00filesystem.squashfs
The destination directory is /home/JPLive/LneT-LXQT-amd64
Mounting overlay image.Mounting image 00filesystem.squashfs in overlay root.Done.
Chroot to modify the system.

Now populating the root profile with useful commands...
Warning: Before exit, verify that there are no running processes into this shell.
(LneT-LXQT-amd64)root@pcjordi:/# aptitude full-upgrade
The following packages will be upgraded: 
  claws-mail claws-mail-multi-notifier dirmngr gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server 
  gpgconf gpgsm gpgv hunspell-ca libmpfr4 sudo 
The following packages are RECOMMENDED but will NOT be installed:
  aspell-am aspell-ar aspell-ar-large aspell-bg aspell-br aspell-ca aspell-cs aspell-cy aspell-da aspell-de 
  aspell-de-1901 aspell-el aspell-en aspell-eo aspell-eo-cx7 aspell-es aspell-et aspell-eu aspell-fa aspell-fo aspell-fr 
  aspell-ga aspell-gl-minimos aspell-he aspell-hr aspell-hsb aspell-hu aspell-hy aspell-is aspell-it aspell-kk aspell-ku 
  aspell-lt aspell-lv aspell-nl aspell-pl aspell-pt-br aspell-pt-pt aspell-ro aspell-ru aspell-sk aspell-sl aspell-sv 
  aspell-tl aspell-uk aspell-uz claws-mail-i18n 
16 packages upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Need to get 0 B/10.4 MB of archives. After unpacking 18.4 kB will be used.
Do you want to continue? [Y/n/?] y
(Reading database ... 53176 files and directories currently installed.)
Preparing to unpack .../00-gpg-wks-client_2.2.0-3_amd64.deb ...
Unpacking gpg-wks-client (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../01-dirmngr_2.2.0-3_amd64.deb ...
Unpacking dirmngr (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../02-gnupg-l10n_2.2.0-3_all.deb ...
Unpacking gnupg-l10n (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../03-gpg_2.2.0-3_amd64.deb ...
Unpacking gpg (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../04-gnupg-utils_2.2.0-3_amd64.deb ...
Unpacking gnupg-utils (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../05-gpg-agent_2.2.0-3_amd64.deb ...
Unpacking gpg-agent (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../06-gpgsm_2.2.0-3_amd64.deb ...
Unpacking gpgsm (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../07-gpgconf_2.2.0-3_amd64.deb ...
Unpacking gpgconf (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../08-gnupg_2.2.0-3_amd64.deb ...
Unpacking gnupg (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../09-gpg-wks-server_2.2.0-3_amd64.deb ...
Unpacking gpg-wks-server (2.2.0-3) over (2.2.0-1) ...
Preparing to unpack .../10-gpgv_2.2.0-3_amd64.deb ...
Unpacking gpgv (2.2.0-3) over (2.2.0-1) ...
dpkg: error: error removing old backup file '/var/lib/dpkg/status-old': Stale file handle
E: Sub-process /usr/bin/dpkg returned an error code (2)
dpkg: error: error removing old backup file '/var/lib/dpkg/status-old': Stale file handle
E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem. 
E: Could not regain the system lock!  (Perhaps another apt or dpkg is running?)
E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem. 
                                         
W: Could not lock the cache file; this usually means that dpkg or another apt tool is already installing packages.  Opening in read-only mode; any changes you make to the states of packages will NOT be preserved!
(LneT-LXQT-amd64)root@pcjordi:/# 

--MP_/c+knolb_6ocNPth23etHT7s
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=mount-list.txt

sysfs	/sys	sysfs	nodev,noexec,nosuid,relatime,rw	sysfs	0:17
proc	/proc	proc	nodev,noexec,nosuid,relatime,rw	proc	0:5
udev	/dev	devtmpfs	mode=755,nosuid,nr_inodes=978527,relatime,rw,size=3914108k	udev	0:6
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
/lnet/image/LneTXFCE64	/boot	none	ro,bind	/dev/sda1	8:1
/lnet/cowroot/LneTXFCEhome	/home	none	rw,bind	/dev/sda2	8:2
mqueue	/dev/mqueue	mqueue	relatime,rw	mqueue	0:16
debugfs	/sys/kernel/debug	debugfs	relatime,rw	debugfs	0:8
hugetlbfs	/dev/hugepages	hugetlbfs	pagesize=2M,relatime,rw	hugetlbfs	0:33
/lnet/image/grub	/boot/grub	none	ro,bind	/dev/sda1	8:1
/lnet/image/grub	/lnet/image/LneTXFCE64/grub	none	ro,bind	/dev/sda1	8:1
/lnet/cowroot/JPLive	/home/JPLive	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive	/lnet/cowroot/LneTXFCEhome/JPLive	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/LneTXFCEhome/root	/root	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/apt-cache-amd64	/var/cache/apt	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/var-spool	/var/spool	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/apt-lib-amd64	/var/lib/apt	none	rw,bind	/dev/sda2	8:2
tmpfs	/run/user/1001	tmpfs	gid=100,mode=700,nodev,nosuid,relatime,rw,size=786152k,uid=1001	tmpfs	0:38
/home/JPLive/LneT-LXQT-amd64/iso/LneT-LXQT/00filesystem.squashfs	/tmp/live-net-remaster-JGtNY3/image/00filesystem.squashfs	squashfs	relatime,ro,loop=/dev/loop2	/dev/loop2	7:2
overlay	/tmp/live-net-remaster-JGtNY3/chroot	overlay	index=off,lowerdir=/tmp/live-net-remaster-JGtNY3/image/00filesystem.squashfs,relatime,rw,upperdir=/home/tmp.IxhAZV2w0q/upper,workdir=/home/tmp.IxhAZV2w0q/work	overlay	0:37
/dev/	/tmp/live-net-remaster-JGtNY3/chroot/dev	none	rw,bind	udev	0:6
/dev/pts/	/tmp/live-net-remaster-JGtNY3/chroot/dev/pts	none	rw,bind	devpts	0:18
/dev/pts/	/dev/pts	none	rw,bind	devpts	0:18
/sys/	/tmp/live-net-remaster-JGtNY3/chroot/sys	none	rw,bind	sysfs	0:17
/tmp/	/tmp/live-net-remaster-JGtNY3/chroot/tmp	none	rw,bind	tmpfs	0:22
/lnet/cowroot/JPLive	/tmp/live-net-remaster-JGtNY3/chroot/home/JPLive	none	rw,bind	/dev/sda2	8:2
/proc/	/tmp/live-net-remaster-JGtNY3/chroot/proc	none	rw,bind	none	0:5
/lnet/cowroot/JPLive/apt-cache-amd64	/tmp/live-net-remaster-JGtNY3/chroot/var/cache/apt	none	rw,bind	/dev/sda2	8:2
/lnet/cowroot/JPLive/apt-lib-amd64	/tmp/live-net-remaster-JGtNY3/chroot/var/lib/apt	none	rw,bind	/dev/sda2	8:2

--MP_/c+knolb_6ocNPth23etHT7s--
