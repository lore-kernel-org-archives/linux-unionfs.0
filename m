Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16291FC7E4
	for <linux-unionfs@vger.kernel.org>; Tue, 15 Oct 2024 13:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999110; cv=none; b=YvXL251MnO+3HqhH+fJfyoDg4mPvYgoP4SgqffRPXFcRqOZbwcnaSBcGjeUcidym9o8q4i9frqWITPZAVORWarGP8+P6MNuQ9OtbXD4iO2ZaqZYoVdzygiEOvqoG0AEpVGx8qacfAsHmey/GHODYm/Rq/nBVqkUW+kU1Z7Wqp80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999110; c=relaxed/simple;
	bh=UNuPEi9bn4Aaoy0yIWPMmR8Dh3ZeLEH0wEGZT3YfBmc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bptwF3+DVXM0dhkgLZadFxhAZgU7eY5MjfViWTJWOoWrCYKkLuhi63fWlnXigj9liIJg4GwWtRevMq4PnxVbb5McL0QJiKhRdfPTRrVUGbouYuRxelBelUrvEmciu4sXQbm2WFaJQRBJMKGGzUobZcV4mJbT2BXP3YAoGGIj3dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9RUW9gm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9RUW9gm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728999106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rM7d7RWu40O4DQHtwZKIYbNhDI1KAtyZXH8jUeUq4ME=;
	b=h9RUW9gm8gUJbVzhcRerDx5R+/KFwIYousYW/8D/OyhohmMa8qE1zKUCbs16cPcD0IOKgc
	JPZHLkk+MTA2/GJ34M3bwSXBJg7+iM8WH8PMDVYP2Sx9wMVc+TiEA2YK5BeJUDLRKX75mA
	MeqJ1N+9t0ed77qfCLf0UOQYRQ1ooFQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-_VDt_nJTO9u7fNRDttXLRQ-1; Tue, 15 Oct 2024 09:31:45 -0400
X-MC-Unique: _VDt_nJTO9u7fNRDttXLRQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a99f084683fso219243366b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Oct 2024 06:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728999104; x=1729603904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rM7d7RWu40O4DQHtwZKIYbNhDI1KAtyZXH8jUeUq4ME=;
        b=ppuH3WPKOFze4XjSgNQTJ5YGE0ig1mCJvJEadBQd9tsCBIY4xObUWpol9hqRNeiLk0
         24pP4CKF8sra6DQuP2i3ff7Hoxx8wGfIaFFFNtzebG+X6vXYapWvj66YDPNELmoiZmJn
         riESZndoMEBFEbb2OAw9RfmYgzR9wXDG0o0ThFgSHhJQ40vZjqAxyPEDBi9TSPC60H2f
         4gHtDGzD4Ob1jOPUQkGfx3qjUP0NTxqlOwECkRvb6vOeT2JbVL8gXD6iFbv6CMo70/aS
         BxgXj2brHIRtwAPJNEmAqy0hQx4pCBW50U6rVduymXGD2AmkudgsdCFDMRIfn8R3Xc75
         YR4A==
X-Gm-Message-State: AOJu0YzRz14I/13fR1GDrGTPnS11JLhJKIrcysnmuyXM76vy/lya9PAE
	MzAw/TRnD7puGSjQZUCQ5wZFWlkQBNN6RNh/7fAo4D99lsKwgYcmj9/9SjOxRIYS8JrlF7fw/sj
	SwnlD/d4Ec+quvmc2LYBlx7Tp77swCrt4KvBRLB7mLAVyTFkmvT6eXXWf+kVtEwvV4Fllu7A=
X-Received: by 2002:a17:907:d5a0:b0:a99:fb10:1269 with SMTP id a640c23a62f3a-a9a34d699d1mr20575766b.17.1728999104196;
        Tue, 15 Oct 2024 06:31:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeZ0pJgjdHejYMStyWDunYDsJp8FO5BZ5uQ7na+uvD+oeXULjrIeHqt0ozzAxrS7P8Ca4FRQ==
