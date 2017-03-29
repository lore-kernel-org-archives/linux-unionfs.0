From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/6] ovl: consistent_fd feature
Date: Wed, 29 Mar 2017 17:36:00 +0300
Message-ID: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35834 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdC2OgC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Mar 2017 10:36:02 -0400
Received: by mail-wr0-f195.google.com with SMTP id p52so3562094wrc.2
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Mar 2017 07:36:01 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Mikos,

This patch set implement the 'simple' solution we discussed on LSF.
For the special case of all overlays on the same fs with clone support,
files are copied up on open for read (as O_TMPFILE) and linked to
upperdir on first open for write.

- Patches 1-2 are the refactoring I sent you earlier.  They are not
  strictly needed for the consistent_fd feature - up to you.
- Patches 3-4 test 'samefs' and 'cloneup' properties of underlying fs.
- Patch 5 copies up open for read (for the special case).
- Patch 6 defers linking the tmpfile to first open for write.

Some of the design choices for patch 6 are questionable:
the storing of tempfile in ovl_dentry_update(),
temp dentry is freed only on overlay dentry release.
awaiting your feedback about those choises.

xfstests run of ./check -overlay -g quick passed on
both ext4 (no clone) and xfs+reflink (yes clone).
test overlay/016 ("Test ro/rw fd data inconsistecies")
passes with xfs+reflink.
test overlay/013 ("Test truncate running executable...")
fails with xfs+reflink, because test expects the inconsistency.

I also modified unionmount-testsuite and added ./run --ov --samefs
to setup lower+upper on same base fs of your choise [1].
It passes with base fs tmpfs (no clone) and base fs xfs+reflink.

Amir.

[1] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

Amir Goldstein (6):
  ovl: store path type in dentry
  ovl: cram opaque boolean into type flags
  ovl: check if all layers are on the same fs
  ovl: check if clone from lower to upper is supported
  ovl: copy on read with consistent_fd feature
  ovl: link upper tempfile on open for write

 Documentation/filesystems/vfs.txt | 13 +++---
 fs/overlayfs/Kconfig              | 18 ++++++++
 fs/overlayfs/copy_up.c            | 97 ++++++++++++++++++++++++++++++++-------
 fs/overlayfs/inode.c              | 41 ++++++++++++-----
 fs/overlayfs/namei.c              | 10 ++--
 fs/overlayfs/overlayfs.h          | 12 ++++-
 fs/overlayfs/ovl_entry.h          | 20 ++++++--
 fs/overlayfs/super.c              | 59 ++++++++++++++++++++++--
 fs/overlayfs/util.c               | 69 +++++++++++++++++++++++-----
 9 files changed, 277 insertions(+), 62 deletions(-)

-- 
2.7.4
