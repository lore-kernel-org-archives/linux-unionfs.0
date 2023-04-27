Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6654DC77B7C
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243517AbjD0NFx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbjD0NFw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:52 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FB730C5
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:50 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f19a7f9424so60831585e9.2
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600749; x=1685192749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YR36zJIvvwpJCImhXwGZ4+CgPwxCvrjXgoKQj+qpR7E=;
        b=jVk2Pot/nWJY2qt8c5pQ5L9f9tGwIlwWejv4ps+M6+ylgZ74atGCWUX8CN+McNCRJ2
         zwRyszaE6aatETftpiKq3bIThmDf2DyJ75mttsE48JTZ6wSbdsqc/9V1xxE43+vM/Mol
         3QNnMzTxAqRktrDwbMOs2crcPZqV/M3cVFu/mseftrprTClsNwS7W+Yfh+mQS+zmyUMu
         3zR8VNHrexLG9DZBLQUf+avemffLZaxOQN3vI6bsUZgS0Ln5VjhQ2ZX6xXWRyZ2jRIzU
         0pSzdy8Z117fTwCwc5hao9t2vqmXjON/9umztwHT1OBQGWYcXthfcg9jqxlnhRD719Rc
         +WwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600749; x=1685192749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YR36zJIvvwpJCImhXwGZ4+CgPwxCvrjXgoKQj+qpR7E=;
        b=Ws6UJbgmL+RqGQRgvfKhT+18lmtXBeWP1r66zjbioYOqFwAQKXBRx6YOGNvn4Ijlbq
         OB6dRncIXYmC4/bsrSnn75bTiSE5sPVgbn8RJs91WIscMEgIuCR8JwiXFqsXfs3mckZy
         Dmy0qjnks2JXqb7ZyfxveV55QoLXSmoUD4SvL6YR+T6Q9lswxzOEbxbvSXZIV3ZnyGBh
         udO6fSYhqjsFPFEKSxpVcFsUIgTKenawdbVG1SEMVbJp5n5xV+UAw5QG8H5KyH741UiY
         skcYf1uGIAmmFF6Re3DjnDbTau0KaVoz7cgMkEWh5huqr9fXoaZdRB4xZw7tMRcUafaG
         y3ug==
X-Gm-Message-State: AC+VfDwYDk5zSbzHogiNCicWqufK86lN1IjxcNGbn+XZMEDn40XrH3Gl
        bBQ469yTpeTF69W4LW+um0CttKv4uWfZHA==
X-Google-Smtp-Source: ACHHUZ4GuTdG8Eaepa9W5jq/hu+S6E/BhmMncWWsKWAquAJIJ98C1Z72+s9NC35McFZwKUzd4hOixQ==
X-Received: by 2002:a5d:6b8f:0:b0:2cf:e517:c138 with SMTP id n15-20020a5d6b8f000000b002cfe517c138mr1177559wrx.66.1682600749224;
        Thu, 27 Apr 2023 06:05:49 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:48 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 04/13] ovl: factor out ovl_free_entry() and ovl_stack_*() helpers
Date:   Thu, 27 Apr 2023 16:05:30 +0300
Message-Id: <20230427130539.2798797-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In preparation for moving lowerstack into ovl_inode.

Note that in ovl_lookup() the temp stack dentry refs are now cloned
into the final ovl_lowerstack instead of being transferred, so cleanup
always needs to call ovl_stack_free(stack).

Reviewed-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 13 +++++--------
 fs/overlayfs/overlayfs.h |  5 +++++
 fs/overlayfs/ovl_entry.h |  2 --
 fs/overlayfs/super.c     | 14 ++------------
 fs/overlayfs/util.c      | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 31f889d27083..c237c8dbff09 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -907,8 +907,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (!d.stop && ovl_numlower(poe)) {
 		err = -ENOMEM;
-		stack = kcalloc(ofs->numlayer - 1, sizeof(struct ovl_path),
-				GFP_KERNEL);
+		stack = ovl_stack_alloc(ofs->numlayer - 1);
 		if (!stack)
 			goto out_put_upper;
 	}
@@ -1073,7 +1072,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (!oe)
 		goto out_put;
 
-	memcpy(ovl_lowerstack(oe), stack, sizeof(struct ovl_path) * ctr);
+	ovl_stack_cpy(ovl_lowerstack(oe), stack, ctr);
 	dentry->d_fsdata = oe;
 
 	if (upperopaque)
@@ -1131,18 +1130,16 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		kfree(origin_path);
 	}
 	dput(index);
