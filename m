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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E093EC49361
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1D3461159
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhFQPZA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhFQPY6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Jun 2021 11:24:58 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5AC061767
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:49 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id t11-20020a1cc30b0000b02901cec841b6a0so4426096wmf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7yRz5fBvz0QjFHM/i+cV9QhWjVXY4W7zJhUSwe5b+Q=;
        b=F4N5fsrpTDHA2wToqr8KqRh4dKh7EVTqj3klgBTjAwYZTF7bsfMFhZsaF3EyV87fM4
         FcbMHUMesn9M37Im2kZgAC1XV51H8ZfpWyRk3IHfWF6GHzw+x4g8fWRa9WpzlXxQUxPe
         pn79MzekiL3ATpQaZwzbwyHZ2rltTxEZQhxHGgyTGPVXX0Nyqbt8d6KCSsRf5V6j4ErF
         j7MdBxnjjDMx/MeZ+XJUfTP+P7h0rvpLT+PF7l4XRcinsxSTH9HENZdSzm8+8XSHIpLp
         q/gYo+CcIsIuCZXIyNCYeGcPr7bX774k37CIMEs9idmQ810FFqVwYQmWEo6lDGj609Nw
         DfGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7yRz5fBvz0QjFHM/i+cV9QhWjVXY4W7zJhUSwe5b+Q=;
        b=kErb8MObzYdW2G2U5uoXkYBkibaXoG+cxcQ3T8cMkeahSVP35zdl8SEsnjAg4yirea
         wgIWBF/OZtVmWjLYPJYuaXHXoaBmR4axtHPHyo7IuMgej5dkuBflsw7xrjtWsuyICBy6
         XUOdNUr8wPuq8ur68vktiawDbhOvUNGZ1Sb/p8Z8LWOZOn5FJDZgbNx6EdevMXNTryKn
         QBSWv+RIqp3cRDcUpgckDMp57i0Jnh3i2O7tf38Jexj6MdUL9QQBJwml2Y2L1wLDxyuE
         SuxhfCSV0+4WPrHjP+HpN2lOuj0a4ArbtwO+siOkulmevTIhyGyoKo5vs40GAiO6/mVL
         kEDQ==
X-Gm-Message-State: AOAM533Nd5l0nGYuN+k/eSFGlj2hnbxxEwiRAqyWBYshNkO0Ahb4sCrB
        hXujQn+tPF6OyzG4VLecL6+5R0g4Mo0=
X-Google-Smtp-Source: ABdhPJzKhgJNACGu1sZV0ltRlRNG71QEefYClxwh9ShxvnDQZ0LOs3RdVxjIrcQ0UPLGXJRT3I61ow==
X-Received: by 2002:a7b:c3da:: with SMTP id t26mr5685813wmj.63.1623943368012;
        Thu, 17 Jun 2021 08:22:48 -0700 (PDT)
Received: from localhost.localdomain ([141.226.242.176])
        by smtp.gmail.com with ESMTPSA id o7sm5835910wro.76.2021.06.17.08.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:22:47 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 1/3] ovl: pass ovl_fs to ovl_check_setxattr()
Date:   Thu, 17 Jun 2021 18:22:39 +0300
Message-Id: <20210617152241.987010-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617152241.987010-1-amir73il@gmail.com>
References: <20210617152241.987010-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Instead of passing the overlay dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 10 +++++-----
 fs/overlayfs/dir.c       |  6 ++++--
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h |  6 +++---
 fs/overlayfs/util.c      |  7 +++----
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2846b943e80c..3fa68a5cc16e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -331,8 +331,8 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	return ERR_PTR(err);
 }
 
-int ovl_set_origin(struct ovl_fs *ofs, struct dentry *dentry,
-		   struct dentry *lower, struct dentry *upper)
+int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
+		   struct dentry *upper)
 {
 	const struct ovl_fh *fh = NULL;
 	int err;
@@ -351,7 +351,7 @@ int ovl_set_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	/*
 	 * Do not fail when upper doesn't support xattrs.
 	 */
-	err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh->buf,
+	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
 				 fh ? fh->fb.len : 0, 0);
 	kfree(fh);
 
@@ -526,13 +526,13 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 * hard link.
 	 */
 	if (c->origin) {
-		err = ovl_set_origin(ofs, c->dentry, c->lowerpath.dentry, temp);
+		err = ovl_set_origin(ofs, c->lowerpath.dentry, temp);
 		if (err)
 			return err;
 	}
 
 	if (c->metacopy) {
-		err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
+		err = ovl_check_setxattr(ofs, temp, OVL_XATTR_METACOPY,
 					 NULL, 0, -EOPNOTSUPP);
 		if (err)
 			return err;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 03a22954fe61..9154222883e6 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -233,9 +233,10 @@ struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr)
 static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
 			       int xerr)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	int err;
 
-	err = ovl_check_setxattr(dentry, upper, OVL_XATTR_OPAQUE, "y", 1, xerr);
+	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_OPAQUE, "y", 1, xerr);
 	if (!err)
 		ovl_dentry_set_opaque(dentry);
 
@@ -1045,6 +1046,7 @@ static bool ovl_need_absolute_redirect(struct dentry *dentry, bool samedir)
 static int ovl_set_redirect(struct dentry *dentry, bool samedir)
 {
 	int err;
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	const char *redirect = ovl_dentry_get_redirect(dentry);
 	bool absolute_redirect = ovl_need_absolute_redirect(dentry, samedir);
 
@@ -1055,7 +1057,7 @@ static int ovl_set_redirect(struct dentry *dentry, bool samedir)
 	if (IS_ERR(redirect))
 		return PTR_ERR(redirect);
 
-	err = ovl_check_setxattr(dentry, ovl_dentry_upper(dentry),
+	err = ovl_check_setxattr(ofs, ovl_dentry_upper(dentry),
 				 OVL_XATTR_REDIRECT,
 				 redirect, strlen(redirect), -EXDEV);
 	if (!err) {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 210cd6f66e28..da063b18b419 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -811,7 +811,7 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	if (err)
 		return err;
 
-	err = ovl_set_origin(ofs, dentry, lower, upper);
+	err = ovl_set_origin(ofs, lower, upper);
 	if (!err)
 		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 29d71f253db4..6e3a1bea1c9a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -332,7 +332,7 @@ bool ovl_already_copied_up(struct dentry *dentry, int flags);
 bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry);
 bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
 			 enum ovl_xattr ox);
-int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
+int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
@@ -573,8 +573,8 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 				  bool is_upper);
-int ovl_set_origin(struct ovl_fs *ofs, struct dentry *dentry,
-		   struct dentry *lower, struct dentry *upper);
+int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
+		   struct dentry *upper);
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b9d03627f364..81b8f135445a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -600,12 +600,11 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
 };
 
-int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
+int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr)
 {
 	int err;
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
 	if (ofs->noxattr)
 		return xerr;
@@ -623,6 +622,7 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	int err;
 
 	if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)))
@@ -632,8 +632,7 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	 * Do not fail when upper doesn't support xattrs.
 	 * Upper inodes won't have origin nor redirect xattr anyway.
 	 */
-	err = ovl_check_setxattr(dentry, upperdentry, OVL_XATTR_IMPURE,
-				 "y", 1, 0);
+	err = ovl_check_setxattr(ofs, upperdentry, OVL_XATTR_IMPURE, "y", 1, 0);
 	if (!err)
 		ovl_set_flag(OVL_IMPURE, d_inode(dentry));
 
-- 
2.32.0

