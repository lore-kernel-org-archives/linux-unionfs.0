Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35FA54FA2
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677289; cv=none; b=o84Ho/mM72KVye4LOo/Cb51Px2+Q0L6MeCrvSQRwntvkqBpZQc3ZE48uVZ2XMYaWy6+OnZFEJihslhernmjutmdesORrr4Vj5meEYFZgESUDpWIBuZqQfoJb4oGUHb1wsRckTOPA5yBRmA5cWG0nte2Dg0JqBIvFQHsH57paIX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677289; c=relaxed/simple;
	bh=bBfAJi/bJf2nD+gd3YqaNeaEuDQ3ztMPp8XYXKoJ52g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CzNGQH9WexXob/Mlq0KfpFsGDOPz02t278zaWU18+Tx8Htm/SmKzqs0W3Hyr61NvXWbJ62/WMPyGhSc6FgVynQncXs35eRFRx+bBKNV0WFetZc51XcUPWPpuvXOckQiP8zWnDmFev+rI56mFVIV455EcueoPvWQ1zX2FyQpKjPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wHJkKVjR; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wHJkKVjR"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc647f65573so2780922276.2
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677286; x=1712282086; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RHfrMplbbUkEBek0oxfkmQFW+uLxDMPloBNof976q78=;
        b=wHJkKVjRMmLu3l+quU/T1dkRy2eN9n0/f3raXxrUmdxkEBl+F5MjZr/xg38d4MvCqS
         Zs9QTc8jOGKXFRO4lO1MZBy7urTGovN9UqoSDGIj4vkCU6yKuKVfKoMFe23nx7gPicwU
         qTndnx7gWcpxrRQE3Bd68SISe31PeCm+I1cUHij18e1P5B9gpTPn5zi1CCK0q6EzeBqm
         Tc6Q/fcJVszPKaxFXH52l8WwjB31mbv0hsR5M7dzl9cGBNJFiLE8X9zQbPjt7yi13eTb
         +hYrgs/m/hkK3FRhKnopDAs5EHcEA4vG5Ef4vtT6QkBqDzMPAh39LsuLInkr63qWHXkW
         YRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677286; x=1712282086;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RHfrMplbbUkEBek0oxfkmQFW+uLxDMPloBNof976q78=;
        b=b3JjdGmJErnQFnyd/l6UeuWxQ2AC9Lpvj9ixFIxAyJtx6Y+2ZI8oOPSnAagH4aKxMi
         gDrcRsx9BSjOIvdqyfE+nnNgoFaAPxX3cJVN5x8WW1jRoS9C38rd+yBQGWXl8jodEDmu
         deIR7T6gJP3Gn0AMNQtsUtboqu6gdP8bot6fXKELC0pMMJliB8IyjJbE8D4tU8TuGG4/
         nwMRM1TlEZ8JVBnSA2K0guMslbQAsjgwG6Z3VYcUBPOiNS31Y1mioP6q3DS3LT3QVPF2
         MHPCxsN7C/vLePlccl6jckKG364QkUEGFdLOslK19l0TKTI8ErAwV1udDa2RHC5T1G/n
         U7TA==
X-Forwarded-Encrypted: i=1; AJvYcCWmbUzjJC2P1fuS4a18jQ8egrG7lz9bqa60Vtut0yQfr+aaXdmqJIKfB4DHVxmDJGBuGrKQkWOHPrHv8R1JQ2ZsptEE9TXb9ubbesTlaQ==
X-Gm-Message-State: AOJu0YzvP3oPUxOcCRZTMNPHneYMYy76H1j/OcgQJl5Mq8Gu4KAeeCza
	1pAqhwO8M+7veQNAUfKRKCMtx2YDFEj2HDZiZJ/hMI+xYoeN55xk4p5UF+vogT7QQPWKGVCqmOO
	l5Q==
X-Google-Smtp-Source: AGHT+IFbnUa67u4V59nNCnGnTBVkSthpFf64uvZOHCdvmkQja1eGLLGkihEUhtkYy01teYap9rh/yjJgyyU=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a05:6902:120a:b0:dda:c59c:3953 with SMTP id
 s10-20020a056902120a00b00ddac59c3953mr322226ybu.0.1711677285863; Thu, 28 Mar
 2024 18:54:45 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:36 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-22-drosen@google.com>
Subject: [RFC PATCH v4 21/36] fuse-bpf: Add partial flock support
From: Daniel Rosenberg <drosen@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Yonghong Song <yonghong.song@linux.dev>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Joanne Koong <joannelkoong@gmail.com>, Mykola Lysenko <mykolal@fb.com>, 
	Christian Brauner <brauner@kernel.org>, kernel-team@android.com, 
	Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"

This adds passthrough support for flock on fuse-bpf files. It does not
give any control via a bpf filter. The flock will act as though it was
taken on the lower file.

see fuse_test -t32 (flock_test)

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/fuse/backing.c | 15 +++++++++++++++
 fs/fuse/file.c    |  9 +++++++--
 fs/fuse/fuse_i.h  |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index f18aee297335..b2df2469c29c 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -9,6 +9,7 @@
 #include <linux/bpf_fuse.h>
 #include <linux/fdtable.h>
 #include <linux/file.h>
+#include <linux/filelock.h>
 #include <linux/fs_stack.h>
 #include <linux/namei.h>
 #include <linux/splice.h>
@@ -1586,6 +1587,20 @@ int fuse_bpf_file_write_iter(ssize_t *out, struct inode *inode, struct kiocb *io
 				iocb, from);
 }
 
+int fuse_file_flock_backing(struct file *file, int cmd, struct file_lock *fl)
+{
+	struct fuse_file *ff = file->private_data;
+	struct file *backing_file = ff->backing_file;
+	int error;
+
+	fl->fl_file = backing_file;
+	if (backing_file->f_op->flock)
+		error = backing_file->f_op->flock(backing_file, cmd, fl);
+	else
+		error = locks_lock_file_wait(backing_file, fl);
+	return error;
+}
+
 ssize_t fuse_backing_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	int ret;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 46de67810f03..255eb59d04f8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2676,13 +2676,18 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 {
 	struct inode *inode = file_inode(file);
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
 	int err;
 
+#ifdef CONFIG_FUSE_BPF
+	/* TODO - this is simply passthrough, not a proper BPF filter */
+	if (ff->backing_file)
+		return fuse_file_flock_backing(file, cmd, fl);
+#endif
+
 	if (fc->no_flock) {
 		err = locks_lock_file_wait(file, fl);
 	} else {
-		struct fuse_file *ff = file->private_data;
-
 		/* emulate flock with POSIX locks */
 		ff->flock = true;
 		err = fuse_setlk(file, fl, 1);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 8ae6ad967f95..e69f83616909 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1651,6 +1651,7 @@ static inline int fuse_bpf_access(int *out, struct inode *inode, int mask)
 
 #endif // CONFIG_FUSE_BPF
 
+int fuse_file_flock_backing(struct file *file, int cmd, struct file_lock *fl);
 ssize_t fuse_backing_mmap(struct file *file, struct vm_area_struct *vma);
 
 int fuse_handle_backing(struct fuse_bpf_entry *fbe, struct path *backing_path);
-- 
2.44.0.478.gd926399ef9-goog

