Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93286399CFC;
	Mon, 29 Jun 2026 06:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782715138; cv=none; b=AvmcAIg4e6+NwkkTielaOhLSiVvlSMUglYRQzDMpUW1N2Xy3XbIQRhzVdSK4tHSHPJuqEVNrM1hxWgygoH83iNSAB2x/4aH257aj43fWXoA812cjKReus6z7G9mKGCGb+z1GFPEfJ/GxqJMJyvmrxwZVd+VY7g0iikPSJQVdnOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782715138; c=relaxed/simple;
	bh=yMjikxqDlcKWi1x2cqbRlCEY8jjNMBp6V8gggNWTTpQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTQeovtVcZzUmYIwI7Ntqf9hXo9sfZqw4Tb2mE289CFlLPwacAXxu6n6KA5GhR7evIh4I3qi1rz3TQq53IloqyXqOB6/0hU+Vz+AN7fr+ffEfJPaeuhmx+igWWqw1Vh3jAIWI+R01boCUjyFdr3uVlljWZbVETvh+t4/4D+6fck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QdsxDoOI; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QdsxDoOI"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UgKmET0Nq2YFRuaZ+9dvoAavSZ4Y0haUUe5I/uRHD6I=;
	b=QdsxDoOIf6r3PcwBZV8ocB2d22Xaj4Flo5raF7j+Z/j0xtn8yJPXQXVCOJ7Z8l2hcDIN+tuXe
	JuHhrAipo3I1ms6IfNsKXlk5Ulr7c0PlH/Q/HRR2ZaEeFopPR0i86L6pAI/OxHHOdQ/DsCLGmw+
	FqQE7Tcpbs2ozK9yZf50e2I=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gpbwq339JzRhV3;
	Mon, 29 Jun 2026 14:29:47 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 7FD6A40561;
	Mon, 29 Jun 2026 14:38:54 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:54 +0800
Received: from octopus.huawei.com (10.67.174.191) by
 kwepemq200017.china.huawei.com (7.202.195.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Jun 2026 14:38:53 +0800
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
Subject: [PATCH stable/linux-5.10.y 3/7] fs: use backing_file container for internal files with "fake" f_path
Date: Mon, 29 Jun 2026 15:06:49 +0800
Message-ID: <20260629070653.580879-4-caixinchen1@huawei.com>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 62d53c4a1dfe347bd87ede46ffad38c9a3870338 ]

Overlayfs uses open_with_fake_path() to allocate internal kernel files,
with a "fake" path - whose f_path is not on the same fs as f_inode.

Allocate a container struct backing_file for those internal files, that
is used to hold the "fake" ovl path along with the real path.

backing_file_real_path() can be used to access the stored real path.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Message-Id: <20230615112229.2143178-5-amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/file_table.c     | 50 +++++++++++++++++++++++++++++++++++++++++++--
 fs/internal.h       |  5 +++--
 fs/open.c           | 45 +++++++++++++++++++++++++++++-----------
 fs/overlayfs/file.c |  4 ++--
 include/linux/fs.h  | 33 +++++++++++++++++++++++++-----
 5 files changed, 114 insertions(+), 23 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index be24d724b407..6daef2e2b2ad 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -42,18 +42,40 @@ static struct kmem_cache *filp_cachep __read_mostly;
 
 static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
+/* Container for backing file with optional real path */
+struct backing_file {
+	struct file file;
+	struct path real_path;
+};
+
+static inline struct backing_file *backing_file(struct file *f)
+{
+	return container_of(f, struct backing_file, file);
+}
+
+struct path *backing_file_real_path(struct file *f)
+{
+	return &backing_file(f)->real_path;
+}
+EXPORT_SYMBOL_GPL(backing_file_real_path);
+
 static void file_free_rcu(struct rcu_head *head)
 {
 	struct file *f = container_of(head, struct file, f_u.fu_rcuhead);
 
 	put_cred(f->f_cred);
-	kmem_cache_free(filp_cachep, f);
+	if (unlikely(f->f_mode & FMODE_BACKING))
+		kfree(backing_file(f));
+	else
+		kmem_cache_free(filp_cachep, f);
 }
 
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
-	if (!(f->f_mode & FMODE_NOACCOUNT))
+	if (unlikely(f->f_mode & FMODE_BACKING))
+		path_put(backing_file_real_path(f));
+	if (likely(!(f->f_mode & FMODE_NOACCOUNT)))
 		percpu_counter_dec(&nr_files);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
@@ -189,6 +211,30 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
 	return f;
 }
 
+/*
+ * Variant of alloc_empty_file() that allocates a backing_file container
+ * and doesn't check and modify nr_files.
+ *
+ * This is only for kernel internal use, and the allocate file must not be
+ * installed into file tables or such.
+ */
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
+{
+	struct backing_file *ff;
+	int error;
+
+	ff = kzalloc(sizeof(struct backing_file), GFP_KERNEL);
+	if (unlikely(!ff))
+		return ERR_PTR(-ENOMEM);
+
+	error = init_file(&ff->file, flags, cred);
+	if (unlikely(error))
+		return ERR_PTR(error);
+
+	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
+	return &ff->file;
+}
+
 /**
  * alloc_file - allocate and initialize a 'struct file'
  *
diff --git a/fs/internal.h b/fs/internal.h
index 39193250a4ed..676e8a8da1c7 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -107,8 +107,9 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
 /*
  * file_table.c
  */
