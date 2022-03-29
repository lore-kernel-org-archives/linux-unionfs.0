Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26904C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiC2KjH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiC2KjG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:39:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581CBF950
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E9D61195
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A99C340ED;
        Tue, 29 Mar 2022 10:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550242;
        bh=eQ6NiZJzO/1petl8stKemeOsBOw3AMoPUnkGABJYy50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdzAuWTPnMLIltyumP2QjQAf2g7jVHtX0Bv3jx++XdSrvrSL8yo1OfEhiethNpKPY
         eix6XtYI3gj2KuPpo4PR/nr9Y0Delr7pRZmFVwQFkCslieX6PZE6oVT1b0Kl1SQlyc
         p61+FTMAEhwDk4Ve38ySu3uys1Mp5CTalqLOLCQae3uajzVoqWGwRFd7S2aZCeB3TJ
         Ck6GoTe8fcoJopJ5vti3N6x+lQ8QH+El1eB3KUpl27lVNxzaBVnCFQRaPKA7jASZDP
         XJdifreyaPkZRexv72Ibxu1YdzdwAFND44X9LLyMWNRIILRzBlYNTn4/7iTxiTII8K
         dJSqQJIebqryg==
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
Subject: [PATCH 14/18] ovl: use ovl_copy_{real,upper}attr() wrappers
Date:   Tue, 29 Mar 2022 12:35:21 +0200
Message-Id: <20220329103526.1207086-15-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9229; h=from:subject; bh=eQ6NiZJzO/1petl8stKemeOsBOw3AMoPUnkGABJYy50=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5PTgQ+clwlayn/NPGjUzPLjH7rXP6eivjzcasqBbhj9su PmcT7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIdCLDX4lgcy3rqewHTs/Qn6o469 SCcNOFNveXne9oz7708NmKLRsZGfYvSpo+e9Z8vu0i2z/U9bBdyTs07budRWjLvrUfL2s8+cwMAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When copying inode attributes we from the upper or lower layer to ovl
inodes we need to take the upper or lower layer's mount's idmapping into
account. In a lot of places we call ovl_copyattr() only on upper inodes
and in some we call it on either upper or lower inodes. Split this into
two separate helpers.

The first one should only be called on upper
inodes and is thus called ovl_copy_upperattr(). The second one can be
called on upper or lower inodes. We add ovl_copy_realattr() for this
task. The new helper makes use of the previously added ovl_i_path_real()
helper. This is needed to support idmapped base layers with overlay.

When overlay copies the inode information from an upper or lower layer
to the relevant overlay inode it will apply the idmapping of the upper
or lower layer when doing so. The ovl inode ownership will thus always
correctly reflect the ownership of the idmapped upper or lower layer.

All idmapping helpers are nops when no idmapped base layers are used.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/dir.c       |  6 +++---
 fs/overlayfs/file.c      | 15 +++++++--------
 fs/overlayfs/inode.c     |  8 ++++----
 fs/overlayfs/overlayfs.h | 22 +++++++++++++---------
 fs/overlayfs/util.c      | 27 ++++++++++++++++++++++++++-
 5 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index cacb34c0094d..bc0525cbcf82 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -931,7 +931,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	 */
 	upperdentry = ovl_dentry_upper(dentry);
 	if (upperdentry)
-		ovl_copyattr(d_inode(upperdentry), d_inode(dentry));
+		ovl_copy_upperattr(d_inode(upperdentry), d_inode(dentry));
 
 out_drop_write:
 	ovl_drop_write(dentry);
@@ -1279,9 +1279,9 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
 			 (d_inode(new) && ovl_type_origin(new)));
 
 	/* copy ctime: */
-	ovl_copyattr(d_inode(olddentry), d_inode(old));
+	ovl_copy_upperattr(d_inode(olddentry), d_inode(old));
 	if (d_inode(new) && ovl_dentry_upper(new))
-		ovl_copyattr(d_inode(newdentry), d_inode(new));
+		ovl_copy_upperattr(d_inode(newdentry), d_inode(new));
 
 out_dput:
 	dput(newdentry);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 9250e04e97af..656c30bf20a6 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -277,7 +277,7 @@ static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
 		__sb_writers_acquired(file_inode(iocb->ki_filp)->i_sb,
 				      SB_FREEZE_WRITE);
 		file_end_write(iocb->ki_filp);
-		ovl_copyattr(ovl_inode_real(inode), inode);
+		ovl_copy_realattr(inode);
 	}
 
 	orig_iocb->ki_pos = iocb->ki_pos;
@@ -360,7 +360,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	inode_lock(inode);
 	/* Update mode */
-	ovl_copyattr(ovl_inode_real(inode), inode);
+	ovl_copy_realattr(inode);
 	ret = file_remove_privs(file);
 	if (ret)
 		goto out_unlock;
@@ -385,7 +385,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 				     ovl_iocb_to_rwf(ifl));
 		file_end_write(real.file);
 		/* Update size */
