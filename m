Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC24C001DC
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 12:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbjGMMEE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 08:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbjGMMED (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 08:04:03 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A1F1FCD
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:04:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3fbf7fbe722so5613595e9.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689249841; x=1691841841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h56SDqsggxzwAgqwlvJBkfjjXuZAbLChWWr0hrnSBUQ=;
        b=bNRDXAgc9OWVdcPLeaXxAIi+TtaflJPwnrmXRa6I3xGXg3GQzXJWK2rYGE27p6rIvn
         ITYvNiG9i6LGqSmlQVajcvb47ptvPUxwSPMISTdA0/nbg3cXM0VPMfyc7fJh7M9JF5Hu
         uHlce9y+14jC2RyQjTlk9jvFzyVr1LGlzxCPG2w1wZL2eN7r6LDhhjRL8uZJhnjvlEif
         y5W5davY/wo0HgVUXpxYRtMzTfF3a8OA9xjH+KKNXBEZE/145dYA8IpcXuKhg3gHvUMW
         tHZ7/zYXaUL7wKhuS9rDPJPSHjzwqKo3uZpitSCvr0y6Mw7gUiFS1fv4vF6XM7c4fASf
         7KLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689249841; x=1691841841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h56SDqsggxzwAgqwlvJBkfjjXuZAbLChWWr0hrnSBUQ=;
        b=iexBM+qFg9flqxR9HRq2h1KkK3AkAwrcpSgaVFgZoeIzKow+PSLmf2EVFI5aaOB54s
         3ME2FYqUF4JmvKLTX04nXkCeLm5NfoGi+g1VtnFM/juzfGWlhrstU9wD3KOpHb33t51e
         F+gYLlaQKlAevq38DE4g3RtWfmwrzAHl8gkWk5jRtFHjqwh75hgXz63zhconpBopkjbA
         iYHxMIaxczXyQoFY7dBHMv+cH4nb0Ma9q/a80npBouk5bqKX4tsZzd5EngNGCb0Fn+hL
         sVyYk0X+6IQxJMv1oPMmsnZ1sdTflQROCpA28rxqk/sUK9VJUkNfB5VgPn42IDC1c9fO
         /jJw==
X-Gm-Message-State: ABy/qLYHZfX8c+UXDLEqFSt382Il3ocQVGlMP+DgujAmjfRfS4hHbiM+
        MvsHZgl4Xpqw3n30dDGQKyk=
X-Google-Smtp-Source: APBJJlHr+GolVi/FSJtiYVhCogIeLI7x6qxPCKy0SOLbEMxCtcRdTWTBakrn1B1ThHpj5iz4qBf10A==
X-Received: by 2002:adf:fe0e:0:b0:314:4f36:88 with SMTP id n14-20020adffe0e000000b003144f360088mr1606208wrr.38.1689249840428;
        Thu, 13 Jul 2023 05:04:00 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id cr13-20020a05600004ed00b003143ba62cf4sm7848772wrb.86.2023.07.13.05.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 05:04:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 3/4] ovl: store persistent uuid/fsid with uuid=on
Date:   Thu, 13 Jul 2023 15:03:43 +0300
Message-Id: <20230713120344.1422468-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230713120344.1422468-1-amir73il@gmail.com>
References: <20230713120344.1422468-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

With uuid=on, store a persistent uuid in xattr on the upper dir to
give the overlayfs instance a persistent identifier.

This also makes f_fsid persistent and more reliable for reporting
fid info in fanotify events.

uuid=on is not supported on non-upper overlayfs or with upper fs
that does not support xattrs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst |  3 ++
 fs/overlayfs/overlayfs.h                |  3 ++
 fs/overlayfs/params.c                   |  5 ++++
 fs/overlayfs/super.c                    | 10 +++++--
 fs/overlayfs/util.c                     | 39 +++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index d55381d3fa0f..8275ed735f77 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -671,6 +671,9 @@ controlled by the "uuid" mount option, which supports these values:
     UUID of underlying layers is ignored.
 - "on":
     UUID of overlayfs is generated and used to report a unique fsid.
