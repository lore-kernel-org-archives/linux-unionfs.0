From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.15
Date: Fri, 17 Nov 2017 16:13:17 +0100
Message-ID: <20171117151317.GA5348@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:33878 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdKQPPl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 10:15:41 -0500
Received: by mail-wm0-f49.google.com with SMTP id y82so3765320wmg.1
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 07:15:40 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

Report constant st_ino values across copy-up even if underlying layers are on
different filesystems, but using different st_dev values for each layer.
Ideally we'd report the same st_dev across the overlay, and it's possible to do
for filesystems that use only 32bits for st_ino by unifying the inum space.  It
would be nice if it wasn't a choice of 32 or 64, rather filesystems could report
their current maximum (that could change on resize, so it wouldn't be set in
stone).

There are also miscellaneus fixes and a cleanup of ovl_fill_super(), that was
long overdue.

Created a path_put_init() helper that clears out the pointers after putting the
ref.  I think this could be useful elsewhere, so added it to <linux/path.h>.

Thanks,
Miklos

---
Amir Goldstein (6):
      ovl: lockdep annotate of nested OVL_I(inode)->lock
      ovl: no direct iteration for dir with origin xattr
      ovl: move include of ovl_entry.h into overlayfs.h
      ovl: relax same fs constraint for constant st_ino
      ovl: update cache version of impure parent on rename
      ovl: remove unneeded arg from ovl_verify_origin()

Chandan Rajendra (3):
      ovl: re-structure overlay lower layers in-memory
      ovl: allocate anonymous devs for lowerdirs
      ovl: return anonymous st_dev for lower inodes

Miklos Szeredi (18):
      vfs: add path_put_init()
      ovl: use path_put_init() in error paths for ovl_fill_super()
      ovl: split out ovl_get_upperpath() from ovl_fill_super()
      ovl: split out ovl_get_workpath() from ovl_fill_super()
      ovl: split out ovl_get_lowerstack() from ovl_fill_super()
      ovl: split out ovl_get_upper() from ovl_fill_super()
      ovl: split out ovl_get_workdir() from ovl_fill_super()
      ovl: split out ovl_get_lower_layers() from ovl_fill_super()
      ovl: split out ovl_get_indexdir() from ovl_fill_super()
      ovl: grab reference to workbasedir early
      ovl: factor out ovl_free_fs() helper
      ovl: change order of setup in ovl_fill_super()
      ovl: reduce the number of arguments for ovl_workdir_create()
      ovl: move ovl_get_workdir() and ovl_get_lower_layers()
      ovl: clean up getting upper layer
      ovl: clean up workdir creation
      ovl: clean up getting lower layers
      ovl: rename ufs to ofs

Vivek Goyal (1):
      ovl: Put upperdentry if ovl_check_origin() fails

zhangyi (F) (2):
      ovl: simplify ovl_check_empty_and_clear()
      ovl: fix rmdir problem on non-merge dir with origin xattr

---
 fs/overlayfs/copy_up.c   |   8 +-
 fs/overlayfs/dir.c       |  25 +-
 fs/overlayfs/inode.c     |  63 ++++-
 fs/overlayfs/namei.c     |  59 ++--
 fs/overlayfs/overlayfs.h |  13 +-
 fs/overlayfs/ovl_entry.h |  14 +-
 fs/overlayfs/readdir.c   |  55 +++-
 fs/overlayfs/super.c     | 688 ++++++++++++++++++++++++++---------------------
 fs/overlayfs/util.c      |  21 +-
 include/linux/path.h     |   6 +
 10 files changed, 576 insertions(+), 376 deletions(-)
