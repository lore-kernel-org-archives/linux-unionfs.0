From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/8][V2] overlayfs: Delayed copy up of data
Date: Fri,  6 Oct 2017 13:47:09 -0400
Message-ID: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751862AbdJFRrX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:47:23 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Hi,

Please find attached V2 of patches. I think I have taken care of
feedback from V1. Changes from V1 are as follows.

- Made metacopy up feature dependent on index=on.
- Added a patch to provide kernel config option, module option and mount
  option to enable metadata copyup feature.
- Now I am copying up size from lower when metadata only copyup takes
  place.
- I am returning -ESTALE in ovl_lookup() if an inode as METACOPY xattr
  but can find/resolve associated origin.
- Calling ovl_set_attr() after metadata copyup so that mtime on lower
  and upper are same.

I have little concern about access to METACOPY flag of inode stored in
ovl_inode. We are accessing this flag in lockless manner from reader
side and updating this flag under a mutex. My understanding is that
current code will make sure that user will see this flag set only after
METACOPY XATTR has been set (and not before that). Following is code
flow.

ovl_check_setxattr(OVL_XATTR_METACOPY)
smp_wmb(); (From ovl_inode_update())
ovl_set_flag(OVL_METACOPY, d_inode(c->dentry))

But there is no lockless_deference() call while checking this flag in
ovl_test_flag(). So I have two questions. Is this sufficient? And is
this too subtle and prone to breakage.

-------------------

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

Basically, I am relying on storing OVL_XATTR_ORIGIN in upper inode
during copy up. I use that information to get to lower inode later and
do data copy up when necessary.

I also store OVL_XATTR_METACOPY in upper inode to mark that only
metadata has been copied up and data copy up still might be required.

Any feedback is helpful.

Vivek Goyal (8):
  ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
  ovl: During copy up, first copy up metadata and then data
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Set xattr OVL_XATTR_METACOPY on upper file
  ovl: Set OVL_METACOPY flag during ovl_lookup()
  ovl: Return lower dentry if only metadata copy up took place
  ovl: Fix ovl_getattr() to get number of blocks from lower

 fs/overlayfs/Kconfig     |   9 ++++
 fs/overlayfs/copy_up.c   | 115 ++++++++++++++++++++++++++++++++++++++---------
 fs/overlayfs/inode.c     |  21 +++++++--
 fs/overlayfs/namei.c     |  38 ++++++++++++++++
 fs/overlayfs/overlayfs.h |   5 ++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/super.c     |  36 +++++++++++++++
 fs/overlayfs/util.c      |  32 ++++++++-----
 8 files changed, 219 insertions(+), 38 deletions(-)

-- 
2.13.5
