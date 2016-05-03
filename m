From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC 0/8] Xattr inode operation removal
Date: Mon, 02 May 2016 22:40:35 -0400
Message-ID: <1462243235.2559.23.camel@linux.vnet.ibm.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Hi Andreas,

On Tue, 2016-05-03 at 00:45 +0200, Andreas Gruenbacher wrote:
> Hi all,
> 
> what are your thoughts on this patch set?  It applies on top of the
> work.xattr branch [*], converts the remaining filesystems over to xattr
> handlers, and replaces the getxattr, setxattr, and removexattr inode
> operations.  The only way to implement getxattr, setxattr, and
> removexattr with this approach is through xattr handlers.

The patch description should provide the motivation/reason for the
change (eg. performance, locking).  Up to now these xattr functions
required the caller to take the i_mutex.  Is the i_mutex still required?

Mimi

> *** Please don't merge yet: this is boot tested only so far! ***
> 
> Lustre currently also breaks; I haven't succeeded in cleaning up the
> mess there.  Oleg and Andreas, would you like to look into that?
> 
> Thanks,
> Andreas
> 
> [*] https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=work.xattr
> 
> Andreas Gruenbacher (8):
>   ecryptfs: Switch to generic xattr handlers
>   overlayfs: Switch to generic xattr handlers
>   fuse: Switch to generic xattr handlers
>   evm: Turn evm_update_evmxattr into void function
>   xattr: Add per-inode xattr handlers as a new inode operation
>   xattr: Add __vfs_{get,set,remove}xattr helpers
>   xattr: Stop calling {get,set,remove}xattr inode operations
>   xattr: Remove generic xattr handlers
> 
>  fs/9p/vfs_inode_dotl.c                |   9 --
>  fs/bad_inode.c                        |  33 +++--
>  fs/btrfs/inode.c                      |  12 --
>  fs/cachefiles/bind.c                  |   4 +-
>  fs/cachefiles/namei.c                 |   4 +-
>  fs/ceph/dir.c                         |   3 -
>  fs/ceph/inode.c                       |   6 -
>  fs/cifs/cifsfs.c                      |   9 --
>  fs/ecryptfs/ecryptfs_kernel.h         |   2 +
>  fs/ecryptfs/inode.c                   |  64 +++++-----
>  fs/ecryptfs/main.c                    |   1 +
>  fs/ecryptfs/mmap.c                    |  15 +--
>  fs/ext2/file.c                        |   3 -
>  fs/ext2/namei.c                       |   6 -
>  fs/ext2/symlink.c                     |   6 -
>  fs/ext4/file.c                        |   3 -
>  fs/ext4/namei.c                       |   6 -
>  fs/ext4/symlink.c                     |   9 --
>  fs/f2fs/file.c                        |   3 -
>  fs/f2fs/namei.c                       |  12 --
>  fs/fuse/dir.c                         |  40 ++++--
>  fs/fuse/fuse_i.h                      |   2 +
>  fs/fuse/inode.c                       |   1 +
>  fs/gfs2/inode.c                       |   9 --
>  fs/hfs/inode.c                        |   2 -
>  fs/hfsplus/dir.c                      |   3 -
>  fs/hfsplus/inode.c                    |   3 -
>  fs/jffs2/dir.c                        |   3 -
>  fs/jffs2/file.c                       |   3 -
>  fs/jffs2/symlink.c                    |   3 -
>  fs/jfs/file.c                         |   3 -
>  fs/jfs/namei.c                        |   3 -
>  fs/jfs/symlink.c                      |   6 -
>  fs/kernfs/dir.c                       |   3 -
>  fs/kernfs/inode.c                     |   3 -
>  fs/kernfs/symlink.c                   |   3 -
>  fs/libfs.c                            |  26 +---
>  fs/nfs/nfs3proc.c                     |   6 -
>  fs/nfs/nfs4proc.c                     |   6 -
>  fs/ocfs2/file.c                       |   3 -
>  fs/ocfs2/namei.c                      |   3 -
>  fs/ocfs2/symlink.c                    |   3 -
>  fs/orangefs/inode.c                   |   3 -
>  fs/orangefs/namei.c                   |   3 -
>  fs/orangefs/symlink.c                 |   1 -
>  fs/overlayfs/copy_up.c                |   4 -
>  fs/overlayfs/dir.c                    |   3 -
>  fs/overlayfs/inode.c                  |  46 +++++--
>  fs/overlayfs/overlayfs.h              |   6 +-
>  fs/overlayfs/super.c                  |   5 +-
>  fs/reiserfs/file.c                    |   3 -
>  fs/reiserfs/namei.c                   |   9 --
>  fs/squashfs/inode.c                   |   1 -
>  fs/squashfs/namei.c                   |   1 -
>  fs/squashfs/symlink.c                 |   1 -
>  fs/squashfs/xattr.h                   |   1 -
>  fs/ubifs/dir.c                        |   3 -
>  fs/ubifs/file.c                       |   6 -
>  fs/xattr.c                            | 231 ++++++++++++++++------------------
>  fs/xfs/xfs_iops.c                     |  12 --
>  include/linux/fs.h                    |   5 +-
>  include/linux/xattr.h                 |  12 +-
>  mm/shmem.c                            |  15 ---
>  net/socket.c                          |   1 -
>  security/commoncap.c                  |  25 ++--
>  security/integrity/evm/evm.h          |   7 +-
>  security/integrity/evm/evm_crypto.c   |  20 ++-
>  security/integrity/evm/evm_main.c     |   5 +-
>  security/integrity/ima/ima_appraise.c |  23 ++--
>  security/selinux/hooks.c              |  28 +----
>  security/smack/smack_lsm.c            |  28 ++---
>  71 files changed, 314 insertions(+), 541 deletions(-)
> 
