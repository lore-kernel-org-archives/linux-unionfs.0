From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fix for 4.9
Date: Thu, 1 Dec 2016 09:46:03 +0100
Message-ID: <20161201084603.GE2622@veci.piliscsaba.szeredi.hu>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This fixes a regression introduced in 4.8.

Thanks,
Miklos

---
Miklos Szeredi (1):
      ovl: fix d_real() for stacked fs

---
 fs/overlayfs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