X-Received: by 2002:a17:907:d5a0:b0:a99:fb10:1269 with SMTP id a640c23a62f3a-a9a34d699d1mr20572466b.17.1728999103707;
        Tue, 15 Oct 2024 06:31:43 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-2-25.pool.digikabel.hu. [84.236.2.25])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a29843979sm72303166b.173.2024.10.15.06.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 06:31:43 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH] backing-file: clean up the API
Date: Tue, 15 Oct 2024 15:31:40 +0200
Message-ID: <20241015133141.70632-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 - Pass iocb to ctx->end_write() instead of file + pos

 - Get rid of ctx->user_file, which is redundant most of the time

 - Instead pass user_file explicitly to backing_file_splice_read and
   backing_file_splice_write

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
This applies on top of "fs: pass offset and result to backing_file
end_write() callback"

 fs/backing-file.c            | 37 ++++++++++++++++++++----------------
 fs/fuse/passthrough.c        | 21 +++++++-------------
 fs/overlayfs/file.c          | 14 +++++---------
 include/linux/backing-file.h |  9 ++++-----
 4 files changed, 37 insertions(+), 44 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 09a9be945d45..98f4486cfca9 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -80,7 +80,7 @@ struct backing_aio {
 	refcount_t ref;
 	struct kiocb *orig_iocb;
 	/* used for aio completion */
-	void (*end_write)(struct file *, loff_t, ssize_t);
+	void (*end_write)(struct kiocb *iocb, ssize_t);
 	struct work_struct work;
 	long res;
 };
@@ -108,10 +108,10 @@ static void backing_aio_cleanup(struct backing_aio *aio, long res)
 	struct kiocb *iocb = &aio->iocb;
 	struct kiocb *orig_iocb = aio->orig_iocb;
 
+	orig_iocb->ki_pos = iocb->ki_pos;
 	if (aio->end_write)
-		aio->end_write(orig_iocb->ki_filp, iocb->ki_pos, res);
+		aio->end_write(orig_iocb, res);
 
-	orig_iocb->ki_pos = iocb->ki_pos;
 	backing_aio_put(aio);
 }
 
@@ -200,7 +200,7 @@ ssize_t backing_file_read_iter(struct file *file, struct iov_iter *iter,
 	revert_creds(old_cred);
 
 	if (ctx->accessed)
-		ctx->accessed(ctx->user_file);
+		ctx->accessed(iocb->ki_filp);
 
 	return ret;
 }
@@ -219,7 +219,7 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 	if (!iov_iter_count(iter))
 		return 0;
 
-	ret = file_remove_privs(ctx->user_file);
+	ret = file_remove_privs(iocb->ki_filp);
 	if (ret)
 		return ret;
 
@@ -239,7 +239,7 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 
 		ret = vfs_iter_write(file, iter, &iocb->ki_pos, rwf);
 		if (ctx->end_write)
-			ctx->end_write(ctx->user_file, iocb->ki_pos, ret);
+			ctx->end_write(iocb, ret);
 	} else {
 		struct backing_aio *aio;
 
@@ -270,7 +270,7 @@ ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(backing_file_write_iter);
 
-ssize_t backing_file_splice_read(struct file *in, loff_t *ppos,
+ssize_t backing_file_splice_read(struct file *in, struct file *user_in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags,
 				 struct backing_file_ctx *ctx)
@@ -286,15 +286,15 @@ ssize_t backing_file_splice_read(struct file *in, loff_t *ppos,
 	revert_creds(old_cred);
 
 	if (ctx->accessed)
-		ctx->accessed(ctx->user_file);
+		ctx->accessed(user_in);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(backing_file_splice_read);
 
 ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
-				  struct file *out, loff_t *ppos, size_t len,
-				  unsigned int flags,
+				  struct file *out, struct file *user_out, loff_t *ppos,
+				  size_t len, unsigned int flags,
 				  struct backing_file_ctx *ctx)
 {
 	const struct cred *old_cred;
@@ -306,7 +306,7 @@ ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
 	if (!out->f_op->splice_write)
 		return -EINVAL;
 
-	ret = file_remove_privs(ctx->user_file);
+	ret = file_remove_privs(user_out);
 	if (ret)
 		return ret;
 
@@ -316,8 +316,14 @@ ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
 	file_end_write(out);
 	revert_creds(old_cred);
 
-	if (ctx->end_write)
-		ctx->end_write(ctx->user_file, ppos ? *ppos : 0, ret);
+	if (ctx->end_write) {
+		struct kiocb iocb;
+
+		init_sync_kiocb(&iocb, out);
+		iocb.ki_pos = *ppos;
+
+		ctx->end_write(&iocb, ret);
+	}
 
 	return ret;
 }
@@ -329,8 +335,7 @@ int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 	const struct cred *old_cred;
 	int ret;
 
-	if (WARN_ON_ONCE(!(file->f_mode & FMODE_BACKING)) ||
-	    WARN_ON_ONCE(ctx->user_file != vma->vm_file))
+	if (WARN_ON_ONCE(!(file->f_mode & FMODE_BACKING)))
 		return -EIO;
 
 	if (!file->f_op->mmap)
@@ -343,7 +348,7 @@ int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 	revert_creds(old_cred);
 
 	if (ctx->accessed)
-		ctx->accessed(ctx->user_file);
+		ctx->accessed(vma->vm_file);
 
 	return ret;
 }
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index bbac547dfcb3..5c502394a208 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -18,11 +18,11 @@ static void fuse_file_accessed(struct file *file)
 	fuse_invalidate_atime(inode);
 }
 
