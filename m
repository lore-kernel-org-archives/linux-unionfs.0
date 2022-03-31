Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3046FC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbiCaL0H (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiCaL0G (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:26:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CC96257
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A93B820CA
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E476C340ED;
        Thu, 31 Mar 2022 11:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725857;
        bh=WOdNxqXuhhmv3OnqXoZv8WcZa8jnNpX26+ZsK6gS2LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRuESQd7PEctJyl8CPDO+hiimWdETsxSp+lm0peadrv1ZMbWWKxZtUL8qH/yIClO0
         kRkTjHsJnMWwkNuDQXJe9XJD64IOYW2P99yjRrtGugMxBWuGjyZwjbXT9tAJHlD75Q
         CD9xEtP86RXc63ycJ9AGmz66LtEERdMA+BTkVlYsvb9cXDUBSgXSMCiwnCdTHbDcof
         g6Wq87k3GxGDMQoerblVTiwXoUYdLg7xLvKwAXqYSUBHasYxOBb/Oj/7ufwNGllqaZ
         C/qvCql/ttPaDWhRy8VgVfP7F/XtHmafUOuGhsO7HLSSUIKVdhVpfotk47StC3sGyz
         T1uRhhXZvX52g==
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
Subject: [PATCH v3 08/19] ovl: pass layer mnt to ovl_open_realfile()
Date:   Thu, 31 Mar 2022 13:23:06 +0200
Message-Id: <20220331112318.1377494-9-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4575; i=brauner@kernel.org; h=from:subject; bh=KNVY18KFm6wjsPZn8pxLtkWoZqfp8i1X9pLJDRiDjCs=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59ksmvglpmck2xWBR4JFzFxw6L6T4/5E8s1VqZvP/hrLL 4omdHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNx4GBkeBt+Kvrtudd7f686fHjDcj dzps2q36ecXZCZcqeRuVD28naGv7K77SykGN4rrDSZ0u70/0+tsh3fi1qzP/WvFm4qM7n4iQsA
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

/* v3 */
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

