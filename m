From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH v8 00/15] overlayfs: Delayed copy up of data
Date: Tue, 28 Nov 2017 10:59:44 -0500
Message-ID: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754008AbdK1QAP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:15 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Hi,

Here is the V8 of the patches. Primarily I have taken care of comments
from Amir.

This applies on top of the fix I posted with subject "ovl: Pass
ovl_get_nlink() parameters in right order"

Amir, I have added one more patch int series where I pass index dentry
to ovl_get_nlink() to get rid of a warning during testing.

I think only outstanding concern with this patch series now is how to
detect that metacopy feature was ever enabled and there are some
metacopy only files present. In that case we probably don't want to
allow user to mount with metacopy=off. We currently don't seem to have
a generic infrastructure which keeps track of features and backward
compatibility stuff etc. Discussion still seems to be on upstream.

Is this a blocker for this patch series or this is something we can
live with? Only downside of mounting a file system which has metacopied
files (with metacopy=off), is that user will see truncated files.

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

 fs/overlayfs/Kconfig     |   8 +++
 fs/overlayfs/copy_up.c   | 162 ++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/dir.c       |   1 +
 fs/overlayfs/inode.c     |  65 +++++++++----------
 fs/overlayfs/namei.c     |  42 +++++++++++-
 fs/overlayfs/overlayfs.h |  20 +++++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/super.c     |  62 ++++++++++++++++--
 fs/overlayfs/util.c      | 100 +++++++++++++++++++++++++----
 9 files changed, 363 insertions(+), 98 deletions(-)

-- 
2.13.6
