Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6033E1DE4FB;
	Fri, 26 Jun 2026 07:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458545; cv=none; b=TLI7aYqp/+Xf5evDlzfItxWeIv7V5jOCa4GylpXNgr8fb2JwVYl7oHhylGUBDHArO/5Q1zrqOe0+iUNN7SIX/rCAGPkkT/uM9jB4Auymx9YcMkqfjldN7qerMhPOCCX+OiIjFeDwEVsc6BoGElGN1Fvqz0CCt99D0xXx4VPi0mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458545; c=relaxed/simple;
	bh=GUBlXhjbHWHzdy7sD8gypWL3rIc0A3D9bL5nJM8WkMQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQD1X0rNZOF3mFiugQS+jZkvF2lQR993Q/INt3Hjb6ovUvkZr+U0hZWmgZsrA7ByPz7FLt6h8ZPCbYY5fDszzsX1Psx2mFP7zfBVqpBSHZAvCa6yL/ftJFSYnPej7HsizyhrY92gBYOrhmP6WyVdMPbRiK4HU6SrU4ELT3m8SCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=SI7iSuPz; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="SI7iSuPz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=X9kt03eAYiuKWt73bgrFWHpstJIOsbBZ2xkKfRK562I=;
	b=SI7iSuPzjCRmoJAMfliAL4uqHCtBVeCbPWyIRyK8pe8Uj6EMtmSynzW0Z6qbZEx5tEzVIgIiQ
	+a4lxj6/edzqEdZKZF1tfqZ2Pt85vosxOjM+U7vn3rL2BT9FvQhNJLH4KvFuGxg/WP3uTydpQ2G
	KBoOum97/cpOu8f1kcm3uuc=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gmn2F5H83zmV6M;
	Fri, 26 Jun 2026 15:13:09 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 7374840572;
	Fri, 26 Jun 2026 15:22:16 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Jun 2026 15:22:16 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Jun 2026 15:22:15 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>,
	<bboscaccy@linux.microsoft.com>, <caixinchen1@huawei.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>,
	<lujialin4@huawei.com>
Subject: [PATCH v2 stable/linux-6.18.y 1/2] lsm: add backing_file LSM hooks
Date: Fri, 26 Jun 2026 15:50:34 +0800
Message-ID: <20260626075035.143419-2-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260626075035.143419-1-caixinchen1@huawei.com>
References: <20260626075035.143419-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200017.china.huawei.com (7.202.195.228)

From: Paul Moore <paul@paul-moore.com>

[ Upstream commit 6af36aeb147a06dea47c49859cd6ca5659aeb987 ]

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

There are a three other small changes to support these new LSM hooks:
* Pass the user file associated with a backing file down to
alloc_empty_backing_file() so it can be included in the
security_backing_file_alloc() hook.
* Add getter and setter functions for the backing_file struct LSM blob
as the backing_file struct remains private to fs/file_table.c.
* Constify the file struct field in the LSM common_audit_data struct to
better support LSMs that need to pass a const file struct pointer into
the common LSM audit code.

Thanks to Arnd Bergmann for identifying the missing EXPORT_SYMBOL_GPL()
and supplying a fixup.

Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: linux-erofs@lists.ozlabs.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Paul Moore <paul@paul-moore.com>
[Mainline declares lsm_backing_file_cache in security/lsm.h.  Linux 6.18.y
does not have security/lsm_init.c or security/lsm.h; the cache variable
is defined locally as static struct kmem_cache *lsm_backing_file_cache in
security/security.c.]
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/backing-file.c             |  17 ++++--
 fs/file_table.c               |  27 +++++++--
 fs/fuse/passthrough.c         |   2 +-
 fs/internal.h                 |   3 +-
 fs/overlayfs/dir.c            |   2 +-
 fs/overlayfs/file.c           |   2 +-
 include/linux/backing-file.h  |   4 +-
 include/linux/fs.h            |  13 ++++
 include/linux/lsm_audit.h     |   2 +-
 include/linux/lsm_hook_defs.h |   5 ++
 include/linux/lsm_hooks.h     |   1 +
 include/linux/security.h      |  22 +++++++
 security/security.c           | 109 ++++++++++++++++++++++++++++++++++
 13 files changed, 194 insertions(+), 15 deletions(-)

diff --git a/fs/backing-file.c b/fs/backing-file.c
index 15a7f8031084..e049a627d78f 100644
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
 
@@ -339,6 +342,12 @@ int backing_file_mmap(struct file *file, struct vm_area_struct *vma,
 	vma_set_file(vma, file);
 
 	old_cred = override_creds(ctx->cred);
+	ret = security_mmap_backing_file(vma, file, user_file);
+	if (ret) {
+		revert_creds(old_cred);
+		return ret;
+	}
+
 	ret = vfs_mmap(vma->vm_file, vma);
 	revert_creds(old_cred);
 
diff --git a/fs/file_table.c b/fs/file_table.c
index 762f03dcbcd7..987e01da9938 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -50,6 +50,9 @@ struct backing_file {
 		struct path user_path;
 		freeptr_t bf_freeptr;
 	};
+#ifdef CONFIG_SECURITY
+	void *security;
+#endif
 };
 
 #define backing_file(f) container_of(f, struct backing_file, file)
