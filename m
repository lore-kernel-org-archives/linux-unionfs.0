Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E76347FC4
	for <linux-unionfs@vger.kernel.org>; Fri,  3 Apr 2026 03:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775185754; cv=none; b=d2OV1vkxO4AIGofaZOS7qud/rlM6QXk5IlJfvR4Jl4BegnqJlwkTQhr9abaEUGPwJ8TmPc7px66Fq8OXkZNtk5h1PtC1iTGyAJ++QvIHVbElZYmGRjXqv5YbmCuAo8gooiivP0HPsmWSMkxfR2yBRSXQNnDOCFtV6HpaM4B4YfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775185754; c=relaxed/simple;
	bh=yaq2D4Kebo2PkwIcQf407gzQXgOAU9Yt6G4sUCkrE20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaMk5Lyt90dxdy1HWV862/BKNjUKJOmFMGLy3dV/DtjZ9xPTOcqispwV+fG4/ZVzaHuI6XvoFexgHPCdnzQD8xKRfuujOE60wlCJYCotP5s5HSolcMi6ptsgiD/qZaVgsP3f9F+ckL6U08GwVAbqZD93zP7JZZrkFXRsiSWALsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=QiYqhH9U; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="QiYqhH9U"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50b392f1846so16642031cf.3
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Apr 2026 20:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1775185752; x=1775790552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lykgc06BXIBOf4QiOY++MDQGCTTginAiER02GjGA2DU=;
        b=QiYqhH9UiBRspd36fOK7rCmO5x16MiZ6ZNSwXMyv8vKVNqEYV+no0qaJz3HxrQPYAf
         4jDX8TVPWRTt9Nvu67LjqkVlmGhtp4vGF0x4r15Sm58ADm63SWRjRm9VL4wNB6iOOGAA
         u0qx2c1a5FkHhVM36ttYwjBnwMpqpSFAShVcaZsVKRhhz1Vpf+k5S08KF/8pjbeqDeK1
         Hj8qVTw38wiCM1RHGM23y0fHuje4omgn85NQrH4jV4Ek+18HozJl9zrix2VazvLozzPt
         tpSz342nEIlErUM2BAOBC5GSLsd8ydplJYsPlToEhcC9Gx7sUKshEawmxRVYSA+F2StS
         h3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775185752; x=1775790552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lykgc06BXIBOf4QiOY++MDQGCTTginAiER02GjGA2DU=;
        b=I81td3BIbFV5Wbch5f9OiXwP6zVASna6RkGNRdaIazywtHzAVWr4mVyaBzQsEqG827
         jyxIFwtQyiI33JckPd7dy92ntdX5bnA1lectRu03BF+QdqOeF8/VMboVNzGer1noCM9M
         0GVPDVNTHKM/ZTV0qOl+Sn4u7Xva7jEWywsvPzb4sg2sHXrwf9TSxo/+6iiULaOaKykm
         YVJRqgLXObTJAFZUt58aOWF6KwsGmu45LXP+r2RY4wxv6a6M9M1d0yEOrC+UMuM0PLzh
         hi6WobHZMtXyx09D+wRDyW6PLVkZ6M4VKdtniETNVlmBmG9zGkkdLaph0FBqzWxXjK/r
         SfqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx1rE6pju5z9/evQhE5vZb+ptKJECAFaw5b8IqZjUVq93iQDW8S/gyisz3gaZIWXkJ7own7/kaPcSK4R31@vger.kernel.org
X-Gm-Message-State: AOJu0YzhEystQBmXFSW77t//q1Bb8+YSoCIp/Z1Ou+cG8UYq030HJ2pp
	1yVDwqUMKYTCbR1//Y554Tn3Ox5jmaUnjmrwgZQV2cQEDKi45iLWcEYbEI3IUqWY1w==
X-Gm-Gg: ATEYQzwiDE49u/YLL8ezU7tWCUUgK0KhoTV0tTxgBY9+/CbZIJ2s8Y4oJxw9vyseAui
	s/kq3BYw0hZfhiJ/R1YhL4yQSdomEluX1J+KU2JIvQzhlpqCqTI8fOlCmb3nFVtRleRcJsUcTlm
	nYdX3dXsh+1+hnPeMI8fNP5hprLA19biPqhcJFIC8wBSvzIyGjNIj3PCTJyCZ6xhqciLaYimuUf
	RgQDUHYkHmIo4H5E9UPGoG6GRtErBg2cSjjdcLLLpqhbtQI+zTPzyESj9vWQMUz6yiGmLyYoFfx
	HJVIyQdNNbPdBaGJPCYkjCK1qlv2UHO7+7BMQJKJR6zzDmdoFxUoRpN4frSCr1qc5BmQyfZg0+u
	N+9fVXFkupiMqKERBG/WTxlqfUwW8UsSDdODHcBfGgiVnO6WznDEPVsHC+cuwOdUj7uRuNR+4+c
	CZb5xoXejx8cyssyM9zqBik0gdcT/YCyRTGWVK4hYzKhvWW16wq3CCxv3AnHvKzPaKZxpa
