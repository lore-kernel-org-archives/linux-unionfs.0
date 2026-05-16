Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81D72E414
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892743; cv=none; b=t7mJWL18tzO0dJdYYvPjHVEvt/fzSIU3x6B2EwPMMJpqu9smawGMMlqP1qKQxkggloWXyiIPmVGCNeJQI6E7q0lckfSDJ3FiRb4PiJ69lzjFzdp4uE00gMWIBEjkgSZa+ePUKzkbeu6XwyZpANVkKsb/a2X1ezD63PUd4bqSQI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892743; c=relaxed/simple;
	bh=10D0ja0jF1GRSukhZRjVHm4xdQKInIOaKWH83rqfQHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/gUwYvdHSPSPbLtetBWhnUwqkKWU3Hd4XyCUHDnUUiz5jtWTu06PXArXFJJbkv7n5Uu1+IsuNKqBVxfUeuhJNLvDU6/gtM2zSXKxZR7YWI4nmTIGpPu4YRA2yZ8Fa5qW6g6JPky5BsFAPSIyjblqXg2zo+yxRGLXvCtx6fG7HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKISfjiv; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKISfjiv"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7c04749d739so434947b3.3
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892741; x=1779497541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sABNTlcrpy8GkKAinGpMmGxZyagpdpaCZg/KPONrsY=;
        b=IKISfjivt1C1Gw3Jp/wi9zlZbIciwuEa74+6Zul9nMTGZ3XUXYUb7TmPSQ38v3TngH
         zJhi4KCkpqNiRTionEzCbLtHCwOXGz4XGODWhtXi31oS+ASGmADZG4JKqC+DV9lr3oys
         8oBH3oAKb41zov/QPGfmpkZ7ikvGx5MCeivJNfCNxC9iGtvllPZAoGZtp5D3mKd49GAW
         IU1J14lqc0nWhHDlmQafaa/LjICWTUJpMcXqa8JN9Ah3hNXEBAHQrTQl/28nrCoZOY98
         griM31o8udKXC0jFtAIv2JyHxTUcZvlRg4tmy5DhewQ6AK6qFXCRF1jTMmnsG9hMy2Em
         /rqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892741; x=1779497541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0sABNTlcrpy8GkKAinGpMmGxZyagpdpaCZg/KPONrsY=;
        b=dNpLKmStdGZM1OF+QnXU5n2S81L31EKOybBaBTkRpYjLakrUCpXz7oO42HAYlWam+r
         dCfFf7djETP090BT7ywcTvTh32GdSCzR16iP/835eig1IAPuZEHf9rgaJN1GiJFWc3Qt
         Bqzk+g3qtxPckhRxCgHTkOfyknGlBfdpJ1/0BBU3Pg12Qp1ILKxzT4+8asmkN2lfQ752
         xFAeERqQh/W33uPozhOvtWg3JqWibhQlE2WErhrZ5derkwNqlldfVilEd+0bkLDoDnTH
         ufxYOvxN0gnSlGVXVzDqa0wGGJPlcuk4BEoB9chfI/xw432GdOsPwCg8Ai9Ddg+Eipri
         Ekpg==
X-Forwarded-Encrypted: i=1; AFNElJ8p6s3wlzFTYyKfADdFWlwTgPW6YcvT6CiXvZQyPsSVhw2froKTnaekdwkFmrqhaLyKCxPdqFdMz+qT/na4@vger.kernel.org
X-Gm-Message-State: AOJu0YxnzF48U3UAOZPzEvOFj+F7gapN8d7TClDEDeNT5+Ni5afEQJXl
	wLJdB0zquqWZj5NJiR7SYhYLO47LrkmRb0Teo8zt3wDV2drN0RYJoL+n
X-Gm-Gg: Acq92OE8rBL3qpXgsHP1bjE8y18mWf5AIDdOun56/ROFgOoTU609elLXO6Eo8uERrIM
	Ei9J6MDRreYWkSum/xmu3x4wCblRksJFkcwYQoY8SDIUun1s0l6wpEDyLMo24QXirGuVOHGDUUO
	nCSAgCrL3T3BiOytHJ/9Cn+jfvMTeb+Vr4x12frYBJVVckNSU6Hw2okA4MFd8d7tNn0MHce2F6Q
	s3tDVggh+su5wvgiIVUk16Nmm7fXmYpjpc9oJ+V7JwgSrI3P6+MTmAeRQxitNrPjmoD7+VLc+Vx
	of77FKrM4Fqo1zs+jM4+X1wWMTwzw/mI3EuItmDuta0hU9MR46kuDQZhu2dP6FjlE/VF8zd9uq3
	pWw99BCfo0ndwM3gCZO5lkL0vVqPkdrdp1BzeRqjR+u7JKWLfuoNO8Q0VvtyMuolLL+EozpQYuv
	jVdkAG+xqk3brg+vjAqn0=
