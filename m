Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B56C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244766AbiDGLZk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiDGLZj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:25:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD27637E
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BE76B8272A
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3231C385A0;
        Thu,  7 Apr 2022 11:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330617;
        bh=6q5UKH/K1PP8S/3FSC7rpJszRqi5npsVnw4HIdIH8Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emE5kyZmMh6FZZh/R6QNUDKmlDaq1OIoCNXv/wRfsTFGJBS4vPnCWVNUAfCLCwC6P
         KKanPDXzI0QA8lUGZ0ZYqX4IYUiE899DCfFSf2IF4qnauXsDOHHqTUZPMMhDRYiwJf
         tpg8SOFNFq58TFuHHiZS/hf5UwFh7+sG1Ud1MkvsMNFH8LjvGLfy/bkvlWZTMJbU50
         n+F8ifmJuoF6vEHfxXfnE0PUZhrY5Axf5DL1VoJGEDKVhTNuUzkJMAWLpyqnIV8nlJ
         2J3KZ8rpwK3Ql2cHl1pb2yJS8Bwxpn0+iSO+F4erwKfWnJpGq0LrNprMHefqkzcfNV
         6+QuIgYwJGoSQ==
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
Subject: [PATCH v5 19/19] ovl: support idmapped layers
Date:   Thu,  7 Apr 2022 13:21:56 +0200
Message-Id: <20220407112157.1775081-20-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; h=from:subject; bh=6q5UKH/K1PP8S/3FSC7rpJszRqi5npsVnw4HIdIH8Y4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfSrblc6qcuitu1KxKyyvUli4fYPDMQK5B8Gb8nSSEli 71nWUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJH3+YwMB0tYWBZ0f93M4XgzbOO0t0 eiYmMXps/7r9SkIqt3ZcqcTIb/Tne4FvIc3b0gwnav9AKL/SHBF5gvbr5RM0XqbqmZ3V0/TgA=
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

/* v5 */
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

