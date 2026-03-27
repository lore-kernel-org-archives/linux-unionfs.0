Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124CC39B484
	for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2026 22:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774649107; cv=none; b=CXoH/5vgNyc1bGuzGFIeOTjd9CSb92zZpCoNctnvZsOOUPDJctaVmsT9+uv+LLT3iM+e32vdrc7B8sMQJvU/QQUeoj6mSYpf7y4eh110p+d7ZucMMoHQ0OvlZa6hTiEi9aGgSm8GyImlYgFkLnsOfC4goa1Y0uNcmkVdo2F/TpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774649107; c=relaxed/simple;
	bh=Uk8bW1uAgDiVghjc4x/VMUrhyq+cuGacppgtnbsN1+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH7Mm+zL05aAUGjG1dsewuLaIMwtKstG/XiS9S+P0LbABy3ORh24npd3VzncMOo/c5DP1B3Y7Sw50qu5i4KVQOIj9f5PsgT7T8GLM9pj7LHvNeLVw5PM274hJ7SY9NDFWY2pvaQ787ZfFNx0veBaFG7VYhexnKzJm1lmLkKP9S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=HEE4HQGt; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="HEE4HQGt"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8cb4136d865so325753585a.1
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2026 15:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1774649103; x=1775253903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kW2PIXWiPZs/O467FgG2DSLN6k3NsRalhA8DzsPZsM0=;
        b=HEE4HQGt1UmyZbHZUrA1wvoQg8kW4wUBrr0xN8iGqYKE68JaX3P8ELxrMYAaoA6hNN
         b14VQYBBLXuYSzyIcr29ZHKChWzyUmih+IU/9pixrbuw0EHzWpg25fTBrjKMtpJB4LI8
         kdpHDc4jauNhWsh/Ncf0cD9QJf6k9psSXSj3eNJakvN1f16A35IMscnrSuC2vPZbrkZB
         F+UT9eNymT5eMqt5KLlBpr8U2UA0RuJJeNECjG0F6HOsBVthZe7ATG/Z6B+1xdefKeEg
         wQwM84nU7WQc6drmUX7OYwg8kciNl8GP0SYxGw9VkkrUKcwfCEjPS1WgfJDbw4voUVgK
         oPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774649103; x=1775253903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kW2PIXWiPZs/O467FgG2DSLN6k3NsRalhA8DzsPZsM0=;
        b=d44LfPrK95svtM7OsHfcXhuK5MNzNdQG/kx5BD7ZYutixkLVoFGX+K44uKxVxwharp
         kzWPSkaSegKGAj5JV9VOGY7UsibprMlJ5u5lSib2+AXRgH7vbfU8/XXyIDM8xmv4NvIg
         dfOYH3vn+tnfghwI6Pv79XX9+WtcPnXVXz1vbvxQX8GaQcS80BOPJRDUb+Op1qS7JTkL
         Mx3+/1rylfp4T1+xfibSyGQWbMkDNdxblVzlucT8BlZdjzjt7t9vb6M4ESz5C2OSOXGM
         TsxQRB/c3JiVZZbkhshqgtUOR9dq+wA+qYD5VerCutyM+h8js6zoFbgCuceS4WxvXq7+
         z2dA==
X-Forwarded-Encrypted: i=1; AJvYcCUU+BBEZr5MGnMjduN75PhTZYYiQ4AX78iQOMNLeZh7dFbgo/2CApZbhMZypZs/006fuMjKs1a3IcTb30ox@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6EB0BNF2xIwvtf38uuXqFVohY8sTT0sYzsy6KFRNv3VoEZGTe
	b8PmI2xPOMR5U3TTLP4rqz730LHe6HZ9jHp2t4Bt9p/9Q41fC8JBRm9u/isg5pwQow==
