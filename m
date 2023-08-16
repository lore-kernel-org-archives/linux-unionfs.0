Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F0BC04FDF
	for <linux-unionfs@archiver.kernel.org>; Wed, 16 Aug 2023 15:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344024AbjHPPa4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 16 Aug 2023 11:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344180AbjHPPak (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2023 11:30:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55033268D
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692199791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGW4J1IfIR1iDZurIdeJoL/jYmIhyqhqD0bhYr6dMRk=;
        b=VYPOkc7fUrsA8QJrKjmvq/JAHnpQF31oGXbZ36oVmPYH9Lj85evRmRn9EaAtcOysCgiwDh
        +l7gHa5an9f5GNQkwCvL/xVZ4kpLw3NG2YAgjfJrrZqfeWdGPVEo/o3sYyjUENBJSAcihh
        T9olcCSIvFQQLeKQR2lFA/wq4bfGGQg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-RvMo_dvlMvi27Bx9crQ9bA-1; Wed, 16 Aug 2023 11:29:50 -0400
X-MC-Unique: RvMo_dvlMvi27Bx9crQ9bA-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b9e014111fso65847861fa.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 08:29:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692199788; x=1692804588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mGW4J1IfIR1iDZurIdeJoL/jYmIhyqhqD0bhYr6dMRk=;
        b=c/0iZ4EBkPUvdLOEeD4uHVvU3Nj6ZExVV/djPENISbYFlH9h5YeHiRdkty3jNBCxIP
         Y6catbiYenZi7SC2WNcApPzDb0q2OU+6Td3js8ID5s+j/2gXf4CVPbMyEVI6BbGBLekn
         /tDBL5pdimtcr+kx/CsSXnmqf/ws0tcarreq2Ov2bdJqO2IOsaqGSSw068ol8zu7PJYe
         SMiWtStNVB/9Ob54bvnG0FXXleozlmgdNGIcv6T62spiiOakgqDAoOj3VEQbvQkn9mJu
         yxo4FhSBE5V0FeGJMpqnjN0BkglhJnySVVkfrkvWxqCPr5g4UpNQgbNWc9mtedvLYhCD
         C6AA==
X-Gm-Message-State: AOJu0YwUmNdSM2EcT2aLdnLKFP853osUv+EutkX8hoNcIuQO88aRITNa
        EFHwfSw13EGMihRYxOtgsk44TKQNjCoYTL/IqUFZs3WuCIvmNTWb/kQirnkgCGR9eTmz7y0T9AY
        tmK6QHBmcyfyTCLupMUk28Q5I6fVNOO8+rg==
X-Received: by 2002:a2e:86c2:0:b0:2b6:c528:4940 with SMTP id n2-20020a2e86c2000000b002b6c5284940mr1747145ljj.3.1692199788648;
        Wed, 16 Aug 2023 08:29:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdx1evdhbEo4aqpNycAZeHF9BLrs40kizDVbAUy6NtUH8T8ESSzWKkf5RuoX082Z7V9MZFQQ==
X-Received: by 2002:a2e:86c2:0:b0:2b6:c528:4940 with SMTP id n2-20020a2e86c2000000b002b6c5284940mr1747133ljj.3.1692199788371;
        Wed, 16 Aug 2023 08:29:48 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id c13-20020a2e9d8d000000b002b9f03729e2sm3523160ljj.36.2023.08.16.08.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 08:29:47 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 2/4] ovl: Support escaped overlay.* xattrs
Date:   Wed, 16 Aug 2023 17:29:40 +0200
Message-ID: <511f90c1f5425c4536381aef8146ef2b1b0b1326.1692198910.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692198910.git.alexl@redhat.com>
References: <cover.1692198910.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There are cases where you want to use an overlayfs mount as a lowerdir
for another overlayfs mount. For example, if the system rootfs is on
overlayfs due to composefs, or to make it volatile (via tmps), then
you cannot currently store a lowerdir on the rootfs. This means you
can't e.g. store on the rootfs a prepared container image for use
using overlayfs.

To work around this, we introduce an escapment mechanism for overlayfs
xattrs. Whenever the lower/upper dir has a xattr named
`overlay.overlay.XYZ`, we list it as overlay.XYZ in listxattrs, and
when the user calls getxattr or setxattr on `overlay.XYZ`, we apply to
`overlay.overlay.XYZ` in the backing directories.

This allows storing any kind of overlay xattrs in a overlayfs mount
that can be used as a lowerdir in another mount. It is possible to
stack this mechanism multiple times, such that
overlay.overlay.overlay.XYZ will survive two levels of overlay mounts,
however this is not all that useful in practice because of stack depth
limitations of overlayfs mounts.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/inode.c     | 27 +++++++++++++++++++--
 fs/overlayfs/overlayfs.h |  7 ++++++
 fs/overlayfs/super.c     | 51 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 2dccf3f7fcbe..743951c11534 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -339,6 +339,18 @@ static const char *ovl_get_link(struct dentry *dentry,
 	return p;
 }
 