-static void fuse_passthrough_end_write(struct file *file, loff_t pos, ssize_t ret)
+static void fuse_passthrough_end_write(struct kiocb *iocb, ssize_t ret)
 {
-	struct inode *inode = file_inode(file);
+	struct inode *inode = file_inode(iocb->ki_filp);
 
-	fuse_write_update_attr(inode, pos, ret);
+	fuse_write_update_attr(inode, iocb->ki_pos, ret);
 }
 
 ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *iter)
@@ -34,7 +34,6 @@ ssize_t fuse_passthrough_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret;
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
-		.user_file = file,
 		.accessed = fuse_file_accessed,
 	};
 
@@ -62,7 +61,6 @@ ssize_t fuse_passthrough_write_iter(struct kiocb *iocb,
 	ssize_t ret;
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
-		.user_file = file,
 		.end_write = fuse_passthrough_end_write,
 	};
 
@@ -88,15 +86,13 @@ ssize_t fuse_passthrough_splice_read(struct file *in, loff_t *ppos,
 	struct file *backing_file = fuse_file_passthrough(ff);
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
-		.user_file = in,
 		.accessed = fuse_file_accessed,
 	};
 
 	pr_debug("%s: backing_file=0x%p, pos=%lld, len=%zu, flags=0x%x\n", __func__,
-		 backing_file, ppos ? *ppos : 0, len, flags);
+		 backing_file, *ppos, len, flags);
 
-	return backing_file_splice_read(backing_file, ppos, pipe, len, flags,
-					&ctx);
+	return backing_file_splice_read(backing_file, in, ppos, pipe, len, flags, &ctx);
 }
 
 ssize_t fuse_passthrough_splice_write(struct pipe_inode_info *pipe,
@@ -109,16 +105,14 @@ ssize_t fuse_passthrough_splice_write(struct pipe_inode_info *pipe,
 	ssize_t ret;
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
-		.user_file = out,
 		.end_write = fuse_passthrough_end_write,
 	};
 
 	pr_debug("%s: backing_file=0x%p, pos=%lld, len=%zu, flags=0x%x\n", __func__,
-		 backing_file, ppos ? *ppos : 0, len, flags);
+		 backing_file, *ppos, len, flags);
 
 	inode_lock(inode);
-	ret = backing_file_splice_write(pipe, backing_file, ppos, len, flags,
-					&ctx);
+	ret = backing_file_splice_write(pipe, backing_file, out, ppos, len, flags, &ctx);
 	inode_unlock(inode);
 
 	return ret;
@@ -130,7 +124,6 @@ ssize_t fuse_passthrough_mmap(struct file *file, struct vm_area_struct *vma)
 	struct file *backing_file = fuse_file_passthrough(ff);
 	struct backing_file_ctx ctx = {
 		.cred = ff->cred,
-		.user_file = file,
 		.accessed = fuse_file_accessed,
 	};
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 24a36d61bb0c..1debab93e3d6 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -231,9 +231,9 @@ static void ovl_file_modified(struct file *file)
 	ovl_copyattr(file_inode(file));
 }
 
