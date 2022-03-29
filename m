Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC89BC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiC2KjR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiC2KjP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:39:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36970BF950
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEF5CB81707
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8998C340ED;
        Tue, 29 Mar 2022 10:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550250;
        bh=sPVaaZpUofWFC8BkZLB7dYzS1+hzaKSXGp2M2Lfp+iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8vpoefSCDk7CqPBFifLMQ0gOMW5gixapLx/nDWuQ8YgoTSxyXbdag+UbLYxCyLnG
         1WAzUDl+FHPogQ1rUsMu1GjRoBW6dHeQwmCaABfdHbkmzp4t4cR+F7xLMhcFVvPO0o
         5RYA1xWO31fFyPkmLksE7jjghCp7Hf1F3U7PsGuGVMw6GAg0FJj8Z1nBVNL2Co5btA
         nDXrdpRUS2NWE5xT5uYGiCIHyUY8RFUaodXK1u80RY0NS2yylyP+QFVHqgeyVbPw9b
         FXIDBVakoLdkma3QoR4koB9qblA+GSEoZn6C6F60SwMTsoOYnCnSsDa+2yGd2X9LJu
         HNfjuXL3rbI5Q==
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
Subject: [PATCH 16/18] ovl: handle idmappings in layer open helpers
Date:   Tue, 29 Mar 2022 12:35:23 +0200
Message-Id: <20220329103526.1207086-17-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2732; h=from:subject; bh=sPVaaZpUofWFC8BkZLB7dYzS1+hzaKSXGp2M2Lfp+iE=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5PTggGdwonyN7peT2mtZncur1/vwP71x9eysv5CC7jZdI +2/zjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl83MLwz6KDe/rGpd7OX0UyvDvO39 1ufjfx/oYk/qs2Dbsezf2dMoHhvyPjFt9b9gXVsjde3ThY+eokY8MCu3mWV2TPWhqZzGJz4AMA
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
 fs/overlayfs/file.c | 7 +++++--
 fs/overlayfs/util.c | 5 +++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 656c30bf20a6..7dd44f4e2757 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -42,6 +42,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 {
 	struct inode *realinode = d_inode(realpath->dentry);
 	struct inode *inode = file_inode(file);
+	struct user_namespace *real_idmap;
 	struct file *realfile;
 	const struct cred *old_cred;
 	int flags = file->f_flags | OVL_OPEN_FLAGS;
@@ -51,12 +52,14 @@ static struct file *ovl_open_realfile(const struct file *file,
 	if (flags & O_APPEND)
 		acc_mode |= MAY_APPEND;
 
+
 	old_cred = ovl_override_creds(inode->i_sb);
-	err = inode_permission(&init_user_ns, realinode, MAY_OPEN | acc_mode);
+	real_idmap = mnt_user_ns(realpath->mnt);
+	err = inode_permission(real_idmap, realinode, MAY_OPEN | acc_mode);
 	if (err) {
 		realfile = ERR_PTR(err);
 	} else {
-		if (!inode_owner_or_capable(&init_user_ns, realinode))
+		if (!inode_owner_or_capable(real_idmap, realinode))
 			flags &= ~O_NOATIME;
 
 		realfile = open_with_fake_path(&file->f_path, flags, realinode,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 79fae06ee10a..7dd2e5e6662a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -523,6 +523,7 @@ bool ovl_is_whiteout(struct dentry *dentry)
 struct file *ovl_path_open(struct path *path, int flags)
 {
 	struct inode *inode = d_inode(path->dentry);
+	struct user_namespace *real_idmap = mnt_user_ns(path->mnt);
 	int err, acc_mode;
 
 	if (flags & ~(O_ACCMODE | O_LARGEFILE))
@@ -539,12 +540,12 @@ struct file *ovl_path_open(struct path *path, int flags)
 		BUG();
 	}
 
-	err = inode_permission(&init_user_ns, inode, acc_mode | MAY_OPEN);
+	err = inode_permission(real_idmap, inode, acc_mode | MAY_OPEN);
 	if (err)
 		return ERR_PTR(err);
 
 	/* O_NOATIME is an optimization, don't fail if not permitted */
-	if (inode_owner_or_capable(&init_user_ns, inode))
+	if (inode_owner_or_capable(real_idmap, inode))
 		flags |= O_NOATIME;
 
 	return dentry_open(path, flags, current_cred());
-- 
2.32.0

