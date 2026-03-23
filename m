Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F99285CAE
	for <linux-unionfs@vger.kernel.org>; Mon, 23 Mar 2026 04:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774239930; cv=none; b=k0cs8qvnOg+p531kja5RcPJfBP7DwuQSEtqxEVg11zQ6Gfjy+U3MbBpMxL0cWmXdd6SPeUkYsoC+F5tQ1YY6armv7ThWT6GMhbzpDa6YKqOdx7cLNnQ4luxZkAwLu33iLA1lbE0epyav77rf94aTQF9CJuTVYQPi8UVT9SaT9Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774239930; c=relaxed/simple;
	bh=nzUCz7ZB5keyb41k9iDHOI3IuomI6bVAhQJA1be4P8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KofjRmsPdYFbzJMAZQuRNrAWOnHouNuewr5d63+YXJGy4cI3B1aCF4ztFl+FR4N6N9GXrfJdx/7v/NJTapgFyY4CcSJ5g6Yn/jigOfmAcpD7BkY5N+ZaxeqJeIOB5qSWYq1J1afQfcobb60K8OZK9hdKNQKICdbsAEpV9wdlB3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=gYclEpJ4; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="gYclEpJ4"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cfd44fa075so232799985a.0
        for <linux-unionfs@vger.kernel.org>; Sun, 22 Mar 2026 21:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1774239926; x=1774844726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7U27J7HcQ8gqGSIMPqPTovtzABDCE7XHkZOKPjJ8mj0=;
        b=gYclEpJ4uC0DdtggmWdnlXKiKNYTH7sfr24qsjJLJo6wqd4UXp91ys0ctwcMfx5QL5
         flJE1DJc/ZF2MRCuVK7A8KYKTt7diCjVvBGNxGi/PIVbLZ/Jj/usCLbq4r4+xW3vjUYT
         cYWUZ1xbsp2LITZ8hjEItrC9IxAjvqdFA7adYrHKiniG5a/8WA02494rjzWMhEbnK25Y
         BESvoCCP9mLXQy4CMEqDdOXCYPQ/t7HNXXriYlojymKCVUn0zBSC3Pp6PjtrFiYRJewD
         TSs4k3g7xh0qq54l/0fzr3jMJ5uhbQ1H/tjruC9dObLI1oFosfCWX7tzOUUsr5xF5uO0
         gmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774239926; x=1774844726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7U27J7HcQ8gqGSIMPqPTovtzABDCE7XHkZOKPjJ8mj0=;
        b=jLI/Jjn6h3hNAyBMseyiLoS2xWRGlaiMkXBnT2ntvOcLamOtJAUBecuVQjDiFu/jth
         C+3y+bR9Zqhzsf/DBlPrA72UgTQLobfh8UHG23FqP7MiSGIX8W1CiFK8eDAj7uev9UYz
         E0MqKlkHc+GVF2E9/D9iGbOhPT2gDDyTMZI+qoeypyw12qWxJHhd0Cls2gbm3GQDRH+E
         OP8cLgRwytoWuqoJHVxYAapQOFUBm7qyupqPDfqfxUKaqHCLnHFmKN5HSpDV0BPWInXr
         clDX3FzadQlKE0OMKDuAsEyd4buV/2DtvcvHeC1cdJmjEG5C8OX8aJdUIANuRRZFku6T
         jm7g==
X-Forwarded-Encrypted: i=1; AJvYcCX3w6aUL3He1194hBem7UZh2pCU/c7HJPLUm3yeMPt+8FltA9BcCSE4JjfuTbFBkCIqj6xr5XFDapi+qB/S@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+UunNRVRLewVwD85yxt1zn9ppkcCEOkiOai0hJUyf6LbXbCxB
	C5srLQSWCJJkmyJDK8Sfm0RZ1u3/cx1ZEQUSGjk82a6qRLImkvtMD4o6knwON8NE3/kSC6tOTBQ
	48Bg=
