Return-Path: <SRS0=Fd6Y=4J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B685BC35646
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8067724650
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CSbCILhB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgBUOfC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:35:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50243 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBUOfC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:35:02 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so2030615wmb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f08LbabUI4MvY9CXB/rjbsppdJ6qjMetNnxvke4MlDo=;
        b=CSbCILhBS6inWJNpHS+P6on2BG4o0xpB0sDkYjpWv28164gE71GQlcZvq7UkePbDoH
         eJCGQqFbBDednHsPIMHBvFbR/dPGG7VarG35irBmrMFOZa5DFoaHqtL/MTN6m4lPtxAG
         P8eEu4JSAkGb8qUq6wNrzRvwOuG7wDAsT7g196SFHDxYOUecVUWza7QqKHiJA66cLKML
         Eo5Qg7aUJB8WKDgE8caXOj/FsdWRNfEkeRVW74yQ71/2DxgwpfFGHdO5RKca7+VOJ9y7
         Q33X+lAJC500MylCLcQ4XyZEAOw5pzWgSCH2k+7IiIf0+G0PCy2UXioYyJOBo5zhMfwP
         +mVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f08LbabUI4MvY9CXB/rjbsppdJ6qjMetNnxvke4MlDo=;
        b=ecFmzfJQIvLt+ruwEdjsp2JqhMKcd4xWjpyFgz49ol1rgrcnA4F7VoPmFV3Wn15OXV
         EbF2V21CLrfUk6k9wy+K4ndJiXfg2l/lYUWh40C5xQdJu6iMMiPdziYIRw81k0NPMzlV
         B5rMvdVsfnNvvyOSOQixaoxcrer6xI276q8R2t8gY9iT0Xp5S8CWMWCuNavaSUm4Mn85
         44R4Edip8AblSZR9u00etcLR0eb27hwRPKyWBB0vSYQ7r09AZ1YBqM4M/L4+kbjnWUnh
         +SbCkg9dSNxwsBYALamnguBhg+V6UcEbHyhL/lPYvWuOwHKkr9POljgvfRWeiFyn9YpB
         5FnA==
X-Gm-Message-State: APjAAAWZECOsXkk7DyECV+JI+GmZVmJvjlVO1t97JipeGlTMpkQAFm8S
        apr2f5fES2Cwyn6bmKgD7co=
X-Google-Smtp-Source: APXvYqxK2wbupHRMwNrrvIM/YDPmY9euiP3KqghZ2ioTFGOJ+JP+Fc3WnhDovFH3IoGapot1b1CGUg==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr4259475wme.90.1582295699470;
        Fri, 21 Feb 2020 06:34:59 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id a184sm4109014wmf.29.2020.02.21.06.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:34:59 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v2 4/5] ovl: enable xino automatically in more cases
Date:   Fri, 21 Feb 2020 16:34:45 +0200
Message-Id: <20200221143446.9099-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221143446.9099-1-amir73il@gmail.com>
References: <20200221143446.9099-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

So far, with xino=auto, we only enable xino if we know that all
underlying filesystem use 32bit inode numbers.

When users configure overlay with xino=auto, they already declare that
they are ready to handle 64bit inode number from overlay.

It is a very common case, that underlying filesystem uses 64bit ino,
but rarely or never uses the high inode number bits (e.g. tmpfs, xfs).
Leaving it for the users to declare high ino bits are unused with
xino=on is not a recipe for many users to enjoy the benefits of xino.

There appears to be very little reason not to enable xino when users
declare xino=auto even if we do not know how many bits underlying
filesystem uses for inode numbers.

In the worst case of xino bits overflow by real inode number, we
already fall back to the non-xino behavior - real inode number with
unique pseudo dev or to non persistent inode number and overlay st_dev
(for directories).

The only annoyance from auto enabling xino is that xino bits overflow
emits a warning to kmsg. Suppress those warnings unless users explicitly
asked for xino=on, suggesting that they expected high ino bits to be
unused by underlying filesystem.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  8 ++++----
 fs/overlayfs/overlayfs.h | 16 ++++++++++++++++
 fs/overlayfs/readdir.c   | 15 ++++++++++-----
 fs/overlayfs/super.c     | 12 +++---------
 4 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d19e4cba4f61..ff917d376bdd 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -99,13 +99,13 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		 * This way all overlay inode numbers are unique and use the
 		 * overlay st_dev.
 		 */
