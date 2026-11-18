Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795005068;
	b=U55Mk8MEXUhhMlvOfwgpx8vhiPl4eI2CQzXsRLtpP34G56t1ta4uqnhxhWuKRNUpN9X+
	 gXMdcXJGg/LGhjVYh+YypcZsPT9Nj7HIGVK9qyhBt39ib+g4i/JqMuPG091N0Jsv+ZH0y
	 Bt0nZ2l/KPNCW7Z3lstu6jzT+VKi21kGcqXSAwg+/EyC40peURocOQrAaialQGGxxVfUb
	 q+FTcgIiSGtCgesT0ddSXa0TRcLcFtaesolZ76zP0fJr2LpxdqwCt5+RLtNnphA86dZdu
	 jPJOnmY/btARGP8wzerEfWzKujUGtUicaCcCsnq4M09xyPUlxCXO5/SK3ZOMXMngZkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795005068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=f3mUKNslXHJyN3r1VZ+v/0u6IUOCig0wFAdY6LISgJY=;
	b=ler06MVnVGS7O67LIaeeHfr5g/YVogMeYdzNOkZCm4nmL3RaFNSilI0UirVNuqsEXXNB
	 +aI8wcsF0Zt//6qPNyp5EeMraVogZ6VdhYN6YlpqWMZI5PdQ9bJu+F/apRqA0QvCyansw
	 KeAvDHT9PEjMpB/bhMf0+o4sEbyqKaomPZ89hmynAl8jZ69/ZpNdByU1uQKEUy4/ltRzw
	 0GDPs1y5quP2KQklJ6mCeLjxkO26fKFLkrP90o49yCzg2gys+vHv0mIomnrAjr2QJ217f
	 S5SR4YGNUxjM4IKOtMflt03OB2nT7a3Aih0BMV6jWU6Tr3bDDVoxnqJKj5LiJQ07qsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=phf4EbHf;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFE2606A31C
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 12:31:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AFE2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=phf4EbHf
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4cdc606b47so141130866b.0
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 04:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795005067; x=1795609867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f3mUKNslXHJyN3r1VZ+v/0u6IUOCig0wFAdY6LISgJY=;
        b=phf4EbHfHK6Elq4jiB72SmX6wnW/h+OQMvi42cRZdhy5+vAiEVkWvI9oMLnSRUnScn
         EcgcQ2Ug8gSaPg2YSyQOGOaSU/iYwjKGhzKxsTQLVBS1tgr3XFvlv6TkIUJn8Wf3wUj1
         Bvij77qIM5ZEY9nq5Bd2VCyDlELNkZEgamt9PDXYt2mPqbkPW81KO0iXS3hpM/GRJlou
         mRnoovywKSfhB0eOiTJm2HMQp6RUD8h/IdJy+/JXnFcE8ELHvz5Kl4Il3grUE45bc0Xu
         o6DyiaSZoos+msrLch/KWytzcZRzodem8EB2zdreH8959vEIl55Tm4CrECOlG/+9Lo9X
         hhFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795005067; x=1795609867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f3mUKNslXHJyN3r1VZ+v/0u6IUOCig0wFAdY6LISgJY=;
        b=Lm0rvBjyYkYdSBJLQBz0uVdCTee185u18I1/e1XukQ6ubfNcd/IMIFUUaDwJR/Z7iH
         uIGr8NqALtKSFHDiljp6bA21hrJztOLAQTOc0lj2kwhg/y3NuccQGyYaRY3ZIMp1wD5y
         RWBukZCeG+w2cd/qEfF4ZtYO5wFo761IYg1DpxVXuYLK/Rka+PisDgaEpDGfNjgoHUAt
         6tDfrxwNQuJrpppPl2alkyatMsYnNPoz6Gj7rJHsh2OpXW+7KyDt4+epzA9NP1DQPLjm
         TED83w0alHhEVt6JNK6Ezg04WOR0V7R+IWBjFYCjuiGa41QCOU5s4ABBg0K1dSvPlGSx
         KhXw==
X-Forwarded-Encrypted: i=1; AL+hErE42jKIRNPD5knVsulu9t+3zM0OKOyisZVFUpB5uvK8+gRK/ppagkY/lx7fHfwrFYoR80CSeYnqELedPXOd@vger.kernel.org
X-Gm-Message-State: APuU4Z8EOSrZpZxnB3mfQqe4cJAyiYoycQGCUGao4K7UE9/p1exNoJzH
	K91XootB4neh3JcYHiQWgBXvyWoIAV842RRfOMZ9ALetnjasYiZD6ymu
