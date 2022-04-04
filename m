Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4668BC433FE
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Apr 2022 10:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355031AbiDDK4x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 06:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358795AbiDDK4w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Apr 2022 06:56:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7ADA35DC8
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 03:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52A5460ADB
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 10:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC39C340F3;
        Mon,  4 Apr 2022 10:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069695;
        bh=3tNbwI5IsoqrkTgo2z/8sPZkcNaRTy6oTlR47MXlroQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiNh9yEizMBIOF0kOrAO5hVTvBkPgyg4xPOX26YeRhxnCAa52B/07HzHNzD0khkQH
         2V5p0lvr6uaEkbC/EJV62nbGla82jpTO6Cq77dNpFw31+LBSKPjsf+o40MvTC96DbP
         pX1cF5woJhimxfcIXxXDNVjVx6wClzRmoid5Orm2vBQn6FXIwluKMyuNhfCjejJNi+
         1HbEIjhcCEPToZNsZW4mobkfhekM/S+JONEjk4bVNxQ7hQEo6GDxuGeiC7xovTJtE5
         TJsocktSBTPXlODwE1IGyoBftC5EBzWnC3BHJ7cEzItmBpSOo+m6eFuswmKI+H/bOd
         n9YjhOM+mUeQA==
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
Subject: [PATCH v4 17/19] ovl: handle idmappings in layer open helpers
Date:   Mon,  4 Apr 2022 12:51:56 +0200
Message-Id: <20220404105159.1567595-18-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220404105159.1567595-1-brauner@kernel.org>
References: <20220404105159.1567595-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2891; h=from:subject; bh=3tNbwI5IsoqrkTgo2z/8sPZkcNaRTy6oTlR47MXlroQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR5nT0ekfJl9aotpfKf1+Yon06LeN6l5N02+8SKL6WHDmmp Tq7W7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI/w1GhglvHJ6u1qrXCNsydet9U8 lkdZdJtg+WLngbxDoj4sLWuH0M/5OkbcxnLe8pX/Dw1l3W21Uhafsv/lHqdP3Ids6oO7N6PRMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In earlier patches we already passed down the relevant upper or lower
path to ovl_open_realfile(). Now let the open helpers actually take the
idmapping of the relevant mount into account when checking permissions.
This is needed to support idmapped base layers with overlay.

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
- Vivek Goyal <vgoyal@redhat.com>:
  - rename some variables
---
 fs/overlayfs/file.c | 7 +++++--
 fs/overlayfs/util.c | 5 +++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 656c30bf20a6..c70be734cc84 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -42,6 +42,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 {
 	struct inode *realinode = d_inode(realpath->dentry);
 	struct inode *inode = file_inode(file);
+	struct user_namespace *real_mnt_userns;
 	struct file *realfile;
 	const struct cred *old_cred;
 	int flags = file->f_flags | OVL_OPEN_FLAGS;
@@ -51,12 +52,14 @@ static struct file *ovl_open_realfile(const struct file *file,
 	if (flags & O_APPEND)
 		acc_mode |= MAY_APPEND;
 
+
 	old_cred = ovl_override_creds(inode->i_sb);
-	err = inode_permission(&init_user_ns, realinode, MAY_OPEN | acc_mode);
+	real_mnt_userns = mnt_user_ns(realpath->mnt);
+	err = inode_permission(real_mnt_userns, realinode, MAY_OPEN | acc_mode);
 	if (err) {
 		realfile = ERR_PTR(err);
 	} else {
-		if (!inode_owner_or_capable(&init_user_ns, realinode))
+		if (!inode_owner_or_capable(real_mnt_userns, realinode))
 			flags &= ~O_NOATIME;
 
 		realfile = open_with_fake_path(&file->f_path, flags, realinode,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 90182d9d7735..fc97d5a8443b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -523,6 +523,7 @@ bool ovl_is_whiteout(struct dentry *dentry)
 struct file *ovl_path_open(struct path *path, int flags)
 {
 	struct inode *inode = d_inode(path->dentry);
+	struct user_namespace *real_mnt_userns = mnt_user_ns(path->mnt);
 	int err, acc_mode;
 
 	if (flags & ~(O_ACCMODE | O_LARGEFILE))
@@ -539,12 +540,12 @@ struct file *ovl_path_open(struct path *path, int flags)
 		BUG();
 	}
 
-	err = inode_permission(&init_user_ns, inode, acc_mode | MAY_OPEN);
+	err = inode_permission(real_mnt_userns, inode, acc_mode | MAY_OPEN);
 	if (err)
 		return ERR_PTR(err);
 
 	/* O_NOATIME is an optimization, don't fail if not permitted */
-	if (inode_owner_or_capable(&init_user_ns, inode))
+	if (inode_owner_or_capable(real_mnt_userns, inode))
 		flags |= O_NOATIME;
 
 	return dentry_open(path, flags, current_cred());
-- 
2.32.0

