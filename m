Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632F8C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Apr 2022 10:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358816AbiDDK5E (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 06:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358767AbiDDK5C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Apr 2022 06:57:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9782F3A3
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 03:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF64560AFF
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 10:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EF9C34111;
        Mon,  4 Apr 2022 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069706;
        bh=97NHJcKeiBpbgBfdsa7Bz9FElrmv/3jv6EiCGYFAIuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOy0XIP0J9U6X0Lf8t2Za9e4XxXMTxSOuZgZOShtyLeyMoTspQyUWCiSZQtva5A/x
         alOrtc5ctFXQvzE8dD57G/ylITJ6RbgA49t6LwnTcZZslTDZJe+ln9HxnTjjXMN9wT
         NONLhbystR0gu0Q5Fk+CYlHcmaWIoPx6ruYiRmcg1g29BdGlD32j0hLkkKTGeHZvxv
         lZLc93ObVsxxGtWVquVTa3QxWBV/PQW73pDdW5Ww6JPmaLEvGPmzqiN/0YSXW6VhOx
         7dBh5zpi3IfxBKmSVsP7HidLP1hLAgHp9WjI+H3rYFOO+HOgYR+rBfSaXnGnc+/0k2
         DeCFdeDz/O82w==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
Subject: [PATCH v4 19/19] ovl: support idmapped layers
Date:   Mon,  4 Apr 2022 12:51:58 +0200
Message-Id: <20220404105159.1567595-20-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220404105159.1567595-1-brauner@kernel.org>
References: <20220404105159.1567595-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1732; h=from:subject; bh=97NHJcKeiBpbgBfdsa7Bz9FElrmv/3jv6EiCGYFAIuk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR5nT2+4uOP1au27VsUU2upvEfw2Lo2VZGLFaVvNog+Kv4Y 5nE9uqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAif+cx/M9+rpQ5e/ZDsROWzNv7gn qbRD6vN9WvK+RyPldwuWFF4XOGf0omTz4cV16YXX55o0LEFmnr9U+j3yjd3Mo3s2rj47UOe3gB
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Now that overlay is able to take a layers idmapping into account allow
overlay mounts to be created on top of idmapped mounts.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
- Turn on support for idmapped mounts in ovl_upper_idmap() helper here
  after we've introduced it earlier in the series and made it return the
  initial idmapping.

/* v3 */
unchanged

/* v4 */
unchanged
---
 fs/overlayfs/ovl_entry.h | 2 +-
 fs/overlayfs/super.c     | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 8630fd93238a..e1af8f660698 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -92,7 +92,7 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
 
 static inline struct user_namespace *ovl_upper_mnt_userns(struct ovl_fs *ofs)
 {
-       return &init_user_ns;
+	return mnt_user_ns(ovl_upper_mnt(ofs));
 }
 
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0123c8086ee9..e0a2e0468ee7 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -874,10 +874,6 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
 		pr_err("filesystem on '%s' not supported\n", name);
 		goto out_put;
 	}
-	if (is_idmapped_mnt(path->mnt)) {
-		pr_err("idmapped layers are currently not supported\n");
-		goto out_put;
-	}
 	if (!d_is_dir(path->dentry)) {
 		pr_err("'%s' not a directory\n", name);
 		goto out_put;
-- 
2.32.0

