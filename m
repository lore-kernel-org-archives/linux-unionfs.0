From: Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 0/7] overlayfs: Delayed copy up of data
Date: Mon,  2 Oct 2017 09:39:58 -0400
Message-ID: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751085AbdJBNkP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 09:40:15 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Hi,

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
use case I have in mind. I have not tested it though.

So here are very crude RFC patch. I have done bare minimal testing on
these and there are many unaddressed issues I can see. 

Before I go any further, I wanted to send these out for some feedback
and see if I am moving in right direction or this appraoch is completely
broken.

Basically, I am relying on storing OVL_XATTR_ORIGIN in upper inode
during copy up. I use that information to get to lower inode later and
do data copy up when necessary.

I also store OVL_XATTR_METACOPY in upper inode to mark that only
metadata has been copied up and data copy up still might be required.

Any feedback is helpful.

Thanks
Vivek

 
Vivek Goyal (7):
  Create origin xattr on copy up for all files
  ovl: During copy up, first copy up metadata and then data
  ovl: Copy up only metadata during copy up where it makes sense
  ovl: Set xattr OVL_XATTR_METACOPY on upper file
  ovl: Set OVL_METACOPY flag during ovl_lookup()
  ovl: Return lower dentry if only metadata copy up took place
  ovl: Fix ovl_getattr() to get size from lower

 fs/overlayfs/copy_up.c   | 87 +++++++++++++++++++++++++++++++++++++-----------
 fs/overlayfs/inode.c     | 13 +++++++-
 fs/overlayfs/namei.c     | 34 +++++++++++++++++++
 fs/overlayfs/overlayfs.h |  5 ++-
 fs/overlayfs/super.c     |  4 +++
 fs/overlayfs/util.c      | 21 ++++++++++--
 6 files changed, 140 insertions(+), 24 deletions(-)

-- 
2.13.5
