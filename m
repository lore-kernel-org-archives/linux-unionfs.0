Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238D5C433B4
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 09:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B87610E9
	for <linux-unionfs@archiver.kernel.org>; Sun, 11 Apr 2021 09:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhDKJWo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 11 Apr 2021 05:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhDKJWn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Apr 2021 05:22:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD135C061574
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Apr 2021 02:22:27 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id f12so9850737wro.0
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Apr 2021 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d6O+5RnidF6zNPJCyHumlMeFkcrf2nmhfRZvSj6wC4c=;
        b=IJiqnSgUVMll50RoCikMFbIfvr2kunxySZpxmWkyxXp59KEcMZ2j2h8CJm8oC4UEFZ
         Y4oPoGRWzfu/alu7lsSrtVMgxO8z9xIVoez2RJ1iL6+a89USHRPfpLgG4JQSzuI4Ur4u
         PHcXykH4vYcWYx2mV/exkT0B/uj+RJKCkIYpQtWIFrwZsFrz/2pg5a9G3Hjt6tTt3kOp
         XygIjoSeNzzrIstdybLSOSNJdZAWQTkNjR/lbusFO33GfndAmsoCCvHOvrUmWgMQOS2W
         sNAWd8tBH0bsuOteLkHJfGTC3gntBt7KRj7zk9YGBDbtkGx5HKnAdzgZzumrgbJ4eBeW
         t0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d6O+5RnidF6zNPJCyHumlMeFkcrf2nmhfRZvSj6wC4c=;
        b=HcBw2wEJYxhd9jPtqBidcIDojdl8HMiu0RfnzoGS03oe3KcuVKZMvWNi1fwZGEEyPD
         ILgllkxkfF0asUJsUkHhpCOtnYiGYlk1m094Ltl23Xf5R+dFPTebo8SWiUy0F1brxmTh
         fC6hktSv9Qwr3czpoanFX2wZV3YmGwqEux511GUFge8JkW7FpxamS5iZZ5gJpHI+9NWL
         jRAViDnnOC5EIhtuyhsRa5n08aEsIR+3gAAU2XWZEOaXK17AafYeNCBiu/tJETCe4E1C
         2HSF86jTNw65bgRF0XtJKSzWCTP8Ft/Q1KdhShYNCTrtT8fWqBj+vrkv4cjmtl9Jj2IS
         R/ug==
X-Gm-Message-State: AOAM533O+h1FG2QvErze2TblnfdXkgZYif7i1ZnZxkT5U9O8VS0MCbbz
        AJeFdxuT/VIxRTF7vaMnhQo=
X-Google-Smtp-Source: ABdhPJwi/tMLBvgZX8s3/nzSU9+7Ul57vCHd2EC0/P0CCOnmHIlscrIIfS/XCVd5PNkAq5q4nKKLCA==
X-Received: by 2002:adf:fec5:: with SMTP id q5mr10542004wrs.168.1618132946494;
        Sun, 11 Apr 2021 02:22:26 -0700 (PDT)
Received: from localhost.localdomain ([141.226.241.101])
        by smtp.gmail.com with ESMTPSA id z1sm12398483wrs.89.2021.04.11.02.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 02:22:25 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: invalidate readdir cache on changes to dir with origin
Date:   Sun, 11 Apr 2021 12:22:23 +0300
Message-Id: <20210411092223.1914782-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The test in ovl_dentry_version_inc() was out-dated and did not include
the case where readdir cache is used on a non-merge dir that has origin
xattr, indicating that it may contain leftover whiteouts.

To make the code more robust, use the same helper ovl_dir_is_real()
to determine if readdir cache should be used and if readdir cache should
be invalidated.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxht70nODhNHNwGFMSqDyOKLXOKrY0H6g849os4BQ7cokA@mail.gmail.com/
Cc: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Found this during code audit related to the bug report above
although I don't see how said bug report could be related.

I have a reproducer for this fixed bug, but I prefer to wait to the
results of investigation of the reported regression before posting
a proper test.

Thanks,
Amir.

 fs/overlayfs/overlayfs.h | 30 +++++++++++++++++++++++++++---
 fs/overlayfs/readdir.c   | 12 ------------
 fs/overlayfs/util.c      | 31 +++++++++----------------------
 3 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d690ecda1e16..d1e08d804207 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -324,9 +324,6 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
