Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2B6F9E0
	for <linux-unionfs@vger.kernel.org>; Wed,  7 Feb 2024 02:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707274600; cv=none; b=Wwm/O1KUAJF/YZUE574ITeO8ZgsDUgD++Fo7TmULuiq8F3K5zzdjsQpUNwD03qXcPEgshDLjSCp2iWYWmv7o/YNwjR7p9IVKODEdZGyR2PnPre3hoApC9QO7S3vrlQ7v3iNx5ThmCBimoAlaIN8/1KXfMgAfsi5KNY5u2JsL3nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707274600; c=relaxed/simple;
	bh=n3McJjJh/WLCQm3zWRum7CJcJhpjLROkO/Uv6o5ddcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mq6/GASq5MIJnQfHAa6+8eoFZlu8R7JfIUVVYzOOnbVbRqHGlLK8Wvele075+tTO1k+5U3NsoEKIOS1LfMLCZy6OqzKIrAmB8Vh13O3CoR+agx4QHRwaeiabZ/EgoxQq8vA/OYPzJ9ICOnlU9a8o7LUcIjE6dEIS8nqm0z1SdWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ax1ywQJ2; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ax1ywQJ2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707274597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UNJ5lQuPym878v0er8vpFPNJuyo1lBu3+aim1D8jyPw=;
	b=Ax1ywQJ2cq7Mst1G9TvZ1jy/KZKCdB3wwM6nrmmh+8C3mADSEeaKp88+b5UpuJ3b2zJStx
	82Xd4FyhygMECo19HN9HAeuvg89PdmaT+GDfacbQd2wTVBvehT8dXl8W609P0J064UeBpB
	g8OaUrY/Ei8oRdgLnN1rl09/t1VGcfU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	linux-btrfs@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v3 2/7] overlayfs: Convert to super_set_uuid()
Date: Tue,  6 Feb 2024 21:56:16 -0500
Message-ID: <20240207025624.1019754-3-kent.overstreet@linux.dev>
In-Reply-To: <20240207025624.1019754-1-kent.overstreet@linux.dev>
References: <20240207025624.1019754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't want to be settingc sb->s_uuid directly anymore, as there's a
length field that also has to be set, and this conversion was not
completely trivial.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
---
 fs/overlayfs/util.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0217094c23ea..f1f0ee9a9dff 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -760,13 +760,14 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 			 const struct path *upperpath)
 {
 	bool set = false;
+	uuid_t uuid;
 	int res;
 
 	/* Try to load existing persistent uuid */
-	res = ovl_path_getxattr(ofs, upperpath, OVL_XATTR_UUID, sb->s_uuid.b,
+	res = ovl_path_getxattr(ofs, upperpath, OVL_XATTR_UUID, uuid.b,
 				UUID_SIZE);
 	if (res == UUID_SIZE)
-		return true;
+		goto success;
 
 	if (res != -ENODATA)
 		goto fail;
@@ -794,14 +795,14 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 	}
 
 	/* Generate overlay instance uuid */
-	uuid_gen(&sb->s_uuid);
+	uuid_gen(&uuid);
 
 	/* Try to store persistent uuid */
 	set = true;
-	res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID, sb->s_uuid.b,
+	res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID, uuid.b,
 			   UUID_SIZE);
 	if (res == 0)
-		return true;
+		goto success;
 
 fail:
 	memset(sb->s_uuid.b, 0, UUID_SIZE);
@@ -809,6 +810,9 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 	pr_warn("failed to %s uuid (%pd2, err=%i); falling back to uuid=null.\n",
 		set ? "set" : "get", upperpath->dentry, res);
 	return false;
+success:
+	super_set_uuid(sb, uuid.b, sizeof(uuid));
+	return true;
 }
 
 bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
-- 
2.43.0

