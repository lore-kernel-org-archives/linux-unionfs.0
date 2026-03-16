Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E538836604B
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Mar 2026 21:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773696986; cv=none; b=hLkV6cHqlWObvsKslfwCUBbLSuY3q03ajmX5uZmBYG0ehAYN4HYuTb+dX3cXwT0+QIG8x868XZUul2dvHPJTRw+c/CqnSWGIf8ET/9NzrR5S+kbdKmlJwmLfVqa8qiF0epjiiwqVdbfZ8euvbdc7LIxR237Qa7fR/fMKliYBMfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773696986; c=relaxed/simple;
	bh=bmz9+qunhYP+20i0DNZS5iAu99ubHlCpB76xw++XWq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiiomhL6ulccNJeq9qEoPffkwmHWIkvm5mhqFMm5bD6W4MlV9pxJWRaWcxKjvv1Rwtd0YdgeiVJBIH6rSrT7LkrnPkIQuw3xOFX7h9KlD8L/yV2TDs2I0CBVyGvqv1RHYkHg3GHlvImAA6JOe+AoCNNcNTwjtSsL1kXMoNpKlhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=d0Tnyl+P; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="d0Tnyl+P"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cbc593a67aso547037185a.2
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Mar 2026 14:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773696983; x=1774301783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZTER0ejJMHI8vN1WrhfquHMJBWsRpf8IPY3C8XWv6w=;
        b=d0Tnyl+PRy4LngxwXDfOkqqmUkqeruTauigEJB2oyTqWe1N/fOaK7qXXaTlcn6Abq7
         gjq2mUUxCBQUZGnHyrtOxDmvHv2uaHFCVRLiYaFdG9XELRGxUwB0RNwN0XXu2sGnbpeI
         oO19+y9LOkgMU82vaAp6Fcx8g1mZi8KWtE9tBQDQhPc94RaJIbZ6hbS/4GE3romRQXbJ
         amrjejkiJpDVK8JBgX00hElLyP4Mxon+LVhhueqaaFUrkAEENG6r9JiXFWpZYq6K3AGc
         vmLUUTDIJbxIAoXcFbyUFS1BK2Zw6ATXBuz4Dlz/nfYwQsDCIr/Lp9X/1pEHKYMYDMpF
         2JXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773696983; x=1774301783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yZTER0ejJMHI8vN1WrhfquHMJBWsRpf8IPY3C8XWv6w=;
        b=o97SGXp+TQDsy98O4eZUOp1uquRIAmHPrwukDIJE8EY8taAeVf0l/7DedAR79DmcAh
         ZW7tqP8fVLzIx/3tP0ysG2WjkvzjEmO75kyN33ne6YJHiwa82BmM69FbiZ5E9wWfv0Yr
         4CQEmJ8XX2mcW97DwdAwK+++TR4CrKzg6xcw2Rc3ucn8VS4rt4veAQ4RtSeDmzzmjKry
         PwjuIprBCIRIUtRDp452DhaSDSas81gc3KJiLEfsUnjw5WpcyDsaF++uCx5ou2/fB4fM
         bj8JM7i/jD+wNOiVOg5izaR27iZp4FrP0gm0VKIKgnMgu/ibl5F1ISLKA2fWv9ihHiKX
         mHbg==
X-Forwarded-Encrypted: i=1; AJvYcCXo/+XznFM3BSBFFXY/nlFs0vi60RGJEFK6An3aZGpyPQ5xEVnJfOLMV8K/sXJ8qYOModtvLMPljKEAXHAq@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf56ZMK/Nx33t6ytopvNV0EtTiKFzIgmG73kNUR8hVyL3FuZiY
	/4w1W4Ivon6tRPbE5mlT5GKmLRdhhhvNGFgNEMD5lGSWAGv8Pibvv1zkNHm5vIZG7ch1RXir9eO
	iuFg=
