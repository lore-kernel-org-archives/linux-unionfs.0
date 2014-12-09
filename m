From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] multi-layer support for overlay filesystem
Date: Tue, 9 Dec 2014 11:37:45 +0100
Message-ID: <20141209103745.GA32280@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34410 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbaLIKhb (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 9 Dec 2014 05:37:31 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so409803wgg.24
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Dec 2014 02:37:29 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Al,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

This adds support for multiple read-only layers to overlayfs.  It also makes the
writable upper layer optional.

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
