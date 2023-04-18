Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA65C77B72
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 01:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjDRBmx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjDRBmD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Apr 2023 21:42:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06BD7AA4
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:22 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f3e30726cso211603977b3.22
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681782082; x=1684374082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XffErqhYI2OU7fEkAttVu8sFpvDYdEUvBhfwhueehVM=;
        b=W64W7LYmODf/FRuZNRmhqRfU8jwPzAf2EgQjFr/GwQnfixQx1lnFWxTQHQr2157bLk
         bOZx0B3xbbAKBKptnu3DGWAHW7YUWHUgXmFNH0B57uqjJVKJbfuIf6siNBmXF+8KrPKl
         rq/fklWlDzNR/LfPz5La++65odFf+sqMFipQNJ9fbMo8fpXLvw0QrXhDgD89PZ+Bh4Cv
         ClbkWZWwvPPc53kzJNCAMgQof+PQW1mdRELbdWXfLwzm+gUieIJC3zqNnbis5j2Pkdx0
         ai+ArKZhDaSGmGokepURyuQtc1NoAeDczoa0Mwj+K+es3hQOC2CkYjntXKPcSV6FWNzd
         ApiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681782082; x=1684374082;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XffErqhYI2OU7fEkAttVu8sFpvDYdEUvBhfwhueehVM=;
        b=c2fSZeoDk+PTERXykfrYrPmbJvSZgauNBP2TqBJrJLsuSEthlm6YtURHIHNRWFe3dW
         rh2scfGDheJVaLS4slX8WJOUE2zHt88RaT+VK5zw3XM5v+ApjPvD7HVcHu7sSimdGHom
         C+ztrs/URugNIaUwlp79qo6AkS2c7GkrOXhhpIpStp5A/9+guLOQnMflKrt4JbOCxIv+
         UV3pd25cnKVP+sYbweXu9cPXuMKaj+sZY5HoswacXJBSYv/mU42MbyToaahDOp2HjUW2
         vRngSiibzUHbBlgrFU6wL5895j3WHYHp5LW2LB+nZg0erTVUj1ApxDqA44TkKBIlL4Yp
         lQkw==
X-Gm-Message-State: AAQBX9dWU9+LIcZB5R+eaTt5p0bHr1dCGDAZaTZC/b0gUTdZHVTVsPqu
        S84iQbxEomEyHMZcea3Xy4F8DbFpUTk=
X-Google-Smtp-Source: AKy350bK1wIQRL+1GOlGecQQ1VG4drCo01/C/N6m/UsccfrVXFYrTKOINwumV372LVk08vQB5twTN47yWjc=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:e67a:98b0:942d:86aa])
 (user=drosen job=sendgmr) by 2002:a81:b303:0:b0:545:1d7f:abfe with SMTP id
 r3-20020a81b303000000b005451d7fabfemr10434358ywh.7.1681782082574; Mon, 17 Apr
 2023 18:41:22 -0700 (PDT)
Date:   Mon, 17 Apr 2023 18:40:14 -0700
In-Reply-To: <20230418014037.2412394-1-drosen@google.com>
Mime-Version: 1.0
References: <20230418014037.2412394-1-drosen@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418014037.2412394-15-drosen@google.com>
Subject: [RFC PATCH v3 14/37] fuse-bpf: Add support for fallocate
From:   Daniel Rosenberg <drosen@google.com>
To:     Miklos Szeredi <miklos@szeredi.hu>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Joanne Koong <joannelkoong@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>, kernel-team@android.com,
        Daniel Rosenberg <drosen@google.com>,
        Paul Lawrence <paullawrence@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This adds backing support for FUSE_FALLOCATE

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c    |  3 +++
 fs/fuse/fuse_i.h  |  6 +++++
 3 files changed, 69 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index c4916dde48c8..ee315598bc3f 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -333,6 +333,66 @@ ssize_t fuse_backing_mmap(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
+static int fuse_file_fallocate_initialize_in(struct bpf_fuse_args *fa,
+					     struct fuse_fallocate_in *in,
+					     struct file *file, int mode, loff_t offset, loff_t length)
+{
+	struct fuse_file *ff = file->private_data;
+
+	*in = (struct fuse_fallocate_in) {
+		.fh = ff->fh,
+		.offset = offset,
+		.length = length,
+		.mode = mode,
+	};
+
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.opcode = FUSE_FALLOCATE,
+			.nodeid = ff->nodeid,
+		},
+		.in_numargs = 1,
+		.in_args[0].size = sizeof(*in),
+		.in_args[0].value = in,
+	};
+
+	return 0;
+}
+
+static int fuse_file_fallocate_initialize_out(struct bpf_fuse_args *fa,
+					      struct fuse_fallocate_in *in,
+					      struct file *file, int mode, loff_t offset, loff_t length)
+{
+	return 0;
+}
+
+static int fuse_file_fallocate_backing(struct bpf_fuse_args *fa, int *out,
+				       struct file *file, int mode, loff_t offset, loff_t length)
+{
+	const struct fuse_fallocate_in *ffi = fa->in_args[0].value;
+	struct fuse_file *ff = file->private_data;
+
+	*out = vfs_fallocate(ff->backing_file, ffi->mode, ffi->offset,
+			     ffi->length);
+	return 0;
+}
+
+static int fuse_file_fallocate_finalize(struct bpf_fuse_args *fa, int *out,
+					struct file *file, int mode, loff_t offset, loff_t length)
+{
+	return 0;
+}
+
+int fuse_bpf_file_fallocate(int *out, struct inode *inode, struct file *file, int mode, loff_t offset, loff_t length)
+{
+	return bpf_fuse_backing(inode, struct fuse_fallocate_in, out,
+				fuse_file_fallocate_initialize_in,
+				fuse_file_fallocate_initialize_out,
+				fuse_file_fallocate_backing,
+				fuse_file_fallocate_finalize,
+				file, mode, offset, length);
+}
+
 /*******************************************************************************
  * Directory operations after here                                             *
  ******************************************************************************/
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9758bd1665a6..58cff04660db 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3071,6 +3071,9 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		(!(mode & FALLOC_FL_KEEP_SIZE) ||
 		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
 
+	if (fuse_bpf_file_fallocate(&err, inode, file, mode, offset, length))
+		return err;
+
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 624d0cebd287..1dd9cc9720df 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1406,6 +1406,7 @@ int parse_fuse_bpf_entry(struct fuse_bpf_entry *fbe, int num_entries);
 #ifdef CONFIG_FUSE_BPF
 
 int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *file, loff_t offset, int whence);
+int fuse_bpf_file_fallocate(int *out, struct inode *inode, struct file *file, int mode, loff_t offset, loff_t length);
 int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct dentry *entry, unsigned int flags);
 int fuse_bpf_access(int *out, struct inode *inode, int mask);
 
@@ -1416,6 +1417,11 @@ static inline int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *
 	return 0;
 }
 
+static inline int fuse_bpf_file_fallocate(int *out, struct inode *inode, struct file *file, int mode, loff_t offset, loff_t length)
+{
+	return 0;
+}
+
 static inline int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct dentry *entry, unsigned int flags)
 {
 	return 0;
-- 
2.40.0.634.g4ca3ef3211-goog