-extern struct file *alloc_empty_file(int, const struct cred *);
-extern struct file *alloc_empty_file_noaccount(int, const struct cred *);
+struct file *alloc_empty_file(int flags, const struct cred *cred);
+struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred);
+struct file *alloc_empty_backing_file(int flags, const struct cred *cred);
 
 /*
  * super.c
diff --git a/fs/open.c b/fs/open.c
index f081f09e411e..d6d5684dc919 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -997,23 +997,44 @@ struct file *dentry_create(const struct path *path, int flags, umode_t mode,
 }
 EXPORT_SYMBOL(dentry_create);
 
-struct file *open_with_fake_path(const struct path *path, int flags,
-				struct inode *inode, const struct cred *cred)
+/**
+ * backing_file_open - open a backing file for kernel internal use
+ * @path:	path of the file to open
+ * @flags:	open flags
+ * @path:	path of the backing file
+ * @cred:	credentials for open
+ *
+ * Open a backing file for a stackable filesystem (e.g., overlayfs).
+ * @path may be on the stackable filesystem and backing inode on the
+ * underlying filesystem. In this case, we want to be able to return
+ * the @real_path of the backing inode. This is done by embedding the
+ * returned file into a container structure that also stores the path of
+ * the backing inode on the underlying filesystem, which can be
+ * retrieved using backing_file_real_path().
+ */
+struct file *backing_file_open(const struct path *path, int flags,
+			       const struct path *real_path,
+			       const struct cred *cred)
 {
-	struct file *f = alloc_empty_file_noaccount(flags, cred);
-	if (!IS_ERR(f)) {
-		int error;
+	struct file *f;
+	int error;
 
-		f->f_path = *path;
-		error = do_dentry_open(f, inode, NULL);
-		if (error) {
-			fput(f);
-			f = ERR_PTR(error);
-		}
+	f = alloc_empty_backing_file(flags, cred);
+	if (IS_ERR(f))
+		return f;
+
+	f->f_path = *path;
+	path_get(real_path);
+	*backing_file_real_path(f) = *real_path;
+	error = do_dentry_open(f, d_inode(real_path->dentry), NULL);
+	if (error) {
+		fput(f);
+		f = ERR_PTR(error);
 	}
+
 	return f;
 }
-EXPORT_SYMBOL(open_with_fake_path);
+EXPORT_SYMBOL_GPL(backing_file_open);
 
 #define WILL_CREATE(flags)	(flags & (O_CREAT | __O_TMPFILE))
 #define O_PATH_FLAGS		(O_DIRECTORY | O_NOFOLLOW | O_PATH | O_CLOEXEC)
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 343db8b3ecd6..460748b63806 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -58,8 +58,8 @@ static struct file *ovl_open_realfile(const struct file *file,
 		if (!inode_owner_or_capable(realinode))
 			flags &= ~O_NOATIME;
 
-		realfile = open_with_fake_path(&file->f_path, flags, realinode,
-					       current_cred());
+		realfile = backing_file_open(&file->f_path, flags, realpath,
+					     current_cred());
 	}
 	revert_creds(old_cred);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11294a89a53b..acdc14542cbb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -163,6 +163,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File is stream-like */
 #define FMODE_STREAM		((__force fmode_t)0x200000)
 
+/* File is embedded in backing_file object */
+#define FMODE_BACKING		((__force fmode_t)0x2000000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
@@ -2673,11 +2676,31 @@ extern struct file *file_open_name(struct filename *, int, umode_t);
 extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int, umode_t);
-extern struct file * dentry_open(const struct path *, int, const struct cred *);
-extern struct file *dentry_create(const struct path *path, int flags,
-				  umode_t mode, const struct cred *cred);
-extern struct file * open_with_fake_path(const struct path *, int,
-					 struct inode*, const struct cred *);
+struct file *dentry_open(const struct path *path, int flags,
+			 const struct cred *creds);
+struct file *dentry_create(const struct path *path, int flags, umode_t mode,
+			   const struct cred *cred);
+struct file *backing_file_open(const struct path *path, int flags,
+			       const struct path *real_path,
+			       const struct cred *cred);
+struct path *backing_file_real_path(struct file *f);
+
+/*
+ * file_real_path - get the path corresponding to f_inode
+ *
+ * When opening a backing file for a stackable filesystem (e.g.,
+ * overlayfs) f_path may be on the stackable filesystem and f_inode on
+ * the underlying filesystem.  When the path associated with f_inode is
+ * needed, this helper should be used instead of accessing f_path
+ * directly.
+*/
+static inline const struct path *file_real_path(struct file *f)
+{
+	if (unlikely(f->f_mode & FMODE_BACKING))
+		return backing_file_real_path(f);
+	return &f->f_path;
+}
+
 static inline struct file *file_clone_open(struct file *file)
 {
 	return dentry_open(&file->f_path, file->f_flags, file->f_cred);
-- 
2.18.0.huawei.25

