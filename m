Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B36EC433FE
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Apr 2022 10:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358034AbiDDK45 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 06:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358767AbiDDK44 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Apr 2022 06:56:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5439C3389C
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 03:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E39F960B0C
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 10:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82061C2BBE4;
        Mon,  4 Apr 2022 10:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069700;
        bh=lXijgtfw0oyTiW5/b9LAGlOOw9gPne0FQLwt4pfv+CA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTUXF3kU0uKuxkCFKE/pK5IdttgWyFU7OV5NTDo/CSoYF7AZQbvNDxtf5qqjVsLLN
         ZRO11tJeyuOCKPq4iGFhKqGiF59pFyLuuiUgj9yW9c++KwF6c9iPodTnmYjOv10ei8
         H01O/JII7pD48EsFR2NqbLy2YTTwnCjQW3n5Yd4sE83p6ueBI33rEhSWje4HXi7UgW
         oVutkONRZoL0yT83dd1NMX3PRGmNbFNu4UxNYqhxe+feKQbkRS3ZwZ/dXA7EnsRHgC
         fgJXCIWQsB577xSn/oaAEjLWMjruBZXhjyKd1iv+8LfTpHAApKt0f2QFPLaP3NyVZ8
         jljWnYmiJxfaw==
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
Subject: [PATCH v4 18/19] ovl: handle idmappings in ovl_xattr_{g,s}et()
Date:   Mon,  4 Apr 2022 12:51:57 +0200
Message-Id: <20220404105159.1567595-19-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220404105159.1567595-1-brauner@kernel.org>
References: <20220404105159.1567595-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2191; h=from:subject; bh=lXijgtfw0oyTiW5/b9LAGlOOw9gPne0FQLwt4pfv+CA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR5nT2+7di76dJp6xvUDZiuya3ZqKv2Tm33keAeHumQiNDQ +yHTOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZiO5mR4UTyTU8F9XsCuzasXFaqkH 3ddcdNrs51YmJ5rUWiDZG/TzEyrFtUnmXjnJicO2Xxon3PCtdf+vm+5uwu2QUiMQfPX5wmyggA
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

/* v4 */
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

