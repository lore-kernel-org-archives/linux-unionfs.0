From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 27/39] ovl: obsolete "check_copy_up" module option
Date: Tue, 29 May 2018 16:43:27 +0200
Message-ID: <20180529144339.16538-28-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This was provided for debugging the ro/rw inconsistecy.  The inconsitency
is now gone so this option is obsolete.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ddaddb4ce4c3..e675e8349e71 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -25,35 +25,20 @@
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
 
-static bool __read_mostly ovl_check_copy_up;
-module_param_named(check_copy_up, ovl_check_copy_up, bool,
-		   S_IWUSR | S_IRUGO);
-MODULE_PARM_DESC(ovl_check_copy_up,
-		 "Warn on copy-up when causing process also has a R/O fd open");
-
-static int ovl_check_fd(const void *data, struct file *f, unsigned int fd)
+static int ovl_ccup_set(const char *buf, const struct kernel_param *param)
 {
-	const struct dentry *dentry = data;
-
-	if (file_inode(f) == d_inode(dentry))
-		pr_warn_ratelimited("overlayfs: Warning: Copying up %pD, but open R/O on fd %u which will cease to be coherent [pid=%d %s]\n",
-				    f, fd, current->pid, current->comm);
+	WARN(1, "overlayfs: \"check_copy_up\" module option is obsolete\n");
 	return 0;
 }
 
-/*
- * Check the fds open by this process and warn if something like the following
- * scenario is about to occur:
- *
- *	fd1 = open("foo", O_RDONLY);
- *	fd2 = open("foo", O_RDWR);
- */
-static void ovl_do_check_copy_up(struct dentry *dentry)
+static int ovl_ccup_get(char *buf, const struct kernel_param *param)
 {
-	if (ovl_check_copy_up)
-		iterate_fd(current->files, 0, ovl_check_fd, dentry);
+	return sprintf(buf, "N\n");
 }
 
+module_param_call(check_copy_up, ovl_ccup_set, ovl_ccup_get, NULL, 0644);
+MODULE_PARM_DESC(ovl_check_copy_up, "Obsolete; does nothing");
+
 int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 	ssize_t list_size, size, value_size = 0;
@@ -719,7 +704,6 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		if (IS_ERR(ctx.link))
 			return PTR_ERR(ctx.link);
 	}
-	ovl_do_check_copy_up(ctx.lowerpath.dentry);
 
 	err = ovl_copy_up_start(dentry);
 	/* err < 0: interrupted, err > 0: raced with another copy-up */
-- 
2.14.3
