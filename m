From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs bug fixes for 4.3-rc7
Date: Thu, 29 Oct 2015 06:12:24 +0100
Message-ID: <20151029051224.GA31673@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38556 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbJ2FMa (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 29 Oct 2015 01:12:30 -0400
Received: by wicll6 with SMTP id ll6so32363300wic.1
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2015 22:12:29 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This contains fixes for bugs that appeared in earlier kernels (all are marked
for -stable).

Thanks,
Miklos

---
David Howells (2):
      ovl: use O_LARGEFILE in ovl_copy_up()
      ovl: fix dentry reference leak

Konstantin Khlebnikov (2):
      ovl: free stack of paths in ovl_fill_super
      ovl: free lower_mnt array in ovl_put_super

Miklos Szeredi (1):
      ovl: fix open in stacked overlay

---
 fs/overlayfs/copy_up.c | 6 +++---
 fs/overlayfs/inode.c   | 3 +++
 fs/overlayfs/super.c   | 2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)
