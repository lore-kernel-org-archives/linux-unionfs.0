Return-Path: <iforster@suse.com>
From: Ignaz Forster <iforster@suse.com>
Subject: [PATCH 2/5] Rename ima_post_create_tmpfile
Date: Mon, 11 Feb 2019 17:53:20 +0100
Message-Id: <20190211165323.9369-3-iforster@suse.com>
In-Reply-To: <20190211165323.9369-1-iforster@suse.com>
References: <20190211165323.9369-1-iforster@suse.com>
To: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: Fabian Vogt <fvogt@suse.com>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

From: Ignaz Forster <iforster@suse.de>

This function is not specific to tmpfiles, but can be used for
marking any file to be in policy. Change the name accordingly.

Signed-off-by: Ignaz Forster <iforster@suse.de>
---
 fs/namei.c                        |  2 +-
 include/linux/ima.h               |  4 ++--
 security/integrity/ima/ima_main.c | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 373a7ec4b09d..744e89474cda 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3462,7 +3462,7 @@ struct dentry *vfs_tmpfile(struct dentry *dentry, umode_t mode, int open_flag)
 		inode->i_state |= I_LINKABLE;
 		spin_unlock(&inode->i_lock);
 	}
-	ima_post_create_tmpfile(inode);
+	ima_post_create_file(inode);
 	return child;
 
 out_err:
diff --git a/include/linux/ima.h b/include/linux/ima.h
index dc12fbcf484c..d47fe0a54efd 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -18,7 +18,7 @@ struct linux_binprm;
 #ifdef CONFIG_IMA
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_file_check(struct file *file, int mask);
-extern void ima_post_create_tmpfile(struct inode *inode);
+extern void ima_post_create_file(struct inode *inode);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern int ima_load_data(enum kernel_load_data_id id);
@@ -57,7 +57,7 @@ static inline int ima_file_check(struct file *file, int mask)
 	return 0;
 }
 
-static inline void ima_post_create_tmpfile(struct inode *inode)
+static inline void ima_post_create_file(struct inode *inode)
 {
 }
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 357edd140c09..629a2c538a7f 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -397,14 +397,14 @@ int ima_file_check(struct file *file, int mask)
 EXPORT_SYMBOL_GPL(ima_file_check);
 
 /**
- * ima_post_create_tmpfile - mark newly created tmpfile as new
- * @file : newly created tmpfile
+ * ima_post_create_file - mark newly created file as new
+ * @file : newly created file
  *
- * No measuring, appraising or auditing of newly created tmpfiles is needed.
+ * No measuring, appraising or auditing of newly created files is needed.
  * Skip calling process_measurement(), but indicate which newly, created
- * tmpfiles are in policy.
+ * files are in policy.
  */
-void ima_post_create_tmpfile(struct inode *inode)
+void ima_post_create_file(struct inode *inode)
 {
 	struct integrity_iint_cache *iint;
 	int must_appraise;
-- 
2.20.1
