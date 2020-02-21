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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4634EC35656
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F7E0222C4
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NmffttUA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgBUOfA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:35:00 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45739 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgBUOfA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:35:00 -0500
Received: by mail-wr1-f65.google.com with SMTP id g3so2303841wrs.12
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SlISVj5khSmyb0ZhUI4MnicEtEutskRWLOy2gHjg7c0=;
        b=NmffttUAPa2L77LnFg0kRkPTSoh8C1Ys8WxdjUOJLkFTA2oqnNE4R6IcB2u5c0cncq
         Td0bVkF2+60tWwu8GGJh/y1zIniXg+vGh9RrizZIXwi7dJ3jEUPI+SFuKxO/0LlGRUZX
         6We9ihd5udUvkBZORrqNcx4fkH0FW99jDcRgYhOKxu6AewltqxZqXk4svaC/OhRwU09r
         CzeTJ/Ihu9UftEYt81o/wuyrGKJaFhIB4ZYceOWp60ImD9r7hfua/mJ9VkzKyE5btltt
         jZhawc/rJ6oEMOCBoJ4TJ5z3Aa03BLi7ct8O2ktAHb+Y62KWpxfTR/duDm53vMNwEK73
         mAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SlISVj5khSmyb0ZhUI4MnicEtEutskRWLOy2gHjg7c0=;
        b=DXW7NRPRiVLMVbXTwHzOqDxpvXnZ144AgDip+r1Z/Yrxr4MLxClKjdUvqz65EV/6+Z
         NwQRH6sw/0PfI5ICeY6/eNtN6YxOq3TPmBRrtpxInOW9SgG6ZgF+fC+jqSk9gGLx+yod
         x/7j3gcolXEs7gdbkd5HoaSc7TJ04CsxPNfmD6Wu41DNOG7hezHIC/Eadb1OFe59J7IJ
         /OFVer4mTB9/pPYNjc/1dDw4/F8MUK7iexpSxZi6vG7NiLhWxZ44CIpOv6mnIcVTwWpG
         JvUaC1liyo98jkX/pKrlcUw7gdXpRAyxt3h4jCW3JXzSXeIhnAWL+DIo13I4c1TiRYHY
         wYuQ==
X-Gm-Message-State: APjAAAVxGeACNXCza3zqLExLyLPfmQsD3rNyfeFoG55BJjlC8neeQUN9
        eNKQztwgb/Te64gR8Ymi/NhJ7Mio
X-Google-Smtp-Source: APXvYqwZ6jV6VVXYBh9RHYN8z59SqLGdk40s77hkOsib1D/34tlUCUqP7X6RV1Lm01q9ot3HBcZPow==
X-Received: by 2002:adf:ecc2:: with SMTP id s2mr50069199wro.263.1582295698093;
        Fri, 21 Feb 2020 06:34:58 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id a184sm4109014wmf.29.2020.02.21.06.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:34:57 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v2 3/5] ovl: avoid possible inode number collisions with xino=on
Date:   Fri, 21 Feb 2020 16:34:44 +0200
Message-Id: <20200221143446.9099-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221143446.9099-1-amir73il@gmail.com>
References: <20200221143446.9099-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When xino feature is enabled and a real directory inode number
overflows the lower xino bits, we cannot map this directory inode
number to a unique and persistent inode number and we fall back to
the real inode st_ino and overlay st_dev.

The real inode st_ino with high bits may collide with a lower inode
number on overlay st_dev that was mapped using xino.

