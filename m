Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5821DC4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Nov 2022 02:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiKVCRT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 21:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiKVCQi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2022 21:16:38 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BD6E637D
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:13 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3a1cfadbcbaso42270057b3.23
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YI7vW6c4K96rrFjk3kAmKImDsQ1aqnDC905YGpSrwzg=;
        b=QjoJIIfxEO0QcSPemPtaHnOA3LOIMlbI0LWuX5Qcvau93ztFNlhi6LpWUYlXE5V6lR
         s+/YMob9Vz1BugWRNv0XR1XHOFD5K48n+WY8PC4yBmcG1k5Bro/WAglb1fsEe87u/U38
         wRUxe8rfXhhdOD6+W97hB8aZVBiiIRQ23y3AgJ9G+p7yUdXJePBNkRahA0wfaL+st6bw
         fwci5sDqdYCh1ja1BPHV9lFNw7YpJKkvFpu0JRvoQSKxbX1U4lj3XRM2dULPxY8TQrg2
         t7lXb/vX6HgrpmFyOYkgGmvUnSIf6zizvQ59C9VGjUaEIUt5rLIctZ29RCV6wVb22Cz9
         EbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YI7vW6c4K96rrFjk3kAmKImDsQ1aqnDC905YGpSrwzg=;
        b=kdTESs54Wie6l7hlMQERQwg1r9oqfPuFvkSMs9zh+kB4WcW021eetPdOrTy4X8fnke
         t94fvuYwovfODMVYV6cmdpWbuDbAAF/Od3OaWfID/XTUabTq/LA3lY/UF4C8MMH14Yu1
         edZdh7FYAGIjw3GQEySgb0bJpXhmKC22JbgJ4bqZ4axLEtZeUop8U94oO/FKLC4hJ9jj
         9v3PPHUk8Tg6fuWeKQi+HfkyhxLJYDgrerXqhV3XgRKFBgbYjJy8U88WXlcWUx24YZ+e
         gaIZwwCVCA3qp38+Wi+dvM4nQ1zIRpCGMO0FxbFgO1HqNVHuTSerFLQiPvbgkAXxJodx
         9uaQ==
X-Gm-Message-State: ANoB5pkG4aeu9mIS6MujtESOHnDFYwMej+haaL6hMmMHk+rYRTiX/Ind
        2EbK1qXDJjElNrXjXOSXa1ZNd5EN4Ck=
X-Google-Smtp-Source: AA0mqf4/pefLkJQGg8e/QbgeP7lFD1agiTyoHkH6/yCiZ2Z9DUXCsl0s2g4JmMF6txc9Z3xM/mdGOD8kgoM=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:200:8539:aadd:13be:6e82])
 (user=drosen job=sendgmr) by 2002:a25:d704:0:b0:6b3:369f:7436 with SMTP id
 o4-20020a25d704000000b006b3369f7436mr2526513ybg.172.1669083372616; Mon, 21
 Nov 2022 18:16:12 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:15:23 -0800
In-Reply-To: <20221122021536.1629178-1-drosen@google.com>
Mime-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122021536.1629178-9-drosen@google.com>
Subject: [RFC PATCH v2 08/21] fuse-bpf: Partially add mapping support
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

This adds a backing implementation for mapping, but no bpf counterpart
yet.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 37 +++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c    |  6 ++++++
 fs/fuse/fuse_i.h  |  4 +++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 670e82d68e36..8d862bc64acd 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -205,6 +205,43 @@ static void fuse_stat_to_attr(struct fuse_conn *fc, struct inode *inode,
 	attr->blksize = 1 << blkbits;
 }
 
+ssize_t fuse_backing_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int ret;
+	struct fuse_file *ff = file->private_data;
+	struct inode *fuse_inode = file_inode(file);
+	struct file *backing_file = ff->backing_file;
+	struct inode *backing_inode = file_inode(backing_file);
+
+	if (!backing_file->f_op->mmap)
+		return -ENODEV;
+
+	if (WARN_ON(file != vma->vm_file))
+		return -EIO;
+
+	vma->vm_file = get_file(backing_file);
+
+	ret = call_mmap(vma->vm_file, vma);
+
+	if (ret)
+		fput(backing_file);
+	else
+		fput(file);
+
+	if (file->f_flags & O_NOATIME)
+		return ret;
+
+	if ((!timespec64_equal(&fuse_inode->i_mtime, &backing_inode->i_mtime) ||
+	     !timespec64_equal(&fuse_inode->i_ctime,
+			       &backing_inode->i_ctime))) {
+		fuse_inode->i_mtime = backing_inode->i_mtime;
+		fuse_inode->i_ctime = backing_inode->i_ctime;
+	}
+	touch_atime(&file->f_path);
+
+	return ret;
+}
+
 /*******************************************************************************
  * Directory operations after here                                             *
  ******************************************************************************/
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 503327be3942..24fd4f33105c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2452,6 +2452,12 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (FUSE_IS_DAX(file_inode(file)))
 		return fuse_dax_mmap(file, vma);
 
+#ifdef CONFIG_FUSE_BPF
+	/* TODO - this is simply passthrough, not a proper BPF filter */
+	if (ff->backing_file)
+		return fuse_backing_mmap(file, vma);
+#endif
+
 	if (ff->open_flags & FOPEN_DIRECT_IO) {
 		/* Can't provide the coherency needed for MAP_SHARED */
 		if (vma->vm_flags & VM_MAYSHARE)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index db3f703c700f..95d67afcff05 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1417,7 +1417,9 @@ static inline int fuse_bpf_access(int *out, struct inode *inode, int mask)
 
 #endif // CONFIG_FUSE_BPF
 
-int fuse_handle_backing(struct fuse_bpf_entry *feb, struct path *backing_path);
+ssize_t fuse_backing_mmap(struct file *file, struct vm_area_struct *vma);
+
+int fuse_handle_backing(struct fuse_bpf_entry *fbe, struct path *backing_path);
 
 int fuse_revalidate_backing(struct dentry *entry, unsigned int flags);
 
-- 
2.38.1.584.g0f3c55d4c2-goog

