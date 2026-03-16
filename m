Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D470366064
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Mar 2026 21:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773696990; cv=none; b=jLLYCGGJSYcBvPQfUGRMu+YWI03tuBH2NGErHarnJPsOlOfXrFPPUEOTU+jnnqpQkODojMbjpWnMIAfZaH9FLvuw84mr90spcX9y1P4bRyU+xNh+fQa59lgHNMgvZD2osW8HvEmpFLUHATvuoMZJXEobfHej5QOmB0C7VhtfoGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773696990; c=relaxed/simple;
	bh=WtafcBhkNjwN/vp7IcaPNnu/9+5NgIh+9C6Xc3B9scE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uwgb9nagMshCwzBVsarlmuiGM1Ys4KKWCQu4NqP6A1vauoSJhBT1u1g29/k+5Lv+GJfUEjcbEcVNoaNdEiuYlHz9de4I57fkiyXxpfYHbmeuRUEv02TR9kN98Y8SB8wa0HKL7rTgrjq7s2krepjOTy8yhuHD/tcUXfO9Xku0U5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=JhNKs3y8; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="JhNKs3y8"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8cd77786e97so510474785a.3
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Mar 2026 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1773696986; x=1774301786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTsLH1MNdb+4eQsSukde0PobQXZ5LXJ2xbUvSGeH18E=;
        b=JhNKs3y8FPHUZHUJGjxluqZy1QEXQPIWb3FgYwtRFXEEy4w+Cix2+ALecLON7F6tId
         9AxRblbiUEif00M89utGZXCw2wCX+e1/qoSbtxK6FDI0ofAu6mhsfYjQDHh0bJecDSLu
         6uMJg1dRA9685gHuMeIe64Lwx8kW6+VZCV3tiifywn3fFUrYvivkFT8k0V8lQFbtZDGF
         X5Cjz0O7LYwDs3COLatjHfF0OUQm/lgzZLF4Feho/QO8CFIcxN0v6LcwUK56Nzyysxb0
         y8/Uo7EJBRxtoQeUL+Zr4DcpvEDG+Kpx4ocTLTAuyPQYybR7ouRFDmDpgTmU+wK+SNYt
         UUhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773696986; x=1774301786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hTsLH1MNdb+4eQsSukde0PobQXZ5LXJ2xbUvSGeH18E=;
        b=qQRVU/ZxjUGOJ0vVjeghfihVS6QW5vYu1NGbAnEBWpQAiY+HUG7VBJYmGWYKRLHRYD
         wW00zYBoks6E5x4wCVRcjR5EMvADgU59raa6UDgN1fz4QviCmpT4OD6XhKT9AKF2qbnv
         RX5jsnN81V916eP+ezeeUE+pzSRM2n+WELyPAmJjWWm2XVV7oAPSsJ0agjZtNJGbsViu
         o2uup2Ko3L9U23BfmbO/OlT3z7zQlG6uuW88dIKsRzV7njbA4tc9wrXv5Nm5txDwEzZy
         cXmXiYoYFdZ2hXgwUI7Nui03PUO/eeJaq/W28VLQKb+sdh7dTmhowiSijMxdgA3yJOUk
         h8UA==
X-Forwarded-Encrypted: i=1; AJvYcCXJm42C4WoN6HAgjA7c5JPkcJilabPMY7Q4TiEV7wW2qsxYv/qpijV34gCLlLsNy0yx8KBydE6MOEzK48B1@vger.kernel.org
X-Gm-Message-State: AOJu0YzIkvgUKE5mGHd3y9hh7+1sTGU+YPffNPFjJIAcOZkoC9AZjuek
	l23xBUkqip72I7AuM1fbWjIvUsTRfD22CcuaqY24RC+oFAMGFGJndwDVDU9Ooek2iw==
