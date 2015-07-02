From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.2
Date: Thu, 2 Jul 2015 14:47:06 +0200
Message-ID: <20150702124706.GA4729@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35947 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbbGBMq5 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 2 Jul 2015 08:46:57 -0400
Received: by wguu7 with SMTP id u7so62272317wgu.3
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Jul 2015 05:46:55 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

This relaxes the requirements on the lower layer filesystem: now ones that
implement .d_revalidate, such as NFS, can be used.  Upper layer filesystems
still has the "no .d_revalidate" requirement.  Also a bad interaction with jffs2
locking has been fixed.

Thanks,
Miklos

---
Miklos Szeredi (3):
      ovl: don't traverse automount points
      ovl: allow distributed fs as lower layer
      ovl: lookup whiteouts outside iterate_dir()

---
 fs/overlayfs/readdir.c |  77 +++++++++++++++++++++------------
 fs/overlayfs/super.c   | 113 +++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 139 insertions(+), 51 deletions(-)
