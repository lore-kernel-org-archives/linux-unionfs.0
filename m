Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EEB2264D6
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892789; cv=none; b=LtnzYZ6DsaemMS9hf2c3A7EWCWH4oyDzWSSQG4RpIIH2yTocgnpn31cq3yZejCcpH+UIZGEFs1hMTd0+teFDlwMy2effAbHd201uBN+5wyQS1I3Bl24M7l3VWviUQAuw9/FiVRXzMAcNKLCzBjocyf09mpqYYYSrNvso/fkQjck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892789; c=relaxed/simple;
	bh=UG+RyXmAbf5BMtaJuV+ReumuWH297LQHFH6uXMnK3cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMxeY7bCoHm5mReKnZqTp7paTFpM6u7PPNK641fHDFKgb2eD0AVbVP8mksJ4RulJbk8Q93+bT5VGtppp7Uvj8pgxl+DmdKU4U58WIblNs/TBjWU5qARPRkqmSZCg6yFexU6Vc27NUEru4N9sWrZ/2ybfY9Y0TaMC9Rekeyy+o2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OnDuazot; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnDuazot"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bd5dde63dbso485077b3.3
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892787; x=1779497587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HpL+NjagBheUb90sz8CHWLzu6c4Er9CRzLxRCD9m2No=;
        b=OnDuazotkFtm+C9c5mDdgyQxbG72wndwKVKxC2ZsbN+khz05ZDmRJnfsY6NL7vpn79
         M5grnyFcFndymAbhl33n48HyoeZjEViwUP04kuupqjyP/+hKF2VGvHwIf2KeQS6abF98
         CbttKQ3S5daMbreJ7ciyreFFhH+AXxkI7oO2e7P0QWyWrsmqSxGuLOXSLA+Nqr9kYkYd
         3JZKf2ZQayeyV3opBrhUa+GdQ8HAKlfC4V52118Fu94QfPu+XUVEB1waLZwW8e4ftLSU
         7BpOW55dnMk+ITfgZ3FLgE7ZnLC0vfl0hft71Jf6eUV21JebhdC4wj9LZJYNrIVdAPz5
         r1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892787; x=1779497587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HpL+NjagBheUb90sz8CHWLzu6c4Er9CRzLxRCD9m2No=;
        b=ii3emJV6FkSjqscwfEVH2QmXwQyI+fNdTV32w9XUZ9gOxgE1udq+Bko+awxl/4VTYk
         qgnJf+FX0r0BT0aQTarFblARIDAGJzLYb8ANYQmsIn/ssUh5VIrx3iVN4sxq9vUvZfMQ
         COQkIhdTIiYMXHbA4877mqR1lYsZi4UczoJ9N6TmvNQsqfgUachrQ8gTAJE1sly/DsED
         9+/QJ+pY6GvMlEZhr6RmMeKppW4l6qWouE84+ooeza1aoK8fdPMGCDmIEAKr6Htd9EIz
         dsIp47eBo7J9tzogA+dQJacffuo5B6MLq0EaSOKft+XSDf4uvuE5wE879B9nxB5Wzu1/
         cGEw==
X-Forwarded-Encrypted: i=1; AFNElJ+NrcVhfh7t1mevSU09HQaku6cAwTdfhdHMkBnVZxokzZqO0qOGAGtbAjcoBZ+ZPNb7SbjGVmhdEOWbZ8Jb@vger.kernel.org
X-Gm-Message-State: AOJu0YxL3Dlthar1T854OrQQyvk0BuZvpQBPgheCtyeyHt+rl3QtxejB
	Mwidcx7cUj4U1V5QiNsT0qOSyZ4DhCZKcxlLflpUpKPUtDVlHqH9C94M
X-Gm-Gg: Acq92OHso+tckArfSSymqLjs/FoidtXFnSVYRyrfFV3lPCeE7qFYO54E/M27MdX4pBH
	gjhah+sJ5BtJAxOKL47Tfj79vzO65qtmNj3yacA0C1M6aIoLVXLTjQS4t1O4ciT7rEBlkLzvVal
	sO/2xdq5dSXDLxIc8funxzrdwEasO+hcM0PTsu5gnxZ7kL9NAbhaoNF0RC8ne+7k+uLd5T2kiL8
	Zk3GuEAQyrnVDHF+PROpEm/P1kZAeM7x9I04FXoELu98p7xFB9U56fg2px4fosoGJPaVvx6pauD
	nFPNw7gx6WkxYjmF+wS2REjxbWzXKwxO0XsAtNkx8NJADlCV8s/wF4E2d3ScfYd/VHTdfbHS33h
	aQPdezYxHavBzaMijvxftvapDrXH0cIKRRoXrUtDKJy/Bi74ElpXVz07kTTeS9QqgL4uTxnwlN3
	ftXo0U+f+wvUkhhczoftxT
