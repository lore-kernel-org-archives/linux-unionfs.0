Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3869922F01
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892738; cv=none; b=Xl5SAjfZUJnzeiG/XWbI+sd8QPS5ATE0nThT64gKJvXAoiC6nTwm7XFelMMUsI0VmUUHXJjPt+vQvu+ON7MuG2kJ+P92iGinaB7REtGZ2V31PHF83AYCm6YuOtcnldym8gH52DOLwPE2jFjvbQm8a9k5LdVsSoBloYuVzzZ9OzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892738; c=relaxed/simple;
	bh=7s7v6Q7Q18XwchqsnnBg1CXLt/ALd9UFDwaTvhxe7+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdjL7dwsHjR5KKLcrYZATBoVYF26Fz7F+4eJTz2DWkWVy8otEo/u9JbAFqybhbPmWSEZ74HGDljxin/6xZMOEZ1UMcxb5NYbJmxzXOzGdLBu3nVtyjdMjWY88jWyhn9pB6r9iOZBDcmewTzWJL3E6S0dejZhDCVziNNopoK6qBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EYRtcjZP; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EYRtcjZP"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7bd5e373d07so581177b3.2
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892736; x=1779497536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s36eFAIzmg/AD7FCSec4sHSYl3AeGXkpY8SXdTrFSxg=;
        b=EYRtcjZP/3/qcTbzWZ+zuyLZCUYV/vZ0kg8bLJcp7amqQnuSlV5l5JNm5wof6T8B7B
         EWOBKfLgiH17tcTwAHxaBQammwVK/8i+uAWjTfyy/4QyobN9gfpJfA6H5to4bdXzvRyo
         y7VbaOzgX/iMkQWGxs+lQI/bWyX1uoq8K5vgFfNhorCx7hpgs0UeIkeiCCwSrh/RNewY
         szkw/JdCwTX7RhXOq1hfsiQ8wSJHqGGIvfCGrocAr0JfiGdozQwDyhtV+VkyB7/tprVN
         wYI99+MYyGdXvbn3B/VEeSZHPWMn5XvSUstVDvlE6za1j2B8JdACPyFaP3XB6LE/C4qK
         ID9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892736; x=1779497536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s36eFAIzmg/AD7FCSec4sHSYl3AeGXkpY8SXdTrFSxg=;
        b=U6SF1CqcKlZRZYN5OKLclfE5yi7QV848pOh4YXupQomOKJKnOBHomMQrRIsKK9fbrd
         eB+MQPd9js4G6zSnbBnpreO/+dEzOYhPzTr4lf9M6t+ISui76ycHmJzJd9xsvsroJgIy
         QadeB+6FYgl3Meim9OAWijqgkBwfSCQqGM5r+g6quV499HzdRF2adZz9ccBFfsUJH9BU
         LtEkWKChy85aqlPKAICtaiNaBpmhp4p2u/QS39+yQGKpnlBvNgSHvHtes0F2Te3zo/dh
         ovnxEKopLff4kWlxgq7HgBxwc8CNxPCwwi188icp1H2JaL281r38jl9e5mPumrci10Qv
         E3OQ==
X-Forwarded-Encrypted: i=1; AFNElJ8jFNEqyx0hWvam1lcLDkaXekC4K3O4rQukVZSwZAE35yn5GO+O8dd+nsvtjEEF11GRAeKya4tXpHqTqWAP@vger.kernel.org
X-Gm-Message-State: AOJu0YzppMshPqXY+LME46Kofp6kBV7RcQ60fFux9LAS2QaLVd05eBve
	KLN6fAyiwPCNZvcE4fTJt8Mm4FrgEUY+3gaddfoqLhvvcd6y0PGHwWpR
X-Gm-Gg: Acq92OHa7QCZ1Grxgb20RLOlzrWWSmOx6w0AMlyknQE20yxlExBQydCFKBMDfyIMLS+
	X6SVCA1WjP6Yr6VgLuxyX1Z2SoDW9JEN1L7p8gg4kLQfwQ0tER+LdLfi6M1GAw9xwecBBt5Qdbp
	Lm5BT8UkPURGqc9woTtnr1XO5hm19jAek9MyDvigMWty5bN3ru8iY2EG+Hl/imjuUlPi8cVNVGg
	YcCOy6Pg+29j384vy6RXNgbCmSm0/zouiYJU8VKJOcU9Ki1jdY2PgEhQkN/9LFvIabkl3BHv4n8
	qn2wE+e4QYLExr0giKuB+dCtFZX82Az0VV0LDN4BjnoZn/ibVkn4SgAsyMXpAChmCqIpZRJg9AH
	S7RZvY4FqPe37+x1VHUlYK4i+VJB+EdtaxXU3ljTmgS2fh2XfLjkb6xx7Zce0pEGzr1gqZBkhBL
	dCZWherOUYrFY24ALb/sq3
X-Received: by 2002:a05:690c:6811:b0:7b3:c611:7ef5 with SMTP id 00721157ae682-7c958ecab11mr75160067b3.6.1778892736378;
        Fri, 15 May 2026 17:52:16 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:28::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f55b85edsm37657617b3.35.2026.05.15.17.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:15 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 01/21] fuse: introduce FUSE_PASSTHROUGH_INO mode
Date: Fri, 15 May 2026 17:39:44 -0700
Message-ID: <20260516004004.1455526-2-joannelkoong@gmail.com>
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

This is a more strict variant of FUSE_PASSTHROUGH mode, in which the
backing file inode number must match the fuse inode number.

This mode will allow the kernel to instantiate fuse inodes by
passthrough lookup and passthrough readdirplus and notify about those
inodes to the server, using the backing file inode number as a unique
identifier for fuse inodes across kernel and server.

