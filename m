Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F42EC8743
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 17:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbjIGRQj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242256AbjIGRQg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 13:16:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EA391
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 10:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694106861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/iRSAOZqcgap6eZo/OIU9reCRxZANsZSTzbSa+C4HuU=;
        b=QqdT4Zqx9dLUAlJKGMPq6LJJj5QRtSqf1Tcp8gznhoniQPAaO60Sz77YnD/tWQcIoVYJ7w
        DinpUgHZXNFhC5A/Gahz07Yi1+/jgs6w8DEM5hzkMiY6W4Gev6ok4PL7ZlnnjaKFT0jkvm
        oUHrZVTY7/z5ZQvy28T3dPq+81DB4LE=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-3M6JFT5FNr-doFMklTRdTw-1; Thu, 07 Sep 2023 04:44:21 -0400
X-MC-Unique: 3M6JFT5FNr-doFMklTRdTw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b6ff15946fso7697521fa.2
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 01:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694076259; x=1694681059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/iRSAOZqcgap6eZo/OIU9reCRxZANsZSTzbSa+C4HuU=;
        b=BsjXhs/9b9WPmryH/KOuFs2D6LGYwq+Payw3c81tJ5KHceYarQblqBIx4rmtfgpHd9
         lb5M+XyO8pZkb2RCBcz+FigDbGqU3iwWF+HfdfJnkUdrAMhO9sPCzxpzaz7O/cTWw9Dt
         9BtiKarhKQy9EkWeSg2tSiRh+ShcGLOzwiMZp6MTRNHeae5qehfpPUbZqB3ry8tL+SGr
         GtQGy/h+M36SV3OH64z+8uhg+rrdSACeegMVxxfRG1vqO3sRIZwIfNcgJvQqOyOG1Sn5
         4aHUEc/rQjyw558kDchJuVa2sSVRR4NR/mt1hYEbQuO4OOgQI+BDB0gwR012/tpJeelE
         WXGQ==
X-Gm-Message-State: AOJu0Yz9ogYR2LwjF4Sj99M7zv+MDQCZqVKM3zAXaYbw52XY4w3z0kHl
        yGXNuS1nDAIVk19PJft911u2cXH8y2HIItXTroPFocZ6U9AoEZqCzQVOebU8UuCjA4M4tyZzFEn
        laIGMOoCuJ0uOjNfVRXSjDw83vifN6nnpgA==
X-Received: by 2002:a2e:b60f:0:b0:2bb:b01a:9226 with SMTP id r15-20020a2eb60f000000b002bbb01a9226mr4407130ljn.7.1694076259242;
        Thu, 07 Sep 2023 01:44:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrYt6a+wSWNp/TfNK+oJ1rI/3yyWsMG7LrlqF6M99rSpoalw3reTcEHomntgCWKF2DMfvsTA==
X-Received: by 2002:a2e:b60f:0:b0:2bb:b01a:9226 with SMTP id r15-20020a2eb60f000000b002bbb01a9226mr4407124ljn.7.1694076258993;
        Thu, 07 Sep 2023 01:44:18 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id o6-20020a2e9b46000000b002b70a64d4desm3812828ljj.46.2023.09.07.01.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 01:44:18 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 3/6] ovl: Support escaped overlay.* xattrs
Date:   Thu,  7 Sep 2023 10:44:08 +0200
Message-ID: <5c18d058e189f488ff87b7fdba231cf356e91789.1694075674.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694075674.git.alexl@redhat.com>
References: <cover.1694075674.git.alexl@redhat.com>
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
 fs/overlayfs/overlayfs.h |  7 ++++
 fs/overlayfs/xattrs.c    | 78 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 81 insertions(+), 4 deletions(-)

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
index b8ea96606ea8..27b31f812eb1 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -4,6 +4,18 @@
 #include <linux/xattr.h>
 #include "overlayfs.h"
 
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
@@ -82,8 +94,8 @@ static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char
 
 static bool ovl_can_list(struct super_block *sb, const char *s)
 {
-	/* Never list private (.overlay) */
-	if (ovl_is_private_xattr(sb, s))
+	/* Never list non-escaped private (.overlay) */
+	if (ovl_is_private_xattr(sb, s) && !ovl_is_escaped_xattr(sb, s))
 		return false;
 
 	/* List all non-trusted xattrs */
@@ -97,10 +109,12 @@ static bool ovl_can_list(struct super_block *sb, const char *s)
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
@@ -108,6 +122,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	if (res <= 0 || size == 0)
 		return res;
 
+	prefix_len = ofs->config.userxattr ?
+		OVL_XATTR_USER_PREFIX_LEN : OVL_XATTR_TRUSTED_PREFIX_LEN;
+
 	/* filter out private xattrs */
 	for (s = list, len = res; len;) {
 		size_t slen = strnlen(s, len) + 1;
@@ -120,6 +137,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
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
@@ -128,11 +151,47 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
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
@@ -141,7 +200,18 @@ static int ovl_own_xattr_set(const struct xattr_handler *handler,
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

