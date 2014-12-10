From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH resend] ovl: cleanup redundant blank lines
Date: Wed, 10 Dec 2014 18:24:26 +0800
Message-ID: <54881F5A.7010902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:52954 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLJKYo (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 10 Dec 2014 05:24:44 -0500
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
index a5bfd60..24f6404 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -191,7 +191,6 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 		ovl_set_timestamps(upperdentry, stat);

 	return err;
-
 }

 static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 48492f1..5ac1236 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -433,5 +433,4 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 	}

 	return inode;
-
 }
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c29e835..a9b5173 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -104,7 +104,6 @@ void ovl_path_upper(struct dentry *dentry, struct path *path)

 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
-
 	enum ovl_path_type type = ovl_path_type(dentry);

 	if (!OVL_TYPE_UPPER(type))
-- 
1.6.0.2

