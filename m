Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAB5C7619A
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjDHQnU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDHQnT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:19 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227E6AF3F
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:18 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j11so4835571wrd.2
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972196; x=1683564196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpCVJ8pOb6zReg9k3WqEzN2eNNsaUGf+a3pH9DZ9NEY=;
        b=OGlhSVTeuVwN/Bs+o8ddmPGcT3gxE/azZZMcdPStGuYs0AwItjM7ClRAZ4yD7wQ+qW
         /tinT8RXXv0SV35h0mvYrhiX51WVS/fCm2AZKkv4gT/dNoTvbbdmus/cNIOEZxEpojkX
         P3cddpPAAGgBA7D5yjCyIp4Bw0bmnIxC/ptk8dNI6h9gjtyZ3nErmMIfi23oIQ4L6P9q
         8C0Ns5cIwhrrnyl4EZs38GTpmRWsp0DxNkoUt64uVtNJ8zhybhjOGrGhA3iW7IpPUFJa
         ib4cGqMgM843cnQyxfB4EjLLHodOcRsUQd0MICg3v3gvimwuw+389ilaReRijsHcWjxv
         fTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972196; x=1683564196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpCVJ8pOb6zReg9k3WqEzN2eNNsaUGf+a3pH9DZ9NEY=;
        b=M7fyaprPq8OEU2HFnrPt/bzUCAZe2i3lFVarlMKDnl1KloJJgzahhdmT44aiUr0jX/
         iNkTExzKcQvgsGgEj5+v+/75cjtxb0w1SshHvfTilMkQLbPejosIdfuMEy2i886VDpL5
         IiYRsNS3cUxNcfpPzU5xzpvjEZUbR9qf6s8wS/ytylCAEmteDsUKT0gkoAMFaojmkC++
         0glYi1Nhi/stHXHro3xSbVF0re0wn+pEt/C7MpXz6sBjsdiJGW0EPb1TAUG8KwGQpvyG
         7uWyEW6IgSUxHbGQYcmYpwRctFGDAzrsaeMRexp8538ujxd7JKMsvi6et+vPhjPvdwsK
         ykPA==
X-Gm-Message-State: AAQBX9fd3C9SIVjFGgFKVBfv1nU2YfJaJApbcIny/D9e7eu/WTtAM8yg
        QHf1Hr8eyQ09XoC+aH4XQcGXpdDNL88=
X-Google-Smtp-Source: AKy350Y3+cYA+Nrgp3HQp40vs8NHOMvg1rjLtUGjPmnyWM7IMlmisBmBJ9iXU1nkn44Q5IU5QsvF7A==
X-Received: by 2002:a5d:4381:0:b0:2ef:b7ed:bc1e with SMTP id i1-20020a5d4381000000b002efb7edbc1emr2040063wrq.29.1680972196672;
        Sat, 08 Apr 2023 09:43:16 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 7/7] ovl: replace lowerdata inode reference with lowerdata redirect
Date:   Sat,  8 Apr 2023 19:43:02 +0300
Message-Id: <20230408164302.1392694-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408164302.1392694-1-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Now that we have the entire lower stack in ovl_inode, we do not
need to hold another reference to the lowerdata inode.

Instead, use the vacant ovl_inode space as a place holder for lowerdata
redirect path from the metacopy to lowerdata, which is going to be used
later on for lazy lowerdata lookup.

Use accessors to get the lowerdata path and dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  4 ++--
 fs/overlayfs/namei.c     |  7 +++++--
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/ovl_entry.h | 16 +++++++++++++++-
 fs/overlayfs/super.c     |  4 ++--
 fs/overlayfs/util.c      | 26 ++++++++++++++++----------
 6 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9f29fc3e9fa5..35d51a6dced7 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1006,8 +1006,7 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->__upperdentry = oip->upperdentry;
 	oi->oe = *oip->oe;
 	oi->redirect = oip->redirect;
