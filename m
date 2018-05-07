Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 00/30] overlayfs: Delayed copy up of data
Date: Mon,  7 May 2018 13:40:32 -0400
Message-Id: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

This is V15 of overlayfs metadata only copy-up feature. These patches I
have rebased on top of Miklos overlayfs-next tree's branch overlayfs-rorw.

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw

Patches are also available here.

https://github.com/rhvgoyal/linux/commits/metacopy-v15

I have run unionmount-testsuite and "./check -overlay -g quick" and that
works. Only 4 overlay tests fail, which fail on vanilla kernel too.

Changes from V14:

- Rebased on top of latest overlayfs-rorw branch.
- Took care of amir's comments on V14.
- Started passing arguments to ovl_get_inode() in a structure, as
  argument list was getting too long.
- Simplified ovl_fsync() and helper patches a bit.
- unioned new field lowerdata with dir cache. 
- Renamed few helper functions with suffix _realdata instead of
- Renamed ovl_rel_redirect() to ovl_need_absolute_redirect() and also
  now started calling it from ovl_set_redirect() instead of calling
  from ovl_reaname() directly.
- Added argument padding to ovl_get_redirect_xattr() and reused this
  function in ovl_check_redirect().
- Added a helper funciton ovl_copy_up_with_data() to force full copy
  up (metadata plus data).

Thanks
Vivek

Vivek Goyal (30):
  ovl: Pass argument to ovl_get_inode() in a structure
  ovl: Initialize ovl_inode->redirect in ovl_get_inode()
  ovl: Move the copy up helpers to copy_up.c
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Use out_err instead of out_nomem
  ovl: Modify ovl_lookup() and friends to lookup metacopy dentry
  ovl: Copy up meta inode data from lowest data inode
  ovl: Add helper ovl_dentry_lowerdata() to get lower data dentry
  ovl: Add an helper to get real data dentry
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Store lower data inode in ovl_inode
  ovl: Add helper ovl_inode_real_data()
  ovl: Open file with data except for the case of fsync
  ovl: Do not expose metacopy only dentry from d_real()
  ovl: Move some dir related ovl_lookup_single() code in else block
  ovl: Check redirects for metacopy files
  ovl: Treat metacopy dentries as type OVL_PATH_MERGE
  ovl: Add an inode flag OVL_CONST_INO
  ovl: Do not set dentry type ORIGIN for broken hardlinks
  ovl: Set redirect on metacopy files upon rename
  ovl: Set redirect on upper inode when it is linked
  ovl: Check redirect on index as well
  ovl: Disbale metacopy for MAP_SHARED mmap()
  ovl: Do not do metadata only copy-up for truncate operation
  ovl: Do not do metacopy only for ioctl modifying file attr
  ovl: Enable metadata only feature

 Documentation/filesystems/overlayfs.txt |  30 +++-
 fs/overlayfs/Kconfig                    |  19 +++
 fs/overlayfs/copy_up.c                  | 161 ++++++++++++++++-----
 fs/overlayfs/dir.c                      |  85 ++++++++---
 fs/overlayfs/export.c                   |   8 +-
 fs/overlayfs/file.c                     |  53 ++++---
 fs/overlayfs/inode.c                    | 131 ++++++++++-------
 fs/overlayfs/namei.c                    | 199 ++++++++++++++++---------
 fs/overlayfs/overlayfs.h                |  36 ++++-
 fs/overlayfs/ovl_entry.h                |  16 +-
 fs/overlayfs/super.c                    |  60 +++++++-
 fs/overlayfs/util.c                     | 249 +++++++++++++++++++++++++++++++-
 12 files changed, 829 insertions(+), 218 deletions(-)

-- 
2.13.6
