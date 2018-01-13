From: Niklas Cassel <niklas.cassel@axis.com>
Subject: overlayfs non-persistent inodes
Date: Sat, 13 Jan 2018 01:19:03 +0100
Message-ID: <20180113001902.GA10063@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:45634 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965312AbeAMATF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 19:19:05 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: amir73il@gmail.com, mszeredi@redhat.com
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

Hello Miklos, Amir

We are having some problems with inotify + overlayfs.

If we start to monitor a directory on an overlayfs,
and get into a low memory situation, or if
/proc/sys/vm/drop_caches is called explicitly,
our inotify stops reporting events.

This appears to be caused by non-persistent inodes.

Looking at the commits, it looked like inode numbers
were persistent since commit
b7a807dc2010 ("ovl: persistent inode number for directories").

However, this doesn't seem to take different file systems
into account:

# cat /proc/version
Linux version 4.15.0-rc7-next-20180109-00003-gd1acc32c9ee5 (niklass@lnxartpec1)
 (gcc version 6.3.0 (crosstool-NG crosstool-ng-1.22.0-610-g21cde94)) #74
 SMP Fri Jan 12 13:23:57 CET 2018
# mkdir -p /test/dir /mnt/tmp
# mount -t tmpfs tmpfs /mnt/tmp
# mkdir /mnt/tmp/.work-test /mnt/tmp/test
# mount -t overlay overlay /test -o lowerdir=/test,upperdir=/mnt/tmp/test,
workdir=/mnt/tmp/.work-test
# ls -lid /test/dir
   6313 drwxr-xr-x    2 root     root            40 Jan  1 00:01 /test/dir
# echo 3 > /proc/sys/vm/drop_caches
[  229.762380] sh (118): drop_caches: 3
# ls -lid /test/dir
   6318 drwxr-xr-x    2 root     root            40 Jan  1 00:01 /test/dir


There are probably a few user space applications that
rely on inotify. If inotify suddenly and silently stops
reporting events after some memory pressure, all kinds
of bugs could be introduced in user space.

I'm guessing that it will not be so easy to figure out
that overlayfs might be the root-cause of their
seemingly random bug.


Regards,
Niklas
