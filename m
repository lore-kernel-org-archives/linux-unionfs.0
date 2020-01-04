Return-Path: <James.Bottomley@hansenpartnership.com>
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 0/3] introduce a uid/gid shifting bind mount
Date: Sat,  4 Jan 2020 12:39:43 -0800
Message-Id: <20200104203946.27914-1-James.Bottomley@HansenPartnership.com>
To: linux-fsdevel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Christian Brauner <christian@brauner.io>, Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, Seth Forshee <seth.forshee@canonical.com>, linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, Eric Biederman <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, containers@lists.linux-foundation.org
List-ID: <linux-unionfs@vger.kernel.org>

The object of this series is to replace shiftfs with a proper uid/gid
shifting bind mount instead of the shiftfs hack of introducing
something that looks similar to an overlay filesystem to do it.

The VFS still has the problem that in order to tell what vfsmount a
dentry belongs to, struct path would have to be threaded everywhere
struct dentry currently is.  However, this patch is structured only to
require a rethreading of notify_change.  The rest of the knowledge
that a shift is in operation is carried in the task structure by
caching the unshifted credentials.

The only real change from v1 is that the notify_change patch is
updated to fix the issues pointed out by Amir Goldstein.  And I've
combined the precursor patch to rethread notify_changes into the
series.

James

---

James Bottomley (3):
  fs: rethread notify_change to take a path instead of a dentry
  fs: introduce uid/gid shifting bind mount
  fs: expose shifting bind mount to userspace

 drivers/base/devtmpfs.c   |   8 +++-
 fs/attr.c                 |  91 ++++++++++++++++++++++++++++----------
 fs/bind.c                 |  35 +++++++++++++++
 fs/cachefiles/interface.c |   6 ++-
 fs/coredump.c             |   4 +-
 fs/ecryptfs/inode.c       |   9 ++--
 fs/exec.c                 |   7 ++-
 fs/inode.c                |  16 ++++---
 fs/internal.h             |   2 +
 fs/mount.h                |   2 +
 fs/namei.c                | 110 ++++++++++++++++++++++++++++++++++++++--------
 fs/namespace.c            |   1 +
 fs/nfsd/vfs.c             |  13 +++---
 fs/open.c                 |  44 ++++++++++++++-----
 fs/overlayfs/copy_up.c    |  40 ++++++++++-------
 fs/overlayfs/dir.c        |  10 ++++-
 fs/overlayfs/inode.c      |   6 ++-
 fs/overlayfs/overlayfs.h  |   2 +-
 fs/overlayfs/super.c      |   3 +-
 fs/posix_acl.c            |   4 +-
 fs/proc_namespace.c       |   4 ++
 fs/stat.c                 |  31 +++++++++++--
 fs/utimes.c               |   2 +-
 include/linux/cred.h      |  10 +++++
 include/linux/fs.h        |   6 +--
 include/linux/mount.h     |   4 +-
 include/linux/sched.h     |   5 +++
 kernel/capability.c       |  14 +++++-
 kernel/cred.c             |  20 +++++++++
 kernel/groups.c           |   7 +++
 30 files changed, 408 insertions(+), 108 deletions(-)

-- 
2.16.4
