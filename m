Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB3BC433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiCaL0m (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbiCaL0l (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:26:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724026257
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:24:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27F66B820C9
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B3FC340EE;
        Thu, 31 Mar 2022 11:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725891;
        bh=G07FJvjnjTNr7ApumxIR53ka35SNoIu/FGNqyAL/ge8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wtsiz05Ue5yTbpssLQcAvuzfwKNEDl8zVHPMALhMKTMmXev7x7vSNmOfDSKGzYORo
         xvXA0RefcGon1PBkFEr7xMI/yOBCOBPUdPpRIbhwHiaSGIsu/kVsM3GqgReInb8wVm
         E/KtPYLu0QYhCCCgj8rLJV7utKnJkMO9iUiC1OjTE5GgyVUmEZjqK5ZfTcqUiLMB9J
         el37s2okDFCgHsN6Prt8nTKb4v75aoN5ClXuqZhqkm6oaocARsSdyCQiwvEFNr49mW
         OBMa1zimA8oGRHGzt2JwUXrmbPxuxEr72Dp2CNF46chW1aHwhts0HeFWCBnsezfDuJ
         jsCWcRaMrZOEg==
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
Subject: [PATCH v3 16/19] ovl: handle idmappings in ovl_permission()
Date:   Thu, 31 Mar 2022 13:23:14 +0200
Message-Id: <20220331112318.1377494-17-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1905; h=from:subject; bh=G07FJvjnjTNr7ApumxIR53ka35SNoIu/FGNqyAL/ge8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59sv8v3U3tvZ/9ExZfp7rlWzr/818fbTVXGKnUeIcr0TW 6rx/HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMRO8Hw3z9g5uwv3S/XvsvpNX24sv fr8cw7z47WJ6a5Mbz7vOR0ug/D//TlRxW5Z22YE5q98zz7ts6HwfnPI9p6M3U2HPzy9e31abwA
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

