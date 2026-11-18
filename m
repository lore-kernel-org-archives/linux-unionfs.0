Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021423;
	b=mQaS0jTPzem/kQho7wRmUqntMXF8FZvv8XZjSKAh5we+ONDyBgnZ3lVrZAWXFEDavQ7e
	 6ilQG6entTftYi5VTmihCqSouDY27237yTqkS/qiAARljUN5cVXBr91U+WPocjX2S7sLe
	 uW9ylaywivZTlHvlwsBBjEObA8iVgSOpvoelS6q9/gVfOTPbK8iOghL1cHqSF3XPZNEcM
	 jYo23Itx6GFbmiLv3uimKbB5LIftNUSZLGzsBxHQvMzVMO0uTyFRbYCAas9reBieo9Itm
	 t0Sp8t99pT6f6wWDBjDIjzWpMAe0CJIH3sh9tDmjUIKTSYaEcGKdtQnzno/JN66oNYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021423;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=fvH4Ub8pP4SdrCX5S0hlW5fTiXrWyYJiu9ya5yzf294=;
	b=oO0unh9lnAWxv5UlfJU63lbrazQ1YJUkKNuSv/NDtNDV5VWox4gtZtAxjw597iH0tcLW
	 oXy83c+U2ti48IkHO4GIojDgSur3VT8GebLzD8RcWH8x6M8iLrLJAlIcXLh4aDP0G8BOo
	 IVjU8n0UqIaymd1lpu17ZPSxozJ9wgrjE6CVpiGKJbUh8xLFHrnI6unSCrx/heK4Te8wx
	 QhwOC6OkN50XQRfc/FKORAm5TgLdtd+utYIYqKU4mZax1y21AHWzGR7FNJcLmFUx5apDC
	 YI8Uq38FwblNfwi+50rqmgWTIyPJhHMLer2JLqcBa0Ecbs5KC47uzxN94pV7HIKno2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=jtytjb57;
	arc=none smtp.remote-ip=209.85.160.179
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFD760A2611
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 17:03:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AFD760A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=jtytjb57
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-55bd96affd2so99671cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 09:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021422; x=1795626222; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fvH4Ub8pP4SdrCX5S0hlW5fTiXrWyYJiu9ya5yzf294=;
        b=jtytjb57xWTV0T3LCUy3gueJ9ET8VJS5Lif7NquguELphfY9Sg8SADYdnucpgE+9tL
         JHjO1HaK5LNCd/fjguE4v+bDOqrwOYMyYEPI/5pj/ZirfgyCOcCNi9fXrn9mppI7tPPl
         7j3W3u41eDM+UkvQIibSESXmVld4g397bUZv0DuoIdJbQEIUCzApfpTLDeiNDxY0J9vJ
         j8xtiH68EYMsfPK+yPvWhNMWz6pgihO4e8NknbslH9IWCNKGP982enbdFUdF9pyWrVZT
         ENEqzHPpFpsiNCQBugGdhHM28hyOY+vthdpwFP229gzP4ubaQhcGEOCqZIsru4WbZlG1
         Qpnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021422; x=1795626222;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fvH4Ub8pP4SdrCX5S0hlW5fTiXrWyYJiu9ya5yzf294=;
        b=cFiEQLkZxZuyeKTIk3gTyjpSTYu6QpWOwSDQ9nM+fsM/ZbkG/Csn9j0NpeEHZ7BZvO
         OEFmT+IhLYMgSO1EO6gf5dZy+zWN+aDPKCEG+8fdb4JjKsBaJzREGWqJmr+Ze9w3x+MC
         FnNJIcT1KbHmVtqXi6aYiOHadcox/YU1/JJgQquY5adxOyRGJQD9GXccaQEr3cGAIjYd
         hGV9zH9RXdNjE+8gzaKmKg5vFYIwaX/xv1R1Z4UCNDbhIwsloK6yT7o44xUfLiTnWFQN
         ciCvZr4h9cEJh1GqLCDRaYb3O4ACBu+kvuWGN9E2S8LMCp26DAl66bKefxywlsIk33YR
         ZhtQ==
