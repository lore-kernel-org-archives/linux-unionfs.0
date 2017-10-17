From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 00/11] Implement overlayfs index=all mount option
Date: Tue, 17 Oct 2017 19:00:11 +0300
Message-ID: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:56230 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932814AbdJQP7u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:59:50 -0400
Received: by mail-wm0-f67.google.com with SMTP id u138so4964988wmu.4
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:59:49 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This is the second of two prep patch sets [1][2] for NFS export [3].
NFS export is enabled with the 'verify_dir' and 'index=all'
mount options.

The requirement for 'index=all' can be relaxed if we create index
for redirected dirs on lookup and for renamed non-dirs when encoding
file handles. Decoding file handle will be more complex without
index=all, so per your suggestion, this was not implemented for
first version of NFS export.

The first two patches in this series are tagged for stable v4.13.
The first patch I already posted, relaxes some index lookup constrains
that we can do without.
The second patch allows kernel v4.13 to mount an overlay with whiteout
index entries, which are being introduced by this patch set.

To sanity test index=all, I have implemented _overlay_check_fs()
helper for xfstests [4], which is a very basic "fsck" of the index dir.
This helper is called at the end of each overlay xfstest to verify the
sanity of the index entries.

Amir.

[1] https://github.com/amir73il/linux/commits/ovl-verify-dir
[2] https://github.com/amir73il/linux/commits/ovl-index-all
[3] https://github.com/amir73il/linux/commits/ovl-nfs-export
[4] https://github.com/amir73il/xfstests/commits/ovl-index-all

Amir Goldstein (11):
  ovl: fix EIO from lookup of non-indexed upper
  ovl: verify whiteout index entries on mount
  ovl: create ovl_need_index() helper
  ovl: add support for mount option index=all
  ovl: lookup index for directories
  ovl: verify directory index entries on mount
  ovl: index directories on copy up
  ovl: cleanup dir index when dir nlink drops to zero
  ovl: whiteout index when union nlink drops to zero
  ovl: whiteout orphan index entries on mount
  ovl: cleanup stale whiteout index entries on mount

 fs/overlayfs/copy_up.c   | 130 +++++++++++++++++---
 fs/overlayfs/dir.c       |  58 +++++----
 fs/overlayfs/inode.c     |  20 ++-
 fs/overlayfs/namei.c     | 314 +++++++++++++++++++++++++++++++++--------------
 fs/overlayfs/overlayfs.h |  29 ++++-
 fs/overlayfs/ovl_entry.h |   2 +-
 fs/overlayfs/readdir.c   |  48 ++++++--
 fs/overlayfs/super.c     |  28 +++--
 fs/overlayfs/util.c      |  55 ++++++---
 9 files changed, 505 insertions(+), 179 deletions(-)

-- 
2.7.4
