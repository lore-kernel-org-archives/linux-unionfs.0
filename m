Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35557 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfC0CoV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Mar 2019 22:44:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id g8so9217809pgf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Mar 2019 19:44:21 -0700 (PDT)
MIME-Version: 1.0
From: koishi komeiji <maykagura@gmail.com>
Date: Wed, 27 Mar 2019 10:44:08 +0800
Message-ID: <CALsfCbd2UKVsC4k=da5x+joaBQk-phCizkyF0vXeMNOYDojWwQ@mail.gmail.com>
Subject: [Help]Cannot read symbolic link(Invalid argument) in overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

Hello.I met a bug about overlayfs again. I run a container by docker .
In the container, a symbolic link has been broken.I switch to host,
and find the broken file in /var/lib/docker.   I find 2 file that one
is in /var/lib/docker/overlay2/e3.../merged and another one is in
/var/lib/docker/overlay2/e3.../diff.
The directory of /var/lib/docker/overlay2/e3.../merged is mounted on
overlay fs. The 2 file have same inode. I think this means they are
the same file. The file in /var/lib/docker/overlay2/e3.../diff is ok.
But the file in /var/lib/docker/overlay2/e3.../merged is broken.
I doubt this is a bug of overlayfs.

root:/var/lib/docker# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        83G   29G   50G  38% /
overlay          83G   29G   50G  38% /var/lib/docker/overlay2/e3ed8.../merged
...


root:/var/lib/docker# find . -name "libdrv_ip6proen.so"
./overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
./overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so


root:/var/lib/docker# cat overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
cat: overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so: Too many
levels of symbolic links

root:/var/lib/docker# ls -li overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
ls: cannot read symbolic link
'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so': Invalid
argument
3038490 lrwxrwxrwx 1 root root 26 3 25 16:24
overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so

root:/var/lib/docker# ls -li overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
3038490 lrwxrwxrwx 1 root root 26 3 25 16:24
overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so ->
libdrv_ip6proen.so.0.0.0.4




root:/var/lib/docker# stat overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
  File: 'overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so' ->
'libdrv_ip6proen.so.0.0.0.4'
  Size: 26              Blocks: 0          IO Block: 4096   symbolic link
Device: 801h/2049d      Inode: 3038490     Links: 1
Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-03-26 16:38:47.588388845 +0800
Modify: 2019-03-25 16:24:05.536041935 +0800
Change: 2019-03-25 16:24:05.536041935 +0800
 Birth: -


root:/var/lib/docker# stat overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
  File: 'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so'stat:
cannot read symbolic link
'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so': Invalid
argument

  Size: 26              Blocks: 0          IO Block: 4096   symbolic link
Device: 801h/2049d      Inode: 3038490     Links: 1
Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-03-26 16:38:47.588388845 +0800
Modify: 2019-03-25 16:24:05.536041935 +0800
Change: 2019-03-25 16:24:05.536041935 +0800
 Birth: -



root:/var/lib/docker# uname -a
Linux z15572-virtual-machine 4.9.29 #1 SMP Tue Oct 16 22:13:48 CST
2018 x86_64 x86_64 x86_64 GNU/Linux

root:/var/lib/docker# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04.5 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04.5 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
VERSION_CODENAME=xenial
UBUNTU_CODENAME=xenial