X-Received: by 2002:a05:690c:6c87:b0:7c0:8028:11f7 with SMTP id 00721157ae682-7c959b9720amr74865897b3.6.1778892787079;
        Fri, 15 May 2026 17:53:07 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:15::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f5c965d6sm38268157b3.47.2026.05.15.17.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:53:06 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 19/21] fuse: add passthrough setattr
Date: Fri, 15 May 2026 17:40:02 -0700
Message-ID: <20260516004004.1455526-20-joannelkoong@gmail.com>
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

Add passthrough setattr which sets attributes directly on the backing
inode through backing_inode_setattr() instead of sending FUSE_SETATTR to
the server.

Passthrough setattr is checked before the
handle_killpriv/handle_killpriv_v2 suid/sgid stripping because the
stripping is handled natively by notify_change() on the backing inode.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dir.c             |  3 +++
 fs/fuse/fuse_i.h          |  3 ++-
 fs/fuse/passthrough.c     | 28 ++++++++++++++++++++++++++++
 include/uapi/linux/fuse.h |  1 +
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 4c7e3e1604af..b67b3b334e69 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -2506,6 +2506,9 @@ static int fuse_setattr(struct mnt_idmap *idmap, struct dentry *entry,
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
 
+	if (fuse_passthrough_op(inode, FUSE_SETATTR))
+		return fuse_passthrough_setattr(entry, attr);
+
 	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID)) {
 		attr->ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID |
 				    ATTR_MODE);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 89c9333e9702..0d978a9837a0 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1279,7 +1279,7 @@ ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from);
 
 /* Inode passthrough operations for backing file attached to inode */
 #define FUSE_PASSTHROUGH_INODE_OPS \
-	(FUSE_PASSTHROUGH_OP_GETATTR)
+	(FUSE_PASSTHROUGH_OP_GETATTR | FUSE_PASSTHROUGH_OP_SETATTR)
 
 #define FUSE_BACKING_MAP_OP(map, op) \
 	((map)->ops_mask & FUSE_PASSTHROUGH_OP(op))
@@ -1367,6 +1367,7 @@ static inline bool fuse_passthrough_op(struct inode *inode, enum fuse_opcode op)
 
 int fuse_passthrough_getattr(struct inode *inode, struct kstat *stat,
 			     u32 request_mask, unsigned int flags);
+int fuse_passthrough_setattr(struct dentry *entry, struct iattr *attr);
 
 static inline bool fuse_use_entry2(struct fuse_conn *fc)
 {
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index ae0137caa06d..c083ab68537e 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -9,6 +9,8 @@
 
 #include <linux/file.h>
 #include <linux/backing-file.h>
+#include <linux/backing-inode.h>
+#include <linux/posix_acl.h>
 #include <linux/splice.h>
 
 static void fuse_file_accessed(struct file *file)
@@ -275,3 +277,29 @@ int fuse_passthrough_getattr(struct inode *inode, struct kstat *stat,
 
 	return 0;
 }
+
+int fuse_passthrough_setattr(struct dentry *entry, struct iattr *attr)
+{
+	struct inode *inode = d_inode(entry);
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_backing *fb = fuse_inode_backing(fi);
+	struct path path;
+	int err;
+
+	err = setattr_prepare(&nop_mnt_idmap, entry, attr);
+	if (err)
+		return err;
+
+	path.mnt = fb->file->f_path.mnt;
+	path.dentry = fb->file->f_path.dentry;
+
+	err = backing_inode_setattr(entry, &path, attr, fb->cred);
+	if (err)
+		return err;
+
+	if (fc->posix_acl)
+		forget_all_cached_acls(inode);
+
+	return 0;
+}
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 3963631558f9..040fee549bb9 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1158,6 +1158,7 @@ struct fuse_backing_map {
 #define FUSE_PASSTHROUGH_OP_WRITE	FUSE_PASSTHROUGH_OP(FUSE_WRITE)
 #define FUSE_PASSTHROUGH_OP_READDIR	FUSE_PASSTHROUGH_OP(FUSE_READDIR)
 #define FUSE_PASSTHROUGH_OP_GETATTR	FUSE_PASSTHROUGH_OP(FUSE_GETATTR)
+#define FUSE_PASSTHROUGH_OP_SETATTR	FUSE_PASSTHROUGH_OP(FUSE_SETATTR)
 
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
-- 
2.52.0