X-Gm-Gg: ATEYQzywyka40NVUNT5HwsUfhIKXiKXmTvuDVO76ywRy52mLTvyaN5aS3hDnlo6LU43
	19xTcOSr+lnWXomARLjAg8GLUqs8JLuMLBIADbfWC+TSlcUkf5R/tlBIuvQJmwghHNuMxP84KTq
	ifTXW4AVxcMntHmcI3rWk9nyIIKImqfaPWu8O/uouqA/dDgYyGVhmYeNcv+iRiNI5Y4yKDcrpUH
	7St5uj4sotsiZ5vvLpmIBa9SurevVZbHDpKpGJSlR0fLC26mcVojVoozYpidrSePiWVGMOtHSsS
	dCs4zUua+JAEc76ddafiGgckkyeekxUm9tZJaIwTrw9PnZBiBNIbQ8esyLOQN0dox/JqFohotdB
	CbCNiwSqhLgOYfwGC1bWo/bM7jZzwLXgWtpOf9q0JH3gi0i0zRiTnX+O9qnCVznkET2RgMAgjq0
	YbJkhFC7xCKqARhOqdWdvWy7Gxnfjv3nraQtW63HrQ5X1SnIyv9avt705Bp/phiWleldsG
X-Received: by 2002:a05:620a:2911:b0:8cf:d565:fca9 with SMTP id af79cd13be357-8d01c5bdb81mr552452385a.9.1774649102931;
        Fri, 27 Mar 2026 15:05:02 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d02803f2c9sm29963685a.23.2026.03.27.15.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 15:05:01 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v3 1/2] lsm: add backing_file LSM hooks
Date: Fri, 27 Mar 2026 18:04:32 -0400
Message-ID: <20260327220446.353103-5-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327220446.353103-4-paul@paul-moore.com>
References: <20260327220446.353103-4-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=21733; i=paul@paul-moore.com; h=from:subject; bh=Uk8bW1uAgDiVghjc4x/VMUrhyq+cuGacppgtnbsN1+A=; b=owEBbQKS/ZANAwAKAeog8tqXN4lzAcsmYgBpxv7+0uoR2Qz500xwLbipMHwHGrTXp6KaEH2n1 JztJ+2DTluJAjMEAAEKAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCacb+/gAKCRDqIPLalzeJ cxiLD/9ozI+Kuw4yVo2CU3ZBA+Fesh+SZPt4dj88Nxdgt1zvuufJfI/X0bLly89lLOpINpDj2+r l3du9c45IEksCyqK3+dNYwJppZvZ1PPw6n+0zMgG6lYB4Q/73A6RIbNevuGscYsv9H8U6rUrrg+ 5tMisWJ/zyh9Sr8m+OVIF+lwpSEZDczYim9MIEz5bIdOYEM1fMSk4+sDxEhXSttoaK1DfCjbaot ObmLaEra4WBv/2U47lTG/JVvyD34/ZbKMLsEBWV6mcIetsk5N00AoSuJwCDScizbZ607s8KOP3Y A853oAgRO5IaSFPITKkxf5s6BJ+Os6HdMiNhftEj8NsZaAMFg2tuDNH1VjtXDBdr+76Z3zyGNKc dQkmmQhfXxh0Ob91u1+sA1wEP1yKh2Q1AyCft7+I1vceBMHhv2B7JjBRgOF/74gKiBudIN3Vbxa Z4za8w7A2MBhZv03zrLu4wbj4USqYgko62zl8S37z6jCdukOyTUkdLY31SkjEVkWs1BsUKT1diY wYZL2dOiQO6gicZQR7y1rIjkpFVDf2XFcZb005xpLL3OdGsenRBFFbWeaftR12KO472fyUnipQs a9U+u8q7N7EiLoj+f8vSmeFBhOSXE2vngWqxHSzxD3CLwu0as5GHeCtl6v/wqd288bFYsu7o9/V KUjBJpHMU5fDgnw==
X-Developer-Key: i=paul@paul-moore.com; a=openpgp; fpr=7100AADFAE6E6E940D2E0AD655E45A5AE8CA7C8A
Content-Transfer-Encoding: 8bit

Stacked filesystems such as overlayfs do not currently provide the
necessary mechanisms for LSMs to properly enforce access controls on the
mmap() and mprotect() operations.  In order to resolve this gap, a LSM
security blob is being added to the backing_file struct and the following
new LSM hooks are being created:

 security_backing_file_alloc()
 security_backing_file_free()
 security_mmap_backing_file()

The first two hooks are to manage the lifecycle of the LSM security blob
in the backing_file struct, while the third provides a new mmap() access
control point for the underlying backing file.  It is also expected that
LSMs will likely want to update their security_file_mprotect() callback
to address issues with their mprotect() controls, but that does not
require a change to the security_file_mprotect() LSM hook.

