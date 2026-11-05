Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881239;
	b=lJZxzU44HJaTl8pekEgVeqDKh8wBQ2T+zM21rukbaw2/Mi+I33mGn6ciYPni8uWk1ojy
	 z61BZ6PXOQLazmEzL+FGCjN2gsllE7yzQOXFxatrwZBSb8wysLFU2cKNjdWY2mpwD2EDl
	 ioj8Rnz6xYqAViu52KGwXORFz25k0ogotYn+0ifFGfbxNSE46Ly1by7/JE3x+aGdIlbKk
	 29LY5A3BUVJ1aZQ4AcRBe+sn04yQKHGid+mNRwtAo+0JPmwIjy7GGr0ka1pgAXssbKDLf
	 ikz2hmKnvapwUl1qz5pqmJDmLKq/8ExSvUEI5vldZZwDwuKo9Kmgy1xF4TzW1J5Yn4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=cG0nvbEc938K4g6g0/S3C0E3FXYt4wLOjjf5YYDWR2A=;
	b=uYu07Er9ddNY+p6jHBxv4IMU8iM/PJ8TVvYUKdAV/LAT3RxK87jopQWkwOhcDaLXWXtn
	 zMVoCFy7tCLWcYDQ+qGgj6URK1U1FqQyrLDune3aXEZc1EzYlUjbBNiHvNoPeH5IUZFNu
	 Slh5zncJN18EiZgFnyo+rc6eZQVHh4O63Rl5ca2JXHKEeM5CT90MjoWj9j9fSwHE8MSH5
	 HV8FESWHlV+1QhS1GYU2+dd9M9IP7JrN4PmHwQtvA4CL9kO7bsK+Pzl7hU0XyE8dcHksj
	 23alT4Db36eyyZmUsdrBLoSxKx/SL4jEC0wa2SuuwXJ1ENGJ2h2PCsG2iCpUkh0chkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmYzrNLY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47E606A31B;
	Thu,  5 Nov 2026 12:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmYzrNLY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99681F00919;
	Thu,  5 Nov 2026 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793881239;
	bh=cG0nvbEc938K4g6g0/S3C0E3FXYt4wLOjjf5YYDWR2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmYzrNLYvxren5PP1A3h6/d8edG1RiPxWIVclUDZHeAFyJhy1fwe90qLhH6jf6kdW
	 a5/yE4cRFus6sZ5oUcLNS9gkKsU4mTVAwxVxkah6ZrWnbvg/ZS4rLQW1awpJKrN3TP
	 OjSgsNjyTiJoqwFp+Y5+KrZvEF7Z1vxEkdOIT6tcYA5DpWq9W++R5AHZGHhLB+Jgzw
	 h2YR26nJ/PWPfiZaTf2AcfIJvaJVV8z6B8QyA6J2mzRbQShJ+KEhZU/G7VvPIInXuQ
	 sWbycoHdmzrc1n2ScUfWLtRayuPaLQOaxZ8EYLuVfa3XRT4qsNK97jotKLk6CPl+Lz
	 QqvNtFk+5zcaw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y 2/4] ovl: pass ofs to setattr operations
Date: Thu,  5 Nov 2026 07:20:34 -0500
Message-ID: <20261105121919.1276067-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105121919.1276067-1-sashal@kernel.org>
References: <2026110419-skeptic-dictation-d90e@gregkh>
 <20261105121919.1276067-1-sashal@kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 5272eaf3a5682750f6f26ec542b206f0821fb3cb ]

Pass down struct ovl_fs to setattr operations so we can ultimately
retrieve the relevant upper mount and take the mount's idmapping into
account when creating new filesystem objects. This is needed to support
idmapped base layers with overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 755b5c5c9277 ("ovl: do not copy up an xattr value that was never read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c   | 19 +++++++++++--------
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4c7ef60dbaac0..fd393716147eb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -292,7 +292,8 @@ static int ovl_copy_up_data(struct ovl_fs *ofs, struct path *old,
 	return error;
 }
 
-static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
+static int ovl_set_size(struct ovl_fs *ofs,
+			struct dentry *upperdentry, struct kstat *stat)
 {
 	struct iattr attr = {
 		.ia_valid = ATTR_SIZE,
@@ -302,7 +303,8 @@ static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
 	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
 }
 
-static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
+static int ovl_set_timestamps(struct ovl_fs *ofs, struct dentry *upperdentry,
+			      struct kstat *stat)
 {
 	struct iattr attr = {
 		.ia_valid =
@@ -314,7 +316,8 @@ static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
 	return notify_change(&init_user_ns, upperdentry, &attr, NULL);
 }
 
-int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
+int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
+		 struct kstat *stat)
 {
 	int err = 0;
 
@@ -334,7 +337,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 		err = notify_change(&init_user_ns, upperdentry, &attr, NULL);
 	}
 	if (!err)
-		ovl_set_timestamps(upperdentry, stat);
+		ovl_set_timestamps(ofs, upperdentry, stat);
 
 	return err;
 }
@@ -540,7 +543,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 
 		if (!err) {
 			/* Restore timestamps on parent (best effort) */
-			ovl_set_timestamps(upperdir, &c->pstat);
+			ovl_set_timestamps(ofs, upperdir, &c->pstat);
 			ovl_dentry_set_upper_alias(c->dentry);
 			ovl_dentry_update_reval(c->dentry, upper);
 		}
@@ -617,9 +620,9 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 
 	inode_lock(temp->d_inode);
 	if (S_ISREG(c->stat.mode))
-		err = ovl_set_size(temp, &c->stat);
+		err = ovl_set_size(ofs, temp, &c->stat);
 	if (!err)
-		err = ovl_set_attr(temp, &c->stat);
+		err = ovl_set_attr(ofs, temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
 	return err;
@@ -847,7 +850,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 
 		/* Restore timestamps on parent (best effort) */
 		inode_lock(udir);
-		ovl_set_timestamps(c->destdir, &c->pstat);
+		ovl_set_timestamps(ofs, c->destdir, &c->pstat);
 		inode_unlock(udir);
 
 		ovl_dentry_set_upper_alias(c->dentry);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5dceb9b076234..9065b69b87971 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -407,7 +407,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 		goto out_cleanup;
 
 	inode_lock(opaquedir->d_inode);
-	err = ovl_set_attr(opaquedir, &stat);
+	err = ovl_set_attr(ofs, opaquedir, &stat);
 	inode_unlock(opaquedir->d_inode);
 	if (err)
 		goto out_cleanup;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ad011aabfccb2..9f891340d60d8 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -618,7 +618,7 @@ int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 		   struct dentry *new);
-int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 				  bool is_upper);
 int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
-- 
2.53.0