@@ -66,8 +69,21 @@ void backing_file_set_user_path(struct file *f, const struct path *path)
 }
 EXPORT_SYMBOL_GPL(backing_file_set_user_path);
 
+#ifdef CONFIG_SECURITY
+void *backing_file_security(const struct file *f)
+{
+	return backing_file(f)->security;
+}
+
+void backing_file_set_security(struct file *f, void *security)
+{
+	backing_file(f)->security = security;
+}
+#endif /* CONFIG_SECURITY */
+
 static inline void backing_file_free(struct backing_file *ff)
 {
+	security_backing_file_free(&ff->file);
 	path_put(&ff->user_path);
 	kmem_cache_free(bfilp_cachep, ff);
 }
@@ -288,10 +304,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	return f;
 }
 
-static int init_backing_file(struct backing_file *ff)
+static int init_backing_file(struct backing_file *ff,
+			     const struct file *user_file)
 {
 	memset(&ff->user_path, 0, sizeof(ff->user_path));
-	return 0;
+	backing_file_set_security(&ff->file, NULL);
+	return security_backing_file_alloc(&ff->file, user_file);
 }
 
 /*
@@ -301,7 +319,8 @@ static int init_backing_file(struct backing_file *ff)
  * This is only for kernel internal use, and the allocate file must not be
  * installed into file tables or such.
  */
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct file *user_file)
 {
 	struct backing_file *ff;
 	int error;
@@ -318,7 +337,7 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 
 	/* The f_mode flags must be set before fput(). */
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
-	error = init_backing_file(ff);
+	error = init_backing_file(ff, user_file);
 	if (unlikely(error)) {
 		fput(&ff->file);
 		return ERR_PTR(error);
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
index 9b2b4d116880..51107fd51514 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -100,7 +100,8 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
  */
 struct file *alloc_empty_file(int flags, const struct cred *cred);
 struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred);
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred);
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct file *user_file);
 void backing_file_set_user_path(struct file *f, const struct path *path);
 
 static inline void file_put_write_access(struct file *file)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a5e9ddf3023b..e924321b6402 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1355,7 +1355,7 @@ static int ovl_create_tmpfile(struct file *file, struct dentry *dentry,
 	}
 
 	ovl_path_upper(dentry->d_parent, &realparentpath);
