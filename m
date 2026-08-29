Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0F0437479
	for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 21:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788039192; cv=none; b=AyvGCCph+oimaajRZ6K1G5VjtYM4TInw+mTKeTU2FfkeUuSIwQnINCIGSv3twKLx94xZXdcUeX3oqMGm/io67cukhOdgh7W4UZdayNYZ8epWjo0I/ZsZTJ4+rNqKhd0PcoFFD0MDPHQeylcFG3dkFVKnO4hwOR/04U49xt6upxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788039192; c=relaxed/simple;
	bh=co+2fxzxIKsrqg4QHh3FK11V9lST4YMEzCqjZ1hMMe4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mDB6t0b4XIIf5yyyZZwCYmE0A9Xm0CV3zIYXRAyMCWAFWw/VIvQenU4NbmV8LlCZAtqC9eV3legcQuJHm/c6HkgDozj5Dv430tdlwseJ4NILdQOIvL+c95xYfD+1+crqPkOeQIgJXuC3Wb2mMaiGYaOm5+CKsr/NDHNBE9nAUoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OI3OzQYj; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OI3OzQYj"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-482e4998d28so1546040f8f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 14:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788039188; x=1788643988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kgtzxw+fLI0xgDG63CMY9iJwpkHw7jAnoCmbSNosjoM=;
        b=OI3OzQYjMJaScY9Nrt4ilDXIt8x6p9Q4tC4RBQgBhP59cHu7C5RuBq77vzRPPpcReh
         EEyTwZpVEblQZcfv9Nnls1xaausUUCgGJgV6OvlrPmDIWFxOz1NO5VM9vq5U34BxcLFJ
         bm2XuLp0Yzxd3ZsebduwI/tZBcpxTn7HO1Bkl4w4XW5EmBNjIrkJ0xpule2yT2ltgS/D
         mmDaKU9KgMvhmRMx6t1UG7turKc0ODGrU0RLJ8CwZi/9ij7+qXw+Ol6/qoY+vimcwfwB
         1g44DxI1L1PL3DnJ8P8BNooRQaMFEpFBNMQzzs3d19PJB5ghYxW7vsjDIYTNPhbDPndi
         1GkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788039188; x=1788643988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kgtzxw+fLI0xgDG63CMY9iJwpkHw7jAnoCmbSNosjoM=;
        b=DbKjAETCcIBqEjzqf02F6vtxQvndIyyqRbhnPpso2rJKeaBS+8hiEXSLMF64A9vSMy
         yI7d/a4GBXP//9Eqp7x1TMRNHhlyiHEbq7lMRRAXW+QCTwoHrjMyJhxjuf9olB4IYMK3
         8mqv7fnoalQyhVkfuIBf4c3JmsY2HSAiS52pMMSac3/AleP39dfGDtjpYu4cNrbSkB+Q
         fhbbNXF13aJ6PL4VmyT5aIViOvbZb5yXXSVhxQQFfOkoxiyZcU+aKfeT3EH94NUq+0Og
         9j3CLXCmsTaPrIITwl1f1aMBaEMNpqnRuSU8M2W5FT8luViwnRA3XqVtGvHfDXRSnPM2
         tN4g==
X-Forwarded-Encrypted: i=1; AKwUvBwk+4KxEgaHR54H0S/Lh6KpHOPLphGRnA6QntVUBiIWpRxuYR9ChVTHsjR0KCSVs04Dj23eRQCpl6OM2c5Y@vger.kernel.org
X-Gm-Message-State: AFuF++m9/Llm7hfv1v+5f0PBX20RyCnf/bkEH5rDWgV2DHO6aL9UgxO8
	HL1Ke4lHHyc9UcIh8LzDIog3Py23fD2z5wmNPro7j63pdLVhKZne3E06
