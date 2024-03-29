Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529FC6A8A0
	for <linux-unionfs@vger.kernel.org>; Fri, 29 Mar 2024 01:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677294; cv=none; b=o6VoLjq9aDwc6AdXXhB7JQ/VSkn25RagJt3Yhu7DuDtfR3yweL1Y31A+hwkNDzqwoWeZN9lGDICKTbY26qXsDp950jrltoPE6L9Jz2LyvsmKA7qMnjk/l0kVdWA2XjzizfJVKCnWBmAM3INdLhV79RO2F6Jxj8EJ1h8OQeVj6O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677294; c=relaxed/simple;
	bh=lg0g6uOF3iAO/ssiLRAcrWry2HIbZpoqzls2TxKy5ms=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oqvVEjA7WGjFqdqQJliFA+YQ1wkdVsi7HpbyYg8EFw6Nc3qqL563zT0INMPuciGPKuAJ2gVTP7BT5gckDvswpg9ral3r9GckeEyWugKNbxMsT8hJ3aPeXuOYfGtq4yRgZexZ9yhSHDu4owgdHGcLtoZXyrIohviG70yFsN2O23Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x4mYQJZa; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--drosen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x4mYQJZa"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso2314925276.3
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2024 18:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711677292; x=1712282092; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=od0eLderVP8wkPdPrI4ENNCsb2rG+V1Fgj/sF5+lSuM=;
        b=x4mYQJZa5N8yMZBMXbwKAQkbqX4tgVORq6SXljK1YvZG2YQaow9FUihPpsUQy/7sxB
         87U18Ceo/QJ08muJc84lHbltw6/mtmtbxT5hOsBKyulrS8wbBCX32tj4sdiXPR9Ud9t7
         +Fr03dmcXrLT2FL2gsKS5bfDPbarhDJeH4fgs0JMx3ws3tYlQaeYbFmfXcxcLerRaIzk
         Y8VCX13ytsiUWeIGEunk3HaMpjQyIkm1Fo/yqOvUhcGcDd5g2TCe0c5n/nFY/OAxNNTi
         6gI0gbIdeP+wZVVjwvv4b+vmTpz/MtanosebtA27LStRbdTzra+LyHE4U70meWDng0BN
         7iIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711677292; x=1712282092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=od0eLderVP8wkPdPrI4ENNCsb2rG+V1Fgj/sF5+lSuM=;
        b=YcHeONQJUmWPMSRbyEnE8Cj5MM2GLqw5yRmhSEt7rpesgqJwoW8LRkQlPZT1UEzLqS
         Z266zTKcFbkEoAPrJQmqItT/tK0kC0iuKnNXeJk0oanRp+ErGUifdN319mf9eiUkNjZP
         LacQrxzpoF/YiJJrFCenebCoj8gkAUDX6qpb6MoKEyxPSkaqGAzAELjgOPuxVcfbqBUR
         YbN4puvUsGSCTMU3pN4qe402+wN7/bZiZ87BPDk2TdwxxRckayOfcKdpyFUILxZnsxIs
         77SvCuYsNOZ09GIlK2AqQWN+u5nB/sMbvJVOhvGW6kKPMtsfWgHpx+8QHyGT3yzC5JJ9
         Rx+g==
X-Forwarded-Encrypted: i=1; AJvYcCVQkjWZvXks0RYhuptT9GyZ/HUlif52GgQaA3lHwdx3Q2UvzI5etmCbDQ08EtlQ6JS1uQzaHV9gt7H1BH3xKeP1TmAAdmxeYfeQTGCUyw==
X-Gm-Message-State: AOJu0YzjqqxqtkKipuS6qn0L+IiuETQu8a6hKoDYxt9TSa7C0xwLKaBy
	n6hRVJzK8e+qfEHD+hwV38NgeVsRpxvBJMLv7n0xkMY2gexT7sKjL2hZA4G4aw0QRBNB5otpsTg
	8+w==
X-Google-Smtp-Source: AGHT+IFNeB7P0RtQ53mC8zg19/JpPgaA07h8+WRkHIS3dG7DeGgWdytZdjnC5CdjHQubEzDWWlIhriwU/f0=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:fcce:d6ab:804c:b94b])
 (user=drosen job=sendgmr) by 2002:a05:6902:2841:b0:dcb:bc80:8333 with SMTP id
 ee1-20020a056902284100b00dcbbc808333mr293843ybb.13.1711677292440; Thu, 28 Mar
 2024 18:54:52 -0700 (PDT)
