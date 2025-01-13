Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0931F9419;
	Mon, 13 Jan 2025 18:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793295; cv=none; b=FqZJIj9WkR0MQD7yahmTg4dVxV3Fev3qL3w0frSIzmV/9x5Farvcx3FlgVkbAtcwjD1gRkw1ir8d5W/RUcJrYkn1GQ6CMj69do+grbCR+/Y8+9Shxv7LMYMiGC4ZuedAi/pZ/ZzVckJE8CxBs2BuLm2cGFMFZbAIbmtsd/7MRcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793295; c=relaxed/simple;
	bh=Dx1KjkjC93S3IzzIaESQaq/jXmZCVzpwk035galG8Yk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iKg1d0j2KSoz3vvqaiupWiPe27N6Yax3IEycl/IpaCgNikbzO55vJGqhicN1Q+aYxmL5xbmqZTxa+sPh1p8oIPcY48ZTT1GleLlVXwr9tsLoekwIX2Vo9TktlpvYlmrq77fVMAJRbvj95WPvlUuJHAWUbvyof82OIjuWgwmzWww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqi3lzMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqi3lzMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213BEC4CEE2;
	Mon, 13 Jan 2025 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793294;
	bh=Dx1KjkjC93S3IzzIaESQaq/jXmZCVzpwk035galG8Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqi3lzMat10AFvEPNRzog0KNmizv1HXp1FYjFQd9yVKdG3WzCwJ1ZEiPZ5B7kW0a1
	 xCMpsF8tuGHmlDZDGKU78iMDfKMgLcgIMl85O3mNF+M8qL2rbWZd6NH/Ff9oB6goOC
	 XN1StKg7dNqgw8qw/7uwOlpgE8g0VLptWkp7Ef0iotM3SNf9T3mInmE5epqM81OkH4
	 8egLjZI+nL0oVyf4li42zSD0kjkNm8jzsMIktTnxYD/eSychmBXcloH5E5Nb/Cp5KP
	 aqWgNxtfdPrnF629/2FWILUVPeG2JUq+2T1a869u62YanNxSrSc7TjFs26yRrxcFv0
	 Dfi64KlN6c0Wg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	miklos@szeredi.hu,
	linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 13/20] ovl: pass realinode to ovl_encode_real_fh() instead of realdentry
Date: Mon, 13 Jan 2025 13:34:18 -0500
Message-Id: <20250113183425.1783715-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250113183425.1783715-1-sashal@kernel.org>
References: <20250113183425.1783715-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.9
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 07aeefae7ff44d80524375253980b1bdee2396b0 ]

We want to be able to encode an fid from an inode with no alias.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/r/20250105162404.357058-2-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c   | 11 ++++++-----
 fs/overlayfs/export.c    |  5 +++--
 fs/overlayfs/namei.c     |  4 ++--
 fs/overlayfs/overlayfs.h |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2ed6ad641a20..a11a9d756a7b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -416,13 +416,13 @@ int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upperdentry,
 	return err;
 }
 
-struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
+struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct inode *realinode,
 				  bool is_upper)
 {
 	struct ovl_fh *fh;
 	int fh_type, dwords;
 	int buflen = MAX_HANDLE_SZ;
-	uuid_t *uuid = &real->d_sb->s_uuid;
+	uuid_t *uuid = &realinode->i_sb->s_uuid;
 	int err;
 
 	/* Make sure the real fid stays 32bit aligned */
@@ -439,7 +439,8 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	 * the price or reconnecting the dentry.
 	 */
 	dwords = buflen >> 2;
-	fh_type = exportfs_encode_fh(real, (void *)fh->fb.fid, &dwords, 0);
+	fh_type = exportfs_encode_inode_fh(realinode, (void *)fh->fb.fid,
+					   &dwords, NULL, 0);
 	buflen = (dwords << 2);
 
 	err = -EIO;
@@ -481,7 +482,7 @@ struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry *origin)
 	if (!ovl_can_decode_fh(origin->d_sb))
 		return NULL;
 
-	return ovl_encode_real_fh(ofs, origin, false);
+	return ovl_encode_real_fh(ofs, d_inode(origin), false);
 }
 
 int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
@@ -506,7 +507,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
 	const struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, upper, true);
+	fh = ovl_encode_real_fh(ofs, d_inode(upper), true);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 5868cb222955..036c9f39a14d 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -223,6 +223,7 @@ static int ovl_check_encode_origin(struct dentry *dentry)
 static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
 			     u32 *fid, int buflen)
 {
+	struct inode *inode = d_inode(dentry);
 	struct ovl_fh *fh = NULL;
 	int err, enc_lower;
 	int len;
@@ -236,8 +237,8 @@ static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
 		goto fail;
 
 	/* Encode an upper or lower file handle */
-	fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_dentry_lower(dentry) :
-				ovl_dentry_upper(dentry), !enc_lower);
+	fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_inode_lower(inode) :
+				ovl_inode_upper(inode), !enc_lower);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5764f91d283e..42b73ae5ba01 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -542,7 +542,7 @@ int ovl_verify_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, real, is_upper);
+	fh = ovl_encode_real_fh(ofs, d_inode(real), is_upper);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh)) {
 		fh = NULL;
@@ -738,7 +738,7 @@ int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_real_fh(ofs, origin, false);
+	fh = ovl_encode_real_fh(ofs, d_inode(origin), false);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0bfe35da4b7b..844874b4a91a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -869,7 +869,7 @@ int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct super_block *sb, const struct path *path, struct dentry *new);
 int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
+struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct inode *realinode,
 				  bool is_upper);
 struct ovl_fh *ovl_get_origin_fh(struct ovl_fs *ofs, struct dentry *origin);
 int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
-- 
2.39.5