-	kfree(stack);
+	ovl_stack_free(stack, ctr);
 	kfree(d.redirect);
 	return d_splice_alias(inode, dentry);
 
 out_free_oe:
 	dentry->d_fsdata = NULL;
-	kfree(oe);
+	ovl_free_entry(oe);
 out_put:
 	dput(index);
-	for (i = 0; i < ctr; i++)
-		dput(stack[i].dentry);
-	kfree(stack);
+	ovl_stack_free(stack, ctr);
 out_put_upper:
 	if (origin_path) {
 		dput(origin_path->dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e100c55bb924..6a50296fef8f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -373,7 +373,12 @@ int ovl_can_decode_fh(struct super_block *sb);
 struct dentry *ovl_indexdir(struct super_block *sb);
 bool ovl_index_all(struct super_block *sb);
 bool ovl_verify_lower(struct super_block *sb);
+struct ovl_path *ovl_stack_alloc(unsigned int n);
+void ovl_stack_cpy(struct ovl_path *dst, struct ovl_path *src, unsigned int n);
+void ovl_stack_put(struct ovl_path *stack, unsigned int n);
+void ovl_stack_free(struct ovl_path *stack, unsigned int n);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
+void ovl_free_entry(struct ovl_entry *oe);
 bool ovl_dentry_remote(struct dentry *dentry);
 void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry);
 void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 0e009fa39d54..608742f60037 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -127,8 +127,6 @@ static inline struct ovl_path *ovl_lowerstack(struct ovl_entry *oe)
 	return ovl_numlower(oe) ? oe->__lowerstack : NULL;
 }
 
-struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
-
 static inline struct ovl_entry *OVL_E(struct dentry *dentry)
 {
 	return (struct ovl_entry *) dentry->d_fsdata;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 89e9843bd2de..d8fe857bd7e1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -54,15 +54,6 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
 MODULE_PARM_DESC(xino_auto,
 		 "Auto enable xino feature");
 
-static void ovl_entry_stack_free(struct ovl_entry *oe)
-{
-	struct ovl_path *lowerstack = ovl_lowerstack(oe);
-	unsigned int i;
-
-	for (i = 0; i < ovl_numlower(oe); i++)
-		dput(lowerstack[i].dentry);
-}
-
 static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
 module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
 MODULE_PARM_DESC(metacopy,
@@ -73,7 +64,7 @@ static void ovl_dentry_release(struct dentry *dentry)
 	struct ovl_entry *oe = dentry->d_fsdata;
 
 	if (oe) {
-		ovl_entry_stack_free(oe);
+		ovl_stack_put(ovl_lowerstack(oe), ovl_numlower(oe));
 		kfree_rcu(oe, rcu);
 	}
 }
@@ -2078,8 +2069,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	return 0;
 
 out_free_oe:
-	ovl_entry_stack_free(oe);
-	kfree(oe);
+	ovl_free_entry(oe);
 out_err:
 	kfree(splitlower);
 	path_put(&upperpath);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a139eb581093..1ba6dbea808c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -83,6 +83,34 @@ bool ovl_verify_lower(struct super_block *sb)
 	return ofs->config.nfs_export && ofs->config.index;
 }
 
+struct ovl_path *ovl_stack_alloc(unsigned int n)
+{
+	return kcalloc(n, sizeof(struct ovl_path), GFP_KERNEL);
+}
+
+void ovl_stack_cpy(struct ovl_path *dst, struct ovl_path *src, unsigned int n)
+{
+	unsigned int i;
+
+	memcpy(dst, src, sizeof(struct ovl_path) * n);
+	for (i = 0; i < n; i++)
+		dget(src[i].dentry);
+}
+
+void ovl_stack_put(struct ovl_path *stack, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; stack && i < n; i++)
+		dput(stack[i].dentry);
+}
+
+void ovl_stack_free(struct ovl_path *stack, unsigned int n)
+{
+	ovl_stack_put(stack, n);
+	kfree(stack);
+}
+
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
 	size_t size = offsetof(struct ovl_entry, __lowerstack[numlower]);
@@ -94,6 +122,12 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 	return oe;
 }
 
+void ovl_free_entry(struct ovl_entry *oe)
+{
+	ovl_stack_put(ovl_lowerstack(oe), ovl_numlower(oe));
+	kfree(oe);
+}
+
 #define OVL_D_REVALIDATE (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)
 
 bool ovl_dentry_remote(struct dentry *dentry)
-- 
2.34.1

