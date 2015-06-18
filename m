From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/8] Security: Provide unioned file support
Date: Thu, 18 Jun 2015 14:32:15 +0100
Message-ID: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org


The attached patches provide security support for unioned files where the
security involves an object-label-based LSM (such as SELinux) rather than a
path-based LSM.

The patches can be broken down into a number of sets:

 (1) A small patch to drop a lock earlier in overlayfs.  The main VFS patch
     touches the same code, so I put this first.

 (2) The main VFS patch that makes an open file struct referring to a union
     file have ->f_path point to the union/overlay file whilst ->f_inode and
     ->f_mapping refer to the subordinate file that does the actual work.

 (3) LSM hooks to handle copy up of a file, including label setting and xattr
     filtration and SELinux implementations of these hooks.

 (4) LSM hooks to handle file open and file permission checking for the
     instance where a union/overlay file is opened that actually falls through
     to a subordinate file (ie. as (2) above) and the SELinux implementation.

 (5) An SELinux patch to make a common helper for several functions that need
     to determine the label for an inode.

The first two patches can be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=for-viro

And all the patches here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=overlayfs

Tagged with overlay-pin-20150618.

This is based on part of Al Viro's vfs/for-next branch.  However, the security
bits will need to go through the security tree - but after first two patches
are taken through the VFS tree.

David
---
David Howells (8):
      overlay: Call ovl_drop_write() earlier in ovl_dentry_open()
      overlayfs: Make f_path always point to the overlay and f_inode to the underlay
      Security: Provide copy-up security hooks for unioned files
      Overlayfs: Use copy-up security hooks
      SELinux: Stub in copy-up handling
      SELinux: Handle opening of a unioned file
      SELinux: Create a common helper to determine an inode label
      SELinux: Check against union label for file operations


 fs/dcache.c                       |    5 +
 fs/internal.h                     |    1 
 fs/open.c                         |   49 +++++-----
 fs/overlayfs/copy_up.c            |   12 ++
 fs/overlayfs/inode.c              |   22 +---
 fs/overlayfs/overlayfs.h          |    1 
 fs/overlayfs/super.c              |    1 
 include/linux/dcache.h            |    2 
 include/linux/fs.h                |    2 
 include/linux/security.h          |   36 +++++++
 security/capability.c             |   13 +++
 security/security.c               |   13 +++
 security/selinux/hooks.c          |  185 +++++++++++++++++++++++++++----------
 security/selinux/include/objsec.h |    1 
 14 files changed, 254 insertions(+), 89 deletions(-)