There are a two other small changes to support these new LSM hooks.  We
pass the user file associated with a backing file down to
alloc_empty_backing_file() so it can be included in the
security_backing_file_alloc() hook, and we constify the file struct field
in the LSM common_audit_data struct to better support LSMs that need to
pass a const file struct pointer into the common LSM audit code.

Thanks to Arnd Bergmann for identifying the missing EXPORT_SYMBOL_GPL()
and supplying a fixup.

Cc: stable@vger.kernel.org
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 fs/backing-file.c             |  18 ++++--
 fs/erofs/ishare.c             |  10 +++-
 fs/file_table.c               |  21 ++++++-
 fs/fuse/passthrough.c         |   2 +-
 fs/internal.h                 |   3 +-
 fs/overlayfs/dir.c            |   2 +-
 fs/overlayfs/file.c           |   2 +-
 include/linux/backing-file.h  |   4 +-
 include/linux/fs.h            |   1 +
 include/linux/lsm_audit.h     |   2 +-
 include/linux/lsm_hook_defs.h |   5 ++
 include/linux/lsm_hooks.h     |   1 +
 include/linux/security.h      |  22 ++++++++
 security/lsm.h                |   1 +
 security/lsm_init.c           |   9 +++
 security/security.c           | 100 ++++++++++++++++++++++++++++++++++
 16 files changed, 187 insertions(+), 16 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 45da8600d564..1f3bbfc75882 100644
--- a/fs/backing-file.c
+++ b/fs/backing-file.c
@@ -12,6 +12,7 @@
 #include <linux/backing-file.h>
 #include <linux/splice.h>
 #include <linux/mm.h>
+#include <linux/security.h>
 
 #include "internal.h"
 
@@ -29,14 +30,15 @@
  * returned file into a container structure that also stores the stacked
  * file's path, which can be retrieved using backing_file_user_path().
  */
-struct file *backing_file_open(const struct path *user_path, int flags,
+struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct path *real_path,
 			       const struct cred *cred)
 {
+	const struct path *user_path = &user_file->f_path;
 	struct file *f;
 	int error;
 
-	f = alloc_empty_backing_file(flags, cred);
+	f = alloc_empty_backing_file(flags, cred, user_file);
 	if (IS_ERR(f))
 		return f;
 
@@ -52,15 +54,16 @@ struct file *backing_file_open(const struct path *user_path, int flags,
 }
 EXPORT_SYMBOL_GPL(backing_file_open);
 
-struct file *backing_tmpfile_open(const struct path *user_path, int flags,
+struct file *backing_tmpfile_open(const struct file *user_file, int flags,
 				  const struct path *real_parentpath,
 				  umode_t mode, const struct cred *cred)
 {
 	struct mnt_idmap *real_idmap = mnt_idmap(real_parentpath->mnt);
+	const struct path *user_path = &user_file->f_path;
 	struct file *f;
 	int error;
 
-	f = alloc_empty_backing_file(flags, cred);
+	f = alloc_empty_backing_file(flags, cred, user_file);
 	if (IS_ERR(f))
 		return f;
 
@@ -336,8 +339,13 @@ int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 
 	vma_set_file(vma, file);
 
-	scoped_with_creds(ctx->cred)
+	scoped_with_creds(ctx->cred) {
+		ret = security_mmap_backing_file(vma, file, user_file);
+		if (ret)
+			return ret;
+
 		ret = vfs_mmap(vma->vm_file, vma);
+	}
 
 	if (ctx->accessed)
 		ctx->accessed(user_file);
diff --git a/fs/erofs/ishare.c b/fs/erofs/ishare.c
index 829d50d5c717..ec3fc5ac1a55 100644
--- a/fs/erofs/ishare.c
+++ b/fs/erofs/ishare.c
@@ -4,6 +4,7 @@
  */
 #include <linux/xxhash.h>
 #include <linux/mount.h>
+#include <linux/security.h>
 #include "internal.h"
 #include "xattr.h"
 
@@ -106,7 +107,8 @@ static int erofs_ishare_file_open(struct inode *inode, struct file *file)
 
 	if (file->f_flags & O_DIRECT)
 		return -EINVAL;
-	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred());
+	realfile = alloc_empty_backing_file(O_RDONLY|O_NOATIME, current_cred(),
+					    file);
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 	ihold(sharedinode);
@@ -150,8 +152,14 @@ static ssize_t erofs_ishare_file_read_iter(struct kiocb *iocb,
 static int erofs_ishare_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct file *realfile = file->private_data;
+	int err;
 
 	vma_set_file(vma, realfile);
+
+	err = security_mmap_backing_file(vma, realfile, file);
+	if (err)
+		return err;
+
 	return generic_file_readonly_mmap(file, vma);
 }
 
diff --git a/fs/file_table.c b/fs/file_table.c
index aaa5faaace1e..0bdc26cae138 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -50,6 +50,7 @@ struct backing_file {
 		struct path user_path;
 		freeptr_t bf_freeptr;
 	};
+	void *security;
 };
 
 #define backing_file(f) container_of(f, struct backing_file, file)
@@ -66,6 +67,11 @@ void backing_file_set_user_path(struct file *f, const struct path *path)
 }
 EXPORT_SYMBOL_GPL(backing_file_set_user_path);
 
