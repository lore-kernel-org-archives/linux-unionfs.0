From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.7-rc3
Date: Thu, 16 Jun 2016 09:32:08 +0200
Message-ID: <20160616073208.GB11993@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33305 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbcFPHcM (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 16 Jun 2016 03:32:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id r5so9223639wmr.0
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Jun 2016 00:32:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This contains two regression fixes: one for the xattr API update and one for
using the mounter's creds in file creation in overlayfs.  There's also a fix for
a bug in handling hard linked AF_UNIX sockets that's been there from day one.
This fix is overlayfs only despite the fact that it touches code outside the
overlay filesystem: d_real() is an identity function for all except overlay
dentries.

Thanks,
Miklos

---
Miklos Szeredi (4):
      vfs: add d_real_inode() helper
      af_unix: fix hard linked sockets on overlay
      ovl: xattr filter fix
      ovl: fix uid/gid when creating over whiteout

---
 fs/overlayfs/dir.c     | 13 +++++++++++--
 fs/overlayfs/inode.c   | 26 ++++++--------------------
 include/linux/dcache.h | 12 ++++++++++++
 net/unix/af_unix.c     |  6 +++---
 4 files changed, 32 insertions(+), 25 deletions(-)
