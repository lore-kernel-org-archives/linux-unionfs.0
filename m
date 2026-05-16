Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D90722F01
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892754; cv=none; b=PU7TKKCOlQR3z4rBtf7rohbI4XW7l8zpy/3fBQ2RPQ7/Zja23yUU5YUzj4hin8WRSYL5ko6+4Iqd3S3x4F6EH9QZCoIR8+AAbopfBOf/c2qZBIyuS7RI0es4vR83simtoJkLwTS6Pc+QeVmy6IPpVDOR1X+unkefYdAmLNpGN44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892754; c=relaxed/simple;
	bh=lnGWVaXe1W4lVI4l09z3D2fCyJs03GaPetOlGCDcDms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ht3JC9UsX2KjhYOfj9IqFEXK1gssDHudTUyp5+t2ainUPiD9BIjDws9H4TtLkssPjau2KFF5kHa5ZiaOxj9TlVd75RZ8VVbsCOBvbRi+opVVzP3QEdVK6dufvyA9XeF6UEEhywDMWyb+p9CW4Pi9eH5MmYJcLyEOBDRU9dELyqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VjnM62Oc; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VjnM62Oc"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-7c0dea734b8so494587b3.3
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892752; x=1779497552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmT6br8rzgsL/Aos2iiX0KSGLlk/N4FMdvjcXM3+Tgg=;
        b=VjnM62OccJh0Pbp1FKfrdbP81+wKyqrPHxTBeiHNIDpDchi3B08dLx7QLZcBHl5FdS
         nMNjZDNahVHSP5vnlBPFl0xnbbMPPUskJlNeIK3aHqvuHQWjFH1SVW/Ga+aQup6RddBW
         lnzDq5rr88Pu0qmSXew8p7odZG//Ovk5IqqHA9U8ApeINLqRz1PRECRu56Pk7rrwGUhb
         oBzrpnrWS1wyWmPgzWnkrdnbDvHSOZGTET0BnKP9+wHy2CxqB9rJRDd7sx8RqzzjYnUj
         sRRdwEckOjr/JU4GoItJmJEDes6DocuVQ2i84+aUMn93cLoLfxqTgX1QZCd8AnpMGgG3
         PPUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892752; x=1779497552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wmT6br8rzgsL/Aos2iiX0KSGLlk/N4FMdvjcXM3+Tgg=;
        b=AC0AW5FdV4gMtz+Ep7q/mxhAbhcFOn7Pg7RLqvKI46KSzIBRBx/pdPw7L9t4qB7b5r
         lMepjQuafcHNfytNzm0h3m4cRRhQb9yRU6593pM/39CoDFcGbPVitX9AwEuD0awd1f3F
         1xBotPdeevbCm31Bx/Lx52OXwgM+tETOEjG0jsAfE2daAMb9xfGWNh1plKn+J1xh5vcz
         qLCsEM42Q+5sV/XpD7I8bLS6Re/hOcUDIaL3Zs7WGBn+x4FDGYvJFARGnoRT66XpUTTX
         ppsmIQ/ouNQCQ1NrLpJBEulE9zemUOpq8sVvCZeyeHecpn2xQt14uSuV+KmTby5vTie5
         oASg==
X-Forwarded-Encrypted: i=1; AFNElJ/4GeMhqs0c6K7XAZEP4eWQ4265IP3SQ3NFxIWfdAuv9l5C6LLayVJtbUkjXIRy+Tj3Y1hlPgPrAz6+Gd4d@vger.kernel.org
X-Gm-Message-State: AOJu0YyW6gk3c2e6kROPUNQop2LU+HHTwjuB9bzKEg+9aCvH8OUdO39C
	TAFe+1V1zPvBfIbRo3h7WMcLzPPu+hCWWYtUti5UNapX8aJBM/R4kJk6