X-Received: by 2002:a05:690c:9304:b0:7ba:fdc5:17e4 with SMTP id 00721157ae682-7c95a087a3bmr61536887b3.22.1778892740736;
        Fri, 15 May 2026 17:52:20 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f28b2d44sm38058107b3.11.2026.05.15.17.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:19 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 02/21] fuse: prepare for passthrough of inode operations
Date: Fri, 15 May 2026 17:39:45 -0700
Message-ID: <20260516004004.1455526-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260516004004.1455526-1-joannelkoong@gmail.com>
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

So far, fuse passthrough was implemented for read/write/splice/mmap
operations for regular files opened with FOPEN_PASSTHROUGH.

A backing file is attached to a fuse inode, but only for as long as
there are FOPEN_PASSTHROUGH files opened on this inode.

We would like to attach a backing file to fuse inode also without an
open file to allow passthrough of some inode operations.

Add field ops_mask to the input argument of FUSE_DEV_IOC_BACKING_OPEN
ioctl to declare the operations that would passthrough to the backing
file once it has been attached to the fuse inode on lookup.

Setting the FUSE_READ/FUSE_WRITE operations in the ops_mask is not
required because those operations are implied by FOPEN_PASSTHROUGH.

When setting operations other than FUSE_READ/FUSE_WRITE in ops_mask,
non-regular backing files are allowed, so we need to verify when
attaching a backing file to a fuse inode, that their file types match.

For simplification of inode attribute caching, for now, require a
filesystem with FUSE_PASSTHROUGH_INO (one-to-one mapping from fuse inode
to backing inode) for setting up passthrough of any inode operations.
We may consider relaxing this requirement for some inode operations
in the future.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/fuse/backing.c         | 13 ++++++++++---
 fs/fuse/fuse_i.h          | 30 ++++++++++++++++++++++++++++++
 fs/fuse/iomode.c          | 16 ++++++++++++++++
 include/uapi/linux/fuse.h |  9 ++++++++-
 4 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 3d3f49c2dd42..1fbb4d876eec 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -87,7 +87,8 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 	struct fuse_backing *fb = NULL;
 	int res;
 
-	pr_debug("%s: fd=%d flags=0x%x\n", __func__, map->fd, map->flags);
+	pr_debug("%s: fd=%d flags=0x%x ops_mask=0x%llx\n", __func__,
+		 map->fd, map->flags, map->ops_mask);
 
 	/* TODO: relax CAP_SYS_ADMIN once backing files are visible to lsof */
 	res = -EPERM;
@@ -95,7 +96,11 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 		goto out;
 
 	res = -EINVAL;
-	if (map->flags || map->padding)
+	if (map->flags || map->ops_mask & ~FUSE_BACKING_MAP_VALID_OPS)
+		goto out;
+
+	/* For now passthrough inode operations requires FUSE_PASSTHROUGH_INO */
+	if (!fc->passthrough_ino && map->ops_mask & FUSE_PASSTHROUGH_INODE_OPS)
 		goto out;
 
 	file = fget_raw(map->fd);
@@ -105,7 +110,8 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 
 	/* read/write/splice/mmap passthrough only relevant for regular files */
 	res = d_is_dir(file->f_path.dentry) ? -EISDIR : -EINVAL;
-	if (!d_is_reg(file->f_path.dentry))
+	if (!(map->ops_mask & ~FUSE_PASSTHROUGH_RW_OPS) &&
+	    !d_is_reg(file->f_path.dentry))
 		goto out_fput;
 
 	backing_sb = file_inode(file)->i_sb;
@@ -120,6 +126,7 @@ int fuse_backing_open(struct fuse_conn *fc, struct fuse_backing_map *map)
 
 	fb->file = file;
 	fb->cred = prepare_creds();
