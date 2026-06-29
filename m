Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B8539A7F5;
	Mon, 29 Jun 2026 06:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715143; cv=none; b=GN2SYTqCGHM7drL7X09o2aeimx/boAop+WboZPdLS0BGdER32cUkmHSLZqtYzr8RxNxBlB/9hQ/gpS/NBCpTHHKZG8doct8PTuy8/8xqIQDZeRpRJ/kmFDGh8B9RuWOjiDcrgztwMeWskioR7y9q7Eue6RIt2tLAtKkRgiupwfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715143; c=relaxed/simple;
	bh=gJsSB4p6joO7Bd7ahEbsYtrwruSsdWFJFZ4V/SHUGoU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAnoE4QwlcNvQLgtflc9DN+jMVAwJUNuUhvhh5YOliK3IHwELUp/xPHq50GnRF7SimRbhSDH68UqW+jgJrEuO1HByLrWpbb0eWL5SS/6Klbwbm4P0bSoj2LskBOhAG5Ni6zT6nDFrzZjwvIlU3fDIPfIRgvsbdO1Y+EHpgVX8d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=mKYlTpc/; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="mKYlTpc/"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kc8lUUlQHuRYpfsFTo2f2mFpQRQi7fjz1x3qpEqKZAk=;
	b=mKYlTpc/IgcPudMJZv0Af1i/nrKiDim/HOoz47DUbjw0aqTeRRvUWKEj39oYTFI+Xb6ZnlX9h
	sv81FC1FieGOKMGazBfkLVFCEz3kgd54HvG8uSnKAYJVgdzYfCz/d3FjEVTJOcOCAiU7cVImtQ0
	oNnSJthfBCMuLDkziZze/bE=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gpbwr3BlkzmVC0;
	Mon, 29 Jun 2026 14:29:48 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 043C5402AB;
	Mon, 29 Jun 2026 14:38:57 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:56 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:55 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <amir73il@gmail.com>, <paul@paul-moore.com>,
	<jmorris@namei.org>, <serge@hallyn.com>, <stephen.smalley.work@gmail.com>,
	<omosnace@redhat.com>, <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<bboscaccy@linux.microsoft.com>, <caixinchen1@huawei.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-unionfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<selinux@vger.kernel.org>, <bpf@vger.kernel.org>, <stable@vger.kernel.org>,
	<lujialin4@huawei.com>
Subject: [PATCH stable/linux-5.10.y 6/7] lsm: add backing_file LSM hooks
Date: Mon, 29 Jun 2026 15:06:52 +0800
Message-ID: <20260629070653.580879-7-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260629070653.580879-1-caixinchen1@huawei.com>
References: <20260629070653.580879-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
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
[1. Mainline uses call_int_hook(FUNC, ...) with the default IRC baked
into the macro. Linux 5.10.y uses call_int_hook(FUNC, IRC, ...)
requiring an explicit default return value.

2. fs/backing-file.c does not exist in LTS
Linux 5.10.y places backing_file_open() in fs/open.c and lacks a
dedicated fs/backing-file.c.  The backing_file_mmap() function and
scoped_with_creds() do not exist in 5.10.y.  Therefore the LTS patch
calls security_mmap_backing_file() directly in ovl_mmap() in
fs/overlayfs/file.c rather than modifying backing_file_mmap().

3. Missing filesystems/modules
Linux 5.10.y does not have backing_tmpfile_open(), fs/fuse/passthrough.c,
or the erofs ishare mmap path that the mainline patch touches. These hunks
are dropped in the 5.10 LTS backport.

4. Use macro backing_file to replace inline function to eliminate the
const warning.

5. Mainline declares lsm_backing_file_cache in security/lsm.h. 5.10.y does
not have security/lsm_init.c or security/lsm.h; the cache variable
is defined locally as static struct kmem_cache *lsm_backing_file_cache
in security/security.c.]
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/file_table.c               |  32 +++++++---
 fs/internal.h                 |   3 +-
 fs/open.c                     |   7 ++-
 fs/overlayfs/file.c           |   8 ++-
 include/linux/fs.h            |  15 ++++-
 include/linux/lsm_audit.h     |   2 +-
 include/linux/lsm_hook_defs.h |   5 ++
 include/linux/lsm_hooks.h     |   1 +
 include/linux/security.h      |  22 +++++++
 security/security.c           | 110 ++++++++++++++++++++++++++++++++++
 10 files changed, 190 insertions(+), 15 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 6792d0bce246..829dfd35365c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -46,12 +46,12 @@ static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 struct backing_file {
 	struct file file;
 	struct path real_path;
+#ifdef CONFIG_SECURITY
+	void *security;
+#endif
 };
 
