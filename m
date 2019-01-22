Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfAVUGy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Jan 2019 15:06:54 -0500
Date: Tue, 22 Jan 2019 14:06:49 -0600
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v3] ima: define ima_post_create_tmpfile() hook and add
 missing call
Message-ID: <20190122200649.dpzwfdhqe2quuv23@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: iforster@suse.de, linux-integrity@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>, Mimi Zohar <zohar@linux.ibm.com>
List-ID: <linux-unionfs@vger.kernel.org>

If tmpfiles can be made persistent, then newly created tmpfiles need to
be treated like any other new files in policy.

This patch indicates which newly created tmpfiles are in policy, causing
the file hash to be calculated on __fput().

Reported-by: Ignaz Forster <ignaz.forster@gmx.de>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Changes since v1:
 - Fixed Subject line function name
 - Addressed 0-day report: warning: 'return' with a value, in
   function returning void

Changes since v2:
 - Call ima_post_create_tmpfile() in vfs_tmpfile() as opposed to
   do_tmpfile(). This will help the case for overlayfs where copy_up
   is denied while overwriting a file.
---
 fs/namei.c                        |  1 +
 include/linux/ima.h               |  6 ++++++
 security/integrity/ima/ima_main.c | 35 +++++++++++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 914178cdbe94..373a7ec4b09d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3462,6 +3462,7 @@ struct dentry *vfs_tmpfile(struct dentry *dentry, umode_t mode, int open_flag)
 		inode->i_state |= I_LINKABLE;
 		spin_unlock(&inode->i_lock);
 	}
+	ima_post_create_tmpfile(inode);
 	return child;
 
 out_err:
diff --git a/include/linux/ima.h b/include/linux/ima.h
index b5e16b8c50b7..32b0c5bdcd99 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -18,6 +18,7 @@ struct linux_binprm;
 #ifdef CONFIG_IMA
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_file_check(struct file *file, int mask);
+extern void ima_post_create_tmpfile(struct inode *inode);
 extern void ima_file_free(struct file *file);
 extern int ima_file_mmap(struct file *file, unsigned long prot);
 extern int ima_load_data(enum kernel_load_data_id id);
@@ -56,6 +57,11 @@ static inline int ima_file_check(struct file *file, int mask)
 	return 0;
 }
 
+static inline void ima_post_create_tmpfile(struct inode *inode)
+{
+	return;
+}
+
 static inline void ima_file_free(struct file *file)
 {
 	return;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 4ffac4f5c647..357edd140c09 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -396,6 +396,33 @@ int ima_file_check(struct file *file, int mask)
 }
 EXPORT_SYMBOL_GPL(ima_file_check);
 
+/**
+ * ima_post_create_tmpfile - mark newly created tmpfile as new
+ * @file : newly created tmpfile
+ *
+ * No measuring, appraising or auditing of newly created tmpfiles is needed.
+ * Skip calling process_measurement(), but indicate which newly, created
+ * tmpfiles are in policy.
+ */
+void ima_post_create_tmpfile(struct inode *inode)
+{
+	struct integrity_iint_cache *iint;
+	int must_appraise;
+
+	must_appraise = ima_must_appraise(inode, MAY_ACCESS, FILE_CHECK);
+	if (!must_appraise)
+		return;
+
+	/* Nothing to do if we can't allocate memory */
+	iint = integrity_inode_get(inode);
+	if (!iint)
+		return;
+
+	/* needed for writing the security xattrs */
+	set_bit(IMA_UPDATE_XATTR, &iint->atomic_flags);
+	iint->ima_file_status = INTEGRITY_PASS;
+}
+
 /**
  * ima_post_path_mknod - mark as a new inode
  * @dentry: newly created dentry
@@ -413,9 +440,13 @@ void ima_post_path_mknod(struct dentry *dentry)
 	if (!must_appraise)
 		return;
 
+	/* Nothing to do if we can't allocate memory */
 	iint = integrity_inode_get(inode);
-	if (iint)
-		iint->flags |= IMA_NEW_FILE;
+	if (!iint)
+		return;
+
+	/* needed for re-opening empty files */
+	iint->flags |= IMA_NEW_FILE;
 }
 
 /**
-- 
2.16.4


-- 
Goldwyn
