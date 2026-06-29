Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309143A7F72;
	Mon, 29 Jun 2026 06:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715149; cv=none; b=PvA4ExI2Ef0wqvnuPqO8RD6vSCLX/AGlOIvTqPUtZfubPLiFqLhVkk8M8o7whdMtNxJ2o32anKFA1z1rh94atlSR5AN809HuZz6wXStEtvOPQJwWcw3TCkbswg4JxXR0MJyuuWXhodp7kTqx3qGqIX7SrSysbHSp8nNJEAO9BIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715149; c=relaxed/simple;
	bh=ZT04T3IUQYJWxpoZxIQZJnwsvT/n1pz7+Rojx5OGfOI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mCkill1+Xzl/6LTCjvtr0378KWv5X0ujcTJa/mhe1uqWkosD5rDRfzmnRrWkPKPQORjFOut5Tl4FU0yJDv32Rjo4N9O0A8eAwJoUO5ZS2BPMIZZizWWegoEbpjBXOCPBAnqR8Q/Hahm6B1gsrqHSkjiXskPlf6boLSKKSPOxOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oBbCSgL9; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oBbCSgL9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JERjemWMazbzgv3eH1TR6f1/mewYdhsfmaHQlE+mYUY=;
	b=oBbCSgL9dtJUQRIS3I9BgzVQJcPavny3sj0Wfe4aCPU3mtLJVlp4JQMAW+oNxPvzhASNziWrB
	+eOadU5RdUJDwd/lSQ5/RQNBl44xAfECMNMIVKprwgF2B27+VZHUOCg6GOHHcokf0MPh4ploggG
	E26xTkTHxv2xfGdJ+wvYQTI=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gpbxK2TF3z12LD8;
	Mon, 29 Jun 2026 14:30:13 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id B20734057F;
	Mon, 29 Jun 2026 14:38:57 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:57 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:56 +0800
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
Subject: [PATCH stable/linux-5.10.y 7/7] selinux: fix overlayfs mmap() and mprotect() access checks
Date: Mon, 29 Jun 2026 15:06:53 +0800
Message-ID: <20260629070653.580879-8-caixinchen1@huawei.com>
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

[ Upstream commit 82544d36b1729153c8aeb179e84750f0c085d3b1 ]

The existing SELinux security model for overlayfs is to allow access if
the current task is able to access the top level file (the "user" file)
and the mounter's credentials are sufficient to access the lower
level file (the "backing" file).  Unfortunately, the current code does
not properly enforce these access controls for both mmap() and mprotect()
operations on overlayfs filesystems.

This patch makes use of the newly created security_mmap_backing_file()
LSM hook to provide the missing backing file enforcement for mmap()
operations, and leverages the backing file API and new LSM blob to
provide the necessary information to properly enforce the mprotect()
access controls.

