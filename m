From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.7-rc5
Date: Sun, 3 Jul 2016 10:32:08 +0200
Message-ID: <20160703083208.GC11993@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34724 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbcGCIcP (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 3 Jul 2016 04:32:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so14913631wmz.1
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Jul 2016 01:32:13 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This contains fixes for a dentry leak, a regression in 4.6 noticed by Docker
users and missing write access checking in truncate.

Thanks,
Miklos

---
Miklos Szeredi (2):
      ovl: fix dentry leak for default_permissions
      ovl: get_write_access() in truncate

Vivek Goyal (1):
      ovl: warn instead of error if d_type is not supported

---
 fs/overlayfs/inode.c | 29 ++++++++++++++++++++++++++---
 fs/overlayfs/super.c | 12 +++++++-----
 2 files changed, 33 insertions(+), 8 deletions(-)
