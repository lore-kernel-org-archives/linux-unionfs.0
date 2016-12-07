From: Amir Goldstein <amir73il@gmail.com>
Subject: Introducing overlayfs snapshots project
Date: Wed, 7 Dec 2016 16:34:25 +0200
Message-ID: <CAOQ4uxgQ=-2x0VHXzGwEcbfqi2Xz62a9JUHkDjUfWC0gJdkU5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36040 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753080AbcLGOef (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Dec 2016 09:34:35 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hi All,

I am pleased to announce the overlayfs snapshots project.
Overlayfs snapshots bring file level snapshots capability
to any local file system.

Project requirements:
* Incremental read-only snapshots of directory sub-tree
* Independent of underlying local file system
* Snapshots use available file system disk space
* Snapshot deletion automatically frees up disk space
* Minimal performance overhead to file access in the writable mount
* POSIX compliance for file system operation in the writable mount
* File access to read-only snapshots may incur performance overhead
* Reading from snapshots may exhibit overlayfs non-standard behavior
* Take new snapshot in O(1) time and disk space
* No upper limit on number or size of snapshots

The project has a working POC[1] covering a partial list of the
requirements, a tailored test suite[2] to verify snapshots
consistency and a wiki[3] with more information about the project.

The kernel Documentation page is also available in nice formatting at:
https://github.com/amir73il/overlayfs/wiki/Snapshots-overview

Contributions to overlayfs snapshots project are most welcome
in the form of code review, testing, articles and public attention.

Comments and questions are always welcome.

Amir.

[1] https://github.com/amir73il/linux/tree/ovl_snapshot
[2] https://github.com/amir73il/unionmount-testsuite/tree/ovl_snapshot
[3] https://github.com/amir73il/overlayfs/wiki/Overlayfs-snapshots

Summary of overlayfs snapshots patches in [1]:
----------------------------------------------
Amir Goldstein (10):
  ovl: introduce snapshot mount
  ovl: explicit copy up/whiteout requests from snapshot mount
  ovl: implement snapshot mount lookup
  ovl: cow file to snapshot on open for write
  ovl: cow file/dir to snapshot on ovl_want_write()
  ovl: redirect dir on rename in snapshot mount
  ovl: fix set_acl crash with snapshot mount
  ovl: real dir operations for snapshot mount
  ovl: unhash removed dentries from snapshot
  ovl: overlayfs snapshots documentation

 Documentation/filesystems/overlayfs-snapshots.txt | 196 +++++++++++++++++
 fs/overlayfs/Kconfig                              |   8 +
 fs/overlayfs/Makefile                             |   1 +
 fs/overlayfs/dir.c                                |  64 +++++-
 fs/overlayfs/inode.c                              |   2 +-
 fs/overlayfs/namei.c                              |  27 ++-
 fs/overlayfs/overlayfs.h                          |  14 ++
 fs/overlayfs/ovl_entry.h                          |   7 +-
 fs/overlayfs/readdir.c                            |   4 +-
 fs/overlayfs/snapshot.c                           | 115 ++++++++++
 fs/overlayfs/super.c                              | 253 +++++++++++++++++++---
 fs/overlayfs/util.c                               |  17 ++
 12 files changed, 661 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs-snapshots.txt
 create mode 100644 fs/overlayfs/snapshot.c

-- 
2.7.4
