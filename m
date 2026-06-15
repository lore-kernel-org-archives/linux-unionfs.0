Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38F33F485F;
	Mon, 15 Jun 2026 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529624; cv=none; b=E6+DR9ZLf/g4iZ5Q6UAUGwShrN5uGvCZ06KQRCdCG/i1Nf4pt8lBuW3FiU5iw8WvyxlNDZpnEkggkXitTi4AUPI++2UIX8jxcvQoLqvmP0mr/tM5vmmX+BuYgqOSsTP5JFaPgrkQT7tRbaCAge4ojLKN4lffbCbuCzYbKj3dfUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529624; c=relaxed/simple;
	bh=DNeRIYjbkUKWItLjpqd3MaID1vUuQUKFko6vZezSndQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=te9D53g4Mr8+E8hIQHj48313TRRyWiP+rYL68/fmjCZxLmgmUoOlsenhjRLIq98ge2KBhLVegtehb8BbMVyPSBHkDpS0M6PcX6PxJxK7i3OJFbwvxMhtCNg5eXfg2laaYF0McmMe5ulbS2OkTl4FfYVUUQ+8a6PsDoKln9MpMgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z0IBCtJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z0IBCtJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C5D1F00A3D;
	Mon, 15 Jun 2026 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529622;
	bh=/1seP85KHVzeaoK6Wv6Z5WPE3l7PMpUZIxsF2LzzckI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z0IBCtJ/H6NDW3sclzSxk0ecjH58LmRwZ/O0Kzk5R4Jt+/ThJboinKrOrSyJSzQQ2
	 iEaMXXqsAfPM15xMEblBt2AN952UE5cP4u8JtkASIJfCAPaEDDUCGAuOFZ7MlbgkBU
	 VXmIsXAxmLPcdTmE1VNTs3N6dSnGfl0lYbR72hfaG0jRuDde4hB6RFu5tN3m2el6pU
	 ZXkh+EQvrLcknHYRZsstldYpbZ+I+sRSfz/xgNVS7k+ZZWiHuKsbUd00QklChS13Rr
	 tXhgJetgPZjyASM00c1SImUhcTN72BCWWO8d2v9qjHWhSoXX2Xhx7subHJXUMAmcDt
	 iqf/j9sL9mWsg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:53 +0200
Subject: [PATCH 04/10] ovl: handle idmapped mounts in ovl_getattr()
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-4-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=1846; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DNeRIYjbkUKWItLjpqd3MaID1vUuQUKFko6vZezSndQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+GRTxf+wx7Odap4q+Kqxw+OydrkyE9uVUx8vqO9u
 S5s9rqZHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZ/5ORYZHIrPZIRdXwqQy+
 1o1qKbc/lfy48I7NIkZHSzVxMd/0Uwz/rAR3vznhx5EYFt4SquwhqvCF53Rip6Pt46vH7ypUHch
 jBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ovl_getattr() fetches attributes from the real (upper or lower) path
via vfs_getattr(), so the returned stat->uid/stat->gid are already
mapped through the real layer idmap but not through the overlay mount
idmap.  Unlike the generic path, the VFS does not re-apply the
accessing mount's idmap after ->getattr returns - generic_fillattr()
does it, but overlayfs bypasses it - so overlayfs has to do it itself.

Map stat->uid/stat->gid through the overlay mount idmap before
returning, mirroring generic_fillattr().  The owner reported through an
idmapped overlay mount is thus the overlay-final id translated by the
mount idmap.

No functional change until FS_ALLOW_IDMAP is set on ovl_fs_type; until
then make_vfsuid()/make_vfsgid() are the identity for &nop_mnt_idmap.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 33734ca971e1..45b2a5c3d978 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -180,6 +180,8 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
 	int fsid = 0;
 	int err;
 	bool metacopy_blocks = false;
+	vfsuid_t vfsuid;
+	vfsgid_t vfsgid;
 
 	metacopy_blocks = ovl_is_metacopy_dentry(dentry);
 
@@ -292,6 +294,12 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
 	if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		stat->nlink = dentry->d_inode->i_nlink;
 
+	/* Map ownership of the real inode through the overlay mount idmap. */
+	vfsuid = make_vfsuid(idmap, i_user_ns(inode), stat->uid);
+	vfsgid = make_vfsgid(idmap, i_user_ns(inode), stat->gid);
+	stat->uid = vfsuid_into_kuid(vfsuid);
+	stat->gid = vfsgid_into_kgid(vfsgid);
+
 	return err;
 }
 

-- 
2.47.3