X-Gm-Gg: ATEYQzyCDVgDtR9lLrvNEz7IPJ79LGe3coj0msRdHHWYAoYRH1a1oBcApfq9nwsFksW
	bKYd3Ve9yo+5tQRrBp+/HQXAJ+I6JJZTTPKGybHJKpj+ZadJUTcLG7+5HwTwwu5xOhNx1xBQyCt
	9+hl1SZbvKsB0QYgyQfzZf5Vmk4+VCW0mMEDSA9cqgp/je8jXi8uFAb2stFLIoC1WFqB8lYzAKo
	EsQPnaM/onhU6S49L3i+/WMBs5uiE5HmysfOyOiPdmb3IazLjLSrEg+ERvYb1kXpCx++wAAE+Z7
	z/VmTe4cvPghSKzw9xOxIPw6rDn4kJhkWKwzd5afey0vdmuEMzx6O0ca9pXl8+5LYcURnzrQb6R
	rWmxQofenByAmj1MDGPlrxBfyL4PY73yYCJxQIfY/DoNtrd8jaT+bJI5hNCwxqPGabEQ6SFeZBl
	zXXeMRG9Ui8to8YuG+MttIZlQO6bQ/MMJ+KoBY/+vSbydR79ZMcMncFcju9j4C5D+4EzQ+
X-Received: by 2002:a05:620a:4452:b0:8cd:91b4:8225 with SMTP id af79cd13be357-8cdb5b21c1bmr1920572085a.40.1773696986434;
        Mon, 16 Mar 2026 14:36:26 -0700 (PDT)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda2151db2sm1241918285a.44.2026.03.16.14.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 14:36:25 -0700 (PDT)
From: Paul Moore <paul@paul-moore.com>
To: linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>
Subject: [PATCH 3/3] selinux: fix overlayfs mmap() and mprotect() access checks
Date: Mon, 16 Mar 2026 17:35:58 -0400
Message-ID: <20260316213606.374109-8-paul@paul-moore.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316213606.374109-5-paul@paul-moore.com>
References: <20260316213606.374109-5-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7434; i=paul@paul-moore.com; h=from:subject; bh=WtafcBhkNjwN/vp7IcaPNnu/9+5NgIh+9C6Xc3B9scE=; b=owEBbQKS/ZANAwAKAeog8tqXN4lzAcsmYgBpuHfNl2n7U5d3uCSuiCJ0pcaLH2KBlzhET15UZ /VXba2LXguJAjMEAAEKAB0WIQRLQqjPB/KZ1VSXfu/qIPLalzeJcwUCabh3zQAKCRDqIPLalzeJ c/r4D/43yZPGbaF4C/icZgs1GQN6W84UpGasnfPDaWHYaEJPvywAnFA/BsR9Bx56Ag5xdtx9/Gj 1auuQ3dKUwZS19EMzIG/0XLs2KN4lHJsN/1ZMGDfeurZXRkkGO+gpirLiOcUJT3cW6WXL3FEOMB M+vpqKVfywXWnm9AjtHKbBUneccnmqTtLn+PhnWleJBieZBFsQu1fVLduG7Xpdywl0ZJmrfFYYc Wc0Mlj3LfLhJ4COyiolcKYaT2rJxP2m3KOo4VmFAJc5OLOklkG1e6xbLyrbrkMajrDfMCVW8lDa /84AlvlfHOhUtTruAM11fynwQa508e7MVti0Z+MeOSd+9o5TgQYrV3/8rvHmEfcbxgHXoL71dTX wuC24MPUfUZoZ+X6gujHb8MOC4uSa+e3bEEQBW/zHzQlVAK+xl8ptCQeqkG5cu1KPyor30J6oLK eVTvnl1jRU0GWLC2Nx9Whi8uY1g4zkh3i/9FQ/cxuzQ/w3wRb8J5odeMtC4COYPFfu1qYog8TLF KdPKH+qNJGu/uer+B/hQoG/MkU6jCtrRIafiP7floG+bc5w64CGButwO4TLstTemt0Fb8vjaQ8f K3Gr/Hc3rN3SXFQm+1hjRWdfKjExHcH/lyCYwAWuyg+P2/0xXbx9bGmasehfhFpqAFY+6H3qC6z EFYJs2NeuiSWSUQ==
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
operations on overlayfs files, and leverages the new
backing_file_user_path_file() VFS API to provide an equivalent to the
missing user file in mprotect().

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 security/selinux/hooks.c | 108 ++++++++++++++++++++++++++++++++-------
 1 file changed, 90 insertions(+), 18 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d8224ea113d1..013e1e35a1ff 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -94,6 +94,7 @@
 #include <linux/io_uring/cmd.h>
 #include <uapi/linux/lsm.h>
 #include <linux/memfd.h>