-static inline struct backing_file *backing_file(struct file *f)
-{
-	return container_of(f, struct backing_file, file);
-}
+#define backing_file(f) container_of(f, struct backing_file, file)
 
 struct path *backing_file_real_path(struct file *f)
 {
@@ -70,8 +70,21 @@ static void file_free_rcu(struct rcu_head *head)
 		kmem_cache_free(filp_cachep, f);
 }
 
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
 	path_put(&ff->real_path);
 }
 
@@ -216,10 +229,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	return f;
 }
 
-static int init_backing_file(struct backing_file *ff)
+static int init_backing_file(struct backing_file *ff,
+			     const struct file *user_file)
 {
 	memset(&ff->real_path, 0, sizeof(ff->real_path));
-	return 0;
+	backing_file_set_security(&ff->file, NULL);
+	return security_backing_file_alloc(&ff->file, user_file);
 }
 
 /*
@@ -229,7 +244,8 @@ static int init_backing_file(struct backing_file *ff)
  * This is only for kernel internal use, and the allocate file must not be
  * installed into file tables or such.
  */
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct file *user_file)
 {
 	struct backing_file *ff;
 	int error;
@@ -244,7 +260,7 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
 
 	/* The f_mode flags must be set before fput(). */
 	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
-	error = init_backing_file(ff);
+	error = init_backing_file(ff, user_file);
 	if (unlikely(error)) {
 		fput(&ff->file);
 		return ERR_PTR(error);
diff --git a/fs/internal.h b/fs/internal.h
index 676e8a8da1c7..e74f9b27888e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -109,7 +109,8 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
  */
 struct file *alloc_empty_file(int flags, const struct cred *cred);
 struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred);
-struct file *alloc_empty_backing_file(int flags, const struct cred *cred);
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred,
+				      const struct file *user_file);
 
 /*
  * super.c
diff --git a/fs/open.c b/fs/open.c
index d6d5684dc919..fbcfdb83c02e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1012,18 +1012,19 @@ EXPORT_SYMBOL(dentry_create);
  * the backing inode on the underlying filesystem, which can be
  * retrieved using backing_file_real_path().
  */
