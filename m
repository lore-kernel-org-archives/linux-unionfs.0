Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7D8C2FC18
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 11:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350109AbjHQLGX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350158AbjHQLGU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 07:06:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3122D4A
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692270332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vXTVuEBmfYUzoynIN4uLPrgO36XLIwyf9C49xPBpr/0=;
        b=ElsOrWaYa22PS9/sYehfK79vQIpNz4U8N+HFMSLARGQks9mNhS0UkDp4lgK8FmFCl9ntqq
        RYVBYms6KHnq9OMbt+DwT5Tykz1Ae2yOxKRN8CqD75EemMzmPTcrWvILVWGg9biGuL8sFv
        fYpBSR+OBID4hX6CgoApNhemlBzXWAk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-NPAwq9twOLiU3lyt3sgjcw-1; Thu, 17 Aug 2023 07:05:31 -0400
X-MC-Unique: NPAwq9twOLiU3lyt3sgjcw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b980182002so4658591fa.1
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692270330; x=1692875130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXTVuEBmfYUzoynIN4uLPrgO36XLIwyf9C49xPBpr/0=;
        b=KzgVo38UtoCzJsv8rCswYyIpxb68pW/9nLbWFY1q6qWWMg10wdSmjim6E6ukIq4kcd
         5Hy0+yNp16mg2I9B2o1hq5JGz1GTYaH6xvxe/uucvO7cC8gCJed3Nx9o0VGFQ/h1ZXBH
         OX9yeJ0BicFp2319VNLUnJoyP6sdiLvaFTVOLkB3Wl8SBMS5xS6xGK2uTAlt09146j4s
         uf1n/kM9MFKQm277HH/xJ0eM/QLXni33lMdh8wi0MTfLWIlk16x/F2KIuckXpBSbuhKA
         1IZg9XR8je9I9vXqkgxpQLlVF7WmJ08tyktSt2a02VSKpGsvlM1O+hR3KVRXBZ9wMgfz
         Ikcg==
X-Gm-Message-State: AOJu0YyFqvAWpKuABJLZxYGnVWv7q3+pewIhSo3tRPePCCW12dM6WttZ
        RrOA214o+0WmvuM5sM8x2P0Nt1j7HEwXwAPN2sdBLB/D5hc2IMfkGhdjK32Usg2iy0a4vlDqSCK
        9NUK3c6fdjVnlF5fq8XxjRXf8zw==
X-Received: by 2002:a2e:700f:0:b0:2bb:94e4:6b07 with SMTP id l15-20020a2e700f000000b002bb94e46b07mr895305ljc.12.1692270330011;
        Thu, 17 Aug 2023 04:05:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkh7gMbpJV3MP/NUt00a9n699Vr6lgYo4vD2YeXqFygtKTy/L+T6VVl4rz00gOd005BDi6NA==
X-Received: by 2002:a2e:700f:0:b0:2bb:94e4:6b07 with SMTP id l15-20020a2e700f000000b002bb94e46b07mr895301ljc.12.1692270329738;
        Thu, 17 Aug 2023 04:05:29 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id l20-20020a2e8694000000b002ba15c272e8sm69010lji.71.2023.08.17.04.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 04:05:29 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 3/5] ovl: Support escaped overlay.* xattrs
Date:   Thu, 17 Aug 2023 13:05:22 +0200
Message-ID: <c303fe8cdcafade9583b390d13b2a5d56e122d58.1692270188.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692270188.git.alexl@redhat.com>
References: <cover.1692270188.git.alexl@redhat.com>
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
index ef993a543b2a..311e1f37ce84 100644
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

