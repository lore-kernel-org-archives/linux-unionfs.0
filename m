From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [RFC/RFT] multi-layer support for overlay filesystem
Date: Thu, 20 Nov 2014 18:03:13 +0100
Message-ID: <20141120170313.GC3596@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Patrick Frisch <patrick@frischux.de>, Aaron Campbell <aaron@arbor.net>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Here's the latest patchset to support multiple read-only layers for overlayfs.
Diffstat is against overlayfs-current branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

I hope to have this included in 3.19.

Please review and test (I can post the full patchset if someone wants that).

Thanks,
Miklos

---
Miklos Szeredi (12):
      ovl: check whiteout while reading directory
      ovl: make path-type a bitmap
      ovl: dont replace opaque dir
      ovl: add mutli-layer infrastructure
      ovl: helper to iterate layers
      ovl: multi-layer readdir
      ovl: multi-layer lookup
      ovl: allow statfs if no upper layer
      ovl: mount: change order of initialization
      ovl: improve mount helpers
      ovl: make upperdir optional
      ovl: support multiple lower layers

---
 Documentation/filesystems/overlayfs.txt |  12 +
 fs/overlayfs/copy_up.c                  |   4 +-
 fs/overlayfs/dir.c                      |  24 +-
 fs/overlayfs/inode.c                    |   9 +-
 fs/overlayfs/overlayfs.h                |  14 +-
 fs/overlayfs/readdir.c                  | 120 +++-----
 fs/overlayfs/super.c                    | 521 ++++++++++++++++++++------------
 7 files changed, 427 insertions(+), 277 deletions(-)
