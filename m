Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352193BAD90
	for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014808; cv=none; b=NKQsOb/fARjtnvudNaLdQe9v0BMxLoWo0Zt++IyWaZlpNq5TDiNxDeYhCJmYz7INBd+MbDAG3hxsR+46YN0di71qB3xteyJNsgKSkJY3+UejqgNFGEnDaox8ztWVR0WOrabje0BOcdgOY3dbmWuHeRPiP8x3/A+ztJw7crY23Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014808; c=relaxed/simple;
	bh=yHl+B1AOud++XfXBqYXRiSpYxbw9Mct48dzUUXuIwiM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rFrHQe5i/o83Pv4Hty0xR5nVErsIk1uVLTZxTJJ4fqD/TOeKwOCIHJF/syomDScnR7QfQimnI1+LR69ud6lyy4YiSL5sr3TpKjSMe0TlQxpdqbokcFXqGzaXNHqhXrMV3U+/srz8drXK5tvMHfN6rqblC6yVOgEHkK3+S0xiRZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQ8+NpdR; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQ8+NpdR"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-668c60b8f45so1826183a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 06:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774014797; x=1774619597; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Pm+eEQ60JIMUuvkrTDt/cbZSgeK8toOkUpeH6Q+x4Q=;
        b=lQ8+NpdRNpBmTNr0z2RMtUshCgJBYMxf4VdYNA89vClT3bhdCL48qsc0/9ckuGWm1Z
         a+p2YC7MPE4z66QfLXUXcSGmvHOmAP6oGQ+mewg9+aammukc/t9VKuxq2pzt3e/hTtMo
         ryYvgCQSg52PvVkd3V72pebcmulb9wnrNBcgPiN3Kp8SEkSDm5K9sxDLGBipE/2KSvz5
         sDE4+LQwz3ejM+WTfKWUQIoC9unR8zGtxinsxAKr2dHP0gCWzcgdZGGsA5rZkwYEPAf5
         wy8qZ1sHgRBlq2ajL1biCVtDHMPJYUw5LqhmHREedYfLlbeZvfQDIgxd1OPHq3kLEi1f
         RL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774014797; x=1774619597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Pm+eEQ60JIMUuvkrTDt/cbZSgeK8toOkUpeH6Q+x4Q=;
        b=lIq1pemcstu0stXKisZY6xOVhKvfU3fWzlLIsq/+BpbED42zlpPDuEdJodQCEFld7k
         zpV0w52V6/hwa8M8cPg+VsihEdKBpFBa7/VPcRhWqvaZAuPO7uKsIpgp8Tzbfy/6Jyps
         6hfy4e0mPeOHgjpjo+W8WCbOzNA864FRvZO9Ntbid8BY3h+HTpMFxlFNOTVjVvgfQ1tS
         mKlJ6urIawWvauq3DarzaJh9CCPccN7L+DRcMsFif43rnLmEyVX3elsN1xzQw0pvcpK6
         yWoGjpHyEoNBHL2rdHXvNXaiD0u2twMqWAImcRuSCoM6lFERp3oW/F6odYHO6tuxKdRU
         6Q6w==
X-Forwarded-Encrypted: i=1; AJvYcCVIUk4i5Ocz7ged68GJxG7WZt/pm+nlY8gQVbZcaByL7xiT1Ku8ThF0cXIVMz0svkluqQiESzyrzojziixN@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv+MgtfAMe3+Ra8XPhSuV3MtaT1Um6mu/prRew1u0lbj3HuKJc
	rKri9Kp/yaIjZUl82/X4KHZRDAr2N9GPaJrsW48rnIJj6M3G21TLVP1B
