From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 10/28] ovl: Copy up meta inode data from lowest data inode
Date: Tue, 29 May 2018 16:45:54 +0200
Message-ID: <20180529144612.16675-11-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

So far lower could not be a meta inode.  So whenever it was time to copy up
data of a meta inode, we could copy it up from top most lower dentry.

But now lower itself can be a metacopy inode.  That means data copy up
needs to take place from a data inode in metacopy inode chain.  Find lower
data inode in the chain and use that for data copy up.

Introduced a helper called ovl_path_lowerdata() to find the lower data
inode chain.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c   | 13 +++++++++----
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 12 ++++++++++++
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7d01afd345e9..8c05e9ad9782 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -519,13 +519,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	}
 
 	if (S_ISREG(c->stat.mode) && !c->metacopy) {
-		struct path upperpath;
+		struct path upperpath, datapath;
 
 		ovl_path_upper(c->dentry, &upperpath);
 		BUG_ON(upperpath.dentry != NULL);
 		upperpath.dentry = temp;
 
-		err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
+		ovl_path_lowerdata(c->dentry, &datapath);
+		err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
 		if (err)
 			return err;
 	}
@@ -706,14 +707,18 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
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
index b1f6591b9af4..31795c041d61 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -217,6 +217,7 @@ bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ab9a8fae0f99..32ff67fa0bfb 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -164,6 +164,18 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 	}
 }
 
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	if (oe->numlower) {
+		path->mnt = oe->lowerstack[oe->numlower - 1].layer->mnt;
+		path->dentry = oe->lowerstack[oe->numlower - 1].dentry;
+	} else {
+		*path = (struct path) { };
+	}
+}
+
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
 	enum ovl_path_type type = ovl_path_type(dentry);
-- 
2.14.3
