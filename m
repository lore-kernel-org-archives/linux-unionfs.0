From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fix for 4.8-rc5
Date: Fri, 9 Sep 2016 21:37:09 +0200
Message-ID: <20160909193709.GO25404@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This fixes a regression caused by the last pull request.

Thanks,
Miklos

---
Miklos Szeredi (1):
      ovl: fix workdir creation

---
 fs/overlayfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
