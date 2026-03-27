Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE0039D6DB
	for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2026 22:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774649107; cv=none; b=dQ9q4FMMXcwBi40MWYaLmw7m2p/0mb5aQXiyxNVVEx81w3R4n7/lXbh+qWyaSBDu8l09VWNjKXLGbugjiLezIrKhEjb5K/Ayz6978Qk1qxMFq/bVGfvk/wh9v0JCCghmNIWI1xi4I63DBUi0Rd78FSkujr10zNK+GRLmt5LlGMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774649107; c=relaxed/simple;
	bh=uAsoCWMtcPyMp/S2SCYo9T7XmE/BIztqzDW98RmcLw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox4Rmvrazr7ZNkxAImnKQUf0RnrtsLUXKWXVuO+u8gNqABN7Om3g2zBJ+LxF4NDil2ZauRIZ9Z43YeXDChcN52PBjjRzw1IRaiOf7zTRs2x4gC/GJtsMKYUTmoNzn2wb2L5W8EE0Z93g9eH+NfU4FNIaLlfDzj5UeuVaJk2uOz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=AO/k6HSI; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="AO/k6HSI"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd7284782dso166641485a.1
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2026 15:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1774649105; x=1775253905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rvmB3982RCg91CztQ8nF7ZM39jIt6VKpquOeXwnbw0A=;
        b=AO/k6HSICfFc0PlayzjVZlleKkYn7SfrGS5KSFy50MUTB8yy/QZEcpkRxbMTLC2RcJ
         zdJuXLSjI6brPRuZY3VIgHLcRYdq39GnbliyhRntIMIfT6v1+M0mZ2k+ostA1HSFzcYE
         Y3xg2BSuFU2Q0PImFeUHc0vvXTCDqaEatf9SXyy31fSqMRY3vuAKR7lhu2YGVNjzvOL1
         Jrmv1FcUlDcqDQ7S4jb7l/8KmvUBmLe7bjJPWLowcGQlhYoH5pgBtlvU4k2sDoVpfmDK
         umIxoYo5wkGyc9bv9W8Bbh3B3h+ae3cCc2gudQGB71St4+Ts2XhrIvS+8sICiLYbHH6T
         wPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774649105; x=1775253905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rvmB3982RCg91CztQ8nF7ZM39jIt6VKpquOeXwnbw0A=;
        b=oMrF1lPoTOgI9A5NO0TzWMeAEJ8aIxy3a636cnxjBnvqtBheCgwUMBy+Q19F3H5eXD
         doG70binwDlW27m9PsM9eNWaEFBc6KacY8KMUYJKGWLEQfn1v5WyhahBDWNMw9VwvXOz
         ZquPRTXUX+WcglvZLNBva+DIDwFU3uXwv+uh/5Qx4UGNysUXm1dmd/QK4b97ZRFYYfaF
         EgXA9F7eMZOFJ9lzQJEUKok1qqayt3Dx0YwwTGvxflTiuOPCqDeAIb+z8CErbMxRR2LW
         EfEtBg2QavJdQxhwpJZmFmbrC3jGJuhikPsE5RcuQ0iUV8kT+Y+Jf0s2y1KwLa2N0DqU
         KJ2w==
X-Forwarded-Encrypted: i=1; AJvYcCV8i4jtl3YUY9qRwng5DYzQ3+/JqOz6tu1RskcZylMGTW6sYyNnC1NuTGtm6cbNItgXi4vvuaJRQIE03lxI@vger.kernel.org
X-Gm-Message-State: AOJu0YwIFeExwiBQ7nT97dIKUCccC+YNbPEqWPkzkps+lgCDSB0OsjNI
	atzSsLWpymH3lMr1Iqs/+PHXnHpuPdrQr/WRhAnEpKWnG558rl3x3vXGYR5aBndcfA==