X-Forwarded-Encrypted: i=1; AL+hErH89RYwVamNeh36TaUlZALlu60zerB+P/eLsCcB8uBJsJvO7ab4ceFw3jBgT3VASbJMyCRE/5z30CeFVP4d@vger.kernel.org
X-Gm-Message-State: APuU4Z+gYb7YbjE9C0YS6TK6EGCC5dzjM28Opnq72eAR3OptW5N36Mnq
	RZgrlAO8j5TpR43hZR2GG8qMLidyBlDfF/7SklhbhutIQbPz8MptWOREQAiwMhohxek=
X-Gm-Gg: AYBFou3QzlxqvXJ5U5YhzTuTU4dUTncBT/OAzMx2YLU5IEk7rSx9HwHVmrU99Bj3eDX
	lDFi0yciwHOlVQLrqMNXEcMN/IdRyXZf6AXfOl43pCzYGCQ0sS2hv/fki7R7BDMFrGwtWErs1Nr
	mhn10Zxa6gGcKqg8i2W8FiBAtGWvha5Bore1Mp9+5vMVJzk0QmPFyD89IFCMuiYsjysycOst00P
	drhxQJ2BMmEPO8eJynFyuIu7rbJShGXr3H3q6TXpzRqdPZV43d9g+67j0JRn0BgzMSNhn6a5RSo
	IwjGCdHhopYYvpQyljjjVS4OENM9k+7MXkEFIW0jRFnvTvFaSO1E6N3SQ8hPX+NHqqyAZx6WYV5
	M4W4BPAN9hVAez7/aA4DeYNurJfbxlaJESDC3Y3HNKccCFQ/h1nzcuhUDz/osjEAKPPAruZwJa0
	TwE0MWliqU8hcHdyOlCDVw3iGRvVOCk4Pt4M7XU0uemB70Qao74fxr5/jx6hDMHG6QHf8w2/85x
	5/RoN2TomCOBGGPZirJhgp2ziLy+abb/HWPmbQvMSHP7n+XBRu9MkBiWO/hXky2rzdomWJ/Wk7X
	w81oKSRNiSPiqKKa6MjxpqVH7DD7CRGgyflQHKn160zvDA==
X-Received: by 2002:a05:622a:888a:b0:531:2eb:be76 with SMTP id d75a77b69052e-55d685dca55mr1340681cf.22.1795021421979;
        Wed, 18 Nov 2026 09:03:41 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.248])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66b75823sm3947741cf.13.2026.11.18.09.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:03:41 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:03:29 +0000
Subject: [PATCH v7 6/7] ovl: track an inode when it is modified
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
Message-Id: <20261118-b4-ovl-containerized-sync-v7-6-54f45743fe55@toxicpanda.com>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
In-Reply-To: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021413; l=13673;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=sPqSka9KhAUm2vDOMU5sUKmAVVG3y6JkxmGpRbiINKM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGnsSjcuEKTtgEft92GUU32bXEuHRW8HnFTNhiaCJW68t6KKT4UsoRahoD+H6+lZqin6Mi/UD1S
 zS0NalCrLBQ4=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Put an overlay inode into the set of inodes to sync when its upper inode is
modified through the overlay.

Nearly every modification ends in ovl_copyattr(), so do it there.  These do
not, so they track the inode themselves:

 - copy up, for the inode and for its parent
 - ovl_instantiate(), for a new inode and for a new hard link
 - atime updates, if the atime of the upper inode has changed
 - the root, because the mount may have set xattrs on the upper root
 - shared writable mappings
 - the removal of a stale "impure" xattr in readdir
 - the "origin" xattr that lookup sets on a merge directory
 - the helpers that set the "impure", "redirect", "opaque" and "nlink"
   xattrs, and ovl_clear_empty() for the parent.  The operation that calls
   them may still fail, and then it does not get to ovl_copyattr().
 - a setattr that fails, it may have truncated some of the file