X-Gm-Gg: AYBFou10nIU1N5WqwH0xW4bjaqS/ybyld49y5uWkxuWgNnc4hhiz8GgG9cz40gaMXDL
	8G1j6IthRg8HkGvqCS+DLCx+lz/P1GJxaW+UYutvCl6vQ06NUfti32BaPuyNP3db6XOyHE8+71r
	L7/dUasphjGW+AgRM/p8Y3rZzptnqEbsQ9bPvrAfjlJmEBWSMByTgLF9O5ZVFsCZ3RKMW+JDdan
	tMB0+WF/ytUnpgazEB5XMulMr7YC9tId9q2JoR0tDL7TlcgoT6cJ3aLAwIuZdv2i9qMINeseyyZ
	NwI7psDY60/Y71mn/c28nqN9nJ+pBU7YCMUMjTUjGRMYcYWkwy4iaBteKLVFwRGrJxLtxROAAym
	hxsk2dJ33bW3AVBGTrtDy1lyTN0NVxihHxovGbTRmF0VZ84HGq2VXTys3JotOOjMwXspUQReGkc
	MG8tamyHg3ugrPMlIn2PevyoGuzAUd3hVvG2RR2uVQrW3VVKM/5GW9+tG/wNZUPJ+maUH1MJ4vZ
	7HT+sJlgeUgzyEhfy31kB2N2jHNWSc89ls8gI50p8mcF3yI+8h0lez8yqMfR8Jucdc6tX3rCF1B
	n3OrPzoRUcZTaiUHK0monnFIiQu6Wc3at8ja1WIBi0mATJQgtD/M2jwjRXCLeOW66Vs=
X-Received: by 2002:a05:6000:420b:b0:482:e10e:58df with SMTP id ffacd0b85a97d-482f7a03ba8mr20017068f8f.21.1788039187820;
        Sat, 29 Aug 2026 14:33:07 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ae86-1b01-80e2-8851-4221-68d8.310.pool.telefonica.de. [2a02:3100:ae86:1b01:80e2:8851:4221:68d8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbb33070sm12540616f8f.36.2026.08.29.14.33.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 14:33:06 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: selinux@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] selinux: recheck intermediate backing files on mprotect
Date: Sat, 29 Aug 2026 23:32:56 +0200
Message-Id: <20260829213256.51527-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260829213256.51527-1-kmehltretter@gmail.com>
References: <20260829213256.51527-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mprotect() can be used to bypass the SELinux checks that mmap() performs
against the intermediate layers of a stacked filesystem.

mmap() checks every backing layer as the request descends through the
stack.  mprotect() only has the lowest backing file in vma->vm_file, so it
rechecks the top-level user and the lowest mounter, but skips the mounters
of every layer in between.  With two nested overlayfs mounts and a policy
denying mounter_t -> middle_file_t:file { execute }, a direct
mmap(PROT_EXEC) is denied:

  avc:  denied  { execute } for  pid=71 comm="nested_exec"
    path="/payload" dev="overlay" ino=9
    scontext=user_u:base_r:mounter_t
    tcontext=user_u:object_r:middle_file_t tclass=file permissive=0

while mmap(PROT_NONE) followed by mprotect(PROT_EXEC) succeeds.

Preserve each intermediate path, mounter SID and file-description SID in
the backing-file security blob, copying the saved entries when another
backing layer is opened.  Allocate the array only for nested backing files,
and release it and the path references in the backing_file_free hook.

During mprotect(), recheck fd { use } and the requested inode permissions
for every saved mounter, and include the intermediate layers in the execmod
checks.  Policy for nested stacking may then need to grant intermediate
mounters what a direct mmap() already requires, and execmod on intermediate
labels for binaries using text relocations.

Tested on arm64 QEMU with a small BusyBox initramfs and a purpose-built
SELinux policy, on a mainline tree containing
commit f2381b546e7e ("fs: fix user path of nested backing files").

Fixes: 82544d36b172 ("selinux: fix overlayfs mmap() and mprotect() access checks")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 security/selinux/hooks.c          | 141 ++++++++++++++++++++++++++----
 security/selinux/include/objsec.h |   8 ++
 2 files changed, 133 insertions(+), 16 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 232b7e7bfcafd..b6750edcc4783 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1674,26 +1674,32 @@ static int cred_has_capability(const struct cred *cred,
 	return rc;
 }
 