X-Gm-Gg: ATEYQzxPx1WHRmm+6KyomvWk/Egk/zbkB+q8KDT/bassVAt2Km1Qgj9I3nZ0SBUlqcr
	oejUdRzHvTb7D2t93z3Eg670tcUOPuolVNCj9hHihaRNhRQnju7CPHjWn1nPc5mbzF8Gq3RRdy0
	ClaluPGnr2Rt6ZXDHgMDdPFB0lbl/yvjg82UqBu10SJfiATvmQ86kPi4GGP/6JosJMqgBbtvZZM
	WgJIwwcMfshmN/Umj9Kzu5318gXSO0SVMw3w3vjZD3uH4OedI46zutRvZMU2SyPqWqcDmD+R2H5
	isDWwoAh6CjsvBJOAJZ/tCrkR4QkKC/TdkMYVbwlALY4KgjKZFCafb8Wo4X2V+YCKsLwFk9Ar2x
	kplkA3kaj0iCx70If4ACP/RNyz/adKhTnYM0vFUPHhKfjKjln/6nKbW2+hb5HtNmYtuKYniFcwP
	Ir/lWpVg2WNQTdXPtIplUIq1ooenuqxmwuGYwanOzF39QTbqgeuF4LMP1q44vhHj0rpZc4GPTNI
	wi2Omc=
X-Received: by 2002:a05:622a:1346:b0:509:348f:bc0e with SMTP id d75a77b69052e-50957e5d6d8mr198612561cf.69.1773696982805;
        Mon, 16 Mar 2026 14:36:22 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50939ec63d6sm150988431cf.12.2026.03.16.14.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 14:36:21 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 1/3] backing_file: store user_path_file
Date: Mon, 16 Mar 2026 17:35:56 -0400
Message-ID: <20260316213606.374109-6-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316213606.374109-5-paul@paul-moore.com>
References: <20260316213606.374109-5-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13336; i=paul@paul-moore.com; h=from:subject; bh=NGdpwf6jjNG1m9nIOap17SBd8DdIeebZ7C6CkE/q3I4=; b=owEBbQKS/ZANAwAKAeog8tqXN4lzAcsmYgBpuHfGxXiwIgWzzGyed0c2IzlCCSu6jvx75gPuG 28x0EzIk2mJAjMEAAEKAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCabh3xgAKCRDqIPLalzeJ c2/sD/9vhv7kQW6uHbgaYmRVbFNSaPBfuDtecqWCJ/vuXkb/0O0kCgsOdyca+hLmtUiaNr5tgfh ydgYtFzhZcIQmd63SzGkZgKT9pJqoMdxXtMmbwKur8Ax50SNSDMWyVzYspnn6dlROlgrUcZKWEY zt1RX29uhgODLKO5q6GjhcWqnWu1NYhODhgJzBjtXLPb4vNNX33qvavhhdaS0BbcQEhptS/GfbZ cC1I+x+d7s807xfO8k5IGgacZKZ46Fm5lksTvCc2YQgG6f0HinuRZ3AF7YI934+FFUrf30uEedn Fmav+QtdZPB2ch7xPo7CVq/0Vd5dZB4Erl15f5DoAve+7TsysVkpAD/HJPvnqof3i9xGVub5ge7 fm0I3XS8RH5b2oOwh/bBAbq6Y6Odl2gmo2O+qp2kWRQrQSshsA49GwECzkMnzYnvdTOB4cG0tud fBAtFwQUhJtkYDz9gJYcPUFCIQejmesSjqC+O/Y4R+BYsOV3L4SuD8Ox9t5w3+ZFb5QoVytbco0 1/LkK6kseVZ+hzT80mWdiI2tk+xUD5V2UyKhR+TZ4XYoDd0t5QEKQ1lAlCsN02i5ehJjmYys1px yZX6kAQLa8/ZkxQ5B8AFZIMUMcqK5RJIGShA9ee6SN3Xf+MFV2ingztRHHy5/dSnQ24+i5ba3TS B7/xt2WprlNyrsQ==
X-Developer-Key: i=paul@paul-moore.com; a=openpgp; fpr=7100AADFAE6E6E940D2E0AD655E45A5AE8CA7C8A
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

Instead of storing the user_path, store an O_PATH file for the
user_path with the original user file creds and a security context.

The user_path_file is only exported as a const pointer and its refcnt
is initialized to FILE_REF_DEAD, because it is not a refcounted object.