Take an inode out of the set when its last link is removed.  Nobody needs
a deleted file to be durable, and the reference of the set would keep its
space.  An O_TMPFILE that can still get a name is tracked like any other
file, and leaves the set when its dentry goes without one.

syncfs() does not look at the set yet.  Until the next patch an inode only
leaves it when it is unlinked, at unmount, or when memory is needed.

Based on work by Chengguang Xu.

Link: https://lore.kernel.org/r/20211122030038.1938875-1-cgxu519@mykernel.net
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/copy_up.c   |  9 +++++++++
 fs/overlayfs/dir.c       | 11 +++++++++++
 fs/overlayfs/file.c      |  7 ++++++-
 fs/overlayfs/inode.c     | 27 +++++++++++++++++++++------
 fs/overlayfs/namei.c     |  9 +++++++--
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/readdir.c   |  1 +
 fs/overlayfs/super.c     | 11 +++++++++++
 fs/overlayfs/util.c      | 16 ++++++++++++++--
 9 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c147ad155b79..f5c89af79e15 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1223,6 +1223,15 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			err = ovl_link_up(&ctx);
 		if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
 			err = ovl_copy_up_meta_inode_data(&ctx);
+		/*
+		 * All three write to the upper inode, and there may be no later
+		 * write that would track the overlay inode.  The first two
+		 * also add an entry to the upper inode of the parent, set its
+		 * "impure" xattr and restore its timestamps.
+		 */
+		ovl_track_inode(d_inode(dentry));
+		if (parent)
+			ovl_track_inode(d_inode(parent));
 		ovl_copy_up_end(dentry);
 	}
 	do_delayed_call(&done);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1792e4114621..3d50e0e7183f 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -276,6 +276,9 @@ static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
 	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_OPAQUE, "y", 1, xerr);
 	if (!err)
 		ovl_dentry_set_opaque(dentry);
+	/* A new directory has no inode yet, ovl_instantiate() tracks it */
+	if (d_inode(dentry))
+		ovl_track_inode(d_inode(dentry));
 
 	return err;
 }
@@ -330,6 +333,9 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 		inc_nlink(inode);
 	}
 
+	/* The upper inode was just created, or has got a new link */
+	ovl_track_inode(inode);
+
 	if (tmpfile)
 		d_mark_tmpfile(tmpfile, inode);
 
@@ -457,6 +463,8 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 
 	err = ovl_do_rename_rd(&rd);
 	end_renaming(&rd);
+	/* The caller tracks the parent, unless it fails after this */
+	ovl_track_inode(d_inode(dentry->d_parent));
 	if (err)
 		goto out_cleanup_unlocked;
 
@@ -971,6 +979,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 			clear_nlink(dentry->d_inode);
 		else
 			ovl_drop_nlink(dentry);
+		ovl_untrack_inode(dentry->d_inode);
 	}
 	ovl_nlink_end(dentry);
 
@@ -1127,6 +1136,7 @@ static int ovl_set_redirect(struct dentry *dentry, bool samedir)
 	err = ovl_check_setxattr(ofs, ovl_dentry_upper(dentry),
 				 OVL_XATTR_REDIRECT,
 				 redirect, strlen(redirect), -EXDEV);
