Return-Path: <SRS0=Pu7X=DG=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B4CC4346E
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Sep 2020 07:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91E6B20936
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Sep 2020 07:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI2Hrh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 03:47:37 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16796 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725535AbgI2Hrh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Sep 2020 03:47:37 -0400
X-IronPort-AV: E=Sophos;i="5.77,317,1596470400"; 
   d="scan'208";a="99706518"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 29 Sep 2020 15:47:32 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 0389048990E8;
        Tue, 29 Sep 2020 15:47:27 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 29 Sep 2020 15:47:26 +0800
Received: from Fedora-31.g08.fujitsu.local (10.167.220.31) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 29 Sep 2020 15:47:23 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-unionfs@vger.kernel.org>
CC:     <miklos@szeredi.hu>, <amir73il@gmail.com>, <hch@infradead.org>,
        <darrick.wong@oracle.com>, <fstests@vger.kernel.org>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH v2 1/2] ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR ioctls for directories
Date:   Tue, 29 Sep 2020 15:28:47 +0800
Message-ID: <20200929072848.853877-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 0389048990E8.AC791
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[S|G]ETFLAGS and FS[S|G]ETXATTR ioctls are applicable to both files and
directories, so add ioctl operations to dir as well.

We teach ovl_real_fdget() to get the realfile of directories which use
a different type of file->private_data.

ifdef away compat ioctl implementation to conform to standard practice.

With this change, xfstest generic/079 which tests these ioctls on files
and directories passes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Reviewed-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---

V1->v2:
1) Rename subject
2) Rebase on top of the following branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

 fs/overlayfs/file.c      | 16 +++++++++++++---
 fs/overlayfs/overlayfs.h |  3 +++
 fs/overlayfs/readdir.c   | 33 ++++++++++++++++++++++++++++-----
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 3582c3ae819c..90b9aaebdf57 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -136,6 +136,13 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
 
 static int ovl_real_fdget(const struct file *file, struct fd *real)
 {
+	if (d_is_dir(file_dentry(file))) {
+	    real->flags = 0;
+	    real->file = ovl_dir_real_file(file, false);
+
+	    return PTR_ERR_OR_ZERO(real->file);
+	}
+
 	return ovl_real_fdget_meta(file, real, false);
 }
 
@@ -648,7 +655,7 @@ static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
 				   ovl_fsxflags_to_iflags(fa.fsx_xflags));
 }
 
-static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
@@ -673,8 +680,8 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static long ovl_compat_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
+#ifdef CONFIG_COMPAT
+long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case FS_IOC32_GETFLAGS:
@@ -691,6 +698,7 @@ static long ovl_compat_ioctl(struct file *file, unsigned int cmd,
 
 	return ovl_ioctl(file, cmd, arg);
 }
+#endif
 
 enum ovl_copyop {
 	OVL_COPY,
@@ -792,7 +800,9 @@ const struct file_operations ovl_file_operations = {
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl	= ovl_compat_ioctl,
+#endif
 	.splice_read    = ovl_splice_read,
 	.splice_write   = ovl_splice_write,
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7bce2469fe55..f8880aa2ba0e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -416,6 +416,7 @@ static inline int ovl_verify_upper(struct ovl_fs *ofs, struct dentry *index,
 
 /* readdir.c */
 extern const struct file_operations ovl_dir_operations;
+struct file *ovl_dir_real_file(const struct file *file, bool want_upper);
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list);
 void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list);
 void ovl_cache_free(struct list_head *list);
@@ -503,6 +504,8 @@ struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 extern const struct file_operations ovl_file_operations;
 int __init ovl_aio_request_cache_init(void);
 void ovl_aio_request_cache_destroy(void);
+long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 596002054ac6..392efbbe9242 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -853,16 +853,22 @@ static struct file *ovl_dir_open_realfile(struct file *file,
 	return res;
 }
 
-static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
-			 int datasync)
+/*
+ * Like ovl_real_fdget(), returns upperfile if dir was copied up since open.
+ * Unlike ovl_real_fdget(), this caches upperfile in file->private_data.
+ *
+ * TODO: use same abstract type for file->private_data of dir and file so
+ * upperfile could also be cached for files as well.
+ */
+struct file *ovl_dir_real_file(const struct file *file, bool want_upper)
 {
+
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	struct file *realfile = od->realfile;
 
-	/* Nothing to sync for lower */
 	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
-		return 0;
+		return want_upper ? NULL : realfile;
 
 	if (!ovl_should_sync(OVL_FS(dentry->d_sb)))
 		return 0;
@@ -884,7 +890,7 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 			if (!od->upperfile) {
 				if (IS_ERR(realfile)) {
 					inode_unlock(inode);
-					return PTR_ERR(realfile);
+					return realfile;
 				}
 				smp_store_release(&od->upperfile, realfile);
 			} else {
@@ -897,6 +903,19 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 		}
 	}
 
+	return realfile;
+}
+
+static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
+			 int datasync)
+{
+	struct file *realfile = ovl_dir_real_file(file, true);
+	int err = PTR_ERR_OR_ZERO(realfile);
+
+	/* Nothing to sync for lower */
+	if (!realfile || err)
+		return err;
+
 	return vfs_fsync_range(realfile, start, end, datasync);
 }
 
@@ -949,6 +968,10 @@ const struct file_operations ovl_dir_operations = {
 	.llseek		= ovl_dir_llseek,
 	.fsync		= ovl_dir_fsync,
 	.release	= ovl_dir_release,
+	.unlocked_ioctl	= ovl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= ovl_compat_ioctl,
+#endif
 };
 
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
-- 
2.25.1