X-Gm-Gg: Acq92OGczqAg1O8StXSulzt3TK2Mp8H0qNUVjbx4EKxLFJgWTrsZ34AnfBOHXJwq94I
	Wd4pGZRBjb1DYjrFb1h9FWWrMccadM7V8wOWZQXtWx9+9dTiRay6kKbUMJJtNDNQbbyhjAQBghi
	cQksTQ1aycAQaoq9WqRq9gSnNlXPc6BraRWpAJL6s7T7XTRuY/2RXEMDaFHMSO7fIbo4aUUBCgR
	fcR/7hdMNsOHnAM+gFWEd/iAs8gyTNEc6lCTQ+4fFhQkv1vELeeV0ht56pi07Hc5VAS3vYaUCPo
	vw1ZW253vBmmlfuMkVgmspU9PzN6VSGpBnjRo5W1RLFWaZB/tmVbUYFMfRMLbr3lGb4pBbuySn+
	us0GugeXLXamhr9FfSTwC057SptqeLXn6i13iJGskltpUF6aPDRTq39nwZl045mlQ7Rhbvi8fXE
	AFODJVWCB+i1oKefUTemQ5
X-Received: by 2002:a53:c049:0:10b0:650:dbd:6f83 with SMTP id 956f58d0204a3-65e22825847mr5927369d50.48.1778892752241;
        Fri, 15 May 2026 17:52:32 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:21::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0db0b134sm3280844d50.13.2026.05.15.17.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:31 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 06/21] fuse: implement passthrough for getattr/statx
Date: Fri, 15 May 2026 17:39:49 -0700
Message-ID: <20260516004004.1455526-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260516004004.1455526-1-joannelkoong@gmail.com>
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

Call vfs_getattr() on backing inode to respond to a user statx(2)
request and update the fuse inode attributes with the response.

For now, we assume that calling vfs_getattr() on backing inode is cheap,
so we never use cached attributed and always update fuse inode
attributes from backing attributes in fuse_permission() and
fuse_update_attributes().

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/fuse/dir.c             | 32 ++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h          |  8 +++++++-
 fs/fuse/passthrough.c     | 36 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fuse.h |  1 +
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 05f69b8fa4c4..9a8e525f4d2b 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1414,6 +1414,28 @@ static void fuse_statx_to_attr(struct fuse_statx *sx, struct fuse_attr *attr)
 	attr->blksize = sx->blksize;
 }
 
+void fuse_kstat_to_attr(struct fuse_conn *fc, const struct kstat *stat,
+			struct fuse_attr *attr)
+{
+	memset(attr, 0, sizeof(*attr));
+
+	attr->ino = stat->ino;
+	attr->size = stat->size;
+	attr->blocks = stat->blocks;
+	attr->atime = stat->atime.tv_sec;
+	attr->mtime = stat->mtime.tv_sec;
+	attr->ctime = stat->ctime.tv_sec;
+	attr->atimensec = stat->atime.tv_nsec;
+	attr->mtimensec = stat->mtime.tv_nsec;
+	attr->ctimensec = stat->ctime.tv_nsec;
+	attr->mode = stat->mode;
+	attr->nlink = stat->nlink;
+	attr->uid = from_kuid(fc->user_ns, stat->uid);
+	attr->gid = from_kgid(fc->user_ns, stat->gid);
+	attr->rdev = new_encode_dev(MKDEV(MAJOR(stat->rdev), MINOR(stat->rdev)));
+	attr->blksize = stat->blksize;
+}
+
 static int fuse_do_statx(struct mnt_idmap *idmap, struct inode *inode,
 			 struct file *file, struct kstat *stat)
 {
@@ -1539,6 +1561,12 @@ static int fuse_update_get_attr(struct mnt_idmap *idmap, struct inode *inode,
 	if (fc->no_statx)
 		request_mask &= STATX_BASIC_STATS;
 
+	if (fuse_passthrough_op(inode, FUSE_GETATTR)) {
+		forget_all_cached_acls(inode);
+		return fuse_passthrough_getattr(inode, stat, request_mask,
+						flags);
+	}
+
 	if (!request_mask)
 		sync = false;
 	else if (flags & AT_STATX_FORCE_SYNC)
@@ -1737,6 +1765,10 @@ static int fuse_perm_getattr(struct inode *inode, int mask)
 		return -ECHILD;
 
 	forget_all_cached_acls(inode);
+	if (fuse_passthrough_op(inode, FUSE_GETATTR))
+		return fuse_passthrough_getattr(inode, NULL,
+						STATX_BASIC_STATS, 0);
+
 	return fuse_do_getattr(&nop_mnt_idmap, inode, NULL, NULL);
 }
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 502b3b3f7e89..389e28497dc7 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -991,6 +991,8 @@ void fuse_init_symlink(struct inode *inode);
 /*
  * Change attributes of an inode
  */
+void fuse_kstat_to_attr(struct fuse_conn *fc, const struct kstat *stat,
+			struct fuse_attr *attr);
 void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 			    struct fuse_statx *sx,
 			    u64 attr_valid, u64 attr_version);
