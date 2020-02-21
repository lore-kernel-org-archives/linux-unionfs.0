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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D5BC35646
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:34:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EADD222C4
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:34:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhLNeBft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgBUOe7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:34:59 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55478 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBUOe7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:34:59 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so2016178wmj.5
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Te8DPg4MJrBvsFAqbuBPY526gkZKgWcy8+MNpYkeURw=;
        b=mhLNeBftJZS5I+Lfkq39OObgRogMQ7i2YcgdbNwrYFZimVnfU6r/32kxbW59VDhKj/
         2QmXBvZAwZzI/kDr5kYfxDRzx8Xh9q5LimKCi6TPtoOnc4G/O4QymBcE3Fb27cUCTVk/
         RVNG5fNmYaTQ7PaPDHBwCmsL1lvHWKh2v9wu7CQ4NrYwCRN/oAzki3mQNQFAlDmujjt2
         +LHLmsSoAhlQc2pJ4Dn5dSFc5IULJIv6+ICOwODp5fLS72B+p0E7AJ8+g0hsP5mLnxOS
         sem8A3oiONqq4m26H518Fn9g70J/QD9FJ6LpDh5rQ40mdBg/mU777GWzyoxx8+tGDgMP
         l2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Te8DPg4MJrBvsFAqbuBPY526gkZKgWcy8+MNpYkeURw=;
        b=RCrtLsJ7BQ3OYH31JeFNhL8GroCOHUj0Zfv9KInpmG8fatLtNs/df31gsExgeKk8yJ
         43trcw01sCCfS03Tbck9+maOZQIxEuqzdHootcBbkwH+r9ng+eEptZRi9MD9r6XJ4Rjf
         il4Zg2/VLsU/obzpuxGAM8WyUjn+/+5qidyh148wIZYhBskKxZIA06IDydqx4yJd04V0
         D5Uo/5tyM7NsOeKmYS5umRbRvcnAfSstDVYpwzu+W41zoh0VYNq+vvTZPexHwM3MfJFT
         B+dxlv5mKRX5mCkTwFUVjKNnWw/puvZ6LZIdBj32AyWtO54l7MScy0m6Qw37AlSijpbA
         4eGg==
X-Gm-Message-State: APjAAAVZkjuEAb/AHnF3F/KKDHWUYNbiEGED3RAygI/GwHn3tS6fobxM
        /LnSW1Wjgvj4vhYaORAgm6Q=
X-Google-Smtp-Source: APXvYqzB6/KR5skuYGoZw58iEWZaWbKdo5ZrECbAODiFpgGk8ykKxcH5aqkWNuqr+iO9A94IBo/GhQ==
X-Received: by 2002:a7b:c753:: with SMTP id w19mr4391708wmk.34.1582295696762;
        Fri, 21 Feb 2020 06:34:56 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id a184sm4109014wmf.29.2020.02.21.06.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:34:56 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH v2 2/5] ovl: use a private non-persistent ino pool
Date:   Fri, 21 Feb 2020 16:34:43 +0200
Message-Id: <20200221143446.9099-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221143446.9099-1-amir73il@gmail.com>
References: <20200221143446.9099-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There is no reason to deplete the system's global get_next_ino() pool
for overlay non-persistent inode numbers and there is no reason at all
to allocate non-persistent inode numbers for non-directories.

For non-directories, it is much better to leave i_ino the same as
real i_ino, to be consistent with st_ino/d_ino.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 15 ++++++++++++---
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     |  1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 13219a5864c4..1d555cb1a5cd 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -561,6 +561,15 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 #endif
 }
 
+static void ovl_next_ino(struct inode *inode)
+{
+	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+
+	inode->i_ino = atomic_long_inc_return(&ofs->last_ino);
+	if (unlikely(!inode->i_ino))
+		inode->i_ino = atomic_long_inc_return(&ofs->last_ino);
+}
+
 static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
 {
 	int xinobits = ovl_xino_bits(inode->i_sb);
@@ -572,12 +581,12 @@ static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
 	 * consistent with d_ino and st_ino values. An i_ino value inconsistent
 	 * with d_ino also causes nfsd readdirplus to fail.
 	 */
+	inode->i_ino = ino;
 	if (ovl_same_dev(inode->i_sb)) {
-		inode->i_ino = ino;
 		if (xinobits && fsid && !(ino >> (64 - xinobits)))
 			inode->i_ino |= (unsigned long)fsid << (64 - xinobits);
-	} else {
-		inode->i_ino = get_next_ino();
+	} else if (S_ISDIR(inode->i_mode)) {
+		ovl_next_ino(inode);
 	}
 }
 
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 89015ea822e7..5762d802fe01 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -75,6 +75,8 @@ struct ovl_fs {
 	struct inode *indexdir_trap;
 	/* -1: disabled, 0: same fs, 1..32: number of unused ino bits */
 	int xino_mode;
+	/* For allocation of non-persistent inode numbers */
+	atomic_long_t last_ino;
 };
 
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f4c0ad69f9a6..18b710344dd2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1736,6 +1736,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_stack_depth = 0;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	atomic_long_set(&ofs->last_ino, 1);
 	/* Assume underlaying fs uses 32bit inodes unless proven otherwise */
 	if (ofs->config.xino != OVL_XINO_OFF) {
 		ofs->xino_mode = BITS_PER_LONG - 32;
-- 
2.17.1

