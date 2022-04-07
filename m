Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB424C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiDGLZT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbiDGLZR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:25:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1886569
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:23:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87889B826CD
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA51EC385A4;
        Thu,  7 Apr 2022 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330595;
        bh=kmW/lRTF16D5FuSqfQyI6F0yr+VLFSFjHngZUztP7/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPlOa0EP0kd0HtzXCud0IBvE9kXiF1WZCX8H2SbMqnI8XmVwyw0TCm5YD22stGlUz
         3LQ0BsmYlVtQeK5ptv9XmTB/QYy7H1qGwqZf5h5rsYs/OSg2eVNqTB0cvydK/WnrqR
         FuKMT7pIHMmGbnbskUZ0+2Xb8o2m/wXj4b2fQ5qQxNbArW07/zxjmfe04un6YkHODs
         6M6yesXrbm6/cWoq0RfrMcbjt1f0yb+1yDZ2lh9pGJ44CYqqHVCytCvEwXDVlV3Xy5
         NOP4sxQbKFh137Fp3tl2WAVPwWl3vtyq+0scWu1GRvv7FYvAfypVDaehPsafptsHcb
         pY5YjaFaY5tcQ==
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
Subject: [PATCH v5 13/19] ovl: handle idmappings for layer lookup
Date:   Thu,  7 Apr 2022 13:21:50 +0200
Message-Id: <20220407112157.1775081-14-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5372; h=from:subject; bh=kmW/lRTF16D5FuSqfQyI6F0yr+VLFSFjHngZUztP7/E=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfTRT3pu8yC3cPbNFPMN51RdAq7XeLAsN3Iqubl5W706 x+vWjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm4PGb4pzn9JUvs6u3bueP6/jBxf5 XeumPt/4zED13/DhhoLFl2vo/hN4vzTK21q7bcdlZoF25feDdqWwBfHK+AzlKJNPMjQS6WnAA=
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
index 32f9d9089059..98ac5a47a00c 100644
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
+	index = lookup_one_positive_unlocked(ovl_upper_mnt_userns(ofs), name.name,
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