+void *backing_file_security(const struct file *f)
+{
+	return backing_file(f)->security;
+}
+
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
@@ -73,8 +79,11 @@ static inline void file_free(struct file *f)
 		percpu_counter_dec(&nr_files);
 	put_cred(f->f_cred);
 	if (unlikely(f->f_mode & FMODE_BACKING)) {
-		path_put(backing_file_user_path(f));
-		kmem_cache_free(bfilp_cachep, backing_file(f));
+		struct backing_file *ff = backing_file(f);
+
+		security_backing_file_free(&ff->security);
+		path_put(&ff->user_path);
+		kmem_cache_free(bfilp_cachep, ff);
 	} else {
 		kmem_cache_free(filp_cachep, f);
 	}
@@ -290,7 +299,8 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
  * This is only for kernel internal use, and the allocate file must not be
  * installed into file tables or such.
  */
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct file *user_file)
 {
 	struct backing_file *ff;
 	int error;
@@ -306,6 +316,11 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 	}
 
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
+	error = security_backing_file_alloc(&ff->security, user_file);
+	if (unlikely(error)) {
+		fput(&ff->file);
+		return ERR_PTR(error);
+	}
 	return &ff->file;
 }
 EXPORT_SYMBOL_GPL(alloc_empty_backing_file);
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 72de97c03d0e..f2d08ac2459b 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -167,7 +167,7 @@ struct fuse_backing *fuse_passthrough_open(struct file *file, int backing_id)
 		goto out;
 
 	/* Allocate backing file per fuse file to store fuse path */
-	backing_file = backing_file_open(&file->f_path, file->f_flags,
+	backing_file = backing_file_open(file, file->f_flags,
 					 &fb->file->f_path, fb->cred);
 	err = PTR_ERR(backing_file);
 	if (IS_ERR(backing_file)) {
diff --git a/fs/internal.h b/fs/internal.h
index cbc384a1aa09..77e90e4124e0 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -106,7 +106,8 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
  */
 struct file *alloc_empty_file(int flags, const struct cred *cred);
 struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred);
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred);
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct file *user_file);
 void backing_file_set_user_path(struct file *f, const struct path *path);
 
 static inline void file_put_write_access(struct file *file)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ff3dbd1ca61f..f2f20a611af3 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1374,7 +1374,7 @@ static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
 				return PTR_ERR(cred);
 
 			ovl_path_upper(dentry->d_parent, &realparentpath);
-			realfile = backing_tmpfile_open(&file->f_path, flags, &realparentpath,
+			realfile = backing_tmpfile_open(file, flags, &realparentpath,
 							mode, current_cred());
 			err = PTR_ERR_OR_ZERO(realfile);
 			pr_debug("tmpfile/open(%pd2, 0%o) = %i\n", realparentpath.dentry, mode, err);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 97bed2286030..27cc07738f33 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -48,7 +48,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 			if (!inode_owner_or_capable(real_idmap, realinode))
 				flags &= ~O_NOATIME;
 
-			realfile = backing_file_open(file_user_path(file),
+			realfile = backing_file_open(file,
 						     flags, realpath, current_cred());
 		}
 	}
