Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4D1C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiDGLY7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244766AbiDGLY6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:24:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422A232985
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFE6A61E55
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A226BC385A4;
        Thu,  7 Apr 2022 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330578;
        bh=g3sWMbJBgudfnUwwxgWAahq2w78t3DCRRJ8vV+vmriw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+gjTP8UYJclain8OB+DfenHY/0S9WFoIOJ4siKiVQ2vGJRMs5Y6rZBEWk03Uj2d4
         nv+eJ1Vad/GzA6na6zObsRlZmlS8rA6gtVEYVQUO3fhTl6vwDSuB5B+i1cc6fdPvLV
         /8WVJNGrfKNzpKg8LScEY2d2cGIV70iyRRa4FcYAOXelX617JaTl31Q+WyzHr+LCHF
         JQoG3kF9e3uIrFhUoCcrIkbk66WZh5Q6aU75XWDYUhZJrNJ+Tx1OrVfucEfzA9Pf5v
         itHw7cCVRgLB1jD08HqePO04a3cG9HmAQ3UvWIhd4QkVYNfLQmZhHFXHlOd9gD0BUS
         JDcK8brp22soA==
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
Subject: [PATCH v5 09/19] ovl: use ovl_do_notify_change() wrapper
Date:   Thu,  7 Apr 2022 13:21:46 +0200
Message-Id: <20220407112157.1775081-10-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6679; h=from:subject; bh=g3sWMbJBgudfnUwwxgWAahq2w78t3DCRRJ8vV+vmriw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfSedm574dvaq780i7iWHV69ede1intGDw/GGhv6p6Zk N1XO7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI4+MM/0ts5y780Hq15oFs8bxjot 1vuF1bsnvfyxvEzziSHzOf9z7DH16/1PQ/0i5hfl+dj7xP83i3pEo+eqXMx45thTe4nlT7sAMA
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

/* v5 */
unchanged
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
index e2b3502f6b12..439b727885fe 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -515,7 +515,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
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

