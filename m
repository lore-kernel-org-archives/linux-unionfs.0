Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019197;
	b=e/FVShMdepm1qmiqS/e/dj9XSVnLKZFmYBqG5bDnEaMh/J1vlfvKzpc3BAZINLs0R5+C
	 yboZx7pfrzn5NUspRKlLnn+8bB37kbT24YF4VhZNh8nHNjzAtle9i7Z8QBG/U3KQZ064F
	 Nca0ZbIRwSoBbqF56NJZJy37p9KbluyPpHTYK0uUvmvU31QXM9Sgi1pO79A5IU2Q9fAKC
	 yWLHJtcFJHi9EMdmce8/8HNPmXxApKuj3iBPCVk436WXzGfed0hnidxNNwQaJnK9CjFSM
	 iPQuMdeUp9mF03uViegvove0mJME0SN0pbNDVERTA9VQSq/XjxWf6wSorNLwoVmJHMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019197;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8R8LZ+i0FaLTDkigpffcBCAnwgB/uoixBqukycJfWRk=;
	b=SMtblM2t1nL+qcSNLtctC485LJNF9h6hYuaSvEIx2/FgsHvzDlbbb4X3GlppuPFDD5Dj
	 z1AAH50u0qAoteawNuJN7wKRoFaKUSVUPRw68qZatFZqidZstr84QBB9zK+th2+HqTYBv
	 hGr50GBfk5GvHPKKNPjJGskf9KIygrBjiBBXfIIVSTsRvuhRFmTzeNrLPZKJTIZbT1YZ2
	 iGt1+lVHtK66svyS0/53FU/zHKzmk9Y8KJ+Kax399RkF8t8jd8vVf+tNxKBZVV+56VU1q
	 Dm5um/muypoOjAgL4sNWQq+fbNERnGojmODcF7tjtZ9ff8ek5cGRxW2NZQs7ekWqXJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BoT1vU4V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D26606A331;
	Wed, 18 Nov 2026 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BoT1vU4V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62181F000C4;
	Wed, 18 Nov 2026 16:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795019197;
	bh=8R8LZ+i0FaLTDkigpffcBCAnwgB/uoixBqukycJfWRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BoT1vU4Vcp+f02HUwQGgB3aSXaAj5nanI7aZF7JaVb7+/JGVGvNznNcMh9J4VLwFs
	 siTG+ebR2rum+4SW3xq8Ztm8jAwb/hFWY06zulTlbq4nUcYWiqtH2qUrMl7nmuNlab
	 UWehwP0yI04CD4roAqKoAd4B2CxJla5VbirLKxcdhlL8GBsgBplUOd+TPkm3AItBHt
	 GmBgOK5zD8CPQ3QTZo89VtjEWhsZTLOsXHBmM+iKlL01iRo5ihGcyWX0+whSFFXVMz
	 x6P5ND51CQc8xBrBcIwR10Ux5QiumG6RB9KPC4nrsa0kl2EtPOowjJDzz5QXXCW+Cu
	 gY83Y7XioatgQ==
Date: Wed, 18 Nov 2026 17:26:33 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 4/6] ovl: refuse pseudo lower layers unless offline lower
 changes are allowed
Message-ID: <20261118-wildwasser-raketen-hierbei-10c9d844ca6f@brauner>
References: <20261118073102.1216568-1-amir73il@gmail.com>
 <20261118073102.1216568-5-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118073102.1216568-5-amir73il@gmail.com>

On Wed, Nov 18, 2026 at 08:31:00AM +0100, Amir Goldstein wrote:
> -		/* Pseudo filesystems don't hold data for metacopy files. */
> -		if (i >= ctx->nr - ctx->nr_data &&
> +		/* Pseudo filesystems don't mix with new overlayfs features */
> +		if (!ovl_allow_offline_changes(ofs) &&
>  		    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {

sashiko.dev <sashiko@sashiko.dev>:

[Severity: Medium]
Does checking ovl_allow_offline_changes(ofs) here run before
ofs->config.index has been finalized?

[...]

Because most pseudo filesystems do not implement export operations,
evaluating ovl_allow_offline_changes(ofs) before those fallbacks run
causes a regression where mounting with an upperdir over a pseudo lower
layer fails with -EINVAL instead of falling back to index=off, and makes
multi-layer mounts depend on whether a non-exportfs lower layer appears
before or after the pseudo layer in lowerdir.

via: https://sashiko.dev/#/message/20261118073102.1216568-5-amir73il@gmail.com

I think that's right. ovl_lower_dir(), ovl_get_fsid() and the !workdir
case in ovl_fill_super_creds() all turn the index off.

So with index=on sysfs is refused when it comes first and accepted
behind a lower layer without file handles.

Same for sashiko's 6/6 report.

So I would fold the following diff so we check the layers once they're
set up but before ovl_init_uuid_xattr() and ovl_get_indexdir() write to
upper. I can fold this into 4/6, plus tests into 6/6, if you agree:

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2c08dc07bd149..4d803b16f3298 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1260,14 +1260,6 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];
 
-		/* Pseudo filesystems don't mix with new overlayfs features */
-		if (!ovl_allow_offline_changes(ofs) &&
-		    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
-			pr_err("pseudo filesystem on %s not supported with metacopy, index, redirect_dir=on, xino=on or data-only layers\n",
-			       l->name);
-			return ERR_PTR(-EINVAL);
-		}
-
 		err = ovl_lower_dir(l->name, &l->path, ofs, &sb->s_stack_depth);
 		if (err)
 			return ERR_PTR(err);
@@ -1374,6 +1366,28 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 	return 0;
 }
 
+/*
+ * Pseudo filesystems don't mix with new overlayfs features.  Check the layers
+ * only after setting them up, as that may have turned off the index.
+ */
+static int ovl_check_pseudo_layers(struct ovl_fs *ofs)
+{
+	unsigned int i;
+
+	if (ovl_allow_offline_changes(ofs))
+		return 0;
+
+	for (i = 1; i < ofs->numlayer; i++) {
+		if (ofs->layers[i].mnt->mnt_sb->s_iflags & SB_I_PSEUDO) {
+			pr_err("pseudo filesystem on %s not supported with metacopy, index, redirect_dir=on, xino=on or data-only layers\n",
+			       ofs->config.lowerdirs[i]);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static struct dentry *ovl_get_root(struct super_block *sb,
 				   struct dentry *upperdentry,
 				   struct ovl_entry *oe)
@@ -1538,6 +1552,15 @@ static int ovl_fill_super_creds(struct fs_context *fc, struct super_block *sb)
 	if (!ovl_upper_mnt(ofs))
 		sb->s_flags |= SB_RDONLY;
 
+	/* A mount without a workdir doesn't use the index */
+	if (!ofs->workdir)
+		ofs->config.index = false;
+
+	/* Before the uuid and the index dir are set up on the upper layer */
+	err = ovl_check_pseudo_layers(ofs);
+	if (err)
+		goto out_free_oe;
+
 	if (ovl_has_fsid(ofs) && ovl_upper_mnt(ofs)) {
 		/* Use per instance persistent uuid/fsid */
 		ovl_init_uuid_xattr(sb, ofs, &ctx->upper);

-- 
