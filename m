Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA5AC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244768AbiDGLZF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244766AbiDGLZE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:25:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E698D4D602
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FD6DB8269F
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE283C385A0;
        Thu,  7 Apr 2022 11:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330582;
        bh=D+HEvKemKBHDYLFAxSLs/OmsbKoi7CcI1fj6CQuwfvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ljs836AHJhaUg29xPeEfcf4KiKeZJJ7R/HmT5yquZy4+TS1Lp4cb7+B3revz1oMe4
         UwRm4BefITMUYXqxveiNI0J5k8hFSduyS/m8MFNU2+KJrL5oqtqzNJRkr7p1McsVkW
         PGkXIXb2NhyRdU5gV+WALOM+v6WYf7kJ6igJQfIar6aaKIKu1chEUN82AdDRYjnpIw
         5DS+kZM6qvBnpjGtkWJ3V3DPGgsO45RFRsjzdyvvGQ9DfggT934HHtt7kshrT3h9+2
         8PQAUmhwWfdHxRrhh2RP/PXQFsOspWB9deu+I41QuLobhsOQ8+FQMYewPDzSxKi/XV
         QfqnWyP9qx33Q==
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
Subject: [PATCH v5 10/19] ovl: use ovl_lookup_upper() wrapper
Date:   Thu,  7 Apr 2022 13:21:47 +0200
Message-Id: <20220407112157.1775081-11-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9755; h=from:subject; bh=D+HEvKemKBHDYLFAxSLs/OmsbKoi7CcI1fj6CQuwfvg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfSW/pQVorYo79rxmVvENrdecJyS4T9pnVvyQ+mmyiLv oGUqHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP58paRYYpNA4tSUNxLT66Q/oc/qz gEc5VivWu2tqa+PiPgFHyKjeGf4jvPXZWhuctUeMp03j/bHaMjdv+a8Ym2OdGC8rzLjv7gBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Introduce ovl_lookup_upper() as a simple wrapper around lookup_one().
Make it clear in the helper's name that this only operates on the upper
layer. The wrapper will take upper layer's idmapping into account when
checking permission in lookup_one().

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

/* v5 */
unchanged
---
 fs/overlayfs/copy_up.c   | 12 +++++++-----
 fs/overlayfs/dir.c       | 31 +++++++++++++++----------------
 fs/overlayfs/overlayfs.h |  8 ++++++++
 fs/overlayfs/readdir.c   |  6 +++---
 fs/overlayfs/super.c     |  6 +++---
 fs/overlayfs/util.c      |  2 +-
 6 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a5d68302693f..19b5f75d1fe2 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -487,7 +487,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (err)
 		goto out;
 