X-Gm-Gg: AYBFou00kvg7RHC0BjzUi0FSqrvhGS+mX6XZZZihviYr76kNGfjfHKmgCm/orvjIG2X
	+cUbYbArv7jB2lvXhWhSDwLxBykg3XJNDU7ZKF4uarZeOHMVbWYf+bVPPXsqrgaPHaOu5DFQ+Fu
	4j1ZYQPIDqacnC3+/WVa3zBc3YZBn6rfYPGlmfTW/63qkAJ4zE8n0Qvt+uHP1oneODQIpYHd4C6
	XUBKnTvBifN9nVP+9cesIgawfS7qQGUvdaW/8WZFIQ9xhveFfl3TjgF57/3iW17LEye11qQyZRn
	H6JT21ZJAtUAxb4yUSNFHmVRYAp7uqYF/AFa3QhTzIOpx9AMxHDi9tiHKyfmfJWQi8zPMXicrNO
	VEJH0rKWvCztRzh569BbwLLUvF+8uzyfADRji43oViHziUZd3W7aItjqLqRbQoGsdxFl6DangqU
	2vuCCXXT+a0px+xTlIhzypvop51gD0E5TrWtQ55HAHtrG+zTpSf0QK+PPankoCEyCmKESjG4/B1
	i7nkKZg9B84cXeHeAC2leXGfidLLCDjclG5mB/3K2tgQmri8MrMx31zKkqyjkrcsvu4AOyNKY8Z
	9qTo4on/js8THsJcaFGC5UZZvR/09CAk/c+zWnVoODXoNnu8vrFppqFfZ9D8L6DNbcjT/2kVt/i
	oukhkknzA02s=
X-Received: by 2002:a17:907:d9f:b0:c2e:4292:d27e with SMTP id a640c23a62f3a-c510e1f6122mr192389966b.22.1795005066567;
        Wed, 18 Nov 2026 04:31:06 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c510cab0335sm88297166b.49.2026.11.18.04.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:31:06 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Ding Feng <dingf3ng@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH v1] fs: add ->f_real() file operation
Date: Wed, 18 Nov 2026 13:31:05 +0100
Message-ID: <20261118123105.1247627-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sync_file_range(2) and cachestat(2) operate on file->f_mapping.  For a
file on a stacking filesystem, such as overlayfs, the data and its page
cache are in the real (backing) file, so on a stacked file
sync_file_range() writes back nothing and cachestat() reports nothing.

Add a ->f_real() file operation, modelled after ->d_real(), and a
file_real() helper in backing-file.h that returns the backing file
holding the data of a stacked file, or the file itself.  file_real() is
a no-op without CONFIG_FS_STACK; otherwise its slow path in
fs/backing-file.c calls ->f_real() and verifies that it returned a
backing file.  The real file is owned by the stacked file, so it is
valid for as long as the caller holds the stacked file.

file_real() is only meant for inspecting and writing back the page cache
of the data.  Operations that need the credentials or permission checks
of the stacking filesystem need a dedicated file operation, like
->fadvise().

Use file_real() in sync_file_range() (also used by io_uring) and in
cachestat(), and implement ->f_real() for overlayfs.

Tested-by: Ding Feng <dingf3ng@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Link: https://lore.kernel.org/r/20261118040056.6543-1-dingf3ng@gmail.com/
Link: https://lore.kernel.org/r/20260623111533.2285005-1-ptikhomirov@virtuozzo.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

Posting the POC as proper patch after Ding has approved that it works.
I hope that this is what you had in mind.

Thanks,
Amir.

Changes since POC:
- Document ->f_real() in vfs.rst and locking.rst
- Add Link, Tested-by and Cc tags

POC: https://lore.kernel.org/r/CAOQ4uxg5baphOjo+_A=3nZBmFEmMV7KOiv_W=rjEVYV41eTEaA@mail.gmail.com/

 Documentation/filesystems/locking.rst |    1 +
 Documentation/filesystems/vfs.rst     |   17 +++++++++++++++++
 fs/backing-file.c                     |   12 ++++++++++++
 fs/overlayfs/file.c                   |   11 +++++++++++
 fs/sync.c                             |    8 ++++++++
 include/linux/backing-file.h          |   26 ++++++++++++++++++++++++++
 include/linux/fs.h                    |    1 +
 mm/filemap.c                          |    9 ++++++++-
 8 files changed, 84 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -485,6 +485,7 @@ prototypes::
 			struct file *file_out, loff_t pos_out,
 			loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	struct file *(*f_real)(const struct file *);
 
 locking rules:
 	All may block.
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1038,6 +1038,7 @@ This describes how the VFS can manipulat
 					   struct file *file_out, loff_t pos_out,
 					   loff_t len, unsigned int remap_flags);
 		int (*fadvise)(struct file *, loff_t, loff_t, int);
+		struct file *(*f_real)(const struct file *);
 		int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 		int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 					unsigned int poll_flags);
@@ -1162,6 +1163,22 @@ otherwise noted.
 ``fadvise``
 	possibly called by the fadvise64() system call.
 