-static void ovl_file_end_write(struct file *file, loff_t, ssize_t)
+static void ovl_file_end_write(struct kiocb *iocb, ssize_t)
 {
-	ovl_file_modified(file);
+	ovl_file_modified(iocb->ki_filp);
 }
 
 static void ovl_file_accessed(struct file *file)
@@ -271,7 +271,6 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret;
 	struct backing_file_ctx ctx = {
 		.cred = ovl_creds(file_inode(file)->i_sb),
-		.user_file = file,
 		.accessed = ovl_file_accessed,
 	};
 
@@ -298,7 +297,6 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	int ifl = iocb->ki_flags;
 	struct backing_file_ctx ctx = {
 		.cred = ovl_creds(inode->i_sb),
-		.user_file = file,
 		.end_write = ovl_file_end_write,
 	};
 
@@ -338,7 +336,6 @@ static ssize_t ovl_splice_read(struct file *in, loff_t *ppos,
 	ssize_t ret;
 	struct backing_file_ctx ctx = {
 		.cred = ovl_creds(file_inode(in)->i_sb),
-		.user_file = in,
 		.accessed = ovl_file_accessed,
 	};
 
@@ -346,7 +343,7 @@ static ssize_t ovl_splice_read(struct file *in, loff_t *ppos,
 	if (ret)
 		return ret;
 
-	ret = backing_file_splice_read(fd_file(real), ppos, pipe, len, flags, &ctx);
+	ret = backing_file_splice_read(fd_file(real), in, ppos, pipe, len, flags, &ctx);
 	fdput(real);
 
 	return ret;
@@ -368,7 +365,6 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	ssize_t ret;
 	struct backing_file_ctx ctx = {
 		.cred = ovl_creds(inode->i_sb),
-		.user_file = out,
 		.end_write = ovl_file_end_write,
 	};
 
@@ -380,9 +376,10 @@ static ssize_t ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	if (ret)
 		goto out_unlock;
 
-	ret = backing_file_splice_write(pipe, fd_file(real), ppos, len, flags, &ctx);
+	ret = backing_file_splice_write(pipe, fd_file(real), out, ppos, len, flags, &ctx);
 	fdput(real);
 
+
 out_unlock:
 	inode_unlock(inode);
 
@@ -420,7 +417,6 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	struct file *realfile = file->private_data;
 	struct backing_file_ctx ctx = {
 		.cred = ovl_creds(file_inode(file)->i_sb),
-		.user_file = file,
 		.accessed = ovl_file_accessed,
 	};
 
diff --git a/include/linux/backing-file.h b/include/linux/backing-file.h
index 2eed0ffb5e8f..7db9f77281ca 100644
--- a/include/linux/backing-file.h
+++ b/include/linux/backing-file.h
@@ -14,9 +14,8 @@
 
 struct backing_file_ctx {
 	const struct cred *cred;
-	struct file *user_file;
 	void (*accessed)(struct file *);
-	void (*end_write)(struct file *, loff_t, ssize_t);
+	void (*end_write)(struct kiocb *iocb, ssize_t);
 };
 
 struct file *backing_file_open(const struct path *user_path, int flags,
@@ -31,13 +30,13 @@ ssize_t backing_file_read_iter(struct file *file, struct iov_iter *iter,
 ssize_t backing_file_write_iter(struct file *file, struct iov_iter *iter,
 				struct kiocb *iocb, int flags,
 				struct backing_file_ctx *ctx);
-ssize_t backing_file_splice_read(struct file *in, loff_t *ppos,
+ssize_t backing_file_splice_read(struct file *in, struct file *user_in, loff_t *ppos,
 				 struct pipe_inode_info *pipe, size_t len,
 				 unsigned int flags,
 				 struct backing_file_ctx *ctx);
 ssize_t backing_file_splice_write(struct pipe_inode_info *pipe,
-				  struct file *out, loff_t *ppos, size_t len,
-				  unsigned int flags,
+				  struct file *out, struct file *user_out, loff_t *ppos,
+				  size_t len, unsigned int flags,
 				  struct backing_file_ctx *ctx);
 int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 		      struct backing_file_ctx *ctx);
-- 
2.47.0

