From: Amir Goldstein <amir73il@gmail.com>
Subject: Overlayfs snapshots pre announce
Date: Fri, 2 Dec 2016 11:30:24 +0200
Message-ID: <CAOQ4uxjXpd_Fy3vBfzcXZYudPoZyXkrLEofLNQ0YPB6HeD9ZgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36807 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbcLBJa0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 04:30:26 -0500
Received: by mail-wm0-f41.google.com with SMTP id g23so10948553wme.1
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Dec 2016 01:30:25 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Hi Miklos,

Wanted to give you a heads up on upcoming announcement for
overlayfs snapshots POC, just to give you a sense of what's been
driving my recent overlayfs development efforts
and also because I am eager to share the news ;-).

I still need to sort out some documentation with FAQ and use cases
before I make a more public announcement of the project. I intend
to get to it next week and post a talk proposal to LSF/MM.

An example to make a long story short:
    mount -t overlay -o lowerdir=/lower,upperdir=/upper,workdir=/work
none /snaphot
    mount -t snapshot -o upperdir=/lower,snapshot=/snapshot
  none /mnt

/mnt is a rw view of /lower, where every mutation is preceded
by "copy-down" to upper.
/snapshot is an overlay view of lower+upper where content
remains stable.

I instrumented unionmount-testsuite with run --sn for running tests on the
setup described in the example above (in my githib #ovl_snapshot branch).
I am pleased to say that all test now pass successfully, including content
validation of files in /snapshot after every test (before and after remount).

The patches to overlayfs are not so intrusive IMO and can be found on
my github #ovl_snapshot branch.

As a matter of fact, most of the changes can be maintained as a forked
module for the development period. The module registers itself as fs type
snapshot and used for the second stacked mount.

At the moment there are only 2 modifications required from the underlying
"vanilla" overlayfs mount:
1. #redirect_fh, which #ovl_snapshot is based on
    redirect_fh allows moving directories in lower without breaking the
    downwards reference from upper
2. "explicit whiteout" - place preemptive whiteout in upper
    (see patch #2), which does not affect normal overlayfs ops
    and does not break any assumptions as far as I can tell

Thanks for all your help and patience so far!
Amir.

Amir Goldstein (9):
  ovl: introduce snapshot mount
  ovl: explicit copy up/whiteout requests from snapshot mount
  ovl: implement snapshot mount lookup
  ovl: cow file to snapshot on open for write
  ovl: cow file/dir to snapshot on ovl_want_write()
  ovl: redirect dir on rename in snapshot mount
  ovl: fix set_acl crash with snapshot mount
  ovl: unhash removed dentries from snapshot
  ovl: real dir operations for snapshot mount

 fs/overlayfs/Kconfig     |   8 ++
 fs/overlayfs/Makefile    |   1 +
 fs/overlayfs/dir.c       |  52 ++++++++--
 fs/overlayfs/inode.c     |   2 +-
 fs/overlayfs/namei.c     |  27 ++++-
 fs/overlayfs/overlayfs.h |  14 +++
 fs/overlayfs/ovl_entry.h |   7 +-
 fs/overlayfs/readdir.c   |   4 +-
 fs/overlayfs/snapshot.c  | 115 +++++++++++++++++++++
 fs/overlayfs/super.c     | 256 +++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/util.c      |  17 ++++
 11 files changed, 458 insertions(+), 45 deletions(-)
 create mode 100644 fs/overlayfs/snapshot.c
