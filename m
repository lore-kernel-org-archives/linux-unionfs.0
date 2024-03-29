Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594439AF4
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677257; cv=none; b=WOBfn5C8+PGZs/zeTmBWSWKLPItT1S6bbsgmj+5Wux4Eg6VjOfb11YVfl4cXPymZB+XK5eD2TGkBhasYDijB8ZDYhi1t6X27Zr7UHOOx7XkwwXVd6p6vKcLsctXvUwc84tJIU1aJfhtOTrFZUL4CZ0fb9mPIC+ooel47UxZ8Daw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677257; c=relaxed/simple;
	bh=tFmf24Mjc0l+J1FvLtlzPLbHQwNkOVITHodym4M2p8g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rsDS/Q/9RO2cOLQu1N42ZnDZl9zCDEyf5PiVe9TNcSJIOzUdEwXSg/FO9hYSU4sQ3HCGFy6VuZCwJrmV3JvmcJLvopn5sHEgZlXmEatuk2CNFknosPXvMsEvoBGVjL3mXj8SWvUQg1cW/of/HMJ9F1BZWcFRQDAC4bgnm//9sw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YmargXJs; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YmargXJs"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60f9d800a29so25397217b3.0
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677255; x=1712282055; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eeuNGA+8CuovI+htgf5CrcA9lpm9o2FtGFCkGxKFo9c=;
        b=YmargXJsKh02pEkO2JoheAf/ikD8SSfSQ51Blbp5F8DAr5dPQ/rnMKP/5o8iF8+jRv
         7mFRutAXe0FIFDAAWby/UVsz8XTcP8AjpQ1LOwhtLzjPdinT+jauAaBhUymSJOZCvMqb
         1FNIFM2djvTlX3jj3gGgSa9fEPCY0SOrTP9MwQNmkjmmhOqmIqFE4huYbJcpZIy/AAbX
         9FzZUvtp61PhBrXzdY1GPSDadvIX1nht7opJRX0OvTXnhhdTCX98ZJvI8MWkL1VK3fTz
         xzLBQzXRYxFaR8Yp+Kti9kNO2amKVzfC13R7/c/a1EWwZfJzQS8S9SrE7QekU068oUGm
         RRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677255; x=1712282055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeuNGA+8CuovI+htgf5CrcA9lpm9o2FtGFCkGxKFo9c=;
        b=LYY74VP1ElgJ1QwBXRGCspVXFFr7XzoTyJcbL7DW2kpO2ewvLu6NtKVEz57LIlwTBl
         FXFWOQEfwwtcp93OUyPmMInB0roDYio5/1Uug+Tj5BoT21EEzWi/qzrFlb5nsh+y9Li1
         ABOVHCUll64z+ZEt7fiy9/6jH8EjRbgIx5XGJ5ivXQRH+H7RiE8KoplDhZb3vt2+AW0J
         DlMlfxSOZmyRYLb6alEHTIE/yG8kBMiuNfafD8otZVxEgziY12fLF96k0WQfgo/Rcm6X
         DmAuYq3xXvzWKL0v/D1eFCLIulV2mLzODnlD8w+5jpwie8/p5MBgoQtXv0vHGYNSe2di
         GYAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl1cXUFCYXYbNuhSvcpHOYtXzfy4HVrVIVz0tLLmuBs68wZj0fxvQjZ5uEAxuqhW0N4isz4GsjglFGwQev4hKuFiOh7rFRe9N9J+39EA==
X-Gm-Message-State: AOJu0YxmVp3fYtsy1C6sxP3vODXEdYJBfiwtO5+3fLYWWIU/O6ffmXmi
	nB1srvrhWQK/0XepCBGmY/ZHJskjmIfLn9LGezyijpjsqPP1LZioY5k0HFD0ADd4rxZ1P2jamNz
	KAw==