X-Gm-Gg: ATEYQzw37k9fV1ONYuks3y9URWv2Y5RkQuLzQUzJkGu/xIgWX6Jmo4eYHM7QXd+BEqp
	+LdAgEGuyeX1YNdsF32UbrQSPwWcr6ruNe5bDVUtBkoSdZYP1R1y9YQvwFsAkUtqSU+D4qwA8UK
	ahwtNAUv8iNkqdFbGDsDGgrBeEIEnNQi5RcH5nbo1RP/MCCbXeDCocg3VRXcEB6KpZ6wQRs7eA0
	Ysh6Wgur9KEFUwV5NuHfftGsKrfXJcBqu/dZ2y7QCBSb3jX+tNvJZQTrUOqxQdcgzjeKvsUYCDF
	VmWqJaFHPM+6LUIe6LCIqNqmm7Q0HplktL5Q/arxz1bjhMSbBxoUtxniMfNNnC+bQOUISbB3Vn0
	JO7JbE/d967Zfi0UXzgQxKfE7LLwoI2fzWfTlbSad36tveMhjCXuJy9T0ROkEIuqfXKoC9Yd29r
	JOd2UodjmJsbhyXj0ppz1mwkG8wIPE+5oR5kOJ0+DALdog0/AyDjFPBSknXAV+J+As5xVgGfkVt
	jrHWD3qO1cu4tPi6VM5j3Q61wgf
X-Received: by 2002:a17:907:c70c:b0:b96:eb7e:bc55 with SMTP id a640c23a62f3a-b982f1edf01mr232203466b.10.1774014796546;
        Fri, 20 Mar 2026 06:53:16 -0700 (PDT)
Received: from localhost (2001-1c00-570d-ee00-e98d-b8f7-8d95-53b2.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:e98d:b8f7:8d95:53b2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b983365a159sm158826466b.44.2026.03.20.06.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 06:53:16 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Paul Moore <paul@paul-moore.com>,
	Gao Xiang <xiang@kernel.org>,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v7] backing_file: store an internal O_PATH user_path_file
Date: Fri, 20 Mar 2026 14:53:15 +0100
Message-ID: <20260320135315.1731572-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of storing the user_path, store an internal O_PATH file,
embedded in the backing_file struct for the user_path with a copy of
the original user file creds and with an independent a security context.

This internal O_PATH file is going to be used by LSM mprotect hooks
to check the permissions to mprotect against a copy of the original
mmaped file credentials.

The internal user_path_file is only exported as a const pointer and
its refcnt is initialized to FILE_REF_DEAD, because it is not an actual
refcounted object.  The file_ref_init() helper was changed to accept
the FILE_REF_ constant instead of the fake +1 integer count.

The internal O_PATH file is opened using a new kernel helper
kernel_path_file_open(), which skips all the generic code in
do_dentry_open() and does only the essentials, so that the internal
O_PATH file could be opened with a negative dentry.

This is needed for backing_tmpfile_open() to open a backing O_PATH
tmpfile before instantiating the dentry.
The callers of backing_tmpfile_open() are responsible for calling
backing_tmpfile_finish() after making the path positive.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

7th time is a charm (?).

Here is another try to introduce backing_file_user_path_file(),
after dealing with the the syzbot report [1] v6 [2] introduces.

Thanks,
Amir.

Changes since v6:
- Create helper for internal O_PATH open with negative path
- Create backing_tmpfile_finish() API to fixup the negative path

[1] https://syzkaller.appspot.com/bug?extid=f34aab278bf5d664e2be
[2] https://lore.kernel.org/linux-fsdevel/20260318131258.1457101-1-amir73il@gmail.com/

 fs/backing-file.c            | 32 +++++++++++-------
 fs/erofs/ishare.c            | 13 ++++++--
 fs/file_table.c              | 63 +++++++++++++++++++++++++++++-------
 fs/fuse/passthrough.c        |  3 +-
 fs/internal.h                | 12 +++++--
 fs/open.c                    | 34 ++++++++++++++++---
 fs/overlayfs/dir.c           |  5 ++-
 fs/overlayfs/file.c          |  1 +
 include/linux/backing-file.h | 30 +++++++++++++++--
 include/linux/file_ref.h     |  4 +--
 10 files changed, 159 insertions(+), 38 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 45da8600d5644..77935c93333ab 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/backing-file.h>
 #include <linux/splice.h>
