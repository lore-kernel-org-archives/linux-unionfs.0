Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775EA1C4611;
	Wed, 25 Sep 2024 11:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265163; cv=none; b=rnVxYCm15tfl9slqGNI+ioHL7vWfnwj4jiC6lzyQc7Nx8OOWIU74PKmAVPTb3OuvE0pZYaBIob1tg8VI5qHh9vGT8CP52SoWJ6B3wRLv/S9MhKmC1E8Saiff49BCm+H3iov0YQof0K/QjDPJl3SWmQENdZ3v1q9Od9znES9eJJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265163; c=relaxed/simple;
	bh=m2ROjprRWhTVD3wZGN+3R3wT6CoVz83aRSUjazL7pI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ihk9Ju+cCc/O8IVffHYJFmEP76mZsn5M5IDwNTmSqM/d78bNpkfSk56mueJFgmoon2aUeMPkKBswN85qZlEBhO5ySoIKjkNhQ/V22VaJTGFA/WS9UMyVPXM1ciW1WVYa7UkEFXcxI3EFPQ3F9JvNlqTiSPzKPTCL88eQ5jAxyWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EiF/W+dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EiF/W+dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA31C4CEC3;
	Wed, 25 Sep 2024 11:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727265163;
	bh=m2ROjprRWhTVD3wZGN+3R3wT6CoVz83aRSUjazL7pI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiF/W+dJFB3lNxQZRWlw2dd+/IFKJQlNsfEBYpNJcffH2uqopZYQFQ/eZ2C88Rv1x
	 s+Vm2QATKyCnzYLXOQuqWbSo3mCTlZ180o/dBh3KlqY0j/bz8XP4y9N2sEHXqsj14q
	 QodXBIjXnpcGWE7un579Vc0SeMIerJ3llqvGOMFGdbcLSQ6mP9+IcYP69t5s9sumHM
	 2qje+QEw3tdrddQhwQymC8LUIV2JZ7tKn4MbsolfOlC+zRYBnvb+WpH4q96Uv+VVc2
	 WVzvZ2lAC4eFG2fZ9X+7thle6d61BOco3PLRrt8NWLJI8Ytnr4qrtwpWAWRbsBjy2n
	 kyDizlMEAnvTQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Fei Lv <feilv@asrmicro.com>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 222/244] ovl: fsync after metadata copy-up
Date: Wed, 25 Sep 2024 07:27:23 -0400
Message-ID: <20240925113641.1297102-222-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 7d6899fb69d25e1bc6f4700b7c1d92e6b608593d ]

For upper filesystems which do not use strict ordering of persisting
metadata changes (e.g. ubifs), when overlayfs file is modified for
the first time, copy up will create a copy of the lower file and
its parent directories in the upper layer. Permission lost of the
new upper parent directory was observed during power-cut stress test.

Fix by moving the fsync call to after metadata copy to make sure that the
metadata copied up directory and files persists to disk before renaming
from tmp to final destination.

With metacopy enabled, this change will hurt performance of workloads
such as chown -R, so we keep the legacy behavior of fsync only on copyup
of data.

Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxj-pOvmw1-uXR3qVdqtLjSkwcR9nVKcNU_vC10Zyf2miQ@mail.gmail.com/
Reported-and-tested-by: Fei Lv <feilv@asrmicro.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 43 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a5ef2005a2cc5..051a802893a18 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -243,8 +243,24 @@ static int ovl_verify_area(loff_t pos, loff_t pos2, loff_t len, loff_t totlen)
 	return 0;
 }
 
+static int ovl_sync_file(struct path *path)
+{
+	struct file *new_file;
+	int err;
+
+	new_file = ovl_path_open(path, O_LARGEFILE | O_RDONLY);
+	if (IS_ERR(new_file))
+		return PTR_ERR(new_file);
+
+	err = vfs_fsync(new_file, 0);
+	fput(new_file);
+
+	return err;
+}
+
 static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
-			    struct file *new_file, loff_t len)
+			    struct file *new_file, loff_t len,
+			    bool datasync)
 {
 	struct path datapath;
 	struct file *old_file;
@@ -342,7 +358,8 @@ static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 
 		len -= bytes;
 	}
-	if (!error && ovl_should_sync(ofs))
+	/* call fsync once, either now or later along with metadata */
+	if (!error && ovl_should_sync(ofs) && datasync)
 		error = vfs_fsync(new_file, 0);
 out_fput:
 	fput(old_file);
@@ -574,6 +591,7 @@ struct ovl_copy_up_ctx {
 	bool indexed;
 	bool metacopy;
 	bool metacopy_digest;
+	bool metadata_fsync;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -634,7 +652,8 @@ static int ovl_copy_up_data(struct ovl_copy_up_ctx *c, const struct path *temp)
 	if (IS_ERR(new_file))
 		return PTR_ERR(new_file);
 
-	err = ovl_copy_up_file(ofs, c->dentry, new_file, c->stat.size);
+	err = ovl_copy_up_file(ofs, c->dentry, new_file, c->stat.size,
+			       !c->metadata_fsync);
 	fput(new_file);
 
 	return err;
@@ -701,6 +720,10 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 		err = ovl_set_attr(ofs, temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
+	/* fsync metadata before moving it into upper dir */
+	if (!err && ovl_should_sync(ofs) && c->metadata_fsync)
+		err = ovl_sync_file(&upperpath);
+
 	return err;
 }
 
@@ -860,7 +883,8 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 
 	temp = tmpfile->f_path.dentry;
 	if (!c->metacopy && c->stat.size) {
-		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size);
+		err = ovl_copy_up_file(ofs, c->dentry, tmpfile, c->stat.size,
+				       !c->metadata_fsync);
 		if (err)
 			goto out_fput;
 	}
@@ -1135,6 +1159,17 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	    !kgid_has_mapping(current_user_ns(), ctx.stat.gid))
 		return -EOVERFLOW;
 
+	/*
+	 * With metacopy disabled, we fsync after final metadata copyup, for
+	 * both regular files and directories to get atomic copyup semantics
+	 * on filesystems that do not use strict metadata ordering (e.g. ubifs).
+	 *
+	 * With metacopy enabled we want to avoid fsync on all meta copyup
+	 * that will hurt performance of workloads such as chown -R, so we
+	 * only fsync on data copyup as legacy behavior.
+	 */
+	ctx.metadata_fsync = !OVL_FS(dentry->d_sb)->config.metacopy &&
+			     (S_ISREG(ctx.stat.mode) || S_ISDIR(ctx.stat.mode));
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
 	if (parent) {
-- 
2.43.0