Cc: stable@vger.kernel.org
Acked-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
[backing_file_user_path() not available
Mainline uses backing_file_user_path(file) to obtain the user-visible path
from a backing file. The 5.10.y version uses &file->f_path directly]
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 security/selinux/hooks.c          | 244 ++++++++++++++++++++++--------
 security/selinux/include/objsec.h |  11 ++
 2 files changed, 190 insertions(+), 65 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e1bbdef0bcd3..76cc0cbd1fd2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1703,52 +1703,75 @@ static inline int file_path_has_perm(const struct cred *cred,
 static int bpf_fd_pass(const struct file *file, u32 sid);
 #endif
 
-/* Check whether a task can use an open file descriptor to
-   access an inode in a given way.  Check access to the
-   descriptor itself, and then use dentry_has_perm to
-   check a particular permission to the file.
-   Access to the descriptor is implicitly granted if it
-   has the same SID as the process.  If av is zero, then
-   access to the file is not checked, e.g. for cases
-   where only the descriptor is affected like seek. */
-static int file_has_perm(const struct cred *cred,
-			 struct file *file,
-			 u32 av)
+static int __file_has_perm(const struct cred *cred, const struct file *file,
+			   u32 av, bool bf_user_file)
+
 {
-	struct file_security_struct *fsec = selinux_file(file);
-	struct inode *inode = file_inode(file);
 	struct common_audit_data ad;
-	u32 sid = cred_sid(cred);
+	struct inode *inode;
+	u32 ssid = cred_sid(cred);
+	u32 tsid_fd;
 	int rc;
 
-	ad.type = LSM_AUDIT_DATA_FILE;
-	ad.u.file = file;
+	if (bf_user_file) {
+		struct backing_file_security_struct *bfsec;
+		const struct path *path;
 
-	if (sid != fsec->sid) {
-		rc = avc_has_perm(&selinux_state,
-				  sid, fsec->sid,
-				  SECCLASS_FD,
-				  FD__USE,
-				  &ad);
+		if (WARN_ON(!(file->f_mode & FMODE_BACKING)))
+			return -EIO;
+
+		bfsec = selinux_backing_file(file);
+		path = &file->f_path;
+		tsid_fd = bfsec->uf_sid;
+		inode = d_inode(path->dentry);
+
+		ad.type = LSM_AUDIT_DATA_PATH;
+		ad.u.path = *path;
+	} else {
+		struct file_security_struct *fsec = selinux_file(file);
+
+		tsid_fd = fsec->sid;
+		inode = file_inode(file);
+
+		ad.type = LSM_AUDIT_DATA_FILE;
+		ad.u.file = file;
+	}
+
+	if (ssid != tsid_fd) {
+		rc = avc_has_perm(&selinux_state, ssid, tsid_fd, SECCLASS_FD, FD__USE, &ad);
 		if (rc)
-			goto out;
+			return rc;
 	}
 
 #ifdef CONFIG_BPF_SYSCALL
-	rc = bpf_fd_pass(file, cred_sid(cred));
+	/* regardless of backing vs user file, use the underlying file here */
+	rc = bpf_fd_pass(file, ssid);
 	if (rc)
 		return rc;
 #endif
 
 	/* av is zero if only checking access to the descriptor. */
-	rc = 0;
 	if (av)
-		rc = inode_has_perm(cred, inode, av, &ad);
+		return inode_has_perm(cred, inode, av, &ad);
 
-out:
-	return rc;
+	return 0;
 }
 
+/* Check whether a task can use an open file descriptor to
+   access an inode in a given way.  Check access to the
+   descriptor itself, and then use dentry_has_perm to
+   check a particular permission to the file.
+   Access to the descriptor is implicitly granted if it
+   has the same SID as the process.  If av is zero, then
+   access to the file is not checked, e.g. for cases
+   where only the descriptor is affected like seek. */
+static inline int file_has_perm(const struct cred *cred,
+				const struct file *file, u32 av)
+{
+	return __file_has_perm(cred, file, av, false);
+}
+
+
 /*
  * Determine the label for an inode that might be unioned.
  */
@@ -3572,6 +3595,17 @@ static int selinux_file_alloc_security(struct file *file)
 	return 0;
 }
 
+static int selinux_backing_file_alloc(struct file *backing_file,
+				      const struct file *user_file)
+{
+	struct backing_file_security_struct *bfsec;
+
+	bfsec = selinux_backing_file(backing_file);
+	bfsec->uf_sid = selinux_file(user_file)->sid;
+
+	return 0;
+}
+
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3691,43 +3725,55 @@ static int selinux_file_ioctl_compat(struct file *file, unsigned int cmd,
 
 static int default_noexec __ro_after_init;
 
-static int file_map_prot_check(struct file *file, unsigned long prot, int shared)
+static int __file_map_prot_check(const struct cred *cred,
+				 const struct file *file, unsigned long prot,
+				 bool shared, bool bf_user_file)
 {
-	const struct cred *cred = current_cred();
-	u32 sid = cred_sid(cred);
-	int rc = 0;
+	struct inode *inode = NULL;
+	bool prot_exec = prot & PROT_EXEC;
+	bool prot_write = prot & PROT_WRITE;
+
+	if (file) {
+		if (bf_user_file)
+			inode = d_inode(file->f_path.dentry);
+		else
+			inode = file_inode(file);
+	}
+
+	if (default_noexec && prot_exec &&
+	    (!file || IS_PRIVATE(inode) || (!shared && prot_write))) {
+		int rc;
+		u32 sid = cred_sid(cred);
 
-	if (default_noexec &&
-	    (prot & PROT_EXEC) && (!file || IS_PRIVATE(file_inode(file)) ||
-				   (!shared && (prot & PROT_WRITE)))) {
 		/*
-		 * We are making executable an anonymous mapping or a
-		 * private file mapping that will also be writable.
-		 * This has an additional check.
+		 * We are making executable an anonymous mapping or a private
+		 * file mapping that will also be writable.
 		 */
-		rc = avc_has_perm(&selinux_state,
-				  sid, sid, SECCLASS_PROCESS,
-				  PROCESS__EXECMEM, NULL);
+		rc = avc_has_perm(&selinux_state, sid, sid, SECCLASS_PROCESS, PROCESS__EXECMEM,
+				  NULL);
 		if (rc)
-			goto error;
+			return rc;
 	}
 
 	if (file) {
-		/* read access is always possible with a mapping */
+		/* "read" always possible, "write" only if shared */
 		u32 av = FILE__READ;
-
-		/* write access only matters if the mapping is shared */
-		if (shared && (prot & PROT_WRITE))
+		if (shared && prot_write)
 			av |= FILE__WRITE;
-
-		if (prot & PROT_EXEC)
+		if (prot_exec)
 			av |= FILE__EXECUTE;
 
-		return file_has_perm(cred, file, av);
+		return __file_has_perm(cred, file, av, bf_user_file);
 	}
 
-error:
-	return rc;
+	return 0;
+}
+
+static inline int file_map_prot_check(const struct cred *cred,
+				      const struct file *file,
+				      unsigned long prot, bool shared)
+{
+	return __file_map_prot_check(cred, file, prot, shared, false);
 }
 
 static int selinux_mmap_addr(unsigned long addr)
@@ -3744,17 +3790,16 @@ static int selinux_mmap_addr(unsigned long addr)
 	return rc;
 }
 
-static int selinux_mmap_file(struct file *file, unsigned long reqprot,
-			     unsigned long prot, unsigned long flags)
+static int selinux_mmap_file_common(const struct cred *cred, struct file *file,
+				    unsigned long reqprot, unsigned long prot, bool shared)
 {
-	struct common_audit_data ad;
-	int rc;
-
 	if (file) {
+		int rc;
+		struct common_audit_data ad;
+
 		ad.type = LSM_AUDIT_DATA_FILE;
 		ad.u.file = file;
-		rc = inode_has_perm(current_cred(), file_inode(file),
-				    FILE__MAP, &ad);
+		rc = inode_has_perm(cred, file_inode(file), FILE__MAP, &ad);
 		if (rc)
 			return rc;
 	}
@@ -3762,36 +3807,86 @@ static int selinux_mmap_file(struct file *file, unsigned long reqprot,
 	if (checkreqprot_get(&selinux_state))
 		prot = reqprot;
 
-	return file_map_prot_check(file, prot,
-				   (flags & MAP_TYPE) == MAP_SHARED);
+	return file_map_prot_check(cred, file, prot, shared);
+}
+
+static int selinux_mmap_file(struct file *file,
+			     unsigned long reqprot,
+			     unsigned long prot, unsigned long flags)
+{
+	return selinux_mmap_file_common(current_cred(), file, reqprot, prot,
+					(flags & MAP_TYPE) == MAP_SHARED);
+}
+
+/**
+ * selinux_mmap_backing_file - Check mmap permissions on a backing file
+ * @vma: memory region
+ * @backing_file: stacked filesystem backing file
+ * @user_file: user visible file
+ *
+ * This is called after selinux_mmap_file() on stacked filesystems, and it
+ * is this function's responsibility to verify access to @backing_file and
+ * setup the SELinux state for possible later use in the mprotect() code path.
+ *
+ * By the time this function is called, mmap() access to @user_file has already
+ * been authorized and @vma->vm_file has been set to point to @backing_file.
+ *
+ * Return zero on success, negative values otherwise.
+ */
+static int selinux_mmap_backing_file(struct vm_area_struct *vma,
+				     struct file *backing_file,
+				     struct file *user_file __always_unused)
+{
+	unsigned long prot = 0;
+
+	/* translate vma->vm_flags perms into PROT perms */
+	if (vma->vm_flags & VM_READ)
+		prot |= PROT_READ;
+	if (vma->vm_flags & VM_WRITE)
+		prot |= PROT_WRITE;
+	if (vma->vm_flags & VM_EXEC)
+		prot |= PROT_EXEC;
+
+	return selinux_mmap_file_common(backing_file->f_cred, backing_file,
+					prot, prot, vma->vm_flags & VM_SHARED);
 }
 
 static int selinux_file_mprotect(struct vm_area_struct *vma,
 				 unsigned long reqprot,
 				 unsigned long prot)
 {
+	int rc;
 	const struct cred *cred = current_cred();
 	u32 sid = cred_sid(cred);
+	const struct file *file = vma->vm_file;
+	bool backing_file;
+	bool shared = vma->vm_flags & VM_SHARED;
+
+	/* check if we need to trigger the "backing files are awful" mode */
+	backing_file = file && (file->f_mode & FMODE_BACKING);
 
 	if (checkreqprot_get(&selinux_state))
 		prot = reqprot;
 
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
-		int rc = 0;
 		if (vma->vm_start >= vma->vm_mm->start_brk &&
 		    vma->vm_end <= vma->vm_mm->brk) {
 			rc = avc_has_perm(&selinux_state,
 					  sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECHEAP, NULL);
-		} else if (!vma->vm_file &&
+			if (rc)
+				return rc;
+		} else if (!file &&
 			   ((vma->vm_start <= vma->vm_mm->start_stack &&
 			     vma->vm_end >= vma->vm_mm->start_stack) ||
 			    vma_is_stack_for_current(vma))) {
 			rc = avc_has_perm(&selinux_state,
 					  sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECSTACK, NULL);
-		} else if (vma->vm_file && vma->anon_vma) {
+			if (rc)
+				return rc;
+		} else if (file && vma->anon_vma) {
 			/*
 			 * We are making executable a file mapping that has
 			 * had some COW done. Since pages might have been
@@ -3799,13 +3894,29 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			 * modified content.  This typically should only
 			 * occur for text relocations.
 			 */
-			rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
+			rc = __file_has_perm(cred, file, FILE__EXECMOD,
+					     backing_file);
+			if (rc)
+				return rc;
+			if (backing_file) {
+				rc = file_has_perm(file->f_cred, file,
+						   FILE__EXECMOD);
+				if (rc)
+					return rc;
+			}
 		}
+	}
+
+	rc = __file_map_prot_check(cred, file, prot, shared, backing_file);
+	if (rc)
+		return rc;
+	if (backing_file) {
+		rc = file_map_prot_check(file->f_cred, file, prot, shared);
 		if (rc)
 			return rc;
 	}
 
-	return file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
+	return 0;
 }
 
 static int selinux_file_lock(struct file *file, unsigned int cmd)
@@ -6924,6 +7035,7 @@ static int selinux_lockdown(enum lockdown_reason what)
 struct lsm_blob_sizes selinux_blob_sizes __lsm_ro_after_init = {
 	.lbs_cred = sizeof(struct task_security_struct),
 	.lbs_file = sizeof(struct file_security_struct),
+	.lbs_backing_file = sizeof(struct backing_file_security_struct),
 	.lbs_inode = sizeof(struct inode_security_struct),
 	.lbs_ipc = sizeof(struct ipc_security_struct),
 	.lbs_msg_msg = sizeof(struct msg_security_struct),
@@ -7075,9 +7187,11 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
+	LSM_HOOK_INIT(backing_file_alloc, selinux_backing_file_alloc),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(file_ioctl_compat, selinux_file_ioctl_compat),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
+	LSM_HOOK_INIT(mmap_backing_file, selinux_mmap_backing_file),
 	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
 	LSM_HOOK_INIT(file_mprotect, selinux_file_mprotect),
 	LSM_HOOK_INIT(file_lock, selinux_file_lock),
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 330b7b6d44e0..b4be6588827c 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -60,6 +60,10 @@ struct file_security_struct {
 	u32 pseqno;		/* Policy seqno at the time of file open */
 };
 
+struct backing_file_security_struct {
+	u32 uf_sid; /* associated user file fsec->sid */
+};
+
 struct superblock_security_struct {
 	struct super_block *sb;		/* back pointer to sb object */
 	u32 sid;			/* SID of file system superblock */
@@ -159,6 +163,13 @@ static inline struct file_security_struct *selinux_file(const struct file *file)
 	return file->f_security + selinux_blob_sizes.lbs_file;
 }
 
+static inline struct backing_file_security_struct *
+selinux_backing_file(const struct file *backing_file)
+{
+	void *blob = backing_file_security(backing_file);
+	return blob + selinux_blob_sizes.lbs_backing_file;
+}
+
 static inline struct inode_security_struct *selinux_inode(
 						const struct inode *inode)
 {
-- 
2.18.0.huawei.25

