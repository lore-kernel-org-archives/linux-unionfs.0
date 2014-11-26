From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH] ovl: Cleanup redundant blank lines
Date: Wed, 26 Nov 2014 16:16:59 +0800
Message-ID: <54758C7B.6040402@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:28152 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaKZIRT (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 26 Nov 2014 03:17:19 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

This patch removes redundant blanks lines in overlayfs.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/overlayfs/copy_up.c |    1 -
 fs/overlayfs/inode.c   |    1 -
 fs/overlayfs/super.c   |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ea10a87..66d161b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -191,7 +191,6 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 		ovl_set_timestamps(upperdentry, stat);

 	return err;
-
 }

 static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 07d74b2..8ef1a03 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -430,5 +430,4 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 	}

 	return inode;
-
 }
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f16d318..bdd1195 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -98,7 +98,6 @@ void ovl_path_upper(struct dentry *dentry, struct path *path)

 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
-
 	enum ovl_path_type type = ovl_path_type(dentry);

 	if (type == OVL_PATH_LOWER)
-- 
1.6.0.2