This mode limits the possibility to map multiple fuse inodes to the same
backing file, unless they are all hardlinks.

This mode is only supported on 64bit arch, where ino_t is u64.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/fuse/file.c            |  3 +--
 fs/fuse/fuse_i.h          |  6 ++++--
 fs/fuse/inode.c           |  8 +++++++-
 fs/fuse/iomode.c          | 13 ++++++++++---
 include/uapi/linux/fuse.h |  6 +++++-
 5 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7a35ac3e0023..06dc8cfe3c7b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1429,7 +1429,6 @@ static void fuse_dio_lock(struct kiocb *iocb, struct iov_iter *from,
 			  bool *exclusive)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	*exclusive = fuse_dio_wr_exclusive_lock(iocb, from);
 	if (*exclusive) {
@@ -1444,7 +1443,7 @@ static void fuse_dio_lock(struct kiocb *iocb, struct iov_iter *from,
 		 * have raced, so check it again.
 		 */
 		if (fuse_io_past_eof(iocb, from) ||
-		    fuse_inode_uncached_io_start(fi, NULL) != 0) {
+		    fuse_inode_uncached_io_start(inode, NULL) != 0) {
 			inode_unlock_shared(inode);
 			inode_lock(inode);
 			*exclusive = true;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 3a7ac74a23ed..0b925ac3e195 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -698,6 +698,9 @@ struct fuse_conn {
 	/** @passthrough: Passthrough support for read/write IO */
 	unsigned int passthrough:1;
 
+	/** @passthrough_ino: One-to-one mapping between fuse ino to backing ino */
+	unsigned int passthrough_ino:1;
+
 	/** @use_pages_for_kvec_io: Use pages instead of pointer for kernel I/O */
 	unsigned int use_pages_for_kvec_io:1;
 
@@ -1237,8 +1240,7 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 
 /* iomode.c */
 int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
-int fuse_inode_uncached_io_start(struct fuse_inode *fi,
-				 struct fuse_backing *fb);
+int fuse_inode_uncached_io_start(struct inode *inode, struct fuse_backing *fb);
 void fuse_inode_uncached_io_end(struct fuse_inode *fi);
 
 int fuse_file_io_open(struct file *file, struct inode *inode);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 33009227e91d..b2a5892a4dc3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1397,6 +1397,8 @@ static void process_init_reply(struct fuse_args *args, int error)
 				fc->passthrough = 1;
 				fc->max_stack_depth = arg->max_stack_depth;
 				fm->sb->s_stack_depth = arg->max_stack_depth;
+				if (flags & FUSE_PASSTHROUGH_INO)
+					fc->passthrough_ino = 1;
 			}
 			if (flags & FUSE_NO_EXPORT_SUPPORT)
 				fm->sb->s_export_op = &fuse_export_fid_operations;
@@ -1476,8 +1478,12 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
 #endif
 	if (fm->fc->auto_submounts)
 		flags |= FUSE_SUBMOUNTS;
-	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
+	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH)) {
 		flags |= FUSE_PASSTHROUGH;
+		/* one-to-one ino mapping requires 64bit ino */
+		if (sizeof(ino_t) == sizeof(u64))
+			flags |= FUSE_PASSTHROUGH_INO;
+	}
 
 	/*
 	 * This is just an information flag for fuse server. No need to check
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index 3728933188f3..ca3b28597722 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -82,8 +82,10 @@ static void fuse_file_cached_io_release(struct fuse_file *ff,
 }
 
 /* Start strictly uncached io mode where cache access is not allowed */
-int fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_backing *fb)
+int fuse_inode_uncached_io_start(struct inode *inode, struct fuse_backing *fb)
 {
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_backing *oldfb;
 	int err = 0;
 
@@ -94,6 +96,12 @@ int fuse_inode_uncached_io_start(struct fuse_inode *fi, struct fuse_backing *fb)
 		err = -EBUSY;
 		goto unlock;
 	}
+	/* With FUSE_PASSTHROUGH_INO, fuse and backing ino must match */
+	if (fb && fc->passthrough_ino &&
+	    fb->file->f_inode->i_ino != inode->i_ino) {
+		err = -EIO;
+		goto unlock;
+	}
 	if (fi->iocachectr > 0) {
 		err = -ETXTBSY;
 		goto unlock;
@@ -117,10 +125,9 @@ static int fuse_file_uncached_io_open(struct inode *inode,
 				      struct fuse_file *ff,
 				      struct fuse_backing *fb)
 {
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	int err;
 
-	err = fuse_inode_uncached_io_start(fi, fb);
+	err = fuse_inode_uncached_io_start(inode, fb);
 	if (err)
 		return err;
 
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index c13e1f9a2f12..4be9ccc5b3ff 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -240,6 +240,9 @@
  *  - add FUSE_COPY_FILE_RANGE_64
  *  - add struct fuse_copy_file_range_out
  *  - add FUSE_NOTIFY_PRUNE
+ *
+ *  7.46
+ *  - add FUSE_PASSTHROUGH_INO
  */
 
 #ifndef _LINUX_FUSE_H
@@ -275,7 +278,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 45
+#define FUSE_KERNEL_MINOR_VERSION 46
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -495,6 +498,7 @@ struct fuse_file_lock {
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
 #define FUSE_OVER_IO_URING	(1ULL << 41)
 #define FUSE_REQUEST_TIMEOUT	(1ULL << 42)
+#define FUSE_PASSTHROUGH_INO	(1ULL << 43)
 
 /**
  * CUSE INIT request/reply flags
-- 
2.52.0

