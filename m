From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.6
Date: Tue, 22 Mar 2016 14:10:08 +0100
Message-ID: <20160322131008.GB11906@tucsk>
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

This contains various fixes and tweaks.

Thanks,
Miklos

---
David Howells (1):
      ovl: Warn on copy up if a process has a R/O fd open to the lower file

Konstantin Khlebnikov (1):
      ovl: honor flag MS_SILENT at mount

Miklos Szeredi (3):
      ovl: verify upper dentry before unlink and rename
      ovl: rename is_merge to is_lowest
      ovl: cleanup unused var in rename2

Sohom Bhattacharjee (1):
      ovl: fixed coding style warning

Vivek Goyal (1):
      ovl: Ensure upper filesystem supports d_type

---
 fs/overlayfs/copy_up.c   | 35 +++++++++++++++++++++++++++
 fs/overlayfs/dir.c       | 61 ++++++++++++++++++++++++++++++------------------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/readdir.c   | 53 ++++++++++++++++++++++++++++++++++-------
 fs/overlayfs/super.c     | 18 +++++++++++++-
 5 files changed, 136 insertions(+), 32 deletions(-)
