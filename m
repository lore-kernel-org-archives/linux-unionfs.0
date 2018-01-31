From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 00/18] overlayfs: Delayed copy up of data
Date: Wed, 31 Jan 2018 16:13:11 -0500
Message-ID: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbeAaVNm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:42 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Hi,

Please find attached V11 of patches. Looks like now new design might
change these patches significantly based on Miklos's feedback. So I
am posting my latest patches based on current design. Just in case we
decide that we want to stick to old design.

Change from V10:

- Based on Amir's feedback, I am not storing the full origin chain in
  lowerstack now. Instead now I am storing only two dentries at max in
  lowerstack. lowerstack[0] will point to top most metacopy dentry in
  lower and lowerstack[1] will have data dentry. 

Thanks
Vivek

Amir Goldstein (1):
  ovl: disable redirect_dir and index when no xattr support

Vivek Goyal (17):
  ovl: Do not look for OVL_XATTR_NLINK if index is not there
  ovl: Create origin xattr on copy up for all files
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Move the copy up helpers to copy_up.c
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Set OVL_UPPERDATA flag during ovl_lookup()
  ovl: Allocate bigger stack for origin
  ovl: Get and install lower most data dentry in stack
  ovl: Setup origin chain for lower regular files
  ovl: Do not mark a non dir as _OVL_PATH_MERGE in ovl_path_type()
  ovl: Copy up meta inode data from lowest data inode
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Do not expose metacopy only upper dentry from d_real()
  ovl: Enable metadata only feature

 Documentation/filesystems/overlayfs.txt |  54 +++++++---
 fs/overlayfs/Kconfig                    |  15 +++
 fs/overlayfs/copy_up.c                  | 172 +++++++++++++++++++++++---------
 fs/overlayfs/dir.c                      |   1 +
 fs/overlayfs/inode.c                    |  60 ++++-------
 fs/overlayfs/namei.c                    | 154 +++++++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h                |  24 ++++-
 fs/overlayfs/ovl_entry.h                |   1 +
 fs/overlayfs/super.c                    |  64 ++++++++++--
 fs/overlayfs/util.c                     | 134 ++++++++++++++++++++++++-
 10 files changed, 566 insertions(+), 113 deletions(-)

-- 
2.13.6
