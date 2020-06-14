Return-Path: <SRS0=/kxx=73=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50319C433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 13:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E805206D7
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 13:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ezvlyyae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgFNNJv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 09:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgFNNJu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 Jun 2020 09:09:50 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C56C05BD43
        for <linux-unionfs@vger.kernel.org>; Sun, 14 Jun 2020 06:09:50 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t18so14380249wru.6
        for <linux-unionfs@vger.kernel.org>; Sun, 14 Jun 2020 06:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sEPFin1V4gJKG4fH9IlcZTt9ccKEZh1H3KYCW8E4crc=;
        b=EzvlyyaetV2EIyIbMf4XTkYPmZzqtk9FdKzvS1Qx13mZYdDO3PKKJWovQItlavQ1EC
         jW3q13DieebUJCGIkV9BECtzAbfBTWWxXAiL9h3Rsu21Ghpj4+6YjVuSccGxdUPj7RZd
         nbk7qgbmSE7LSr+/z+UwKeqm0Nrc8l3O52DU3ERhHUlHXv8GHdA18H6wkViTNWMqceEq
         /VSEWhaXJuSXCQJ5QnLBdkt36XD6FejuCOJktkF/77nCpCRi4wspYxP8iaBX3UrYl8ug
         CweVYk0235aqOf0mVvnju9V0waTbQRaOK3es6xCKOXbH5oJFEkwDOfhgdsci1zrJ9Sot
         1Mxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sEPFin1V4gJKG4fH9IlcZTt9ccKEZh1H3KYCW8E4crc=;
        b=PMSsBOeT50hnKys0wPOMnMlucnup6PpfkSBJN7PxaN3dZ5Qd7Yg7glqth5/HVkN38w
         I/ycx2QBcO/8WsglJa4RcfoBvn+H/dBLby9NTebmcBXfd15bNMUb94UFrDak6pwUyipV
         NikLjz0Zs5rKHnc0urBUQBYv4oifmI96Ai92uqWkBLkMhCgWJsYVa8zB0U6CQOHQKKim
         5fV36dRkczltmqEbO7Wu1+Q2p1i+/3z6J1lDcbf51HzeSnvlbiks9tdaKLKpf8JbAacG
         mElFG7Pw4ZNJ/uAgJ8Qr2blXAX8pkXGA++xS/vbcHZya1IQ6eGjKkJ13bcI7ERUeL5Qt
         rCDQ==
X-Gm-Message-State: AOAM532zJB23Clc+an8GjXUs6vuC14/p8QFAHKw+bmwrviugghHsurQK
        edU9YHFXA8TSGuG4ef1o1O5Pn6IX
X-Google-Smtp-Source: ABdhPJxnGjldyQq/rHwS/LpfMLL+tYQusHZdfUwt0WeB/z3bpgfsn/TBnb46vHwoJM/QjJThuGxnpA==
X-Received: by 2002:adf:9c12:: with SMTP id f18mr25992567wrc.105.1592140188926;
        Sun, 14 Jun 2020 06:09:48 -0700 (PDT)
Received: from localhost.localdomain ([5.102.204.95])
        by smtp.gmail.com with ESMTPSA id g82sm18458283wmf.1.2020.06.14.06.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 06:09:48 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 2/2] ovl: warn about unsupported file operations on upper fs
Date:   Sun, 14 Jun 2020 16:09:39 +0300
Message-Id: <20200614130939.7702-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200614130939.7702-1-amir73il@gmail.com>
References: <20200614130939.7702-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot has reported a crash in a test case where overlayfs uses
hugetlbfs as upper fs.

Since hugetlbfs has no write() nor write_iter() file ops, there seems
to be little value in supporting this configuration, however, we do not
want to regress strange use cases that me be using such configuration.

As a minimum, check for this case and warn about it on mount time as
well as adding this check for the strict requirements set of remote
upper fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 60 ++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 91476bc422f9..5bee70eb8f64 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -6,6 +6,7 @@
 
 #include <uapi/linux/magic.h>
 #include <linux/fs.h>
+#include <linux/file.h>
 #include <linux/namei.h>
 #include <linux/xattr.h>
 #include <linux/mount.h>
