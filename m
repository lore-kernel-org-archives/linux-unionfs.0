From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 00/18] overlayfs: Delayed copy up of data
Date: Mon, 22 Jan 2018 13:39:46 -0500
Message-ID: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751113AbeAVSkN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:13 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Hi,

Please find attached V10 of the metadata only copy up patches. I think
I have taken care of review comments and I will start writing automated
test cases now.

One thing which concerns me about these patches is the fact that during
file open d_real() will return lower inode which actually contains file
data and that inode will be installed in f->f_inode. So while f->f_inode
is perfectly fine for data operations, it is not fine for metadata
operations. Because metadata has been copied up and is represented by
a different inode.

I am concerned that this is a subtle behavior change and especially
security modules might be surprised by it. I will spend now more time
looking at what security modules are doing with f->f_inode. Thoughts?

Amir, some new patches have been added in series due to metacopy inode
support in midlayer. And some existing patches have changed. You
probably will have to look at existing Reviewd-by patches too.

Changes since V9:

- Added support for metacopy inode in midlayer.
- Added documentation for metadata only copy up.
- Stopped following metacopy origin if metacopy is not enabled. This is
  due to possible security concerns.
- Dropped a patch to do union of encryption and compression attributes
  of lower and upper. Doing union seemed wrong.
- Dropped a patch to get rid of -EOPNOTSUPP check in
  ovl_check_setxattr(). Looks like both Amir and Miklos wanted to retain
  that check and warn if unexpctedly upper returned -EOPNOTSUPP at a
  later time while checks were fine during mount time.

Any review comment/feedback is welcome.

Vivek

Amir Goldstein (1):
  ovl: disable redirect_dir and index when no xattr support

Vivek Goyal (17):
  ovl: Do not look for OVL_XATTR_NLINK if index is not there
  ovl: Create origin xattr on copy up for all files
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Move the copy up helpers to copy_up.c
  ovl: Add mechanism to create a chain of origin dentries
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Set OVL_UPPERDATA flag during ovl_lookup()
  ovl: Setup origin chain for lower regular files
  ovl: Check metacopy attributes on a chain of origin
  ovl: Do not mark a non dir as _OVL_PATH_MERGE in ovl_path_type()
  ovl: Copy up meta inode data from lowest data inode
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Do not expose metacopy only upper dentry from d_real()
  ovl: Enable metadata only feature

 Documentation/filesystems/overlayfs.txt |  54 +++++++---
 fs/overlayfs/Kconfig                    |  15 +++
 fs/overlayfs/copy_up.c                  | 172 +++++++++++++++++++++---------
 fs/overlayfs/dir.c                      |   1 +
 fs/overlayfs/inode.c                    |  60 ++++-------
 fs/overlayfs/namei.c                    | 181 ++++++++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h                |  24 ++++-
 fs/overlayfs/ovl_entry.h                |   2 +
 fs/overlayfs/super.c                    |  64 +++++++++--
 fs/overlayfs/util.c                     | 143 ++++++++++++++++++++++++-
 10 files changed, 583 insertions(+), 133 deletions(-)

-- 
2.13.6
