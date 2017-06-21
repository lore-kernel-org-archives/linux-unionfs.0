From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 00/25] Overlayfs inodes index
Date: Wed, 21 Jun 2017 15:28:31 +0300
Message-ID: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34971 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFUM2m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:28:42 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This is it.
All done on my end, so unless you have any rejects that you want me
to fix, you may start mangling.

I've added another xfstest for nlink accounting and may add another
one that mangles with lower hardlinks to get negative overlay nlink.
It's a behavior I observed with lower/upper stress xfstest overlay/019
and fixed in patch 25.

Given the state of affairs with consistent d_ino patches, I suggest that
we focus on herding the inode index patches towards linux-next before
anything else.

Thanks,
Amir.


This work introduces the inodes index opt-in feature, which provides:
- Hardlinks are not broken on copy up
- Infrastructure for overlayfs NFS export

The work is available on my ovl-hardlinks.v4 branch [1].
For the curious, documentation about how overlay NFS export would work
with the inodes index is available in the linked commit [2].

The most significant change w.r.t. vfs is that with inodes index,
overlay inodes are hashed and unique throughout the lifecycle of an
overlay object (i.e. across copy up). This is required for not breaking
hardlinks on copy up.

Hardlink copy up tests including coverage for concurrent copy up of
lower hardlinks, lower/upper hardlinks consistency and union nlink
accounting are available on my xfstests dev branch [3].

This work also fixes constant st_ino for samefs case for lower hardlinks,
so the few constant st_ino tests that fail on v4.12-rc1 due to copy up of
lower hardlinks now pass [3][4].

Changes since v3:
- Persistent overlay nlink accounting
- Cleanup index when overlay nlink drops to zero
- Cleanup stale and orphan index entries on mount
- Update documentation w.r.t inodes index feature

Changes v1..v2:
- Introduce ovl_inode and ovl_inode mutex
- Synchronize copy up with ovl_inode mutex
- Don't store index dentry in overlay dentry
- Consistency of lower/upper hardlinks by link-up on lookup
- Preemptive copy up before lower hardlink unlink

[1] https://github.com/amir73il/linux/commits/ovl-hardlinks.v4
[2] https://github.com/amir73il/linux/commits/ovl-nfs-export 
[3] https://github.com/amir73il/xfstests/commits/overlayfs-devel
[4] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel


Amir Goldstein (25):
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
  ovl: cleanup bad and stale index entries on mount
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
  ovl: persistent overlay inode nlink for indexed inodes
  ovl: cleanup orphan index entries

 Documentation/filesystems/overlayfs.txt |   6 +-
 fs/inode.c                              |  50 +++
 fs/overlayfs/Kconfig                    |  20 +
 fs/overlayfs/copy_up.c                  | 625 +++++++++++++++++++++++++-------
 fs/overlayfs/dir.c                      | 164 ++++++++-
 fs/overlayfs/inode.c                    | 160 +++++++-
 fs/overlayfs/namei.c                    | 382 ++++++++++++++++---
 fs/overlayfs/overlayfs.h                |  47 ++-
 fs/overlayfs/ovl_entry.h                |  37 +-
 fs/overlayfs/readdir.c                  |  50 +++
 fs/overlayfs/super.c                    | 286 +++++++++++++--
 fs/overlayfs/util.c                     | 164 +++++++--
 include/linux/fs.h                      |  14 +
 13 files changed, 1723 insertions(+), 282 deletions(-)

-- 
2.7.4
