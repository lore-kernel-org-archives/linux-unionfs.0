Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E6CC433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 10:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245351AbiC3K2D (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242937AbiC3K2D (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 06:28:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C125E25FD6D
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 03:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E2C16147F
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 10:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D34C340EC;
        Wed, 30 Mar 2022 10:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635977;
        bh=G6naFoPtdXpR2WKC80xSIzVxFbOl197lstuUWxX8bKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk89VKTIzcV8+1VHYA6G0/jBN76+YIhgdQu8b/J65VREYWFTtAqMgzrAAc96wzcp8
         Z2iyEgR+zbrjUTOYbL8tHLxmhGibZtH8iTlUG7jtUsJkgBOOk8nmGwm46LOpTnPUOZ
         D5FadVmFfHNdi+v0F2GmLOh0Gh96bcyf5ZaOD1Ivt7x3t5Xb68ENEr5bq+vgg0e6sx
         T77Gmh9OS8ammALIh+MQ4Vw7WmrVJgOka8H2+W23e9zrDKijrcj8Mcsyq0GoIzPmgC
         g/tYdOGCrmwlhejjQckOPN26tUmYfWPptb+IM9n9184QfLT6J/eRbaM511WyRyFv/4
         lVRBwBqvCCMKA==
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
Subject: [PATCH v2 16/19] ovl: handle idmappings in ovl_permission()
Date:   Wed, 30 Mar 2022 12:24:04 +0200
Message-Id: <20220330102409.1290850-17-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1882; h=from:subject; bh=G6naFoPtdXpR2WKC80xSIzVxFbOl197lstuUWxX8bKM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56B9YemPaF5mXdgGPjvjYHn7x/8fjNYpPii/pMUwVWb2y cdbi0o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJMHxmZOgqbGtZd3KF9wTGBC7pgp 4HJhd/ffjVt7BeuGS63d2YfcmMDE9nnAmq+Twl+sDvA6Jh23wF+FiOiO5qNs64MdtdV9JtIhcA
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

