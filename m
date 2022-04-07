Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5C0C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiDGLZ1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiDGLZ0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85005637E
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB73661E1E
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C86C385A4;
        Thu,  7 Apr 2022 11:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330606;
        bh=heNRhVYD10ENxTFlqTs5ld9AtMj91SbLemTKLf/ypJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBGmYQEvKO/ht7JNxAJ1bTfw29OBPzQdvgPHzQPo9gBdEoGAj0Aj8mgkzUoUcnAJz
         YZ6b3D6q4HXRIEqDKdhrkPPXfpFYsbKpSQtfyjBv1K9/7XjJBVgDUNIqmdLqQfL9o1
         g8x0pC75/m41IpqvXPyMB3Xs40gwHk6B9y1RgxU3JoOjbwWfpkd1wjYOGjcLLId7DS
         v8bWL+U8B/iaZhPphh0XJKgOjgO26zTyPY1m7hJjBcQD6aAxHKPIgP/gykxey83f65
         7ppXLFu7qY3hfE+lACOTIjkuRM8o9IHP+XBTO2FeUK3jqwVokAXdyoYJ5DDo/xBEe/
         ZKjeAUtwJ5lKw==
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
Subject: [PATCH v5 16/19] ovl: handle idmappings in ovl_permission()
Date:   Thu,  7 Apr 2022 13:21:53 +0200
Message-Id: <20220407112157.1775081-17-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1951; h=from:subject; bh=heNRhVYD10ENxTFlqTs5ld9AtMj91SbLemTKLf/ypJY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfR9pj8nMmqmUMXzpwI8K6bedjy5+9JXDtv9O26/7Z0Y Erh8UUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE3GsZ/pdZaJr5OHK4Rs+cq/Wih+ 3DRM0GDWuB3wFnqywKeYtS7BkZGl88cfe7//Gv3Kn2483HK30KKlPNFz8+0pL4gNNo48F8dgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Use the previously introduced ovl_i_path_real() helper to retrieve the
relevant upper or lower path and take the mount's idmapping into account
for the lower layer permission check. This is needed to support idmapped
base layers with overlay.

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
 fs/overlayfs/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 44fa578267fa..0b09e62091da 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -280,12 +280,14 @@ int ovl_permission(struct user_namespace *mnt_userns,
 		   struct inode *inode, int mask)
 {
 	struct inode *upperinode = ovl_inode_upper(inode);
-	struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
+	struct inode *realinode;
+	struct path realpath;
 	const struct cred *old_cred;
 	int err;
 
 	/* Careful in RCU walk mode */
-	if (!realinode) {
+	ovl_i_path_real(inode, &realpath);
+	if (!realpath.dentry) {
 		WARN_ON(!(mask & MAY_NOT_BLOCK));
 		return -ECHILD;
 	}
@@ -298,6 +300,7 @@ int ovl_permission(struct user_namespace *mnt_userns,
 	if (err)
 		return err;
 
+	realinode = d_inode(realpath.dentry);
 	old_cred = ovl_override_creds(inode->i_sb);
 	if (!upperinode &&
 	    !special_file(realinode->i_mode) && mask & MAY_WRITE) {
@@ -305,7 +308,7 @@ int ovl_permission(struct user_namespace *mnt_userns,
 		/* Make sure mounter can read file for copy up later */
 		mask |= MAY_READ;
 	}
-	err = inode_permission(&init_user_ns, realinode, mask);
+	err = inode_permission(mnt_user_ns(realpath.mnt), realinode, mask);
 	revert_creds(old_cred);
 
 	return err;
-- 
2.32.0