-		if (unlikely(stat->ino >> xinoshift)) {
-			pr_warn_ratelimited("inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
-					    dentry, stat->ino, xinobits);
-		} else {
+		if (likely(!(stat->ino >> xinoshift))) {
 			stat->ino |= ((u64)fsid) << (xinoshift + 1);
 			stat->dev = dentry->d_sb->s_dev;
 			return 0;
+		} else if (ovl_xino_warn(dentry->d_sb)) {
+			pr_warn_ratelimited("inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
+					    dentry, stat->ino, xinobits);
 		}
 	}
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 68df20512dca..3ccf1725e3d2 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -48,6 +48,12 @@ enum ovl_entry_flag {
 	OVL_E_CONNECTED,
 };
 
+enum {
+	OVL_XINO_OFF,
+	OVL_XINO_AUTO,
+	OVL_XINO_ON,
+};
+
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
@@ -301,6 +307,16 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
 }
 
+/*
+ * With xino=auto, we do best effort to keep all inodes on same st_dev and
+ * d_ino consistent with st_ino.
+ * With xino=on, we do the same effort but we warn if we failed.
+ */
+static inline bool ovl_xino_warn(struct super_block *sb)
+{
+	return OVL_FS(sb)->config.xino == OVL_XINO_ON;
+}
+
 /* All layers on same fs? */
 static inline bool ovl_same_fs(struct super_block *sb)
 {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6325dcc4c48b..e452ff7d583d 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -438,13 +438,15 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 
 /* Map inode number to lower fs unique range */
 static u64 ovl_remap_lower_ino(u64 ino, int xinobits, int fsid,
-			       const char *name, int namelen)
+			       const char *name, int namelen, bool warn)
 {
 	unsigned int xinoshift = 64 - xinobits;
 
 	if (unlikely(ino >> xinoshift)) {
-		pr_warn_ratelimited("d_ino too big (%.*s, ino=%llu, xinobits=%d)\n",
-				    namelen, name, ino, xinobits);
+		if (warn) {
+			pr_warn_ratelimited("d_ino too big (%.*s, ino=%llu, xinobits=%d)\n",
+					    namelen, name, ino, xinobits);
+		}
 		return ino;
 	}
 
@@ -521,7 +523,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	} else if (xinobits && !OVL_TYPE_UPPER(type)) {
 		ino = ovl_remap_lower_ino(ino, xinobits,
 					  ovl_layer_lower(this)->fsid,
-					  p->name, p->len);
+					  p->name, p->len,
+					  ovl_xino_warn(dir->d_sb));
 	}
 
 out:
@@ -651,6 +654,7 @@ struct ovl_readdir_translate {
 	u64 parent_ino;
 	int fsid;
 	int xinobits;
+	bool xinowarn;
 };
 
 static int ovl_fill_real(struct dir_context *ctx, const char *name,
@@ -671,7 +675,7 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
 			ino = p->ino;
 	} else if (rdt->xinobits) {
 		ino = ovl_remap_lower_ino(ino, rdt->xinobits, rdt->fsid,
-					  name, namelen);
+					  name, namelen, rdt->xinowarn);
 	}
 
 	return orig_ctx->actor(orig_ctx, name, namelen, offset, ino, d_type);
@@ -702,6 +706,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
 		.xinobits = ovl_xino_bits(dir->d_sb),
+		.xinowarn = ovl_xino_warn(dir->d_sb),
 	};
 
 	if (rdt.xinobits && lower_layer)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 67cd9e59d467..01938c93e5c8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -317,12 +317,6 @@ static const char *ovl_redirect_mode_def(void)
 	return ovl_redirect_dir_def ? "on" : "off";
 }
 
-enum {
-	OVL_XINO_OFF,
-	OVL_XINO_AUTO,
-	OVL_XINO_ON,
-};
-
 static const char * const ovl_xino_str[] = {
 	"off",
 	"auto",
@@ -1479,8 +1473,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 
 	/*
 	 * When all layers on same fs, overlay can use real inode numbers.
-	 * With mount option "xino=on", mounter declares that there are enough
-	 * free high bits in underlying fs to hold the unique fsid.
+	 * With mount option "xino=<on|auto>", mounter declares that there are
+	 * enough free high bits in underlying fs to hold the unique fsid.
 	 * If overlayfs does encounter underlying inodes using the high xino
 	 * bits reserved for fsid, it emits a warning and uses the original
 	 * inode number or a non persistent inode number allocated from a
@@ -1492,7 +1486,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		ofs->xino_mode = 0;
 	} else if (ofs->config.xino == OVL_XINO_OFF) {
 		ofs->xino_mode = -1;
-	} else if (ofs->config.xino == OVL_XINO_ON && ofs->xino_mode < 0) {
+	} else if (ofs->xino_mode < 0) {
 		/*
 		 * This is a roundup of number of bits needed for encoding
 		 * fsid, where fsid 0 is reserved for upper fs (even with
-- 
2.17.1

