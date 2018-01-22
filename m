From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 15/18] ovl: Copy up meta inode data from lowest data inode
Date: Mon, 22 Jan 2018 13:40:01 -0500
Message-ID: <20180122184004.26026-16-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751231AbeAVSkP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:15 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

So far lower could not be a meta inode. So whenever it was time to copy
up data of a meta inode, we could copy it up from top most lower dentry.

But now lower itself can be a metacopy inode. That means data copy up
needs to take place from a data inode in metacopy inode chain. Find
lower data inode in the chain and use that for data copy up.

Introduced a helper called ovl_path_lowerdata() to find the lower
data inode chain.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 14 ++++++++++----
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 19 +++++++++++++++++++
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0bfc1df13b79..f4ece4754725 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -489,13 +489,15 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	}
 
 	if (S_ISREG(c->stat.mode) && !c->metacopy) {
-		struct path upperpath;
+		struct path upperpath, datapath;
 
 		ovl_path_upper(c->dentry, &upperpath);
 		BUG_ON(upperpath.dentry != NULL);
 		upperpath.dentry = temp;
 
-		err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
+		ovl_path_lowerdata(c->dentry, &datapath);
+		BUG_ON(datapath.dentry == NULL);
+		err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
 		if (err)
 			return err;
 	}
@@ -627,14 +629,18 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 /* Copy up data of an inode which was copied up metadata only in the past. */
 static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 {
-	struct path upperpath;
+	struct path upperpath, datapath;
 	int err;
 
 	ovl_path_upper(c->dentry, &upperpath);
 	if (WARN_ON(upperpath.dentry == NULL))
 		return -EIO;
 
-	err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
+	ovl_path_lowerdata(c->dentry, &datapath);
+	if (WARN_ON(datapath.dentry == NULL))
+		return -EIO;
+
+	err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
 	if (err)
 		return err;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index de400606df0c..9ec65f0b5384 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -210,6 +210,7 @@ bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index e717d561019d..9cd4187cb043 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -132,6 +132,25 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 	}
 }
 
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	int i;
+
+	if (!oe->numlower) {
+		*path = (struct path) { };
+		return;
+	}
+
+	for (i = 0 ; i < oe->numlower; i++) {
+		if (oe->lowerstack[i].metacopy)
+			continue;
+		path->mnt = oe->lowerstack[i].layer->mnt;
+		path->dentry = oe->lowerstack[i].dentry;
+		return;
+	}
+}
+
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
 	enum ovl_path_type type = ovl_path_type(dentry);
-- 
2.13.6