@@ -1131,42 +1132,61 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 }
 
 /*
- * Returns 1 if RENAME_WHITEOUT is supported, 0 if not supported and
+ * Returns 1 if required ops are supported, 0 if not supported and
  * negative values if error is encountered.
  */
-static int ovl_check_rename_whiteout(struct dentry *workdir)
+static int ovl_check_supported_ops(struct ovl_fs *ofs)
 {
-	struct inode *dir = d_inode(workdir);
-	struct dentry *temp;
+	struct inode *dir = d_inode(ofs->workdir);
+	struct dentry *temp = NULL;
 	struct dentry *dest;
 	struct dentry *whiteout;
 	struct name_snapshot name;
+	struct path path;
+	struct file *file;
+	unsigned int unsupported;
 	int err;
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 
-	temp = ovl_create_temp(workdir, OVL_CATTR(S_IFREG | 0));
-	err = PTR_ERR(temp);
-	if (IS_ERR(temp))
+	path.mnt = ovl_upper_mnt(ofs);
+	path.dentry = ovl_create_temp(ofs->workdir, OVL_CATTR(S_IFREG | 0));
+	err = PTR_ERR(path.dentry);
+	if (IS_ERR(path.dentry))
 		goto out_unlock;
 
-	dest = ovl_lookup_temp(workdir);
-	err = PTR_ERR(dest);
-	if (IS_ERR(dest)) {
-		dput(temp);
+	temp = path.dentry;
+	file = dentry_open(&path, O_RDWR, current_cred());
+	err = PTR_ERR(file);
+	if (IS_ERR(file))
+		goto out_unlock;
+
+	unsupported = OVL_UPPER_FMODE_MASK & ~file->f_mode;
+	fput(file);
+	if (unsupported) {
+		err = 0;
+		pr_warn("upper fs does not support required file operations (%x).\n",
+			unsupported);
 		goto out_unlock;
 	}
 
+	dest = ovl_lookup_temp(ofs->workdir);
+	err = PTR_ERR(dest);
+	if (IS_ERR(dest))
+		goto out_unlock;
+
 	/* Name is inline and stable - using snapshot as a copy helper */
 	take_dentry_name_snapshot(&name, temp);
 	err = ovl_do_rename(dir, temp, dir, dest, RENAME_WHITEOUT);
 	if (err) {
-		if (err == -EINVAL)
+		if (err == -EINVAL) {
 			err = 0;
+			pr_warn("upper fs does not support RENAME_WHITEOUT.\n");
+		}
 		goto cleanup_temp;
 	}
 
-	whiteout = lookup_one_len(name.name.name, workdir, name.name.len);
+	whiteout = lookup_one_len(name.name.name, ofs->workdir, name.name.len);
 	err = PTR_ERR(whiteout);
 	if (IS_ERR(whiteout))
 		goto cleanup_temp;
@@ -1181,10 +1201,10 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 cleanup_temp:
 	ovl_cleanup(dir, temp);
 	release_dentry_name_snapshot(&name);
-	dput(temp);
 	dput(dest);
 
 out_unlock:
+	dput(temp);
 	inode_unlock(dir);
 
 	return err;
@@ -1195,7 +1215,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *temp;
-	bool rename_whiteout;
+	bool supported_ops;
 	bool d_type;
 	int fh_type;
 	int err;
@@ -1235,14 +1255,12 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		pr_warn("upper fs does not support tmpfile.\n");
 
 
-	/* Check if upper/work fs supports RENAME_WHITEOUT */
-	err = ovl_check_rename_whiteout(ofs->workdir);
+	/* Check if upper/work fs supports required ops */
+	err = ovl_check_supported_ops(ofs);
 	if (err < 0)
 		goto out;
 
-	rename_whiteout = err;
-	if (!rename_whiteout)
-		pr_warn("upper fs does not support RENAME_WHITEOUT.\n");
+	supported_ops = err;
 
 	/*
 	 * Check if upper/work fs supports trusted.overlay.* xattr
@@ -1264,7 +1282,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 * we can enforce strict requirements for remote upper fs.
 	 */
 	if (ovl_dentry_remote(ofs->workdir) &&
-	    (!d_type || !rename_whiteout || ofs->noxattr)) {
+	    (!d_type || !supported_ops || ofs->noxattr)) {
 		pr_err("upper fs missing required features.\n");
 		err = -EINVAL;
 		goto out;
-- 
2.17.1

