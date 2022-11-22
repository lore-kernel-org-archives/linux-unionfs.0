Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E828AC4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Nov 2022 02:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiKVCUX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 21:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiKVCTO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2022 21:19:14 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC16E8739
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:39 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t9-20020a5b03c9000000b006cff5077dc9so12439918ybp.3
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0L2EwBSVK6gMt275n9P0FS+q+J4F8LKg12isFlJjWcc=;
        b=b2iwtmjGXWqJQaJjBO+sHKmft5jbP35hxZFYnha0+A9WixhUAm4CdAuHnP0ktaGaw4
         DDxlj91SlXqXiMIedrhYVc2MuXzDPTsnIapc/W6VBjn+gCAUuxdwguG/qDR0gk2IMiFx
         4zlKrB5b/CIOsG6Yg3noh99/LJ+k8c1790XSDPWNzJytJ674BCoCHnx1vgBpMOFC61qD
         UeJr1CjS0bLFcMtQZ4tCQ2SiMd/ng2/ofy1NpEx9Qe7R9S2LRnZG4EncOLnYnc8GdMs0
         CR3tu66M4z4AqJQB6L3NkrD9AQ05bbvhFJXPpmH/7syYS4jeqfUywFufcq8EY9q8BLLN
         vk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0L2EwBSVK6gMt275n9P0FS+q+J4F8LKg12isFlJjWcc=;
        b=ooz2Pu6zl9PI5XZE0q6swV7DSYlVQ36f0TvNVAKPmhLOLVWPdHM9EwEbDDMAz0v86W
         VgWZ8cfMBqadllxTBHNEXIPkvz+whcAfqjvPadoYbhSe5qqqd94RQs24gdrhDzArX5KU
         1C6PENEgRtTko7JQUvQHvTQHjrwO7v33NXEFanM6fkz723Fj/T7jqa8VjTAMCFpsKzG+
         U42IawL4+d6prQdDzQRi7lg0iIeL7xn3Zqi9FuyOWOoMYv+yMBvLpRsYg6cqNJAx9Bc5
         +M7IBV4Z9ohl9MpntomeXzbdGzKHYBRZKGRLezKc4kJIL8teBaB74G62SX8SlX73bxmm
         /bbA==
X-Gm-Message-State: ANoB5plox5QM9pHZNSgmV8dPAvR4xcsvKwyHXl6hx0rNjEY8sstQcKu4
        JA+h5NJ1jcTtR5Vh/gpa/mDWIG5SO5o=
X-Google-Smtp-Source: AA0mqf4pEXHKRMLLpP2NZX30KTDAY/ErO0cp90kyzkQhus0BdDLQ4WHMIDRUYeTiMXMyrFbVNmQccySgIJE=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:200:8539:aadd:13be:6e82])
 (user=drosen job=sendgmr) by 2002:a25:ab14:0:b0:6e9:916d:3f4d with SMTP id
 u20-20020a25ab14000000b006e9916d3f4dmr6ybi.346.1669083398353; Mon, 21 Nov
 2022 18:16:38 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:15:34 -0800
In-Reply-To: <20221122021536.1629178-1-drosen@google.com>
Mime-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122021536.1629178-20-drosen@google.com>
Subject: [RFC PATCH v2 19/21] fuse-bpf: Add xattr support
From:   Daniel Rosenberg <drosen@google.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        Daniel Rosenberg <drosen@google.com>,
        Paul Lawrence <paullawrence@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 285 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/fuse_i.h  |  30 +++++
 fs/fuse/xattr.c   |  18 +++
 3 files changed, 333 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 36c8688c4463..05fb88865289 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -967,6 +967,291 @@ int fuse_bpf_dir_fsync(int *out, struct inode *inode, struct file *file, loff_t
 				file, start, end, datasync);
 }
 
