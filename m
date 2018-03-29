Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 00/28] overlayfs: Delayed copy up of data
Date: Thu, 29 Mar 2018 15:38:26 -0400
Message-Id: <20180329193854.13814-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

Here are the V13 of metadata only copy up patches.

These apply on top of 4.16.0-rc7 kernel + "ovl: Bunch of ovl_lookup() path fixes" patch series.

Patches are also available here.

https://github.com/rhvgoyal/linux/commits/metacopy-v13

Changes from V12:

- Primarily took care of Amir's comments.
- Redirects are now placed on regular file also and that opened bunch
  of races. Fixed those issues.
- Posted few ovl_lookup() fixes and rebased these patches on top of
  the fixes. ("ovl: Bunch of ovl_lookup() path fixes")
- Now metacopy file with upper is also marked as OVL_TYPE_MERGED and
  rename code makes use of that assumption. (Suggested by Amir).
- Fixed an issue where OVL_TYPE_ORIGIN was being set even for broken
  hardlinks with metacopy.
- Fixed races w.r.t remove redirect path.
- During rename, set relative redirect if nlink=1, otherwise set
  absolute redirect on metacopy files.

Any comments and feedback is welcome.

Thanks
Vivek

Vivek Goyal (28):
  ovl: Set OVL_INDEX flag in ovl_get_inode()
  ovl: Initialize ovl_inode->redirect in ovl_get_inode()
  ovl: Rename local variable locked to new_locked
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Move the copy up helpers to copy_up.c
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Modify ovl_lookup() and friends to lookup metacopy dentry
  ovl: Copy up meta inode data from lowest data inode
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Add helper ovl_dentry_lowerdata() to get lower data dentry
  ovl: Do not expose metacopy only dentry from d_real()
  ovl: Move some of ovl_nlink_start() functionality in ovl_nlink_prep()
  ovl: Create locked version of ovl_nlink_start() and ovl_nlink_end()
  ovl: During rename lock both source and target ovl_inode
  ovl: Check redirects for metacopy files
  ovl: Treat metacopy dentries as type OVL_PATH_MERGE
  ovl: Do not set dentry type ORIGIN for broken hardlinks
  ovl: Set redirect on metacopy files upon rename
  ovl: Set redirect on upper inode when it is linked
  ovl: Remove redirect when data of a metacopy file is copied up
  ovl: Do not error if REDIRECT XATTR is missing
  ovl: Use out_err insteada of out_nomem
  ovl: Re-check redirect xattr during inode initialization
  ovl: Verify a data dentry has been found for metacopy inode
  ovl: Enable metadata only feature

 Documentation/filesystems/overlayfs.txt |  30 +++-
 fs/overlayfs/Kconfig                    |  19 +++
 fs/overlayfs/copy_up.c                  | 165 +++++++++++++++----
 fs/overlayfs/dir.c                      | 166 ++++++++++++++++---
 fs/overlayfs/export.c                   |   7 +-
 fs/overlayfs/inode.c                    | 140 +++++++++++-----
 fs/overlayfs/namei.c                    | 121 ++++++++++----
 fs/overlayfs/overlayfs.h                |  30 +++-
 fs/overlayfs/ovl_entry.h                |   1 +
 fs/overlayfs/super.c                    |  62 ++++++-
 fs/overlayfs/util.c                     | 281 +++++++++++++++++++++++++++++---
 11 files changed, 861 insertions(+), 161 deletions(-)

-- 
2.13.6
