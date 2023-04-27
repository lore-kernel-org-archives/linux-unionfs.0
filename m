Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23C5C77B7C
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243462AbjD0NF5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243632AbjD0NF4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:56 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D578930C5
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:54 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f1728c2a57so87877425e9.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600753; x=1685192753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=INyY0JfzbXLsgNjgWAaOLUUB2t51RMbiJ7ru4CmKfpY=;
        b=l49jjuWh0SzdneakLKJ8JpeDXWAxtCLVHs7z/bBZtSX5tSpTcirfiuAneC8Xyq3uOw
         du11JGxmkqaUgTkjUhpKVuHum34laSHeSuSEeOwmXUBva917mwyaFxUiwENYxcrW+H2v
         NePJAlrMhEJgqZQ2nKAZwS9M2/iKf2HUkQds/E6EDMlhkHlG3IObWs+Y9cf2PpBkW2LH
         AN0HVNJYXtMhiRSRaGJA2I1UH7F2M7D4EVpPGsld2Q1v0vKeogGKt3BlqlyCnWBfozuo
         44XVNEJbJ1A4ISK5aNs1XW7XrSGANcod6XrNb9wUycnaS2kUSfiVfrM7ii5zRG+FW9gC
         O/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600753; x=1685192753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=INyY0JfzbXLsgNjgWAaOLUUB2t51RMbiJ7ru4CmKfpY=;
        b=DVq4ykUIpvN01Hnu1b/07N4C6RgpCARxbagrTar0Vaz7bTvmWfZg4bs2cXojmhYIFm
         1Ei6qZ9MQHnx4fxylAb12zqW8PJb16oa9OhQ87s1LUyHCBjwu6M5eSESkyl8Kw/NJE5D
         mH5CUgqmLVV6TrLVv6jpSLMJNeJXqfLVLs7iJya6UJr3rGIMo8nwZpwWfoOkZvMsM81r
         Ic7xZUFIpYJEwLOQ8Pt5lS2SLedF3aPlfHN3XPkz9YvjbTkstP7athKLUFh5NPS70gcg
         kwj1iWPQC8fKr/BbjADwoGlKPw+F3BnQRjXbYCsw+oltQes4IuARvhUYIF5NGPkloek0
         iLXw==
X-Gm-Message-State: AC+VfDw5gLWyOzDC3CcTBGt5n570Xklhf/zFcnuQkb1s6L1FGeO8DVTK
        E+RN3walGZKULnNaDJMmUFMZpcMCycir0A==
X-Google-Smtp-Source: ACHHUZ7MnAEnmOtgoq2BhMHcFK893l7b1CT8AChChZYV8eBHviZVKnQpp8QizNTgt04XGP+erL8o3A==
X-Received: by 2002:adf:ea11:0:b0:2f1:e162:d48 with SMTP id q17-20020adfea11000000b002f1e1620d48mr1271210wrm.47.1682600753368;
        Thu, 27 Apr 2023 06:05:53 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 07/13] ovl: deduplicate lowerdata and lowerstack[]
Date:   Thu, 27 Apr 2023 16:05:33 +0300
Message-Id: <20230427130539.2798797-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The ovl_inode contains a copy of lowerdata in lowerstack[], so the
lowerdata inode member can be removed.

Use accessors ovl_lowerdata*() to get the lowerdata whereever the member
was accessed directly.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  2 --
 fs/overlayfs/namei.c     |  2 --
 fs/overlayfs/overlayfs.h |  1 -
 fs/overlayfs/ovl_entry.h | 16 +++++++++++++++-
 fs/overlayfs/super.c     |  3 ---
 fs/overlayfs/util.c      | 15 +++++++--------
 6 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f2ea51fac56b..62027e60a936 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1006,8 +1006,6 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->__upperdentry = oip->upperdentry;
 	oi->oe = oip->oe;
 	oi->redirect = oip->redirect;
-	if (oip->lowerdata)
-		oi->lowerdata = igrab(d_inode(oip->lowerdata));
 
 	realinode = ovl_inode_real(inode);
 	ovl_copyattr(inode);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 4f332d3fad37..e2b3c8f6753a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1108,8 +1108,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			.oe = oe,
 			.index = index,
 			.redirect = upperredirect,
