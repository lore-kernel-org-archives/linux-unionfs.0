Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC58BC77B7F
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 01:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjDRBoF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjDRBmz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Apr 2023 21:42:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ABB7ED5
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:52 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f3e30726cso211609387b3.22
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681782101; x=1684374101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikqE+zYz1BXZh8mMNk5W0C4vdov8fukuxDv9VBrvDl0=;
        b=lWajx8mafW1seUIDD7+qIrKfh1VFBzwDUsLiwI++++Oz4bdMluxYPYY5tEsxAWa6CH
         vxq2L9Ahhr00QlIXhuRa3H0R5r+rycy5muTibHI7wt1orB3xYTatC8P/ujh+GxeJv/Ea
         /qsU11Dq37CWkGOvJwpF5+roapL50puA2pWR52NQY0wwb8g7QRm+EFltGejT5i4Jt/Y1
         OXZxsrsSrppo/t9R3VKyB1ZTuREyblAyqTJ0f7YYvHtuCgBmBUieoHEv00v6QvsgLSJm
         90ZuhZjoOrQHXNOmhPGdV9IuQx/Xj2Nnt6uh+MJyIttYHlPKKkqeKwTrP9CBD6HG1qXp
         E0dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681782101; x=1684374101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikqE+zYz1BXZh8mMNk5W0C4vdov8fukuxDv9VBrvDl0=;
        b=YUX+aMCX2s6geg4Bc8XwVoRsHFzy9wDQxuSlrW+/xgkOD3/nMasp1FM14Qme2WGtLW
         9mc8dOzRBoNeee3RaHFx7zoZeBapDSisjk1vzPgcGPl6LoqeNt6tutE5gB3xPgpFVdpr
         CMzuUgRsg3ajISHARVp8llJWOnreOZPW8fRbmMXb1BS7SwyWQN+oQ4X9dv/Z+rm6YaIh
         M14He4nJ5oLjp+sl4pHM+1GNW7Dh9JcALhrCXnLhrd9ZDcm9yhTLDLnFw1BDC5TerCs9
         sgfCMWR8Basav7Lzyz+AEeOZeqgNi218DPsVswrzcRzBFk97gmvFVhaKPDq+0RZAeQmA
         C+JA==
X-Gm-Message-State: AAQBX9fa8Q6hqFii5kEkK/OEgexCdvMn5qRLFdn5CEk42oIpZhlmsI2p
        jIcqyzbAZNzjKTjtMr5T5JxNojBPys0=
X-Google-Smtp-Source: AKy350Y8W7u23ruYQztA6DVfVSc2+c8wyOOiKTHLOnbBM9IdQq81SwSucFeU6gGP5hv1qDXkZmp6krD4aBI=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:e67a:98b0:942d:86aa])
 (user=drosen job=sendgmr) by 2002:a81:a807:0:b0:552:f777:88ce with SMTP id
 f7-20020a81a807000000b00552f77788cemr2101987ywh.3.1681782101478; Mon, 17 Apr
 2023 18:41:41 -0700 (PDT)
Date:   Mon, 17 Apr 2023 18:40:22 -0700
In-Reply-To: <20230418014037.2412394-1-drosen@google.com>
Mime-Version: 1.0
References: <20230418014037.2412394-1-drosen@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418014037.2412394-23-drosen@google.com>
Subject: [RFC PATCH v3 22/37] fuse-bpf: Add support for FUSE_COPY_FILE_RANGE
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

This adds backing support for FUSE_COPY_FILE_RANGE

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c    |  4 +++
 fs/fuse/fuse_i.h  | 10 ++++++
 3 files changed, 101 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 6a6130a16d2b..928b24db2303 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -801,6 +801,93 @@ int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *file, loff_t o
 				file, offset, whence);
 }
 
