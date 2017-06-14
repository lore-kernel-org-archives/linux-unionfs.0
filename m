From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 00/23] Overlayfs inodes index
Date: Wed, 14 Jun 2017 10:26:19 +0300
Message-ID: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33703 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754021AbdFNH0f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:35 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

I've made all the changes we discussed on v2 review and now all
upper/lower hardlinks are consistent. Note that I chose to invalidate
lower indexed dentries instead of updating all aliases on first copy up
(patch 21). That seemed simpler to me. Please let me know if you see any
culprit with that approach. I also re-introduced ovl_update_type()
(patch 8) for easier and more compact storing of the INDEX type flag.

The remaining work on persistent nlink accounting and orphan index
cleanup is left for a differnt posting. Without that complementary work,
the index entries will remain forever. I am not aware of any other
culprit or correctness issues that may arrise from lack of index cleanup.

This work introduces the inodes index opt-in feature, which provides:
- Hardlinks are not broken on copy up
- Infrastructure for overlayfs NFS export

The work is available on my ovl-hardlinks branch [1].
For the curious, documentation about how overlay NFS export would work
with the inodes index is available in the linked commit [2].

The most significant change w.r.t. vfs is that with inodes index,
overlay inodes are hashed and unique throughout the lifecycle of an
overlay object (i.e. across copy up). This is required for not breaking
hardlinks on copy up.

Hardlink copy up tests including coverage for concurrent copy up of
lower hardlinks and lower/upper hardlinks consistency are available on
my xfstests dev branch [3].

This work also fixes constant st_ino for samefs case for lower hardlinks,
so the few constant st_ino tests that fail on v4.12-rc1 due to copy up of
lower hardlinks now pass [3][4].

Thanks,
Amir.

Changes since v2:
- Introduce ovl_inode and ovl_inode mutex
- Synchronize copy up with ovl_inode mutex
- Don't store index dentry in overlay dentry
- Consistency of lower/upper hardlinks by link-up on lookup
- Preemptive copy up before lower hardlink unlink

TODO:
- Persistent overlay nlink accounting
- Whiteout index when overlay nlink drops to zero
- Cleanup stale and orphan index entries on mount
- Document the inodes index feature

[1] https://github.com/amir73il/linux/commits/ovl-hardlinks
[2] https://github.com/amir73il/linux/commits/ovl-nfs-export 
[3] https://github.com/amir73il/xfstests/commits/overlayfs-devel
[4] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

Amir Goldstein (23):
  vfs: introduce inode 'inuse' lock
  ovl: get exclusive ownership on upper/work dirs
  ovl: relax same fs constrain for ovl_check_origin()
  ovl: generalize ovl_create_workdir()
  ovl: introduce the inodes index dir feature
  ovl: verify upper root dir matches lower root dir
  ovl: verify index dir matches upper dir
  ovl: store path type in dentry
  ovl: cram dentry state booleans into type flags
  ovl: lookup index entry for copy up origin
  ovl: allocate an ovl_inode struct
  ovl: store upper/lower real inode in ovl_inode_info
  ovl: use ovl_inode_init() for initializing new inode
  ovl: hash overlay non-dir inodes by copy up origin inode
  ovl: defer upper dir lock to tempfile link
  ovl: factor out ovl_copy_up_inode() helper
  ovl: generalize ovl_copy_up_locked() using actors
  ovl: generalize ovl_copy_up_one() using actors
  ovl: use ovl_inode mutex to synchronize concurrent copy up
  ovl: implement index dir copy up method
  ovl: link up indexed lower hardlink on lookup
  ovl: fix nlink leak in ovl_rename()
  ovl: adjust overlay inode nlink for indexed inodes

 fs/inode.c               |  50 ++++
 fs/overlayfs/Kconfig     |  20 ++
 fs/overlayfs/copy_up.c   | 592 +++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/dir.c       |  50 +++-
 fs/overlayfs/inode.c     |  68 +++++-
 fs/overlayfs/namei.c     | 283 ++++++++++++++++++----
 fs/overlayfs/overlayfs.h |  37 +--
 fs/overlayfs/ovl_entry.h |  37 ++-
 fs/overlayfs/super.c     | 308 +++++++++++++++++++++---
 fs/overlayfs/util.c      | 164 ++++++++++---
 include/linux/fs.h       |  14 ++
 11 files changed, 1356 insertions(+), 267 deletions(-)

-- 
2.7.4
