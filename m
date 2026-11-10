Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320707;
	b=TqxglDRcNiOZJpVuwBA5efQRtDFrySG3g2GKM6HfQ/RTwhSarXTAIscVkLoQGtRN3929
	 T0WNDkmAudbLJMI98jrtvkbREBBe+PpYK7gNXQjKsZAIs2JfX9O5EYsz+DRHSMUzUzhpK
	 g6mZ8jFqUAvAVcKNZ1Bm65yRJyDFnRxu/C9EgGi1L+6huBHmjp2IwgxFqL8Yoo4iv2JsJ
	 XmZsADoMmhrNdwdPTj3SxCnHFxFLFVSpnsrQGUNBBQNNBOjj40G8Bbf+18067dqpiUGHJ
	 iLqfBzshBzgrjqkXeRHBm45wob079W9XWUfPPzSjywbtADDhkJrydUyI3FQtJhAvcXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320707;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=/Yf/4ABv93USUAVj2AnEM7i9aTJoeg8A5XrLmuUcGSA=;
	b=yRQtXflB1FECSahvjJniCe1VOyai9owM9+PiTIbwsoFg+6YTvofIyvhd74kaLmL0v1Et
	 s1FpPFz0dNYTsw/++byOTByqxdQ76A9gWSESybPsO7jl3mvuLRu8OLx1JDU1VmaCtiGRz
	 DWJ3oXK+11iOdwXFQV7I/1z1u6wSU16GIk1PF9iLI4ud5365qFBRJRzreER1NyDcHS5Mo
	 9QxcozPcRZUBwIhEe+xYIIHx0mnrvDKeo59/AsWP32jfZlvry0j+fPZlV7+aKEwKnhecY
	 nR4PpbELHmLmcHhrMvGEcbscL8HBnXFj28vKjpaJgfPxIYQCDgkh2cu3nR9vuH8vFjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b="SdThXX/X";
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A78760A2635
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A78760A2635
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=SdThXX/X
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93a40a9a01aso260472285a.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794320706; x=1794925506; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Yf/4ABv93USUAVj2AnEM7i9aTJoeg8A5XrLmuUcGSA=;
        b=SdThXX/XvWC9iOLb5cweprXm8p8lbV9keIXzQHaWNn2oqo4ovzGvnfwDSniy3BJ+ZF
         Ki8eVuer4TH1cZYDxoebOYr6iOY4/IaxJKchmlI8qm9xsVP094OPrc8deQ1jLlPO3nMz
         woJgTvD0Z4hGW0X3p9NAwnpBwlAUv5pNMGWL9fHb5UXEM2tBftLuPzCSEWJQZ/mNLy7u
         QG58vUn3tLBa9lqpOmtKVdAYnofLazFnpl/Jtde/q3+uyir4U40/C26f5CTe8ODtSvOl
         LqprqlHztzKF9u2u8uOcE5ZB5/nACXf2nPvD+mVJty+1ECJ3ia/KcLq330lknq1+JCfX
         GxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320706; x=1794925506;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Yf/4ABv93USUAVj2AnEM7i9aTJoeg8A5XrLmuUcGSA=;
        b=QbiRyuFvNwSw59y/Pfeqhlv3Aw/pAyCCiVN3hKHXR/0bVYXa7Ua71TNGsKdwKx7w92
         mc/54bDLTY2sn5fng95woeAB1NvAeHdM0+kIboinNEC10yUGdf/bEL9yFHBzfDh3BRao
         z86SPi2+4hmwypuweiWe4Vv555k4VEQkQagmDgQfvoadkyHJWWHTJH4zQjCnGMX1BN2G
         sM3pCHNEXulVr1vsA/h6dhpW9/qN8B4fm79Ip3N00ha7132in5FQccACHlEmLUgJMHBn
         K/vhrVmV3HjsJ/wk9haXPthSVsCS9WZIowLDjFPHg8LRzOTdj5razZeQSRTWAof22vGp
         /YDw==