X-Gm-Gg: ATEYQzwiKvY8FZZywdn1slcQR5F5zcLWt77/qy4QZ2wP0DXe99sXDNNCseLczMz5mAn
	ZI/gKVTu9uiQ4FVUUU0P70nfyyxyCMh7N7yme4BxEotEW5+LOWIxTbj5F+h6Hj59vXizpmWd1qY
	A73QjEaaMD+ZZEvur6XVnvZfH2+hSC/nEsp8Nlq6UVYeugd/H+bdZ6/jmAviTvVKiP0FewRBjjm
	ChIA7wbjStRHTJdqrzuzDvZL7MUfEBCUEEoQL3gRrBot/B1ymBvZ+jXt4s6LOo2k0nuxFYRZhWa
	TZ+F1FM0x8lqbBWERdyHF5F/HD4L7T6h55gysWLteMEsm9OCodBDwwPgZYmIjiszciAk6nZlkwt
	EsSG28NUhfmJ3E9ghvByqeqPDkZAQcfznVyblK9kCpa1FTbgsYIq8C73f+zAOm0bN2aRqz28NvP
	WxVTMB4j67FIMYGLU2QX7ik99xOmQA7sgoJqHsgQY4PelOzIAkucZJjHJSqG1djgL58MKG
X-Received: by 2002:a05:620a:2698:b0:8cd:afe5:eb91 with SMTP id af79cd13be357-8cfc7f4af8emr1651381585a.42.1774239925970;
        Sun, 22 Mar 2026 21:25:25 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90e7587sm694331885a.46.2026.03.22.21.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 21:25:24 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [RFC PATCH v2 2/2] selinux: fix overlayfs mmap() and mprotect() access checks
