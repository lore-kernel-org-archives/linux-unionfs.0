Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB8DC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbiDGLZf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiDGLZf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:25:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B39637E
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95040B82730
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E66C385A7;
        Thu,  7 Apr 2022 11:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330613;
        bh=SGCaVTGeIWfycaomEt/ZveOhRkv3aZYBz3fbyKvHVyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyfVX0IxQTEa6/9ot1rBTf/IeTtE+mZZbiL9c8LK9UWqZhO/mR3FsmIEXokadMMf3
         7y7Qz20jq/TPrfzOnKNQ+DQ7hgYd+rpKnxudXM4SKk3U1pATHO0Y5OavUSf/+/K7tO
         4Z0eFsMf8aO9/8NijIcFSdfsk/BtFJbP6qFD9zrYBKBEvo/eE+Pe1brB3ijDpXhbsm
         FLxmblPKhzFgqmSBHXYFNKUC2ygGb94NZzKhVa49/ZKWa29EHFnEE+5S55IpP8g4wo
         jcoygM8nobi3IIPblDnLFI/Kj34W1RZYJ2OhnUtNWeLR7943wtFPp+wg0pUMmmt4nQ
         KW9ArsdioMxrg==
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
Subject: [PATCH v5 18/19] ovl: handle idmappings in ovl_xattr_{g,s}et()
Date:   Thu,  7 Apr 2022 13:21:55 +0200
Message-Id: <20220407112157.1775081-19-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2214; h=from:subject; bh=SGCaVTGeIWfycaomEt/ZveOhRkv3aZYBz3fbyKvHVyk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfRrZH/6SmGrYfoPy7KF4U3+5ncymEK+XxZQ3fBbmMlz 1VW2jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInEMDIyXLlx5o3L/12arrLeC0v5Dx 9uilcIrD/6at/3rNUPTnQHcjH8lZ1e3V0u90n8kJ7nygtqLcZhofOdOXLtZLQuONt92h/GCwA=
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

/* v5 */
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