@@ -1274,7 +1276,8 @@ void fuse_file_release(struct inode *inode, struct fuse_file *ff,
 	(FUSE_PASSTHROUGH_RW_OPS | FUSE_PASSTHROUGH_OP_READDIR)
 
 /* Inode passthrough operations for backing file attached to inode */
-#define FUSE_PASSTHROUGH_INODE_OPS (0)
+#define FUSE_PASSTHROUGH_INODE_OPS \
+	(FUSE_PASSTHROUGH_OP_GETATTR)
 
 #define FUSE_BACKING_MAP_OP(map, op) \
 	((map)->ops_mask & FUSE_PASSTHROUGH_OP(op))
@@ -1358,6 +1361,9 @@ static inline bool fuse_passthrough_op(struct inode *inode, enum fuse_opcode op)
 	return fb && fb->ops_mask & FUSE_PASSTHROUGH_OP(op);
 }
 
+int fuse_passthrough_getattr(struct inode *inode, struct kstat *stat,
+			     u32 request_mask, unsigned int flags);
+
 #ifdef CONFIG_SYSCTL
 extern int fuse_sysctl_register(void);
 extern void fuse_sysctl_unregister(void);
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index a1d87ed51a94..7de038960b2f 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -219,3 +219,39 @@ void fuse_passthrough_release(struct fuse_file *ff, struct fuse_backing *fb)
 	put_cred(ff->cred);
 	ff->cred = NULL;
 }
+
+/*
+ * Inode passthrough operations for backing file attached on lookup.
+ */
+int fuse_passthrough_getattr(struct inode *inode, struct kstat *stat,
+			     u32 request_mask, unsigned int flags)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_backing *fb = fuse_inode_backing(fi);
+	u64 attr_version = fuse_get_attr_version(fc);
+	const struct path *fb_path = &fb->file->f_path;
+	const struct cred *old_cred;
+	struct kstat backing_stat;
+	struct fuse_attr attr;
+	int err;
+
+	if (!stat)
+		stat = &backing_stat;
+
+	old_cred = override_creds(fb->cred);
+	err = vfs_getattr(fb_path, stat, request_mask, flags);
+	revert_creds(old_cred);
+	if (err)
+		return err;
+
+	/* Always override st_dev and st_ino with FUSE dev and ino */
+	stat->dev = inode->i_sb->s_dev;
+	stat->ino = inode->i_ino;
+
+	/* Fill fuse inode attrs from backing inode stat */
+	fuse_kstat_to_attr(fc, stat, &attr);
+	fuse_change_attributes(inode, &attr, NULL, 0, attr_version);
+
+	return 0;
+}
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index df366e390f0c..6404ed95c758 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1143,6 +1143,7 @@ struct fuse_backing_map {
 #define FUSE_PASSTHROUGH_OP_READ	FUSE_PASSTHROUGH_OP(FUSE_READ)
 #define FUSE_PASSTHROUGH_OP_WRITE	FUSE_PASSTHROUGH_OP(FUSE_WRITE)
 #define FUSE_PASSTHROUGH_OP_READDIR	FUSE_PASSTHROUGH_OP(FUSE_READDIR)
+#define FUSE_PASSTHROUGH_OP_GETATTR	FUSE_PASSTHROUGH_OP(FUSE_GETATTR)
 
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
-- 
2.52.0

