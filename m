Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] vfs: replace i_readcount with a biased i_count
Date: Sat,  8 Jun 2019 16:57:16 +0300
Message-Id: <20190608135717.8472-2-amir73il@gmail.com>
In-Reply-To: <20190608135717.8472-1-amir73il@gmail.com>
References: <20190608135717.8472-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Mimi Zohar <zohar@linux.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Count struct files open RO together with inode reference count instead
of using a dedicated i_readcount field.  This will allow us to use the
RO count also when CONFIG_IMA is not defined and will reduce the size of
struct inode for 32bit archs when CONFIG_IMA is defined.

We need this RO count for posix leases code, which currently naively
checks i_count and d_count in an inaccurate manner.

Should regular i_count overflow into RO count bias by struct files
opened for write, it's not a big deal, as we mostly need the RO count
to be reliable when the first writer comes along.

Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h                | 33 +++++++++++++++++++------------
 security/integrity/ima/ima_main.c |  2 +-
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7fdfe93e25d..504bf17967dd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -694,9 +694,6 @@ struct inode {
 	atomic_t		i_count;
 	atomic_t		i_dio_count;
 	atomic_t		i_writecount;
-#ifdef CONFIG_IMA
-	atomic_t		i_readcount; /* struct files open RO */
-#endif
 	union {
 		const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
 		void (*free_inode)(struct inode *);
@@ -2890,26 +2887,36 @@ static inline bool inode_is_open_for_write(const struct inode *inode)
 	return atomic_read(&inode->i_writecount) > 0;
 }
 
-#ifdef CONFIG_IMA
+/*
+ * Count struct files open RO together with inode rerefernce count.
+ * We need this count for IMA and for posix leases. The RO count should not
+ * include files opened RDWR nor files opened O_PATH and internal kernel
+ * inode references, like the ones taken by overlayfs and inotify.
+ * Should regular i_count overflow into I_RO_COUNT_BIAS by struct files
+ * opened for write, it's not a big deal, as we mostly need
+ * inode_is_open_rdonly() to be reliable when the first writer comes along.
+ */
+#define I_RO_COUNT_SHIFT 10
+#define I_RO_COUNT_BIAS	(1UL << I_RO_COUNT_SHIFT)
+
 static inline void i_readcount_dec(struct inode *inode)
 {
-	BUG_ON(!atomic_read(&inode->i_readcount));
-	atomic_dec(&inode->i_readcount);
+	WARN_ON(atomic_read(&inode->i_count) < I_RO_COUNT_BIAS);
+	atomic_sub(I_RO_COUNT_BIAS, &inode->i_count);
 }
 static inline void i_readcount_inc(struct inode *inode)
 {
-	atomic_inc(&inode->i_readcount);
+	atomic_add(I_RO_COUNT_BIAS, &inode->i_count);
 }
-#else
-static inline void i_readcount_dec(struct inode *inode)
+static inline int i_readcount_read(const struct inode *inode)
 {
-	return;
+	return atomic_read(&inode->i_count) >> I_RO_COUNT_SHIFT;
 }
-static inline void i_readcount_inc(struct inode *inode)
+static inline bool inode_is_open_rdonly(const struct inode *inode)
 {
-	return;
+	return atomic_read(&inode->i_count) > I_RO_COUNT_BIAS;
 }
-#endif
+
 extern int do_pipe_flags(int *, int);
 
 #define __kernel_read_file_id(id) \
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 357edd140c09..766bac778d11 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -94,7 +94,7 @@ static void ima_rdwr_violation_check(struct file *file,
 	bool send_tomtou = false, send_writers = false;
 
 	if (mode & FMODE_WRITE) {
-		if (atomic_read(&inode->i_readcount) && IS_IMA(inode)) {
+		if (inode_is_open_rdonly(inode) && IS_IMA(inode)) {
 			if (!iint)
 				iint = integrity_iint_find(inode);
 			/* IMA_MEASURE is set from reader side */
-- 
2.17.1
