Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E625C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiCaL0y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiCaL0y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:26:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EFCE01D
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:25:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24F03B820C4
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAE4C340EE;
        Thu, 31 Mar 2022 11:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725904;
        bh=aJInD1WLkljol/qO2oyeDBrHsjhh98TPzkrhCaLZ/HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQA434RnuPUh4ZHjzVFsfyUaJzmFi0jI3dGD95Dla2C+2OM9W13ycEskpjjhZPxcG
         ZooVZVgbQB3kwmcJ/pFHQ6KIn2gBg8LE5dsb4k3Rf6/epcLXtx5RKNuO8IiDjR2d+g
         qchS3bIPZkHJvk/cad5gqcdbS5tfsTfzxgBUrIDiMrBrWTgICkvnSwbNxxr/ZLHJbH
         ai9TOtu1rL/JUH45R+nh5Xefa4elYdfcrkv1UFSQvM/Iu3vbQDaTNfJ38Ta7Qz8DRm
         yCC5Z3qSSHdfUC+drcJG6G2iyHlleVmourtcwWQqWXOAr9LL/1mqvW2mPOpulUEa4N
         J5aT+X9an1qmw==
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
Subject: [PATCH v3 19/19] ovl: support idmapped layers
Date:   Thu, 31 Mar 2022 13:23:17 +0200
Message-Id: <20220331112318.1377494-20-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1704; h=from:subject; bh=aJInD1WLkljol/qO2oyeDBrHsjhh98TPzkrhCaLZ/HY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59ss4MWa5yb48YXb77MKXHazXUl2260ce/9H+dIN2+5cL mfULO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayLZvhf5DvZoHQyPtf98aL9BjYvt bhebhSwOXXPZVTbEkHVqzJq2L4w9VX66jtK+P8I+dGZeKLR7rn1sYk3fz6OmpHcdgPHVYhZgA=
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
---
 fs/overlayfs/ovl_entry.h | 2 +-
 fs/overlayfs/super.c     | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 79b612cfbe52..898b002a5c6f 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -92,7 +92,7 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
 
 static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)
 {
-       return &init_user_ns;
+	return mnt_user_ns(ovl_upper_mnt(ofs));
 }
 
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9a656a24f7b1..d4cc07f7a2ef 100644
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