-struct file *backing_file_open(const struct path *path, int flags,
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
 
-	f->f_path = *path;
+	f->f_path = *user_path;
 	path_get(real_path);
 	*backing_file_real_path(f) = *real_path;
 	error = do_dentry_open(f, d_inode(real_path->dentry), NULL);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 460748b63806..318ec1d99aa1 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -58,7 +58,7 @@ static struct file *ovl_open_realfile(const struct file *file,
 		if (!inode_owner_or_capable(realinode))
 			flags &= ~O_NOATIME;
 
-		realfile = backing_file_open(&file->f_path, flags, realpath,
+		realfile = backing_file_open(file, flags, realpath,
 					     current_cred());
 	}
 	revert_creds(old_cred);
@@ -491,6 +491,7 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct file *user_file = vma->vm_file;
 	struct file *realfile = file->private_data;
 	const struct cred *old_cred;
 	int ret;
@@ -504,6 +505,11 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_file = get_file(realfile);
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = security_mmap_backing_file(vma, realfile, user_file);
+	if (ret) {
+		revert_creds(old_cred);
+		return ret;
+	}
 	ret = call_mmap(vma->vm_file, vma);
 	revert_creds(old_cred);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index acdc14542cbb..3b1eb8d7d9d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2680,11 +2680,24 @@ struct file *dentry_open(const struct path *path, int flags,
 			 const struct cred *creds);
 struct file *dentry_create(const struct path *path, int flags, umode_t mode,
 			   const struct cred *cred);
-struct file *backing_file_open(const struct path *path, int flags,
+struct file *backing_file_open(const struct file *user_file, int flags,
 			       const struct path *real_path,
 			       const struct cred *cred);
 struct path *backing_file_real_path(struct file *f);
 
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
  * file_real_path - get the path corresponding to f_inode
  *
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 28f23b341c1c..8b42e110cb26 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -92,7 +92,7 @@ struct common_audit_data {
 #endif
 		char *kmod_name;
 		struct lsm_ioctlop_audit *op;
-		struct file *file;
+		const struct file *file;
 		struct lsm_ibpkey_audit *ibpkey;
 		struct lsm_ibendport_audit *ibendport;
 		int reason;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index e34b295bc15a..473e4d8dafe3 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -156,6 +156,9 @@ LSM_HOOK(int, 0, kernfs_init_security, struct kernfs_node *kn_dir,
 LSM_HOOK(int, 0, file_permission, struct file *file, int mask)
 LSM_HOOK(int, 0, file_alloc_security, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, file_free_security, struct file *file)
+LSM_HOOK(int, 0, backing_file_alloc, struct file *backing_file,
+	 const struct file *user_file)
+LSM_HOOK(void, LSM_RET_VOID, backing_file_free, struct file *backing_file)
 LSM_HOOK(int, 0, file_ioctl, struct file *file, unsigned int cmd,
 	 unsigned long arg)
 LSM_HOOK(int, 0, file_ioctl_compat, struct file *file, unsigned int cmd,
@@ -163,6 +166,8 @@ LSM_HOOK(int, 0, file_ioctl_compat, struct file *file, unsigned int cmd,
 LSM_HOOK(int, 0, mmap_addr, unsigned long addr)
 LSM_HOOK(int, 0, mmap_file, struct file *file, unsigned long reqprot,
 	 unsigned long prot, unsigned long flags)
+LSM_HOOK(int, 0, mmap_backing_file, struct vm_area_struct *vma,
+	 struct file *backing_file, struct file *user_file)
 LSM_HOOK(int, 0, file_mprotect, struct vm_area_struct *vma,
 	 unsigned long reqprot, unsigned long prot)
 LSM_HOOK(int, 0, file_lock, struct file *file, unsigned int cmd)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index bbf9c8c7bd9c..04f08634e552 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1562,6 +1562,7 @@ struct security_hook_list {
 struct lsm_blob_sizes {
 	int	lbs_cred;
 	int	lbs_file;
+	int	lbs_backing_file;
 	int	lbs_inode;
 	int	lbs_ipc;
 	int	lbs_msg_msg;
diff --git a/include/linux/security.h b/include/linux/security.h
index f3c9d640b60b..c127367026d5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -369,11 +369,17 @@ int security_kernfs_init_security(struct kernfs_node *kn_dir,
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
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
@@ -923,6 +929,15 @@ static inline int security_file_alloc(struct file *file)
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
@@ -942,6 +957,13 @@ static inline int security_mmap_file(struct file *file, unsigned long prot,
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
index d6b1b82094b7..50e781b06eb4 100644
--- a/security/security.c
+++ b/security/security.c
@@ -76,6 +76,7 @@ struct security_hook_heads security_hook_heads __lsm_ro_after_init;
 static BLOCKING_NOTIFIER_HEAD(blocking_lsm_notifier_chain);
 
 static struct kmem_cache *lsm_file_cache;
+static struct kmem_cache *lsm_backing_file_cache;
 static struct kmem_cache *lsm_inode_cache;
 
 char *lsm_names;
@@ -197,6 +198,8 @@ static void __init lsm_set_blob_sizes(struct lsm_blob_sizes *needed)
 
 	lsm_set_blob_size(&needed->lbs_cred, &blob_sizes.lbs_cred);
 	lsm_set_blob_size(&needed->lbs_file, &blob_sizes.lbs_file);
+	lsm_set_blob_size(&needed->lbs_backing_file,
+			     &blob_sizes.lbs_backing_file);
 	/*
 	 * The inode blob gets an rcu_head in addition to
 	 * what the modules might need.
@@ -338,6 +341,7 @@ static void __init ordered_lsm_init(void)
 
 	init_debug("cred blob size     = %d\n", blob_sizes.lbs_cred);
 	init_debug("file blob size     = %d\n", blob_sizes.lbs_file);
+	init_debug("backing_file blob size  = %d\n", blob_sizes.lbs_backing_file);
 	init_debug("inode blob size    = %d\n", blob_sizes.lbs_inode);
 	init_debug("ipc blob size      = %d\n", blob_sizes.lbs_ipc);
 	init_debug("msg_msg blob size  = %d\n", blob_sizes.lbs_msg_msg);
@@ -350,6 +354,11 @@ static void __init ordered_lsm_init(void)
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
@@ -575,6 +584,30 @@ static int lsm_file_alloc(struct file *file)
 	return 0;
 }
 
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
  * lsm_inode_alloc - allocate a composite inode blob
  * @inode: the inode that needs a blob
@@ -1493,6 +1526,57 @@ void security_file_free(struct file *file)
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
+	rc = call_int_hook(backing_file_alloc, 0, backing_file, user_file);
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
 int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return call_int_hook(file_ioctl, 0, file, cmd, arg);
@@ -1562,6 +1646,32 @@ int security_mmap_file(struct file *file, unsigned long prot,
 	return ima_file_mmap(file, prot, prot_adj, flags);
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
+	return call_int_hook(mmap_backing_file, 0, vma, backing_file, user_file);
+}
+EXPORT_SYMBOL_GPL(security_mmap_backing_file);
+
 int security_mmap_addr(unsigned long addr)
 {
 	return call_int_hook(mmap_addr, 0, addr);
-- 
2.18.0.huawei.25

