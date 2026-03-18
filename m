Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BB23D7D6E
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Mar 2026 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773839585; cv=none; b=ZVdqRSec5+3nkymTPNazGb7addslM/t9eDWvC4tiTu3MQy7ceXrDBwW+Cdf5VdI9wM7YNXHdneRlmcdARQCtVWR+mOnpG71z6e8Qx6XDrgMlbV+fMsFJUWq04jxIiwJvBdsQYjrVj2Sko6cbM1GrdhxlnKzx4oVYNCNTHvbTorA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773839585; c=relaxed/simple;
	bh=0IA0+TJ+RKjtQhJBfCkHA3ggeX7HGJOg8E13KTMAdbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CFkm1TJfh5+V79XeZrjTeniozpL/vH//373CslMHbSBlaGyA8xXImRELARIr+JR+In7IC/i0uMkGdIqFBA+XcT34wpwrBQkCdENus5pSrI+rBUvJYAb267iC5sWb92jhukXxY6Tmrljgqsm0OxGdyjS5sXcFZfqsQTEjjCYLEX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIaesU41; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIaesU41"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b980785a0bfso63305366b.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Mar 2026 06:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773839581; x=1774444381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b/7hSXXq5I5tQDMuUzkqP7+YK2PRj0uGUtwNTKJSrfA=;
        b=TIaesU41JaX3ub9QSHgWebj8lmftbMRPfSWUDuZBsd/M2+0NZyscXo+gEjqMiYVzYg
         NgMKMGFwiQFHClLxQelMzY++93viPw7WDEyg/Jns8/6KKfSd4iYmDtnjRjH56Z4eUTkT
         l0jOB9u+GOpctuoNHLUd8GJ+Bm1ospS5KnvP1kcQ8bv3zdXdcX2vQfpzftMosV+tJAGb
         hy0i4bED+N60WZb9yCycgf5CFX8iIlG1G3CQl80VSAA03Q8xnB+OC3KQ8u0bT53cnH/L
         4BzDYKDdQmI+A2z9U6Lbxg8F1nvSjd7XhxCmL8zF3DG8TTgeQF8pruyMeVnBFYpnqCsy
         WrVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773839581; x=1774444381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/7hSXXq5I5tQDMuUzkqP7+YK2PRj0uGUtwNTKJSrfA=;
        b=A4blvyjMKlJVISLtRIOkEXeUjzEbHoF65AS0y1PZ6rlk5ilKwoci14PsbuEbg6+VKp
         oJFQqIC9WCU6vuE6ZtzyAFzsK0evapsxVbcgh3VBdxKuneR3cLebh9ORfpcYr/79Fkaa
         kvBMDWEp1+vuyWLULJDpooQXxgRLEV1LBfYmLFafMlJc6qH8u/aRw2r3W1qnx4tWVdvU
         ahg1VUfngDuhhFA4lnJyzt1pcuWBQcT7TkCV0VpUt5j7mFK2qh08zOXrBuEfYXSaEilR
         e9+UEUV/rw7ebK1cYa7AaSTgG8IUBbL6Gd/4wa8+WE8Z2zkjhALodIKUFDYj21llJpt7
         i1Hg==
X-Forwarded-Encrypted: i=1; AJvYcCW6zPMsvaMauByOZUpuM3XAoiziJik33sPfx4PQwbppYWNfoWHDTZa1A+BCRdC13Cu5C57haG/tLAuXik1C@vger.kernel.org
X-Gm-Message-State: AOJu0YyPdeqqAFjHAm/j4hvdUpf93ezwD1C5PkUmZ6TK6vm4zpzwLQxE
	Pys+7wub2k97KksWqa7SYHz8NXWIJsb1Mic17xlEtVRJUVw/erx1D+D8lJJESCLD
X-Gm-Gg: ATEYQzzFVyN4iqUu2qOqYjGeNfJfO47E6LJNGkN8Zba72NHZk4cTL9+QL9ckLxr/fzg
	xP8yTIW5pstRlKUAebXExRc99GxMK/lEBDMN+ZFdKDaqTnconDkqwnABU+V5ccMTOMr48s+zYkx
	TtDBnLTL/jfDNAWAikEib8H5mhaGZh16OyvcuyJltqhVuezgk77kD7FF6bFfKUlpZuGjt+sq8C8
	WtPNnTXqyq1exvDQ9Jl2B8RR0HLQZLF0h7uF7DHhe6DNcp0Oa8CzmjToEdGXh3gP0bVgfpALkji
	eyRIhISf6Xdk2TDtqhBQM4NnnX8/XY4uw5aA+flRp+ZCHLlzbcMvSnylYb697/NRb01hvn5ZSHa
	+GLVWPSriFKn0w0eT+Up8NxxIL8IEy5hp8OaH/5Qsa1jxzfUjGPeVsiXbnFcJ2yyeKtqD0kLSVp
	jAcYUf/aaRCL9Yg7+kq5P+gqhjI98Jr4qVGPfgDsyUDhJECIU9tHx8VhYwcLanqmhAx8164jybY
	wu7SEJJ1MWlkqjjwSCwYnIHfNQ=
