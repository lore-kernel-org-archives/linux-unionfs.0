From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH v6 00/15] overlayfs: Delayed copy up of data
Date: Thu,  9 Nov 2017 15:50:04 -0500
Message-ID: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754202AbdKIUuf (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:35 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

Hi,

Here is the V6 of patches. I have taken care of most of the comments
from previous iteration and also rebased patches to overlayfs-next
branch of miklos's tree.

These patches are still in RFC stage and very lightly tested. First
I want to make sure that I have addressed all design concerns. Once that
is done, will do more extensive testing.

Following are changes from V5.

- Rebased on top of overlafs-next branch
- Fixed races in ovl_getattr() w.r.t metacopy only file.
- Fixed issues related to encryped and compressed files in ovl_getattr() 
- Added bunch of helper functions so that code is little more clean.
- Miscellaneous code cleanup as suggested by Amir.

Amir, I am still setting UPPERDATA only if file needs it. I am really
not convinced that we should do it for all files. Code is not that
much extra. Please have another look and see how do you feel about it
now.

Vivek

Vivek Goyal (15):
  ovl: Create origin xattr on copy up for all files
  ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Set OVL_UPPERDATA flag during ovl_lookup()
  ovl: Return lower dentry if only metadata copy up took place
  ovl: Do not expose metacopy only upper dentry
  ovl: Fix encryption status of a metacopy only file
  ovl: Fix compression status of a metacopy only file
  ovl: Introduce read/write barriers around metacopy flag update
  ovl: Enable metadata only feature

 fs/overlayfs/Kconfig     |   8 ++++
 fs/overlayfs/copy_up.c   | 115 +++++++++++++++++++++++++++++------------------
 fs/overlayfs/inode.c     |  35 +++++++++++++--
 fs/overlayfs/namei.c     |  40 +++++++++++++++++
 fs/overlayfs/overlayfs.h |   9 +++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/super.c     |  61 ++++++++++++++++++++++---
 fs/overlayfs/util.c      | 107 ++++++++++++++++++++++++++++++++++++++-----
 8 files changed, 311 insertions(+), 65 deletions(-)

-- 
2.13.6
