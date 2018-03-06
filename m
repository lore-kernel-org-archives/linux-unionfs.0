Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 00/17] overlayfs: Delayed copy up of data
Date: Tue,  6 Mar 2018 15:53:51 -0500
Message-Id: <20180306205408.23383-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

Here are V12 of the metadata only copy up patches. 

Patches are also available here.

https://github.com/rhvgoyal/linux/tree/metacopy-v12

Changes from V11:

- Rebased on latest kernel
- Follow metacopy source using REDIRECT instead of ORIGIN
- Support metacopy xattr in mid layer.

Please have a look.

Amir, few patches have changed and you might have to look at it
again.

Also, I have disabled metacopy support when nfs_export=on. I am not
sure if I can make it work for nfs_export easily or not. Will need
to spend more time understanding nfs_export stuff.

Thanks
Vivek

Vivek Goyal (17):
  ovl: redirect_dir=nofollow can follow redirect for opaque lower
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Move the copy up helpers to copy_up.c
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Modify ovl_lookup() and friends to lookup metacopy dentry
  ovl: Do not mark a non dir as _OVL_PATH_MERGE in ovl_path_type()
  ovl: Copy up meta inode data from lowest data inode
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Do not expose metacopy only upper dentry from d_real()
  ovl: Check redirects for metacopy files
  ovl: Set redirect on metacopy files upon rename
  ovl: Remove redirect when data of a metacopy file is copied up
  ovl: Set redirect on upper inode when it is linked
  ovl: Enable metadata only feature

 Documentation/filesystems/overlayfs.txt |  30 +++++-
 fs/overlayfs/Kconfig                    |  17 ++++
 fs/overlayfs/copy_up.c                  | 165 +++++++++++++++++++++++++-------
 fs/overlayfs/dir.c                      |  32 +++++--
 fs/overlayfs/export.c                   |   3 +
 fs/overlayfs/inode.c                    |  49 ++++------
 fs/overlayfs/namei.c                    | 142 +++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h                |  22 ++++-
 fs/overlayfs/ovl_entry.h                |   1 +
 fs/overlayfs/super.c                    |  62 +++++++++++-
 fs/overlayfs/util.c                     | 138 +++++++++++++++++++++++++-
 11 files changed, 554 insertions(+), 107 deletions(-)

-- 
2.13.6
