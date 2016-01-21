From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.5
Date: Thu, 21 Jan 2016 16:06:58 +0100
Message-ID: <20160121150658.GB21394@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33534 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064AbcAUPG3 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 21 Jan 2016 10:06:29 -0500
Received: by mail-wm0-f43.google.com with SMTP id 123so178026220wmz.0
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Jan 2016 07:06:28 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This contains several bug fixes and a new mount option "default_permissions"
that allows read-only exported NFS filesystems to be used as lower layer.

Thanks,
Miklos

---
Konstantin Khlebnikov (1):
      ovl: check dentry positiveness in ovl_cleanup_whiteouts()

Miklos Szeredi (4):
      ovl: default permissions
      ovl: allow zero size xattr
      ovl: root: copy attr
      ovl: setattr: check permissions before copy-up

Stephen Hemminger (1):
      ovl: move super block magic number to magic.h

Vito Caputo (1):
      ovl: use a minimal buffer in ovl_copy_xattr

---
 fs/overlayfs/copy_up.c     | 41 ++++++++++++++++++++++++++---------------
 fs/overlayfs/inode.c       | 36 ++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h   |  3 +++
 fs/overlayfs/readdir.c     |  3 ++-
 fs/overlayfs/super.c       | 35 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/magic.h |  1 +
 6 files changed, 101 insertions(+), 18 deletions(-)
