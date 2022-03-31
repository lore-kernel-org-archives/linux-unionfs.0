Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B551EC433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiCaL0L (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbiCaL0K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:26:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315906257
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:24:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F68614ED
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FDBC340EE;
        Thu, 31 Mar 2022 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725862;
        bh=mLScqkgo58TWkua1/LdPLgSxN8Jz5NZ5m1BQQz4XrY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iwsNc2lOM/5Wljyj5TFzkP4Zk+9SJM0Gs5we99jxkxPz9v0KmR9/qqp6sO0JmbzAz
         y5zUWai1IqOKhf1z898iApatbuOBChpro9richd7Cb98Vc6L87KMj4VpQvDaDcFIjj
         tAPPow4wmU3mG8YQwkG1Pt7pxRyQ7WceIHTVljxAPVvtBvnFfAMNC8gmF3H6cEL3GT
         kZ9csRqAbC6slRFztGrRwQX7ElrKKPi0gWn5AYbE+xnK5/3BZhFK/AvjXehFsi1pcT
         vLKiIsfJ8unjBCBO5PbHVIov59/M/wQrgZ9eCTjlrX40zgf7WBC73q1Y7CXnT0k6m/
         PfC/tlt/mRRlg==
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
Subject: [PATCH v3 09/19] ovl: use ovl_do_notify_change() wrapper
Date:   Thu, 31 Mar 2022 13:23:07 +0200
Message-Id: <20220331112318.1377494-10-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6478; h=from:subject; bh=mLScqkgo58TWkua1/LdPLgSxN8Jz5NZ5m1BQQz4XrY8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59kvmakkXcG82az757V+NoM3/no7o0jqzA1uOL3DN878y a41TRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQermZk6Jx6sbbfe2r/pegOOYHOF+ Ji38PdvK35O+ZKBPq3i6zNYGSYmBk29+SJG92shg9r31z9WfNYePWCjlk/N+5dq+jmPK2DEQA=
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
---
 fs/overlayfs/copy_up.c   |  8 ++++----
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/inode.c     |  3 ++-
 fs/overlayfs/overlayfs.h | 27 +++++++++++++++++++++++++++
 fs/overlayfs/super.c     |  2 +-
 5 files changed, 35 insertions(+), 7 deletions(-)

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
index 816a69b46b67..c1f4ff0553b5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -122,6 +122,33 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
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
+	struct user_namespace *upper_idmap = ovl_upper_idmap(ofs);
+	struct user_namespace *fs_idmap = i_user_ns(d_inode(upperdentry));
+
+	if (attr->ia_valid & ATTR_UID)
+		attr->ia_uid = mapped_kuid_user(upper_idmap, fs_idmap, attr->ia_uid);
+	if (attr->ia_valid & ATTR_GID)
+		attr->ia_gid = mapped_kgid_user(upper_idmap, fs_idmap, attr->ia_gid);
+
+	return notify_change(upper_idmap, upperdentry, attr, NULL);
+}
+
 static inline int ovl_do_rmdir(struct ovl_fs *ofs,
 			       struct inode *dir, struct dentry *dentry)
 {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f1deb84aebcf..2cc27e707cb3 100644
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

