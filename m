Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E50C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbiCaLZ5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbiCaLZ4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:25:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BED34A907
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:24:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C4A0B820C3
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79650C340ED;
        Thu, 31 Mar 2022 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725846;
        bh=afB0WmPe3v32DG+HadTSN57hFjRgLeiTfKGZDZQBlGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knkHD3ZmhL8/wxhtP79o2BU/Dx+mhgUGmM8hkhQwMj6Qs7r1ShtPgCrmWiw4M0EQE
         LxqR6+PsiXM22QPRTvugw472fvMgm3yV+k2MZxpEBABXksgmI7wT0Ert7/pq/hxN+3
         WtmspokBAagCkV5s6RvQLFcy1RhIQJiJOgTENy5NE4356ldJ8hW2k3imfncLKXMmpw
         gcZ7kw2Rg8FM3JVrOhJeYvqYrsQ43LTEKo9oy3mFNsByyuN8OnSvxE0PeGvigLpdMa
         4HH9qrHDAlNRByy/Q8IxOzY4Xn6drWD8xb8eON+R6eJg2oeSFSl0EiVKkeOGeGMeat
         5IWvz+KZKKJHA==
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
Subject: [PATCH v3 06/19] ovl: handle idmappings in creation operations
Date:   Thu, 31 Mar 2022 13:23:04 +0200
Message-Id: <20220331112318.1377494-7-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4723; h=from:subject; bh=afB0WmPe3v32DG+HadTSN57hFjRgLeiTfKGZDZQBlGY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59ku8cvvUxKZj9Wv5+2PCJi/XyJ0SnprNXJo2ZbLxG17n qxo7O0pYGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyO43hm7Io/5mnHOtNZLxez3pxx5 3r3nfvC2nt6yfUfvxYO93WjOF/7EqVa5dzJiyW31thwshmci3a8qxYf4CuXot/552aa0r8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When creating objects in the upper layer we need to pass down the upper
idmapping into the respective vfs helpers in order to support idmapped
base layers. The vfs helpers will take care of the rest.

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
 fs/overlayfs/overlayfs.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8fae64722eda..27f79be097b1 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -125,7 +125,7 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
 static inline int ovl_do_rmdir(struct ovl_fs *ofs,
 			       struct inode *dir, struct dentry *dentry)
 {
-	int err = vfs_rmdir(&init_user_ns, dir, dentry);
+	int err = vfs_rmdir(ovl_upper_idmap(ofs), dir, dentry);
 
 	pr_debug("rmdir(%pd2) = %i\n", dentry, err);
 	return err;
@@ -134,7 +134,7 @@ static inline int ovl_do_rmdir(struct ovl_fs *ofs,
 static inline int ovl_do_unlink(struct ovl_fs *ofs, struct inode *dir,
 				struct dentry *dentry)
 {
-	int err = vfs_unlink(&init_user_ns, dir, dentry, NULL);
+	int err = vfs_unlink(ovl_upper_idmap(ofs), dir, dentry, NULL);
 
 	pr_debug("unlink(%pd2) = %i\n", dentry, err);
 	return err;
@@ -143,7 +143,7 @@ static inline int ovl_do_unlink(struct ovl_fs *ofs, struct inode *dir,
 static inline int ovl_do_link(struct ovl_fs *ofs, struct dentry *old_dentry,
 			      struct inode *dir, struct dentry *new_dentry)
 {
-	int err = vfs_link(old_dentry, &init_user_ns, dir, new_dentry, NULL);
+	int err = vfs_link(old_dentry, ovl_upper_idmap(ofs), dir, new_dentry, NULL);
 
 	pr_debug("link(%pd2, %pd2) = %i\n", old_dentry, new_dentry, err);
 	return err;
@@ -153,7 +153,7 @@ static inline int ovl_do_create(struct ovl_fs *ofs,
 				struct inode *dir, struct dentry *dentry,
 				umode_t mode)
 {
-	int err = vfs_create(&init_user_ns, dir, dentry, mode, true);
+	int err = vfs_create(ovl_upper_idmap(ofs), dir, dentry, mode, true);
 
 	pr_debug("create(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
@@ -163,7 +163,7 @@ static inline int ovl_do_mkdir(struct ovl_fs *ofs,
 			       struct inode *dir, struct dentry *dentry,
 			       umode_t mode)
 {
-	int err = vfs_mkdir(&init_user_ns, dir, dentry, mode);
+	int err = vfs_mkdir(ovl_upper_idmap(ofs), dir, dentry, mode);
 	pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
 }
@@ -172,7 +172,7 @@ static inline int ovl_do_mknod(struct ovl_fs *ofs,
 			       struct inode *dir, struct dentry *dentry,
 			       umode_t mode, dev_t dev)
 {
-	int err = vfs_mknod(&init_user_ns, dir, dentry, mode, dev);
+	int err = vfs_mknod(ovl_upper_idmap(ofs), dir, dentry, mode, dev);
 
 	pr_debug("mknod(%pd2, 0%o, 0%o) = %i\n", dentry, mode, dev, err);
 	return err;
@@ -182,7 +182,7 @@ static inline int ovl_do_symlink(struct ovl_fs *ofs,
 				 struct inode *dir, struct dentry *dentry,
 				 const char *oldname)
 {
-	int err = vfs_symlink(&init_user_ns, dir, dentry, oldname);
+	int err = vfs_symlink(ovl_upper_idmap(ofs), dir, dentry, oldname);
 
 	pr_debug("symlink(\"%s\", %pd2) = %i\n", oldname, dentry, err);
 	return err;
@@ -244,10 +244,10 @@ static inline int ovl_do_rename(struct ovl_fs *ofs, struct inode *olddir,
 {
 	int err;
 	struct renamedata rd = {
-		.old_mnt_userns	= &init_user_ns,
+		.old_mnt_userns	= ovl_upper_idmap(ofs),
 		.old_dir 	= olddir,
 		.old_dentry 	= olddentry,
-		.new_mnt_userns	= &init_user_ns,
+		.new_mnt_userns	= ovl_upper_idmap(ofs),
 		.new_dir 	= newdir,
 		.new_dentry 	= newdentry,
 		.flags 		= flags,
@@ -265,7 +265,7 @@ static inline int ovl_do_rename(struct ovl_fs *ofs, struct inode *olddir,
 static inline int ovl_do_whiteout(struct ovl_fs *ofs,
 				  struct inode *dir, struct dentry *dentry)
 {
-	int err = vfs_whiteout(&init_user_ns, dir, dentry);
+	int err = vfs_whiteout(ovl_upper_idmap(ofs), dir, dentry);
 	pr_debug("whiteout(%pd2) = %i\n", dentry, err);
 	return err;
 }
@@ -273,7 +273,7 @@ static inline int ovl_do_whiteout(struct ovl_fs *ofs,
 static inline struct dentry *ovl_do_tmpfile(struct ovl_fs *ofs,
 					    struct dentry *dentry, umode_t mode)
 {
-	struct dentry *ret = vfs_tmpfile(&init_user_ns, dentry, mode, 0);
+	struct dentry *ret = vfs_tmpfile(ovl_upper_idmap(ofs), dentry, mode, 0);
 	int err = PTR_ERR_OR_ZERO(ret);
 
 	pr_debug("tmpfile(%pd2, 0%o) = %i\n", dentry, mode, err);
-- 
2.32.0