+	fb->ops_mask = map->ops_mask;
 	refcount_set(&fb->count, 1);
 
 	res = fuse_backing_id_alloc(fc, fb);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 0b925ac3e195..8e54dc7d56af 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -92,6 +92,7 @@ struct fuse_submount_lookup {
 struct fuse_backing {
 	struct file *file;
 	struct cred *cred;
+	u64 ops_mask;
 
 	/* refcount */
 	refcount_t count;
@@ -254,6 +255,8 @@ enum {
 	 * or the fuse server has an exclusive "lease" on distributed fs
 	 */
 	FUSE_I_EXCLUSIVE,
+	/* Has backing file for inode ops passthrough */
+	FUSE_I_PASSTHROUGH,
 };
 
 struct fuse_conn;
@@ -1252,6 +1255,25 @@ struct fuse_file *fuse_file_open(struct fuse_mount *fm, u64 nodeid,
 void fuse_file_release(struct inode *inode, struct fuse_file *ff,
 		       unsigned int open_flags, fl_owner_t id, bool isdir);
 
+/* passthrough.c */
+
+/* READ/WRITE are implied by FOPEN_PASSTHROUGH, but defined for completeness */
+#define FUSE_PASSTHROUGH_RW_OPS \
+	(FUSE_PASSTHROUGH_OP_READ | FUSE_PASSTHROUGH_OP_WRITE)
+
+/* File passthrough operations require a file opened with FOPEN_PASSTHROUGH */
+#define FUSE_PASSTHROUGH_FILE_OPS \
+	(FUSE_PASSTHROUGH_RW_OPS)
+
+/* Inode passthrough operations for backing file attached to inode */
+#define FUSE_PASSTHROUGH_INODE_OPS (0)
+
+#define FUSE_BACKING_MAP_OP(map, op) \
+	((map)->ops_mask & FUSE_PASSTHROUGH_OP(op))
+
+#define FUSE_BACKING_MAP_VALID_OPS \
+	(FUSE_PASSTHROUGH_FILE_OPS | FUSE_PASSTHROUGH_INODE_OPS)
+
 /* backing.c */
 #ifdef CONFIG_FUSE_PASSTHROUGH
 struct fuse_backing *fuse_backing_get(struct fuse_backing *fb);
@@ -1319,6 +1341,14 @@ ssize_t fuse_passthrough_splice_write(struct pipe_inode_info *pipe,
 				      size_t len, unsigned int flags);
 ssize_t fuse_passthrough_mmap(struct file *file, struct vm_area_struct *vma);
 
+static inline bool fuse_passthrough_op(struct inode *inode, enum fuse_opcode op)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_backing *fb = fuse_inode_backing(fi);
+
+	return fb && fb->ops_mask & FUSE_PASSTHROUGH_OP(op);
+}
+
 #ifdef CONFIG_SYSCTL
 extern int fuse_sysctl_register(void);
 extern void fuse_sysctl_unregister(void);
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index ca3b28597722..5517711a3eca 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -96,6 +96,11 @@ int fuse_inode_uncached_io_start(struct inode *inode, struct fuse_backing *fb)
 		err = -EBUSY;
 		goto unlock;
 	}
+	/* fuse and backing file types must match */
+	if (fb && ((fb->file->f_inode->i_mode ^ inode->i_mode) & S_IFMT)) {
+		err = -EIO;
+		goto unlock;
+	}
 	/* With FUSE_PASSTHROUGH_INO, fuse and backing ino must match */
 	if (fb && fc->passthrough_ino &&
 	    fb->file->f_inode->i_ino != inode->i_ino) {
@@ -176,6 +181,7 @@ static int fuse_file_passthrough_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_backing *fb;
 	int err;
 
@@ -188,11 +194,21 @@ static int fuse_file_passthrough_open(struct inode *inode, struct file *file)
 	if (IS_ERR(fb))
 		return PTR_ERR(fb);
 
+	/*
+	 * Inode ops passthrough requires backing file setup at
+	 * creation/lookup time.
+	 */
+	err = -EOPNOTSUPP;
+	if (!fuse_inode_backing(fi) &&
+	    (fb->ops_mask & FUSE_PASSTHROUGH_INODE_OPS))
+		goto fail;
+
 	/* First passthrough file open denies caching inode io mode */
 	err = fuse_file_uncached_io_open(inode, ff, fb);
 	if (!err)
 		return 0;
 
+fail:
 	fuse_passthrough_release(ff, fb);
 	fuse_backing_put(fb);
 
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 4be9ccc5b3ff..0f1e1c1ec367 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -243,6 +243,7 @@
  *
  *  7.46
  *  - add FUSE_PASSTHROUGH_INO
+ *  - add ops_mask field to struct fuse_backing_map
  */
 
 #ifndef _LINUX_FUSE_H
@@ -1133,9 +1134,15 @@ struct fuse_notify_prune_out {
 struct fuse_backing_map {
 	int32_t		fd;
 	uint32_t	flags;
-	uint64_t	padding;
+	uint64_t	ops_mask;
 };
 
+#define FUSE_PASSTHROUGH_OP(op)	(1ULL << ((op) - 1))
+
+/* op bits for fuse_backing_map ops_mask */
+#define FUSE_PASSTHROUGH_OP_READ	FUSE_PASSTHROUGH_OP(FUSE_READ)
+#define FUSE_PASSTHROUGH_OP_WRITE	FUSE_PASSTHROUGH_OP(FUSE_WRITE)
+
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
 #define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
-- 
2.52.0

