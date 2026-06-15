Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2893F44D3;
	Mon, 15 Jun 2026 13:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529636; cv=none; b=kHtTGzaV7a5Vw499RYkCoaYiyCVUA55cxvocWBKYYQRsukBiCth93jB0OjqNOhxEKZTpUScdH+zAj78kFwtAfe4TB2/lCnb7T1BFVLHcECF6JWrkIZ6pSznF+aJmGEkqf/3MthbcHT7SEg9nV64l4NNE/Dfl4An0647cN3deY5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529636; c=relaxed/simple;
	bh=bcGOBZH4TiD3PGlipX298RqL/DmGAjPRcuIuHeRMMDI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IhxtK6U8hmavKuZAZLsfoov6VldlvedEu5QGGgYuu18jID64ejYW133piUvVj/x5BanzN/a66Vyt5fvL4LhrYtTEMK2hyb046wq9/5HQ1IKPjCwYMIbt7fR1bvn9NE4YCpjQaxAbDfedLSoasbLc/qTXUvj/HgbEy2pf8rm6Zgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EgDY3dBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EgDY3dBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7AC1F000E9;
	Mon, 15 Jun 2026 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529634;
	bh=SSos3q3LJk16U7nMl/MDeNjnRNoZ+aeDlq2eqBV/c+o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EgDY3dBbR1Ox+vOQuI5pvK8eclKWDmXMxvUDUZzrYylXGChtmqmSR+q9P3botdQ37
	 E5GEMKHASZYNWC7GSQVaik3DI7TFv8kcH67IuoKj7qoaGXoZm/U/OMCm+uP5W1luWc
	 r5JrwkZnchjnUvT8qHiub4g+eTUbuBMyXroYqD0tdK/ApKP0O/dJjC1mNw+AZ7/dKF
	 s6bOhmxeTiG8wxjnRL2ze6jzDt1ifCWUCr2aX/hfilhqmv+H5JmUox0L5JMBdbFt2C
	 FofUcPVJJyclZ8uluNH1xZz1fVOjLEkgyoJ7WblAGpR3eBSld3fb4n2TWd2z0ss8UH
	 RCOgVy6ffdZRA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:59 +0200
Subject: [PATCH 10/10] ovl: document security.capability idmapping on the
 xattr forward paths
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-10-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=2345; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bcGOBZH4TiD3PGlipX298RqL/DmGAjPRcuIuHeRMMDI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+GNuyz5bYZYme6l1G2hL8UuBTmeCxY4aGe+3GErw
 +TSp1LPO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayYSIjw2Tt+czbZqyzeC2d
 tkrWbc5lR0/xV6x/WLmKbzzMZatPamb4XzX5q1nhpcsG3G83P5mdGH7SLPDA8a2fbaSE61offXJ
 kYQYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Now that an overlay mount can itself be idmapped, every id exposed at
the overlay-inode boundary is mapped through the overlay mount idmap.
security.capability is the one id-bearing xattr that overlayfs does not
translate in its own boundary code: the embedded rootid of a v3 fscap
is instead mapped by the capability LSM inside vfs_getxattr() and
vfs_setxattr().

It still composes correctly only because the xattr read and write
forwards go through the security-aware vfs_getxattr() / vfs_setxattr()
rather than the raw __vfs_*xattr() variants: commoncap maps the rootid
through the layer idmap at the overlay-to-real forward, while the
overlay mount idmap is applied by the outer vfs_getxattr() at the
syscall boundary, mirroring the layer-then-mount composition used by
ovl_getattr().

The raw __vfs_*xattr() variants skip the security hooks and would
silently drop the rootid mapping. Comment both forwards - the read in
ovl_xattr_get() and the write in ovl_do_setxattr() - so they are not
converted to them by accident.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/overlayfs.h | 1 +
 fs/overlayfs/xattrs.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b75df37f70ac..e0d8c6152e9f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -320,6 +320,7 @@ static inline int ovl_do_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 				  const char *name, const void *value,
 				  size_t size, int flags)
 {
+	/* Use vfs_setxattr(), not __vfs_setxattr(): it idmaps the security.capability rootid. */
 	int err = vfs_setxattr(ovl_upper_mnt_idmap(ofs), dentry, name,
 			       value, size, flags);
 
diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
index aa95855c7023..811c94d2d9e9 100644
--- a/fs/overlayfs/xattrs.c
+++ b/fs/overlayfs/xattrs.c
@@ -84,6 +84,7 @@ static int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char
 	struct path realpath;
 
 	ovl_i_path_real(inode, &realpath);
+	/* Use vfs_getxattr(), not __vfs_getxattr(): it idmaps the security.capability rootid. */
 	with_ovl_creds(dentry->d_sb)
 		return vfs_getxattr(mnt_idmap(realpath.mnt), realpath.dentry, name, value, size);
 }

-- 
2.47.3