The only caller of file_ref_init() is now open coded, so the helper
is removed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Paul Moore <paul@paul-moore.com> (SELinux)
Acked-by: Gao Xiang <hsiangkao@linux.alibaba.com> (EROFS)
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 fs/backing-file.c            | 20 ++++++++------
 fs/erofs/ishare.c            |  6 ++--
 fs/file_table.c              | 53 ++++++++++++++++++++++++++++--------
 fs/fuse/passthrough.c        |  3 +-
 fs/internal.h                |  5 ++--
 fs/overlayfs/dir.c           |  3 +-
 fs/overlayfs/file.c          |  1 +
 include/linux/backing-file.h | 29 ++++++++++++++++++--
 include/linux/file_ref.h     | 10 -------
 9 files changed, 90 insertions(+), 40 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 45da8600d564..acabeea7efff 100644
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
@@ -29,19 +31,19 @@
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
+	backing_file_open_user_path(f, user_path);
 	error = vfs_open(real_path, f);
 	if (error) {
 		fput(f);
@@ -52,7 +54,8 @@ struct file *backing_file_open(const struct path *user_path, int flags,
 }
 EXPORT_SYMBOL_GPL(backing_file_open);
 
-struct file *backing_tmpfile_open(const struct path *user_path, int flags,
+struct file *backing_tmpfile_open(const struct path *user_path,
+				  const struct cred *user_cred, int flags,
 				  const struct path *real_parentpath,
 				  umode_t mode, const struct cred *cred)
 {
@@ -60,12 +63,11 @@ struct file *backing_tmpfile_open(const struct path *user_path, int flags,
 	struct file *f;
 	int error;
 
-	f = alloc_empty_backing_file(flags, cred);
+	f = alloc_empty_backing_file(flags, cred, user_cred);
 	if (IS_ERR(f))
 		return f;
 
-	path_get(user_path);
-	backing_file_set_user_path(f, user_path);
+	backing_file_open_user_path(f, user_path);
 	error = vfs_tmpfile(real_idmap, real_parentpath, f, mode);
 	if (error) {
 		fput(f);
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 829d50d5c717..17a4941d4518 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -106,15 +106,15 @@ static int erofs_ishare_file_open(struct inode *inode, struct file *file)
 
 	if (file->f_flags & O_DIRECT)
 		return -EINVAL;
-	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred());
+	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred(),
+					    file->f_cred);
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 	ihold(sharedinode);
 	realfile->f_op = &erofs_file_fops;
 	realfile->f_inode = sharedinode;
 	realfile->f_mapping = sharedinode->i_mapping;
-	path_get(&file->f_path);
-	backing_file_set_user_path(realfile, &file->f_path);
+	backing_file_open_user_path(realfile, &file->f_path);
 
 	file_ra_state_init(&realfile->f_ra, file->f_mapping);
 	realfile->private_data = EROFS_I(inode);
diff --git a/fs/file_table.c b/fs/file_table.c
index aaa5faaace1e..b7dc94656c44 100644
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
+}
+EXPORT_SYMBOL_GPL(backing_file_user_path_file);
+
+void backing_file_open_user_path(struct file *f, const struct path *path)
+{
+	/* open an O_PATH file to reference the user path - cannot fail */
+	WARN_ON(vfs_open(path, &backing_file(f)->user_path_file));
+}
+EXPORT_SYMBOL_GPL(backing_file_open_user_path);
+
+static void destroy_file(struct file *f)
+{
+	security_file_free(f);
+	put_cred(f->f_cred);
 }
-EXPORT_SYMBOL_GPL(backing_file_set_user_path);
 
 static inline void file_free(struct file *f)
 {
-	security_file_free(f);
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
+	atomic_long_set(&f->f_ref.refcnt, FILE_REF_ONEREF);
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
+	atomic_long_set(&ff->user_path_file.f_ref.refcnt, FILE_REF_DEAD);
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
index 72de97c03d0e..60018c635934 100644
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
index cbc384a1aa09..cc6f1e251f5a 100644
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
+void backing_file_open_user_path(struct file *f, const struct path *path);
 
 static inline void file_put_write_access(struct file *file)
 {
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ff3dbd1ca61f..5914b5cf25e3 100644
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
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 97bed2286030..767c128407fc 100644
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
index 1476a6ed1bfd..8afba93f3ce0 100644
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
index 31551e4cb8f3..fdaacbcbdb5b 100644
--- a/include/linux/file_ref.h
+++ b/include/linux/file_ref.h
@@ -51,16 +51,6 @@ typedef struct {
 #endif
 } file_ref_t;
 
-/**
- * file_ref_init - Initialize a file reference count
- * @ref: Pointer to the reference count
- * @cnt: The initial reference count typically '1'
- */
-static inline void file_ref_init(file_ref_t *ref, unsigned long cnt)
-{
-	atomic_long_set(&ref->refcnt, cnt - 1);
-}
-
 bool __file_ref_put(file_ref_t *ref, unsigned long cnt);
 
 /**
-- 
2.53.0

