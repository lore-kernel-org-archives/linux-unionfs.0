Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4F5C43217
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Nov 2022 02:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKVCRV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 21:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiKVCQj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2022 21:16:39 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C35E6749
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:15 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e15-20020a5b0ccf000000b006ed1704b40cso3013449ybr.5
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mBD6bGviTnQaNR8TlIrtDcNsv7AoSToN0hwSmPU39NM=;
        b=oKcvpaX8yBxVrqjzpCwp8hRJbcWcrVDPsDHSTtU/JumfrQNEB9LNqF2bZQDgm66L23
         ezgqXB2c8vNVR5Ss+f0VlAAkX7XbGHrjbnnMn7F2oqVZtP8ZWNt7oydnS1QJUerPmQrw
         wZlW7iK35Eki/V2aGDIyRlsqTBNDWVYquyeLToqnZuW5Dk/b7LAie/wJsfzS3DkKBD2Z
         UTRBDxexsXEWuJSNee5jmYV9WWIOxyhAQPI0DgGAvgfFII8jVxgE22HiU1GNrHiYDYUL
         1O33KGWuGc2xU5ucwwHWvW+lMdsOuhQ+wShSsdOzU36NkBFSAmPL0D30z2fGKF6c0j0K
         MJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBD6bGviTnQaNR8TlIrtDcNsv7AoSToN0hwSmPU39NM=;
        b=Xxo0ph2r3IyJjjNlqkSsia7onEUkFsitIjdr4ykggKrfTcw7xgdtbP0OyaPw3yKf4b
         BqzsbB1CuWyHaI6G4TM9hc+0sSf+3ev7nGqvcT52XczRqW9ORhkfAUuSdIUZs2r8Bui1
         uH8S2BdvuANoyafCosL+tqRlEs2GMYKLqDRuc24efUVKSVF9BT2qJjMzP2rBRVO6Qq/O
         iHmE5QWN7CSadCDr5eBKXxpjib045LdGT0DTwPBXAqmqNYuBX64Zz+j0/MAk4Z0HSzXZ
         NNVabP2XVe0NzE/fuI+GOFxjRHs4sFaMyTHOu2s2lIcLQLWkAXu9/7VWp8Pmm6KHJ+sp
         U3yA==
X-Gm-Message-State: ACrzQf0Kf4VwJEhp7LLIUrRo5mmvhLMLAjk34gVZVVlpFXI1R9BSlBe6
        GcNmQVt57kqjlaU5WjcGczpqPyz10Cw=
X-Google-Smtp-Source: AMsMyM4Kn48IaLW3aQ/ISb02XRlP+7K9GeYY53FXTg2JD7CCTW1NuBvn0mi2FPfdwt99RzojkrLJTecFwGg=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:200:8539:aadd:13be:6e82])
 (user=drosen job=sendgmr) by 2002:a81:86c2:0:b0:332:a104:f7e4 with SMTP id
 w185-20020a8186c2000000b00332a104f7e4mr66525980ywf.505.1669083374599; Mon, 21
 Nov 2022 18:16:14 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:15:24 -0800
In-Reply-To: <20221122021536.1629178-1-drosen@google.com>
Mime-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122021536.1629178-10-drosen@google.com>
Subject: [RFC PATCH v2 09/21] fuse-bpf: Add lseek support
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
 fs/fuse/backing.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c    |  3 ++
 fs/fuse/fuse_i.h  |  6 ++++
 3 files changed, 97 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 8d862bc64acd..76f48872ed35 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -205,6 +205,94 @@ static void fuse_stat_to_attr(struct fuse_conn *fc, struct inode *inode,
 	attr->blksize = 1 << blkbits;
 }
 