-		ovl_copyattr(ovl_inode_real(inode), inode);
+		ovl_copy_realattr(inode);
 	} else {
 		struct ovl_aio_req *aio_req;
 
@@ -435,12 +435,11 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	struct fd real;
 	const struct cred *old_cred;
 	struct inode *inode = file_inode(out);
-	struct inode *realinode = ovl_inode_real(inode);
 	ssize_t ret;
 
 	inode_lock(inode);
 	/* Update mode */
-	ovl_copyattr(realinode, inode);
+	ovl_copy_realattr(inode);
 	ret = file_remove_privs(out);
 	if (ret)
 		goto out_unlock;
@@ -456,7 +455,7 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 
 	file_end_write(real.file);
 	/* Update size */
-	ovl_copyattr(realinode, inode);
+	ovl_copy_realattr(inode);
 	revert_creds(old_cred);
 	fdput(real);
 
@@ -530,7 +529,7 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	revert_creds(old_cred);
 
 	/* Update size */
-	ovl_copyattr(ovl_inode_real(inode), inode);
+	ovl_copy_realattr(inode);
 
 	fdput(real);
 
@@ -602,7 +601,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	revert_creds(old_cred);
 
 	/* Update size */
-	ovl_copyattr(ovl_inode_real(inode_out), inode_out);
+	ovl_copy_realattr(inode_out);
 
 	fdput(real_in);
 	fdput(real_out);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e28b7ed755b3..44fa578267fa 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -81,7 +81,7 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 		err = ovl_do_notify_change(ofs, upperdentry, attr);
 		revert_creds(old_cred);
 		if (!err)
-			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
+			ovl_copy_upperattr(upperdentry->d_inode, dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
 
 		if (winode)
@@ -379,7 +379,7 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 	revert_creds(old_cred);
 
 	/* copy c/mtime */
-	ovl_copyattr(d_inode(realdentry), inode);
+	ovl_copy_upperattr(d_inode(realdentry), inode);
 
 out_drop_write:
 	ovl_drop_write(dentry);
@@ -581,7 +581,7 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		inode_set_flags(inode, flags, OVL_COPY_I_FLAGS_MASK);
 
 		/* Update ctime */
-		ovl_copyattr(ovl_inode_real(inode), inode);
+		ovl_copy_realattr(inode);
 	}
 	ovl_drop_write(dentry);
 out:
@@ -791,7 +791,7 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 		oi->lowerdata = igrab(d_inode(oip->lowerdata));
 
 	realinode = ovl_inode_real(inode);
-	ovl_copyattr(realinode, inode);
+	ovl_copy_realattr(inode);
 	ovl_copyflags(realinode, inode);
 	ovl_map_ino(inode, ino, fsid);
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c3f7e5602699..1715cbfae2a0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -615,15 +615,19 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip);
-static inline void ovl_copyattr(struct inode *from, struct inode *to)
-{
-	to->i_uid = from->i_uid;
-	to->i_gid = from->i_gid;
-	to->i_mode = from->i_mode;
-	to->i_atime = from->i_atime;
-	to->i_mtime = from->i_mtime;
-	to->i_ctime = from->i_ctime;
-	i_size_write(to, i_size_read(from));
+void ovl_do_copyattr(struct vfsmount *realmnt, struct inode *realinode,
+		     struct inode *inode);
+static inline void ovl_copy_upperattr(struct inode *upperinode, struct inode *to)
+{
+	ovl_do_copyattr(ovl_upper_mnt(OVL_FS(to->i_sb)), upperinode, to);
+}
+
+static inline void ovl_copy_realattr(struct inode *to)
+{
+	struct path realpath;
+
+	ovl_i_path_real(to, &realpath);
+	ovl_do_copyattr(realpath.mnt, d_inode(realpath.dentry), to);
 }
 
 /* vfs inode flags copied from real to ovl inode */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7dd9901c9d17..79fae06ee10a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -500,7 +500,7 @@ static void ovl_dir_version_inc(struct dentry *dentry, bool impurity)
 void ovl_dir_modified(struct dentry *dentry, bool impurity)
 {
 	/* Copy mtime/ctime */
-	ovl_copyattr(d_inode(ovl_dentry_upper(dentry)), d_inode(dentry));
+	ovl_copy_upperattr(d_inode(ovl_dentry_upper(dentry)), d_inode(dentry));
 
 	ovl_dir_version_inc(dentry, impurity);
 }
@@ -1116,3 +1116,28 @@ int ovl_sync_status(struct ovl_fs *ofs)
 
 	return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
 }
+
+/*
+ * ovl_do_copyattr() - copy inode attributes from layer to ovl inode
+ *
+ * When overlay copies inode information from an upper or lower layer to the
+ * relevant overlay inode it will apply the idmapping of the upper or lower
+ * layer when doing so ensuring that the ovl inode ownership will correctly
+ * reflect the ownership of the idmapped upper or lower layer. For example, an
+ * idmapped upper or lower layer mapping id 1001 to id 1000 will take care to
+ * map any lower or upper inode owned by id 1001 to id 1000. These mapping
+ * helpers are nops when the relevant layer isn't idmapped.
+ */
+void ovl_do_copyattr(struct vfsmount *realmnt, struct inode *realinode,
+		     struct inode *inode)
+{
+	struct user_namespace *real_idmap = mnt_user_ns(realmnt);
+
+	inode->i_uid = i_uid_into_mnt(real_idmap, realinode);
+	inode->i_gid = i_gid_into_mnt(real_idmap, realinode);
+	inode->i_mode = realinode->i_mode;
+	inode->i_atime = realinode->i_atime;
+	inode->i_mtime = realinode->i_mtime;
+	inode->i_ctime = realinode->i_ctime;
+	i_size_write(inode, i_size_read(realinode));
+}
-- 
2.32.0

