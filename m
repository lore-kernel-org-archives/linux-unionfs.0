From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 0/4] ovl: xattr fixes / improvements
Date: Mon, 22 Aug 2016 20:06:30 +0200
Message-ID: <1471889194-31218-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755160AbcHVSGi (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Aug 2016 14:06:38 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

Here are some overlayfs fixes.  The first and third should definitely go
in for 4.8; the second is a mere cleanup; the fourth could go in later
but shouldn't hurt now, either.

Thanks,
Andreas

Andreas Gruenbacher (4):
  ovl: Fix OVL_XATTR_PREFIX
  ovl: Get rid of ovl_xattr_noacl_handlers array
  ovl: Switch to generic_removexattr
  ovl: Switch to generic_getxattr

 fs/overlayfs/dir.c       |  4 +--
 fs/overlayfs/inode.c     | 90 ++++++++++++++----------------------------------
 fs/overlayfs/overlayfs.h | 12 +++----
 fs/overlayfs/super.c     | 65 ++++++++++++++++++++++------------
 4 files changed, 74 insertions(+), 97 deletions(-)

-- 
2.7.4
