From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 0/4] ovl: optimize dir iteration
Date: Thu, 22 Dec 2016 19:25:31 +0200
Message-ID: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35144 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941660AbcLVRZz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Dec 2016 12:25:55 -0500
Received: by mail-wm0-f65.google.com with SMTP id l2so11813991wml.2
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Dec 2016 09:25:55 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This patch series implements dir iteration optimizations
using fs support for setting file types on rename.

Implementing support for xfs was very easy, although this
is just a demo patch, because proper support would require
a new feature flag and relaxing xfs_repair file type checks.

The xfs patch is based on top of my cleanup series, but is
not dependent on it in any significant way.

I tested on the following setup of upper/lower on same base xfs:

/dev-lower_layer on /base type xfs (rw,relatime,attr2,inode64,noquota)
/dev-lower_layer on /lower type xfs (rw,relatime,attr2,inode64,noquota)
/dev-lower_layer on /upper type xfs (rw,relatime,attr2,inode64,noquota)
overlay on /mnt type overlay (rw,relatime,lowerdir=/lower,upperdir=/upper/0,workdir=/upper/work)

Generated some whiteouts some copy ups and some opaque objects:

root@kvm-xfstests:~# rm /mnt/a/pointless100 
root@kvm-xfstests:~# rmdir /mnt/a/empty100
root@kvm-xfstests:~# touch /mnt/a/foo100 
root@kvm-xfstests:~# touch /mnt/a/dir100 
root@kvm-xfstests:~# touch /mnt/a/newfile
root@kvm-xfstests:~# mkdir /mnt/a/newdir

Used this tool I introduced to xfstests to print the resulting dtypes:

root@kvm-xfstests:~# ./xfstests/src/t_dir_type /upper/0/a/
. d
.. d
pointless100 w
empty100 w
foo100 u
dir100 u
newfile f
newdir d


What do you think of the proposed rename API?
To me, it makes some sense, because a request to re-classify
a directory entry is like a request to re-index it, which
is basically what rename is about. It may even make sense
to be able to call the rename API for changing dtype,
without changing the name/parent at all.

Amir.

Amir Goldstein (4):
  vfs: add RENAME_VFS_DTYPE vfs_rename() flag
  xfs: support RENAME_VFS_DTYPE flag
  ovl: use RENAME_DT_UNKNOWN to optimize stable d_inode
  ovl: use RENAME_DT_WHT to optimize ovl_dir_read_merged()

 fs/overlayfs/copy_up.c   |  8 +++++++-
 fs/overlayfs/dir.c       | 12 +++++++++---
 fs/overlayfs/overlayfs.h |  5 +++++
 fs/overlayfs/readdir.c   |  2 +-
 fs/xfs/libxfs/xfs_dir2.c |  1 +
 fs/xfs/xfs_iops.c        | 11 ++++++++---
 include/linux/fs.h       | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h  |  4 ++++
 8 files changed, 65 insertions(+), 8 deletions(-)

-- 
2.7.4
