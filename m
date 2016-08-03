From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] fix overlayfs deadlock in file_remove_privs()
Date: Wed, 3 Aug 2016 18:30:29 +0200
Message-ID: <20160803163029.GD25404@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33426 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbcHCQbP (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 3 Aug 2016 12:31:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id o80so37126277wme.0
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Aug 2016 09:30:33 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git for-viro

This fixes the deadlock introduced by making the suid removal actually work on
overlayfs.

Responsible commit 07a2daab49c5 ("ovl: Copy up underlying inode's ->i_mode to
overlay inode") unfortunately slipped through my testing and 4.7 was released
with this bug.

Two more patches are cleaning away unneeded exports of related helpers.

Thanks,
Miklos

---
Miklos Szeredi (3):
      vfs: fix deadlock in file_remove_privs() on overlayfs
      vfs: remove file_needs_remove_privs()
      vfs: make dentry_needs_remove_privs() internal

---
 fs/inode.c         | 7 +++----
 fs/internal.h      | 1 +
 include/linux/fs.h | 5 -----
 3 files changed, 4 insertions(+), 9 deletions(-)
