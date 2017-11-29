From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v9 00/15] overlayfs: Delayed copy up of data
Date: Wed, 29 Nov 2017 10:54:33 -0500
Message-ID: <20171129155448.32721-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933120AbdK2Py6 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 10:54:58 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Hi,

Please find attached V9 of the patches. Minor changes to take care of
Amir's comments. I have also dropped RFC tag. If there are no concerns,
then I would like these patches to be included.

These patches apply on top of overlayfs-next branch plus the fix I posted
with subject "ovl: Pass ovl_get_nlink() parameters in right order"

https://www.spinics.net/lists/stable/msg200902.html

Changes from V8.

- Fixed ovl_get_nlink() to take index as parameter instead of
  upperdentry.

- Ran checkpatch on patches and fixed issues.

- Updated help text of config option OVERLAY_FS_METACOPY
 

Vivek

Amir Goldstein (1):
  ovl: disable redirect_dir and index when no xattr support

Vivek Goyal (14):
  ovl: Do not look for OVL_XATTR_NLINK if index is not there
  ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
  ovl: Create origin xattr on copy up for all files
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Move the copy up helpers to copy_up.c
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Set OVL_UPPERDATA flag during ovl_lookup()
  ovl: Do not expose metacopy only upper dentry from d_real()
  ovl: Fix encryption/compression status of a metacopy only file
  ovl: Enable metadata only feature

 fs/overlayfs/Kconfig     |  15 +++++
 fs/overlayfs/copy_up.c   | 162 ++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/dir.c       |   1 +
 fs/overlayfs/inode.c     |  73 ++++++++++-----------
 fs/overlayfs/namei.c     |  40 ++++++++++++
 fs/overlayfs/overlayfs.h |  21 +++++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/super.c     |  62 ++++++++++++++++--
 fs/overlayfs/util.c      | 105 ++++++++++++++++++++++++++----
 9 files changed, 376 insertions(+), 104 deletions(-)

-- 
2.13.6
