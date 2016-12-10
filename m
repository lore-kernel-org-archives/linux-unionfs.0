From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] readlink cleanup
Date: Sat, 10 Dec 2016 21:41:45 +0100
Message-ID: <20161210204145.GK2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33881 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbcLJUlt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Dec 2016 15:41:49 -0500
Received: by mail-wm0-f68.google.com with SMTP id g23so2980267wme.1
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Dec 2016 12:41:48 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git readlink

This is a rework of the readlink cleanup patchset.  Now readlink(2) does the
following:

 - if i_op->readlink() is non-NULL (only proc and afs mountpoints for now) then
   it calls that;
 - otherwise call i_op->get_link();
 - signature of ->readlink() now matches that of ->get_link();

This is against the #misc branch (the stats look better that way ;)

Thanks,
Miklos

---
Miklos Szeredi (10):
      ecryptfs: use vfs_get_link()
      proc/self: use generic_readlink
      vfs: replace calling i_op->readlink with vfs_readlink()
      vfs: default to generic_readlink()
      vfs: remove ".readlink = generic_readlink" assignments
      vfs: make generic_readlink() static
      vfs: convert ->readlink to same signature as ->get_link
      vfs: remove page_readlink()
      vfs: make readlink_copy() static
      nsfs: clean up ns_get_name() interface

---
 Documentation/filesystems/Locking             |  6 +--
 Documentation/filesystems/porting             |  7 ++++
 Documentation/filesystems/vfs.txt             | 14 ++++---
 drivers/staging/lustre/lustre/llite/symlink.c |  1 -
 fs/9p/vfs_inode.c                             |  1 -
 fs/9p/vfs_inode_dotl.c                        |  1 -
 fs/affs/symlink.c                             |  1 -
 fs/afs/mntpt.c                                |  2 +-
 fs/autofs4/symlink.c                          |  1 -
 fs/bad_inode.c                                |  8 +---
 fs/btrfs/inode.c                              |  1 -
 fs/ceph/inode.c                               |  1 -
 fs/cifs/cifsfs.c                              |  1 -
 fs/coda/cnode.c                               |  1 -
 fs/configfs/symlink.c                         |  1 -
 fs/ecryptfs/inode.c                           | 30 ++++++--------
 fs/ext2/symlink.c                             |  2 -
 fs/ext4/symlink.c                             |  3 --
 fs/f2fs/namei.c                               |  2 -
 fs/fuse/dir.c                                 |  1 -
 fs/gfs2/inode.c                               |  1 -
 fs/hostfs/hostfs_kern.c                       |  1 -
 fs/jffs2/symlink.c                            |  1 -
 fs/jfs/symlink.c                              |  2 -
 fs/kernfs/symlink.c                           |  1 -
 fs/libfs.c                                    |  1 -
 fs/minix/inode.c                              |  1 -
 fs/namei.c                                    | 58 ++++++++++++++++-----------
 fs/ncpfs/inode.c                              |  1 -
 fs/nfs/symlink.c                              |  1 -
 fs/nfsd/nfs4xdr.c                             |  8 ++--
 fs/nfsd/vfs.c                                 |  6 +--
 fs/nilfs2/namei.c                             |  1 -
 fs/nsfs.c                                     | 17 ++++++--
 fs/ocfs2/symlink.c                            |  1 -
 fs/orangefs/symlink.c                         |  1 -
 fs/overlayfs/inode.c                          |  1 -
 fs/proc/base.c                                | 57 +++++++++-----------------
 fs/proc/inode.c                               |  1 -
 fs/proc/namespaces.c                          | 13 +++---
 fs/proc/self.c                                | 13 ------
 fs/proc/thread_self.c                         | 14 -------
 fs/reiserfs/namei.c                           |  1 -
 fs/squashfs/symlink.c                         |  1 -
 fs/stat.c                                     |  8 ++--
 fs/sysv/inode.c                               |  1 -
 fs/ubifs/file.c                               |  1 -
 fs/xfs/xfs_ioctl.c                            |  4 +-
 fs/xfs/xfs_iops.c                             |  2 -
 include/linux/fs.h                            |  9 ++---
 include/linux/proc_ns.h                       |  4 +-
 mm/shmem.c                                    |  2 -
 52 files changed, 124 insertions(+), 195 deletions(-)
