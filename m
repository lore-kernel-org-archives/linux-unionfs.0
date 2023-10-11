Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDC2CDB468
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Oct 2023 16:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjJKQqo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 12:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbjJKQqf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2023 12:46:35 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BE18F
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 09:46:32 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4075c58ac39so763595e9.3
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2023 09:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697042790; x=1697647590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RJqFA+s/mSPU1XInzGqIfTATa62Q4sl69T8M5JbscGQ=;
        b=ecan99vpddHANYl/qUyZ1UFEBwwSVErLHQ4G5ZrAmNFOAOLwjSmsVJqcztVS1mWzn7
         5QqhKYi8j3T+hAjZsjiEr8lJakuFWyK9mLWpoAcUnqZEHMItSfHTPPdMmGLbouV77FeL
         SfRedU5jB8N1ggJD5VEzqgFUcCSa6HUogD/md6AINrBJiMBw6XDtcOoT6c9y04kS19r6
         RK+yNAupw2o8jKWW0KLhMuiZKXeYYrS49JjLjNR4GTwgfXCS7+aS3J9hSyBhFhKKvXeQ
         yW87y7SFbS2Pwd/J4mGsLW9yEmQ2xi4x2eiSqez0Vb97Fy6NG8pjpZ1LIUls9IK8uded
         GKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697042790; x=1697647590;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJqFA+s/mSPU1XInzGqIfTATa62Q4sl69T8M5JbscGQ=;
        b=Dq3dv/bnTJKla2nqyvN3ugNV3CReo6fZ/hJs0/1de6w0ZkD7oyjcIBg57C3Wtd4aJ0
         PhnupwYZZ8qpuYxgWDMLOe4IrNjJuNDF4LlNePpm7QyFO3FMzzMcU3DBcmSik21nqjCd
         f1tmrXdNVO1DzoFlk5jR18hi5P0In1W5ex/y/6YEXoVncV+Rmv8/PD2m7w69D7pLYtTv
         ZkQ1K3q6cY7exYXWfyhSr1VSEQ/dwU78SDgZ972GFN0QuDCPSeWKc73HCRpEbtFPfkOR
         OzA//ZDTGkopQz3SYuLjBo53gjUKtkVP9xVWic/PqnGF9qwy8oiYF9grgPtRP09L8bMA
         GV/w==
X-Gm-Message-State: AOJu0YzjmMHofYoeUBWCZlsgRZtueFQ3se78atqN1ekJ4X2kEkDU1/wu
        1q+eDeBrxKG4SrjGCDdg9YMQBXMH6MI=
X-Google-Smtp-Source: AGHT+IH/MXu2UpoNZHPsp8lCQi2sH4GohP40GX5UepJEMkI7palXu6s2b6OB0ZKAu5nKBc7GyzZN/w==
X-Received: by 2002:adf:e852:0:b0:315:9e1b:4ea6 with SMTP id d18-20020adfe852000000b003159e1b4ea6mr18329833wrn.58.1697042790306;
        Wed, 11 Oct 2023 09:46:30 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 9-20020a05600c020900b003feea62440bsm17195277wmi.43.2023.10.11.09.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 09:46:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix regression in showing lowerdir mount option
Date:   Wed, 11 Oct 2023 19:46:13 +0300
Message-Id: <20231011164613.1766616-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Before commit b36a5780cb44 ("ovl: modify layer parameter parsing"),
spaces and commas in lowerdir mount option value used to be escaped using
seq_show_option().

In current upstream, when lowerdir value has a space, it is not escaped
in /proc/mounts, e.g.:

  none /mnt overlay rw,relatime,lowerdir=l l,upperdir=u,workdir=w 0 0

which results in broken output of the mount utility:

  none on /mnt type overlay (rw,relatime,lowerdir=l)

Store the original lowerdir mount options before unescaping and show
them using the same escaping used for seq_show_option() in addition to
escaping the colon separator character.

Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 95b751507ac8..1429767a84bc 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -164,7 +164,8 @@ static ssize_t ovl_parse_param_split_lowerdirs(char *str)
 
 	for (s = d = str;; s++, d++) {
 		if (*s == '\\') {
-			s++;
+			/* keep esc chars in split lowerdir */
+			*d++ = *s++;
 		} else if (*s == ':') {
 			bool next_colon = (*(s + 1) == ':');
 
@@ -239,7 +240,7 @@ static void ovl_unescape(char *s)
 	}
 }
 
-static int ovl_mount_dir(const char *name, struct path *path)
+static int ovl_mount_dir(const char *name, struct path *path, bool upper)
 {
 	int err = -ENOMEM;
 	char *tmp = kstrdup(name, GFP_KERNEL);
@@ -248,7 +249,7 @@ static int ovl_mount_dir(const char *name, struct path *path)
 		ovl_unescape(tmp);
 		err = ovl_mount_dir_noesc(tmp, path);
 
-		if (!err && path->dentry->d_flags & DCACHE_OP_REAL) {
+		if (!err && upper && path->dentry->d_flags & DCACHE_OP_REAL) {
 			pr_err("filesystem on '%s' not supported as upperdir\n",
 			       tmp);
 			path_put_init(path);
@@ -269,7 +270,7 @@ static int ovl_parse_param_upperdir(const char *name, struct fs_context *fc,
 	struct path path;
 	char *dup;
 
-	err = ovl_mount_dir(name, &path);
+	err = ovl_mount_dir(name, &path, true);
 	if (err)
 		return err;
 
@@ -472,7 +473,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		l = &ctx->lower[nr];
 		memset(l, 0, sizeof(*l));
 
-		err = ovl_mount_dir_noesc(dup_iter, &l->path);
+		err = ovl_mount_dir(dup_iter, &l->path, false);
 		if (err)
 			goto out_put;
 
@@ -950,16 +951,23 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ofs = OVL_FS(sb);
 	size_t nr, nr_merged_lower = ofs->numlayer - ofs->numdatalayer;
-	char **lowerdatadirs = &ofs->config.lowerdirs[nr_merged_lower];
-
-	/* lowerdirs[] starts from offset 1 */
-	seq_printf(m, ",lowerdir=%s", ofs->config.lowerdirs[1]);
-	/* dump regular lower layers */
-	for (nr = 2; nr < nr_merged_lower; nr++)
-		seq_printf(m, ":%s", ofs->config.lowerdirs[nr]);
-	/* dump data lower layers */
-	for (nr = 0; nr < ofs->numdatalayer; nr++)
-		seq_printf(m, "::%s", lowerdatadirs[nr]);
+
+	/*
+	 * lowerdirs[] starts from offset 1, then
+	 * >= 0 regular lower layers prefixed with : and
+	 * >= 0 data-only lower layers prefixed with ::
+	 *
+	 * we need to escase comma and space like seq_show_option() does and
+	 * we also need to escape the colon separator from lowerdir paths.
+	 */
+	seq_puts(m, ",lowerdir=");
+	for (nr = 1; nr < ofs->numlayer; nr++) {
+		if (nr > 1)
+			seq_putc(m, ':');
+		if (nr >= nr_merged_lower)
+			seq_putc(m, ':');
+		seq_escape(m, ofs->config.lowerdirs[nr], ":,= \t\n\\");
+	}
 	if (ofs->config.upperdir) {
 		seq_show_option(m, "upperdir", ofs->config.upperdir);
 		seq_show_option(m, "workdir", ofs->config.workdir);
-- 
2.34.1

