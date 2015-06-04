From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 0/2] ovl: support NFS as lower layer
Date: Thu,  4 Jun 2015 15:29:44 +0200
Message-ID: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sa-dev@rainbow.by, andre.roth@roche.com
List-Id: linux-unionfs@vger.kernel.org

Two small patches implementing this follow.  Comments and testing welcome.

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Thanks,
Miklos

---
Miklos Szeredi (2):
      ovl: don't traverse automount points
      ovl: allow distributed fs as lower layer

---
 fs/overlayfs/super.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 74 insertions(+), 7 deletions(-)
