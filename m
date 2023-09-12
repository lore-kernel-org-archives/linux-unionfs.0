Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0014BCA0ECF
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 09:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbjILJ4w (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjILJ4v (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 05:56:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06729E5F
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694512567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YqbbASY003qKulBUHqCJcC0Dpf/dI06U7ZKUlRa8j9I=;
        b=HC2PTkd13PIXACybzlevDfCoRosLkb3nAQU4hhwvzGcu3rG2sW69W2NQBHrwbYihJAbX+5
        B6tCnpuejuJIJ14dBfqiC+cbgehQQjdlrS3aVqn3Sik63J12VC9I68AjqJ4bho3wX+qKIu
        F3AyRYWb0hpV/blpALc6x3TH/xFsOg4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-ha3a81lzNkCcMRTVKQXPDA-1; Tue, 12 Sep 2023 05:56:05 -0400
X-MC-Unique: ha3a81lzNkCcMRTVKQXPDA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-500a9156daaso6114867e87.0
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694512563; x=1695117363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YqbbASY003qKulBUHqCJcC0Dpf/dI06U7ZKUlRa8j9I=;
        b=KE37ptzxVJPdbnXumHLMY5rGEfJ/tqo8tByUflQqeVWic8NSzOprWTnpZWxy/UsHTZ
         m/m6bBE0PVXfOIJK5RoAgJEa4cOxSjdPRZhe2xAwIdk0G1HMACv4/KYYydZ75I3lm3QI
         8XUnWV31CASsHxTxz2VY2bydJw5n2hq4SUoHoUrzO1+xTr639bqtO+rsbXrboj4UBoXT
         iO3XfudirY5ILvFcpW+9fhpjU/6YV5isYe68k7N8rPmbt0T9hySKXKHdgUEHGfz8SvDG
         gzKZg/e0bL2//tXvNksE8zhTeo+1lHyJVgEkl1DaPAN0nKmp4qTyfTrbE16EChJPi/ER
         tnaw==
X-Gm-Message-State: AOJu0YwUy0efWwc4aWnbUWo2KX+YDy9qyVOf9c90VR1F0ANFMFAAgGX0
        PIswYKHRHCBq0pR6lKoLgc4EO3CiriQXMpnn07+FrJdU5CB9PvZz2TUn+npRLIudjTJ3/o70jAp
        f+ovkJzWfzfKo4ptVrVXYn/uSZA==
X-Received: by 2002:a05:6512:14a:b0:4fd:d470:203b with SMTP id m10-20020a056512014a00b004fdd470203bmr9314686lfo.69.1694512563317;
        Tue, 12 Sep 2023 02:56:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYAiy/CzgH0JHN1WND58rvRufsgso7xUFvphVLBZvV2Z8DcPqtKfZenSmU3nbpwUdDNelrYQ==
X-Received: by 2002:a05:6512:14a:b0:4fd:d470:203b with SMTP id m10-20020a056512014a00b004fdd470203bmr9314674lfo.69.1694512562986;
        Tue, 12 Sep 2023 02:56:02 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id t15-20020ac243af000000b004fdba93b92asm1691766lfl.252.2023.09.12.02.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 02:56:02 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 1/5] ovl: Move xattr support to new xattrs.c file
Date:   Tue, 12 Sep 2023 11:55:55 +0200
Message-ID: <15c404ab098dd19f7c02af2241e24bf33b057add.1694512044.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694512044.git.alexl@redhat.com>
References: <cover.1694512044.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This moves the code from super.c and inode.c, and makes ovl_xattr_get/set()
static.

This is in preparation for doing more work on xattrs support.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Makefile    |   2 +-
 fs/overlayfs/inode.c     | 124 ------------------------
 fs/overlayfs/overlayfs.h |  18 ++--
 fs/overlayfs/super.c     |  65 +------------
 fs/overlayfs/xattrs.c    | 198 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 209 insertions(+), 198 deletions(-)
 create mode 100644 fs/overlayfs/xattrs.c

diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 4e173d56b11f..5648954f8588 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
 overlay-objs := super.o namei.o util.o inode.o file.o dir.o readdir.o \
-		copy_up.o export.o params.o
+		copy_up.o export.o params.o xattrs.o
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 83ef66644c21..10b179edb653 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -339,130 +339,6 @@ static const char *ovl_get_link(struct dentry *dentry,
 	return p;
 }
 
-bool ovl_is_private_xattr(struct super_block *sb, const char *name)
-{
-	struct ovl_fs *ofs = OVL_FS(sb);
-
-	if (ofs->config.userxattr)
-		return strncmp(name, OVL_XATTR_USER_PREFIX,
-			       sizeof(OVL_XATTR_USER_PREFIX) - 1) == 0;
-	else
-		return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
-			       sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) == 0;
-}
-
-int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
-		  const void *value, size_t size, int flags)
-{
-	int err;
-	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
-	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
-	struct dentry *realdentry = upperdentry ?: ovl_dentry_lower(dentry);
-	struct path realpath;
-	const struct cred *old_cred;
-
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
-	if (!value && !upperdentry) {
-		ovl_path_lower(dentry, &realpath);
-		old_cred = ovl_override_creds(dentry->d_sb);
-		err = vfs_getxattr(mnt_idmap(realpath.mnt), realdentry, name, NULL, 0);
-		revert_creds(old_cred);
-		if (err < 0)
-			goto out_drop_write;
-	}
-
-	if (!upperdentry) {
-		err = ovl_copy_up(dentry);
-		if (err)
-			goto out_drop_write;
-
-		realdentry = ovl_dentry_upper(dentry);
-	}
-
-	old_cred = ovl_override_creds(dentry->d_sb);
-	if (value) {
-		err = ovl_do_setxattr(ofs, realdentry, name, value, size,
-				      flags);
-	} else {
-		WARN_ON(flags != XATTR_REPLACE);
-		err = ovl_do_removexattr(ofs, realdentry, name);
-	}
-	revert_creds(old_cred);
-
-	/* copy c/mtime */
-	ovl_copyattr(inode);
-
-out_drop_write:
-	ovl_drop_write(dentry);
-out:
-	return err;
-}
-
-int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
-		  void *value, size_t size)
-{
-	ssize_t res;
-	const struct cred *old_cred;
-	struct path realpath;
-
-	ovl_i_path_real(inode, &realpath);
-	old_cred = ovl_override_creds(dentry->d_sb);
-	res = vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, name, value, size);
-	revert_creds(old_cred);
-	return res;
-}
-
-static bool ovl_can_list(struct super_block *sb, const char *s)
-{
-	/* Never list private (.overlay) */
-	if (ovl_is_private_xattr(sb, s))
-		return false;
-
-	/* List all non-trusted xattrs */
-	if (strncmp(s, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) != 0)
-		return true;
-
-	/* list other trusted for superuser only */
-	return ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
-}
-
-ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
-{
-	struct dentry *realdentry = ovl_dentry_real(dentry);
-	ssize_t res;
-	size_t len;
-	char *s;
-	const struct cred *old_cred;
-
-	old_cred = ovl_override_creds(dentry->d_sb);
-	res = vfs_listxattr(realdentry, list, size);
-	revert_creds(old_cred);
-	if (res <= 0 || size == 0)
-		return res;
-
-	/* filter out private xattrs */
-	for (s = list, len = res; len;) {
-		size_t slen = strnlen(s, len) + 1;
-
-		/* underlying fs providing us with an broken xattr list? */
-		if (WARN_ON(slen > len))
-			return -EIO;
-
-		len -= slen;
-		if (!ovl_can_list(dentry->d_sb, s)) {
-			res -= slen;
-			memmove(s, s + slen, len);
-		} else {
-			s += slen;
-		}
-	}
-
-	return res;
-}
-
 #ifdef CONFIG_FS_POSIX_ACL
 /*
  * Apply the idmapping of the layer to POSIX ACLs. The caller must pass a clone
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 9817b2dcb132..7b2a309bd746 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -684,17 +684,8 @@ int ovl_set_nlink_lower(struct dentry *dentry);
 unsigned int ovl_get_nlink(struct ovl_fs *ofs, struct dentry *lowerdentry,
 			   struct dentry *upperdentry,
 			   unsigned int fallback);
-int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
-		struct iattr *attr);
-int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
-		struct kstat *stat, u32 request_mask, unsigned int flags);
 int ovl_permission(struct mnt_idmap *idmap, struct inode *inode,
 		   int mask);
-int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
-		  const void *value, size_t size, int flags);
-int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
-		  void *value, size_t size);
-ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 
 #ifdef CONFIG_FS_POSIX_ACL
 struct posix_acl *do_ovl_get_acl(struct mnt_idmap *idmap,
@@ -830,3 +821,12 @@ static inline bool ovl_force_readonly(struct ovl_fs *ofs)
 {
 	return (!ovl_upper_mnt(ofs) || !ofs->workdir);
 }
+
+/* xattr.c */
+
+const struct xattr_handler **ovl_xattr_handlers(struct ovl_fs *ofs);
+int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+		struct iattr *attr);
+int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
+		struct kstat *stat, u32 request_mask, unsigned int flags);
+ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index def266b5e2a3..a3be13306c73 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -434,68 +434,6 @@ static bool ovl_workdir_ok(struct dentry *workdir, struct dentry *upperdir)
 	return ok;
 }
 