+``f_real``
+	stacking filesystems (e.g. overlayfs) whose file data is accessed
+	through a backing file implement this method to return that backing
+	file.  It is called through file_real() by system calls that operate
+	on the page cache of the data, such as sync_file_range(2) and
+	cachestat(2).
+
+	The returned file must be a backing file (FMODE_BACKING) or the file
+	itself.  It is owned by the file and must remain valid for as long
+	as the caller holds a reference to the file.
+
+	The returned file is only used to inspect and write back the page
+	cache of the data.  Operations that need the credentials or the
+	permission checks of the stacking filesystem need a dedicated file
+	operation (e.g. ``fadvise``).
+
 ``mmap_prepare``
 	Called by the mmap(2) system call. Allows a VFS to set up a
 	file-backed memory mapping, most notably establishing relevant
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1960,6 +1960,7 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	struct file *(*f_real)(const struct file *);
 	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
--- a/include/linux/backing-file.h
+++ b/include/linux/backing-file.h
@@ -40,5 +40,31 @@ ssize_t backing_file_splice_write(struct
 				  struct backing_file_ctx *ctx);
 int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 		      struct backing_file_ctx *ctx);
+struct file *__file_real(struct file *file);
+
+/**
+ * file_real - Return the real file hosting the data
+ * @file: the file to query
+ *
+ * If @file is on a stacking filesystem (e.g. overlayfs) whose data is
+ * accessed through a backing file, return that backing file.
+ * Otherwise return @file itself.
+ *
+ * The returned file is owned by @file and is valid for as long as the
+ * caller holds a reference to @file.
+ *
+ * The real file is only meant to be used for inspecting and writing
+ * back the page cache of the data (e.g. sync_file_range(2), cachestat(2)).
+ * It must not be used for operations that require the credentials or the
+ * permission checks of the stacking filesystem; those need a dedicated
+ * file operation (e.g. ->fadvise()).
+ */
+static inline struct file *file_real(struct file *file)
+{
+	if (!IS_ENABLED(CONFIG_FS_STACK) || likely(!file->f_op->f_real))
+		return file;
+
+	return __file_real(file);
+}
 
 #endif /* _LINUX_BACKING_FILE_H */
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -102,6 +102,18 @@ struct file *backing_tmpfile_open(const
 }
 EXPORT_SYMBOL(backing_tmpfile_open);
 
+/* Slow path of file_real() for a file with ->f_real() */
+struct file *__file_real(struct file *file)
+{
+	struct file *real_file = file->f_op->f_real(file);
+
+	if (!IS_ERR(real_file) && real_file != file &&
+	    WARN_ON_ONCE(!(real_file->f_mode & FMODE_BACKING)))
+		return ERR_PTR(-EIO);
+
+	return real_file;
+}
+
 struct backing_aio {
 	struct kiocb iocb;
 	refcount_t ref;
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/backing-file.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/namei.h>
@@ -269,6 +270,13 @@ int sync_file_range(struct file *file, l
 	if (!S_ISREG(i_mode) && !S_ISBLK(i_mode) && !S_ISDIR(i_mode))
 		goto out;
 
+	/* The page cache of a stacked file is in its real file */
+	file = file_real(file);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto out;
+	}
+
 	mapping = file->f_mapping;
 	ret = 0;
 	if (flags & SYNC_FILE_RANGE_WAIT_BEFORE) {
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -31,6 +31,7 @@
 #include <linux/hash.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
+#include <linux/backing-file.h>
 #include <linux/folio_batch.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
@@ -4782,6 +4783,7 @@ SYSCALL_DEFINE4(cachestat, unsigned int,
 		struct cachestat __user *, cstat, unsigned int, flags)
 {
 	CLASS(fd, f)(fd);
+	struct file *real_file;
 	struct address_space *mapping;
 	struct cachestat_range csr;
 	struct cachestat cs;
@@ -4804,11 +4806,16 @@ SYSCALL_DEFINE4(cachestat, unsigned int,
 	if (flags != 0)
 		return -EINVAL;
 
+	/* The page cache of a stacked file is in its real file */
+	real_file = file_real(fd_file(f));
+	if (IS_ERR(real_file))
+		return PTR_ERR(real_file);
+
 	first_index = csr.off >> PAGE_SHIFT;
 	last_index =
 		csr.len == 0 ? ULONG_MAX : (csr.off + csr.len - 1) >> PAGE_SHIFT;
 	memset(&cs, 0, sizeof(struct cachestat));
-	mapping = fd_file(f)->f_mapping;
+	mapping = real_file->f_mapping;
 	filemap_cachestat(mapping, first_index, last_index, &cs);
 
 	if (copy_to_user(cstat, &cs, sizeof(struct cachestat)))
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -195,6 +195,16 @@ static struct file *ovl_real_file(const
 	return ovl_real_file_path(file, &realpath);
 }
 
+/*
+ * The real file that holds the page cache of the data: the upper file after
+ * copy up, otherwise the lower data file.  After copy up of a file that was
+ * opened from lower, this opens the upper file, just like a write would.
+ */
+static struct file *ovl_f_real(const struct file *file)
+{
+	return ovl_real_file(file);
+}
+
 static int ovl_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file_dentry(file);
@@ -656,6 +666,7 @@ const struct file_operations ovl_file_op
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
+	.f_real		= ovl_f_real,
 	.flush		= ovl_flush,
 	.splice_read    = ovl_splice_read,
 	.splice_write   = ovl_splice_write,
