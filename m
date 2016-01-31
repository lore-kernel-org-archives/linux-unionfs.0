From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] ovl: copy MS_POSIXACL flag from upper layer
Date: Sun, 31 Jan 2016 16:22:01 +0300
Message-ID: <145424652170.10770.5085971283841936983.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33890 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430AbcAaNWI (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 31 Jan 2016 08:22:08 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>

Catched by xfstests generic/319

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 fs/overlayfs/super.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ba28b007005e..e6ae59c7119c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -972,6 +972,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			goto out_put_workpath;
 		}
 		sb->s_stack_depth = upperpath.mnt->mnt_sb->s_stack_depth;
+
+		/* Copy MS_POSIXACL flag from upper layer */
+		sb->s_flags &= ~MS_POSIXACL;
+		sb->s_flags |= upperpath.mnt->mnt_sb->s_flags & MS_POSIXACL;
 	}
 	err = -ENOMEM;
 	lowertmp = kstrdup(ufs->config.lowerdir, GFP_KERNEL);
