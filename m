From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.1
Date: Tue, 26 May 2015 18:02:55 +0200
Message-ID: <20150526160255.GC4531@tucsk.suse.de>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Overlayfs rmdir() failed to check for emptiness in one case; this was introduced
in 4.0.  The other bug was there since day one: failure to mount if upper fs is
full, which bit some OpenWRT folks.

Thanks,
Miklos

---
Miklos Szeredi (2):
      ovl: don't remove non-empty opaque directory
      ovl: mount read-only if workdir can't be created

---
 fs/overlayfs/copy_up.c |  3 +++
 fs/overlayfs/dir.c     | 33 ++++++++++++++++++++++++++++-----
 fs/overlayfs/super.c   | 10 +++++-----
 3 files changed, 36 insertions(+), 10 deletions(-)
