Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0450625CC4E
	for <linux-unionfs@vger.kernel.org>; Tue, 20 May 2025 05:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747718181; cv=none; b=WLQhLqvJSpX2DFmd/gGjxD8gs53U5uPmlQXLjIJ5WFABia5RrlV+Z/hQVqxS5xPNT5C8BL0NexOtpwKp4P90R2enWXF1kSrgboHL+G91c5mMxrbTOIGh+gFCPEQzfO1+5XfAeszqGnceqERp6jlSfwGbzFtXmkYhXDiMHNuO4LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747718181; c=relaxed/simple;
	bh=XrNNzUY1TXKJiOxaGFQwiLM9iQNnTBPUEAMRSKaZEtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtU/42K7pxjX8dacgqfg2C5dcqH4XTpzV2S0ldsKlgFgSI45ZkZ/ypcV/GNrxTtojg5AVz6FivTba6U/BfgN6ieD/tFIvdr5k72O6VJa/PrANUDQN06eJrJO+BL4S0nX1WU1d/WV5PqgzJ74C59Pkz7atXgegfQFFQNPQzf3gjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sol6R6Lb; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sol6R6Lb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747718176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGQ1zxXw5QQ6/+CjgC6ci/ZRW8eopkMw2zSjQhSjJdk=;
	b=Sol6R6LbqJ+Hh10AABgv0JL5++/JH7BlUN9ny23vNyrqcFPCwTyoypoLpjXmh7HXc++t0a
	N/AJUpjtNrykPoG1OSC4g1YnUJ1v4kVlFogto/jcMfOuwVGvOPMYHCrl1cfIfOUpOYgU6n
	gS1cL+M/5jEyKqoh21DhSNgim+tZie0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-fsdevel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6/6] overlayfs: Support casefolded filesystems
Date: Tue, 20 May 2025 01:15:58 -0400
Message-ID: <20250520051600.1903319-7-kent.overstreet@linux.dev>
In-Reply-To: <20250520051600.1903319-1-kent.overstreet@linux.dev>
References: <20250520051600.1903319-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Overlayfs can now work on filesystems that support casefolding, provided
the specific subtree overlayfs is using as layers don't have casefolding
enabled.

d_casefold_disabled_get() and put() are used, which check that
casefolding is enabled nowhere on a given subtree, and get and release a
reference that prevents the filesystem from enabling casefolding on that
tree while overlayfs is in use.

We also now check the new SB_CASEFOLD superblock flag; if it's set we
allow for dcache hash and compare ops to be set, relying instead on the
new dcache methods.

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/overlayfs/params.c | 20 +++++++++++++++++---
 fs/overlayfs/util.c   | 19 +++++++++++++++----
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 6759f7d040c8..ae7424e075a7 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -287,7 +287,8 @@ static int ovl_mount_dir_check(struct fs_context *fc, const struct path *path,
 	 * with overlayfs.  Check explicitly to prevent post-mount
 	 * failures.
 	 */
-	if (sb_has_encoding(path->mnt->mnt_sb))
+	if ((path->mnt->mnt_sb->s_flags & SB_CASEFOLD) &&
+	    !(path->dentry->d_inode->i_flags & S_NO_CASEFOLD))
 		return invalfc(fc, "case-insensitive capable filesystem on %s not supported", name);
 
 	if (ovl_dentry_weird(path->dentry))
@@ -411,20 +412,32 @@ static int ovl_do_parse_layer(struct fs_context *fc, const char *layer_name,
 	if (!name)
 		return -ENOMEM;
 
+	if (layer != Opt_workdir &&
+	    layer != Opt_upperdir) {
+		err = d_casefold_disabled_get(layer_path->dentry);
+		if (err)
+			return err;
+	}
+
 	upper = is_upper_layer(layer);
 	err = ovl_mount_dir_check(fc, layer_path, layer, name, upper);
 	if (err)
-		return err;
+		goto err_put;
 
 	if (!upper) {
 		err = ovl_ctx_realloc_lower(fc);
 		if (err)
-			return err;
+			goto err_put;
 	}
 
 	/* Store the user provided path string in ctx to show in mountinfo */
 	ovl_add_layer(fc, layer, layer_path, &name);
 	return err;
+err_put:
+	if (layer != Opt_workdir &&
+	    layer != Opt_upperdir)
+		d_casefold_disabled_put(layer_path->dentry);
+	return err;
 }
 
 static int ovl_parse_layer(struct fs_context *fc, struct fs_parameter *param,
@@ -475,6 +488,7 @@ static void ovl_reset_lowerdirs(struct ovl_fs_context *ctx)
 	ctx->lowerdir_all = NULL;
 
 	for (size_t nr = 0; nr < ctx->nr; nr++, l++) {
+		d_casefold_disabled_put(l->path.dentry);
 		path_put(&l->path);
 		kfree(l->name);
 		l->name = NULL;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0819c739cc2f..c515f260032c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -205,10 +205,21 @@ bool ovl_dentry_weird(struct dentry *dentry)
 	if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(dentry))
 		return true;
 
-	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
-				  DCACHE_MANAGE_TRANSIT |
-				  DCACHE_OP_HASH |
-				  DCACHE_OP_COMPARE);
+	if (dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
+			       DCACHE_MANAGE_TRANSIT))
+		return true;
+
+	/*
+	 * The filesystem might support casefolding, but we've already checked
+	 * that casefolding isn't present on this tree: we only need to check
+	 * for non-casefolding hash/compare ops
+	 */
+	if (!(dentry->d_sb->s_flags & SB_CASEFOLD) &&
+	    (dentry->d_flags & (DCACHE_OP_HASH |
+				DCACHE_OP_COMPARE)))
+		return true;
+
+	return false;
 }
 
 enum ovl_path_type ovl_path_type(struct dentry *dentry)
-- 
2.49.0

