From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL resend] vfs update for 4.7
Date: Fri, 27 May 2016 21:49:51 +0200
Message-ID: <20160527194951.GB5758@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35443 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbcE0Tt4 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 27 May 2016 15:49:56 -0400
Received: by mail-wm0-f66.google.com with SMTP id e3so1435157wme.2
        for <linux-unionfs@vger.kernel.org>; Fri, 27 May 2016 12:49:55 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git d_real

This fixes hard linked unix sockets on overlayfs and consolidates the
d_real/d_select_inode API as well as some documentation cleanups.

Thanks,
Miklos

---
Miklos Szeredi (5):
      vfs: add d_real_inode() helper
      af_unix: fix hard linked sockets on overlay
      vfs: merge .d_select_inode() into .d_real()
      vfs: document ->d_real()
      vfs: clean up documentation

---
 Documentation/filesystems/Locking |  4 ++--
 Documentation/filesystems/vfs.txt | 39 +++++++++++++++++++++++++--------------
 fs/dcache.c                       |  3 ---
 fs/namei.c                        |  2 +-
 fs/open.c                         | 17 +++++++++++++----
 fs/overlayfs/inode.c              | 31 ++++++++++---------------------
 fs/overlayfs/overlayfs.h          |  2 +-
 fs/overlayfs/super.c              | 17 +++++++++++++----
 include/linux/dcache.h            | 35 ++++++++++++++++++++---------------
 include/linux/fs.h                |  2 +-
 net/unix/af_unix.c                |  6 +++---
 11 files changed, 89 insertions(+), 69 deletions(-)
