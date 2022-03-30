Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB469C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 10:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbiC3K1X (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245347AbiC3K1X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 06:27:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8318C260C45
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 03:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A53CB81AD2
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 10:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B856BC340EE;
        Wed, 30 Mar 2022 10:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635934;
        bh=bHy6AeP1lMtEHbcM/A1dgdssELeIheVHRp7LoN3FDP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nNc8X1iBuLiyZAQDgkCFOeC7bVbRkhNbSoQoSZDmwWUtUdMb4cOjtMqJBx/5Z7pXV
         bQn4SqbiCy4bzv9Iwiu8e9MkCf2MHPSgYJQRuu05d1rPw0QnRe5lTdd+19Zgb/IWQf
         FbUUn9tFtWVciZD3Dyc0kS1QSuNjOaoCdp+QRjB9YaM0fBQI0FlXdCEcHEMHcHG+3k
         UiChf9hCUVFjLES8wNSY5Fp1Lh1i+LFr/IBsJZDoqzqYkVAqt7W5A5IxhIuw1NBta/
         XKgZGxXURdg5LT6xdgpAzT0YOYpptkYCC83M33qy7CPURsUk89J39tWyO8/tlrH350
         w+WiKDXHtyaDA==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 08/19] ovl: pass layer mnt to ovl_open_realfile()
Date:   Wed, 30 Mar 2022 12:23:56 +0200
Message-Id: <20220330102409.1290850-9-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4552; i=brauner@kernel.org; h=from:subject; bh=Ywq1FeK9BXqPwdYj9v670/RpVl5CxsohCFBEIZ12gXU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56O9N3v+al/fSZJWjrM47QgIzXH60rb5hG6rG8iGAd/HF BIVlHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMR42f4xaTOtP/lGqHlzT/kVfbbSf Ub2u49KCZ8VOX9ZqOqAPVjsxgZdrYvsmqOXmRtzsbvLvXmr9oSa/YfhUsK1myPWFldvZubHQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Ensure that ovl_open_realfile() takes the mount's idmapping into
account. We add a new helper ovl_path_realdata() that can be used to
easily retrieve the relevant path which we can pass down. This is needed
to support idmapped base layers with overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
unchanged
---
 fs/overlayfs/file.c      | 22 +++++++++++++---------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 14 ++++++++++++++
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index fa125feed0ff..9250e04e97af 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -38,8 +38,9 @@ static char ovl_whatisit(struct inode *inode, struct inode *realinode)
 #define OVL_OPEN_FLAGS (O_NOATIME | FMODE_NONOTIFY)
 
 static struct file *ovl_open_realfile(const struct file *file,
-				      struct inode *realinode)
+				      struct path *realpath)
 {
+	struct inode *realinode = d_inode(realpath->dentry);
 	struct inode *inode = file_inode(file);
 	struct file *realfile;
 	const struct cred *old_cred;
@@ -104,21 +105,21 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
 			       bool allow_meta)
 {
-	struct inode *inode = file_inode(file);
-	struct inode *realinode;
+	struct dentry *dentry = file_dentry(file);
+	struct path realpath;
 
 	real->flags = 0;
 	real->file = file->private_data;
 
 	if (allow_meta)
-		realinode = ovl_inode_real(inode);
+		ovl_path_real(dentry, &realpath);
 	else
-		realinode = ovl_inode_realdata(inode);
+		ovl_path_realdata(dentry, &realpath);
 
 	/* Has it been copied up since we'd opened it? */
-	if (unlikely(file_inode(real->file) != realinode)) {
+	if (unlikely(file_inode(real->file) != d_inode(realpath.dentry))) {
 		real->flags = FDPUT_FPUT;
-		real->file = ovl_open_realfile(file, realinode);
+		real->file = ovl_open_realfile(file, &realpath);
 
 		return PTR_ERR_OR_ZERO(real->file);
 	}
@@ -144,17 +145,20 @@ static int ovl_real_fdget(const struct file *file, struct fd *real)
 
 static int ovl_open(struct inode *inode, struct file *file)
 {
+	struct dentry *dentry = file_dentry(file);
 	struct file *realfile;
+	struct path realpath;
 	int err;
 
-	err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
+	err = ovl_maybe_copy_up(dentry, file->f_flags);
 	if (err)
 		return err;
 
 	/* No longer need these flags, so don't pass them on to underlying fs */
 	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
-	realfile = ovl_open_realfile(file, ovl_inode_realdata(inode));
+	ovl_path_realdata(dentry, &realpath);
+	realfile = ovl_open_realfile(file, &realpath);
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b003652f8827..816a69b46b67 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -319,6 +319,7 @@ void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
+enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 5a7e5d1e884b..42293610f64e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -194,6 +194,20 @@ enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 	return type;
 }
 
+enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+
+	WARN_ON_ONCE(d_is_dir(dentry));
+
+	if (!OVL_TYPE_UPPER(type) || OVL_TYPE_MERGE(type))
+		ovl_path_lowerdata(dentry, path);
+	else
+		ovl_path_upper(dentry, path);
+
+	return type;
+}
+
 struct dentry *ovl_dentry_upper(struct dentry *dentry)
 {
 	return ovl_upperdentry_dereference(OVL_I(d_inode(dentry)));
-- 
2.32.0