-	if (oip->lowerdata)
-		oi->lowerdata = igrab(d_inode(oip->lowerdata));
+	oi->lowerdata_redirect = oip->lowerdata_redirect;
 
 	realinode = ovl_inode_real(inode);
 	ovl_copyattr(inode);
@@ -1368,6 +1367,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			dput(upperdentry);
 			ovl_destroy_entry(oip->oe);
 			kfree(oip->redirect);
+			kfree(oip->lowerdata_redirect);
 			goto out;
 		}
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index cdcb2ac5d95c..b629261324f1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1105,10 +1105,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			.oe = &oe,
 			.index = index,
 			.redirect = upperredirect,
-			.lowerdata = (ctr > 1 && !d.is_dir) ?
-				      stack[ctr - 1].dentry : NULL,
 		};
 
+		/* Store lowerdata redirect for lazy lookup */
+		if (ctr > 1 && !d.is_dir && !stack[ctr - 1].dentry) {
+			oip.lowerdata_redirect = d.redirect;
+			d.redirect = NULL;
+		}
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 32532342e56a..011b7b466f70 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -409,6 +409,7 @@ struct inode *ovl_inode_lower(struct inode *inode);
 struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
 struct inode *ovl_inode_realdata(struct inode *inode);
+const char *ovl_lowerdata_redirect(struct inode *inode);
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
 void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry);
@@ -660,7 +661,7 @@ struct ovl_inode_params {
 	struct ovl_entry *oe;
 	bool index;
 	char *redirect;
-	struct dentry *lowerdata;
+	char *lowerdata_redirect;
 };
 void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 		    unsigned long ino, int fsid);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 5d95e937f555..221f0cbe748e 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -125,6 +125,20 @@ static inline struct ovl_path *ovl_lowerstack(struct ovl_entry *oe)
 	return oe && oe->__numlower > 1 ? oe->__lowerstack : &oe->__lowerpath;
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
+		const char *lowerdata_redirect;	/* regular file */
 	};
 	const char *redirect;
 	u64 version;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e01a76de787c..6e4231799b86 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -172,7 +172,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
 	ovl_init_entry(&oi->oe, NULL, 0);
-	oi->lowerdata = NULL;
+	oi->lowerdata_redirect = NULL;
 	mutex_init(&oi->lock);
 
 	return &oi->vfs_inode;
@@ -196,7 +196,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
 	else
-		iput(oi->lowerdata);
+		kfree(oi->lowerdata_redirect);
 }
 
 static void ovl_free_fs(struct ovl_fs *ofs)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 540819ac9b9c..fe2e5a8b216b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -245,11 +245,12 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
-	struct ovl_path *lowerstack = ovl_lowerstack(oe);
+	struct ovl_path *lowerdata = ovl_lowerdata(oe);
+	struct dentry *lowerdata_dentry = ovl_lowerdata_dentry(oe);
 
-	if (ovl_numlower(oe)) {
-		path->mnt = lowerstack[ovl_numlower(oe) - 1].layer->mnt;
-		path->dentry = lowerstack[ovl_numlower(oe) - 1].dentry;
+	if (lowerdata_dentry) {
+		path->dentry = lowerdata_dentry;
+		path->mnt = lowerdata->layer->mnt;
 	} else {
 		*path = (struct path) { };
 	}
@@ -308,10 +309,7 @@ const struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
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
@@ -359,10 +357,12 @@ struct inode *ovl_inode_real(struct inode *inode)
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
@@ -377,9 +377,15 @@ struct inode *ovl_inode_realdata(struct inode *inode)
 	return ovl_inode_lowerdata(inode);
 }
 
+const char *ovl_lowerdata_redirect(struct inode *inode)
+{
+	return inode && S_ISREG(inode->i_mode) ?
+		OVL_I(inode)->lowerdata_redirect : NULL;
+}
+
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode)
 {
-	return OVL_I(inode)->cache;
+	return inode && S_ISDIR(inode->i_mode) ? OVL_I(inode)->cache : NULL;
 }
 
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache)
-- 
2.34.1