+    UUID is stored in xattr "trusted.overlay.uuid", making overlayfs fsid
+    unique and persistent.  This option requires an overlayfs with upper
+    filesystem that supports xattrs.
 
 
 Volatile mount
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 000dd89fe319..8b026d758eaf 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -37,6 +37,7 @@ enum ovl_xattr {
 	OVL_XATTR_IMPURE,
 	OVL_XATTR_NLINK,
 	OVL_XATTR_UPPER,
+	OVL_XATTR_UUID,
 	OVL_XATTR_METACOPY,
 	OVL_XATTR_PROTATTR,
 };
@@ -465,6 +466,8 @@ bool ovl_already_copied_up(struct dentry *dentry, int flags);
 bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 			      enum ovl_xattr ox);
 bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *path);
+bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
+			 const struct path *upperpath);
 
 static inline bool ovl_check_origin_xattr(struct ovl_fs *ofs,
 					  struct dentry *upperdentry)
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 1ff93467e793..5a59c87c1dfe 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -801,6 +801,11 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->ovl_volatile = false;
 	}
 
+	if (!config->upperdir && config->uuid == OVL_UUID_ON) {
+		pr_info("option \"uuid=on\" requires an upper fs, falling back to uuid=null.\n");
+		config->uuid = OVL_UUID_NULL;
+	}
+
 	/* Resolve verity -> metacopy dependency */
 	if (config->verity_mode && !config->metacopy) {
 		/* Don't allow explicit specified conflicting combinations */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9c937bc85194..6cb8a8180702 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -777,6 +777,10 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			ofs->config.index = false;
 			pr_warn("...falling back to index=off.\n");
 		}
+		if (ovl_has_fsid(ofs)) {
+			ofs->config.uuid = OVL_UUID_NULL;
+			pr_warn("...falling back to uuid=null.\n");
+		}
 		/*
 		 * xattr support is required for persistent st_ino.
 		 * Without persistent st_ino, xino=auto falls back to xino=off.
@@ -1427,9 +1431,9 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!ovl_origin_uuid(ofs) && ofs->numfs > 1) {
 		pr_warn("The uuid=off requires a single fs for lower and upper, falling back to uuid=null.\n");
 		ofs->config.uuid = OVL_UUID_NULL;
-	} else if (ovl_has_fsid(ofs)) {
-		/* Use per instance uuid/fsid */
-		uuid_gen(&sb->s_uuid);
+	} else if (ovl_has_fsid(ofs) && ovl_upper_mnt(ofs)) {
+		/* Use per instance persistent uuid/fsid */
+		ovl_init_uuid_xattr(sb, ofs, &ctx->upper);
 	}
 
 	if (!ovl_force_readonly(ofs) && ofs->config.index) {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 500133f196d7..8602982ae579 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -676,6 +676,43 @@ bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *path)
 	return false;
 }
 
+/*
+ * Load persistent uuid from xattr into s_uuid if found, or store a new
+ * random generated value in s_uuid and in xattr.
+ */
+bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
+			 const struct path *upperpath)
+{
+	bool set = false;
+	int res;
+
+	/* Try to load existing persistent uuid */
+	res = ovl_path_getxattr(ofs, upperpath, OVL_XATTR_UUID, sb->s_uuid.b,
+				UUID_SIZE);
+	if (res == UUID_SIZE)
+		return true;
+
+	if (res != -ENODATA)
+		goto fail;
+
+	/* Generate overlay instance uuid */
+	uuid_gen(&sb->s_uuid);
+
+	/* Try to store persistent uuid */
+	set = true;
+	res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID, sb->s_uuid.b,
+			   UUID_SIZE);
+	if (res == 0)
+		return true;
+
+fail:
+	memset(sb->s_uuid.b, 0, UUID_SIZE);
+	ofs->config.uuid = OVL_UUID_NULL;
+	pr_warn("failed to %s uuid (%pd2, err=%i); falling back to uuid=null.\n",
+		set ? "set" : "get", upperpath->dentry, res);
+	return false;
+}
+
 bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 			       enum ovl_xattr ox)
 {
@@ -698,6 +735,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 #define OVL_XATTR_IMPURE_POSTFIX	"impure"
 #define OVL_XATTR_NLINK_POSTFIX		"nlink"
 #define OVL_XATTR_UPPER_POSTFIX		"upper"
+#define OVL_XATTR_UUID_POSTFIX		"uuid"
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
 #define OVL_XATTR_PROTATTR_POSTFIX	"protattr"
 
@@ -712,6 +750,7 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_IMPURE),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_NLINK),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UUID),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
 };
-- 
2.34.1