X-Received: by 2002:ac8:7d15:0:b0:50b:3a6d:db64 with SMTP id d75a77b69052e-50d62ae96camr27305031cf.48.1775185751870;
        Thu, 02 Apr 2026 20:09:11 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b73e7e5sm35303831cf.17.2026.04.02.20.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 20:09:11 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v4 3/3] selinux: fix overlayfs mmap() and mprotect() access checks
Date: Thu,  2 Apr 2026 23:08:35 -0400
Message-ID: <20260403030848.731867-8-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403030848.731867-5-paul@paul-moore.com>
References: <20260403030848.731867-5-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13546; i=paul@paul-moore.com; h=from:subject; bh=yaq2D4Kebo2PkwIcQf407gzQXgOAU9Yt6G4sUCkrE20=; b=owEBbQKS/ZANAwAKAeog8tqXN4lzAcsmYgBpzy9HldP16eHiCJ+mwObRveQJ2Gln0HedCwxRN VGaah0yULaJAjMEAAEKAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCac8vRwAKCRDqIPLalzeJ c7GLEACntKgi6d+d6yteJxF2tw9/qjnBQPa8wdrCch3KGEw0hvsSOkka+OhLqm+HXq3SUQsuMBx 5n5Yh/oYGwstW8F54Luk6qADBTv9qQxvWSw81sKVu8FWeWxxb/sUsGAjXg8unYkQCB3NWPV0F8R 77ABaWbhxecuZ6pRS/O4hrU6sbrEnC2iMaCT4RdJSWM3ldSCsf2Knr0LkauIF7/YUxm+A936xqg MTtoHYI5SQAEAtKOXe6ksnyTkUxsuVfhLu140AUwqmLGlbBeqI4nxBOaY/Qtom85nolyKhB8VA8 /UKP+CJbJSumyZGeUGPT4JOw0ZWFWZ7DdcjWKeVbHr/KRVMz82Sn49p6QJ+SEFsCcCErrV9ao+h WgWILzJJYRx0cD7kXOKbEDW9/Xp3EFRkBh5SA8F/TkHchz6I9ccUdTULu2KX17i942toKZmYaQ4 GU9y0FJ7fF/YlUn6dnrKRVHDJ+mkhQNm1/NBPHCecy61/6Ow/94dkU9JM7fw9b/d0fC2vG2Xrcd sx1pIf6eKmWkmxeD4W/HYujU3D5iyKyPq9lNqoCAjkEZXubYyYg/IqElMhDeEo+iWpIiYPvplTr 6FbzQo966xFXPEJev+9dDEEHNKdycHyesEicV97XY+emh/qleQWr4yaluTW1DqYCV1/VhLWzJ+J 0J3ayw+5K6gOtKA==
X-Developer-Key: i=paul@paul-moore.com; a=openpgp; fpr=7100AADFAE6E6E940D2E0AD655E45A5AE8CA7C8A
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 security/selinux/hooks.c          | 256 +++++++++++++++++++++---------
 security/selinux/include/objsec.h |  11 ++
 2 files changed, 196 insertions(+), 71 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d8224ea113d1..76e0fb7dcb36 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1745,6 +1745,60 @@ static inline int file_path_has_perm(const struct cred *cred,
 static int bpf_fd_pass(const struct file *file, u32 sid);
 #endif
 
+static int __file_has_perm(const struct cred *cred, const struct file *file,
+			   u32 av, bool bf_user_file)
+
+{
+	struct common_audit_data ad;
+	struct inode *inode;
+	u32 ssid = cred_sid(cred);
+	u32 tsid_fd;
+	int rc;
+
+	if (bf_user_file) {
+		struct backing_file_security_struct *bfsec;
+		const struct path *path;
+
+		if (WARN_ON(!(file->f_mode & FMODE_BACKING)))
+			return -EIO;
+
+		bfsec = selinux_backing_file(file);
+		path = backing_file_user_path(file);
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
+		rc = avc_has_perm(ssid, tsid_fd, SECCLASS_FD, FD__USE, &ad);
+		if (rc)
+			return rc;
+	}
+
+#ifdef CONFIG_BPF_SYSCALL
+	/* regardless of backing vs user file, use the underlying file here */
+	rc = bpf_fd_pass(file, ssid);
+	if (rc)
+		return rc;
+#endif
+
+	/* av is zero if only checking access to the descriptor. */
+	if (av)
+		return inode_has_perm(cred, inode, av, &ad);
+
+	return 0;
+}
+
 /* Check whether a task can use an open file descriptor to
    access an inode in a given way.  Check access to the
    descriptor itself, and then use dentry_has_perm to
@@ -1753,41 +1807,10 @@ static int bpf_fd_pass(const struct file *file, u32 sid);
    has the same SID as the process.  If av is zero, then
    access to the file is not checked, e.g. for cases
    where only the descriptor is affected like seek. */
-static int file_has_perm(const struct cred *cred,
-			 struct file *file,
-			 u32 av)
+static inline int file_has_perm(const struct cred *cred,
+				const struct file *file, u32 av)
 {
-	struct file_security_struct *fsec = selinux_file(file);
-	struct inode *inode = file_inode(file);
-	struct common_audit_data ad;
-	u32 sid = cred_sid(cred);
-	int rc;
-
-	ad.type = LSM_AUDIT_DATA_FILE;
-	ad.u.file = file;
-
-	if (sid != fsec->sid) {
-		rc = avc_has_perm(sid, fsec->sid,
-				  SECCLASS_FD,
-				  FD__USE,
-				  &ad);
-		if (rc)
-			goto out;
-	}
-
-#ifdef CONFIG_BPF_SYSCALL
-	rc = bpf_fd_pass(file, cred_sid(cred));
-	if (rc)
-		return rc;
-#endif
-
-	/* av is zero if only checking access to the descriptor. */
-	rc = 0;
-	if (av)
-		rc = inode_has_perm(cred, inode, av, &ad);
-
-out:
-	return rc;
+	return __file_has_perm(cred, file, av, false);
 }
 
 /*
@@ -3825,6 +3848,17 @@ static int selinux_file_alloc_security(struct file *file)
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
@@ -3942,42 +3976,55 @@ static int selinux_file_ioctl_compat(struct file *file, unsigned int cmd,
 
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
+			inode = d_inode(backing_file_user_path(file)->dentry);
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
-		rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
-				  PROCESS__EXECMEM, NULL);
+		rc = avc_has_perm(sid, sid, SECCLASS_PROCESS, PROCESS__EXECMEM,
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
@@ -3993,36 +4040,80 @@ static int selinux_mmap_addr(unsigned long addr)
 	return rc;
 }
 
-static int selinux_mmap_file(struct file *file,
-			     unsigned long reqprot __always_unused,
-			     unsigned long prot, unsigned long flags)
+static int selinux_mmap_file_common(const struct cred *cred, struct file *file,
+				    unsigned long prot, bool shared)
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
 
-	return file_map_prot_check(file, prot,
-				   (flags & MAP_TYPE) == MAP_SHARED);
+	return file_map_prot_check(cred, file, prot, shared);
+}
+
+static int selinux_mmap_file(struct file *file,
+			     unsigned long reqprot __always_unused,
+			     unsigned long prot, unsigned long flags)
+{
+	return selinux_mmap_file_common(current_cred(), file, prot,
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
+					prot, vma->vm_flags & VM_SHARED);
 }
 
 static int selinux_file_mprotect(struct vm_area_struct *vma,
 				 unsigned long reqprot __always_unused,
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
 
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
-		int rc = 0;
 		/*
 		 * We don't use the vma_is_initial_heap() helper as it has
 		 * a history of problems and is currently broken on systems
@@ -4036,11 +4127,15 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 		    vma->vm_end <= vma->vm_mm->brk) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECHEAP, NULL);
-		} else if (!vma->vm_file && (vma_is_initial_stack(vma) ||
+			if (rc)
+				return rc;
+		} else if (!file && (vma_is_initial_stack(vma) ||
 			    vma_is_stack_for_current(vma))) {
 			rc = avc_has_perm(sid, sid, SECCLASS_PROCESS,
 					  PROCESS__EXECSTACK, NULL);
-		} else if (vma->vm_file && vma->anon_vma) {
+			if (rc)
+				return rc;
+		} else if (file && vma->anon_vma) {
 			/*
 			 * We are making executable a file mapping that has
 			 * had some COW done. Since pages might have been
@@ -4048,13 +4143,29 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
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
@@ -7393,6 +7504,7 @@ struct lsm_blob_sizes selinux_blob_sizes __ro_after_init = {
 	.lbs_cred = sizeof(struct cred_security_struct),
 	.lbs_task = sizeof(struct task_security_struct),
 	.lbs_file = sizeof(struct file_security_struct),
+	.lbs_backing_file = sizeof(struct backing_file_security_struct),
 	.lbs_inode = sizeof(struct inode_security_struct),
 	.lbs_ipc = sizeof(struct ipc_security_struct),
 	.lbs_key = sizeof(struct key_security_struct),
@@ -7498,9 +7610,11 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 
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
index 5bddd28ea5cb..b19e5d978e82 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -88,6 +88,10 @@ struct file_security_struct {
 	u32 pseqno; /* Policy seqno at the time of file open */
 };
 
+struct backing_file_security_struct {
+	u32 uf_sid; /* associated user file fsec->sid */
+};
+
 struct superblock_security_struct {
 	u32 sid; /* SID of file system superblock */
 	u32 def_sid; /* default SID for labeling */
@@ -195,6 +199,13 @@ static inline struct file_security_struct *selinux_file(const struct file *file)
 	return file->f_security + selinux_blob_sizes.lbs_file;
 }
 
+static inline struct backing_file_security_struct *
+selinux_backing_file(const struct file *backing_file)
+{
+	void *blob = backing_file_security(backing_file);
+	return blob + selinux_blob_sizes.lbs_backing_file;
+}
+
 static inline struct inode_security_struct *
 selinux_inode(const struct inode *inode)
 {
-- 
2.53.0

