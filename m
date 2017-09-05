From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 2/3] ovl: fix relatime for directories
Date: Tue,  5 Sep 2017 09:46:35 +0200
Message-ID: <1504597596-17994-3-git-send-email-mszeredi@redhat.com>
References: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Need to treat non-regular overlayfs files the same as regular files when
checking for an atime update.

Add a d_real() flag to make it return the real dentry for all file types.

Reported-by: "zhangyi (F)" <yi.zhang@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/inode.c             | 3 ++-
 fs/overlayfs/super.c   | 3 +++
 include/linux/dcache.h | 3 +++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 50370599e371..16e85d3a46d1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1570,7 +1570,8 @@ static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
 			       bool rcu)
 {
 	if (!rcu) {
-		struct inode *realinode = d_real_inode(dentry);
+		struct inode *realinode =
+			d_inode(d_real(dentry, NULL, 0, D_REAL_ALL));
 
 		if (unlikely(inode != realinode) &&
 		    (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19e89ce39017..059ee2f19361 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -75,6 +75,9 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	struct dentry *real;
 	int err;
 
+	if (flags & D_REAL_ALL)
+		return ovl_dentry_real(dentry);
+
 	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
 			return dentry;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index fd0721e520f4..9594ef3382ff 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -562,6 +562,9 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
 	return upper;
 }
 
+/* d_real() flags */
+#define D_REAL_ALL	0x1	/* return real dentry for all file types */
+
 /**
  * d_real - Return the real dentry
  * @dentry: the dentry to query
-- 
2.5.5
