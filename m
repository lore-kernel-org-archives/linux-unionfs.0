Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AC8C77B6C
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjDHQnR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjDHQnQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:16 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E7630D7
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:15 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e2so1119589wrc.10
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972193; x=1683564193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1xKSE7R5Y48ctl1s4FYlYwmW1BZc+WkAeGsQQ9jRf8=;
        b=kzBbEXKL6M+gpNYTNcAEljRTE41bwZGjfk83EoR9T1fGsuCGABYWSgBxfs+6M4H9QV
         GqryDG6zepTwC5hgSd8Z1hpV5VfgdgeKheMO9toAE4vrq7TSzHXC79wKy7m5PgBIWsKJ
         BJBqq3dpM1sZZf6SeIFs2MpmPopjD5VcGpS6xK1CBNxoW3XDxz/MuA3luo0AlYdxV8cu
         f0V7nUtHTh4/B60GFmVIDQe2vMx3F9kgwicYaasP0Py4CBWOu2yfd3iGEJHXTtwYVk/f
         Az0ss2JrEG7QdhagcmphlHfOphqL+uXsk2QfRWvx/1Ey1CRf3HHiOeWsIZKHil+I7iMV
         ky7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972193; x=1683564193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1xKSE7R5Y48ctl1s4FYlYwmW1BZc+WkAeGsQQ9jRf8=;
        b=RekfEf51wfIbacR2iteQfAG2eSMpbEVMlGT9zMJ8D2mhMNZkDJxAZ0XsG509n64AL/
         xwpFefIuOKY3DlCSXZzTXD5xHsZf9ltdAq5D4xsB9/7/4AI3EetqeoMcSfEUukcFZBRC
         jW9QjJmenySWVitx1hgNe2KJFNM+DNkAdL/pPvRZG/Rnun8zBUYbiT3zoY9J2QcLhuz/
         VZ005vahjhnSfmb/YZwg9BYOfJon2VJ9rFdJRnhjr/2G/2SXM8IH3WlrVu/FFCP2FWB+
         uqw+FWPFgUBgy7JnySRqImhZJkZ9wPnYbObkCVoEVYxiV130zaCiA7CPQssDNkV7+GEe
         XcNw==
X-Gm-Message-State: AAQBX9dfTeCRY1Ox7UawDSvi/WEhNJzZsFa7oJ+m6f1RnSU9ZJyTXrlt
        f7JsTLinLgMsnC09JvSMvZI=
X-Google-Smtp-Source: AKy350aqgNXT7GKIyOErMbpCRnCdmq4ebitwVN43Ta0+S2IV26lSPZ9RAgZO4FH5f5/AxIwyxZA39Q==
X-Received: by 2002:adf:e747:0:b0:2d4:5117:f4b with SMTP id c7-20020adfe747000000b002d451170f4bmr3540992wrn.26.1680972193212;
        Sat, 08 Apr 2023 09:43:13 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:12 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 4/7] ovl: factor out ovl_free_entry() and ovl_stack_*() helpers
Date:   Sat,  8 Apr 2023 19:42:59 +0300
Message-Id: <20230408164302.1392694-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408164302.1392694-1-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In preparation for moving lowerstack into ovl_inode.

Note that in ovl_lookup() the temp stack dentry refs are now cloned
into the final ovl_lowerstack instead of being transfered, so cleanup
always needs to call ovl_stack_free(stack).

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
index f456a99d6017..754f8ae4ce62 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -127,8 +127,6 @@ static inline struct ovl_path *ovl_lowerstack(struct ovl_entry *oe)
 	return oe ? oe->__lowerstack : NULL;
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