-/* Check whether a task has a particular permission to an inode.
-   The 'adp' parameter is optional and allows other audit
-   data to be passed (e.g. the dentry). */
-static int inode_has_perm(const struct cred *cred,
-			  struct inode *inode,
-			  u32 perms,
-			  struct common_audit_data *adp)
+/*
+ * Check whether a SID has a particular permission to an inode.  The 'adp'
+ * parameter is optional and allows other audit data to be passed (e.g. the
+ * dentry).
+ */
+static int inode_sid_has_perm(u32 sid, struct inode *inode, u32 perms,
+			      struct common_audit_data *adp)
 {
 	struct inode_security_struct *isec;
-	u32 sid;
 
 	if (unlikely(IS_PRIVATE(inode)))
 		return 0;
 
-	sid = cred_sid(cred);
 	isec = selinux_inode(inode);
 
 	return avc_has_perm(sid, isec->sid, isec->sclass, perms, adp);
 }
 
+static int inode_has_perm(const struct cred *cred,
+			  struct inode *inode,
+			  u32 perms,
+			  struct common_audit_data *adp)
+{
+	return inode_sid_has_perm(cred_sid(cred), inode, perms, adp);
+}
+
 /* Same as inode_has_perm, but pass explicit audit data containing
    the dentry to help the auditing code to more easily generate the
    pathname if needed. */
@@ -3854,13 +3860,63 @@ static int selinux_backing_file_alloc(struct file *backing_file,
 				      const struct file *user_file)
 {
 	struct backing_file_security_struct *bfsec;
+	const struct backing_file_security_struct *ubfsec;
+	struct backing_file_security_layer *layer;
+	u32 i;
 
 	bfsec = selinux_backing_file(backing_file);
 	bfsec->uf_sid = selinux_file_user_sid(user_file);
+	if (!(user_file->f_mode & FMODE_BACKING))
+		return 0;
+
+	ubfsec = selinux_backing_file(user_file);
+	/* a wrapped count would make kmalloc_array() return ZERO_SIZE_PTR */
+	if (unlikely(ubfsec->layer_count == U32_MAX))
+		return -EOVERFLOW;
+
+	/*
+	 * The final VMA only retains the lowest backing file, so record the
+	 * whole chain here rather than in the mmap hook, where concurrent
+	 * mappings would have to be serialized.  Size it dynamically: erofs
+	 * inode sharing adds a backing file without bumping s_stack_depth.
+	 */
+	bfsec->layers = kmalloc_array(ubfsec->layer_count + 1,
+				      sizeof(*bfsec->layers), GFP_KERNEL);
+	if (!bfsec->layers)
+		return -ENOMEM;
+
+	for (i = 0; i < ubfsec->layer_count; i++) {
+		layer = &bfsec->layers[i];
+		*layer = ubfsec->layers[i];
+		path_get(&layer->path);
+	}
+
+	/* f_path, not file_user_path(): this layer, not the top-level file */
+	layer = &bfsec->layers[i];
+	layer->path = user_file->f_path;
+	layer->mounter_sid = cred_sid(user_file->f_cred);
+	layer->fd_sid = selinux_file(user_file)->sid;
+	path_get(&layer->path);
+	bfsec->layer_count = ubfsec->layer_count + 1;
 
 	return 0;
 }
 