diff --git a/include/linux/backing-file.h b/include/linux/backing-file.h
index 1476a6ed1bfd..c939cd222730 100644
--- a/include/linux/backing-file.h
+++ b/include/linux/backing-file.h
@@ -18,10 +18,10 @@ struct backing_file_ctx {
 	void (*end_write)(struct kiocb *iocb, ssize_t);
 };
 
-struct file *backing_file_open(const struct path *user_path, int flags,
+struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct path *real_path,
 			       const struct cred *cred);
-struct file *backing_tmpfile_open(const struct path *user_path, int flags,
+struct file *backing_tmpfile_open(const struct file *user_file, int flags,
 				  const struct path *real_parentpath,
 				  umode_t mode, const struct cred *cred);
 ssize_t backing_file_read_iter(struct file *file, struct iov_iter *iter,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25e..8f5702cfb5e0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2474,6 +2474,7 @@ struct file *dentry_open_nonotify(const struct path *path, int flags,
 struct file *dentry_create(struct path *path, int flags, umode_t mode,
 			   const struct cred *cred);
 const struct path *backing_file_user_path(const struct file *f);
+void *backing_file_security(const struct file *f);
 
 /*
  * When mmapping a file on a stackable filesystem (e.g., overlayfs), the file
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 382c56a97bba..584db296e43b 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -94,7 +94,7 @@ struct common_audit_data {
 #endif
 		char *kmod_name;
 		struct lsm_ioctlop_audit *op;
-		struct file *file;
+		const struct file *file;
 		struct lsm_ibpkey_audit *ibpkey;
 		struct lsm_ibendport_audit *ibendport;
 		int reason;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 8c42b4bde09c..2c4da40757ad 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -191,6 +191,9 @@ LSM_HOOK(int, 0, file_permission, struct file *file, int mask)
 LSM_HOOK(int, 0, file_alloc_security, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, file_release, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, file_free_security, struct file *file)
+LSM_HOOK(int, 0, backing_file_alloc, void *backing_file_blobp,
+	 const struct file *user_file)
+LSM_HOOK(void, LSM_RET_VOID, backing_file_free, void *backing_file_blobp)
 LSM_HOOK(int, 0, file_ioctl, struct file *file, unsigned int cmd,
 	 unsigned long arg)
 LSM_HOOK(int, 0, file_ioctl_compat, struct file *file, unsigned int cmd,
@@ -198,6 +201,8 @@ LSM_HOOK(int, 0, file_ioctl_compat, struct file *file, unsigned int cmd,
 LSM_HOOK(int, 0, mmap_addr, unsigned long addr)
 LSM_HOOK(int, 0, mmap_file, struct file *file, unsigned long reqprot,
 	 unsigned long prot, unsigned long flags)
+LSM_HOOK(int, 0, mmap_backing_file, struct vm_area_struct *vma,
+	 struct file *backing_file, struct file *user_file)
 LSM_HOOK(int, 0, file_mprotect, struct vm_area_struct *vma,
 	 unsigned long reqprot, unsigned long prot)
 LSM_HOOK(int, 0, file_lock, struct file *file, unsigned int cmd)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index d48bf0ad26f4..b4f8cad53ddb 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -104,6 +104,7 @@ struct security_hook_list {
 struct lsm_blob_sizes {
 	unsigned int lbs_cred;
 	unsigned int lbs_file;
+	unsigned int lbs_backing_file;
 	unsigned int lbs_ib;
 	unsigned int lbs_inode;
 	unsigned int lbs_sock;
diff --git a/include/linux/security.h b/include/linux/security.h
index 83a646d72f6f..0a726bb70479 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -471,11 +471,17 @@ int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_release(struct file *file);
 void security_file_free(struct file *file);
+int security_backing_file_alloc(void **backing_file_blobp,
+				const struct file *user_file);
+void security_backing_file_free(void **backing_file_blobp);
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 int security_file_ioctl_compat(struct file *file, unsigned int cmd,
 			       unsigned long arg);
 int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags);
+int security_mmap_backing_file(struct vm_area_struct *vma,
+			       struct file *backing_file,
+			       struct file *user_file);
 int security_mmap_addr(unsigned long addr);
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			   unsigned long prot);
@@ -1140,6 +1146,15 @@ static inline void security_file_release(struct file *file)
 static inline void security_file_free(struct file *file)
 { }
 
+static inline int security_backing_file_alloc(void **backing_file_blobp,
+					      const struct file *user_file)
+{
+	return 0;
+}
+
+static inline void security_backing_file_free(void **backing_file_blobp)
+{ }
+
 static inline int security_file_ioctl(struct file *file, unsigned int cmd,
 				      unsigned long arg)
 {
@@ -1159,6 +1174,13 @@ static inline int security_mmap_file(struct file *file, unsigned long prot,
 	return 0;
 }
 
+static inline int security_mmap_backing_file(struct vm_area_struct *vma,
+					     struct file *backing_file,
+					     struct file *user_file)
+{
+	return 0;
+}
+
 static inline int security_mmap_addr(unsigned long addr)
 {
 	return cap_mmap_addr(addr);
diff --git a/security/lsm.h b/security/lsm.h
index db77cc83e158..32f808ad4335 100644
--- a/security/lsm.h
+++ b/security/lsm.h
@@ -29,6 +29,7 @@ extern struct lsm_blob_sizes blob_sizes;
 
 /* LSM blob caches */
 extern struct kmem_cache *lsm_file_cache;
+extern struct kmem_cache *lsm_backing_file_cache;
 extern struct kmem_cache *lsm_inode_cache;
 
 /* LSM blob allocators */
diff --git a/security/lsm_init.c b/security/lsm_init.c
index 573e2a7250c4..7c0fd17f1601 100644
--- a/security/lsm_init.c
+++ b/security/lsm_init.c
@@ -293,6 +293,8 @@ static void __init lsm_prepare(struct lsm_info *lsm)
 	blobs = lsm->blobs;
 	lsm_blob_size_update(&blobs->lbs_cred, &blob_sizes.lbs_cred);
 	lsm_blob_size_update(&blobs->lbs_file, &blob_sizes.lbs_file);
+	lsm_blob_size_update(&blobs->lbs_backing_file,
+			     &blob_sizes.lbs_backing_file);
 	lsm_blob_size_update(&blobs->lbs_ib, &blob_sizes.lbs_ib);
 	/* inode blob gets an rcu_head in addition to LSM blobs. */
 	if (blobs->lbs_inode && blob_sizes.lbs_inode == 0)
@@ -441,6 +443,8 @@ int __init security_init(void)
 	if (lsm_debug) {
 		lsm_pr("blob(cred) size %d\n", blob_sizes.lbs_cred);
 		lsm_pr("blob(file) size %d\n", blob_sizes.lbs_file);
+		lsm_pr("blob(backing_file) size %d\n",
+		       blob_sizes.lbs_backing_file);
 		lsm_pr("blob(ib) size %d\n", blob_sizes.lbs_ib);
 		lsm_pr("blob(inode) size %d\n", blob_sizes.lbs_inode);
 		lsm_pr("blob(ipc) size %d\n", blob_sizes.lbs_ipc);
@@ -462,6 +466,11 @@ int __init security_init(void)
 		lsm_file_cache = kmem_cache_create("lsm_file_cache",
 						   blob_sizes.lbs_file, 0,
 						   SLAB_PANIC, NULL);
+	if (blob_sizes.lbs_backing_file)
+		lsm_backing_file_cache = kmem_cache_create(
+						   "lsm_backing_file_cache",
+						   blob_sizes.lbs_backing_file,
+						   0, SLAB_PANIC, NULL);
 	if (blob_sizes.lbs_inode)
 		lsm_inode_cache = kmem_cache_create("lsm_inode_cache",
 						    blob_sizes.lbs_inode, 0,
diff --git a/security/security.c b/security/security.c
index 67af9228c4e9..651a0d643c9f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -81,6 +81,7 @@ const struct lsm_id *lsm_idlist[MAX_LSM_COUNT];
 struct lsm_blob_sizes blob_sizes;
 
 struct kmem_cache *lsm_file_cache;
+struct kmem_cache *lsm_backing_file_cache;
 struct kmem_cache *lsm_inode_cache;
 
 #define SECURITY_HOOK_ACTIVE_KEY(HOOK, IDX) security_hook_active_##HOOK##_##IDX
@@ -172,6 +173,28 @@ static int lsm_file_alloc(struct file *file)
 	return 0;
 }
 
+/**
+ * lsm_backing_file_alloc - allocate a composite backing file blob
+ * @backing_file_blobp: pointer to the backing file LSM blob pointer
+ *
+ * Allocate the backing file blob for all the modules.
+ *
+ * Returns 0, or -ENOMEM if memory can't be allocated.
+ */
+static int lsm_backing_file_alloc(void **backing_file_blobp)
+{
+	if (!lsm_backing_file_cache) {
+		*backing_file_blobp = NULL;
+		return 0;
+	}
+
+	*backing_file_blobp = kmem_cache_zalloc(lsm_backing_file_cache,
+						GFP_KERNEL);
+	if (*backing_file_blobp == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
 /**
  * lsm_blob_alloc - allocate a composite blob
  * @dest: the destination for the blob
@@ -2417,6 +2440,57 @@ void security_file_free(struct file *file)
 	}
 }
 
+/**
+ * security_backing_file_alloc() - Allocate and setup a backing file blob
+ * @backing_file_blobp: pointer to the backing file LSM blob pointer
+ * @user_file: the associated user visible file
+ *
+ * Allocate a backing file LSM blob and perform any necessary initialization of
+ * the LSM blob.  There will be some operations where the LSM will not have
+ * access to @user_file after this point, so any important state associated
+ * with @user_file that is important to the LSM should be captured in the
+ * backing file's LSM blob.
+ *
+ * LSM's should avoid taking a reference to @user_file in this hook as it will
+ * result in problems later when the system attempts to drop/put the file
+ * references due to a circular dependency.
+ *
+ * Return: Return 0 if the hook is successful, negative values otherwise.
+ */
+int security_backing_file_alloc(void **backing_file_blobp,
+				const struct file *user_file)
+{
+	int rc;
+
+	rc = lsm_backing_file_alloc(backing_file_blobp);
+	if (rc)
+		return rc;
+	rc = call_int_hook(backing_file_alloc, *backing_file_blobp, user_file);
+	if (unlikely(rc))
+		security_backing_file_free(backing_file_blobp);
+
+	return rc;
+}
+
+/**
+ * security_backing_file_free() - Free a backing file blob
+ * @backing_file_blobp: pointer to the backing file LSM blob pointer
+ *
+ * Free any LSM state associate with a backing file's LSM blob, including the
+ * blob itself.
+ */
+void security_backing_file_free(void **backing_file_blobp)
+{
+	void *backing_file_blob = *backing_file_blobp;
+
+	call_void_hook(backing_file_free, backing_file_blob);
+
+	if (backing_file_blob) {
+		*backing_file_blobp = NULL;
+		kmem_cache_free(lsm_backing_file_cache, backing_file_blob);
+	}
+}
+
 /**
  * security_file_ioctl() - Check if an ioctl is allowed
  * @file: associated file
@@ -2505,6 +2579,32 @@ int security_mmap_file(struct file *file, unsigned long prot,
 			     flags);
 }
 
+/**
+ * security_mmap_backing_file - Check if mmap'ing a backing file is allowed
+ * @vma: the vm_area_struct for the mmap'd region
+ * @backing_file: the backing file being mmap'd
+ * @user_file: the user file being mmap'd
+ *
+ * Check permissions for a mmap operation on a stacked filesystem.  This hook
+ * is called after the security_mmap_file() and is responsible for authorizing
+ * the mmap on @backing_file.  It is important to note that the mmap operation
+ * on @user_file has already been authorized and the @vma->vm_file has been
+ * set to @backing_file.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_mmap_backing_file(struct vm_area_struct *vma,
+			       struct file *backing_file,
+			       struct file *user_file)
+{
+	/* recommended by the stackable filesystem devs */
+	if (WARN_ON_ONCE(!(backing_file->f_mode & FMODE_BACKING)))
+		return -EIO;
+
+	return call_int_hook(mmap_backing_file, vma, backing_file, user_file);
+}
+EXPORT_SYMBOL_GPL(security_mmap_backing_file);
+
 /**
  * security_mmap_addr() - Check if mmap'ing an address is allowed
  * @addr: address
-- 
2.53.0