X-Google-Smtp-Source: AGHT+IHRQU6ab0eRho+UjDvwkzeb9d7pS8VugdyuU3acPa0I9eBDEaOKo5pla1Pw5XzmlyStLuGkngRj8h4=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a81:4e10:0:b0:611:5ca6:59c3 with SMTP id
 c16-20020a814e10000000b006115ca659c3mr248817ywb.6.1711677254863; Thu, 28 Mar
 2024 18:54:14 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:22 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-8-drosen@google.com>
Subject: [RFC PATCH v4 07/36] fuse-bpf: Add support for access
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
	Daniel Rosenberg <drosen@google.com>, Paul Lawrence <paullawrence@google.com>
Content-Type: text/plain; charset="UTF-8"

This adds backing support for FUSE_ACCESS

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dir.c     |  6 ++++++
 fs/fuse/fuse_i.h  |  6 ++++++
 3 files changed, 59 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 14fcc2032764..a94d99ff9862 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -420,3 +420,50 @@ int fuse_revalidate_backing(struct dentry *entry, unsigned int flags)
 		return backing_entry->d_op->d_revalidate(backing_entry, flags);
 	return 1;
 }
+
+static int fuse_access_initialize_in(struct bpf_fuse_args *fa, struct fuse_access_in *in,
+				     struct inode *inode, int mask)
+{
+	*in = (struct fuse_access_in) {
+		.mask = mask,
+	};
+
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.opcode = FUSE_ACCESS,
+			.nodeid = get_node_id(inode),
+		},
+		.in_numargs = 1,
+		.in_args[0].size = sizeof(*in),
+		.in_args[0].value = in,
+	};
+
+	return 0;
+}
+
+static int fuse_access_initialize_out(struct bpf_fuse_args *fa, struct fuse_access_in *in,
+				      struct inode *inode, int mask)
+{
+	return 0;
+}
+
+static int fuse_access_backing(struct bpf_fuse_args *fa, int *out, struct inode *inode, int mask)
+{
+	struct fuse_inode *fi = get_fuse_inode(inode);
+	const struct fuse_access_in *fai = fa->in_args[0].value;
+
+	*out = inode_permission(&nop_mnt_idmap, fi->backing_inode, fai->mask);
+	return 0;
+}
+
+static int fuse_access_finalize(struct bpf_fuse_args *fa, int *out, struct inode *inode, int mask)
+{
+	return 0;
+}
+
+int fuse_bpf_access(int *out, struct inode *inode, int mask)
+{
+	return bpf_fuse_backing(inode, struct fuse_access_in, out,
+				fuse_access_initialize_in, fuse_access_initialize_out,
+				fuse_access_backing, fuse_access_finalize, inode, mask);
+}
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 6503c91886f6..8db6eb6a0848 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1563,6 +1563,9 @@ static int fuse_access(struct inode *inode, int mask)
 	struct fuse_access_in inarg;
 	int err;
 
+	if (fuse_bpf_access(&err, inode, mask))
+		return err;
+
 	BUG_ON(mask & MAY_NOT_BLOCK);
 
 	if (fm->fc->no_access)
@@ -1619,6 +1622,9 @@ static int fuse_permission(struct mnt_idmap *idmap,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
+	if (fuse_bpf_access(&err, inode, mask))
+		return err;
+
 	/*
 	 * If attributes are needed, refresh them before proceeding
 	 */
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index dd62e78e474c..08ee98b7bb95 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1439,6 +1439,7 @@ int parse_fuse_bpf_entry(struct fuse_bpf_entry *fbe, int num_entries);
 #ifdef CONFIG_FUSE_BPF
 
 int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct dentry *entry, unsigned int flags);
+int fuse_bpf_access(int *out, struct inode *inode, int mask);
 
 #else
 
@@ -1447,6 +1448,11 @@ static inline int fuse_bpf_lookup(struct dentry **out, struct inode *dir, struct
 	return 0;
 }
 
+static inline int fuse_bpf_access(int *out, struct inode *inode, int mask)
+{
+	return 0;
+}
+
 #endif // CONFIG_FUSE_BPF
 
 int fuse_handle_backing(struct fuse_bpf_entry *feb, struct path *backing_path);
-- 
2.44.0.478.gd926399ef9-goog