+	ovl_track_inode(d_inode(dentry));
 	if (!err) {
 		spin_lock(&dentry->d_lock);
 		ovl_dentry_set_redirect(dentry, redirect);
@@ -1339,6 +1349,7 @@ static int ovl_rename_upper(struct ovl_renamedata *ovlrd, struct list_head *list
 			clear_nlink(d_inode(new));
 		else
 			ovl_drop_nlink(new);
+		ovl_untrack_inode(d_inode(new));
 	}
 
 	ovl_dir_modified(old->d_parent, ovl_type_origin(old) ||
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7433220d4ad6..95dc34f2690b 100644
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
+		ovl_track_inode(file_inode(file));
+	return err;
 }
 
 static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a11564e90751..08de2e9fdffa 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -84,11 +84,17 @@ int ovl_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 		if (err)
 			goto out_put_write;
 
+		/* Before a truncate dirties a page, for errors of writeback */
+		if (winode)
+			ovl_track_inode(dentry->d_inode);
+
 		inode_lock(upperdentry->d_inode);
 		with_ovl_creds(dentry->d_sb)
 			err = ovl_do_notify_change(ofs, upperdentry, attr);
 		if (!err)
 			ovl_copyattr(dentry->d_inode);
+		else
+			ovl_track_inode(dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
 		ovl_drop_write(dentry);
 
@@ -582,11 +588,17 @@ int ovl_update_time(struct inode *inode, enum fs_update_time type,
 		};
 
 		if (upperpath.dentry) {
+			struct inode *upper = d_inode(upperpath.dentry);
+			struct timespec64 old = inode_get_atime(upper), new;
+
 			if (flags & IOCB_NOWAIT)
 				return -EAGAIN;
 			touch_atime(&upperpath);
-			inode_set_atime_to_ts(inode,
-					      inode_get_atime(d_inode(upperpath.dentry)));
+			new = inode_get_atime(upper);
+			inode_set_atime_to_ts(inode, new);
+			/* touch_atime() may have had nothing to do */
+			if (!timespec64_equal(&old, &new))
+				ovl_track_inode(inode);
 		}
 	}
 	return 0;
@@ -898,7 +910,8 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->lowerdata_redirect = oip->lowerdata_redirect;
 
 	realinode = ovl_inode_real(inode);
-	ovl_copyattr(inode);
+	/* Nothing was changed, the inode is only being looked up */
+	__ovl_copyattr(inode);
 	ovl_copyflags(realinode, inode);
 	ovl_map_ino(inode, ino, fsid);
 }
@@ -975,7 +988,7 @@ static int ovl_set_nlink_common(struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	struct inode *realinode = d_inode(realdentry);
 	char buf[13];
-	int len;
+	int len, err;
 
 	len = snprintf(buf, sizeof(buf), format,
 		       (int) (inode->i_nlink - realinode->i_nlink));
@@ -983,8 +996,10 @@ static int ovl_set_nlink_common(struct dentry *dentry,
 	if (WARN_ON(len >= sizeof(buf)))
 		return -EIO;
 
-	return ovl_setxattr(OVL_FS(inode->i_sb), ovl_dentry_upper(dentry),
-			    OVL_XATTR_NLINK, buf, len);
+	err = ovl_setxattr(OVL_FS(inode->i_sb), ovl_dentry_upper(dentry),
+			   OVL_XATTR_NLINK, buf, len);
+	ovl_track_inode(inode);
+	return err;
 }
 
 int ovl_set_nlink_upper(struct dentry *dentry)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c6127edb9be9..353392dbbde4 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -951,7 +951,8 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	ovl_drop_write(dentry);
 out:
 	kfree(fh);
-	return err;
+	/* Tell the caller that @upper was modified, it has no inode yet */
+	return err ? err : 1;
 }
 
 static int ovl_maybe_validate_verity(struct dentry *dentry)
@@ -1102,6 +1103,7 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 	struct dentry *origin = NULL;
 	bool upperopaque = false;
 	bool uppermetacopy = false;
+	bool origin_fixed = false;
 	int metacopy_size = 0;
 	unsigned int i;
 	int err;
@@ -1181,10 +1183,11 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
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
@@ -1370,6 +1373,8 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 			return PTR_ERR(inode);
 
 		ctx->inode = inode;