-	index = lookup_one_len(name.name, indexdir, name.len);
+	index = ovl_lookup_upper(ofs, name.name, indexdir, name.len);
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
 	} else {
@@ -536,8 +536,8 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 		return err;
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
-	upper = lookup_one_len(c->dentry->d_name.name, upperdir,
-			       c->dentry->d_name.len);
+	upper = ovl_lookup_upper(ofs, c->dentry->d_name.name, upperdir,
+				 c->dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
 		err = ovl_do_link(ofs, ovl_dentry_upper(c->dentry), udir, upper);
@@ -700,7 +700,8 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 			goto cleanup;
 	}
 
-	upper = lookup_one_len(c->destname.name, c->destdir, c->destname.len);
+	upper = ovl_lookup_upper(ofs, c->destname.name, c->destdir,
+				 c->destname.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto cleanup;
@@ -752,7 +753,8 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 
-	upper = lookup_one_len(c->destname.name, c->destdir, c->destname.len);
+	upper = ovl_lookup_upper(ofs, c->destname.name, c->destdir,
+				 c->destname.len);
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
 		err = ovl_do_link(ofs, temp, udir, upper);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 439b727885fe..bb05604f998c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -51,7 +51,7 @@ struct dentry *ovl_lookup_temp(struct ovl_fs *ofs, struct dentry *workdir)
 	/* counter is allowed to wrap, since temp dentries are ephemeral */
 	snprintf(name, sizeof(name), "#%x", atomic_inc_return(&temp_id));
 
-	temp = lookup_one_len(name, workdir, strlen(name));
+	temp = ovl_lookup_upper(ofs, name, workdir, strlen(name));
 	if (!IS_ERR(temp) && temp->d_inode) {
 		pr_err("workdir/%s already exists\n", name);
 		dput(temp);
@@ -155,8 +155,8 @@ int ovl_mkdir_real(struct ovl_fs *ofs, struct inode *dir,
 	 * to it unhashed and negative. If that happens, try to
 	 * lookup a new hashed and positive dentry.
 	 */
-	d = lookup_one_len(dentry->d_name.name, dentry->d_parent,
-			   dentry->d_name.len);
+	d = ovl_lookup_upper(ofs, dentry->d_name.name, dentry->d_parent,
+			     dentry->d_name.len);
 	if (IS_ERR(d)) {
 		pr_warn("failed lookup after mkdir (%pd2, err=%i).\n",
 			dentry, err);
@@ -333,9 +333,8 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 	newdentry = ovl_create_real(ofs, udir,
-				    lookup_one_len(dentry->d_name.name,
-						   upperdir,
-						   dentry->d_name.len),
+				    ovl_lookup_upper(ofs, dentry->d_name.name,
+						     upperdir, dentry->d_name.len),
 				    attr);
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
@@ -489,8 +488,8 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (err)
 		goto out;
 
-	upper = lookup_one_len(dentry->d_name.name, upperdir,
-			       dentry->d_name.len);
+	upper = ovl_lookup_upper(ofs, dentry->d_name.name, upperdir,
+				 dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto out_unlock;
@@ -772,8 +771,8 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 	if (err)
 		goto out_dput;
 
-	upper = lookup_one_len(dentry->d_name.name, upperdir,
-			       dentry->d_name.len);
+	upper = ovl_lookup_upper(ofs, dentry->d_name.name, upperdir,
+				 dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto out_unlock;
@@ -820,8 +819,8 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir,
 	}
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
-	upper = lookup_one_len(dentry->d_name.name, upperdir,
-			       dentry->d_name.len);
+	upper = ovl_lookup_upper(ofs, dentry->d_name.name, upperdir,
+				 dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto out_unlock;
@@ -1196,8 +1195,8 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
 
 	trap = lock_rename(new_upperdir, old_upperdir);
 
-	olddentry = lookup_one_len(old->d_name.name, old_upperdir,
-				   old->d_name.len);
+	olddentry = ovl_lookup_upper(ofs, old->d_name.name, old_upperdir,
+				     old->d_name.len);
 	err = PTR_ERR(olddentry);
 	if (IS_ERR(olddentry))
 		goto out_unlock;
@@ -1206,8 +1205,8 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
 	if (!ovl_matches_upper(old, olddentry))
 		goto out_dput_old;
 
-	newdentry = lookup_one_len(new->d_name.name, new_upperdir,
-				   new->d_name.len);
+	newdentry = ovl_lookup_upper(ofs, new->d_name.name, new_upperdir,
+				     new->d_name.len);
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_dput_old;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 139f76640ae7..261fc08de1db 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/uuid.h>
 #include <linux/fs.h>
+#include <linux/namei.h>
 #include "ovl_entry.h"
 
 #undef pr_fmt
@@ -309,6 +310,13 @@ static inline struct dentry *ovl_do_tmpfile(struct ovl_fs *ofs,
 	return ret;
 }
 
+static inline struct dentry *ovl_lookup_upper(struct ovl_fs *ofs,
+					      const char *name,
+					      struct dentry *base, int len)
+{
+	return lookup_one(ovl_upper_mnt_userns(ofs), name, base, len);
+}
+
 static inline bool ovl_open_flags_need_copy_up(int flags)
 {
 	if (!flags)
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 9c580ef8cd6f..1d06222a496c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1013,7 +1013,7 @@ void ovl_cleanup_whiteouts(struct ovl_fs *ofs, struct dentry *upper,
 		if (WARN_ON(!p->is_whiteout || !p->is_upper))
 			continue;
 
-		dentry = lookup_one_len(p->name, upper, p->len);
+		dentry = ovl_lookup_upper(ofs, p->name, upper, p->len);
 		if (IS_ERR(dentry)) {
 			pr_err("lookup '%s/%.*s' failed (%i)\n",
 			       upper->d_name.name, p->len, p->name,
@@ -1113,7 +1113,7 @@ static int ovl_workdir_cleanup_recurse(struct ovl_fs *ofs, struct path *path,
 			err = -EINVAL;
 			break;
 		}
-		dentry = lookup_one_len(p->name, path->dentry, p->len);
+		dentry = ovl_lookup_upper(ofs, p->name, path->dentry, p->len);
 		if (IS_ERR(dentry))
 			continue;
 		if (dentry->d_inode)
@@ -1181,7 +1181,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 			if (p->len == 2 && p->name[1] == '.')
 				continue;
 		}
-		index = lookup_one_len(p->name, indexdir, p->len);
+		index = ovl_lookup_upper(ofs, p->name, indexdir, p->len);
 		if (IS_ERR(index)) {
 			err = PTR_ERR(index);
 			index = NULL;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 432ef060d2ab..2fd2d3e5eaba 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -761,7 +761,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 retry:
-	work = lookup_one_len(name, ofs->workbasedir, strlen(name));
+	work = ovl_lookup_upper(ofs, name, ofs->workbasedir, strlen(name));
 
 	if (!IS_ERR(work)) {
 		struct iattr attr = {
@@ -1289,7 +1289,7 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 		goto cleanup_temp;
 	}
 
-	whiteout = lookup_one_len(name.name.name, workdir, name.name.len);
+	whiteout = ovl_lookup_upper(ofs, name.name.name, workdir, name.name.len);
 	err = PTR_ERR(whiteout);
 	if (IS_ERR(whiteout))
 		goto cleanup_temp;
@@ -1321,7 +1321,7 @@ static struct dentry *ovl_lookup_or_create(struct ovl_fs *ofs,
 	struct dentry *child;
 
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
-	child = lookup_one_len(name, parent, len);
+	child = ovl_lookup_upper(ofs, name, parent, len);
 	if (!IS_ERR(child) && !child->d_inode)
 		child = ovl_create_real(ofs, parent->d_inode, child,
 					OVL_CATTR(mode));
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 42293610f64e..79e5a22a3c7c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -838,7 +838,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	}
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
-	index = lookup_one_len(name.name, indexdir, name.len);
+	index = ovl_lookup_upper(ofs, name.name, indexdir, name.len);
 	err = PTR_ERR(index);
 	if (IS_ERR(index)) {
 		index = NULL;
-- 
2.32.0

