Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6977040866
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677268; cv=none; b=QGFMzeYBpQhnub3jAyp6Za9NZ5Y4lsi7e5MO8KbiPJvRXoOU587SMW95NhZsyDnzOecsX8ibvW+wztWcDqsbnSQrlS5J9f+wIngGXmCoExEfZYVONThIz4VBFr0IdU10AEPcftzTSnFBGOndF5JhGj9CNURndMU68lgte23AHno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677268; c=relaxed/simple;
	bh=JLW59NjmZEXXJzbkpxfd4s8AQSfi6of7y8Bzc4kj/Po=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gU4CqtPqhVVCcAnadqxbg6NWaQu8PPldqZKyXTui9K6CCfmlVZRddHqZqQal339pJJBfDGqj6d2+0/yl333Wpl/dBbpgpWk4XuWVVeWF8FNvmV+NMNczUfB3zkuhKD+ot6v/6GdDVq+L87xk5w5cGQbp88bdQkH6tUpe2lcrJmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=011HA22H; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="011HA22H"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc693399655so2763367276.1
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677265; x=1712282065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ktsTVmyBdlTiNpg1aGMp+wH2qwaXK1AaKKS16VfXuCw=;
        b=011HA22Hps4cpxNx2buAPfy87SMOxluGxh315GZYczaGqPRp4j9AoAPv5j9X4RUHkl
         GnLdAUrxCinE4g7n7FixzGrAEYgVt4KJynpx+F/eB3YdzFr5h6BUB4oKCwfaxGJCaxek
         6ZMHrsiKhPtQySHXW5cn1jLxfe/cxdTekgCnhY3t5KoCCrPR6YhHVIa+ujDwZK/XojtI
         vxTZCIzx8sHMXu52K9r9OXUUUor8zm586LajpDNEE65gWU431Ae9/yGPf6ZzElTCayWM
         vuvf2aUGrbTbBUl4M3ZjJ1wftcvdD5L7WhT46VMgjoiLHnGw9312mKQAySbOjaAH6M3o
         en5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677265; x=1712282065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ktsTVmyBdlTiNpg1aGMp+wH2qwaXK1AaKKS16VfXuCw=;
        b=uzbWteYOi0Vm66dIavFN2q53F4XwjtRdxjGABPolTNuokvx07/AN/8fblpWrEJwV2q
         KttVTkCbRmNygRuik1meV3bk9V1sAG4AhT3UVKbtlsOEpDtUY0FVJQtIqg5ejkkLt30I
         cKBkk1aR/R0r5w9iXZ6Eus/23AfwRZn5YtapZe6SkxSHgVRCDDAAOwf5qBpjIgY8YVgR
         r+Sh0M/ShQHzqdR7p+aqUzuBzoKbztAuhAzuwX6ldeaECQD4LM8gc1tEEKaKrjUIVYNu
         Fn/g6SfKokJZsv27aejmu+LwZ0D/YHht+iPpqa0b+g9zMg5SD5/seFyFQ4wZw98dfE6h
         yNwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcMTRN8YR3gliXbT1DW4dX0INhvI38UQKWpWWiQwmXuK3Il5bViV2eF6luG8hRgXB37xQLS1Xgj1ImjXxbZgOL2ZpLpqM3B5g9xOqXKA==
X-Gm-Message-State: AOJu0Yy8PTZc9w7iEefnDvCp50HdrdEDVP1qV/BW7pv5CJvgkbG/ujFp
	S7HEjP+SNbKlv8bjnUKhuGL9F9MnY2alO+FiuAbyw/bxZ4fv7wEhud0Sl6NxaQT5RixFhfiCDhT
	N2Q==
X-Google-Smtp-Source: AGHT+IHwPuMmlvt3RvgB+vaylOM9ssMbHVx7dCYSMOX3mHYJDBemyI25mz8XasllVr+OtJ/G4RkvvbuGvgc=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a05:6902:2503:b0:dc9:c54e:c5eb with SMTP id
 dt3-20020a056902250300b00dc9c54ec5ebmr307231ybb.7.1711677265603; Thu, 28 Mar
 2024 18:54:25 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:27 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-13-drosen@google.com>
