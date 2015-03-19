From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes
Date: Thu, 19 Mar 2015 16:54:23 +0100
Message-ID: <20150319155423.GC20913@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

This fixes minor issues with the multi-layer update in v4.0.

Thanks,
Miklos

---
hujianyang (3):
      ovl: print error message for invalid mount options
      ovl: check lowerdir amount for non-upper mount
      ovl: upper fs should not be R/O

---
 fs/overlayfs/super.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)
