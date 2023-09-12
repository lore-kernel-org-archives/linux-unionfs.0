Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0589ECA0ECA
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 09:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbjILJ5B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjILJ5A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 05:57:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0C44E6D
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694512570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yyh1wyrw9pQ8Gv+42y0urg8105iBepDA/ve4Qegyxkg=;
        b=LOY2o7LKmUfN6paz7IFPDrNEtZiBxREJtPItRs5BY6UYtGOMue/JL8+30UwLJo4vIlf1oQ
        d3WQKdcDf4vDaDYya4cFKMgv3HqQI4vwzASJAF5NCE2spN0LwjblimpgBLiwkpy/JNm8t5
        qme9mQdWMQHkgoE7KORQYMoZbLSAocM=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-c76zofuhPUejeG1DuVt95w-1; Tue, 12 Sep 2023 05:56:07 -0400
X-MC-Unique: c76zofuhPUejeG1DuVt95w-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2bcec24e8f8so60451751fa.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694512566; x=1695117366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yyh1wyrw9pQ8Gv+42y0urg8105iBepDA/ve4Qegyxkg=;
        b=JESmJcDczfKnIvZJrVVmhe0YMimAMBLkseHMMb4BxrTj/gnfuzG7S+qbTzddUxb8n8
         Bi/Mg6Ea3H6zL9wPJDOR7J0Csc5SKhSNkOewM4hhhb8G/haVO8t27+e6o+8gkB3MCsut
         fKi0zR+o9KRkqXridZwaJoF8L26EstmpzVHer90K2XlMB4QZzuXxvRrNBq4pkKwAg4Gw
         24CKAF+CVC2/ZQfovhqeudCF40DLH42UvDRuq/CJAao7Y2KVVnAOEdjb9FxeGHKw1ifT
         aDGyiz8Mpd6mBjCISDt9XKktcJhAjqla2TfCvCYO3XUeAgGZNsx/wG0KMZ1qpmUEFd90
         0d8g==
X-Gm-Message-State: AOJu0YzGetIr/Ora+UYYwE5YLpzyRwp4ziJ0Ws0sZKp4uK58y74ypgNd
        coIwdy5QAxNPFUt8gqJyHZxEcWawYqI67WGKKc32EuNCjidArspAR20Fei1FV0DeR+dGBBmT7rT
        IDU7A29b9lWRIa6ngC1HvYI9Gzg==
X-Received: by 2002:a19:2d02:0:b0:4fe:711:2931 with SMTP id k2-20020a192d02000000b004fe07112931mr9115291lfj.22.1694512565917;
        Tue, 12 Sep 2023 02:56:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZSFFIvMimA3d3JKm1Boh1cCyIdNaycUYvINgJhOExVJS4hPJmTQfF45JvDapDAwvXOSSdSQ==
X-Received: by 2002:a19:2d02:0:b0:4fe:711:2931 with SMTP id k2-20020a192d02000000b004fe07112931mr9115285lfj.22.1694512565605;
        Tue, 12 Sep 2023 02:56:05 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id t15-20020ac243af000000b004fdba93b92asm1691766lfl.252.2023.09.12.02.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 02:56:04 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 3/5] ovl: Support escaped overlay.* xattrs
Date:   Tue, 12 Sep 2023 11:55:57 +0200
Message-ID: <852732d9ae04ed940957a9fd2194af7a55d81c82.1694512044.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694512044.git.alexl@redhat.com>
References: <cover.1694512044.git.alexl@redhat.com>
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
"overlay.overlay.XYZ", we list it as "overlay.XYZ" in listxattrs, and
when the user calls getxattr or setxattr on "overlay.XYZ", we apply to
"overlay.overlay.XYZ" in the backing directories.

This allows storing any kind of overlay xattrs in a overlayfs mount
that can be used as a lowerdir in another mount. It is possible to
stack this mechanism multiple times, such that
"overlay.overlay.overlay.XYZ" will survive two levels of overlay mounts,
however this is not all that useful in practice because of stack depth
limitations of overlayfs mounts.

Note: These escaped xattrs are copied to upper during copy-up.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  7 ++++
 fs/overlayfs/xattrs.c    | 81 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index dff7232b7bf5..736d7f952a8e 100644
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
diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index b8ea96606ea8..55ab56e982ea 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -4,7 +4,19 @@
 #include <linux/xattr.h>
 #include "overlayfs.h"
 
-bool ovl_is_private_xattr(struct super_block *sb, const char *name)
+static bool ovl_is_escaped_xattr(struct super_block *sb, const char *name)
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
+static bool ovl_is_prefixed_xattr(struct super_block *sb, const char *name)
 {
 	struct ovl_fs *ofs = OVL_FS(sb);
 
@@ -16,6 +28,11 @@ bool ovl_is_private_xattr(struct super_block *sb, const char *name)
 			       OVL_XATTR_TRUSTED_PREFIX_LEN) == 0;
 }
 
+bool ovl_is_private_xattr(struct super_block *sb, const char *name)
+{
+	return ovl_is_prefixed_xattr(sb, name) && !ovl_is_escaped_xattr(sb, name);
+}
+
 static int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 			 const void *value, size_t size, int flags)
 {
@@ -97,10 +114,12 @@ static bool ovl_can_list(struct super_block *sb, const char *s)
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 {
 	struct dentry *realdentry = ovl_dentry_real(dentry);
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	ssize_t res;
 	size_t len;
 	char *s;
 	const struct cred *old_cred;
+	size_t prefix_len, name_len;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	res = vfs_listxattr(realdentry, list, size);
@@ -108,6 +127,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	if (res <= 0 || size == 0)
 		return res;
 
+	prefix_len = ofs->config.userxattr ?
+		OVL_XATTR_USER_PREFIX_LEN : OVL_XATTR_TRUSTED_PREFIX_LEN;
+
 	/* filter out private xattrs */
 	for (s = list, len = res; len;) {
 		size_t slen = strnlen(s, len) + 1;
@@ -120,6 +142,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 		if (!ovl_can_list(dentry->d_sb, s)) {
 			res -= slen;
 			memmove(s, s + slen, len);
+		} else if (ovl_is_escaped_xattr(dentry->d_sb, s)) {
+			res -= OVL_XATTR_ESCAPE_PREFIX_LEN;
+			name_len = slen - prefix_len - OVL_XATTR_ESCAPE_PREFIX_LEN;
+			s += prefix_len;
+			memmove(s, s + OVL_XATTR_ESCAPE_PREFIX_LEN, name_len + len);
+			s += name_len;
 		} else {
 			s += slen;
 		}
@@ -128,11 +156,47 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	return res;
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
@@ -141,7 +205,18 @@ static int ovl_own_xattr_set(const struct xattr_handler *handler,
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

