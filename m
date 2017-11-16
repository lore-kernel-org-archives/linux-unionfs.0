From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH v7 00/14] overlayfs: Delayed copy up of data
Date: Thu, 16 Nov 2017 17:03:21 -0500
Message-ID: <20171116220335.13448-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935965AbdKPWDo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2017 17:03:44 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: vgoyal@redhat.com, amir73il@gmail.com, miklos@szeredi.hu

Hi,

Here is the V7 of the patches. These patches apply on top of
overlayfs-next branch of miklos's tree.

I have taken care of most of the comments from previous iteration.

These patches are very lightly tested. First I want to make sure that I
have addressed all design concerns. Once that is done, will do more
extensive testing.

Following are changes from V6.

- Cherry picked Amir's patch to disable redirect_dir and index feature
  if upper does not support xattr. 
- Disable metacopy if upper does not support xattr.
- Merged encryption and compression patch.
- Merged barriers patch into core patch.
- Now OVL_UPPERDATA is set for all kind of dentries. Read side of 
  OVL_UPPERDATA first checks whether dentry in question should have
  this flag set or not.  
- Now smp_rmb() is called only when checking OVL_UPPERDATA from lockless
  path. 
- Miscellaneous code cleanus as asked by Amir.

Original Description
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

Amir Goldstein (1):
  ovl: disable redirect_dir and index when no xattr support

Vivek Goyal (13):
  ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
  ovl: Create origin xattr on copy up for all files
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: During copy up, first copy up metadata and then data
  ovl: Move couple of copy up functions in copy_up.c
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Add helper ovl_already_copied_up()
  ovl: A new xattr OVL_XATTR_METACOPY for file on upper
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Set OVL_UPPERDATA flag during ovl_lookup()
  ovl: Do not expose metacopy only upper dentry from d_real()
  ovl: Fix encryption/compression status of a metacopy only file
  ovl: Enable metadata only feature

 fs/overlayfs/Kconfig     |   8 +++
 fs/overlayfs/copy_up.c   | 161 ++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/dir.c       |   1 +
 fs/overlayfs/inode.c     |  58 ++++++++---------
 fs/overlayfs/namei.c     |  40 ++++++++++++
 fs/overlayfs/overlayfs.h |   9 ++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/super.c     |  61 ++++++++++++++++--
 fs/overlayfs/util.c      | 107 +++++++++++++++++++++++++++----
 9 files changed, 352 insertions(+), 94 deletions(-)

-- 
2.13.6