X-Forwarded-Encrypted: i=1; AL+hErFLIy+Fd0jhwwAt/1FWKmI5FZ8VHnzVVdOJ9ib2OhDFVqHg0ThYdZIXPL42f5cQ4ts2PHq5uNwh7WrdoavI@vger.kernel.org
X-Gm-Message-State: APuU4Z/BCbJYKWL6nDthX0Nb2hWSDftrlr1ZAKi2b5P1V3fhdAbG3F2B
	f7p/p5Ytvt8vmxj48KA+SXilc2CIXYOBou2Vj+JfWjNZ3bWog56Uk4YjGmppxyvXCFk=
X-Gm-Gg: AYBFou3T+gO4Ezv9VuumPO4FPCP+U2KJx9E3F0+gW2JAqUC9vkr660z4sDEFBA4Fnj8
	FKPnjiKpLtFmODPIEmeNgUCUuTrSYIHIBVjj+BihyxfdkCWlQ6cU8Z/dxzQJ5JwJkGubJ3/tiay
	HaNlF5OB0nINNHJpLiC1Lr9mLPtY7bor0BP3nHIEo/AcriogtXYtGKETlEDwpn8wWYNhNu3ztFI
	kUBNeqROWhLfSgtokgwJBB945I0AqcAzIo+W9yZg4vsyNIH8YNPXNFZ+WkFs3vp4TPcGZhrrDO8
	l4mn0CUl95jZCMBLMwXFg13Ta8fB3m39Qv9LK88OmcK+dOf2pihXfRM3PrRLUy98hVEQhRfZ4n8
	eaxugJ5L/hnysnG//DtdUy75tURU6kWgkay13IMrF2KkY6r1YqMfPaJgGQou3h/zgxUIU0fZU3m
	q6zdfsg/OePB6dKXaGCqmzG5hyOqqjpxtITz9uT3pmkjR/XokbLoC+dAWJYey9OJuRehUg2vWu7
	Aqny7ikOCrHIRQjil3u/2GixVu/LU0Fx7lMx/KjaqZFpZLqE2EBHpIYhq6QNQfpA4W8Xywm7oE5
	uht5cvwRaPSnaow31j54uCg5URDtlQv4taMiIz9QSEwnmz80qphCnjkhRNXGT6F7OxI=
X-Received: by 2002:a05:620a:2a04:b0:93e:5677:317b with SMTP id af79cd13be357-9479f20ce46mr451524885a.25.1794320706134;
        Tue, 10 Nov 2026 06:25:06 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.243])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e61a7easm235416185a.5.2026.11.10.06.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:25:05 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 10 Nov 2026 14:24:52 +0000
Subject: [PATCH v6 4/9] ovl: mark the overlay inode dirty on modification
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-b4-ovl-containerized-sync-v6-4-43d1be16a4d6@toxicpanda.com>
References: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
In-Reply-To: <20261110-b4-ovl-containerized-sync-v6-0-43d1be16a4d6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794320698; l=9192;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=ou5XGwlSrGDmJzRWNj5Nri9TL3HAVDhsUzU4tRBA/GY=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QM7p/GXHsPzXklpYrqEBoQ6fizk1gVVbYwRPMujBKMKAuHk/66jWwIfK6TL9wtFMf/lAlGyR5TT
 5XtVAw0nwRgg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

To sync only what was written through an overlay, we have to know which
upper inodes were modified through it.  Mark the overlay inode dirty when
its upper inode is modified, which puts it on the dirty list of the
overlay's bdi.

Nearly every modification ends in ovl_copyattr(), so do it there.  These do
not, so they mark the inode themselves:

 - copy up, for the inode and for its parent
 - ovl_instantiate(), for a new inode and for a new hard link
 - atime updates
 - shared writable mappings
 - the removal of a stale "impure" xattr in readdir
 - the "origin" and "impure" xattrs that lookup sets on a merge directory
   and on its parent

