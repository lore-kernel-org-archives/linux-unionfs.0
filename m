Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F2BC433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiC2Ki7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiC2Ki6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:38:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C65C12E2
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D56F761195
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640C3C340ED;
        Tue, 29 Mar 2022 10:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550234;
        bh=JRC3vjWrKM28/LpMQVqCBfzXf4Uh+Zc0QCglIh/EIdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkYd1YtJaSrj/PDwtbrE2yB5kC23iNSFVPS90UeBUYcOo9F9Y3jI7QIP9zLGGSkR5
         ZdNQDexuy7kBdF7g7JEE50TKGj9Kde0on0lWcFC9LGBPIx1ed12BBAuwdklDZllu8J
         2IRse7O1yAQeVykxn/FCCzSYJ8UrrJWKSbXLBCWf2c7E4c9WrvsY0IFw7jNW7Jwpgr
         j3dHq66dGVNExe3jCJIOrKWr3eLqi83gjfFcW25mMSW2gfhDaBjl2yQIAewWwCj/yY
         fXO6hvGmPPMKM5qvn6eZ0UWMj8OcKebveIvpJXLhU0YXNOg5/vGVJCR3gKvWdnHIUl
         X9T5mZmlynP+A==
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
Subject: [PATCH 12/18] ovl: handle idmappings for layer lookup
Date:   Tue, 29 Mar 2022 12:35:19 +0200
Message-Id: <20220329103526.1207086-13-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5197; h=from:subject; bh=JRC3vjWrKM28/LpMQVqCBfzXf4Uh+Zc0QCglIh/EIdY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5Pdgv7hzzO1T9jFnUx0/pv+8UZmQLT663Osm6oXJ/3e2U yX3BHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABM5fo+R4ZqO+HR9m921y2c+6NSwvB WxRnIf/77jHnNrPj9ZHHCkZAMjw99FF14cyD/zxvOn2+mgXJkT7w8ltUdMLtiSu2Tx8ksZlfwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Make the two places where lookup helpers can be called either on lower
or upper layers take the mount's idmapping into account. To this end we
pass down the mount in struct ovl_lookup_data. It can later also be used
to construct struct path for various other helpers. This is needed to
support idmapped base layers with overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/export.c  |  3 ++-
 fs/overlayfs/namei.c   | 14 ++++++++------
 fs/overlayfs/readdir.c | 10 +++++-----
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index ebde05c9cf62..5acf353d160b 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -391,7 +391,8 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	 * pointer because we hold no lock on the real dentry.
 	 */
 	take_dentry_name_snapshot(&name, real);
-	this = lookup_one_len(name.name.name, connected, name.name.len);
+	this = lookup_one(mnt_user_ns(layer->mnt), name.name.name,
+			  connected, name.name.len);
 	release_dentry_name_snapshot(&name);
 	err = PTR_ERR(this);
 	if (IS_ERR(this)) {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 32f9d9089059..f7b550eafc1b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -199,11 +199,12 @@ static bool ovl_is_opaquedir(struct ovl_fs *ofs, struct path *path)
 	return ovl_path_check_dir_xattr(ofs, path, OVL_XATTR_OPAQUE);
 }
 
-static struct dentry *ovl_lookup_positive_unlocked(const char *name,
+static struct dentry *ovl_lookup_positive_unlocked(struct ovl_lookup_data *d,
+						   const char *name,
 						   struct dentry *base, int len,
 						   bool drop_negative)
 {
-	struct dentry *ret = lookup_one_len_unlocked(name, base, len);
+	struct dentry *ret = lookup_one_unlocked(mnt_user_ns(d->mnt), name, base, len);
 
 	if (!IS_ERR(ret) && d_flags_negative(smp_load_acquire(&ret->d_flags))) {
 		if (drop_negative && ret->d_lockref.count == 1) {
@@ -229,7 +230,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 	int err;
 	bool last_element = !post[0];
 
-	this = ovl_lookup_positive_unlocked(name, base, namelen, drop_negative);
+	this = ovl_lookup_positive_unlocked(d, name, base, namelen, drop_negative);
 	if (IS_ERR(this)) {
 		err = PTR_ERR(this);
 		this = NULL;
@@ -709,7 +710,8 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 	if (err)
 		return ERR_PTR(err);
 
-	index = lookup_positive_unlocked(name.name, ofs->indexdir, name.len);
+	index = lookup_one_positive_unlocked(ovl_upper_idmap(ofs), name.name,
+					     ofs->indexdir, name.len);
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
 		if (err == -ENOENT) {
@@ -1174,8 +1176,8 @@ bool ovl_lower_positive(struct dentry *dentry)
 		struct dentry *this;
 		struct dentry *lowerdir = poe->lowerstack[i].dentry;
 
-		this = lookup_positive_unlocked(name->name, lowerdir,
-					       name->len);
+		this = lookup_one_positive_unlocked(mnt_user_ns(poe->lowerstack[i].layer->mnt),
+						   name->name, lowerdir, name->len);
 		if (IS_ERR(this)) {
 			switch (PTR_ERR(this)) {
 			case -ENOENT:
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 1d06222a496c..78f62cc1797b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -264,11 +264,11 @@ static int ovl_fill_merge(struct dir_context *ctx, const char *name,
 		return ovl_fill_lowest(rdd, name, namelen, offset, ino, d_type);
 }
 
-static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
+static int ovl_check_whiteouts(struct path *path, struct ovl_readdir_data *rdd)
 {
 	int err;
 	struct ovl_cache_entry *p;
-	struct dentry *dentry;
+	struct dentry *dentry, *dir = path->dentry;
 	const struct cred *old_cred;
 
 	old_cred = ovl_override_creds(rdd->dentry->d_sb);
@@ -278,7 +278,7 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 		while (rdd->first_maybe_whiteout) {
 			p = rdd->first_maybe_whiteout;
 			rdd->first_maybe_whiteout = p->next_maybe_whiteout;
-			dentry = lookup_one_len(p->name, dir, p->len);
+			dentry = lookup_one(mnt_user_ns(path->mnt), p->name, dir, p->len);
 			if (!IS_ERR(dentry)) {
 				p->is_whiteout = ovl_is_whiteout(dentry);
 				dput(dentry);
@@ -312,7 +312,7 @@ static inline int ovl_dir_read(struct path *realpath,
 	} while (!err && rdd->count);
 
 	if (!err && rdd->first_maybe_whiteout && rdd->dentry)
-		err = ovl_check_whiteouts(realpath->dentry, rdd);
+		err = ovl_check_whiteouts(realpath, rdd);
 
 	fput(realfile);
 
@@ -479,7 +479,7 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 			goto get;
 		}
 	}
-	this = lookup_one_len(p->name, dir, p->len);
+	this = lookup_one(mnt_user_ns(path->mnt), p->name, dir, p->len);
 	if (IS_ERR_OR_NULL(this) || !this->d_inode) {
 		/* Mark a stale entry */
 		p->is_whiteout = true;
-- 
2.32.0