To avoid possible collision with legitimate xino values, map a non
persistent inode number to a dedicated range in the xino address space.
The dedicated range is created by adding one more bit to the number of
reserved high xino bits.  We could have added just one more fsid, but
that would have had the undesired effect of changing persistent overlay
inode numbers on kernel or require more complex xino mapping code.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c   | 39 +++++++++++++++++++++++++++++----------
 fs/overlayfs/readdir.c | 10 ++++++++--
 fs/overlayfs/super.c   | 13 ++++++++-----
 3 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1d555cb1a5cd..d19e4cba4f61 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -79,6 +79,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 {
 	bool samefs = ovl_same_fs(dentry->d_sb);
 	unsigned int xinobits = ovl_xino_bits(dentry->d_sb);
+	unsigned int xinoshift = 64 - xinobits;
 
 	if (samefs) {
 		/*
@@ -89,20 +90,20 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		stat->dev = dentry->d_sb->s_dev;
 		return 0;
 	} else if (xinobits) {
-		unsigned int shift = 64 - xinobits;
 		/*
 		 * All inode numbers of underlying fs should not be using the
 		 * high xinobits, so we use high xinobits to partition the
 		 * overlay st_ino address space. The high bits holds the fsid
-		 * (upper fsid is 0). This way overlay inode numbers are unique
-		 * and all inodes use overlay st_dev. Inode numbers are also
-		 * persistent for a given layer configuration.
+		 * (upper fsid is 0). The lowest xinobit is reserved for mapping
+		 * the non-peresistent inode numbers range in case of overflow.
+		 * This way all overlay inode numbers are unique and use the
+		 * overlay st_dev.
 		 */
-		if (stat->ino >> shift) {
+		if (unlikely(stat->ino >> xinoshift)) {
 			pr_warn_ratelimited("inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
 					    dentry, stat->ino, xinobits);
 		} else {
-			stat->ino |= ((u64)fsid) << shift;
+			stat->ino |= ((u64)fsid) << (xinoshift + 1);
 			stat->dev = dentry->d_sb->s_dev;
 			return 0;
 		}
@@ -573,6 +574,7 @@ static void ovl_next_ino(struct inode *inode)
 static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
 {
 	int xinobits = ovl_xino_bits(inode->i_sb);
+	unsigned int xinoshift = 64 - xinobits;
 
 	/*
 	 * When d_ino is consistent with st_ino (samefs or i_ino has enough
@@ -582,11 +584,28 @@ static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
 	 * with d_ino also causes nfsd readdirplus to fail.
 	 */
 	inode->i_ino = ino;
-	if (ovl_same_dev(inode->i_sb)) {
-		if (xinobits && fsid && !(ino >> (64 - xinobits)))
-			inode->i_ino |= (unsigned long)fsid << (64 - xinobits);
-	} else if (S_ISDIR(inode->i_mode)) {
+	if (ovl_same_fs(inode->i_sb)) {
+		return;
+	} else if (xinobits && likely(!(ino >> xinoshift))) {
+		inode->i_ino |= (unsigned long)fsid << (xinoshift + 1);
+		return;
+	}
+
+	/*
+	 * For directory inodes on non-samefs with xino disabled or xino
+	 * overflow, we allocate a non-persistent inode number, to be used for
+	 * resolving st_ino collisions in ovl_map_dev_ino().
+	 *
+	 * To avoid ino collision with legitimate xino values from upper
+	 * layer (fsid 0), use the lowest xinobit to map the non
+	 * persistent inode numbers to the unified st_ino address space.
+	 */
+	if (S_ISDIR(inode->i_mode)) {
 		ovl_next_ino(inode);
+		if (xinobits) {
+			inode->i_ino &= ~0UL >> xinobits;
+			inode->i_ino |= 1UL << xinoshift;
+		}
 	}
 }
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 40ac9ce2465a..6325dcc4c48b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -440,13 +440,19 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 static u64 ovl_remap_lower_ino(u64 ino, int xinobits, int fsid,
 			       const char *name, int namelen)
 {
-	if (ino >> (64 - xinobits)) {
+	unsigned int xinoshift = 64 - xinobits;
+
+	if (unlikely(ino >> xinoshift)) {
 		pr_warn_ratelimited("d_ino too big (%.*s, ino=%llu, xinobits=%d)\n",
 				    namelen, name, ino, xinobits);
 		return ino;
 	}
 
-	return ino | ((u64)fsid) << (64 - xinobits);
+	/*
+	 * The lowest xinobit is reserved for mapping the non-peresistent inode
+	 * numbers range, but this range is only exposed via st_ino, not here.
+	 */
+	return ino | ((u64)fsid) << (xinoshift + 1);
 }
 
 /*
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 18b710344dd2..67cd9e59d467 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1483,7 +1483,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	 * free high bits in underlying fs to hold the unique fsid.
 	 * If overlayfs does encounter underlying inodes using the high xino
 	 * bits reserved for fsid, it emits a warning and uses the original
-	 * inode number.
+	 * inode number or a non persistent inode number allocated from a
+	 * dedicated range.
 	 */
 	if (ofs->numfs - !ofs->upper_mnt == 1) {
 		if (ofs->config.xino == OVL_XINO_ON)
@@ -1494,11 +1495,13 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	} else if (ofs->config.xino == OVL_XINO_ON && ofs->xino_mode < 0) {
 		/*
 		 * This is a roundup of number of bits needed for encoding
-		 * fsid, where fsid 0 is reserved for upper fs even with
-		 * lower only overlay.
+		 * fsid, where fsid 0 is reserved for upper fs (even with
+		 * lower only overlay) +1 extra bit is reserved for the non
+		 * persistent inode number range that is used for resolving
+		 * xino lower bits overflow.
 		 */
-		BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 31);
-		ofs->xino_mode = ilog2(ofs->numfs - 1) + 1;
+		BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 30);
+		ofs->xino_mode = ilog2(ofs->numfs - 1) + 2;
 	}
 
 	if (ofs->xino_mode > 0) {
-- 
2.17.1