Date: Thu, 28 Mar 2024 18:53:38 -0700
In-Reply-To: <20240329015351.624249-1-drosen@google.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240329015351.624249-1-drosen@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240329015351.624249-24-drosen@google.com>
Subject: [RFC PATCH v4 23/36] fuse-bpf: allow mounting with no userspace daemon
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

When using fuse-bpf in pure passthrough mode, we don't explicitly need a
userspace daemon. This allows simple testing of the backing operations.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
---
 fs/fuse/fuse_i.h |  4 ++++
 fs/fuse/inode.c  | 25 +++++++++++++++++++------
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 81639c006ac5..f1a8f8a97f1f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -586,6 +586,7 @@ struct fuse_fs_context {
 	bool no_control:1;
 	bool no_force_umount:1;
 	bool legacy_opts_show:1;
+	bool no_daemon:1;
 	enum fuse_dax_mode dax_mode;
 	unsigned int max_read;
 	unsigned int blksize;
@@ -873,6 +874,9 @@ struct fuse_conn {
 	/* Is statx not implemented by fs? */
 	unsigned int no_statx:1;
 
+	/** BPF Only, no Daemon running */
+	unsigned int no_daemon:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index bc504e0d0e80..b4332416e23a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -829,6 +829,7 @@ enum {
 	OPT_MAX_READ,
 	OPT_BLKSIZE,
 	OPT_ROOT_DIR,
+	OPT_NO_DAEMON,
 	OPT_ERR
 };
 
@@ -844,6 +845,7 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
 	fsparam_u32	("blksize",		OPT_BLKSIZE),
 	fsparam_string	("subtype",		OPT_SUBTYPE),
 	fsparam_u32	("root_dir",		OPT_ROOT_DIR),
+	fsparam_flag	("no_daemon",		OPT_NO_DAEMON),
 	{}
 };
 
@@ -933,6 +935,11 @@ static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
 			return invalfc(fsc, "Unable to open root directory");
 		break;
 
+	case OPT_NO_DAEMON:
+		ctx->no_daemon = true;
+		ctx->fd_present = true;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -1506,7 +1513,7 @@ void fuse_send_init(struct fuse_mount *fm)
 	ia->args.nocreds = true;
 	ia->args.end = process_init_reply;
 
-	if (fuse_simple_background(fm, &ia->args, GFP_KERNEL) != 0)
+	if (unlikely(fm->fc->no_daemon) || fuse_simple_background(fm, &ia->args, GFP_KERNEL) != 0)
 		process_init_reply(fm, &ia->args, -ENOTCONN);
 }
 EXPORT_SYMBOL_GPL(fuse_send_init);
@@ -1798,6 +1805,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	fc->destroy = ctx->destroy;
 	fc->no_control = ctx->no_control;
 	fc->no_force_umount = ctx->no_force_umount;
+	fc->no_daemon = ctx->no_daemon;
 
 	err = -ENOMEM;
 	root = fuse_get_root_inode(sb, ctx->rootmode, ctx->root_dir);
@@ -1844,7 +1852,7 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	struct fuse_fs_context *ctx = fsc->fs_private;
 	int err;
 
-	if (!ctx->file || !ctx->rootmode_present ||
+	if (!!ctx->file == ctx->no_daemon || !ctx->rootmode_present ||
 	    !ctx->user_id_present || !ctx->group_id_present)
 		return -EINVAL;
 
@@ -1852,10 +1860,12 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	 * Require mount to happen from the same user namespace which
 	 * opened /dev/fuse to prevent potential attacks.
 	 */
-	if ((ctx->file->f_op != &fuse_dev_operations) ||
-	    (ctx->file->f_cred->user_ns != sb->s_user_ns))
-		return -EINVAL;
-	ctx->fudptr = &ctx->file->private_data;
+	if (ctx->file) {
+		if ((ctx->file->f_op != &fuse_dev_operations) ||
+		    (ctx->file->f_cred->user_ns != sb->s_user_ns))
+			return -EINVAL;
+		ctx->fudptr = &ctx->file->private_data;
+	}
 
 	err = fuse_fill_super_common(sb, ctx);
 	if (err)
@@ -1905,6 +1915,9 @@ static int fuse_get_tree(struct fs_context *fsc)
 
 	fsc->s_fs_info = fm;
 
+	if (ctx->no_daemon)
+		return get_tree_nodev(fsc, fuse_fill_super);;
+
 	if (ctx->fd_present)
 		ctx->file = fget(ctx->fd);
 
-- 
2.44.0.478.gd926399ef9-goog

