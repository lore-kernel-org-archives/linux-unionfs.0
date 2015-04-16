From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/4] Overlayfs: Wrap ->d_inode
Date: Thu, 16 Apr 2015 15:42:41 +0100
Message-ID: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org


Hi Al, Miklos,

Here are four patches that wrap ->d_inode inside of overlayfs.

The first patch wraps a number of S_ISDIR(dentry->d_inode) to d_is_dir(dentry)
or d_can_lookup(dentry), making the assumption that a directory in a lower
layer will always correspond to a directory in the union layer - and thus the
test works for both the overlay's own inodes and the overlay's subordinate
inodes.

The second patch wraps accesses to an overlay superblock's own inodes.  These
require the use of d_inode() and d_really_is_xxx().

The third and fourth patch wraps accesses that an overlay superblock does to
its subordinate inodes.  These require the use of d_backing_inode() and
d_is_xxx().

It is assumed that an overlay will _not_ be used as the top layer in a
unionmount.

The patches can also be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=file-pin-devel-2

under the overlay-pin-20150416 tag.

David
---
David Howells (4):
      Overlayfs: Convert S_ISDIR(dentry->d_inode) to d_is_dir()/d_can_lookup()
      Overlayfs: Convert own ->d_inode to d_inode() or d_really_is_positive/negative()
      Overlayfs: Wrap accesses to ->d_inode on subordinate filesystems
      Overlayfs: Wrap RCU-mode accesses to ->d_inode on subordinate filesystems


 fs/overlayfs/copy_up.c |   18 ++++++-------
 fs/overlayfs/dir.c     |   67 ++++++++++++++++++++++++------------------------
 fs/overlayfs/inode.c   |   16 ++++++-----
 fs/overlayfs/readdir.c |    6 ++--
 fs/overlayfs/super.c   |   39 ++++++++++++++--------------
 include/linux/dcache.h |   18 +++++++++++++
 6 files changed, 92 insertions(+), 72 deletions(-)

