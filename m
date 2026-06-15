Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854B83F44F5;
	Mon, 15 Jun 2026 13:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529618; cv=none; b=SgpBwOPgDzlGGsZIBoOXM0SXETJ18Cr5tToa+F2cv3bV3Jms95oBYuMCISRCcWVAh3MYw4OXkazoDnVh4PvFEozlgP/OYIpcDWyIBZbbipOx3g9/7ogj4mtSfVD+bKX4gRDK0Ei6XrUEkX8HKfhSk5M2JSFyhFLEA/dk6aGzNTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529618; c=relaxed/simple;
	bh=NpWUpF2WSEyl1oSiqyWLF2E+Soif/8wHHnhGgpZqmQE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hb5/3GIDUUNwvJSTYycAS9y2G9J+uv4Eh6d2Fhb6Ic+T4ELmXxBRbFXd2sOexXTN8w9ccJ57fn4afdzqLGx/062BJANl0tnETW1bddE2W4Piw8Bmk9NkRwdxnDLVp/jBArmDLNPFZFeXXctYez+OXvB9mL+Z3GKJ0QTV4bW5GIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TTOA+XeX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TTOA+XeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB861F00A3A;
	Mon, 15 Jun 2026 13:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529617;
	bh=e/IMpetT2k0wHwxIN4I/giBOH+uiAW+AqVmzJ8SbQ3E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TTOA+XeXbVDfG3ERLrlAQsu1HufPecwviiIjtH//bNYfPJMiEf9s12PeJzwudop8l
	 EXZMq3PR2x/QAn6HtpldcBAHmBwr2fea5BdKXzzeI/90J6S6wYQbvx+pAxxmfn+BmQ
	 JZxxJKFo221eIZBualy3g2Ml+ALs33In8L95BmekGKWXgNA8bvjuGDF4Suf+xUquOv
	 jO9wveFQxd3ICtBM7f0g0NcCC9BNahuZQ9STU7YaHY2+Jm3Na2GK3m0YZlfetipKU7
	 FkzsqMAwdXwrIizPjdBECVseHSLyMTCM8PM3aGh5g2g7YF04TbkClwPaP+2xkNEYaP
	 8q2BNn6+mdwOA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:50 +0200
Subject: [PATCH 01/10] ovl: handle idmapped mounts in ovl_create_object()
 and ovl_tmpfile()
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-1-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=3517; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NpWUpF2WSEyl1oSiqyWLF2E+Soif/8wHHnhGgpZqmQE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+GJmKlcJ3OvVuNIlN3xZbouK1g0Jl3hSLXw2bfBw
 97M+fDijlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn0bGb4Z+2WtK7mQ+P9F/cm
 TWr2Xr3/wqkrzxbqWlY+bLJXeXaQ14Dhf0HttRgl9jK9kwkxgnseuus0rJw4+fiTItO+Y0yueg/
 ZGAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

In preparation for allowing the overlay mount itself to be idmapped,
thread the mount's struct mnt_idmap into the inode creation path and
use it for inode_init_owner() instead of the hardcoded &nop_mnt_idmap.

The preallocated overlay inode's i_{u,g}id are copied into the override
credentials by ovl_override_creator_creds() to create the real upper
inode, so honoring the overlay mount idmap here makes newly created
files, directories, special files, symlinks and tmpfiles get the
caller's mapped fs{u,g}id once overlay mounts can be idmapped.

No functional change: until FS_ALLOW_IDMAP is set on ovl_fs_type the
overlay mount idmap is always &nop_mnt_idmap, so inode_init_owner()
behaves exactly as before.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/dir.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a033743dbf51..a7a393b04277 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -689,8 +689,8 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	return err;
 }
 
-static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
-			     const char *link)
+static int ovl_create_object(struct mnt_idmap *idmap, struct dentry *dentry,
+			     int mode, dev_t rdev, const char *link)
 {
 	int err;
 	struct inode *inode;
@@ -717,7 +717,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	inode_state_set(inode, I_CREATING);
 	spin_unlock(&inode->i_lock);
 
-	inode_init_owner(&nop_mnt_idmap, inode, dentry->d_parent->d_inode, mode);
+	inode_init_owner(idmap, inode, dentry->d_parent->d_inode, mode);
 	attr.mode = inode->i_mode;
 
 	err = ovl_create_or_link(dentry, inode, &attr, false);
@@ -734,13 +734,13 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 static int ovl_create(struct mnt_idmap *idmap, struct inode *dir,
 		      struct dentry *dentry, umode_t mode, bool excl)
 {
-	return ovl_create_object(dentry, (mode & 07777) | S_IFREG, 0, NULL);
+	return ovl_create_object(idmap, dentry, (mode & 07777) | S_IFREG, 0, NULL);
 }
 
 static struct dentry *ovl_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 				struct dentry *dentry, umode_t mode)
 {
-	return ERR_PTR(ovl_create_object(dentry, (mode & 07777) | S_IFDIR, 0, NULL));
+	return ERR_PTR(ovl_create_object(idmap, dentry, (mode & 07777) | S_IFDIR, 0, NULL));
 }
 
 static int ovl_mknod(struct mnt_idmap *idmap, struct inode *dir,
@@ -750,13 +750,13 @@ static int ovl_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	if (S_ISCHR(mode) && rdev == WHITEOUT_DEV)
 		return -EPERM;
 
-	return ovl_create_object(dentry, mode, rdev, NULL);
+	return ovl_create_object(idmap, dentry, mode, rdev, NULL);
 }
 
 static int ovl_symlink(struct mnt_idmap *idmap, struct inode *dir,
 		       struct dentry *dentry, const char *link)
 {
-	return ovl_create_object(dentry, S_IFLNK, 0, link);
+	return ovl_create_object(idmap, dentry, S_IFLNK, 0, link);
 }
 
 static int ovl_set_link_redirect(struct dentry *dentry)
@@ -1444,7 +1444,7 @@ static int ovl_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 	if (!inode)
 		goto drop_write;
 
-	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
+	inode_init_owner(idmap, inode, dir, mode);
 	err = ovl_create_tmpfile(file, dentry, inode, inode->i_mode);
 	if (err)
 		goto put_inode;

-- 
2.47.3

