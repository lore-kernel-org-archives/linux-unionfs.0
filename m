Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 10/31] ovl: Copy up meta inode data from lowest data inode
Date: Thu, 26 Apr 2018 15:09:52 -0400
Message-Id: <20180426191013.13219-11-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

So far lower could not be a meta inode. So whenever it was time to copy
up data of a meta inode, we could copy it up from top most lower dentry.

But now lower itself can be a metacopy inode. That means data copy up
needs to take place from a data inode in metacopy inode chain. Find
lower data inode in the chain and use that for data copy up.

Introduced a helper called ovl_path_lowerdata() to find the lower
data inode chain.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 14 ++++++++++----
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 14 ++++++++++++++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7453913ca61b..5a865a4cf3d7 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -565,13 +565,15 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
@@ -754,14 +756,18 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
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
index 790314079950..cb6fad91147d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -223,6 +223,7 @@ bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a32509814f54..42b24308e016 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -164,6 +164,20 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 	}
 }
 
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	int idx = oe->numlower - 1;
+
+	if (!oe->numlower) {
+		*path = (struct path) { };
+		return;
+	}
+
+	path->mnt = oe->lowerstack[idx].layer->mnt;
+	path->dentry = oe->lowerstack[idx].dentry;
+}
+
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
 	enum ovl_path_type type = ovl_path_type(dentry);
-- 
2.13.6
