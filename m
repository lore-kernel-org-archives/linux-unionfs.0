Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968063F44F5;
	Mon, 15 Jun 2026 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529621; cv=none; b=XQhC3mLUckQcAD2o7JF0H8pReI0kXQt+UX+PqLoy1UevLL69fof93XxNNHjhRKZcWI9lFeQFHZpYragDyBtdAotld2L1JFuiPZjMzs1U4/HeBjnCBJiEjeTf39Ae1nNsrJ1vqp7gVkDvnRzqxm2OiTjo5O6zsNdDdy+bpyd4MIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529621; c=relaxed/simple;
	bh=zNI3HfIa56+66d21HxRZLqXOxBtJhnK9/z2XkIzyCrI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HlA17gQQwgge6U32Z2amcIQCBlCHJihw756RMZA/danpK074hQ+WktZKpvlEZhJakMc0J8r+7hhlM0n29BsZwG2gvKerDvWu0ViJbcfHyyywxhsFy8B+IBVxCgkwuW7v1hSEr8v8Q6o7P9QtQkz39j/YoXwfPbJfk2jtBYjany0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MieC8pkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MieC8pkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC8C1F000E9;
	Mon, 15 Jun 2026 13:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529619;
	bh=op1Dt+/SV25Phb4fS+96TnXVhsYUlXnrqvX28Sz+HCQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MieC8pkNTFY9zIJQoa3rdzwU+7xgW7xcN9XmbJ4SUKO7JQ8yCWweSsU1LsuZ0yzBI
	 8Ov9oqUlkyl6CQmb9ZtMmmLx+VGGitN/BthejOk8+OoPkchXPcqax+0GcdTacZ7ipo
	 bX4EsMlSqszal7XJGUmsAYrqKtnTMNLHsZUgx9pavhf6z+SCvsWVGRhkGQObeWIldu
	 7WmxlxuOi/I0sv2OII0YlQIfR0Wg/IfJbpfUAM4nwlvgJiuiRDm7h8xneYgKU1Dz53
	 bzIifj68PrMl3FGhvdoau4KCmBPS4J7DYWm0ThlECuM8bTPVku4deExsCt2PFrS7PN
	 ZQCvgczEwey+g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:51 +0200
Subject: [PATCH 02/10] ovl: handle idmapped mounts in ovl_permission()
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-2-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=1427; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zNI3HfIa56+66d21HxRZLqXOxBtJhnK9/z2XkIzyCrI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+G5aDE18Cvf1a2xr9i0vggdrTAPY9NJ/lfItNJe6
 syMI7NUO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaiKs/I8ODm/UruiIXFKj9T
 GbZMnl0+/UTytUObDCoOpHyQ4S29J8PIcK3O58JinQM/e8/L+s+X4Dg8P7T5c6VPJo/Q34jsW70
 GXAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

When the overlay mount is idmapped, the permission check on the overlay
inode must account for the mount's idmapping.  Use the struct mnt_idmap
passed in by the VFS instead of the hardcoded &nop_mnt_idmap when
checking the overlay inode against the caller's credentials.

The second check, which verifies that the mounter may access the
underlying real inode, continues to use the real layer's idmap
mnt_idmap(realpath.mnt) under the mounter's credentials and is
deliberately left unchanged.  The overlay mount idmap only affects how
the caller views the overlay inode, not the mounter's access to the
layers, so it cannot widen access to the real files.

No functional change until FS_ALLOW_IDMAP is set on ovl_fs_type; until
then the overlay mount idmap is always &nop_mnt_idmap.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00c69707bda9..f59db57dfd55 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -306,7 +306,7 @@ int ovl_permission(struct mnt_idmap *idmap,
 	 * Check overlay inode with the creds of task and underlying inode
 	 * with creds of mounter
 	 */
-	err = generic_permission(&nop_mnt_idmap, inode, mask);
+	err = generic_permission(idmap, inode, mask);
 	if (err)
 		return err;
 

-- 
2.47.3

