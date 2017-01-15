From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/6] ovl: introduce copy up waitqueue
Date: Sun, 15 Jan 2017 15:57:31 +0200
Message-ID: <1484488652-611-6-git-send-email-amir73il@gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>

The overlay sb 'copyup_wq' and overlay inode 'copying' condition
variable are about to replace the upper sb rename_lock, as finer
grained synchronization objects for concurrent copy up.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 30 ++++++++++++++++++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 59d1c38..131efb7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -180,6 +180,8 @@ struct file *ovl_path_open(struct path *path, int flags);
 struct dentry *ovl_alloc_tmpfile(struct dentry *parent, umode_t mode);
 int ovl_link_tmpfile(struct dentry *temp, struct inode *dir,
 		     struct dentry *dentry);
+int ovl_copy_up_start(struct dentry *dentry);
+void ovl_copy_up_end(struct dentry *dentry);
 
 /* namei.c */
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 65f24000..59614fa 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -28,6 +28,7 @@ struct ovl_fs {
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
 	bool tmpfile;
+	wait_queue_head_t copyup_wq;
 };
 
 /* private information held for every overlayfs dentry */
@@ -39,6 +40,7 @@ struct ovl_entry {
 			u64 version;
 			const char *redirect;
 			bool opaque;
+			bool copying;
 		};
 		struct rcu_head rcu;
 	};
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a6c42f5..4a9f489 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -708,6 +708,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ufs)
 		goto out;
 
+	init_waitqueue_head(&ufs->copyup_wq);
 	ufs->config.redirect_dir = ovl_redirect_dir_def;
 	err = ovl_parse_opt((char *) data, &ufs->config);
 	if (err)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0fbf41c..f361b47 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -301,3 +301,33 @@ int ovl_link_tmpfile(struct dentry *temp, struct inode *dir,
 
 	return err;
 }
+
+int ovl_copy_up_start(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_entry *oe = dentry->d_fsdata;
+	int err;
+
+	spin_lock(&ofs->copyup_wq.lock);
+	err = wait_event_interruptible_locked(ofs->copyup_wq, !oe->copying);
+	if (!err) {
+		if (oe->__upperdentry)
+			err = 1; /* Already copied up */
+		else
+			oe->copying = true;
+	}
+	spin_unlock(&ofs->copyup_wq.lock);
+
+	return err;
+}
+
+void ovl_copy_up_end(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	spin_lock(&ofs->copyup_wq.lock);
+	oe->copying = false;
+	wake_up_locked(&ofs->copyup_wq);
+	spin_unlock(&ofs->copyup_wq.lock);
+}
-- 
2.7.4

