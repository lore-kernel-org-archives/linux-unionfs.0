From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/5] overlayfs upperdir/workdir verifications
Date: Thu,  1 Jun 2017 20:01:49 +0300
Message-ID: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32958 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdFARBp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 13:01:45 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This patch set is a prelude to the index dir feature, which
requires origin verification w.r.t. upperdir.  I will follow
up with the posting of index dir feature soon.

This work prevents:
1. Concurrent overlay mounts with same upperdir/workdir
2. Reuse of upperdir with different lowerdir
3. Merge lower dir that doesn't match upper dir origin

For backward compat with existing setups that copy layers, the
checks 2-3 above depend on a new mount option (-o verify_lower).
The same mount option is going to determine whether an index dir
that doesn't match upper dir is blown away or fails the mount.

I have another dir verification patch that decodes origin dir on
failure to verify lower dir, which I am using for snapshots and
is going to be needed for NFS export. Because those features are
not proposed for v4.13 I left out the patch from this posting.

The verify_lower mount option can be tested with my unionmount-testsuite
development branch [1].  I had to fix the mount cycling test (run --ov=N)
not to reuse the same workdir with new rotated upperdir, because reusing
workdir with different upperdir breaks the origin verification for the
persistent index dir.

[1] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

Amir Goldstein (5):
  vfs: introduce inode 'inuse' lock
  ovl: get exclusive ownership on upper/work dirs
  ovl: add support for verify_lower mount option
  ovl: verify lower root dir by file handle
  ovl: document the 'verify_lower' feature

 Documentation/filesystems/overlayfs.txt |  48 +++++++++++++
 fs/inode.c                              |  50 ++++++++++++++
 fs/overlayfs/copy_up.c                  |  16 +++--
 fs/overlayfs/namei.c                    |  95 ++++++++++++++++++++++---
 fs/overlayfs/overlayfs.h                |  18 +++++
 fs/overlayfs/ovl_entry.h                |   4 ++
 fs/overlayfs/super.c                    | 118 +++++++++++++++++++++++++++++++-
 fs/overlayfs/util.c                     |   7 ++
 include/linux/fs.h                      |  15 ++++
 9 files changed, 351 insertions(+), 20 deletions(-)

-- 
2.7.4
