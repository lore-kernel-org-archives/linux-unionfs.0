From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 00/28] overlayfs: Delayed copy up of data
Date: Tue, 29 May 2018 16:45:44 +0200
Message-ID: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

In one of the recent converstions, people mentioned that chown/chmod
lead to copy up files as well as data. We could optimize it so that
only metadata is copied up during chown/chmod and data is copied up when
file is opened for WRITE.

This optimization potentially could be useful with containers and user
namespaces. In popular scenario, people end up doing chown() on whole
image directory tree based on container mappings. And this chown copies
up everything, breaking sharing of page cache between containers.

With these patches, only metadat is copied up during chown() and if file
is opened for READ, d_real() returns lower dentry/inode. That way,
different containers can still continue to use page cache. That's the
use case I have in mind.

---
Vivek Goyal (28):
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
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Store lower data inode in ovl_inode
  ovl: Add helper ovl_inode_realdata()
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
 fs/overlayfs/copy_up.c                  | 160 ++++++++++++++++-----
 fs/overlayfs/dir.c                      |  74 +++++++---
 fs/overlayfs/export.c                   |   3 +
 fs/overlayfs/file.c                     |  43 ++++--
 fs/overlayfs/inode.c                    | 112 +++++++++------
 fs/overlayfs/namei.c                    | 195 ++++++++++++++++----------
 fs/overlayfs/overlayfs.h                |  33 ++++-
 fs/overlayfs/ovl_entry.h                |   6 +-
 fs/overlayfs/super.c                    |  62 +++++++-
 fs/overlayfs/util.c                     | 241 +++++++++++++++++++++++++++++++-
 12 files changed, 780 insertions(+), 198 deletions(-)

-- 
2.14.3
