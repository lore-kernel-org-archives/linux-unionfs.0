From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.13
Date: Wed, 12 Jul 2017 10:26:20 +0200
Message-ID: <20170712082620.GA5256@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36084 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933664AbdGLI03 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jul 2017 04:26:29 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so4032225wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jul 2017 01:26:28 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This work from Amir introduces the inodes index feature, which provides:

- hardlinks are not broken on copy up;
- infrastructure for overlayfs NFS export.

This  also fixes constant st_ino for samefs case for lower hardlinks.

There's one patch touching <linux/fs.h>, which adds an inode flag for testing
"in use by another overlay".  So this flag is set on inodes in the underlying
layers, but the use is private to overlayfs.

Thanks,
Miklos

---
Amir Goldstein (19):
      ovl: fix nlink leak in ovl_rename()
      ovl: allocate an ovl_inode struct
      ovl: use ovl_inode mutex to synchronize concurrent copy up
      vfs: introduce inode 'inuse' lock
      ovl: get exclusive ownership on upper/work dirs
      ovl: relax same fs constrain for ovl_check_origin()
      ovl: generalize ovl_create_workdir()
      ovl: introduce the inodes index dir feature
      ovl: verify upper root dir matches lower root dir
      ovl: verify index dir matches upper dir
      ovl: lookup index entry for copy up origin
      ovl: cleanup bad and stale index entries on mount
      ovl: defer upper dir lock to tempfile link
      ovl: factor out ovl_copy_up_inode() helper
      ovl: implement index dir copy up
      ovl: persistent overlay inode nlink for indexed inodes
      ovl: cleanup orphan index entries
      ovl: document copying layers restrictions with inodes index
      ovl: mark parent impure and restore timestamp on ovl_link_up()

Miklos Szeredi (14):
      ovl: simplify getting inode
      ovl: use i_private only as a key
      ovl: compare inodes
      ovl: move __upperdentry to ovl_inode
      ovl: move redirect to ovl_inode
      ovl: move impure to ovl_inode
      ovl: move cache and version to ovl_inode
      ovl: hash overlay non-dir inodes by copy up origin
      ovl: extract helper to get temp file in copy up
      ovl: base tmpfile in workdir too
      ovl: use struct copy_up_ctx as function argument
      ovl: add flag for upper in ovl_entry
      ovl: rearrange copy up
      ovl: move copy up lock out

---
 Documentation/filesystems/overlayfs.txt |  34 +++
 fs/overlayfs/Kconfig                    |  20 ++
 fs/overlayfs/copy_up.c                  | 410 +++++++++++++++++++++-----------
 fs/overlayfs/dir.c                      |  52 +++-
 fs/overlayfs/inode.c                    | 215 +++++++++++++++--
 fs/overlayfs/namei.c                    | 368 +++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h                |  58 +++--
 fs/overlayfs/ovl_entry.h                |  36 ++-
 fs/overlayfs/readdir.c                  |  50 ++++
 fs/overlayfs/super.c                    | 247 ++++++++++++++++---
 fs/overlayfs/util.c                     | 345 ++++++++++++++++++++-------
 include/linux/fs.h                      |   4 +
 12 files changed, 1456 insertions(+), 383 deletions(-)