+struct fuse_copy_file_range_args {
+	struct fuse_copy_file_range_in in;
+	struct fuse_write_out out;
+};
+
+static int fuse_copy_file_range_initialize_in(struct bpf_fuse_args *fa,
+					      struct fuse_copy_file_range_args *args,
+					      struct file *file_in, loff_t pos_in, struct file *file_out,
+					      loff_t pos_out, size_t len, unsigned int flags)
+{
+	struct fuse_file *fuse_file_in = file_in->private_data;
+	struct fuse_file *fuse_file_out = file_out->private_data;
+
+	args->in = (struct fuse_copy_file_range_in) {
+		.fh_in = fuse_file_in->fh,
+		.off_in = pos_in,
+		.nodeid_out = fuse_file_out->nodeid,
+		.fh_out = fuse_file_out->fh,
+		.off_out = pos_out,
+		.len = len,
+		.flags = flags,
+	};
+
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.nodeid = get_node_id(file_in->f_inode),
+			.opcode = FUSE_COPY_FILE_RANGE,
+		},
+		.in_numargs = 1,
+		.in_args[0].size = sizeof(args->in),
+		.in_args[0].value = &args->in,
+	};
+
+	return 0;
+}
+
+static int fuse_copy_file_range_initialize_out(struct bpf_fuse_args *fa,
+					       struct fuse_copy_file_range_args *args,
+					       struct file *file_in, loff_t pos_in, struct file *file_out,
+					       loff_t pos_out, size_t len, unsigned int flags)
+{
+	fa->out_numargs = 1;
+	fa->out_args[0].size = sizeof(args->out);
+	fa->out_args[0].value = &args->out;
+
+	return 0;
+}
+
+static int fuse_copy_file_range_backing(struct bpf_fuse_args *fa, ssize_t *out, struct file *file_in,
+					loff_t pos_in, struct file *file_out, loff_t pos_out, size_t len,
+					unsigned int flags)
+{
+	const struct fuse_copy_file_range_in *fci = fa->in_args[0].value;
+	struct fuse_file *fuse_file_in = file_in->private_data;
+	struct file *backing_file_in = fuse_file_in->backing_file;
+	struct fuse_file *fuse_file_out = file_out->private_data;
+	struct file *backing_file_out = fuse_file_out->backing_file;
+
+	/* TODO: Handle changing of in/out files */
+	if (backing_file_out)
+		*out = vfs_copy_file_range(backing_file_in, fci->off_in, backing_file_out,
+					   fci->off_out, fci->len, fci->flags);
+	else
+		*out = generic_copy_file_range(file_in, pos_in, file_out, pos_out, len,
+					       flags);
+	return 0;
+}
+
+static int fuse_copy_file_range_finalize(struct bpf_fuse_args *fa, ssize_t *out, struct file *file_in,
+					 loff_t pos_in, struct file *file_out, loff_t pos_out, size_t len,
+					 unsigned int flags)
+{
+	return 0;
+}
+
+int fuse_bpf_copy_file_range(ssize_t *out, struct inode *inode, struct file *file_in,
+			     loff_t pos_in, struct file *file_out, loff_t pos_out, size_t len,
+			     unsigned int flags)
+{
+	return bpf_fuse_backing(inode, struct fuse_copy_file_range_args, out,
+				fuse_copy_file_range_initialize_in,
+				fuse_copy_file_range_initialize_out,
+				fuse_copy_file_range_backing,
+				fuse_copy_file_range_finalize,
+				file_in, pos_in, file_out, pos_out, len, flags);
+}
+
 static int fuse_fsync_initialize_in(struct bpf_fuse_args *fa, struct fuse_fsync_in *in,
 				    struct file *file, loff_t start, loff_t end, int datasync)
 {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a4a0aeb28e4a..8179afe28c6f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3199,6 +3199,10 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	bool is_unstable = (!fc->writeback_cache) &&
 			   ((pos_out + len) > inode_out->i_size);
 
+	if (fuse_bpf_copy_file_range(&err, file_inode(file_in), file_in, pos_in,
+				     file_out, pos_out, len, flags))
+		return err;
+
 	if (fc->no_copy_file_range)
 		return -EOPNOTSUPP;
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 17899a1fe885..74540f308636 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1421,6 +1421,9 @@ int fuse_bpf_release(int *out, struct inode *inode, struct file *file);
 int fuse_bpf_releasedir(int *out, struct inode *inode, struct file *file);
 int fuse_bpf_flush(int *out, struct inode *inode, struct file *file, fl_owner_t id);
 int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *file, loff_t offset, int whence);
+int fuse_bpf_copy_file_range(ssize_t *out, struct inode *inode, struct file *file_in, loff_t pos_in,
+			     struct file *file_out, loff_t pos_out,
+			     size_t len, unsigned int flags);
 int fuse_bpf_fsync(int *out, struct inode *inode, struct file *file, loff_t start, loff_t end, int datasync);
 int fuse_bpf_dir_fsync(int *out, struct inode *inode, struct file *file, loff_t start, loff_t end, int datasync);
 int fuse_bpf_file_read_iter(ssize_t *out, struct inode *inode, struct kiocb *iocb, struct iov_iter *to);
@@ -1500,6 +1503,13 @@ static inline int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *
 	return 0;
 }
 
+static inline int fuse_bpf_copy_file_range(ssize_t *out, struct inode *inode, struct file *file_in, loff_t pos_in,
+					   struct file *file_out, loff_t pos_out,
+					   size_t len, unsigned int flags)
+{
+	return 0;
+}
+
 static inline int fuse_bpf_fsync(int *out, struct inode *inode, struct file *file, loff_t start, loff_t end, int datasync)
 {
 	return 0;
-- 
2.40.0.634.g4ca3ef3211-goog