Do not mark an unhashed inode.  __mark_inode_dirty() would set its dirty
flags without queueing it, and every later call would return early.  The
inode of a lower hardlink is unhashed until ovl_inode_update() hashes it.
The root inode is never hashed, a later patch takes care of it.

Based on work by Chengguang Xu.

Link: https://lore.kernel.org/r/20211122030038.1938875-1-cgxu519@mykernel.net
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/copy_up.c   |  9 +++++++++
 fs/overlayfs/dir.c       |  3 +++
 fs/overlayfs/file.c      |  7 ++++++-
 fs/overlayfs/inode.c     |  4 +++-
 fs/overlayfs/namei.c     | 10 ++++++++--
 fs/overlayfs/overlayfs.h | 20 ++++++++++++++++++++
 fs/overlayfs/readdir.c   |  1 +
 fs/overlayfs/util.c      | 12 +++++++++++-
 8 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e963701b4c87..44bc96aa3d5d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1199,6 +1199,15 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			err = ovl_link_up(&ctx);
 		if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
 			err = ovl_copy_up_meta_inode_data(&ctx);
+		/*
+		 * All three write to the upper inode, and there may be no later
+		 * write that would mark the overlay inode dirty.  The first two
+		 * also add an entry to the upper inode of the parent, set its
+		 * "impure" xattr and restore its timestamps.
+		 */
+		ovl_mark_inode_dirty(d_inode(dentry));
+		if (parent)
+			ovl_mark_inode_dirty(d_inode(parent));
 		ovl_copy_up_end(dentry);
 	}
 	do_delayed_call(&done);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1194ccf981c3..a24326446659 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -331,6 +331,9 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 		inc_nlink(inode);
 	}
 
+	/* The upper inode was just created, or has got a new link */
+	ovl_mark_inode_dirty(inode);
+
 	if (tmpfile)
 		d_mark_tmpfile(tmpfile, inode);
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7433220d4ad6..53c5131a0482 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -472,8 +472,13 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 		.cred = ovl_creds(file_inode(file)->i_sb),
 		.accessed = ovl_file_accessed,
 	};
+	int err;
 
-	return backing_file_mmap(of->realfile, vma, &ctx);
+	err = backing_file_mmap(of->realfile, vma, &ctx);
+	/* Stores through the mapping go straight to the upper inode */
+	if (!err && vma_is_shared_maywrite(vma))
+		ovl_mark_inode_dirty(file_inode(file));
+	return err;
 }
 
 static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 63906b3dafcb..9a4bf7c2502b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -587,6 +587,7 @@ int ovl_update_time(struct inode *inode, enum fs_update_time type,
 			touch_atime(&upperpath);
 			inode_set_atime_to_ts(inode,
 					      inode_get_atime(d_inode(upperpath.dentry)));
+			ovl_mark_inode_dirty(inode);
 		}
 	}
 	return 0;
@@ -898,7 +899,8 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->lowerdata_redirect = oip->lowerdata_redirect;
 
 	realinode = ovl_inode_real(inode);
-	ovl_copyattr(inode);
+	/* Nothing was changed, the inode is only being looked up */
+	__ovl_copyattr(inode);
 	ovl_copyflags(realinode, inode);
 	ovl_map_ino(inode, ino, fsid);
 }
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ca899fdfaafd..647992c95284 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -944,11 +944,13 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	err = ovl_set_origin_fh(ofs, fh, upper);
 	if (!err)
 		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
+	ovl_mark_inode_dirty(d_inode(dentry->d_parent));
 
 	ovl_drop_write(dentry);
 out:
 	kfree(fh);
-	return err;
+	/* Tell the caller that @upper was modified, it has no inode yet */
+	return err ? err : 1;
 }
 
 static int ovl_maybe_validate_verity(struct dentry *dentry)
