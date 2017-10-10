From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/9][V3] overlayfs: Delayed copy up of data
Date: Tue, 10 Oct 2017 11:32:15 -0400
Message-ID: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932241AbdJJPci (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2017 11:32:38 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com, ebiederm@xmission.com

Hi,

This is V3 of patches.

Changes from V2:

- Got rid of boolean in ovl_getattr(). This will be changed again once
  chandan's patches are merged (Amir).

- Moved index=on check much later in ovl_fill_super(). (Amir)

- Fixed an inode leak in case of returning -ESTALE.

- Added another patch to add read and write barrier around
  setting/resetting of OVL_METACOPY bit. As we do lockless access in
  ovl_copy_up_flags(), I think without this we can be subject to races.

Original description
--------------------
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

Thanks
Vivek

Vivek Goyal (9):
  ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
  ovl: During copy up, first copy up metadata and then data
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Set xattr OVL_XATTR_METACOPY on upper file
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Introduce read/write barriers around metacopy flag update
  ovl: Set OVL_METACOPY flag during ovl_lookup()
  ovl: Return lower dentry if only metadata copy up took place

 fs/overlayfs/Kconfig     |   9 ++++
 fs/overlayfs/copy_up.c   | 114 ++++++++++++++++++++++++++++++++++++++---------
 fs/overlayfs/inode.c     |  12 ++++-
 fs/overlayfs/namei.c     |  40 +++++++++++++++++
 fs/overlayfs/overlayfs.h |   8 +++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/super.c     |  36 +++++++++++++++
 fs/overlayfs/util.c      |  53 +++++++++++++++++-----
 8 files changed, 237 insertions(+), 36 deletions(-)

-- 
2.13.5
