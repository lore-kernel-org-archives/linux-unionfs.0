From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.12-final
Date: Fri, 30 Jun 2017 10:01:23 +0200
Message-ID: <20170630080123.GA4637@veci.piliscsaba.szeredi.hu>
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

Fix two bugs in copy-up code.  One introduced in 4.11 and one in 4.12-rc.

Thanks,
Miklos

---
Miklos Szeredi (2):
      ovl: copy-up: don't unlock between lookup and link
      ovl: don't set origin on broken lower hardlink

---
 fs/overlayfs/copy_up.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)
