Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14708C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 10:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245364AbiC3K2P (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245360AbiC3K2O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 06:28:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD96325FD6F
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 03:26:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB89B81BE7
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 10:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC022C340F2;
        Wed, 30 Mar 2022 10:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635987;
        bh=cmQxe0onAS1e1bm83vy7u3OkaCNT3x5WsSrjkVCJIA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHbTqaZI0C7/AzMc/hWqQx4yQ60AkyMboD+J7Y+6JcU+eVe6E7csTHoTIq8Y9RHP0
         Vn8Hq7PxZOHvJ848DV3Pwc+ADy/zelbk1nQa+58x9KrzaRlm3xjajJIxliS+z9+p/l
         kf7j/31tZBnu15siY9hd8JJ222h3/6GP07PAkX2bMCWNlu1hProRciUWq9QA1PzmXF
         NnDic1qK3V7n+GGDSt0McgGEX397jLxIjLpXdR+cTU50MaoIXqS5+j8aK8yetDqQ29
         18kxkrB35HftrInlpQXen/XsyGRmSEf7wj50luO+9l70lu+9IETTcxKDDCR4IUQd+1
         eg6m0J6MwHFgw==
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
Subject: [PATCH v2 18/19] ovl: handle idmappings in ovl_xattr_{g,s}et()
Date:   Wed, 30 Mar 2022 12:24:06 +0200
Message-Id: <20220330102409.1290850-19-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2145; h=from:subject; bh=cmQxe0onAS1e1bm83vy7u3OkaCNT3x5WsSrjkVCJIA4=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56B84xW+kNDU3/ffK05M3MbJ2vxap6ol192Zcte3Wnq1T vxyQ6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIbHFGhmMq7+dFsTUylDQezv13n/ Eat4BnEl/nPo0XzK93ZElO3MHIcO1yvt/6x/+j3gZnRfubhmp8XHrV7Hqm1AL1SwvOCL/5wwcA
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

