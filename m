From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 00/17] Avoid breaking lower hardlinks on copy up
Date: Fri,  2 Jun 2017 17:04:27 +0300
Message-ID: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36026 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdFBOEi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:38 -0400
Received: by mail-wm0-f66.google.com with SMTP id k15so19203989wmh.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:37 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This is the curernt pile. Since the pile is quite big, touches
many parts of the code and raises some user API questions, I wanted
to send it out early for review, so there are still some known issues.

I have improved hardlink copy up tests including concurrent copy
up of lower hardlinks on my xfstests dev branch [1].

This work does NOT assume samefs.

Known issues:
- Missing code on mount to verify/cleanup stale index entries
- Missing documentation
- Better handling of existing broken hardlink with origin (*)
- Non-upper alias content is inconsistent with upper aliases (**)

(*) Currently upper entries are hashed by origin inode if it is
    known AND inodes index feature is enabled. This is not enough.
    Need to also check that the origin inode in question is indexed.

(**) This is for the same reason that ro/rw fd content is inconsistent.
     The 2 hardlink copy up xfstests fail because of that.
     Need to lookup the index on lookup of non-upper and store it in
     dentry for open RDONLY. Something like my rocopyup POC [2].
     Probably not for v4.13 though...

[1] https://github.com/amir73il/xfstests/commits/overlayfs-devel
[2] https://github.com/amir73il/linux/commits/ovl-rocopyup

Amir Goldstein (17):
  vfs: add helper wait_on_inode_inuse()
  ovl: generalize ovl_create_workdir()
  ovl: introduce the inodes index dir feature
  ovl: verify index dir matches upper dir
  ovl: create helper ovl_lookup_index()
  ovl: move inode helpers to inode.c
  ovl: create helpers for initializing hashed inode
  ovl: use ovl_inode_init() for initializing new inode
  ovl: allow hashing non upper inodes
  ovl: allow hashing inodes by arbitrary key
  ovl: hash overlay non-dir inodes by copy up origin inode
  ovl: defer upper dir lock to tempfile link
  ovl: factor out ovl_copy_up_inode() helper
  ovl: generalize ovl_copy_up_locked() using actors
  ovl: generalize ovl_copy_up_one() using actors
  ovl: implement index dir copy up method
  ovl: handle race of concurrent lower hardlinks copy up

 fs/inode.c               |  24 ++
 fs/overlayfs/Kconfig     |  20 ++
 fs/overlayfs/copy_up.c   | 630 ++++++++++++++++++++++++++++++++++++++---------
 fs/overlayfs/dir.c       |   2 +-
 fs/overlayfs/inode.c     |  66 ++++-
 fs/overlayfs/namei.c     |  72 +++++-
 fs/overlayfs/overlayfs.h |  43 +++-
 fs/overlayfs/ovl_entry.h |   3 +
 fs/overlayfs/super.c     | 154 +++++++++---
 fs/overlayfs/util.c      |  26 +-
 include/linux/fs.h       |   1 +
 11 files changed, 848 insertions(+), 193 deletions(-)

-- 
2.7.4