+#include <linux/uio.h>
 #include <linux/mm.h>
 
 #include "internal.h"
@@ -18,9 +19,10 @@
 /**
  * backing_file_open - open a backing file for kernel internal use
  * @user_path:	path that the user reuqested to open
+ * @user_cred:	credentials that the user used for open
  * @flags:	open flags
  * @real_path:	path of the backing file
- * @cred:	credentials for open
+ * @cred:	credentials for open of the backing file
  *
  * Open a backing file for a stackable filesystem (e.g., overlayfs).
  * @user_path may be on the stackable filesystem and @real_path on the
@@ -29,20 +31,21 @@
  * returned file into a container structure that also stores the stacked
  * file's path, which can be retrieved using backing_file_user_path().
  */
-struct file *backing_file_open(const struct path *user_path, int flags,
+struct file *backing_file_open(const struct path *user_path,
+			       const struct cred *user_cred, int flags,
 			       const struct path *real_path,
 			       const struct cred *cred)
 {
 	struct file *f;
 	int error;
 
-	f = alloc_empty_backing_file(flags, cred);
+	f = alloc_empty_backing_file(flags, cred, user_cred);
 	if (IS_ERR(f))
 		return f;
 
-	path_get(user_path);
-	backing_file_set_user_path(f, user_path);
-	error = vfs_open(real_path, f);
+	error = backing_file_open_user_path(f, user_path);
+	if (!error)
+		error = vfs_open(real_path, f);
 	if (error) {
 		fput(f);
 		f = ERR_PTR(error);
@@ -52,7 +55,8 @@ struct file *backing_file_open(const struct path *user_path, int flags,
 }
 EXPORT_SYMBOL_GPL(backing_file_open);
 
-struct file *backing_tmpfile_open(const struct path *user_path, int flags,
+struct file *backing_tmpfile_open(const struct path *user_path,
+				  const struct cred *user_cred, int flags,
 				  const struct path *real_parentpath,
 				  umode_t mode, const struct cred *cred)
 {
@@ -60,13 +64,13 @@ struct file *backing_tmpfile_open(const struct path *user_path, int flags,
 	struct file *f;
 	int error;
 
-	f = alloc_empty_backing_file(flags, cred);
+	f = alloc_empty_backing_file(flags, cred, user_cred);
 	if (IS_ERR(f))
 		return f;
 
-	path_get(user_path);
-	backing_file_set_user_path(f, user_path);
-	error = vfs_tmpfile(real_idmap, real_parentpath, f, mode);
+	error = backing_file_open_user_path(f, user_path);
+	if (!error)
+		error = vfs_tmpfile(real_idmap, real_parentpath, f, mode);
 	if (error) {
 		fput(f);
 		f = ERR_PTR(error);
@@ -75,6 +79,12 @@ struct file *backing_tmpfile_open(const struct path *user_path, int flags,
 }
 EXPORT_SYMBOL(backing_tmpfile_open);
 
+void backing_tmpfile_finish(struct file *file)
+{
+	backing_file_set_user_path_inode(file);
+}
+EXPORT_SYMBOL_GPL(backing_tmpfile_finish);
+
 struct backing_aio {
 	struct kiocb iocb;
 	refcount_t ref;
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 829d50d5c717d..f3a5fb0bffaf0 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -103,18 +103,25 @@ static int erofs_ishare_file_open(struct inode *inode, struct file *file)
 {
 	struct inode *sharedinode = EROFS_I(inode)->sharedinode;
 	struct file *realfile;
+	int err;
 
 	if (file->f_flags & O_DIRECT)
 		return -EINVAL;
-	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred());
+	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred(),
+					    file->f_cred);
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
+
+	err = backing_file_open_user_path(realfile, &file->f_path);
+	if (err) {
+		fput(realfile);
+		return err;
+	}
+
 	ihold(sharedinode);
 	realfile->f_op = &erofs_file_fops;
 	realfile->f_inode = sharedinode;
 	realfile->f_mapping = sharedinode->i_mapping;
-	path_get(&file->f_path);
-	backing_file_set_user_path(realfile, &file->f_path);
 
 	file_ra_state_init(&realfile->f_ra, file->f_mapping);
 	realfile->private_data = EROFS_I(inode);
diff --git a/fs/file_table.c b/fs/file_table.c
index aaa5faaace1e9..a4d1064d50896 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -27,6 +27,7 @@
 #include <linux/task_work.h>
 #include <linux/swap.h>
 #include <linux/kmemleak.h>
+#include <linux/backing-file.h>
 
 #include <linux/atomic.h>
 
@@ -43,11 +44,11 @@ static struct kmem_cache *bfilp_cachep __ro_after_init;
 
 static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
-/* Container for backing file with optional user path */
+/* Container for backing file with optional user path file */
 struct backing_file {
 	struct file file;
 	union {
-		struct path user_path;
+		struct file user_path_file;
 		freeptr_t bf_freeptr;
 	};
 };
@@ -56,24 +57,54 @@ struct backing_file {
 
 const struct path *backing_file_user_path(const struct file *f)
 {
-	return &backing_file(f)->user_path;
+	return &backing_file(f)->user_path_file.f_path;
 }
 EXPORT_SYMBOL_GPL(backing_file_user_path);
 
-void backing_file_set_user_path(struct file *f, const struct path *path)
+const struct file *backing_file_user_path_file(const struct file *f)
 {
-	backing_file(f)->user_path = *path;
+	return &backing_file(f)->user_path_file;
 }
-EXPORT_SYMBOL_GPL(backing_file_set_user_path);
+EXPORT_SYMBOL_GPL(backing_file_user_path_file);
 
-static inline void file_free(struct file *f)
+int backing_file_open_user_path(struct file *f, const struct path *path)
+{
+	if (WARN_ON(!(f->f_mode & FMODE_BACKING)))
+		return -EIO;
+	kernel_path_file_open(&backing_file(f)->user_path_file, path);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(backing_file_open_user_path);
+
+void backing_file_set_user_path_inode(struct file *f)
+{
+	if (WARN_ON(!(f->f_mode & FMODE_BACKING)))
+		return;
+	file_set_d_inode(&backing_file(f)->user_path_file);
+}
+EXPORT_SYMBOL_GPL(backing_file_set_user_path_inode);
+
+static void destroy_file(struct file *f)
 {
 	security_file_free(f);
+	put_cred(f->f_cred);
+}
+
+static inline void file_free(struct file *f)
+{
+	destroy_file(f);
 	if (likely(!(f->f_mode & FMODE_NOACCOUNT)))
 		percpu_counter_dec(&nr_files);
-	put_cred(f->f_cred);
 	if (unlikely(f->f_mode & FMODE_BACKING)) {
-		path_put(backing_file_user_path(f));
+		struct file *user_path_file = &backing_file(f)->user_path_file;
+
+		/*
+		 * no refcount on the user_path_file - they die together,
+		 * so __fput() is not called for user_path_file. path_put()
+		 * is the only relevant cleanup from __fput().
+		 */
+		destroy_file(user_path_file);
+		path_put(&user_path_file->__f_path);
 		kmem_cache_free(bfilp_cachep, backing_file(f));
 	} else {
 		kmem_cache_free(filp_cachep, f);
@@ -201,7 +232,7 @@ static int init_file(struct file *f, int flags, const struct cred *cred)
 	 * fget-rcu pattern users need to be able to handle spurious
 	 * refcount bumps we should reinitialize the reused file first.
 	 */
-	file_ref_init(&f->f_ref, 1);
+	file_ref_init(&f->f_ref, FILE_REF_ONEREF);
 	return 0;
 }
 
@@ -290,7 +321,8 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
  * This is only for kernel internal use, and the allocate file must not be
  * installed into file tables or such.
  */
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct cred *user_cred)
 {
 	struct backing_file *ff;
 	int error;
@@ -305,6 +337,15 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 		return ERR_PTR(error);
 	}
 
+	error = init_file(&ff->user_path_file, O_PATH, user_cred);
+	/* user_path_file is not refcounterd - it dies with the backing file */
+	file_ref_init(&ff->user_path_file.f_ref, FILE_REF_DEAD);
+	if (unlikely(error)) {
+		destroy_file(&ff->file);
+		kmem_cache_free(bfilp_cachep, ff);
+		return ERR_PTR(error);
+	}
+
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
 	return &ff->file;
 }
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 72de97c03d0ee..60018c6359342 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -10,6 +10,7 @@
 #include <linux/file.h>
 #include <linux/backing-file.h>
 #include <linux/splice.h>
+#include <linux/uio.h>
 
 static void fuse_file_accessed(struct file *file)
 {
@@ -167,7 +168,7 @@ struct fuse_backing *fuse_passthrough_open(struct file *file, int backing_id)
 		goto out;
 
 	/* Allocate backing file per fuse file to store fuse path */
-	backing_file = backing_file_open(&file->f_path, file->f_flags,
+	backing_file = backing_file_open(&file->f_path, file->f_cred, file->f_flags,
 					 &fb->file->f_path, fb->cred);
 	err = PTR_ERR(backing_file);
 	if (IS_ERR(backing_file)) {
diff --git a/fs/internal.h b/fs/internal.h
index cbc384a1aa096..4a9e5e00678d9 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -106,8 +106,16 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
  */
 struct file *alloc_empty_file(int flags, const struct cred *cred);
 struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred);
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred);
-void backing_file_set_user_path(struct file *f, const struct path *path);
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct cred *user_cred);
+int backing_file_open_user_path(struct file *f, const struct path *path);
+void backing_file_set_user_path_inode(struct file *f);
+void kernel_path_file_open(struct file *f, const struct path *path);
+
+static inline void file_set_d_inode(struct file *f)
+{
+	f->f_inode = d_inode(f->f_path.dentry);
+}
 
 static inline void file_put_write_access(struct file *file)
 {
diff --git a/fs/open.c b/fs/open.c
index 91f1139591abe..a7b3b04cd9ae7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -884,10 +884,38 @@ static inline int file_get_write_access(struct file *f)
 	return error;
 }
 
+static const struct file_operations empty_fops = {};
+
+static void do_path_file_open(struct file *f)
+{
+	f->f_mode = FMODE_PATH | FMODE_OPENED;
+	file_set_fsnotify_mode(f, FMODE_NONOTIFY);
+	f->f_op = &empty_fops;
+}
+
+/**
+ * kernel_path_file_open - open an O_PATH file for kernel internal use
+ * @f:		pre-allocated file with f_flags and f_cred initialized
+ * @path:	path to reference (may have a negative dentry)
+ *
+ * Open a minimal O_PATH file that only references a path.
+ * Unlike vfs_open(), this does not require a positive dentry and does not
+ * set up f_mapping and other fields not needed for O_PATH.
+ * If path is negative at the time of this call, the caller is responsible for
+ * callingn backing_file_set_user_path_inode() after making the path positive.
+
+ */
+void kernel_path_file_open(struct file *f, const struct path *path)
+{
+	f->__f_path = *path;
+	path_get(&f->f_path);
+	file_set_d_inode(f);
+	do_path_file_open(f);
+}
+
 static int do_dentry_open(struct file *f,
 			  int (*open)(struct inode *, struct file *))
 {
-	static const struct file_operations empty_fops = {};
 	struct inode *inode = f->f_path.dentry->d_inode;
 	int error;
 
@@ -898,9 +926,7 @@ static int do_dentry_open(struct file *f,
 	f->f_sb_err = file_sample_sb_err(f);
 
 	if (unlikely(f->f_flags & O_PATH)) {
-		f->f_mode = FMODE_PATH | FMODE_OPENED;
-		file_set_fsnotify_mode(f, FMODE_NONOTIFY);
-		f->f_op = &empty_fops;
+		do_path_file_open(f);
 		return 0;
 	}
 
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ff3dbd1ca61f2..24e961f165a78 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1374,7 +1374,8 @@ static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
 				return PTR_ERR(cred);
 
 			ovl_path_upper(dentry->d_parent, &realparentpath);
-			realfile = backing_tmpfile_open(&file->f_path, flags, &realparentpath,
+			realfile = backing_tmpfile_open(&file->f_path, file->f_cred,
+							flags, &realparentpath,
 							mode, current_cred());
 			err = PTR_ERR_OR_ZERO(realfile);
 			pr_debug("tmpfile/open(%pd2, 0%o) = %i\n", realparentpath.dentry, mode, err);
@@ -1392,6 +1393,8 @@ static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
 			err = ovl_instantiate(dentry, inode, newdentry, false, file);
 			if (!err) {
 				file->private_data = of;
+				/* user_path_file was opened with a negative path */
+				backing_tmpfile_finish(realfile);
 			} else {
 				dput(newdentry);
 				ovl_file_free(of);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 97bed2286030d..767c128407fcc 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -49,6 +49,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 				flags &= ~O_NOATIME;
 
 			realfile = backing_file_open(file_user_path(file),
+						     file_user_cred(file),
 						     flags, realpath, current_cred());
 		}
 	}
diff --git a/include/linux/backing-file.h b/include/linux/backing-file.h
index 1476a6ed1bfd7..52ac51ada6ff9 100644
--- a/include/linux/backing-file.h
+++ b/include/linux/backing-file.h
@@ -9,21 +9,45 @@
 #define _LINUX_BACKING_FILE_H
 
 #include <linux/file.h>
-#include <linux/uio.h>
 #include <linux/fs.h>
 
+/*
+ * When mmapping a file on a stackable filesystem (e.g., overlayfs), the file
+ * stored in ->vm_file is a backing file whose f_inode is on the underlying
+ * filesystem.
+ *
+ * LSM can use file_user_path_file() to store context related to the user path
+ * that was opened and mmaped.
+ */
+const struct file *backing_file_user_path_file(const struct file *f);
+
+static inline const struct file *file_user_path_file(const struct file *f)
+{
+	if (f && unlikely(f->f_mode & FMODE_BACKING))
+		return backing_file_user_path_file(f);
+	return f;
+}
+
+static inline const struct cred *file_user_cred(const struct file *f)
+{
+	return file_user_path_file(f)->f_cred;
+}
+
 struct backing_file_ctx {
 	const struct cred *cred;
 	void (*accessed)(struct file *file);
 	void (*end_write)(struct kiocb *iocb, ssize_t);
 };
 
-struct file *backing_file_open(const struct path *user_path, int flags,
+struct file *backing_file_open(const struct path *user_path,
+			       const struct cred *user_cred, int flags,
 			       const struct path *real_path,
 			       const struct cred *cred);
-struct file *backing_tmpfile_open(const struct path *user_path, int flags,
+struct file *backing_tmpfile_open(const struct path *user_path,
+				  const struct cred *user_cred, int flags,
 				  const struct path *real_parentpath,
 				  umode_t mode, const struct cred *cred);
+void backing_tmpfile_finish(struct file *file);
 ssize_t backing_file_read_iter(struct file *file, struct iov_iter *iter,
 			       struct kiocb *iocb, int flags,
 			       struct backing_file_ctx *ctx);
diff --git a/include/linux/file_ref.h b/include/linux/file_ref.h
index 31551e4cb8f34..c7512ce70f9c4 100644
--- a/include/linux/file_ref.h
+++ b/include/linux/file_ref.h
@@ -54,11 +54,11 @@ typedef struct {
 /**
  * file_ref_init - Initialize a file reference count
  * @ref: Pointer to the reference count
- * @cnt: The initial reference count typically '1'
+ * @cnt: The initial reference count typically FILE_REF_ONEREF
  */
 static inline void file_ref_init(file_ref_t *ref, unsigned long cnt)
 {
-	atomic_long_set(&ref->refcnt, cnt - 1);
+	atomic_long_set(&ref->refcnt, cnt);
 }
 
 bool __file_ref_put(file_ref_t *ref, unsigned long cnt);
-- 
2.53.0

