From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.10
Date: Fri, 16 Dec 2016 18:32:16 +0100
Message-ID: <20161216173216.GC27207@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:35704 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756371AbcLPRcV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Dec 2016 12:32:21 -0500
Received: by mail-wj0-f195.google.com with SMTP id he10so15303719wjc.2
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Dec 2016 09:32:20 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This update contains:

 - try to clone on copy-up;
 - allow renaming a directory;
 - split source into managable chunks;
 - misc cleanups and fixes.

It does not contain the read-only fd data inconsistency fix, which Al didn't
like.  I'll leave that to the next year...

Thanks,
Miklos

---
Al Viro (1):
      ovl: clean up kstat usage

Amir Goldstein (10):
      vfs: allow vfs_clone_file_range() across mount points
      vfs: call vfs_clone_file_range() under freeze protection
      vfs: fix vfs_clone_file_range() for overlayfs files
      ovl: use vfs_clone_file_range() for copy up if possible
      ovl: fix nested overlayfs mount
      ovl: check for emptiness of redirect dir
      ovl: show redirect_dir mount option
      ovl: create directories inside merged parent opaque
      ovl: fold ovl_copy_up_truncate() into ovl_copy_up()
      ovl: fix reStructuredText syntax errors in documentation

Geliang Tang (1):
      ovl: fix return value of ovl_fill_super

Miklos Szeredi (24):
      Revert "af_unix: fix hard linked sockets on overlay"
      Revert "vfs: rename: check backing inode being equal"
      vfs: no mnt_want_write_file() in vfs_{copy,clone}_file_range()
      ovl: update doc
      Revert "ovl: get_write_access() in truncate"
      ovl: rename ovl_rename2() to ovl_rename()
      ovl: treat special files like a regular fs
      ovl: don't check rename to self
      ovl: don't check sticky
      ovl: add ovl_dentry_is_whiteout()
      ovl: check lower existence when removing
      ovl: get rid of PURE type
      ovl: rename: simplify handling of lower/merged directory
      ovl: check lower existence of rename target
      ovl: simplify lookup
      ovl: use d_is_dir()
      ovl: split super.c
      ovl: check namelen
      ovl: consolidate lookup for underlying layers
      ovl: lookup redirects
      ovl: redirect on rename-dir
      ovl: allow redirect_dir to default to "on"
      ovl: allow setting max size of redirect
      ovl: opaque cleanup

---
 Documentation/filesystems/overlayfs.txt |  26 +-
 fs/ioctl.c                              |   6 +-
 fs/namei.c                              |   6 +-
 fs/nfsd/vfs.c                           |   3 +-
 fs/overlayfs/Kconfig                    |  14 +
 fs/overlayfs/Makefile                   |   2 +-
 fs/overlayfs/copy_up.c                  |  61 ++--
 fs/overlayfs/dir.c                      | 375 ++++++++++++---------
 fs/overlayfs/inode.c                    |  78 +----
 fs/overlayfs/namei.c                    | 401 +++++++++++++++++++++++
 fs/overlayfs/overlayfs.h                |  62 ++--
 fs/overlayfs/ovl_entry.h                |  53 +++
 fs/overlayfs/super.c                    | 557 ++++----------------------------
 fs/overlayfs/util.c                     | 265 +++++++++++++++
 fs/read_write.c                         |  23 +-
 include/linux/fs.h                      |  13 +
 net/unix/af_unix.c                      |   6 +-
 17 files changed, 1139 insertions(+), 812 deletions(-)
 create mode 100644 fs/overlayfs/namei.c
 create mode 100644 fs/overlayfs/ovl_entry.h
 create mode 100644 fs/overlayfs/util.c