+struct fuse_lseek_io {
+	struct fuse_lseek_in fli;
+	struct fuse_lseek_out flo;
+};
+
+static int fuse_lseek_initialize_in(struct fuse_args *fa, struct fuse_lseek_io *flio,
+				    struct file *file, loff_t offset, int whence)
+{
+	struct fuse_file *fuse_file = file->private_data;
+
+	flio->fli = (struct fuse_lseek_in) {
+		.fh = fuse_file->fh,
+		.offset = offset,
+		.whence = whence,
+	};
+
+	*fa = (struct fuse_args) {
+		.nodeid = get_node_id(file->f_inode),
+		.opcode = FUSE_LSEEK,
+		.in_numargs = 1,
+		.in_args[0].size = sizeof(flio->fli),
+		.in_args[0].value = &flio->fli,
+	};
+
+	return 0;
+}
+
+static int fuse_lseek_initialize_out(struct fuse_args *fa, struct fuse_lseek_io *flio,
+				     struct file *file, loff_t offset, int whence)
+{
+	fa->out_numargs = 1;
+	fa->out_args[0].size = sizeof(flio->flo);
+	fa->out_args[0].value = &flio->flo;
+
+	return 0;
+}
+
+static int fuse_lseek_backing(struct fuse_args *fa, loff_t *out,
+			      struct file *file, loff_t offset, int whence)
+{
+	const struct fuse_lseek_in *fli = fa->in_args[0].value;
+	struct fuse_lseek_out *flo = fa->out_args[0].value;
+	struct fuse_file *fuse_file = file->private_data;
+	struct file *backing_file = fuse_file->backing_file;
+
+	/* TODO: Handle changing of the file handle */
+	if (offset == 0) {
+		if (whence == SEEK_CUR) {
+			flo->offset = file->f_pos;
+			*out = flo->offset;
+			return 0;
+		}
+
+		if (whence == SEEK_SET) {
+			flo->offset = vfs_setpos(file, 0, 0);
+			*out = flo->offset;
+			return 0;
+		}
+	}
+
+	inode_lock(file->f_inode);
+	backing_file->f_pos = file->f_pos;
+	*out = vfs_llseek(backing_file, fli->offset, fli->whence);
+	flo->offset = *out;
+	inode_unlock(file->f_inode);
+	return 0;
+}
+
+static int fuse_lseek_finalize(struct fuse_args *fa, loff_t *out,
+			       struct file *file, loff_t offset, int whence)
+{
+	struct fuse_lseek_out *flo = fa->out_args[0].value;
+
+	if (!fa->error_in)
+		file->f_pos = flo->offset;
+	*out = flo->offset;
+	return 0;
+}
+
+int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *file, loff_t offset, int whence)
+{
+	return fuse_bpf_backing(inode, struct fuse_lseek_io, out,
+				fuse_lseek_initialize_in, fuse_lseek_initialize_out,
+				fuse_lseek_backing,
+				fuse_lseek_finalize,
+				file, offset, whence);
+}
+
 ssize_t fuse_backing_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 24fd4f33105c..e90b3e2d5452 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2704,6 +2704,9 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int whence)
 	loff_t retval;
 	struct inode *inode = file_inode(file);
 
+	if (fuse_bpf_lseek(&retval, inode, file, offset, whence))
+		return retval;
+
 	switch (whence) {
 	case SEEK_SET:
 	case SEEK_CUR:
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 95d67afcff05..108c2ea15a49 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1400,11 +1400,17 @@ int parse_fuse_bpf_entry(struct fuse_bpf_entry *fbe, int num_entries);
 
 #ifdef CONFIG_FUSE_BPF
 
+int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *file, loff_t offset, int whence);
 int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct dentry *entry, unsigned int flags);
 int fuse_bpf_access(int *out, struct inode *inode, int mask);
 
 #else
 
+static inline int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *file, loff_t offset, int whence)
+{
+	return 0;
+}
+
 static inline int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct dentry *entry, unsigned int flags)
 {
 	return 0;
-- 
2.38.1.584.g0f3c55d4c2-goog

