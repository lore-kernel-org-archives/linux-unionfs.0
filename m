Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B7E25228D
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892783; cv=none; b=aiqfPCI3I9omdDRO9IgyftnPFdczGxQusin77H5QK90d9DC4pXPliGNi8/gWx1RhByTieH5Tn9rYJ3A0VHxrXcdNOu2X1F/4YnKSXPM/xEtiAGjXJHFd+Xcowtcg5EDz6v0CBaheaMCxpn9QDwIhnkpvIdHKhdf6g94OfmRsnxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892783; c=relaxed/simple;
	bh=83QXb2H8zEYU3YJc6kqnJMkvfyLtCVBTo3qBBCSFH80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDbVlMV0sQ7nRT13WS/Qi/TswskE9RjPZWg17n3Cg2CARQvPFB3PtugeVv2nJmBfxzpRi0mRWL3RUuNIV9L5EqxlRPQfViJgNnFVN90tqosmXG0YZJEFQukrrnKeozZvqf+govkkvBn+F91KdwpHZsxNg9jSfDEXKoQBCG+U904=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jq+a0RES; arc=none smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jq+a0RES"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-65c7a459105so629446d50.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892781; x=1779497581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0otT9kXQRrcjcRWqrPsgABEM99e3TKRKPZ1SqOUbyY=;
        b=jq+a0RESsQYVvdz1RKrlHDw/fgBupDX55ermCweCpjRUba+Q8gUOhFZcAVwB+Q1rJ+
         WUY0fkUZsWvue/i0w/m559vTixWIDjT74qO91v7hNGLTQVXAAuzzoySjqSnjhZtrbQ3F
         8YY1F5Zut4RDgoM8jxuJp1D23o2TWQ2lTTLNvay21K/Dhtya7kJ7hmm31D6tiHrs8CWr
         1sptRxMhR/mhXbXR9kEUyXckPFE0u4uaSZx4rUQc18rYIxWXFt71SyakT0k/hhV+PgSe
         gtQZb3KPtg9/aP1eErMBJ9DeygAxkvFOGz7rIRqIqQHgBmnfpIKJj7MbDOn0JD+MkEpL
         tRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892781; x=1779497581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n0otT9kXQRrcjcRWqrPsgABEM99e3TKRKPZ1SqOUbyY=;
        b=ldEt/yhksBs/jtkEL64D4cAaRFQ1oFHJReym81vlJGszHFcq4Qss/LI85Odj74orYz
         uGww0qge8M3QZdJuB8UEJ9B3FYU9OepZnD0ailvyyr4sO2iJN3QWQ3/igq4r02lcQmXW
         hq7gfs4/Qm++CRffzfdjUGqCiVcWt1VlwTho+W+7ioWtT5MiAeLafKyTmExLfvpEPk8/
         fXukGvTv5UCtQ+KIV6A1ghDNG3C1jyty9kfWWsjHcneh2vFIUo18r4FdO9sREMZCOlUg
         rI0BzLiWdya7C0rt09ugOWHjALdyODduGrOQWDncbXqrYNCxtiTaGX4NjQ9sEW+ZSYFF
         bNhQ==
X-Forwarded-Encrypted: i=1; AFNElJ/B0zF+NET1L4wqi01eFMrbqL6ymnonSglcgPu/NXQmopxkfHcH7EA9W/HhQXOZx2rXK771UnG7KVLRceGS@vger.kernel.org
X-Gm-Message-State: AOJu0YyLmRR2x9TKjybKsVKs5wFhtYD0T98zuhd9OEcABu5lAd0brkE/
	UOxEgdk0taYOvEuMkazcsEOEI7/PocXURe5xPWRiqMQoGsydjbssySaC
X-Gm-Gg: Acq92OHLk4/iSR8vJMeW+Jtb8e7nnN9w3mnbJ9gnop6eQPBLWkhiCRZW7TkJrDTYLjD
	rASk5J7yxmsxq2aRrRTpwKif10o/mekUxj0aFyWiI/gVdM5TSK9loS0cSg9lRfJEvTON0vWVWBd
	HcGDNXQxfa1+033qEdkktMpR9tDRZJJkqePrXs6QHsEcWwYpwezJaFN1TDBX3ofP7aRho1lGvAr
	4gUYZ8WsW4VZbDFEJFkzdW84eH5SbWCMhNm9jDghStkUKaw7U7213cefchM605JrySNsWh2ymOw
	0Vab+xwLRBJbVWOMRH1O+ItYrbIUVzjIl5/ihVzjCsYbF5cVKxojiD+876tJbC+w680xnEFTNLW
	Pq2f+lcycE6ubKKKq8EQqAffWi09SzS0juKO2LBd5yr/itAOTp8YUHSjUsFwlXDwoMKETrdUB1e
	q7OoUsa4l6L1JzV+jA+pSJh5HPFwNOZaQ=
X-Received: by 2002:a05:690e:250b:10b0:657:a6a4:6ee2 with SMTP id 956f58d0204a3-65e21483a73mr4552396d50.3.1778892780961;
        Fri, 15 May 2026 17:53:00 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:1f::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0dbcda4bsm3285218d50.18.2026.05.15.17.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:53:00 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 17/21] backing-inode: add backing_inode_copyattr()
Date: Fri, 15 May 2026 17:40:00 -0700
Message-ID: <20260516004004.1455526-18-joannelkoong@gmail.com>
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

