Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B6EC49EA2
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0650608FC
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbhFSJ2i (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Jun 2021 05:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbhFSJ2i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Jun 2021 05:28:38 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E84EC061574
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:27 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m18so13552353wrv.2
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tAM1BO1d1TI6NAh8l+G4aBUoTaN24h5NkkhHqA7Rbl8=;
        b=UvoMxQhyTjIgBP8+OmlQgfU0WdrWLRPwQBvMxbsc3U/9zK77tPGO6u2bm1iAMVgi4d
         QQfe4i7hMQz9Wzc/ccGGoXPRHq82BBGZd6AIHps6j8pr6LXcBXtjvQgTs2KZpj3ZLXiX
         e4XlweMoMNbUAYblYmiVsKR+QOaIH3w8teEEmybiN4UvuCJYFFv6/ZNn5QBDuWdfFN0E
         hlwlBCLUZtSRYXsbPqNss4WxdpfujotI2P3cLHeV+PQQByK9vKJe+NwlVI9D2fY/lNi3
         bGM9ZmaVacXMWqX2CAtcZr5B2SdWUHmCulbZ6+Hsy7K1MsQqh7NtF7PDO+8PVjQL9eEn
         OzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tAM1BO1d1TI6NAh8l+G4aBUoTaN24h5NkkhHqA7Rbl8=;
        b=TJZKn99jil0+N9RO3ZhuFp/wkZOaQMU46LykmTySs3VlkcQVsHZ1Ty5a9fH+Ea4MS5
         6klK3FX6EZ9H4uSfC4zjHyg7Av22NZrqdVb796togfx8juPWCFexKhMUrPl+eY3a1+Mw
         fOtQQSrVJCOenn+VXJDreRxdNCMRB4fN1EOsyHcyfWYPzjAotZvQenELhRSl5HPgYOXE
         xEHsbzI8rEoTbgkWhAvmV6L0ujaJeiCh2bGjCOvUP8grzpBfdWwmr4h3i7Ac1JrZKBuf
         i5DhDjEbC8TZBeVAYLbx0MDGC0LfUL6iZ2+Ywgd8r1jrIbzPggBfJnxVHO4P1l0s4Gvw
         GAaA==
X-Gm-Message-State: AOAM5323HxeevXl/wu7Q/8ImUxktbKx+RzHeGqgixO4BjTnqID6taW6c
        i+N1KOvRzQijYAl/euPHP7o=
X-Google-Smtp-Source: ABdhPJyKQFzBflWUvb1RVZMyukzdLqa38MWDZZ4zUvSpjmoPa5SbQV61TvWOfCjLtzr+s5taseJbug==
X-Received: by 2002:adf:fcc5:: with SMTP id f5mr8605930wrs.83.1624094785829;
        Sat, 19 Jun 2021 02:26:25 -0700 (PDT)
Received: from localhost.localdomain ([141.226.245.169])
        by smtp.gmail.com with ESMTPSA id 2sm10904445wrz.87.2021.06.19.02.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 02:26:25 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v3 3/4] ovl: copy up sync/noatime fileattr flags
Date:   Sat, 19 Jun 2021 12:26:18 +0300
Message-Id: <20210619092619.1107608-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619092619.1107608-1-amir73il@gmail.com>
References: <20210619092619.1107608-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When a lower file has sync/noatime fileattr flags, the behavior of
overlayfs post copy up is inconsistent.

Immediattely after copy up, ovl inode still has the S_SYNC/S_NOATIME
inode flags copied from lower inode, so vfs code still treats the ovl
inode as sync/noatime.  After ovl inode evict or mount cycle,
the ovl inode does not have these inode flags anymore.

To fix this inconsitency, try to copy the fileattr flags on copy up
if the upper fs supports the fileattr_set() method.

This gives consistent behavior post copy up regardless of inode eviction
from cache.

We cannot copy up the immutable/append-only inode flags in a similar
manner, because immutable/append-only inodes cannot be linked and because
overlayfs will not be able to set overlay.* xattr on the upper inodes.

Those flags will be addressed by a followup patch.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 49 ++++++++++++++++++++++++++++++++++------
 fs/overlayfs/inode.c     | 36 ++++++++++++++++++-----------
 fs/overlayfs/overlayfs.h | 14 +++++++++++-
 3 files changed, 78 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 3fa68a5cc16e..a06b423ca5d1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/file.h>
+#include <linux/fileattr.h>
 #include <linux/splice.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
@@ -130,6 +131,31 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 	return error;
 }
 