+bool ovl_is_escaped_xattr(struct super_block *sb, const char *name)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	if (ofs->config.userxattr)
+		return strncmp(name, OVL_XATTR_ESCAPE_USER_PREFIX,
+			       OVL_XATTR_ESCAPE_USER_PREFIX_LEN) == 0;
+	else
+		return strncmp(name, OVL_XATTR_ESCAPE_TRUSTED_PREFIX,
+			       OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN - 1) == 0;
+}
+
 bool ovl_is_private_xattr(struct super_block *sb, const char *name)
 {
 	struct ovl_fs *ofs = OVL_FS(sb);
@@ -417,8 +429,8 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 
 static bool ovl_can_list(struct super_block *sb, const char *s)
 {
-	/* Never list private (.overlay) */
-	if (ovl_is_private_xattr(sb, s))
+	/* Never list non-escaped private (.overlay) */
+	if (ovl_is_private_xattr(sb, s) && !ovl_is_escaped_xattr(sb, s))
 		return false;
 
 	/* List all non-trusted xattrs */
@@ -432,10 +444,12 @@ static bool ovl_can_list(struct super_block *sb, const char *s)
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 {
 	struct dentry *realdentry = ovl_dentry_real(dentry);
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	ssize_t res;
 	size_t len;
 	char *s;
 	const struct cred *old_cred;
+	size_t prefix_len;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	res = vfs_listxattr(realdentry, list, size);
@@ -443,6 +457,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	if (res <= 0 || size == 0)
 		return res;
 
+	prefix_len = ofs->config.userxattr ?
+		OVL_XATTR_USER_PREFIX_LEN : OVL_XATTR_TRUSTED_PREFIX_LEN;
+
 	/* filter out private xattrs */
 	for (s = list, len = res; len;) {
 		size_t slen = strnlen(s, len) + 1;
@@ -455,6 +472,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 		if (!ovl_can_list(dentry->d_sb, s)) {
 			res -= slen;
 			memmove(s, s + slen, len);
+		} else if (ovl_is_escaped_xattr(dentry->d_sb, s)) {
+			memmove(s + prefix_len,
+				s + prefix_len + OVL_XATTR_ESCAPE_PREFIX_LEN,
+				slen - (prefix_len + OVL_XATTR_ESCAPE_PREFIX_LEN) + len);
+			res -= OVL_XATTR_ESCAPE_PREFIX_LEN;
+			s += slen - OVL_XATTR_ESCAPE_PREFIX_LEN;
 		} else {
 			s += slen;
 		}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 33f88b524627..1dbd01719f63 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -32,6 +32,13 @@ enum ovl_path_type {
 #define OVL_XATTR_USER_PREFIX XATTR_USER_PREFIX OVL_XATTR_NAMESPACE
 #define OVL_XATTR_USER_PREFIX_LEN (sizeof(OVL_XATTR_USER_PREFIX) - 1)
 
+#define OVL_XATTR_ESCAPE_PREFIX OVL_XATTR_NAMESPACE
+#define OVL_XATTR_ESCAPE_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_PREFIX) - 1)
+#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX OVL_XATTR_TRUSTED_PREFIX OVL_XATTR_ESCAPE_PREFIX
+#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_TRUSTED_PREFIX) - 1)
+#define OVL_XATTR_ESCAPE_USER_PREFIX OVL_XATTR_USER_PREFIX OVL_XATTR_ESCAPE_PREFIX
+#define OVL_XATTR_ESCAPE_USER_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_USER_PREFIX) - 1)
+
 enum ovl_xattr {
 	OVL_XATTR_OPAQUE,
 	OVL_XATTR_REDIRECT,
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index def266b5e2a3..97bc94459f7a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -434,11 +434,47 @@ static bool ovl_workdir_ok(struct dentry *workdir, struct dentry *upperdir)
 	return ok;
 }
 
+static char *ovl_xattr_escape_name(const char *prefix, const char *name)
+{
+	size_t prefix_len = strlen(prefix);
+	size_t name_len = strlen(name);
+	size_t escaped_len;
+	char *escaped, *s;
+
+	escaped_len = prefix_len + OVL_XATTR_ESCAPE_PREFIX_LEN + name_len;
+	if (escaped_len > XATTR_NAME_MAX)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	escaped = kmalloc(escaped_len + 1, GFP_KERNEL);
+	if (escaped == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	s = escaped;
+	memcpy(s, prefix, prefix_len);
+	s += prefix_len;
+	memcpy(s, OVL_XATTR_ESCAPE_PREFIX, OVL_XATTR_ESCAPE_PREFIX_LEN);
+	s += OVL_XATTR_ESCAPE_PREFIX_LEN;
+	memcpy(s, name, name_len + 1);
+
+	return escaped;
+}
+
 static int ovl_own_xattr_get(const struct xattr_handler *handler,
 			     struct dentry *dentry, struct inode *inode,
 			     const char *name, void *buffer, size_t size)
 {
-	return -EOPNOTSUPP;
+	char *escaped;
+	int r;
+
+	escaped = ovl_xattr_escape_name(handler->prefix, name);
+	if (IS_ERR(escaped))
+		return PTR_ERR(escaped);
+
+	r = ovl_xattr_get(dentry, inode, escaped, buffer, size);
+
+	kfree(escaped);
+
+	return r;
 }
 
 static int ovl_own_xattr_set(const struct xattr_handler *handler,
@@ -447,7 +483,18 @@ static int ovl_own_xattr_set(const struct xattr_handler *handler,
 			     const char *name, const void *value,
 			     size_t size, int flags)
 {
-	return -EOPNOTSUPP;
+	char *escaped;
+	int r;
+
+	escaped = ovl_xattr_escape_name(handler->prefix, name);
+	if (IS_ERR(escaped))
+		return PTR_ERR(escaped);
+
+	r = ovl_xattr_set(dentry, inode, escaped, value, size, flags);
+
+	kfree(escaped);
+
+	return r;
 }
 
 static int ovl_other_xattr_get(const struct xattr_handler *handler,
-- 
2.41.0

