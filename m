Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B973FC433F5
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Apr 2022 10:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358537AbiDDK4H (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 06:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357558AbiDDK4H (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Apr 2022 06:56:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA63BE35
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 03:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCEAF60AE5
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 10:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909BDC2BBE4;
        Mon,  4 Apr 2022 10:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069650;
        bh=nkGkJlZO8uMgszpU/ZQrHftsxGm+Dy0V8JJk6NQcJ2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEm33DjfVlLl+DuJ7z8zVO6/Uh/PO+D5dcxestljGab975zms56YbP1YlKM61arqA
         TTxW0Ai7V1reIJTkxzuqiJpOEje2iUugNNFiTB+KrrFtPzWGWxgiXvLwrZIT1CfHUQ
         KnUzdVYfLa6gB2ZycG7BUgI2xsXs461P2SppwxXF8gFa7BKqhI7zNjdfOTxNcsKPLX
         KL37XVf+1VR80LlMHxQjNctergReMkwlTwwdYwZXtIou4u/y0+qEC9itRCsrwtsyOs
         S4MHSEittBnuJewGscq316KwCjFtglKXI8EuqZXWBYNN0z0jrWYJ0lt/ABt8KZKcBa
         5Ysfjn7uYdx6g==
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
Subject: [PATCH v4 09/19] ovl: use ovl_do_notify_change() wrapper
Date:   Mon,  4 Apr 2022 12:51:48 +0200
Message-Id: <20220404105159.1567595-10-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220404105159.1567595-1-brauner@kernel.org>
References: <20220404105159.1567595-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6656; h=from:subject; bh=nkGkJlZO8uMgszpU/ZQrHftsxGm+Dy0V8JJk6NQcJ2c=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR5nT3SXdWgcvzwro/Sc+Omdgo72dzr52n2nuHOVdGxp1/E XPRZRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETe9jL8U4xjMFrwyW+SrWCYkJJs/m LD/exXTrLqqThuey6xL1TXj5HhXKnLUq+qW46vzhvxrS/csqSx947aq6SP4qzLn1906+dlAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Introduce ovl_do_notify_change() as a simple wrapper around
notify_change() to support idmapped layers. The helper mirrors other
ovl_do_*() helpers that operate on the upper layers.

When changing ownership of an upper object the intended ownership needs
to be mapped according to the upper layer's idmapping. This mapping is
the inverse to the mapping applied when copying inode information from
an upper layer to the corresponding overlay inode. So e.g., when an
upper mount maps files that are stored on-disk as owned by id 1001 to
1000 this means that calling stat on this object from an idmapped mount
will report the file as being owned by id 1000. Consequently in order to
change ownership of an object in this filesystem so it appears as being
owned by id 1000 in the upper idmapped layer it needs to store id 1001
on disk. The mnt mapping helpers take care of this.

All idmapping helpers are nops when no idmapped base layers are used.

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
  - s/ovl_upper_idmap()/ovl_upper_mnt_userns()/g
    and other variable renamings
---
 fs/overlayfs/copy_up.c   |  8 ++++----
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/inode.c     |  3 ++-
 fs/overlayfs/overlayfs.h | 29 +++++++++++++++++++++++++++++
 fs/overlayfs/super.c     |  2 +-
 5 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2c336acb2ba0..a5d68302693f 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -301,7 +301,7 @@ static int ovl_set_size(struct ovl_fs *ofs,
 		.ia_size = stat->size,
 	};
 
-	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
+	return ovl_do_notify_change(ofs, upperdentry, &attr);
 }
 
 static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -314,7 +314,7 @@ static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
 		.ia_mtime = stat->mtime,
 	};
 
-	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
+	return ovl_do_notify_change(ofs, upperdentry, &attr);
 }
 
 int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -327,7 +327,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
 			.ia_valid = ATTR_MODE,
 			.ia_mode = stat->mode,
 		};
-		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
+		err = ovl_do_notify_change(ofs, upperdentry, &attr);
 	}
 	if (!err) {
 		struct iattr attr = {
@@ -335,7 +335,7 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
 			.ia_uid = stat->uid,
 			.ia_gid = stat->gid,
 		};
-		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
+		err = ovl_do_notify_change(ofs, upperdentry, &attr);
 	}
 	if (!err)
 		ovl_set_timestamps(ofs, upperdentry, stat);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 27a40b6754f4..9ae0352ff52a 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -516,7 +516,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 			.ia_mode = cattr->mode,
 		};
 		inode_lock(newdentry->d_inode);
-		err = notify_change(&init_user_ns, newdentry, &attr, NULL);
+		err = ovl_do_notify_change(ofs, newdentry, &attr);
 		inode_unlock(newdentry->d_inode);
 		if (err)
 			goto out_cleanup;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index c51a9dd36cc7..9a8e6b94d9e8 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -21,6 +21,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		struct iattr *attr)
 {
 	int err;
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	bool full_copy_up = false;
 	struct dentry *upperdentry;
 	const struct cred *old_cred;
@@ -77,7 +78,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 
 		inode_lock(upperdentry->d_inode);
 		old_cred = ovl_override_creds(dentry->d_sb);
-		err = notify_change(&init_user_ns, upperdentry, attr, NULL);
+		err = ovl_do_notify_change(ofs, upperdentry, attr);
 		revert_creds(old_cred);
 		if (!err)
 			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 716e31ace058..139f76640ae7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -122,6 +122,35 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
 	return ovl_xattr_table[ox][ofs->config.userxattr];
 }
 
+/*
+ * When changing ownership of an upper object map the intended ownership
+ * according to the upper layer's idmapping. When an upper mount idmaps files
+ * that are stored on-disk as owned by id 1001 to id 1000 this means stat on
+ * this object will report it as being owned by id 1000 when calling stat via
+ * the upper mount.
+ * In order to change ownership of an object so stat reports id 1000 when
+ * called on an idmapped upper mount the value written to disk - i.e., the
+ * value stored in ia_*id - must 1001. The mount mapping helper will thus take
+ * care to map 1000 to 1001.
+ * The mnt idmapping helpers are nops if the upper layer isn't idmapped.
+ */
+static inline int ovl_do_notify_change(struct ovl_fs *ofs,
+				       struct dentry *upperdentry,
+				       struct iattr *attr)
+{
+	struct user_namespace *upper_mnt_userns = ovl_upper_mnt_userns(ofs);
+	struct user_namespace *fs_userns = i_user_ns(d_inode(upperdentry));
+
+	if (attr->ia_valid & ATTR_UID)
+		attr->ia_uid = mapped_kuid_user(upper_mnt_userns,
+						fs_userns, attr->ia_uid);
+	if (attr->ia_valid & ATTR_GID)
+		attr->ia_gid = mapped_kgid_user(upper_mnt_userns,
+						fs_userns, attr->ia_gid);
+
+	return notify_change(upper_mnt_userns, upperdentry, attr, NULL);
+}
+
 static inline int ovl_do_rmdir(struct ovl_fs *ofs,
 			       struct inode *dir, struct dentry *dentry)
 {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 307a36af7b4f..432ef060d2ab 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -821,7 +821,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 
 		/* Clear any inherited mode bits */
 		inode_lock(work->d_inode);
-		err = notify_change(&init_user_ns, work, &attr, NULL);
+		err = ovl_do_notify_change(ofs, work, &attr);
 		inode_unlock(work->d_inode);
 		if (err)
 			goto out_dput;
-- 
2.32.0