+static void selinux_backing_file_free(struct file *backing_file)
+{
+	struct backing_file_security_struct *bfsec;
+
+	/* security_backing_file_free() may be called twice after an error */
+	if (!backing_file_security(backing_file))
+		return;
+
+	bfsec = selinux_backing_file(backing_file);
+	while (bfsec->layer_count)
+		path_put(&bfsec->layers[--bfsec->layer_count].path);
+	kfree(bfsec->layers);
+	bfsec->layers = NULL;
+}
+
 /*
  * Check whether a task has the ioctl permission and cmd
  * operation to an inode.
@@ -3978,6 +4034,53 @@ static int selinux_file_ioctl_compat(struct file *file, unsigned int cmd,
 
 static int default_noexec __ro_after_init;
 
+static u32 file_map_prot_to_av(unsigned long prot, bool shared)
+{
+	u32 av = FILE__READ;
+
+	if (shared && (prot & PROT_WRITE))
+		av |= FILE__WRITE;
+	if (prot & PROT_EXEC)
+		av |= FILE__EXECUTE;
+
+	return av;
+}
+
+static int backing_mounters_has_perm(const struct file *file, u32 av)
+{
+	const struct backing_file_security_struct *bfsec;
+	const struct backing_file_security_layer *layer;
+	struct common_audit_data ad;
+	struct inode *inode;
+	u32 i;
+	int rc;
+
+	if (WARN_ON_ONCE(!(file->f_mode & FMODE_BACKING)))
+		return -EIO;
+
+	bfsec = selinux_backing_file(file);
+	for (i = 0; i < bfsec->layer_count; i++) {
+		layer = &bfsec->layers[i];
+		inode = d_inode(layer->path.dentry);
+
+		ad.type = LSM_AUDIT_DATA_PATH;
+		ad.u.path = layer->path;
+
+		if (layer->mounter_sid != layer->fd_sid) {
+			rc = avc_has_perm(layer->mounter_sid, layer->fd_sid,
+					  SECCLASS_FD, FD__USE, &ad);
+			if (rc)
+				return rc;
+		}
+
+		rc = inode_sid_has_perm(layer->mounter_sid, inode, av, &ad);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int __file_map_prot_check(const struct file *file, unsigned long prot,
 				 bool shared, bool mounter_check,
 				 bool bf_user_file)
@@ -4011,14 +4114,10 @@ static int __file_map_prot_check(const struct file *file, unsigned long prot,
 	if (file) {
 		const struct cred *cred = mounter_check ?
 				file->f_cred : current_cred();
-		/* "read" always possible, "write" only if shared */
-		u32 av = FILE__READ;
-		if (shared && prot_write)
-			av |= FILE__WRITE;
-		if (prot_exec)
-			av |= FILE__EXECUTE;
 
-		return __file_has_perm(cred, file, av, bf_user_file);
+		return __file_has_perm(cred, file,
+				       file_map_prot_to_av(prot, shared),
+				       bf_user_file);
 	}
 
 	return 0;
@@ -4113,6 +4212,7 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 	int rc;
 	const struct cred *cred = current_cred();
 	u32 sid = cred_sid(cred);
+	u32 av;
 	const struct file *file = vma->vm_file;
 	bool backing_file;
 	bool shared = vma->vm_flags & VM_SHARED;
@@ -4156,6 +4256,10 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 			if (rc)
 				return rc;
 			if (backing_file) {
+				rc = backing_mounters_has_perm(file,
+							       FILE__EXECMOD);
+				if (rc)
+					return rc;
 				rc = file_has_perm(file->f_cred, file,
 						   FILE__EXECMOD);
 				if (rc)
@@ -4168,6 +4272,10 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 	if (rc)
 		return rc;
 	if (backing_file) {
+		av = file_map_prot_to_av(prot, shared);
+		rc = backing_mounters_has_perm(file, av);
+		if (rc)
+			return rc;
 		rc = file_map_prot_check(file, prot, shared, true);
 		if (rc)
 			return rc;
@@ -7642,6 +7750,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
 	LSM_HOOK_INIT(backing_file_alloc, selinux_backing_file_alloc),
+	LSM_HOOK_INIT(backing_file_free, selinux_backing_file_free),
 	LSM_HOOK_INIT(file_ioctl, selinux_file_ioctl),
 	LSM_HOOK_INIT(file_ioctl_compat, selinux_file_ioctl_compat),
 	LSM_HOOK_INIT(mmap_file, selinux_mmap_file),
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 853f7266ed189..2f21568251ffe 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -86,8 +86,16 @@ struct file_security_struct {
 	u32 pseqno; /* Policy seqno at the time of file open */
 };
 
+struct backing_file_security_layer {
+	struct path path; /* this layer's real path */
+	u32 mounter_sid; /* SID of the mounter that opened it */
+	u32 fd_sid; /* SID of its open file description */
+};
+
 struct backing_file_security_struct {
 	u32 uf_sid; /* top-level user file fsec->sid */
+	u32 layer_count; /* number of intermediate backing files */
+	struct backing_file_security_layer *layers;
 };
 
 struct superblock_security_struct {
-- 
2.53.0

