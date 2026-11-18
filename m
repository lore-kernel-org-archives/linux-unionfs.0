Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053007;
	b=lHdS+GVzGfDA0mi62adlK3ObVQz6H9KOY2jcUTZkuZhtf2oqbZ75nrdiX4C6Gm1tVb+l
	 3oUe6fvTlecZO8ghfd0sIvL82W3gbuM4n/Hdr9NAoEbQf19+pC+Yj4mbHj2sYemuUoV0b
	 nGYEYH1Zxwo5m9XMLYK5qnoeD9clxPqfRyzwZ0GHw/ySyN/kSWm8JIOL46rCuq2OqlymF
	 AtChBgEw40XPHV7+xmE0B9H5LYlGFnh+MEZhPMTgpNdf1rknCe0xQxe3Y4fCmjKQ/D9ax
	 hgwrg9uNh5CNW3pO8XzSy4XkA8fqFQacIOyyX4DHCGA035rnL3s4FQqvMK1S5LD4vxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eDMrua8e3ig2CSWRoDRgzZzW6NQ9vg9ef96ssQPi0FM=;
	b=UYOIyesPJsTvL9LbZsozZCSA9+cMDEhamJou3XSfExsHY+bv4fJBoxQAnye3koJLrB7a
	 Yhx4ik159Yw4tEbGnSpMoYA6P91cC0wKjlppN+P3AD6nplf9KT1xUnyGNXAIMjzZLuPGI
	 LXiZnR7/v+ftcsy7ypKKRVFx4vo/QdN27QmKtWhsFYWJE0Tozkq1oIKZ9JlZikYlMK/Cp
	 oPzgNaIPVAem8w45XjnT4KL2iNbqm1mnaWBXcQhskndJ137KApaAuKfUgJsrdYadQM4+w
	 EzVMIvj9mNjeJDLP7n03BJ/Yv4BFYnwmys/J2rpj+qMlN2yjhjoAVnpDXsJFmM9yjnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvueBVjP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E665606A31C;
	Thu, 19 Nov 2026 01:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BvueBVjP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5081F000C4;
	Thu, 19 Nov 2026 01:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053007;
	bh=eDMrua8e3ig2CSWRoDRgzZzW6NQ9vg9ef96ssQPi0FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvueBVjP3HaaOKkUtYmoTsH31U78UB8oGCup313t3D7EY5DxijFpqs81MOG7yc0AK
	 npT8Y/6eBzZCsaFFlSorNcA0LInNaeKJc/jTvVUjAgqqjwaXajYKx+CZ1Q+3QSOAid
	 rVI3Cj3JDWuNhokL7le/eyelPd6G9PKYTNZ2wiHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-unionfs@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Microsoft)" <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0765/2214] ovl: pass ofs to setattr operations
Date: Wed, 18 Nov 2026 15:40:41 +0100
Message-ID: <20261118150042.303470990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 24b4e41e939dc..44a0514c62ac0 100644
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
@@ -858,7 +861,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 
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



