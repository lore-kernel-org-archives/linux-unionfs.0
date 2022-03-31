Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C32EC433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbiCaL0B (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbiCaL0A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:26:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D6AE01D
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26A956158C
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D40C340EE;
        Thu, 31 Mar 2022 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725851;
        bh=Q9KLf3qMPi6/YGdPK+p5VSGfdRGZUy38C5q8JRpBIJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vpvy4I/CjTF9veIBdUkJSLxZukNQYqdq5E6LJLP1JNBdTOg9N48/0IZwk/E21o/Xj
         RzWqo7FH48ks5i7v29SyfxJ0mouFzNej3XPzyDz496QgO4EBPwgVqxh2JFB8R7e86h
         33gcwvpyUMPtxt4NdJlLt97YGeA1cJzXxd8hzIUuyx3SoqnqDs6iII22zPxz0HxwMY
         8mNn9ceo8Y1+9vu+ZLABHw1VPbxLOXXBIJ5W/A6Ca1Zme/KATGW0H6f5tP4+WSTmlJ
         tGqe+bN8ZZO15f1o9mfLxJ8vX9G0kD+IL+cf2BG+AniNNMCR5tHlTjF4zbwIhCeYm+
         LK32Dv+MPfKOA==
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
Subject: [PATCH v3 07/19] ovl: pass ofs to setattr operations
Date:   Thu, 31 Mar 2022 13:23:05 +0200
Message-Id: <20220331112318.1377494-8-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4402; h=from:subject; bh=Q9KLf3qMPi6/YGdPK+p5VSGfdRGZUy38C5q8JRpBIJY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59kuyH5+dOqWIyau6etnH9+vft5etqVCSMLEXdYvr79pn eOdbRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQYVBkZ/hc+u9J+elm3SObMxZ/09r mdOPUruLE6U2Cm8PO7snscXjMyLNtz7fuZe8UJbQoPr/4Q706tuHna59dVjlNZ8f99RV5lMgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Pass down struct ovl_fs to setattr operations so we can ultimately
retrieve the relevant upper mount and take the mount's idmapping into
account when creating new filesystem objects. This is needed to support
idmapped base layers with overlay.

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
 fs/overlayfs/copy_up.c   | 19 +++++++++++--------
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 44605c51a382..2c336acb2ba0 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -293,7 +293,8 @@ static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
 	return error;
 }
 
-static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
+static int ovl_set_size(struct ovl_fs *ofs,
+			struct dentry *upperdentry, struct kstat *stat)
 {
 	struct iattr attr = {
 		.ia_valid = ATTR_SIZE,
@@ -303,7 +304,8 @@ static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
 	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
 }
 
-static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
+static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
+			      struct kstat *stat)
 {
 	struct iattr attr = {
 		.ia_valid =
@@ -315,7 +317,8 @@ static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
 	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
 }
 
-int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
+int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
+		 struct kstat *stat)
 {
 	int err = 0;
 
@@ -335,7 +338,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
 	}
 	if (!err)
-		ovl_set_timestamps(upperdentry, stat);
+		ovl_set_timestamps(ofs, upperdentry, stat);
 
 	return err;
 }
@@ -542,7 +545,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 
 		if (!err) {
 			/* Restore timestamps on parent (best effort) */
-			ovl_set_timestamps(upperdir, &c->pstat);
+			ovl_set_timestamps(ofs, upperdir, &c->pstat);
 			ovl_dentry_set_upper_alias(c->dentry);
 		}
 	}
@@ -616,9 +619,9 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 
 	inode_lock(temp->d_inode);
 	if (S_ISREG(c->stat.mode))
-		err = ovl_set_size(temp, &c->stat);
+		err = ovl_set_size(ofs, temp, &c->stat);
 	if (!err)
-		err = ovl_set_attr(temp, &c->stat);
+		err = ovl_set_attr(ofs, temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
 	return err;
@@ -840,7 +843,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 
 		/* Restore timestamps on parent (best effort) */
 		inode_lock(udir);
-		ovl_set_timestamps(c->destdir, &c->pstat);
+		ovl_set_timestamps(ofs, c->destdir, &c->pstat);
 		inode_unlock(udir);
 
 		ovl_dentry_set_upper_alias(c->dentry);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 8da72b1ebafc..27a40b6754f4 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -408,7 +408,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 		goto out_cleanup;
 
 	inode_lock(opaquedir->d_inode);
-	err = ovl_set_attr(opaquedir, &stat);
+	err = ovl_set_attr(ofs, opaquedir, &stat);
 	inode_unlock(opaquedir->d_inode);
 	if (err)
 		goto out_cleanup;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 27f79be097b1..b003652f8827 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -622,7 +622,7 @@ int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 		   struct dentry *new);
-int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 				  bool is_upper);
 int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
-- 
2.32.0