-	realfile = backing_tmpfile_open(&file->f_path, flags, &realparentpath,
+	realfile = backing_tmpfile_open(file, flags, &realparentpath,
 					mode, current_cred());
 	err = PTR_ERR_OR_ZERO(realfile);
 	pr_debug("tmpfile/open(%pd2, 0%o) = %i\n", realparentpath.dentry, mode, err);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7ab2c9daffd0..3fedfdddfa75 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -48,7 +48,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 		if (!inode_owner_or_capable(real_idmap, realinode))
 			flags &= ~O_NOATIME;
 
-		realfile = backing_file_open(file_user_path(file),
+		realfile = backing_file_open(file,
 					     flags, realpath, current_cred());
 	}
 	ovl_revert_creds(old_cred);
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
index 014cb04eefbe..f3e798184a58 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2890,6 +2890,19 @@ struct file *dentry_create(const struct path *path, int flags, umode_t mode,
 			   const struct cred *cred);
 const struct path *backing_file_user_path(const struct file *f);
 
+#ifdef CONFIG_SECURITY
+void *backing_file_security(const struct file *f);
+void backing_file_set_security(struct file *f, void *security);
+#else
+static inline void *backing_file_security(const struct file *f)
+{
+	return NULL;
+}
+static inline void backing_file_set_security(struct file *f, void *security)
+{
+}
+#endif /* CONFIG_SECURITY */
+
 /*
  * When mmapping a file on a stackable filesystem (e.g., overlayfs), the file
  * stored in ->vm_file is a backing file whose f_inode is on the underlying
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
index 8c42b4bde09c..b4958167e381 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -191,6 +191,9 @@ LSM_HOOK(int, 0, file_permission, struct file *file, int mask)
 LSM_HOOK(int, 0, file_alloc_security, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, file_release, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, file_free_security, struct file *file)
+LSM_HOOK(int, 0, backing_file_alloc, struct file *backing_file,
+	 const struct file *user_file)
+LSM_HOOK(void, LSM_RET_VOID, backing_file_free, struct file *backing_file)
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
index 79ec5a2bdcca..ea4b0f5ca7f0 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -104,6 +104,7 @@ struct security_hook_list {
 struct lsm_blob_sizes {
 	int lbs_cred;
 	int lbs_file;
+	int lbs_backing_file;
 	int lbs_ib;
 	int lbs_inode;
 	int lbs_sock;
diff --git a/include/linux/security.h b/include/linux/security.h
index b64598e5d65d..e54025362426 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -473,11 +473,17 @@ int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_release(struct file *file);
 void security_file_free(struct file *file);
+int security_backing_file_alloc(struct file *backing_file,
+				const struct file *user_file);
+void security_backing_file_free(struct file *backing_file);
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
@@ -1142,6 +1148,15 @@ static inline void security_file_release(struct file *file)
 static inline void security_file_free(struct file *file)
 { }
 
+static inline int security_backing_file_alloc(struct file *backing_file,
+					      const struct file *user_file)
+{
+	return 0;
+}
+
+static inline void security_backing_file_free(struct file *backing_file)
+{ }
+
 static inline int security_file_ioctl(struct file *file, unsigned int cmd,
 				      unsigned long arg)
 {
@@ -1161,6 +1176,13 @@ static inline int security_mmap_file(struct file *file, unsigned long prot,
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
diff --git a/security/security.c b/security/security.c
index 603c3c6d5635..9285909908ab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -94,6 +94,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX + 1] = {
 static BLOCKING_NOTIFIER_HEAD(blocking_lsm_notifier_chain);
 
 static struct kmem_cache *lsm_file_cache;
+static struct kmem_cache *lsm_backing_file_cache;
 static struct kmem_cache *lsm_inode_cache;
 
 char *lsm_names;
@@ -265,6 +266,7 @@ static void __init lsm_set_blob_sizes(struct lsm_blob_sizes *needed)
 
 	lsm_set_blob_size(&needed->lbs_cred, &blob_sizes.lbs_cred);
 	lsm_set_blob_size(&needed->lbs_file, &blob_sizes.lbs_file);
+	lsm_set_blob_size(&needed->lbs_backing_file, &blob_sizes.lbs_backing_file);
 	lsm_set_blob_size(&needed->lbs_ib, &blob_sizes.lbs_ib);
 	/*
 	 * The inode blob gets an rcu_head in addition to
@@ -470,6 +472,7 @@ static void __init ordered_lsm_init(void)
 
 	init_debug("cred blob size       = %d\n", blob_sizes.lbs_cred);
 	init_debug("file blob size       = %d\n", blob_sizes.lbs_file);
+	init_debug("lsm_backing_file_cache	 = %d\n", blob_sizes.lbs_backing_file);
 	init_debug("ib blob size         = %d\n", blob_sizes.lbs_ib);
 	init_debug("inode blob size      = %d\n", blob_sizes.lbs_inode);
 	init_debug("ipc blob size        = %d\n", blob_sizes.lbs_ipc);
@@ -495,6 +498,11 @@ static void __init ordered_lsm_init(void)
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
@@ -671,6 +679,30 @@ int unregister_blocking_lsm_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_blocking_lsm_notifier);
 
+/**
+ * lsm_backing_file_alloc - allocate a composite backing file blob
+ * @backing_file: the backing file
+ *
+ * Allocate the backing file blob for all the modules.
+ *
+ * Returns 0, or -ENOMEM if memory can't be allocated.
+ */
+static int lsm_backing_file_alloc(struct file *backing_file)
+{
+	void *blob;
+
+	if (!lsm_backing_file_cache) {
+		backing_file_set_security(backing_file, NULL);
+		return 0;
+	}
+
+	blob = kmem_cache_zalloc(lsm_backing_file_cache, GFP_KERNEL);
+	backing_file_set_security(backing_file, blob);
+	if (!blob)
+		return -ENOMEM;
+	return 0;
+}
+
 /**
  * lsm_blob_alloc - allocate a composite blob
  * @dest: the destination for the blob
@@ -2965,6 +2997,57 @@ void security_file_free(struct file *file)
 	}
 }
 
+/**
+ * security_backing_file_alloc() - Allocate and setup a backing file blob
+ * @backing_file: the backing file
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
+int security_backing_file_alloc(struct file *backing_file,
+				const struct file *user_file)
+{
+	int rc;
+
+	rc = lsm_backing_file_alloc(backing_file);
+	if (rc)
+		return rc;
+	rc = call_int_hook(backing_file_alloc, backing_file, user_file);
+	if (unlikely(rc))
+		security_backing_file_free(backing_file);
+
+	return rc;
+}
+
+/**
+ * security_backing_file_free() - Free a backing file blob
+ * @backing_file: the backing file
+ *
+ * Free any LSM state associate with a backing file's LSM blob, including the
+ * blob itself.
+ */
+void security_backing_file_free(struct file *backing_file)
+{
+	void *blob = backing_file_security(backing_file);
+
+	call_void_hook(backing_file_free, backing_file);
+
+	if (blob) {
+		backing_file_set_security(backing_file, NULL);
+		kmem_cache_free(lsm_backing_file_cache, blob);
+	}
+}
+
 /**
  * security_file_ioctl() - Check if an ioctl is allowed
  * @file: associated file
@@ -3053,6 +3136,32 @@ int security_mmap_file(struct file *file, unsigned long prot,
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
2.18.0.huawei.25

