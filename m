Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53099C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiCaL0v (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiCaL0u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:26:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6494A92B
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E329BB820C3
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF4FC340ED;
        Thu, 31 Mar 2022 11:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725900;
        bh=CsftalyXAX2r+d3BPfCnUXJaWhwSTTIdEOrLr1GcAeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkCjJqeFweSqd9RNpX9AQOt5tIwMbXkWzENL8dKz6U+VYuhwPEmhY/pnTc96mNtyt
         4ILhTGlOcqTCuTAJyakL085REftqkA+ATdTWhPvexxhGCAL4XKBsK98loEADgQ7Tgo
         SV+argd85kl4uMLLrEXQQBL4wbmJuYLuGNU6MhR3YBdczp2lsg+TFEZvprBPdS4CPR
         I9rpHH6Igba+NaqFSsoJtQrU/ax9zjVasrKFQyqqTRBq/a+fBuHA906ez1BiNoT7qi
         X/eYGBz3FS4ddRgK+JKye4AZJ5Df+T404xnFTadQ3VvU/H+ax6OvIL6FREUoe7vYE3
         9xQHCXDa0sEZA==
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
Subject: [PATCH v3 18/19] ovl: handle idmappings in ovl_xattr_{g,s}et()
Date:   Thu, 31 Mar 2022 13:23:16 +0200
Message-Id: <20220331112318.1377494-19-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2168; h=from:subject; bh=CsftalyXAX2r+d3BPfCnUXJaWhwSTTIdEOrLr1GcAeo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59svsimRPvHVd4Xur/uMAvr0ss/pO6f/r9/cvdFB7ureg Tm5PRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESeXGRk+PYyxok1y/D/qWj3uL6+zn s7qyJrlp34t+2lR5SHWpvDOYb/weLb+R07v7t6bVVlCF+xZpWRWnt5dnTblzizS+V5KzcxAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When retrieving xattrs from the upper or lower layers take the relevant
mount's idmapping into account. We rely on the previously introduced
ovl_i_path_real() helper to retrieve the relevant path. This is needed
to support idmapped base layers with overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
unchanged

/* v3 */
unchanged
---
 fs/overlayfs/inode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 0b09e62091da..a3fcb61844ff 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -349,6 +349,7 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
 	struct dentry *realdentry = upperdentry ?: ovl_dentry_lower(dentry);
+	struct path realpath;
 	const struct cred *old_cred;
 
 	err = ovl_want_write(dentry);
@@ -356,8 +357,9 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 		goto out;
 
 	if (!value && !upperdentry) {
+		ovl_path_lower(dentry, &realpath);
 		old_cred = ovl_override_creds(dentry->d_sb);
-		err = vfs_getxattr(&init_user_ns, realdentry, name, NULL, 0);
+		err = vfs_getxattr(mnt_user_ns(realpath.mnt), realdentry, name, NULL, 0);
 		revert_creds(old_cred);
 		if (err < 0)
 			goto out_drop_write;
@@ -395,11 +397,11 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 {
 	ssize_t res;
 	const struct cred *old_cred;
-	struct dentry *realdentry =
-		ovl_i_dentry_upper(inode) ?: ovl_dentry_lower(dentry);
+	struct path realpath;
 
+	ovl_i_path_real(inode, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
-	res = vfs_getxattr(&init_user_ns, realdentry, name, value, size);
+	res = vfs_getxattr(mnt_user_ns(realpath.mnt), realpath.dentry, name, value, size);
 	revert_creds(old_cred);
 	return res;
 }
-- 
2.32.0

