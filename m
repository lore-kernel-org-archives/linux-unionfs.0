From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATH 0/4] Reduce excessive use of lock_rename() in overlayfs
Date: Fri, 11 Nov 2016 00:44:39 +0200
Message-ID: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34865 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755895AbcKJWpP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Nov 2016 17:45:15 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

lock_rename() is a very big hammer used before every call to vfs_rename(),
in order to avoid some horrible corner cases that are described in the
comment above vfs_rename().

lock_rename() taked a super block global mutex before every rename operation
that involved moving to a different parent and forces all such renames in
the file system to be serialized.

That cost may be acceptable to most workloads, because moving files/dirs
between directories are not as common as other file system operations.

Overlayfs uses vfs_rename() more that most file systems do, not only for
user requested renames, but also for every copy-up and every whiteout,
so vfs_rename() can be triggered from user operations open/create/delete,
that are much more common the renames.

It turns out, though, that all the horrible corner cases that require
the big lock_rename() hammer, can be eliminated when setting up the
overlay mount and then lock_rename() can be avoided in many use cases.

I do not have any performance results to show, which is really called
for in this sort of work. But it seems obvious that when running multiple
docker containers, file system operations should not be serialized among
all of them. So I am hoping that someone, with test machines stronger
than mine, can take this code to a test drive.

This code passed regression tests with unionmount-testsuite, pjdfstest
and xfstests -g quick.
It fails xfs tests generic/373 and generic/374 and for a good reason:
those tests try to mount 2 overlayfs mounts with the same upper/work dirs.
I will send patches to fix those 2 tests.

Amir Goldstein (4):
  vfs: reinterpret sillyrename flag as delete lock
  vfs: introduce delete trylock/unlock
  ovl: delete lock upper dir and work dir
  ovl: relax lock_rename when moving files between work and upper dir

 fs/afs/dir.c             |  6 ++---
 fs/btrfs/ioctl.c         |  5 ++--
 fs/namei.c               | 25 ++++++++++++++++---
 fs/overlayfs/copy_up.c   |  7 +++---
 fs/overlayfs/dir.c       | 25 +++++++++++++------
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/super.c     | 63 +++++++++++++++++++++++++++++++++++++++---------
 include/linux/dcache.h   | 35 +++++++++++++++++++++++++++
 include/linux/namei.h    |  2 ++
 9 files changed, 137 insertions(+), 33 deletions(-)

-- 
2.7.4
