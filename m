Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDD61BD504
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 08:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737620295; cv=none; b=lJusVcEl4zCEmuFxaERfkqhOeKBmJgTiegBujz2cIHk8Z8jdEzPdYINdR8j5eRsbISpcX3bBgs9BTz1fYwOdsd4b0+avir953ROcRbm9Wh2Q8CJkrvAwLzBeoL232RlM+HXXuI5fVsJc3Rz9uI8YNXeLiH3biihKZd2pxpACIRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737620295; c=relaxed/simple;
	bh=wMUIV+9lCp1oR8NeC3oALdD7qSFlUKSOymBY5mERm7c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tZEEgt/tjNf6ysV/sDIEzYQ9pa7zA6zoTJgb6krurW6A0s94d4tbL+h3Ju9WgS+Ujs1UP85nnQhhCf+s8xoHJxhEu5wL+hRtisYvZD/5FVEXC+8WUjud/l/xxyqa2qLiG5v65aszY7pbFu69RDr60Ahy0y+9J+XpianMCnwxSGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=engflow.com; spf=pass smtp.mailfrom=engflow.com; dkim=pass (1024-bit key) header.d=engflow.com header.i=@engflow.com header.b=Xzs9g413; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=engflow.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=engflow.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=engflow.com header.i=@engflow.com header.b="Xzs9g413"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38a34e8410bso274768f8f.2
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 00:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engflow.com; s=google; t=1737620291; x=1738225091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zdRD3Qz+X9zSG9MGMgZmv/lZlVwYsoOR1yVG8sLSiMA=;
        b=Xzs9g413gBkWlZAbnXLk+tDvaYncDtM8byegqdrzkJjnEGoX/ZoCqBbzsMr7nkNkWG
         Ggw9DhWMw3VBfBkqNwY7w2Wmlw8e/hkFhxCkszvorCU3OFIovmaR5WT3cIbY4Eq0mDNw
         mPAezwNf/F2NkAiWHHMPvVreajiZFrU2PxRoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737620291; x=1738225091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zdRD3Qz+X9zSG9MGMgZmv/lZlVwYsoOR1yVG8sLSiMA=;
        b=bslwdt6FuenZ4M9AokmBRkGOQCmCwlw59SVPO7yM3ZN/CBE4E1aFIS0lqnxs6bmEHo
         A+xX5hbHhHLH+uXflDrCAPC+hMA5JrfINEcK6erdwUBNxlpqJgGn8wRCB1IjMFlIM5jW
         PTP+FLgZjBMbmHPz2kjkI3Hs6oOwGjZnBOzVZaG9Za1aJZBYG/GKUENFJQAvJms2oClA
         1v+DR3zsiwOy50tJjOb8MV1QLPfjYTie94Fdob5x283F7V73Mmvc3tBepaBq3GlB2pDf
         PcaTyksr0r1U1atAicFOvQK0qTHHiNvYeAFAii1455EKf6arKI4+cx/3P9zSCXEuSdPf
         5ZmA==
X-Gm-Message-State: AOJu0YzYHr8MUo1HQ/t5Kstt7i2O1YsASpfdG6U6nUfyqTQFWBP/H77k
	Va+9y0eyldB6xcL/ztdkvu0D9ehOW+tK2SvezsZ52QkPHABgEue34vE0TODW5McjgATraHOMu8w
	BTL0=
X-Gm-Gg: ASbGncspOcyRE9ZZYM3pEr1nRRt6BIaUPO1vAcSUFhvZ8P34lhopwHbvoBT/0Ig7Eq0
	y4UoSNUzedLiTXehRD7AnqXw9AJkqyiJODR7wy2At9vwuun2yPpJQ1oEQLv0dan+kg+v0p5dnNx
	DS1rflfWjoJPDo1bgPspg6B3nUGbuw2kR25FcW18SvNYsLAcHFLUQg64zYYAAuCUfNWXbk4PP5p
	PoEtLIQ/DEGGYQQeumQyR9dM+vD/f/qylp34fnW0hhPlOeJunD8I9ND0+1w3D9+XMpwZre3Hx6Q
	7CCZ5shB83OxE7OUhaDvWmkc
X-Google-Smtp-Source: AGHT+IEuh75glXldre2ACbeXilV0eKufXN3Kn+9nnofUzPweOILyOFgXY7LQe9IQO19fvdMMG2PPwA==
X-Received: by 2002:a5d:5988:0:b0:386:32cb:4aa with SMTP id ffacd0b85a97d-38bf59efa03mr22645198f8f.45.1737620290773;
        Thu, 23 Jan 2025 00:18:10 -0800 (PST)
