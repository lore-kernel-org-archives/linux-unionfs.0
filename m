Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60126C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Apr 2022 10:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354713AbiDDK4t (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 06:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358767AbiDDK4t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Apr 2022 06:56:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234B13D1C7
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 03:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7855B815A2
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 10:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A716DC34111;
        Mon,  4 Apr 2022 10:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069690;
        bh=BM19fRHzGbxaMIg8HLrnBTCsX8amjZdXx0VEnymDyHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZtq6JbwH9HFS/0HviYFiBnhQV+q5W2ZCc2HNN8pBJLgTTp6YFh73x1cj3rkFPWRz
         vozpFxJr56qVeVPJ0mbwtw9M4RwGY0aj98Ma5wVjWusCxEDoWcgFBT9nY57+2k50lO
         fmLfOv6P8o54ffqitEQwatbBAfdFCXv+y8YYcNc6wRfPmHntdZtKBrAmfxJOSSgUIA
         rdSFe3jXKiIP0I3sK484XKM3d3K8kdvEyPIYFUX2XsN5zPp1h7rrP3xB/LxidIyY8G
         18yegj0/PIQ5HRIkULOxLLTPjtv6j/nJSDAf9pBVuQHzuwKI3WnXtK1DJ6uhoi+NzH
         kWHrFWs5hD4PQ==
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
Subject: [PATCH v4 16/19] ovl: handle idmappings in ovl_permission()
Date:   Mon,  4 Apr 2022 12:51:55 +0200
Message-Id: <20220404105159.1567595-17-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220404105159.1567595-1-brauner@kernel.org>
References: <20220404105159.1567595-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1928; h=from:subject; bh=BM19fRHzGbxaMIg8HLrnBTCsX8amjZdXx0VEnymDyHQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR5nT3u4i2omh4kvH36puOrtNOPMLPd5VO4kTTXV05dpb3D fUtHRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES83BkZzmQnb/KaLqu4Z+XWsl0u3v FBoXPs+ufdffX5ELN1GWtpPSPD4qm/sp2vTvr/Yq3wvuYv+ftEzFd3W1rNWmU4qXU134NuVgA=
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

