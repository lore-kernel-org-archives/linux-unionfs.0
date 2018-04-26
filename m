Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751588AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 00/31] overlayfs: Delayed copy up of data
Date: Thu, 26 Apr 2018 15:09:42 -0400
Message-Id: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

This is V14 of overlayfs metadata only copy-up feature. These patches I
have rebased on top of Miklos overlayfs-next tree's branch overlayfs-rorw.

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw

Patches are also available here.

https://github.com/rhvgoyal/linux/commits/metacopy-v14

I think it made sense to rebase these patches on top of stacking file
operations. i know Miklos is making some changes to the patches. I will
rebase again once Miklos publishes his changes.

I have run unionmount-testsuite and "./check -overlay -g quick" and that
works. Only 4 overlay tests fail, which fail on vanilla kernel too.

Changes from V13.
- Rebased on top of overlayfs-rorw branch and made changes to deal with
  stacking file operations.

- Primarily took care of Amir's comments from V13.

- Dropped support for removing REDIRCT when metacopy file is data copied
  up.

- Dropped all the extra inode locking around redirects. I don't think
  any extra locking is required as of now. Put a rationale for my
  thinking in commit message of patch with following subject.

  "ovl: Set redirect on upper inode when it is linked" 

- Finally did not move setting redirect before lock_rename(), as there
  did not seem to be a need for extra locking so no issues with lock
  ordering, hence no need to move setting redirect before lock_rename.

Any feedback is welcome.

Overview
--------
Metadata only copy up allows for copying up of only metadata and data 
is copied up later when file is opened for WRITE operation. This seems
to have couple of use cases.

- Provide reflink like functionality for overlay filesystem.
- Make full container image chown operations faster.

I am especially interested in second use case at this point of time
where I want to chown container images fast and shift them for the user
namespace container is going to run in.

Thanks
Vivek

Vivek Goyal (31):
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
  ovl: Always open file/inode which contains data and not metacopy
  ovl: Do not expose metacopy only dentry from d_real()
  ovl: Move some dir related ovl_lookup_single() code in else block
  ovl: Check redirects for metacopy files
  ovl: Treat metacopy dentries as type OVL_PATH_MERGE
  ovl: Add an inode flag OVL_CONST_INO
  ovl: Do not set dentry type ORIGIN for broken hardlinks
  ovl: Set redirect on metacopy files upon rename
  ovl: Set redirect on upper inode when it is linked
  ovl: Check redirect on index as well
  ovl: Allow ovl_open_realfile() to open metacopy inode
  ovl: Issue fsync on upper metacopy inode as well
  ovl: Disbale metacopy for MAP_SHARED mmap()
  ovl: Do not do metadata only copy-up for truncate operation
  ovl: Do not do metacopy only for ioctl modifying file attr
  ovl: Enable metadata only feature

 Documentation/filesystems/overlayfs.txt |  30 +++-
 fs/overlayfs/Kconfig                    |  19 +++
 fs/overlayfs/copy_up.c                  | 156 +++++++++++++++-----
 fs/overlayfs/dir.c                      |  74 +++++++---
 fs/overlayfs/export.c                   |   6 +-
 fs/overlayfs/file.c                     |  65 +++++++--
 fs/overlayfs/inode.c                    | 113 +++++++++------
 fs/overlayfs/namei.c                    | 144 ++++++++++++++-----
 fs/overlayfs/overlayfs.h                |  34 ++++-
 fs/overlayfs/ovl_entry.h                |   2 +
 fs/overlayfs/super.c                    |  53 ++++++-
 fs/overlayfs/util.c                     | 246 +++++++++++++++++++++++++++++++-
 12 files changed, 782 insertions(+), 160 deletions(-)

-- 
2.13.6

