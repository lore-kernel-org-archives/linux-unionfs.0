From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.7-final
Date: Fri, 22 Jul 2016 21:52:19 +0200
Message-ID: <20160722195219.GD20504@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33430 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbcGVTwY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 22 Jul 2016 15:52:24 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so7449022wme.0
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jul 2016 12:52:23 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This contains a fix for a potential crash/corruption issue and another where the
suid/sgid bits weren't cleared on write.

Thanks,
Miklos

---
Maxim Patlasov (1):
      ovl: verify upper dentry in ovl_remove_and_whiteout()

Miklos Szeredi (1):
      ovl: handle ATTR_KILL*

Vivek Goyal (1):
      ovl: Copy up underlying inode's ->i_mode to overlay inode

---
 fs/overlayfs/dir.c       | 54 +++++++++++++++++++++---------------------------
 fs/overlayfs/inode.c     |  6 ++++--
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 29 insertions(+), 32 deletions(-)