-void ovl_set_flag(unsigned long flag, struct inode *inode);
-void ovl_clear_flag(unsigned long flag, struct inode *inode);
-bool ovl_test_flag(unsigned long flag, struct inode *inode);
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_is_inuse(struct dentry *dentry);
@@ -340,6 +337,21 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 			     int padding);
 int ovl_sync_status(struct ovl_fs *ofs);
 
+static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
+{
+	set_bit(flag, &OVL_I(inode)->flags);
+}
+
+static inline void ovl_clear_flag(unsigned long flag, struct inode *inode)
+{
+	clear_bit(flag, &OVL_I(inode)->flags);
+}
+
+static inline bool ovl_test_flag(unsigned long flag, struct inode *inode)
+{
+	return test_bit(flag, &OVL_I(inode)->flags);
+}
+
 static inline bool ovl_is_impuredir(struct super_block *sb,
 				    struct dentry *dentry)
 {
@@ -444,6 +456,18 @@ int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 			struct dentry *dentry, int level);
 int ovl_indexdir_cleanup(struct ovl_fs *ofs);
 
+/*
+ * Can we iterate real dir directly?
+ *
+ * Non-merge dir may contain whiteouts from a time it was a merge upper, before
+ * lower dir was removed under it and possibly before it was rotated from upper
+ * to lower layer.
+ */
+static inline bool ovl_dir_is_real(struct dentry *dir)
+{
+	return !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
+}
+
 /* inode.c */
 int ovl_set_nlink_upper(struct dentry *dentry);
 int ovl_set_nlink_lower(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f404a78e6b60..cc1e80257064 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -319,18 +319,6 @@ static inline int ovl_dir_read(struct path *realpath,
 	return err;
 }
 
-/*
- * Can we iterate real dir directly?
- *
- * Non-merge dir may contain whiteouts from a time it was a merge upper, before
- * lower dir was removed under it and possibly before it was rotated from upper
- * to lower layer.
- */
-static bool ovl_dir_is_real(struct dentry *dir)
-{
-	return !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
-}
-
 static void ovl_dir_reset(struct file *file)
 {
 	struct ovl_dir_file *od = file->private_data;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7f5a01a11f97..404a0a32ddf6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -422,18 +422,20 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 	}
 }
 
-static void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
+static void ovl_dir_version_inc(struct dentry *dentry, bool impurity)
 {
 	struct inode *inode = d_inode(dentry);
 
 	WARN_ON(!inode_is_locked(inode));
+	WARN_ON(!d_is_dir(dentry));
 	/*
-	 * Version is used by readdir code to keep cache consistent.  For merge
-	 * dirs all changes need to be noted.  For non-merge dirs, cache only
-	 * contains impure (ones which have been copied up and have origins)
-	 * entries, so only need to note changes to impure entries.
+	 * Version is used by readdir code to keep cache consistent.
+	 * For merge dirs (or dirs with origin) all changes need to be noted.
+	 * For non-merge dirs, cache contains only impure entries (i.e. ones
+	 * which have been copied up and have origins), so only need to note
+	 * changes to impure entries.
 	 */
-	if (OVL_TYPE_MERGE(ovl_path_type(dentry)) || impurity)
+	if (!ovl_dir_is_real(dentry) || impurity)
 		OVL_I(inode)->version++;
 }
 
@@ -442,7 +444,7 @@ void ovl_dir_modified(struct dentry *dentry, bool impurity)
 	/* Copy mtime/ctime */
 	ovl_copyattr(d_inode(ovl_dentry_upper(dentry)), d_inode(dentry));
 
-	ovl_dentry_version_inc(dentry, impurity);
+	ovl_dir_version_inc(dentry, impurity);
 }
 
 u64 ovl_dentry_version_get(struct dentry *dentry)
@@ -638,21 +640,6 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	return err;
 }
 
-void ovl_set_flag(unsigned long flag, struct inode *inode)
-{
-	set_bit(flag, &OVL_I(inode)->flags);
-}
-
-void ovl_clear_flag(unsigned long flag, struct inode *inode)
-{
-	clear_bit(flag, &OVL_I(inode)->flags);
-}
-
-bool ovl_test_flag(unsigned long flag, struct inode *inode)
-{
-	return test_bit(flag, &OVL_I(inode)->flags);
-}
-
 /**
  * Caller must hold a reference to inode to prevent it from being freed while
  * it is marked inuse.
-- 
2.30.0

