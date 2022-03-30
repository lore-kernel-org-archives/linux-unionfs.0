Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D9FC433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 10:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbiC3K1u (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242937AbiC3K1t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 06:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD87325FD6F
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 03:26:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EFFF61457
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 10:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBF8C340EC;
        Wed, 30 Mar 2022 10:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635962;
        bh=WBgi/AjfAcw0O7h+u7lfadT8Ax8S+NpcXNNmjD5z/zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFOs98e1+h8VIu+DlHxpUkGFGJ71CAOhLh4MDLYHajkwXA72b41uHLBUSSFUgrtYD
         IqvEecgQ4s8V1PqSEBWI5jUcMMq2zSt/QAGlrS/tvtZQ39GyaS5oA2/T5+DjHZqb9/
         XSO9/JPyifBwiuPIvx03ckLZh+VUI0S/9c1hutSLJTizy+sJla4jDP1IQ1Z3x44wIp
         bVmr4mYDijmpekeOXOgkZ1J4zrVKDYvNTWziR27lb6nivud3e5j4SWua2VHtJExbFd
         yAFqLEZbx6VadosO1tArQo9qEq71Zsy3rLERzxg7Gnr++Zz2vou2UU3bxfjiqsFK+u
         OW4tSrgEWiK0g==
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
Subject: [PATCH v2 13/19] ovl: handle idmappings for layer lookup
Date:   Wed, 30 Mar 2022 12:24:01 +0200
Message-Id: <20220330102409.1290850-14-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5223; h=from:subject; bh=WBgi/AjfAcw0O7h+u7lfadT8Ax8S+NpcXNNmjD5z/zc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56O/Xt+B0+9Q45dmt0wtPt6/7/VXz8uKpReuff3h2XrG9 UGHB3o5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJRK9mZJir4WKbtbbumtKSnxPFMl z43ftkDxxJW6N8b8/NmJv3vNcx/C/YMWHm93vRLAH7jE2T27PrKrrzs10avrDYVD70+se2mQ0A
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