Date: Mon, 23 Mar 2026 00:24:19 -0400
Message-ID: <20260323042510.3331778-6-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323042510.3331778-4-paul@paul-moore.com>
References: <20260323042510.3331778-4-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13625; i=paul@paul-moore.com; h=from:subject; bh=nzUCz7ZB5keyb41k9iDHOI3IuomI6bVAhQJA1be4P8Q=; b=owEBbQKS/ZANAwAKAeog8tqXN4lzAcsmYgBpwMCpcqpl055EfTNuM9GJWfZJ4Qdlrz3uURXvJ ulaQivpiTqJAjMEAAEKAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCacDAqQAKCRDqIPLalzeJ c6JzEAC4s7qXWPAbAlDixGMV+/wSH64oJn3tmg0OENNiCZ9QvcYZjmuU3ZkaghfyQ8rOJjY69lD 6EIH9gSJzrUoVspTyiYax+XEQaRul3aDA6oQ0rXpZrAwjhjeEJajhGC4jUXP3hmJTt7FW0vvzSR J3T84VjwrGbr3/kngIwds3azad3SE4434EzzuD7/GO3Zaare1V0xRH5q7kpJdGI2W0qdoOcapbU epadFctPRipi30nwB5M9+ck2TMGxA3JYkk4WmnmHhNsrzYAp7BCHo018UMEqDCx7sQd/OxI5rKa aWZFCVbBjRRZ5N7SFJS2hM1Mm5oSMUX5vbD779zchJ2Qbse1ZAyF43ZmSWvwPhbAGCXFIk+4jbo +ohlOfppxpnfOJmWkHLc9MskhaGy1lXg9AaeRXJT3XYalNa8iovQi/8dik7Iw0o17SbwbAJfoZt pe0YmaNeZTDuP3zT0ZRTUlSh6Zj1qaf2ASHo7Qz4Fso+d7kfZH+z2h4EAlPZcQCbkoMkIVPDzt7 nM3OsKmWJ6/sEEZXlbSbXhbNAUkC0b5QK/Yi6Tqd0Co8/J+NVntIS6uxH+m9aPuZJ/I6LJk1dFu bh391ngPwk1gA8zkStyI7BURngAfJKoecgdezDa+OoTOl7+SSGIh5cMqKceq90w+XL+0krmfCMM xFdCQFySRb6uslg==
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
 security/selinux/hooks.c          | 252 ++++++++++++++++++++++--------
 security/selinux/include/objsec.h |  17 ++
 2 files changed, 200 insertions(+), 69 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d8224ea113d1..2a3d524dce24 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1745,6 +1745,60 @@ static inline int file_path_has_perm(const struct cred *cred,
 static int bpf_fd_pass(const struct file *file, u32 sid);
 #endif
 
+static int __file_has_perm(bool bf_user_file, const struct cred *cred,
+			   const struct file *file, u32 av)
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
+			return -EPERM;
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
+	return __file_has_perm(false, cred, file, av);
 }
 
 /*
@@ -3825,6 +3848,17 @@ static int selinux_file_alloc_security(struct file *file)
 	return 0;
 }
 
+static int selinux_backing_file_alloc(void *backing_file_blob,
+				      const struct file *user_file)
+{
+	struct backing_file_security_struct *bfsec;
+
+	bfsec = selinux_backing_file_raw(backing_file_blob);
+	bfsec->uf_sid = selinux_file(user_file)->sid;
+
+	return 0;
+}
+
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3942,42 +3976,53 @@ static int selinux_file_ioctl_compat(struct file *file, unsigned int cmd,
 
 static int default_noexec __ro_after_init;
 
-static int file_map_prot_check(struct file *file, unsigned long prot, int shared)
+static int __file_map_prot_check(bool bf_user_file, const struct cred *cred,
+				 const struct file *file, unsigned long prot,
+				 bool shared)
 {
-	const struct cred *cred = current_cred();
-	u32 sid = cred_sid(cred);
-	int rc = 0;
+	struct inode *inode = NULL;
+
+	if (file) {
+		if (bf_user_file)
+			inode = d_inode(backing_file_user_path(file)->dentry);
+		else
+			inode = file_inode(file);
+	}
+
+	if (default_noexec && (prot & PROT_EXEC) &&
+	    (!file || IS_PRIVATE(inode) || (!shared && (prot & PROT_WRITE)))) {
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
 		if (shared && (prot & PROT_WRITE))
 			av |= FILE__WRITE;
-
 		if (prot & PROT_EXEC)
 			av |= FILE__EXECUTE;
 
-		return file_has_perm(cred, file, av);
+		return __file_has_perm(bf_user_file, cred, file, av);
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
+	return __file_map_prot_check(false, cred, file, prot, shared);
 }
 
 static int selinux_mmap_addr(unsigned long addr)
@@ -3993,36 +4038,80 @@ static int selinux_mmap_addr(unsigned long addr)
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
+	bool backing_file = false;
+
+	/* check if we need to trigger the "backing files are awful" mode */
+	if (file && (file->f_mode & FMODE_BACKING))
+		backing_file = true;
 
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
-		int rc = 0;
 		/*
 		 * We don't use the vma_is_initial_heap() helper as it has
 		 * a history of problems and is currently broken on systems
@@ -4036,11 +4125,15 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
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
@@ -4048,13 +4141,31 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			 * modified content.  This typically should only
 			 * occur for text relocations.
 			 */
-			rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
+			rc = __file_has_perm(backing_file, cred, file,
+					     FILE__EXECMOD);
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
+	rc = __file_map_prot_check(backing_file, cred, file, prot,
+				   vma->vm_flags & VM_SHARED);
+	if (rc)
+		return rc;
+	if (backing_file) {
+		rc = file_map_prot_check(file->f_cred, file, prot,
+					 vma->vm_flags & VM_SHARED);
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
index 5bddd28ea5cb..8ec493064aa2 100644
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
@@ -195,6 +199,19 @@ static inline struct file_security_struct *selinux_file(const struct file *file)
 	return file->f_security + selinux_blob_sizes.lbs_file;
 }
 
+static inline struct backing_file_security_struct *
+selinux_backing_file_raw(void *blob)
+{
+	return blob + selinux_blob_sizes.lbs_backing_file;
+}
+
+static inline struct backing_file_security_struct *
+selinux_backing_file(const struct file *backing_file)
+{
+	void *blob = backing_file_security(backing_file);
+	return selinux_backing_file_raw(blob);
+}
+
 static inline struct inode_security_struct *
 selinux_inode(const struct inode *inode)
 {
-- 
2.53.0