X-Received: by 2002:a17:907:3d52:b0:b97:698d:1e with SMTP id a640c23a62f3a-b97f4971d9dmr181381766b.35.1773839580063;
        Wed, 18 Mar 2026 06:13:00 -0700 (PDT)
Received: from localhost (2001-1c00-570d-ee00-0520-bd43-ec36-d135.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:520:bd43:ec36:d135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b97f16d3380sm216163566b.42.2026.03.18.06.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 06:12:59 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Paul Moore <paul@paul-moore.com>,
	Gao Xiang <xiang@kernel.org>,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v6] backing_file: store user_path_file
Date: Wed, 18 Mar 2026 14:12:58 +0100
Message-ID: <20260318131258.1457101-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of storing the user_path, store an O_PATH file for the
user_path with the original user file creds and a security context.

The user_path_file is only exported as a const pointer and its refcnt
is initialized to FILE_REF_DEAD, because it is not a refcounted object.

The file_ref_init() helper was changed to accept the FILE_REF_ constant
instead of the fake +1 integer count.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

My v5 patch was sent by Paul along with his LSM/selinux pataches [1].
Here are the changes you requested.

I removed the ACKs and Tested-by because of the changes.

Thanks,
Amir.

Changes since v5:
- Restore file_ref_init() helper without refcnt -1 offset
- Future proofing errors from backing_file_open_user_path()

[1] https://lore.kernel.org/r/20260316213606.374109-6-paul@paul-moore.com/

 fs/backing-file.c            | 26 ++++++++++--------
 fs/erofs/ishare.c            | 13 +++++++--
 fs/file_table.c              | 53 ++++++++++++++++++++++++++++--------
 fs/fuse/passthrough.c        |  3 +-
 fs/internal.h                |  5 ++--
 fs/overlayfs/dir.c           |  3 +-
 fs/overlayfs/file.c          |  1 +
 include/linux/backing-file.h | 29 ++++++++++++++++++--
 include/linux/file_ref.h     |  4 +--
 9 files changed, 103 insertions(+), 34 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 45da8600d5644..271ff27521063 100644
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
index aaa5faaace1e9..e8b4eb2bbff85 100644
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
@@ -56,24 +57,44 @@ struct backing_file {
 
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
+	/* open an O_PATH file to reference the user path - should not fail */
+	return WARN_ON(vfs_open(path, &backing_file(f)->user_path_file));
+}
+EXPORT_SYMBOL_GPL(backing_file_open_user_path);
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
@@ -201,7 +222,7 @@ static int init_file(struct file *f, int flags, const struct cred *cred)
 	 * fget-rcu pattern users need to be able to handle spurious
 	 * refcount bumps we should reinitialize the reused file first.
 	 */
-	file_ref_init(&f->f_ref, 1);
+	file_ref_init(&f->f_ref, FILE_REF_ONEREF);
 	return 0;
 }
 
@@ -290,7 +311,8 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
  * This is only for kernel internal use, and the allocate file must not be
  * installed into file tables or such.
  */
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct cred *user_cred)
 {
 	struct backing_file *ff;
 	int error;
@@ -305,6 +327,15 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
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
index cbc384a1aa096..7c44a58627ba3 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -106,8 +106,9 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
  */
 struct file *alloc_empty_file(int flags, const struct cred *cred);
 struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred);
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred);
-void backing_file_set_user_path(struct file *f, const struct path *path);
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct cred *user_cred);
+int backing_file_open_user_path(struct file *f, const struct path *path);
 
 static inline void file_put_write_access(struct file *file)
 {
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 8c0a3d876fef1..5fd32ccc134d2 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1389,7 +1389,8 @@ static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
 				return PTR_ERR(cred);
 
 			ovl_path_upper(dentry->d_parent, &realparentpath);
-			realfile = backing_tmpfile_open(&file->f_path, flags, &realparentpath,
+			realfile = backing_tmpfile_open(&file->f_path, file->f_cred,
+							flags, &realparentpath,
 							mode, current_cred());
 			err = PTR_ERR_OR_ZERO(realfile);
 			pr_debug("tmpfile/open(%pd2, 0%o) = %i\n", realparentpath.dentry, mode, err);
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
index 1476a6ed1bfd7..8afba93f3ce07 100644
--- a/include/linux/backing-file.h
+++ b/include/linux/backing-file.h
@@ -9,19 +9,42 @@
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
 ssize_t backing_file_read_iter(struct file *file, struct iov_iter *iter,
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