Received: from hanwen-flow.taileccd.ts.net ([2001:a61:3aa8:7b01:88a:93b7:eccb:1cfe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf32221e2sm18858665f8f.36.2025.01.23.00.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 00:18:10 -0800 (PST)
From: Han-Wen Nienhuys <hanwen@engflow.com>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	Han-Wen Nienhuys <hanwen@engflow.com>
Subject: [PATCH] fs: support cross-type copy_file_range in overlayfs.
Date: Thu, 23 Jan 2025 09:18:04 +0100
Message-ID: <20250123081804.550042-1-hanwen@engflow.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduces the FOP_CROSS_TYPE_COPYFILE flag, and implements it for
overlayfs. This enables copy_file_range between an overlayfs mount and
its constituent layers.

Signed-off-by: Han-Wen Nienhuys <hanwen@engflow.com>
---
 fs/overlayfs/file.c | 60 ++++++++++++++++++++++++++++++---------------
 fs/read_write.c     | 15 ++++++++----
 include/linux/fs.h  |  4 +++
 3 files changed, 54 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 969b458100fe..97b394737251 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -536,6 +536,9 @@ static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 	return ret;
 }
 
+static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
+				   struct file *file_out, loff_t pos_out,
+				   size_t len, unsigned int flags);
 enum ovl_copyop {
 	OVL_COPY,
 	OVL_CLONE,
@@ -547,30 +550,42 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 			    loff_t len, unsigned int flags, enum ovl_copyop op)
 {
 	struct inode *inode_out = file_inode(file_out);
-	struct file *realfile_in, *realfile_out;
+	struct file *realfile_in = file_in;
+	struct file *realfile_out = file_out;
 	const struct cred *old_cred;
 	loff_t ret;
+	bool in_overlay = file_in->f_op->copy_file_range == &ovl_copy_file_range;
+	bool out_overlay = file_out->f_op->copy_file_range == &ovl_copy_file_range;
 
-	inode_lock(inode_out);
-	if (op != OVL_DEDUPE) {
-		/* Update mode */
-		ovl_copyattr(inode_out);
-		ret = file_remove_privs(file_out);
-		if (ret)
-			goto out_unlock;
+	if (WARN_ON_ONCE(!in_overlay && !out_overlay))
+		return -EXDEV;
+
+	if (in_overlay) {
+		realfile_in = ovl_real_file(file_in);
+		ret = PTR_ERR(realfile_in);
+		if (IS_ERR(realfile_in))
+			return ret;
 	}
 
-	realfile_out = ovl_real_file(file_out);
-	ret = PTR_ERR(realfile_out);
-	if (IS_ERR(realfile_out))
-		goto out_unlock;
+	if (out_overlay) {
+		inode_lock(inode_out);
 
-	realfile_in = ovl_real_file(file_in);
-	ret = PTR_ERR(realfile_in);
-	if (IS_ERR(realfile_in))
-		goto out_unlock;
+		if (op != OVL_DEDUPE) {
+			/* Update mode */
+			ovl_copyattr(inode_out);
+			ret = file_remove_privs(file_out);
+			if (ret)
+				goto out_unlock;
+		}
+
+		realfile_out = ovl_real_file(file_out);
+		ret = PTR_ERR(realfile_out);
+		if (IS_ERR(realfile_out))
+			goto out_unlock;
+
+		old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
+	}
 
-	old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
 	switch (op) {
 	case OVL_COPY:
 		ret = vfs_copy_file_range(realfile_in, pos_in,
@@ -588,13 +603,16 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 						flags);
 		break;
 	}
-	ovl_revert_creds(old_cred);
 
 	/* Update size */
-	ovl_file_modified(file_out);
+	if (out_overlay) {
+		ovl_file_modified(file_out);
+		ovl_revert_creds(old_cred);
+	}
 
 out_unlock:
-	inode_unlock(inode_out);
+	if (out_overlay)
+		inode_unlock(inode_out);
 
 	return ret;
 }
@@ -654,6 +672,8 @@ static int ovl_flush(struct file *file, fl_owner_t id)
 }
 
 const struct file_operations ovl_file_operations = {
+	.fop_flags	= FOP_CROSS_TYPE_COPYFILE,
+
 	.open		= ovl_open,
 	.release	= ovl_release,
 	.llseek		= ovl_llseek,
diff --git a/fs/read_write.c b/fs/read_write.c
index a6133241dfb8..93618441a02d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1489,7 +1489,7 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	 * We allow some filesystems to handle cross sb copy, but passing
 	 * a file of the wrong filesystem type to filesystem driver can result
 	 * in an attempt to dereference the wrong type of ->private_data, so
-	 * avoid doing that until we really have a good reason.
+	 * avoid doing unless FOP_CROSS_TYPE_COPYFILE is set.
 	 *
 	 * nfs and cifs define several different file_system_type structures
 	 * and several different sets of file_operations, but they all end up
@@ -1497,6 +1497,9 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 	 */
 	if (flags & COPY_FILE_SPLICE) {
 		/* cross sb splice is allowed */
+	} else if (file_in->f_op->fop_flags & FOP_CROSS_TYPE_COPYFILE ||
+		   file_out->f_op->fop_flags & FOP_CROSS_TYPE_COPYFILE) {
+		/* file system understands how to cross FS types */
 	} else if (file_out->f_op->copy_file_range) {
 		if (file_in->f_op->copy_file_range !=
 		    file_out->f_op->copy_file_range)
@@ -1576,10 +1579,12 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * same sb using clone, but for filesystems where both clone and copy
 	 * are supported (e.g. nfs,cifs), we only call the copy method.
 	 */
-	if (!splice && file_out->f_op->copy_file_range) {
-		ret = file_out->f_op->copy_file_range(file_in, pos_in,
-						      file_out, pos_out,
-						      len, flags);
+	if (!splice && (file_in->f_op->copy_file_range || file_out->f_op->copy_file_range)) {
+		ret =  (file_in->f_op->copy_file_range ?
+			file_in->f_op->copy_file_range :
+			file_out->f_op->copy_file_range)(file_in, pos_in,
+							 file_out, pos_out,
+							 len, flags);
 	} else if (!splice && file_in->f_op->remap_file_range && samesb) {
 		ret = file_in->f_op->remap_file_range(file_in, pos_in,
 				file_out, pos_out,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a4af70367f8a..1248a2542758 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2143,6 +2143,10 @@ struct file_operations {
 #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
 /* File system supports uncached read/write buffered IO */
 #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
+/* copy_file_range accepts source and destination on different types of file
+ * system. If set, file_operations.copy_file_range must also be set.
+ */
+#define FOP_CROSS_TYPE_COPYFILE		((__force fop_flags_t)(1 << 8))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
-- 
2.43.0

