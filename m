From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.7
Date: Fri, 27 May 2016 21:44:29 +0200
Message-ID: <20160527194429.GA5758@veci.piliscsaba.szeredi.hu>
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

The meat of this is a change to use the mounter's credentials for operations
that require elevated privileges (such as whiteout creation).  This fixes
behavior under user namespaces as well as being a nice cleanup.

Thanks,
Miklos

---
Antonio Murdaca (1):
      ovl: override creds with the ones from the superblock mounter

Miklos Szeredi (1):
      ovl: update documentation

Vivek Goyal (1):
      ovl: Do d_type check only if work dir creation was successful

---
 Documentation/filesystems/overlayfs.txt |  9 -----
 fs/overlayfs/copy_up.c                  | 26 +------------
 fs/overlayfs/dir.c                      | 67 +++------------------------------
 fs/overlayfs/overlayfs.h                |  1 +
 fs/overlayfs/readdir.c                  | 14 ++-----
 fs/overlayfs/super.c                    | 37 +++++++++++++-----
 6 files changed, 38 insertions(+), 116 deletions(-)
