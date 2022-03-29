Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BB6C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiC2KjL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiC2KjK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:39:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85867BF950
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A82D61261
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA515C340ED;
        Tue, 29 Mar 2022 10:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550246;
        bh=YiXBnyLzJ2Th273mzlVwjkKuV/cJj+/24xZGw0bznMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFrtz9wH+HoarVHkprwjgqJ1yDx2QSjN7rXMQBHduRKZORW2mmeMxGRPr01sDnC4l
         AZKziymeQuPYwsBH5xk9aoHTfZ/mxx6qHMXW6A9IvAyuXpHXzLIMJz7PJLtfGpJf03
         a3pRvqm2oJWnlOIxZtj9eaTbLW1X/koO7bG7LGddRhSPEKYfTDImSqNWRc3XtdG39D
         xhvp9p8cm6u49pz9qhC2r4SixtLILuC1z86s+04A94Nw348MKOagATmCDoaAxv2Efz
         kSzQ4faHdtqtsMP/8uVqzeIZhgPZRtQOrBOD7ygvGCNvCdS9N0Yd5V8bJI2XfZ5bXX
         bQ5pY02ITAapA==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
Subject: [PATCH 15/18] ovl: handle idmappings in ovl_permission()
Date:   Tue, 29 Mar 2022 12:35:22 +0200
Message-Id: <20220329103526.1207086-16-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1856; h=from:subject; bh=YiXBnyLzJ2Th273mzlVwjkKuV/cJj+/24xZGw0bznMc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5PTiwQjlnm9M6roNV8bN7q3OvGlSuXThl37zZLcxG+4Xl IpMZO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyWY6R4VO+ifSWub+OsCdOmh428e azQ69q/xmJ7bzI7bnr9muXR5yMDMcNa0Pjtl36vf/e93ezrwbsuW+peu2pKmv77nj+S5NT17EDAA==
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

