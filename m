Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0116AC77B7C
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbjD0NGC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243735AbjD0NGB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:06:01 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40FB30D6
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:59 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-2f939bea9ebso7733175f8f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600758; x=1685192758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/luQ3QHYe1XupncGNeGGbz4DTJveQKvDQBgFx1ly8Jw=;
        b=ahWdU2LGOZEadJMmkOjED0khcYOEN+p+K1ZO7A64KQXzKGQPC5lsUEZTVzxYnvMRLv
         K/mjbvojnKKaDtLcsoLT55ILV4anJC2xInDUa11V2+jH7HmAhCpRGIRoaAQCOZUWB0SR
         AdyYdYZlye+F+4VVEh2y5LXEhM4+s2f2eYSt7AFUZVQ6sXmt+ud31cbxOap639Ii6sum
         KrecQBnJnBlKo32MAC0xHSI7jlfUucRzqY05MH21Z6WuOnuZojRK4+0APmMFXgWHHi/4
         uRlomAm2UYteGZivIFtbNf2k/j59eSuPcWZypiYPCjNE3i6lO/8IIiqEpetMjuxwfIXF
         44tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600758; x=1685192758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/luQ3QHYe1XupncGNeGGbz4DTJveQKvDQBgFx1ly8Jw=;
        b=FVtkybQj6riYMvR/P58CJPHi4Nv6AZhiGPq0BUdw54VHgpYtFe77bo4I7GyLdldpMc
         fZmoC6MLkgcr8ZYrDepVh6yU0fcTEObUrkrdTFWsUmf3f+7R3BVDmYhB5seZ1h864jAr
         tBGCUGJNzzIWlr4PLDJfsAQin3Y4caevtDGXFgnP5n96Fl1moY55QuNvzyIiiE5EW7rR
         YND6Dd5wqAXRVw2pwEmb8jtHhefbJH43LozM9Aemh85o8xdsEozg45aLZQZ8LgtQHHQS
         sCxQWj0jguUr5lSX2JGnzyK4sJvHE5rgMWpv4HQ1A+83MnbaCY+m4iSqM6X8X0Gpq+NP
         BWOQ==
X-Gm-Message-State: AC+VfDxQCKwe+3y3LHnao+op96q4op7AiGpNx+ISzqr/yBlbK4yinYXR
        p6k5dyUCMU/ODKIWeYTtvSg=
X-Google-Smtp-Source: ACHHUZ6GIEIvvT8L5qEYmAOn1Wm7gvnOYINZBsdC+cWHyy2sn2aFPt4n2PMhdCaZkBWued9bXUtb8A==
X-Received: by 2002:a5d:684f:0:b0:2f8:1ab3:6e18 with SMTP id o15-20020a5d684f000000b002f81ab36e18mr1356038wrw.51.1682600758469;
        Thu, 27 Apr 2023 06:05:58 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:58 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 11/13] ovl: prepare to store lowerdata redirect for lazy lowerdata lookup
Date:   Thu, 27 Apr 2023 16:05:37 +0300
Message-Id: <20230427130539.2798797-12-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Prepare to allow ovl_lookup() to leave the last entry in a non-dir
lowerstack empty to signify lazy lowerdata lookup.

In this case, ovl_lookup() stores the redirect path from metacopy to
lowerdata in ovl_inode, which is going to be used later to perform the
lazy lowerdata lookup.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  2 ++
 fs/overlayfs/namei.c     |  5 +++++
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  3 ++-
 fs/overlayfs/super.c     |  3 +++
 fs/overlayfs/util.c      | 13 ++++++++++---
 6 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 62027e60a936..a7529b6a86e6 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1006,6 +1006,7 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->__upperdentry = oip->upperdentry;
 	oi->oe = oip->oe;
 	oi->redirect = oip->redirect;
+	oi->lowerdata_redirect = oip->lowerdata_redirect;
 
 	realinode = ovl_inode_real(inode);
 	ovl_copyattr(inode);
@@ -1366,6 +1367,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			dput(upperdentry);
 			ovl_free_entry(oip->oe);
 			kfree(oip->redirect);
+			kfree(oip->lowerdata_redirect);
 			goto out;
 		}
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1ed64ff129d9..6df9a349cd04 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1181,6 +1181,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			.redirect = upperredirect,
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
index 93ebc0edf4ef..cb0135ff6249 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -405,6 +405,7 @@ struct inode *ovl_inode_lower(struct inode *inode);
 struct inode *ovl_inode_lowerdata(struct inode *inode);
 struct inode *ovl_inode_real(struct inode *inode);
 struct inode *ovl_inode_realdata(struct inode *inode);
+const char *ovl_lowerdata_redirect(struct inode *inode);
 struct ovl_dir_cache *ovl_dir_cache(struct inode *inode);
 void ovl_set_dir_cache(struct inode *inode, struct ovl_dir_cache *cache);
 void ovl_dentry_set_flag(unsigned long flag, struct dentry *dentry);
@@ -656,6 +657,7 @@ struct ovl_inode_params {
 	struct ovl_entry *oe;
 	bool index;
 	char *redirect;
+	char *lowerdata_redirect;
 };
 void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 		    unsigned long ino, int fsid);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 93ff299da0dd..513c2c499e41 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -141,6 +141,7 @@ static inline struct ovl_path *ovl_lowerdata(struct ovl_entry *oe)
 	return lowerstack ? &lowerstack[oe->__numlower - 1] : NULL;
 }
 
+/* May return NULL if lazy lookup of lowerdata is needed */
 static inline struct dentry *ovl_lowerdata_dentry(struct ovl_entry *oe)
 {
 	struct ovl_path *lowerdata = ovl_lowerdata(oe);
@@ -157,7 +158,7 @@ static inline unsigned long *OVL_E_FLAGS(struct dentry *dentry)
 struct ovl_inode {
 	union {
 		struct ovl_dir_cache *cache;	/* directory */
-		/* place holder for non-dir */	/* regular file */
+		const char *lowerdata_redirect;	/* regular file */
 	};
 	const char *redirect;
 	u64 version;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 988edb9e9d23..b960b9d84b66 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -171,6 +171,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->version = 0;
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
+	oi->lowerdata_redirect = NULL;
 	oi->oe = NULL;
 	mutex_init(&oi->lock);
 
@@ -194,6 +195,8 @@ static void ovl_destroy_inode(struct inode *inode)
 	ovl_free_entry(oi->oe);
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
+	else
+		kfree(oi->lowerdata_redirect);
 }
 
 static void ovl_free_fs(struct ovl_fs *ofs)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7495b4d378b0..ad93a3132495 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -226,10 +226,11 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 	struct ovl_path *lowerdata = ovl_lowerdata(oe);
+	struct dentry *lowerdata_dentry = ovl_lowerdata_dentry(oe);
 
-	if (ovl_numlower(oe)) {
+	if (lowerdata_dentry) {
 		path->mnt = lowerdata->layer->mnt;
-		path->dentry = lowerdata->dentry;
+		path->dentry = lowerdata_dentry;
 	} else {
 		*path = (struct path) { };
 	}
@@ -356,9 +357,15 @@ struct inode *ovl_inode_realdata(struct inode *inode)
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

