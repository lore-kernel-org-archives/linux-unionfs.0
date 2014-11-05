From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/7] Security: Provide unioned file support
Date: Wed, 05 Nov 2014 15:42:17 +0000
Message-ID: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org


The attached patches provide security support for unioned files where the
security involves an object-label-based LSM (such as SELinux) rather than a
path-based LSM.

There are two problems that need addressing:

 (1) The files that the user accesses through the overlayfs filesystem don't
     really exist there.  Overlayfs passes the accesses directly through to
     the underlying upper or lower file by means of having the dentry_open
     inode op redirect where file->f_path and file->f_inode point.

     This means that SELinux (or similar) will see the security label on one
     lower layer or the other - and not the label on the overlay.  There are
     three labels and all may be different.

 (2) file->f_path *should* point at the overlay dentry and file->f_inode
     should point at the lower layer inode.

I'm not addressing (2) in this series of patches, but will leave that to a
separate patch series.

  
After some discussion with docker people, the agreed theory of operation will
be:

 (1) The docker source (ie. the lower layer) will all be under a single label.

 (2) The docker root (ie. the overlay/union layer) will all be under a single,
     but different label set on the overlay mount (and each docker root may be
     under its own label).

 (3) Inodes in the overlayfs upper layer will be given the overlay label.

 (4) A security_copy_up() operation will be provided to set the label on the
     upper inode when it is created.

 (5) A security_copy_up_xattr() operation will be provided to vet (and maybe
     modify) each xattr as it is copied up.

 (6) An extra label slot will be placed in struct file_security_struct to hold
     the overlay label.

 (7) security_file_open() will need to be given both the overlay and lower
     dentries.

     For overlayfs, the way this probably should be done is file->f_path should
     be set to point to the overlay dentry (thus getting /proc right) and
     file->f_inode to the lower file and make use of d_fallthru in the overlay
     dentry in common with unionmount.

 (8) When the lower file is accessed, both the lower and overlay labels should
     be checked and audited.

 (9) When the upper file is accessed, only the overlay label needs to be
     checked and audited.

I need someone to examine the SELinux bits and have a look to see whether I
need to make further checks.


The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=overlayfs

This is based on part of Al Viro's vfs/for-next branch.

David
---
David Howells (7):
      Security: Provide copy-up security hooks for unioned files
      Overlayfs: Use copy-up security hooks
      SELinux: Stub in copy-up handling
      Security: Pass the union-layer file path into security_file_open()
      SELinux: Handle opening of a unioned file
      SELinux: The copy-up operation must have read permission on the lower file
      SELinux: Check against union and lower labels for file ops on lower files


 fs/ceph/file.c                    |    3 +
 fs/ceph/super.h                   |    1 
 fs/cifs/cifsfs.h                  |    1 
 fs/cifs/dir.c                     |    3 +
 fs/namei.c                        |   11 +++--
 fs/nfs/dir.c                      |    6 ++
 fs/nfs/nfs4_fs.h                  |    2 -
 fs/open.c                         |   31 ++++++++-----
 fs/overlayfs/copy_up.c            |   12 +++++
 fs/overlayfs/inode.c              |    8 ++-
 include/linux/fs.h                |   16 +++++--
 include/linux/security.h          |   43 +++++++++++++++++-
 security/capability.c             |   17 +++++++
 security/security.c               |   19 +++++++-
 security/selinux/hooks.c          |   89 +++++++++++++++++++++++++++++++++++--
 security/selinux/include/objsec.h |    1 
 16 files changed, 228 insertions(+), 35 deletions(-)