Subject: [RFC PATCH v4 12/36] fuse-bpf: Support mknod/unlink/mkdir/rmdir
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

This adds backing support for FUSE_MKNOD, FUSE_MKDIR, FUSE_RMDIR,
and FUSE_UNLINK

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/backing.c | 342 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/dir.c     |  14 ++
 fs/fuse/fuse_i.h  |  24 ++++
 3 files changed, 380 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 317a3adbbb3e..567f859d300c 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -947,6 +947,348 @@ int fuse_revalidate_backing(struct dentry *entry, unsigned int flags)
 	return 1;
 }
 
+struct fuse_mknod_args {
+	struct fuse_mknod_in in;
+	struct fuse_buffer name;
+};
+
+static int fuse_mknod_initialize_in(struct bpf_fuse_args *fa, struct fuse_mknod_args *args,
+				    struct inode *dir, struct dentry *entry, umode_t mode, dev_t rdev)
+{
+	*args = (struct fuse_mknod_args) {
+		.in = (struct fuse_mknod_in) {
+			.mode = mode,
+			.rdev = new_encode_dev(rdev),
+			.umask = current_umask(),
+		},
+		.name = (struct fuse_buffer) {
+			.data = (void *) entry->d_name.name,
+			.size = entry->d_name.len + 1,
+			.flags = BPF_FUSE_IMMUTABLE,
+		},
+	};
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.nodeid = get_node_id(dir),
+			.opcode = FUSE_MKNOD,
+		},
+		.in_numargs = 2,
+		.in_args[0] = (struct bpf_fuse_arg) {
+			.size = sizeof(args->in),
+			.value = &args->in,
+		},
+		.in_args[1] = (struct bpf_fuse_arg) {
+			.is_buffer = true,
+			.buffer = &args->name,
+		},
+	};
+
+	return 0;
+}
+
+static int fuse_mknod_initialize_out(struct bpf_fuse_args *fa, struct fuse_mknod_args *args,
+				     struct inode *dir, struct dentry *entry, umode_t mode, dev_t rdev)
+{
+	return 0;
+}
+
+static int fuse_mknod_backing(struct bpf_fuse_args *fa, int *out,
+			      struct inode *dir, struct dentry *entry, umode_t mode, dev_t rdev)
+{
+	const struct fuse_mknod_in *fmi = fa->in_args[0].value;
+	struct fuse_inode *fuse_inode = get_fuse_inode(dir);
+	struct inode *backing_inode = fuse_inode->backing_inode;
+	struct path backing_path;
+	struct inode *inode = NULL;
+
+	get_fuse_backing_path(entry, &backing_path);
+	if (!backing_path.dentry)
+		return -EBADF;
+
+	inode_lock_nested(backing_inode, I_MUTEX_PARENT);
+	mode = fmi->mode;
+	if (!IS_POSIXACL(backing_inode))
+		mode &= ~fmi->umask;
+	*out = vfs_mknod(&nop_mnt_idmap, backing_inode, backing_path.dentry, mode,
+			new_decode_dev(fmi->rdev));
+	inode_unlock(backing_inode);
+	if (*out)
+		goto out;
+	if (d_really_is_negative(backing_path.dentry) ||
+	    unlikely(d_unhashed(backing_path.dentry))) {
+		*out = -EINVAL;
+		/**
+		 * TODO: overlayfs responds to this situation with a
+		 * lookupOneLen. Should we do that too?
+		 */
+		goto out;
+	}
+	inode = fuse_iget_backing(dir->i_sb, fuse_inode->nodeid, backing_inode);
+	if (IS_ERR(inode)) {
+		*out = PTR_ERR(inode);
+		goto out;
+	}
+	d_instantiate(entry, inode);
+out:
+	path_put(&backing_path);
+	return *out;
+}
+
+static int fuse_mknod_finalize(struct bpf_fuse_args *fa, int *out,
+			       struct inode *dir, struct dentry *entry, umode_t mode, dev_t rdev)
+{
+	return 0;
+}
+
+int fuse_bpf_mknod(int *out, struct inode *dir, struct dentry *entry, umode_t mode, dev_t rdev)
+{
+	return bpf_fuse_backing(dir, struct fuse_mknod_args, out,
+				fuse_mknod_initialize_in, fuse_mknod_initialize_out,
+				fuse_mknod_backing, fuse_mknod_finalize,
+				dir, entry, mode, rdev);
+}
+
+struct fuse_mkdir_args {
+	struct fuse_mkdir_in in;
+	struct fuse_buffer name;
+};
+
+static int fuse_mkdir_initialize_in(struct bpf_fuse_args *fa, struct fuse_mkdir_args *args,
+				    struct inode *dir, struct dentry *entry, umode_t mode)
+{
+	*args = (struct fuse_mkdir_args) {
+		.in = (struct fuse_mkdir_in) {
+			.mode = mode,
+			.umask = current_umask(),
+		},
+		.name = (struct fuse_buffer) {
+			.data = (void *) entry->d_name.name,
+			.size = entry->d_name.len + 1,
+			.flags = BPF_FUSE_IMMUTABLE,
+		},
+	};
+
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.nodeid = get_node_id(dir),
+			.opcode = FUSE_MKDIR,
+		},
+		.in_numargs = 2,
+		.in_args[0] = (struct bpf_fuse_arg) {
+			.size = sizeof(args->in),
+			.value = &args->in,
+		},
+		.in_args[1] = (struct bpf_fuse_arg) {
+			.value = &args->name,
+			.is_buffer = true,
+		},
+	};
+
+	return 0;
+}
+
+static int fuse_mkdir_initialize_out(struct bpf_fuse_args *fa, struct fuse_mkdir_args *args,
+				     struct inode *dir, struct dentry *entry, umode_t mode)
+{
+	return 0;
+}
+
+static int fuse_mkdir_backing(struct bpf_fuse_args *fa, int *out,
+			      struct inode *dir, struct dentry *entry, umode_t mode)
+{
+	const struct fuse_mkdir_in *fmi = fa->in_args[0].value;
+	struct fuse_inode *fuse_inode = get_fuse_inode(dir);
+	struct inode *backing_inode = fuse_inode->backing_inode;
+	struct path backing_path;
+	struct inode *inode = NULL;
+	struct dentry *d;
+
+	get_fuse_backing_path(entry, &backing_path);
+	if (!backing_path.dentry)
+		return -EBADF;
+
+	inode_lock_nested(backing_inode, I_MUTEX_PARENT);
+	mode = fmi->mode;
+	if (!IS_POSIXACL(backing_inode))
+		mode &= ~fmi->umask;
+	*out = vfs_mkdir(&nop_mnt_idmap, backing_inode, backing_path.dentry,
+			mode);
+	if (*out)
+		goto out;
+	if (d_really_is_negative(backing_path.dentry) ||
+	    unlikely(d_unhashed(backing_path.dentry))) {
+		d = lookup_one_len(entry->d_name.name,
+				   backing_path.dentry->d_parent,
+				   entry->d_name.len);
+		if (IS_ERR(d)) {
+			*out = PTR_ERR(d);
+			goto out;
+		}
+		dput(backing_path.dentry);
+		backing_path.dentry = d;
+	}
+	inode = fuse_iget_backing(dir->i_sb, fuse_inode->nodeid, backing_inode);
+	if (IS_ERR(inode)) {
+		*out = PTR_ERR(inode);
+		goto out;
+	}
+	d_instantiate(entry, inode);
+out:
+	inode_unlock(backing_inode);
+	path_put(&backing_path);
+	return *out;
+}
+
+static int fuse_mkdir_finalize(struct bpf_fuse_args *fa, int *out,
+			       struct inode *dir, struct dentry *entry, umode_t mode)
+{
+	return 0;
+}
+
+int fuse_bpf_mkdir(int *out, struct inode *dir, struct dentry *entry, umode_t mode)
+{
+	return bpf_fuse_backing(dir, struct fuse_mkdir_args, out,
+				fuse_mkdir_initialize_in, fuse_mkdir_initialize_out,
+				fuse_mkdir_backing, fuse_mkdir_finalize,
+				dir, entry, mode);
+}
+
+static int fuse_rmdir_initialize_in(struct bpf_fuse_args *fa, struct fuse_buffer *name,
+				    struct inode *dir, struct dentry *entry)
+{
+	*name = (struct fuse_buffer) {
+		.data = (void *) entry->d_name.name,
+		.size = entry->d_name.len + 1,
+		.flags = BPF_FUSE_IMMUTABLE,
+	};
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.nodeid = get_node_id(dir),
+			.opcode = FUSE_RMDIR,
+		},
+		.in_numargs = 1,
+		.in_args[0] = (struct bpf_fuse_arg) {
+			.is_buffer = true,
+			.buffer = name,
+		},
+	};
+
+	return 0;
+}
+
+static int fuse_rmdir_initialize_out(struct bpf_fuse_args *fa, struct fuse_buffer *name,
+				     struct inode *dir, struct dentry *entry)
+{
+	return 0;
+}
+
+static int fuse_rmdir_backing(struct bpf_fuse_args *fa, int *out,
+			      struct inode *dir, struct dentry *entry)
+{
+	struct path backing_path;
+	struct dentry *backing_parent_dentry;
+	struct inode *backing_inode;
+
+	get_fuse_backing_path(entry, &backing_path);
+	if (!backing_path.dentry)
+		return -EBADF;
+
+	backing_parent_dentry = dget_parent(backing_path.dentry);
+	backing_inode = d_inode(backing_parent_dentry);
+
+	inode_lock_nested(backing_inode, I_MUTEX_PARENT);
+	*out = vfs_rmdir(&nop_mnt_idmap, backing_inode, backing_path.dentry);
+	inode_unlock(backing_inode);
+
+	dput(backing_parent_dentry);
+	if (!*out)
+		d_drop(entry);
+	path_put(&backing_path);
+	return *out;
+}
+
+static int fuse_rmdir_finalize(struct bpf_fuse_args *fa, int *out, struct inode *dir, struct dentry *entry)
+{
+	return 0;
+}
+
+int fuse_bpf_rmdir(int *out, struct inode *dir, struct dentry *entry)
+{
+	return bpf_fuse_backing(dir, struct fuse_buffer, out,
+				fuse_rmdir_initialize_in, fuse_rmdir_initialize_out,
+				fuse_rmdir_backing, fuse_rmdir_finalize,
+				dir, entry);
+}
+
+static int fuse_unlink_initialize_in(struct bpf_fuse_args *fa, struct fuse_buffer *name,
+				     struct inode *dir, struct dentry *entry)
+{
+	*name = (struct fuse_buffer) {
+		.data = (void *) entry->d_name.name,
+		.size = entry->d_name.len + 1,
+		.flags = BPF_FUSE_IMMUTABLE,
+	};
+	*fa = (struct bpf_fuse_args) {
+		.info = (struct bpf_fuse_meta_info) {
+			.nodeid = get_node_id(dir),
+			.opcode = FUSE_UNLINK,
+		},
+		.in_numargs = 1,
+		.in_args[0] = (struct bpf_fuse_arg) {
+			.is_buffer = true,
+			.buffer = name,
+		},
+	};
+
+	return 0;
+}
+
+static int fuse_unlink_initialize_out(struct bpf_fuse_args *fa, struct fuse_buffer *name,
+				      struct inode *dir, struct dentry *entry)
+{
+	return 0;
+}
+
+static int fuse_unlink_backing(struct bpf_fuse_args *fa, int *out, struct inode *dir, struct dentry *entry)
+{
+	struct path backing_path;
+	struct dentry *backing_parent_dentry;
+	struct inode *backing_inode;
+
+	get_fuse_backing_path(entry, &backing_path);
+	if (!backing_path.dentry)
+		return -EBADF;
+
+	/* TODO Not sure if we should reverify like overlayfs, or get inode from d_parent */
+	backing_parent_dentry = dget_parent(backing_path.dentry);
+	backing_inode = d_inode(backing_parent_dentry);
+
+	inode_lock_nested(backing_inode, I_MUTEX_PARENT);
+	*out = vfs_unlink(&nop_mnt_idmap, backing_inode, backing_path.dentry,
+			 NULL);
+	inode_unlock(backing_inode);
+
+	dput(backing_parent_dentry);
+	if (!*out)
+		d_drop(entry);
+	path_put(&backing_path);
+	return *out;
+}
+
+static int fuse_unlink_finalize(struct bpf_fuse_args *fa, int *out,
+				struct inode *dir, struct dentry *entry)
+{
+	return 0;
+}
+
+int fuse_bpf_unlink(int *out, struct inode *dir, struct dentry *entry)
+{
+	return bpf_fuse_backing(dir, struct fuse_buffer, out,
+				fuse_unlink_initialize_in, fuse_unlink_initialize_out,
+				fuse_unlink_backing, fuse_unlink_finalize,
+				dir, entry);
+}
+
 static int fuse_access_initialize_in(struct bpf_fuse_args *fa, struct fuse_access_in *in,
 				     struct inode *inode, int mask)
 {
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 09bb4c63fd71..a5b6aef788b2 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -957,6 +957,10 @@ static int fuse_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	struct fuse_mknod_in inarg;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
+	int err;
+
+	if (fuse_bpf_mknod(&err, dir, entry, mode, rdev))
+		return err;
 
 	if (!fm->fc->dont_mask)
 		mode &= ~current_umask();
@@ -1003,6 +1007,10 @@ static int fuse_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	struct fuse_mkdir_in inarg;
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
+	int err;
+
+	if (fuse_bpf_mkdir(&err, dir, entry, mode))
+		return err;
 
 	if (!fm->fc->dont_mask)
 		mode &= ~current_umask();
@@ -1089,6 +1097,9 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	if (fuse_is_bad(dir))
 		return -EIO;
 
+	if (fuse_bpf_unlink(&err, dir, entry))
+		return err;
+
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
@@ -1112,6 +1123,9 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	if (fuse_is_bad(dir))
 		return -EIO;
 
+	if (fuse_bpf_rmdir(&err, dir, entry))
+		return err;
+
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a133010fde1c..9b176f78999f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1441,6 +1441,10 @@ int parse_fuse_bpf_entry(struct fuse_bpf_entry *fbe, int num_entries);
 int fuse_bpf_open(int *err, struct inode *inode, struct file *file, bool isdir);
 int fuse_bpf_create_open(int *out, struct inode *dir, struct dentry *entry,
 			 struct file *file, unsigned int flags, umode_t mode);
+int fuse_bpf_mknod(int *out, struct inode *dir, struct dentry *entry, umode_t mode, dev_t rdev);
+int fuse_bpf_mkdir(int *out, struct inode *dir, struct dentry *entry, umode_t mode);
+int fuse_bpf_rmdir(int *out, struct inode *dir, struct dentry *entry);
+int fuse_bpf_unlink(int *out, struct inode *dir, struct dentry *entry);
 int fuse_bpf_release(int *out, struct inode *inode, struct fuse_file *ff);
 int fuse_bpf_releasedir(int *out, struct inode *inode, struct fuse_file *ff);
 int fuse_bpf_lseek(loff_t *out, struct inode *inode, struct file *file, loff_t offset, int whence);
@@ -1461,6 +1465,26 @@ static inline int fuse_bpf_create_open(int *out, struct inode *dir, struct dentr
 	return 0;
 }
 
+static inline int fuse_bpf_mknod(int *out, struct inode *dir, struct dentry *entry, umode_t mode, dev_t rdev)
+{
+	return 0;
+}
+
+static inline int fuse_bpf_mkdir(int *out, struct inode *dir, struct dentry *entry, umode_t mode)
+{
+	return 0;
+}
+
+static inline int fuse_bpf_rmdir(int *out, struct inode *dir, struct dentry *entry)
+{
+	return 0;
+}
+
+static inline int fuse_bpf_unlink(int *out, struct inode *dir, struct dentry *entry)
+{
+	return 0;
+}
+
 static inline int fuse_bpf_release(int *out, struct inode *inode, struct file *file)
 {
 	return 0;
-- 
2.44.0.478.gd926399ef9-goog