-static int ovl_own_xattr_get(const struct xattr_handler *handler,
-			     struct dentry *dentry, struct inode *inode,
-			     const char *name, void *buffer, size_t size)
-{
-	return -EOPNOTSUPP;
-}
-
-static int ovl_own_xattr_set(const struct xattr_handler *handler,
-			     struct mnt_idmap *idmap,
-			     struct dentry *dentry, struct inode *inode,
-			     const char *name, const void *value,
-			     size_t size, int flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static int ovl_other_xattr_get(const struct xattr_handler *handler,
-			       struct dentry *dentry, struct inode *inode,
-			       const char *name, void *buffer, size_t size)
-{
-	return ovl_xattr_get(dentry, inode, name, buffer, size);
-}
-
-static int ovl_other_xattr_set(const struct xattr_handler *handler,
-			       struct mnt_idmap *idmap,
-			       struct dentry *dentry, struct inode *inode,
-			       const char *name, const void *value,
-			       size_t size, int flags)
-{
-	return ovl_xattr_set(dentry, inode, name, value, size, flags);
-}
-
-static const struct xattr_handler ovl_own_trusted_xattr_handler = {
-	.prefix	= OVL_XATTR_TRUSTED_PREFIX,
-	.get = ovl_own_xattr_get,
-	.set = ovl_own_xattr_set,
-};
-
-static const struct xattr_handler ovl_own_user_xattr_handler = {
-	.prefix	= OVL_XATTR_USER_PREFIX,
-	.get = ovl_own_xattr_get,
-	.set = ovl_own_xattr_set,
-};
-
-static const struct xattr_handler ovl_other_xattr_handler = {
-	.prefix	= "", /* catch all */
-	.get = ovl_other_xattr_get,
-	.set = ovl_other_xattr_set,
-};
-
-static const struct xattr_handler *ovl_trusted_xattr_handlers[] = {
-	&ovl_own_trusted_xattr_handler,
-	&ovl_other_xattr_handler,
-	NULL
-};
-
-static const struct xattr_handler *ovl_user_xattr_handlers[] = {
-	&ovl_own_user_xattr_handler,
-	&ovl_other_xattr_handler,
-	NULL
-};
-
 static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
 			  struct inode **ptrap, const char *name)
 {
@@ -1478,8 +1416,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
 
 	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
-	sb->s_xattr = ofs->config.userxattr ? ovl_user_xattr_handlers :
-		ovl_trusted_xattr_handlers;
+	sb->s_xattr = ovl_xattr_handlers(ofs);
 	sb->s_fs_info = ofs;
 	sb->s_flags |= SB_POSIXACL;
 	sb->s_iflags |= SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGNATURE;
diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
new file mode 100644
index 000000000000..edc7cc49a7c4
--- /dev/null
+++ b/fs/overlayfs/xattrs.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include "overlayfs.h"
+
+bool ovl_is_private_xattr(struct super_block *sb, const char *name)
+{
+	struct ovl_fs *ofs = OVL_FS(sb);
+
+	if (ofs->config.userxattr)
+		return strncmp(name, OVL_XATTR_USER_PREFIX,
+			       sizeof(OVL_XATTR_USER_PREFIX) - 1) == 0;
+	else
+		return strncmp(name, OVL_XATTR_TRUSTED_PREFIX,
+			       sizeof(OVL_XATTR_TRUSTED_PREFIX) - 1) == 0;
+}
+
+static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
+			 const void *value, size_t size, int flags)
+{
+	int err;
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
+	struct dentry *realdentry = upperdentry ?: ovl_dentry_lower(dentry);
+	struct path realpath;
+	const struct cred *old_cred;
+
+	err = ovl_want_write(dentry);
+	if (err)
+		goto out;
+
+	if (!value && !upperdentry) {
+		ovl_path_lower(dentry, &realpath);
+		old_cred = ovl_override_creds(dentry->d_sb);
+		err = vfs_getxattr(mnt_idmap(realpath.mnt), realdentry, name, NULL, 0);
+		revert_creds(old_cred);
+		if (err < 0)
+			goto out_drop_write;
+	}
+
+	if (!upperdentry) {
+		err = ovl_copy_up(dentry);
+		if (err)
+			goto out_drop_write;
+
+		realdentry = ovl_dentry_upper(dentry);
+	}
+
+	old_cred = ovl_override_creds(dentry->d_sb);
+	if (value) {
+		err = ovl_do_setxattr(ofs, realdentry, name, value, size,
+				      flags);
+	} else {
+		WARN_ON(flags != XATTR_REPLACE);
+		err = ovl_do_removexattr(ofs, realdentry, name);
+	}
+	revert_creds(old_cred);
+
+	/* copy c/mtime */
+	ovl_copyattr(inode);
+
+out_drop_write:
+	ovl_drop_write(dentry);
+out:
+	return err;
+}
+
+static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
+			 void *value, size_t size)
+{
+	ssize_t res;
+	const struct cred *old_cred;
+	struct path realpath;
+
+	ovl_i_path_real(inode, &realpath);
+	old_cred = ovl_override_creds(dentry->d_sb);
+	res = vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, name, value, size);
+	revert_creds(old_cred);
+	return res;
+}
+
+static bool ovl_can_list(struct super_block *sb, const char *s)
+{
+	/* Never list private (.overlay) */
+	if (ovl_is_private_xattr(sb, s))
+		return false;
+
+	/* List all non-trusted xattrs */
+	if (strncmp(s, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) != 0)
+		return true;
+
+	/* list other trusted for superuser only */
+	return ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN);
+}
+
+ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
+{
+	struct dentry *realdentry = ovl_dentry_real(dentry);
+	ssize_t res;
+	size_t len;
+	char *s;
+	const struct cred *old_cred;
+
+	old_cred = ovl_override_creds(dentry->d_sb);
+	res = vfs_listxattr(realdentry, list, size);
+	revert_creds(old_cred);
+	if (res <= 0 || size == 0)
+		return res;
+
+	/* filter out private xattrs */
+	for (s = list, len = res; len;) {
+		size_t slen = strnlen(s, len) + 1;
+
+		/* underlying fs providing us with an broken xattr list? */
+		if (WARN_ON(slen > len))
+			return -EIO;
+
+		len -= slen;
+		if (!ovl_can_list(dentry->d_sb, s)) {
+			res -= slen;
+			memmove(s, s + slen, len);
+		} else {
+			s += slen;
+		}
+	}
+
+	return res;
+}
+
+static int ovl_own_xattr_get(const struct xattr_handler *handler,
+			     struct dentry *dentry, struct inode *inode,
+			     const char *name, void *buffer, size_t size)
+{
+	return -EOPNOTSUPP;
+}
+
+static int ovl_own_xattr_set(const struct xattr_handler *handler,
+			     struct mnt_idmap *idmap,
+			     struct dentry *dentry, struct inode *inode,
+			     const char *name, const void *value,
+			     size_t size, int flags)
+{
+	return -EOPNOTSUPP;
+}
+
+static int ovl_other_xattr_get(const struct xattr_handler *handler,
+			       struct dentry *dentry, struct inode *inode,
+			       const char *name, void *buffer, size_t size)
+{
+	return ovl_xattr_get(dentry, inode, name, buffer, size);
+}
+
+static int ovl_other_xattr_set(const struct xattr_handler *handler,
+			       struct mnt_idmap *idmap,
+			       struct dentry *dentry, struct inode *inode,
+			       const char *name, const void *value,
+			       size_t size, int flags)
+{
+	return ovl_xattr_set(dentry, inode, name, value, size, flags);
+}
+
+static const struct xattr_handler ovl_own_trusted_xattr_handler = {
+	.prefix	= OVL_XATTR_TRUSTED_PREFIX,
+	.get = ovl_own_xattr_get,
+	.set = ovl_own_xattr_set,
+};
+
+static const struct xattr_handler ovl_own_user_xattr_handler = {
+	.prefix	= OVL_XATTR_USER_PREFIX,
+	.get = ovl_own_xattr_get,
+	.set = ovl_own_xattr_set,
+};
+
+static const struct xattr_handler ovl_other_xattr_handler = {
+	.prefix	= "", /* catch all */
+	.get = ovl_other_xattr_get,
+	.set = ovl_other_xattr_set,
+};
+
+static const struct xattr_handler *ovl_trusted_xattr_handlers[] = {
+	&ovl_own_trusted_xattr_handler,
+	&ovl_other_xattr_handler,
+	NULL
+};
+
+static const struct xattr_handler *ovl_user_xattr_handlers[] = {
+	&ovl_own_user_xattr_handler,
+	&ovl_other_xattr_handler,
+	NULL
+};
+
+const struct xattr_handler **ovl_xattr_handlers(struct ovl_fs *ofs)
+{
+	return ofs->config.userxattr ? ovl_user_xattr_handlers :
+		ovl_trusted_xattr_handlers;
+}
+
-- 
2.41.0