@@ -1099,6 +1101,7 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 	struct dentry *origin = NULL;
 	bool upperopaque = false;
 	bool uppermetacopy = false;
+	bool origin_fixed = false;
 	int metacopy_size = 0;
 	unsigned int i;
 	int err;
@@ -1178,10 +1181,11 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 		 */
 		if (ctx->upperdentry && !ctx->ctr && !ofs->noxattr && d->is_dir) {
 			err = ovl_fix_origin(ofs, dentry, this, ctx->upperdentry);
-			if (err) {
+			if (err < 0) {
 				dput(this);
 				return err;
 			}
+			origin_fixed = err;
 		}
 
 		/*
@@ -1367,6 +1371,8 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 			return PTR_ERR(inode);
 
 		ctx->inode = inode;
+		if (origin_fixed)
+			ovl_mark_inode_dirty(inode);
 		if (ctx->upperdentry && !uppermetacopy)
 			ovl_set_flag(OVL_UPPERDATA, ctx->inode);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 5b1a097ce543..d82c4bed5af2 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -691,6 +691,25 @@ static inline bool ovl_should_sync_upper_fs(struct ovl_fs *ofs)
 	return ovl_should_sync(ofs) && !ovl_tracks_dirty(ofs);
 }
 
+/*
+ * The upper inode was modified through this overlay.  Put the overlay inode on
+ * the dirty list of the overlay, where syncfs() and unmount find it.
+ *
+ * Do not look at the dirty flags of the upper inode here.  They are cleared
+ * when the writeback of the upper inode starts, not when it completes.
+ *
+ * Do not mark an inode that is not hashed.  __mark_inode_dirty() would set its
+ * dirty flags without putting it on a dirty list, and once the flags are set,
+ * later calls return early.  The overlay inode of a lower hardlink is unhashed
+ * until ovl_inode_update() hashes it, and ovl_copy_up_one() marks it after
+ * that.  The root inode is never hashed, so it is not tracked.
+ */
+static inline void ovl_mark_inode_dirty(struct inode *inode)
+{
+	if (ovl_tracks_dirty(OVL_FS(inode->i_sb)) && !inode_unhashed(inode))
+		mark_inode_dirty(inode);
+}
+
 /*
  * To avoid regressions in existing setups with overlay lower offline changes,
  * we allow lower changes only if none of the new features are used.
@@ -878,6 +897,7 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip);
+void __ovl_copyattr(struct inode *to);
 void ovl_copyattr(struct inode *to);
 
 /* vfs fileattr flags read from overlay.protattr xattr to ovl inode */
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 7d6f7f6022eb..f02c37600df6 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -724,6 +724,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
 		if (!ovl_want_write(dentry)) {
 			ovl_removexattr(ofs, ovl_dentry_upper(dentry),
 					OVL_XATTR_IMPURE);
+			ovl_mark_inode_dirty(inode);
 			ovl_drop_write(dentry);
 		}
 		ovl_clear_flag(OVL_IMPURE, inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 521717209b2e..a260c5a350e2 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1492,7 +1492,7 @@ int ovl_sync_status(struct ovl_fs *ofs)
  * map any lower or upper inode owned by id 1001 to id 1000. These mapping
  * helpers are nops when the relevant layer isn't idmapped.
  */
-void ovl_copyattr(struct inode *inode)
+void __ovl_copyattr(struct inode *inode)
 {
 	struct path realpath;
 	struct inode *realinode;
@@ -1516,3 +1516,13 @@ void ovl_copyattr(struct inode *inode)
 	i_size_write(inode, i_size_read(realinode));
 	spin_unlock(&inode->i_lock);
 }
+
+/*
+ * The attributes are copied because the real inode was modified through the
+ * overlay, so this is also where the overlay inode is marked dirty.
+ */
+void ovl_copyattr(struct inode *inode)
+{
+	__ovl_copyattr(inode);
+	ovl_mark_inode_dirty(inode);
+}

-- 
2.55.0

