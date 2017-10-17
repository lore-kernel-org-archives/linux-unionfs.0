From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 00/11][V4] overlayfs: Delayed copy up of data
Date: Tue, 17 Oct 2017 17:05:47 -0400
Message-ID: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760989AbdJQVG1 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 17:06:27 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Hi,

This is V4 of the patches. Changes from V3 are as follows.

This patch series applies on top of Amir's patch to not return -EIO and
allows me to create ORIGIN for hardlinks even if index=off.

- Got rid of dependency on index=on/off. (Amir)
- Re-introduced patch to create ORIGIN for hardlink copy up even if
  index=off. 
- Gor rid of helpers around new barriers and open coded these. It will
  atleast help to see what I am trying to achieve. (Amir).
- Got rid of boolean set_size (Amir)
- Reorganized some code (Amir)
- Renamed ovl_copy_up_data_inode() function. (Amir).

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

Vivek Goyal (11):
  ovl: Create origin xattr on copy up for all files
  ovl: ovl_check_setxattr() get rid of redundant -EOPNOTSUPP check
  ovl: During copy up, first copy up metadata and then data
  ovl: Provide a mount option metacopy=on/off for metadata copyup
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Set xattr OVL_XATTR_METACOPY on upper file
  ovl: Fix ovl_getattr() to get number of blocks from lower
  ovl: Set OVL_METACOPY flag during ovl_lookup()
  ovl: Return lower dentry if only metadata copy up took place
  ovl: Introduce read/write barriers around metacopy flag update
  ovl: Put barriers to order oi->__upperdentry and OVL_METACOPY update

 fs/overlayfs/Kconfig     |   8 ++++
 fs/overlayfs/copy_up.c   | 113 ++++++++++++++++++++++++++++++++++++-----------
 fs/overlayfs/inode.c     |  17 ++++++-
 fs/overlayfs/namei.c     |  40 +++++++++++++++++
 fs/overlayfs/overlayfs.h |   5 ++-
 fs/overlayfs/ovl_entry.h |   1 +
 fs/overlayfs/super.c     |  48 ++++++++++++++++++--
 fs/overlayfs/util.c      |  46 ++++++++++++++-----
 8 files changed, 235 insertions(+), 43 deletions(-)

-- 
2.13.5