+#include <linux/backing-file.h>
 
 #include "initcalls.h"
 #include "avc.h"
@@ -1754,7 +1755,7 @@ static int bpf_fd_pass(const struct file *file, u32 sid);
    access to the file is not checked, e.g. for cases
    where only the descriptor is affected like seek. */
 static int file_has_perm(const struct cred *cred,
-			 struct file *file,
+			 const struct file *file,
 			 u32 av)
 {
 	struct file_security_struct *fsec = selinux_file(file);
@@ -3942,9 +3943,9 @@ static int selinux_file_ioctl_compat(struct file *file, unsigned int cmd,
 
 static int default_noexec __ro_after_init;
 
-static int file_map_prot_check(struct file *file, unsigned long prot, int shared)
+static int file_map_prot_check(const struct cred *cred, const struct file *file,
+			       unsigned long prot, bool shared)
 {
-	const struct cred *cred = current_cred();
 	u32 sid = cred_sid(cred);
 	int rc = 0;
 
@@ -3993,36 +3994,86 @@ static int selinux_mmap_addr(unsigned long addr)
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
+	const struct file *backing_file = NULL;
+
+	/* check if adjustments are needed for stacked filesystems */
+	if (file && (file->f_mode & FMODE_BACKING)) {
+		backing_file = vma->vm_file;
+		file = backing_file_user_path_file(backing_file);
+
+		/* sanity check the special O_PATH user file */
+		if (WARN_ON(!(file->f_mode & FMODE_OPENED)))
+			return -EPERM;
+	}
 
 	if (default_noexec &&
 	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
-		int rc = 0;
 		/*
 		 * We don't use the vma_is_initial_heap() helper as it has
 		 * a history of problems and is currently broken on systems
@@ -4036,11 +4087,15 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
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
@@ -4048,13 +4103,29 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			 * modified content.  This typically should only
 			 * occur for text relocations.
 			 */
-			rc = file_has_perm(cred, vma->vm_file, FILE__EXECMOD);
+			rc = file_has_perm(cred, file, FILE__EXECMOD);
+			if (rc)
+				return rc;
+			if (backing_file) {
+				rc = file_has_perm(backing_file->f_cred,
+						   backing_file, FILE__EXECMOD);
+				if (rc)
+					return rc;
+			}
 		}
+	}
+
+	rc = file_map_prot_check(cred, file, prot, vma->vm_flags & VM_SHARED);
+	if (rc)
+		return rc;
+	if (backing_file) {
+		rc = file_map_prot_check(backing_file->f_cred, backing_file,
+					 prot, vma->vm_flags & VM_SHARED);
 		if (rc)
 			return rc;
 	}
 
-	return file_map_prot_check(vma->vm_file, prot, vma->vm_flags&VM_SHARED);
+	return 0;
 }
 
 static int selinux_file_lock(struct file *file, unsigned int cmd)
@@ -7501,6 +7572,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(file_ioctl_compat, selinux_file_ioctl_compat),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
+	LSM_HOOK_INIT(mmap_backing_file, selinux_mmap_backing_file),
 	LSM_HOOK_INIT(mmap_addr, selinux_mmap_addr),
 	LSM_HOOK_INIT(file_mprotect, selinux_file_mprotect),
 	LSM_HOOK_INIT(file_lock, selinux_file_lock),
-- 
2.53.0

