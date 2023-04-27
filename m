Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4D0C77B7C
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:05:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243511AbjD0NFs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbjD0NFr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:47 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA4A30C5
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f315735514so22591765e9.1
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600745; x=1685192745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUx+hSs1GqSlRZxyuwSB8fOVcDQ/RGWYj+MVZKDGEtQ=;
        b=kelZZQTzM2hdG0rNCihjkk4aK6SbqZAOLv0R5wUjSC/GvkIGazLAXXzyj6yFo6t58/
         z7DjparMNSA8Tz4kuhdm4HSfGe3YyP6gN5KUS0wl8qyVrzOIL7bZV+prKVj0M3fNir43
         15vRPJLHD10DfOIlXcnSFzI/ucILxq+FU5BuhcmFfY+fK+WNDsRMivoC90KVcJCefrfs
         zHKHGyaTuUu5IZHTZet09TZlcosa3Xr73jiyQ6jF/ZCdZZiR/VuqOQVlA8RUdDRi/K0O
         IFFjROXIRsSGI500uxufVmV/TVFJwFUDzhRyMtCeimzwOQ/2M++AtGIlCGdNcLuEAMZw
         +jKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600745; x=1685192745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUx+hSs1GqSlRZxyuwSB8fOVcDQ/RGWYj+MVZKDGEtQ=;
        b=ldSP+wyYRQDe8DJZS18C32ojQknpUf7MfPR11A9gvRB9ETIQTIKY/H2zJEgako+lrb
         GTJ+9WGcszL3aWZHz+WLO8lprMY8cN0r4kB6nzM+loM2z/uImIRtvDGv+0ynfMYxod9T
         9et7Bt/iY+TA6w0+UJ2nC1a9l+w4CKNm4/Wrpgb3ktIMScahMYci8B5mpiBemuO54Raz
         6Y+ge9u82neL1yqdF+6EtsRDX1ft9c5gxxDjbbHwv0qUY7p62o9B1N7rxU4J6XpOSi8B
         3pxMziKLjoznB0ND5YpmJGGmD6qfXsf4nH3dYCBJA2n7Gr0PlUwWBNKorJXPLLJeImaz
         x+Jg==
X-Gm-Message-State: AC+VfDxAMuyMbWzvTtsJUWn3svzmsw86xCP+YW66rjZcqywkuEWcIkaD
        WKvww4sg2k52H6Un+24ijnA=
X-Google-Smtp-Source: ACHHUZ4jRVPbXnMWdZOv18tDzGA3FiKd1r5i2RQqvyjrfCvpwzr7f8TKKT5nwtqK/RgpC07nHDqInQ==
X-Received: by 2002:adf:ff81:0:b0:2d0:58f9:a6b with SMTP id j1-20020adfff81000000b002d058f90a6bmr4651396wrr.13.1682600744613;
        Thu, 27 Apr 2023 06:05:44 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:44 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v2 01/13] ovl: update of dentry revalidate flags after copy up
Date:   Thu, 27 Apr 2023 16:05:27 +0300
Message-Id: <20230427130539.2798797-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

After copy up, we may need to update d_flags if upper dentry is on a
remote fs and lower dentries are not.

Add helpers to allow incremental update of the revalidate flags.

Fixes: bccece1ead36 ("ovl: allow remote upper")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  2 ++
 fs/overlayfs/dir.c       |  3 +--
 fs/overlayfs/export.c    |  3 +--
 fs/overlayfs/namei.c     |  3 +--
 fs/overlayfs/overlayfs.h |  6 ++++--
 fs/overlayfs/super.c     |  2 +-
 fs/overlayfs/util.c      | 24 ++++++++++++++++++++----
 7 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c14e90764e35..7bf101e756c8 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -576,6 +576,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 			/* Restore timestamps on parent (best effort) */
 			ovl_set_timestamps(ofs, upperdir, &c->pstat);
 			ovl_dentry_set_upper_alias(c->dentry);
+			ovl_dentry_update_reval(c->dentry, upper);
 		}
 	}
 	inode_unlock(udir);
@@ -895,6 +896,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		inode_unlock(udir);
 
 		ovl_dentry_set_upper_alias(c->dentry);
+		ovl_dentry_update_reval(c->dentry, ovl_dentry_upper(c->dentry));
 	}
 
 out:
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index fc25fb95d5fc..9be52d8013c8 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -269,8 +269,7 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 
 	ovl_dir_modified(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
-	ovl_dentry_update_reval(dentry, newdentry,
-			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_reval(dentry, newdentry);
 
 	if (!hardlink) {
 		/*
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index defd4e231ad2..5c36fb3a7bab 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -326,8 +326,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (upper_alias)
 		ovl_dentry_set_upper_alias(dentry);
 
-	ovl_dentry_update_reval(dentry, upper,
-			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_reval(dentry, upper);
 
 	return d_instantiate_anon(dentry, inode);
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index cfb3420b7df0..100a492d2b2a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1122,8 +1122,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
-	ovl_dentry_update_reval(dentry, upperdentry,
-			DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_reval(dentry, upperdentry);
 
 	revert_creds(old_cred);
 	if (origin_path) {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4d0b278f5630..e100c55bb924 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -375,8 +375,10 @@ bool ovl_index_all(struct super_block *sb);
 bool ovl_verify_lower(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
-void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
-			     unsigned int mask);
+void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry);
+void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry);
+void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
+			   unsigned int mask);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f1d9f75f8786..49b6956468f9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1885,7 +1885,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
-	ovl_dentry_update_reval(root, upperdentry, DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_flags(root, upperdentry, DCACHE_OP_WEAK_REVALIDATE);
 
 	return root;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 923d66d131c1..6a0652bd51f2 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -94,14 +94,30 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 	return oe;
 }
 
+#define OVL_D_REVALIDATE (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)
+
 bool ovl_dentry_remote(struct dentry *dentry)
 {
-	return dentry->d_flags &
-		(DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
+	return dentry->d_flags & OVL_D_REVALIDATE;
+}
+
+void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry)
+{
+	if (!ovl_dentry_remote(realdentry))
+		return;
+
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= realdentry->d_flags & OVL_D_REVALIDATE;
+	spin_unlock(&dentry->d_lock);
+}
+
+void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry)
+{
+	return ovl_dentry_init_flags(dentry, upperdentry, OVL_D_REVALIDATE);
 }
 
-void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
-			     unsigned int mask)
+void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
+			   unsigned int mask)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 	unsigned int i, flags = 0;
-- 
2.34.1

