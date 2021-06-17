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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B97EC48BE5
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36FA061159
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhFQPZB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhFQPY7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Jun 2021 11:24:59 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC569C06175F
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso5079184wmc.1
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GjC+VOsN9lvHv20zClgz5MnDwqP5+Nkfd2EwWmDTKLE=;
        b=JWQHDMXbkktvtpB4ol8RBbMt2jXy0EgCTi6Z9UM4/bJK5spQN99xoaKOYmGujxW43G
         xrEmWIj+6ZUMrPUXPki2Uq7hXArh+H8Onf/fqCmfmNpeDg52pdD/VS6sc9IL77yFAp3d
         y9sFKx7fwr2hp3bUpmKMCyW0qFLpgxpgrHn60gjm7rL4oafn/ei/6+eNpLZpKQPe4BfE
         P12ps8AzrQG5UHkK7+D51TrJbWzPYh0Bm9gr+eoFWaolWVRGbQOR+OP5y5ZBWmEuTfE1
         WSMYOPh7co0TbzUpbnPpV0pPoT6SpyYQfXidOJBsL67E0peGgGarE/3nDaN6Tioxz/Lt
         npcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GjC+VOsN9lvHv20zClgz5MnDwqP5+Nkfd2EwWmDTKLE=;
        b=NpZ00p5J4zifThMiwsr7IPYWgu5eRW1Zpelu9x2mMIJw7VojC7sXnEnrYBoouvDuhI
         syV2Mfz5rc1cNPixtXwWseQEuSTPBcWePlwxHPt6TTb9G5WLdLtfSR9xbb4HFqWdylwn
         ECyeqIVpNGBNsDxikTsKm1r1iumDu/SSOwdImY41ucmwu7LjExYSyf+r2Ti1fkLM+yws
         BPDhnOsd5OD5jV+EHGNtRzcZB5ucuSGTKswRrd6eso5wT2XEbAwF+Z6Z6/GheT9EW41N
         cuW9Ms4cA7LKbaBA9LKNiTd6w+dF/hc0zNgZpPkbdVPFQ2fk5AI0BsjlUNs2p5ntD7EP
         z9Zw==
X-Gm-Message-State: AOAM530Je3cB2Sb8IBENw1TNeArSae4uoxQEL3+64/knwzLeEnTIzxcn
        Kxpy64GVL85Lcts0i7Rxlzk=
X-Google-Smtp-Source: ABdhPJx8ORPSqvrNl+At/q3aJegkyVdKdbyB9a55ESPDSXkWGMA3jLdf5cX1z3qTAAXkCeQa8kKZkg==
X-Received: by 2002:a1c:4c07:: with SMTP id z7mr5661960wmf.90.1623943369308;
        Thu, 17 Jun 2021 08:22:49 -0700 (PDT)
Received: from localhost.localdomain ([141.226.242.176])
        by smtp.gmail.com with ESMTPSA id o7sm5835910wro.76.2021.06.17.08.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:22:48 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 2/3] ovl: copy up sync/noatime fileattr flags
Date:   Thu, 17 Jun 2021 18:22:40 +0300
Message-Id: <20210617152241.987010-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617152241.987010-1-amir73il@gmail.com>
References: <20210617152241.987010-1-amir73il@gmail.com>
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
index 3fa68a5cc16e..e1d91cdf4c3f 100644
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
 
+static int ovl_copy_xflags(struct path *old, struct path *new)
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
+		ovl_copy_xflags(&c->lowerpath, &upperpath);
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

