From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/15] VFS: File pinning: pre-script-run fixups
Date: Wed, 25 Mar 2015 14:43:30 +0000
Message-ID: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbbCYOoD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 Mar 2015 10:44:03 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu


Hi Al,

Could you have a look over these patches please?  They can be divided into a
number of subsets:

 (1) A fix for configfs to be consistent about the use of file_inode() vs
     dentry->d_inode within a function.

 (2) Fix various accesses to dentry->d_inode to use d_inode(dentry) where there
     are brackets and things that cause the RE to not match in the scripted
     mass changes.

 (3) Similar to (2), but instances of dentry->d_inode should be changed to
     d_backing_inode(dentry) instead where the code is dealing with someone
     else's dentries and inodes.

 (4) Fix up the chelsio driver to use file_inode() rather than its own wrapper.

 (5) Use d_is_dir() instead of S_ISDIR() where we can.

 (6) Fix up NFS to not use d_inode as a variable name.


 (7) Supply d_really_is_positive/negative() to ignore the dentry type field
     (unlike d_is_positive/negative()) for use in filesystems and pretty much
     anywhere you'd use d_inode() rather than d_backing_inode().

Then there's the last three patches which form a subset.

 (8) Impose a partial ordering on reads and writes of ->d_inode and the type
     field in ->d_flags.  Always set the inode pointer *before* the type and
     always read the type *before* the inode pointer.  This should allow us to
     collapse:

	if (!dentry->d_inode || d_is_negative(dentry)) {
    
     down to:
    
    	if (d_is_negative(dentry)) {

     during RCU pathwalk.  I think.

 (9) Make pathwalk use d_is_reg() rather than S_ISREG() so that we don't need
     the inode pointer there.

Ideally, I'd like to kill struct nameidata::inode, but I think we can only do
that if we do proper unconditional COW and discard on directory dentries when
killing them rather than recycling them.  I think the only actual RCU-mode user
of nd->inode remaining is inode_permission().


The patches can also be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=file-pin-devel

The scripted changed to d_inode() can be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=file-pin-fs-experimental

And the scripted changed to d_backing_inode() can be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=file-pin-nonfs-experimental

David
---
David Howells (15):
      configfs: Fix inconsistent use of file_inode() vs file->f_path.dentry->d_inode
      VFS: Fix up missed bits of apparmor to use d_inode()
      VFS: Fix up audit to use d_backing_inode()
      VFS: Fix up missed bits of lustre to use d_inode()
      VFS: Fix up missed bits of ecryptfs to use d_inode()
      VFS: Fix up missed bits of reiserfs to use d_inode()
      VFS: AF_UNIX sockets should call mknod on the top layer only
      VFS: Cachefiles should perform fs modifications on the top layer only
      VFS: Fix up some ->d_inode accesses in the chelsio driver
      VFS: Fix up debugfs to use d_is_dir() in place of S_ISDIR()
      NFS: Don't use d_inode as a variable name
      VFS: Add owner-filesystem positive/negative dentry checks
      VFS: Impose ordering on accesses of d_inode and d_flags
      VFS: Combine inode checks with d_is_negative() and d_is_positive() in pathwalk
      VFS: Make pathwalk use d_is_reg() rather than S_ISREG()


 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   21 ++-----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.h |    2 -
 drivers/staging/lustre/lustre/llite/namei.c        |    2 -
 drivers/staging/lustre/lustre/llite/statahead.c    |    8 +--
 fs/cachefiles/interface.c                          |    4 +
 fs/cachefiles/namei.c                              |   52 +++++++++---------
 fs/configfs/dir.c                                  |    2 -
 fs/dcache.c                                        |   47 +++++++++++++---
 fs/debugfs/inode.c                                 |    2 -
 fs/ecryptfs/inode.c                                |    4 +
 fs/namei.c                                         |    8 +--
 fs/nfs/read.c                                      |    8 +--
 fs/reiserfs/xattr.h                                |    2 -
 include/linux/dcache.h                             |   59 ++++++++++++++------
 kernel/audit_watch.c                               |    2 -
 net/unix/af_unix.c                                 |    2 -
 security/apparmor/apparmorfs.c                     |    2 -
 17 files changed, 136 insertions(+), 91 deletions(-)