X-Gm-Gg: ATEYQzzhmD2VCmjHx0IKzMj915GDdok/oIFpk8f4k6cg0xOO++zDXSjnszbOhMroBq9
	O9TapuVm17hkkwUIwuQfmuF6JuQ/Z565LwHoM0dvKStFzMz2T8fs3MVwcCZJX87ud37dB7+gAPM
	1f37CVv7zZtZq7BdiFWNhJxpfJc3PTPCXLg0wZ2YiSl5bKsFrny5IJejaCsdFOhfd//DuAnaCay
	GxQ051uaPRdIAMqNiV1/fNo6/ogJlr1jhqgeqPI5spjK75xhBjATZTzCKF6b+oAnpY0dSeTiqXx
	NY5W/libY4dHa0u/zBGTnhraXYie08yN1SU1M9Ei6fk3+Toi7py2dN7fL4werzoYgdMRlDNKsbV
	dnPhEDwyWZ5dTKl8S1+rtdPKp1rFG5A6o1tcC75VQHXOYIbsrjxoxeh1dfAvnsq+cDuxkeVSom9
	CBB98utap9wvFBI2b+W4K6L+UWPfL1fiwf+AiSvePZ/9d5UG8rsQ1WQK0CHisw+zNAtXLv9dKza
	c6DaHc=
X-Received: by 2002:ad4:5d4e:0:b0:89a:b20:9f4f with SMTP id 6a1803df08f44-89ce8ecdf21mr64567106d6.29.1774649104663;
        Fri, 27 Mar 2026 15:05:04 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf2820d8sm3741006d6.26.2026.03.27.15.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 15:05:03 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v3 2/2] selinux: fix overlayfs mmap() and mprotect() access checks
Date: Fri, 27 Mar 2026 18:04:33 -0400
Message-ID: <20260327220446.353103-6-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327220446.353103-4-paul@paul-moore.com>
References: <20260327220446.353103-4-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=13699; i=paul@paul-moore.com; h=from:subject; bh=uAsoCWMtcPyMp/S2SCYo9T7XmE/BIztqzDW98RmcLw0=; b=owEBbQKS/ZANAwAKAeog8tqXN4lzAcsmYgBpxv8CTc3P8pX++ZLYVj2X4l6uAGngrffMBiWtp p71eDswIVqJAjMEAAEKAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCacb/AgAKCRDqIPLalzeJ c1QwD/96PuDqq9HRBacHpqPQXBRFukLJaPYxlXHSW6AH9QXBXwjCQQB/uNQEqk+DkwLfpMY5eXF lY5V/UCM3FgUjfJYYxGBHOIt/ZJND+uqJsZYGoIR1nBmJqsjgb97Dk8TymNaSh9+nr8zuShUCvP fWwfddhRsAYOyZwt6bT9+jZStuKUKyBjkppyqRf5VS/ctHKDhoBAMJmqMIzihpHF7VduqKcg+UY G0xW+Yn6Qa7pSoFGz2Iyx8jsKZTCL/6UBYcsRTbyNznwYbZYQJEnOwkArAtgEHw5f4/iBpCnNJv 352sn7QxCLYKXMsE9SiZBKNhn8zJ28NltTe7/dICgzbmy4hkVlm7sxHRvroTKwiiapP0RgBZaX6 xNn4NaZ0pPnA8dZTqXgwMX6qBPpBr5IvQupE3fUurud9KrUuLkg6SS+2S9DshXploZbpGY0q808 1cgUV9duBo7NM6VWvBCpieQK0cLogM3Mjr+8WCzWEbSDhNcCLkXbWjQPRj7jgJY0rBxHgV/LtND YU1PX0j1DgOlIznVyuP63Tt/rAFRnLJ0vgkxEtNR6I04J+u1YXDGbnVBOV/7jgUsX6xuGH6AQp4 263XOOt045E87l7m6kiTDLB9Pypeyy32Z3U7jLQkNvpawOQ454XA9GB30l9MPoHDv7Axq0Iuwt4 Vecbft1u+WNO0hg==
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
 security/selinux/include/objsec.h |  17 ++
 2 files changed, 202 insertions(+), 71 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d8224ea113d1..d8557da79480 100644
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