+		if (origin_fixed)
+			ovl_track_inode(inode);
 		if (ctx->upperdentry && !uppermetacopy)
 			ovl_set_flag(OVL_UPPERDATA, ctx->inode);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fad8ab77ac19..f4770b4c0222 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -886,6 +886,7 @@ bool ovl_lookup_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir);
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip);
+void __ovl_copyattr(struct inode *to);
 void ovl_copyattr(struct inode *to);
 
 /* sync.c */
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 2018e3114655..599e76e1294a 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -745,6 +745,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
 		if (!ovl_want_write(dentry)) {
 			ovl_removexattr(ofs, ovl_dentry_upper(dentry),
 					OVL_XATTR_IMPURE);
+			ovl_track_inode(inode);
 			ovl_drop_write(dentry);
 		}
 		ovl_clear_flag(OVL_IMPURE, inode);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5eb510bf1b9a..7f7d3993bc7a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -187,8 +187,16 @@ static int ovl_dentry_init(struct dentry *dentry)
 #define ovl_dentry_init NULL
 #endif
 
+/* An O_TMPFILE that has not got a name cannot get one without a dentry */
+static void ovl_d_iput(struct dentry *dentry, struct inode *inode)
+{
+	ovl_untrack_inode(inode);
+	iput(inode);
+}
+
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_real = ovl_d_real,
+	.d_iput = ovl_d_iput,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 	.d_init = ovl_dentry_init,
@@ -197,6 +205,7 @@ static const struct dentry_operations ovl_dentry_operations = {
 #if IS_ENABLED(CONFIG_UNICODE)
 static const struct dentry_operations ovl_dentry_ci_operations = {
 	.d_real = ovl_d_real,
+	.d_iput = ovl_d_iput,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 	.d_hash = generic_ci_d_hash,
@@ -1407,6 +1416,8 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
+	/* The mount may have set xattrs on the upper root */
+	ovl_track_inode(d_inode(root));
 	WARN_ON(!!IS_CASEFOLDED(d_inode(root)) != ofs->casefold);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);
 	/* root keeps a reference of upperdentry */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 521717209b2e..2effec540dac 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -921,6 +921,8 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	err = ovl_check_setxattr(ofs, upperdentry, OVL_XATTR_IMPURE, "y", 1, 0);
 	if (!err)
 		ovl_set_flag(OVL_IMPURE, d_inode(dentry));
+	/* Here, because the operation that needs this may still fail */
+	ovl_track_inode(d_inode(dentry));
 
 	return err;
 }
@@ -1482,7 +1484,7 @@ int ovl_sync_status(struct ovl_fs *ofs)
 }
 
 /*
- * ovl_copyattr() - copy inode attributes from layer to ovl inode
+ * __ovl_copyattr() - copy inode attributes from layer to ovl inode
  *
  * When overlay copies inode information from an upper or lower layer to the
  * relevant overlay inode it will apply the idmapping of the upper or lower
@@ -1492,7 +1494,7 @@ int ovl_sync_status(struct ovl_fs *ofs)
  * map any lower or upper inode owned by id 1001 to id 1000. These mapping
  * helpers are nops when the relevant layer isn't idmapped.
  */
-void ovl_copyattr(struct inode *inode)
+void __ovl_copyattr(struct inode *inode)
 {
 	struct path realpath;
 	struct inode *realinode;
@@ -1516,3 +1518,13 @@ void ovl_copyattr(struct inode *inode)
 	i_size_write(inode, i_size_read(realinode));
 	spin_unlock(&inode->i_lock);
 }
+
+/*
+ * The attributes are copied because the real inode was modified through the
+ * overlay, so this is also where the overlay inode is tracked for a sync.
+ */
+void ovl_copyattr(struct inode *inode)
+{
+	__ovl_copyattr(inode);
+	ovl_track_inode(inode);
+}

-- 
2.55.0

