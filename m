Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DA9C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Jul 2022 09:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbiGHJCO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237695AbiGHJCN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Jul 2022 05:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F228C3337B
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Jul 2022 02:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96C00626DD
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Jul 2022 09:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C39C341C0;
        Fri,  8 Jul 2022 09:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657270932;
        bh=9TrAsfg8Wj4bBBZ9cChY3nhAvDHBUTqO7GTArRE4pss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmwn4SLUQWSPKkGfY8ZgRoBhbc2ALj1qsHqGLT+uA61s6Ni8GYWa1mNviWTCPKAWs
         ifrhVGW0fH2G5G6tcdMk4w8kWYvAIsxTHUGL1lKlF9yQkoeEBBvImLRFbqPmO5utNX
         Km/F66dKbl7C/Co2E2pcuRK2HkP9Gh+0iFeFV5ovdgZ+/jiMqTt3fI30wHqoFu4K2F
         zgFQm1cffUjfFc/ZuRwJU6sZH6RtCxGI8wcKkN2xkszqfRuE4a74yia0IfYhovkXIr
         BJ+V54WB0n5G2hR4ppviiLQ1clg2gebwTxZevwYq8hlS2GdKcOkBHkTbkjd9iDx4Ik
         3Y3JN0+XrqqPA==
From:   Christian Brauner <brauner@kernel.org>
To:     Seth Forshee <sforshee@digitalocean.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 3/3] ovl: handle idmappings in ovl_get_acl()
Date:   Fri,  8 Jul 2022 11:01:34 +0200
Message-Id: <20220708090134.385160-4-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220708090134.385160-1-brauner@kernel.org>
References: <20220708090134.385160-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4724; h=from:subject; bh=9TrAsfg8Wj4bBBZ9cChY3nhAvDHBUTqO7GTArRE4pss=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQd/8Slk67IaB/akBXywGp3wfKXZRnrVFccXuH8mWlO2ZKZ Cyv/d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykIpDhf/3sHSxc89U7DqzW6zuwh8 9spYawzpOrzUf+3/h1SP5z8TFGhmX7T3k6zijm/7PlSPDu17ZhoVdWnHMs5/effvdVn4tDHysA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

During permission checking overlayfs will call

ovl_permission()
-> generic_permission()
   -> acl_permission_check()
      -> check_acl()
         -> get_acl()
            -> inode->i_op->get_acl() == ovl_get_acl()
               -> get_acl() /* on the underlying filesystem */
                  -> inode->i_op->get_acl() == /*lower filesystem callback */
         -> posix_acl_permission()

passing through the get_acl() request to the underlying filesystem.

Before returning these values to the VFS we need to take the idmapping of the
relevant layer into account and translate any ACL_{GROUP,USER} values according
to the idmapped mount.

We cannot alter the ACLs returned from the relevant layer directly as that
would alter the cached values filesystem wide for the lower filesystem. Instead
we can clone the ACLs and then apply the relevant idmapping of the layer.

This is obviously only relevant when idmapped layers are used.

Cc: Seth Forshee <sforshee@digitalocean.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/inode.c | 86 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 78 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 492eddeb481f..538c9f6130b8 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -454,23 +454,93 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	return res;
 }
 
+/*
+ * Apply the idmapping of the layer to POSIX ACLs. The caller must pass a clone
+ * of the POSIX ACLs retrieved from the lower layer to this function to not
+ * alter the POSIX ACLs for the underlying filesystem.
+ */
+static void ovl_idmap_posix_acl(struct user_namespace *mnt_userns,
+				struct posix_acl *acl)
+{
+	unsigned int i;
+
+	for (i = 0; i < acl->a_count; i++) {
+		struct posix_acl_entry *e = &acl->a_entries[i];
+		switch (e->e_tag) {
+		case ACL_USER:
+			e->e_uid = mapped_kuid_fs(mnt_userns, &init_user_ns,
+						  e->e_uid);
+			break;
+		case ACL_GROUP:
+			e->e_gid = mapped_kgid_fs(mnt_userns, &init_user_ns,
+						  e->e_gid);
+			break;
+		}
+	}
+}
+
+/*
+ * When the relevant layer is an idmapped mount we need to take the idmapping
+ * of the layer into account and translate any ACL_{GROUP,USER} values
+ * according to the idmapped mount.
+ *
+ * We cannot alter the ACLs returned from the relevant layer as that would
+ * alter the cached values filesystem wide for the lower filesystem. Instead we
+ * can clone the ACLs and then apply the relevant idmapping of the layer.
+ *
+ * This is obviously only relevant when idmapped layers are used.
+ */
 struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
 {
 	struct inode *realinode = ovl_inode_real(inode);
-	const struct cred *old_cred;
-	struct posix_acl *acl;
+	struct posix_acl *acl, *clone;
+	struct path realpath;
 
 	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !IS_POSIXACL(realinode))
 		return NULL;
 
-	if (rcu)
-		return get_cached_acl_rcu(realinode, type);
+	/* Careful in RCU walk mode */
+	ovl_i_path_real(inode, &realpath);
+	if (!realpath.dentry) {
+		WARN_ON(!rcu);
+		return ERR_PTR(-ECHILD);
+	}
 
-	old_cred = ovl_override_creds(inode->i_sb);
-	acl = get_acl(realinode, type);
-	revert_creds(old_cred);
+	if (rcu) {
+		acl = get_cached_acl_rcu(realinode, type);
+	} else {
+		const struct cred *old_cred;
+
+		old_cred = ovl_override_creds(inode->i_sb);
+		acl = get_acl(realinode, type);
+		revert_creds(old_cred);
+	}
+	/*
+	 * If there are no POSIX ACLs, or we encountered an error,
+	 * or the layer isn't idmapped we don't need to do anything.
+	 */
+	if (!is_idmapped_mnt(realpath.mnt) || IS_ERR_OR_NULL(acl))
+		return acl;
 
-	return acl;
+	/*
+	 * We only get here if the layer is idmapped. So drop out of RCU path
+	 * walk so we can clone the ACLs. There's no need to release the ACLs
+	 * since get_cached_acl_rcu() doesn't take a reference on the ACLs.
+	 */
+	if (rcu)
+		return ERR_PTR(-ECHILD);
+
+	clone = posix_acl_clone(acl, GFP_KERNEL);
+	if (!clone)
+		clone = ERR_PTR(-ENOMEM);
+	else
+		ovl_idmap_posix_acl(mnt_user_ns(realpath.mnt), clone);
+	/*
+	 * Since we're not in RCU path walk we always need to release the
+	 * original ACLs.
+	 */
+	posix_acl_release(acl);
+	return clone;
 }
 
 int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags)
-- 
2.34.1