+struct fuse_getxattr_io {
+	struct fuse_getxattr_in fgi;
+	struct fuse_getxattr_out fgo;
+};
+
+static int fuse_getxattr_initialize_in(struct fuse_args *fa,
+				       struct fuse_getxattr_io *fgio,
+				       struct dentry *dentry, const char *name, void *value,
+				       size_t size)
+{
+	*fgio = (struct fuse_getxattr_io) {
+		.fgi.size = size,
+	};
+
+	*fa = (struct fuse_args) {
+		.nodeid = get_fuse_inode(dentry->d_inode)->nodeid,
+		.opcode = FUSE_GETXATTR,
+		.in_numargs = 2,
+		.in_args[0] = (struct fuse_in_arg) {
+			.size = sizeof(fgio->fgi),
+			.value = &fgio->fgi,
+		},
+		.in_args[1] = (struct fuse_in_arg) {
+			.size = strlen(name) + 1,
+			.value =  (void *) name,
+		},
+	};
+
+	return 0;
+}
+
+static int fuse_getxattr_initialize_out(struct fuse_args *fa,
+					struct fuse_getxattr_io *fgio,
+					struct dentry *dentry, const char *name, void *value,
+					size_t size)
+{
+	fa->out_numargs = 1;
+	if (size) {
+		fa->out_argvar = true;
+		fa->out_args[0].size = size;
+		fa->out_args[0].value = value;
+	} else {
+		fa->out_args[0].size = sizeof(fgio->fgo);
+		fa->out_args[0].value = &fgio->fgo;
+	}
+	return 0;
+}
+
+static int fuse_getxattr_backing(struct fuse_args *fa, int *out,
+				 struct dentry *dentry, const char *name, void *value,
+				 size_t size)
+{
+	ssize_t ret = vfs_getxattr(&init_user_ns,
+				   get_fuse_dentry(dentry)->backing_path.dentry,
+				   fa->in_args[1].value, value, size);
+
+	if (fa->out_argvar)
+		fa->out_args[0].size = ret;
+	else
+		((struct fuse_getxattr_out *)fa->out_args[0].value)->size = ret;
+
+	return 0;
+}
+
+static int fuse_getxattr_finalize(struct fuse_args *fa, int *out,
+				  struct dentry *dentry, const char *name, void *value,
+				  size_t size)
+{
+	struct fuse_getxattr_out *fgo;
+
+	if (fa->out_argvar) {
+		*out = fa->out_args[0].size;
+		return 0;
+	}
+
+	fgo = fa->out_args[0].value;
+
+	*out = fgo->size;
+	return 0;
+}
+
+int fuse_bpf_getxattr(int *out, struct inode *inode, struct dentry *dentry, const char *name,
+		      void *value, size_t size)
+{
+	return fuse_bpf_backing(inode, struct fuse_getxattr_io, out,
+				fuse_getxattr_initialize_in, fuse_getxattr_initialize_out,
+				fuse_getxattr_backing, fuse_getxattr_finalize,
+				dentry, name, value, size);
+}
+
+static int fuse_listxattr_initialize_in(struct fuse_args *fa,
+					struct fuse_getxattr_io *fgio,
+					struct dentry *dentry, char *list, size_t size)
+{
+	*fgio = (struct fuse_getxattr_io) {
+		.fgi.size = size,
+	};
+
+	*fa = (struct fuse_args) {
+		.nodeid = get_fuse_inode(dentry->d_inode)->nodeid,
+		.opcode = FUSE_LISTXATTR,
+		.in_numargs = 1,
+		.in_args[0] =
+			(struct fuse_in_arg) {
+				.size = sizeof(fgio->fgi),
+				.value = &fgio->fgi,
+			},
+	};
+
+	return 0;
+}
+
+static int fuse_listxattr_initialize_out(struct fuse_args *fa,
+					 struct fuse_getxattr_io *fgio,
+					 struct dentry *dentry, char *list, size_t size)
+{
+	fa->out_numargs = 1;
+
+	if (size) {
+		fa->out_argvar = true;
+		fa->out_args[0].size = size;
+		fa->out_args[0].value = (void *)list;
+	} else {
+		fa->out_args[0].size = sizeof(fgio->fgo);
+		fa->out_args[0].value = &fgio->fgo;
+	}
+	return 0;
+}
+
+static int fuse_listxattr_backing(struct fuse_args *fa, ssize_t *out, struct dentry *dentry,
+				  char *list, size_t size)
+{
+	*out = vfs_listxattr(get_fuse_dentry(dentry)->backing_path.dentry, list, size);
+
+	if (*out < 0)
+		return *out;
+
+	if (fa->out_argvar)
+		fa->out_args[0].size = *out;
+	else
+		((struct fuse_getxattr_out *)fa->out_args[0].value)->size = *out;
+
+	return 0;
+}
+
+static int fuse_listxattr_finalize(struct fuse_args *fa, ssize_t *out, struct dentry *dentry,
+				   char *list, size_t size)
+{
+	struct fuse_getxattr_out *fgo;
+
+	if (fa->error_in)
+		return 0;
+
+	if (fa->out_argvar) {
+		*out = fa->out_args[0].size;
+		return 0;
+	}
+
+	fgo = fa->out_args[0].value;
+	*out = fgo->size;
+	return 0;
+}
+
+int fuse_bpf_listxattr(ssize_t *out, struct inode *inode, struct dentry *dentry,
+		       char *list, size_t size)
+{
+	return fuse_bpf_backing(inode, struct fuse_getxattr_io, out,
+				fuse_listxattr_initialize_in, fuse_listxattr_initialize_out,
+				fuse_listxattr_backing, fuse_listxattr_finalize,
+				dentry, list, size);
+}
+
+static int fuse_setxattr_initialize_in(struct fuse_args *fa,
+				       struct fuse_setxattr_in *fsxi,
+				       struct dentry *dentry, const char *name,
+				       const void *value, size_t size, int flags)
+{
+	*fsxi = (struct fuse_setxattr_in) {
+		.size = size,
+		.flags = flags,
+	};
+
+	*fa = (struct fuse_args) {
+		.nodeid = get_fuse_inode(dentry->d_inode)->nodeid,
+		.opcode = FUSE_SETXATTR,
+		.in_numargs = 3,
+		.in_args[0] = (struct fuse_in_arg) {
+			.size = sizeof(*fsxi),
+			.value = fsxi,
+		},
+		.in_args[1] = (struct fuse_in_arg) {
+			.size = strlen(name) + 1,
+			.value =  (void *) name,
+		},
+		.in_args[2] = (struct fuse_in_arg) {
+			.size = size,
+			.value = (void *) value,
+		},
+	};
+
+	return 0;
+}
+
+static int fuse_setxattr_initialize_out(struct fuse_args *fa,
+					struct fuse_setxattr_in *fsxi,
+					struct dentry *dentry, const char *name,
+					const void *value, size_t size, int flags)
+{
+	return 0;
+}
+
+static int fuse_setxattr_backing(struct fuse_args *fa, int *out, struct dentry *dentry,
+				 const char *name, const void *value, size_t size,
+				 int flags)
+{
+	*out = vfs_setxattr(&init_user_ns,
+			    get_fuse_dentry(dentry)->backing_path.dentry, name,
+			    value, size, flags);
+	return 0;
+}
+
+static int fuse_setxattr_finalize(struct fuse_args *fa, int *out, struct dentry *dentry,
+				  const char *name, const void *value, size_t size,
+				  int flags)
+{
+	return 0;
+}
+
+int fuse_bpf_setxattr(int *out, struct inode *inode, struct dentry *dentry,
+		      const char *name, const void *value, size_t size, int flags)
+{
+	return fuse_bpf_backing(inode, struct fuse_setxattr_in, out,
+			       fuse_setxattr_initialize_in, fuse_setxattr_initialize_out,
+			       fuse_setxattr_backing, fuse_setxattr_finalize,
+			       dentry, name, value, size, flags);
+}
+
+static int fuse_removexattr_initialize_in(struct fuse_args *fa,
+					  struct fuse_unused_io *unused,
+					  struct dentry *dentry, const char *name)
+{
+	*fa = (struct fuse_args) {
+		.nodeid = get_fuse_inode(dentry->d_inode)->nodeid,
+		.opcode = FUSE_REMOVEXATTR,
+		.in_numargs = 1,
+		.in_args[0] = (struct fuse_in_arg) {
+			.size = strlen(name) + 1,
+			.value =  (void *) name,
+		},
+	};
+
+	return 0;
+}
+
+static int fuse_removexattr_initialize_out(struct fuse_args *fa,
+					   struct fuse_unused_io *unused,
+					   struct dentry *dentry, const char *name)
+{
+	return 0;
+}
+
+static int fuse_removexattr_backing(struct fuse_args *fa, int *out,
+				    struct dentry *dentry, const char *name)
+{
+	struct path *backing_path = &get_fuse_dentry(dentry)->backing_path;
+
+	/* TODO account for changes of the name by prefilter */
+	*out = vfs_removexattr(&init_user_ns, backing_path->dentry, name);
+	return 0;
+}
+
+static int fuse_removexattr_finalize(struct fuse_args *fa, int *out,
+				     struct dentry *dentry, const char *name)
+{
+	return 0;
+}
+
+int fuse_bpf_removexattr(int *out, struct inode *inode, struct dentry *dentry, const char *name)
+{
+	return fuse_bpf_backing(inode, struct fuse_unused_io, out,
+				fuse_removexattr_initialize_in, fuse_removexattr_initialize_out,
+				fuse_removexattr_backing, fuse_removexattr_finalize,
+				dentry, name);
+}
+
 static inline void fuse_bpf_aio_put(struct fuse_bpf_aio_req *aio_req)
 {
 	if (refcount_dec_and_test(&aio_req->ref))
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 275b649bb5ed..37b29a3ea330 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1421,6 +1421,13 @@ int fuse_bpf_copy_file_range(ssize_t *out, struct inode *inode, struct file *fil
 			     size_t len, unsigned int flags);
 int fuse_bpf_fsync(int *out, struct inode *inode, struct file *file, loff_t start, loff_t end, int datasync);
 int fuse_bpf_dir_fsync(int *out, struct inode *inode, struct file *file, loff_t start, loff_t end, int datasync);
+int fuse_bpf_getxattr(int *out, struct inode *inode, struct dentry *dentry,
+		      const char *name, void *value, size_t size);
+int fuse_bpf_listxattr(ssize_t *out, struct inode *inode, struct dentry *dentry, char *list, size_t size);
+int fuse_bpf_setxattr(int *out, struct inode *inode, struct dentry *dentry,
+		      const char *name, const void *value, size_t size,
+		      int flags);
+int fuse_bpf_removexattr(int *out, struct inode *inode, struct dentry *dentry, const char *name);
 int fuse_bpf_file_read_iter(ssize_t *out, struct inode *inode, struct kiocb *iocb, struct iov_iter *to);
 int fuse_bpf_file_write_iter(ssize_t *out, struct inode *inode, struct kiocb *iocb, struct iov_iter *from);
 int fuse_bpf_file_fallocate(int *out, struct inode *inode, struct file *file, int mode, loff_t offset, loff_t length);
@@ -1515,6 +1522,29 @@ static inline int fuse_bpf_dir_fsync(int *out, struct inode *inode, struct file
 	return 0;
 }
 
+static inline int fuse_bpf_getxattr(int *out, struct inode *inode, struct dentry *dentry,
+				    const char *name, void *value, size_t size)
+{
+	return 0;
+}
+
+static inline int fuse_bpf_listxattr(ssize_t *out, struct inode *inode, struct dentry *dentry, char *list, size_t size)
+{
+	return 0;
+}
+
+static inline int fuse_bpf_setxattr(int *out, struct inode *inode, struct dentry *dentry,
+				    const char *name, const void *value, size_t size,
+				    int flags)
+{
+	return 0;
+}
+
+static inline int fuse_bpf_removexattr(int *out, struct inode *inode, struct dentry *dentry, const char *name)
+{
+	return 0;
+}
+
 static inline int fuse_bpf_file_read_iter(ssize_t *out, struct inode *inode, struct kiocb *iocb, struct iov_iter *to)
 {
 	return 0;
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 0d3e7177fce0..857e7d3a0dab 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -118,6 +118,9 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 	if (fuse_is_bad(inode))
 		return -EIO;
 
+	if (fuse_bpf_listxattr(&ret, inode, entry, list, size))
+		return ret;
+
 	if (!fuse_allow_current_process(fm->fc))
 		return -EACCES;
 
@@ -182,9 +185,14 @@ static int fuse_xattr_get(const struct xattr_handler *handler,
 			 struct dentry *dentry, struct inode *inode,
 			 const char *name, void *value, size_t size)
 {
+	int err;
+
 	if (fuse_is_bad(inode))
 		return -EIO;
 
+	if (fuse_bpf_getxattr(&err, inode, dentry, name, value, size))
+		return err;
+
 	return fuse_getxattr(inode, name, value, size);
 }
 
@@ -194,9 +202,19 @@ static int fuse_xattr_set(const struct xattr_handler *handler,
 			  const char *name, const void *value, size_t size,
 			  int flags)
 {
+	int err;
+	bool handled;
+
 	if (fuse_is_bad(inode))
 		return -EIO;
 
+	if (value)
+		handled = fuse_bpf_setxattr(&err, inode, dentry, name, value, size, flags);
+	else
+		handled = fuse_bpf_removexattr(&err, inode, dentry, name);
+	if (handled)
+		return err;
+
 	if (!value)
 		return fuse_removexattr(inode, name);
 
-- 
2.38.1.584.g0f3c55d4c2-goog

