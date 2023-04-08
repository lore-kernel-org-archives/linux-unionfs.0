Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A411C7619A
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjDHQnN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHQnM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:12 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D76AF3C
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i27so1162863wrc.1
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972190; x=1683564190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xiian5/D6/yo41G0ugtS1goLOW1OEyfi0Yz9b9G4LQ=;
        b=og6ezpWul2iU50UhI2ar3j6LVQnFC9Llr9Vz5nLzgm9xY1jsl68mPBJJiUwOtFhiS5
         xPnsElxZYoP5UEVhrolAN6N/8YzGvxoOGfMbncEFeIRsSvGaLb2NpKskOiTEKfYi4BfV
         OBxCS6PnS0HMePjSkVAr8ypBuIdmohupI72l7kQ3hYB6LjCtlgxktR2LtTYDIntuuy8b
         oKGf9/tnp3ps05/GSKlxTHJC/p7Ql9NGvbb042I0VNH5xkyR7JSiw4zdviH6EnG+rnoV
         xLf6qYEgqhr8oh22yKVT3R6NeVc2xP80mrRSsll0LGQt53Odz9NEoNNIMQ4Kx/gnMoca
         CpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972190; x=1683564190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xiian5/D6/yo41G0ugtS1goLOW1OEyfi0Yz9b9G4LQ=;
        b=eXjlzoOYesitj/ZOuqw+bxaxYr8SliPsHOVXcKvlT1MvNbjKQj1xmgYje3qSSJo1Nf
         IACkwo3qHLA2D/dd3x9iBDXtOWOrGPfHeUKIgzZZ1TrhpE2M1z6GAUmp6aYXJEYAIUG/
         r5iUSQDIIcfcATfc+Zjz9CjoHYmQ45yxGuHJW8jzp1OL+MCrXtscuMBgpXLlLAQKskEu
         o+UBbn/0NSIObwR2qJsnjXb8ZzaraHi8CWsH50sRoMp9GQxKxyLqotq4Fc0osxg3Sp+c
         aXfxST44YOoVvQ15JLzseFDExT5u2VicarAHOHAg7ap+0jljoU4D4Qko9Jg47wpJTYUa
         BLPA==
X-Gm-Message-State: AAQBX9fDeV6vwnXhB562LxTSqT1W7DwEzEnuHtuWi9Bxpvo/QKVT+LIJ
        fLsTKaSIxrwhGS3eU2PSSgs=
X-Google-Smtp-Source: AKy350abLdrBR2Mp8BO/wruk1BqnLpHlrft1s+NSnByw5W9KmjCp0dMkuMxlcJ36ZIJuvpYycgtFcQ==
X-Received: by 2002:adf:ce10:0:b0:2ef:3140:8701 with SMTP id p16-20020adfce10000000b002ef31408701mr3023250wrn.10.1680972189543;
        Sat, 08 Apr 2023 09:43:09 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 1/7] ovl: update of dentry revalidate flags after copy up
Date:   Sat,  8 Apr 2023 19:42:56 +0300
Message-Id: <20230408164302.1392694-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408164302.1392694-1-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

After copy up, we may need to update d_flags if upper dentry is on a
remote fs and lower dentries are not.

Add helpers to allow incremental update of the revalidate flags.

Fixes: bccece1ead36 ("ovl: allow remote upper")
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