-			.lowerdata = (ctr > 1 && !d.is_dir) ?
-				      stack[ctr - 1].dentry : NULL,
 		};
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2c61e4383cf6..93ebc0edf4ef 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -656,7 +656,6 @@ struct ovl_inode_params {
 	struct ovl_entry *oe;
 	bool index;
 	char *redirect;
-	struct dentry *lowerdata;
 };
 void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 		    unsigned long ino, int fsid);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 0bb8ab3aa8a7..548c93e030fc 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -125,6 +125,20 @@ static inline struct ovl_path *ovl_lowerpath(struct ovl_entry *oe)
 	return ovl_lowerstack(oe);
 }
 
+static inline struct ovl_path *ovl_lowerdata(struct ovl_entry *oe)
+{
+	struct ovl_path *lowerstack = ovl_lowerstack(oe);
+
+	return lowerstack ? &lowerstack[oe->__numlower - 1] : NULL;
+}
+
+static inline struct dentry *ovl_lowerdata_dentry(struct ovl_entry *oe)
+{
+	struct ovl_path *lowerdata = ovl_lowerdata(oe);
+
+	return lowerdata ? lowerdata->dentry : NULL;
+}
+
 /* private information held for every overlayfs dentry */
 static inline unsigned long *OVL_E_FLAGS(struct dentry *dentry)
 {
@@ -134,7 +148,7 @@ static inline unsigned long *OVL_E_FLAGS(struct dentry *dentry)
 struct ovl_inode {
 	union {
 		struct ovl_dir_cache *cache;	/* directory */
-		struct inode *lowerdata;	/* regular file */
+		/* place holder for non-dir */	/* regular file */
 	};
 	const char *redirect;
 	u64 version;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e3976ce279a8..1bfbdce2209a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -172,7 +172,6 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
 	oi->oe = NULL;
-	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
 	return &oi->vfs_inode;
@@ -195,8 +194,6 @@ static void ovl_destroy_inode(struct inode *inode)
 	ovl_free_entry(oi->oe);
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
-	else
-		iput(oi->lowerdata);
 }
 
 static void ovl_free_fs(struct ovl_fs *ofs)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 21b2f479a46f..7495b4d378b0 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -225,11 +225,11 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
-	struct ovl_path *lowerstack = ovl_lowerstack(oe);
+	struct ovl_path *lowerdata = ovl_lowerdata(oe);
 
 	if (ovl_numlower(oe)) {
-		path->mnt = lowerstack[ovl_numlower(oe) - 1].layer->mnt;
-		path->dentry = lowerstack[ovl_numlower(oe) - 1].dentry;
+		path->mnt = lowerdata->layer->mnt;
+		path->dentry = lowerdata->dentry;
 	} else {
 		*path = (struct path) { };
 	}
@@ -288,10 +288,7 @@ const struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
  */
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
 {
-	struct ovl_entry *oe = OVL_E(dentry);
-
-	return ovl_numlower(oe) ?
-		ovl_lowerstack(oe)[ovl_numlower(oe) - 1].dentry : NULL;
+	return ovl_lowerdata_dentry(OVL_E(dentry));
 }
 
 struct dentry *ovl_dentry_real(struct dentry *dentry)
@@ -339,10 +336,12 @@ struct inode *ovl_inode_real(struct inode *inode)
 /* Return inode which contains lower data. Do not return metacopy */
 struct inode *ovl_inode_lowerdata(struct inode *inode)
 {
+	struct dentry *lowerdata = ovl_lowerdata_dentry(OVL_I_E(inode));
+
 	if (WARN_ON(!S_ISREG(inode->i_mode)))
 		return NULL;
 
-	return OVL_I(inode)->lowerdata ?: ovl_inode_lower(inode);
+	return lowerdata ? d_inode(lowerdata) : NULL;
 }
 
 /* Return real inode which contains data. Does not return metacopy inode */
-- 
2.34.1