Move logic in ovl_copyattr() to a generic backing_inode_copyattr()
function in a new fs/backing-inode.c, which other filesystems that use
backing inodes (eg fuse passthrough) will use.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/Makefile                   |  2 +-
 fs/backing-inode.c            | 43 +++++++++++++++++++++++++++++++++++
 fs/overlayfs/util.c           | 33 +++------------------------
 include/linux/backing-inode.h | 14 ++++++++++++
 4 files changed, 61 insertions(+), 31 deletions(-)
 create mode 100644 fs/backing-inode.c
 create mode 100644 include/linux/backing-inode.h

diff --git a/fs/Makefile b/fs/Makefile
index cf4a745e9679..3f8a227d4938 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -40,7 +40,7 @@ obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
 
-obj-$(CONFIG_FS_STACK)		+= backing-file.o
+obj-$(CONFIG_FS_STACK)		+= backing-file.o backing-inode.o
 obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
diff --git a/fs/backing-inode.c b/fs/backing-inode.c
new file mode 100644
index 000000000000..474770a1fa9d
--- /dev/null
+++ b/fs/backing-inode.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Common helpers for stackable filesystems and backing inodes.
+ */
+
+#include <linux/backing-inode.h>
+
+/*
+ * backing_inode_copyattr - copy inode attributes from a backing inode
+ *
+ * When a filesystem copies inode information from a backing layer to its own
+ * inode, it applies the idmapping of the backing mount, ensuring that
+ * the inode ownership will correctly reflect the ownership of the idmapped
+ * backing mount. For example, an idmapped backing mount mapping id 1001 to id
+ * 1000 will take care to map any backing inode owned by id 1001 to id 1000.
+ * These mapping helpers are nops when the backing mount isn't idmapped.
+ */
+void backing_inode_copyattr(struct inode *inode,
+			    const struct path *backing_path)
+{
+	struct inode *realinode;
+	struct mnt_idmap *real_idmap;
+	vfsuid_t vfsuid;
+	vfsgid_t vfsgid;
+
+	realinode = d_inode_rcu(backing_path->dentry);
+	real_idmap = mnt_idmap(backing_path->mnt);
+
+	spin_lock(&inode->i_lock);
+	vfsuid = i_uid_into_vfsuid(real_idmap, realinode);
+	vfsgid = i_gid_into_vfsgid(real_idmap, realinode);
+
+	inode->i_uid = vfsuid_into_kuid(vfsuid);
+	inode->i_gid = vfsgid_into_kgid(vfsgid);
+	inode->i_mode = realinode->i_mode;
+	inode_set_atime_to_ts(inode, inode_get_atime(realinode));
+	inode_set_mtime_to_ts(inode, inode_get_mtime(realinode));
+	inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
+	i_size_write(inode, i_size_read(realinode));
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL_GPL(backing_inode_copyattr);
+
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3f1b763a8bb4..3e7d66c26c10 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -16,6 +16,7 @@
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
 #include <linux/overflow.h>
+#include <linux/backing-inode.h>
 #include "overlayfs.h"
 
 /* Get write access to upper mnt - may fail if upper sb was remounted ro */
@@ -1503,38 +1504,10 @@ int ovl_sync_status(struct ovl_fs *ofs)
 	return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
 }
 
-/*
- * ovl_copyattr() - copy inode attributes from layer to ovl inode
- *
- * When overlay copies inode information from an upper or lower layer to the
- * relevant overlay inode it will apply the idmapping of the upper or lower
- * layer when doing so ensuring that the ovl inode ownership will correctly
- * reflect the ownership of the idmapped upper or lower layer. For example, an
- * idmapped upper or lower layer mapping id 1001 to id 1000 will take care to
- * map any lower or upper inode owned by id 1001 to id 1000. These mapping
- * helpers are nops when the relevant layer isn't idmapped.
- */
 void ovl_copyattr(struct inode *inode)
 {
 	struct path realpath;
-	struct inode *realinode;
-	struct mnt_idmap *real_idmap;
-	vfsuid_t vfsuid;
-	vfsgid_t vfsgid;
 
-	realinode = ovl_i_path_real(inode, &realpath);
-	real_idmap = mnt_idmap(realpath.mnt);
-
-	spin_lock(&inode->i_lock);
-	vfsuid = i_uid_into_vfsuid(real_idmap, realinode);
-	vfsgid = i_gid_into_vfsgid(real_idmap, realinode);
-
-	inode->i_uid = vfsuid_into_kuid(vfsuid);
-	inode->i_gid = vfsgid_into_kgid(vfsgid);
-	inode->i_mode = realinode->i_mode;
-	inode_set_atime_to_ts(inode, inode_get_atime(realinode));
-	inode_set_mtime_to_ts(inode, inode_get_mtime(realinode));
-	inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
-	i_size_write(inode, i_size_read(realinode));
-	spin_unlock(&inode->i_lock);
+	ovl_i_path_real(inode, &realpath);
+	backing_inode_copyattr(inode, &realpath);
 }
diff --git a/include/linux/backing-inode.h b/include/linux/backing-inode.h
new file mode 100644
index 000000000000..6b43cba9fabd
--- /dev/null
+++ b/include/linux/backing-inode.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Common helpers for stackable filesystems and backing inodes.
+ */
+
+#ifndef _LINUX_BACKING_INODE_H
+#define _LINUX_BACKING_INODE_H
+
+#include <linux/fs.h>
+
+void backing_inode_copyattr(struct inode *inode,
+			    const struct path *backing_path);
+
+#endif /* _LINUX_BACKING_INODE_H */
-- 
2.52.0