+static int ovl_copy_fileattr(struct path *old, struct path *new)
+{
+	struct fileattr oldfa = { .flags_valid = true };
+	struct fileattr newfa = { .flags_valid = true };
+	int err;
+
+	err = ovl_real_fileattr(old, &oldfa, false);
+	if (err)
+		return err;
+
+	err = ovl_real_fileattr(new, &newfa, false);
+	if (err)
+		return err;
+
+	BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
+	newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
+	newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
+
+	BUILD_BUG_ON(OVL_COPY_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
+	newfa.fsx_xflags &= ~OVL_COPY_FSX_FLAGS_MASK;
+	newfa.fsx_xflags |= (oldfa.fsx_xflags & OVL_COPY_FSX_FLAGS_MASK);
+
+	return ovl_real_fileattr(new, &newfa, true);
+}
+
 static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
 			    struct path *new, loff_t len)
 {
@@ -493,20 +519,21 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
+	struct inode *inode = d_inode(c->dentry);
+	struct path upperpath, datapath;
 	int err;
 
+	ovl_path_upper(c->dentry, &upperpath);
+	if (WARN_ON(upperpath.dentry != NULL))
+		return -EIO;
+
+	upperpath.dentry = temp;
+
 	/*
 	 * Copy up data first and then xattrs. Writing data after
 	 * xattrs will remove security.capability xattr automatically.
 	 */
 	if (S_ISREG(c->stat.mode) && !c->metacopy) {
-		struct path upperpath, datapath;
-
-		ovl_path_upper(c->dentry, &upperpath);
-		if (WARN_ON(upperpath.dentry != NULL))
-			return -EIO;
-		upperpath.dentry = temp;
-
 		ovl_path_lowerdata(c->dentry, &datapath);
 		err = ovl_copy_up_data(ofs, &datapath, &upperpath,
 				       c->stat.size);
@@ -518,6 +545,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	if (err)
 		return err;
 
+	if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
+		/*
+		 * Copy the fileattr inode flags that are the source of already
+		 * copied i_flags (best effort).
+		 */
+		ovl_copy_fileattr(&c->lowerpath, &upperpath);
+	}
+
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
 	 * allow lookup of the copy up origin inode.
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5e828a1c98a8..aec353a2dc80 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -503,16 +503,14 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
  * Introducing security_inode_fileattr_get/set() hooks would solve this issue
  * properly.
  */
-static int ovl_security_fileattr(struct dentry *dentry, struct fileattr *fa,
+static int ovl_security_fileattr(struct path *realpath, struct fileattr *fa,
 				 bool set)
 {
-	struct path realpath;
 	struct file *file;
 	unsigned int cmd;
 	int err;
 
-	ovl_path_real(dentry, &realpath);
-	file = dentry_open(&realpath, O_RDONLY, current_cred());
+	file = dentry_open(realpath, O_RDONLY, current_cred());
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
@@ -527,11 +525,25 @@ static int ovl_security_fileattr(struct dentry *dentry, struct fileattr *fa,
 	return err;
 }
 
+int ovl_real_fileattr(struct path *realpath, struct fileattr *fa, bool set)
+{
+	int err;
+
+	err = ovl_security_fileattr(realpath, fa, set);
+	if (err)
+		return err;
+
+	if (set)
+		return vfs_fileattr_set(&init_user_ns, realpath->dentry, fa);
+	else
+		return vfs_fileattr_get(realpath->dentry, fa);
+}
+
 int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		     struct dentry *dentry, struct fileattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
-	struct dentry *upperdentry;
+	struct path upperpath;
 	const struct cred *old_cred;
 	int err;
 
@@ -541,12 +553,10 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 
 	err = ovl_copy_up(dentry);
 	if (!err) {
-		upperdentry = ovl_dentry_upper(dentry);
+		ovl_path_real(dentry, &upperpath);
 
 		old_cred = ovl_override_creds(inode->i_sb);
-		err = ovl_security_fileattr(dentry, fa, true);
-		if (!err)
-			err = vfs_fileattr_set(&init_user_ns, upperdentry, fa);
+		err = ovl_real_fileattr(&upperpath, fa, true);
 		revert_creds(old_cred);
 		ovl_copyflags(ovl_inode_real(inode), inode);
 	}
@@ -558,14 +568,14 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
-	struct dentry *realdentry = ovl_dentry_real(dentry);
+	struct path realpath;
 	const struct cred *old_cred;
 	int err;
 
+	ovl_path_real(dentry, &realpath);
+
 	old_cred = ovl_override_creds(inode->i_sb);
-	err = ovl_security_fileattr(dentry, fa, false);
-	if (!err)
-		err = vfs_fileattr_get(realdentry, fa);
+	err = ovl_real_fileattr(&realpath, fa, false);
 	revert_creds(old_cred);
 
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6e3a1bea1c9a..1e964e4e45d4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -530,9 +530,20 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 	i_size_write(to, i_size_read(from));
 }
 
+/* vfs inode flags copied from real to ovl inode */
+#define OVL_COPY_I_FLAGS_MASK	(S_SYNC | S_NOATIME | S_APPEND | S_IMMUTABLE)
+
+/*
+ * fileattr flags copied from lower to upper inode on copy up.
+ * We cannot copy immutable/append-only flags, because that would prevevnt
+ * linking temp inode to upper dir.
+ */
+#define OVL_COPY_FS_FLAGS_MASK	(FS_SYNC_FL | FS_NOATIME_FL)
+#define OVL_COPY_FSX_FLAGS_MASK	(FS_XFLAG_SYNC | FS_XFLAG_NOATIME)
+
 static inline void ovl_copyflags(struct inode *from, struct inode *to)
 {
-	unsigned int mask = S_SYNC | S_IMMUTABLE | S_APPEND | S_NOATIME;
+	unsigned int mask = OVL_COPY_I_FLAGS_MASK;
 
 	inode_set_flags(to, from->i_flags & mask, mask);
 }
@@ -560,6 +571,7 @@ struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 extern const struct file_operations ovl_file_operations;
 int __init ovl_aio_request_cache_init(void);
 void ovl_aio_request_cache_destroy(void);
+int ovl_real_fileattr(struct path *realpath, struct fileattr *fa, bool set);
 int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa);
 int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		     struct dentry *dentry, struct fileattr *fa);
-- 
2.32.0

