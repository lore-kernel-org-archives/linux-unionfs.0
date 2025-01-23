Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1047192B69
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 19:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737660004; cv=none; b=NxJU6FcoXodrLEN97jo5W5cxC7ENjpLJ0+ct4ssStvfKRjUBqIHeLcEBA+nV4ZSuK6iCd0Bj8z1OzKMGhlwmF57ZuViQYz7Ghu08BVS7Xu7BpR7MO97hsWPbyKlUCh9jIK5Nnam4168uzIKoIBidAN2lWtnKMgCh9t4xNvK4Ca0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737660004; c=relaxed/simple;
	bh=Y4/RXfn1Jtp3rTKsWKfn4Yt78NwBpJAlGFaeXbm+cQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gujU1YfG6GHwH1IKLhXy9uEMtADtgJWsPse11JQuTEtQ9q5sTRaWq/ZT4SlJ7tZ6M/cSOvG5Ea27ZMToWXd+ix61lY/LGN5GHB8QZJooFxejUoK3bA76Sl8y9LcHfhSwB2ngcwwaYejjkikkgJPr2g/iv+IsmEMjWq5Rj8hL/CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4tzeuwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4tzeuwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF88C4CEE1;
	Thu, 23 Jan 2025 19:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737660004;
	bh=Y4/RXfn1Jtp3rTKsWKfn4Yt78NwBpJAlGFaeXbm+cQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4tzeuwe6RKZua0I0VXiQYCELFyvwUyGgMnqci7BzvHqYO1j193T2XPGHkVP0YHtY
	 CgfCabG68Xa+tCpGdSnF7RcdNJUtSUu8SJfMPWsOix24B1XhL9tbA6yNiZC3Rp3BRk
	 gsIFHatVhObqYulgq2TEZ1ycKajiVGg0EZmNkot63Gw4/5tZQQZeQvWyduWPy4JBC6
	 jWLwO4AA7j4mXz5fGqJtDshZV5tYUD1gpdVABuaY7BwlzU1+WnEoh0G3AlfMpdbo14
	 n5bruL1ANZZdt+x4cCV+wm0kZ15/j5xZZiS+IIfxtJQecTjbawdXtINswPm2I0JENy
	 0rgY3sbtqpFwQ==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	overlayfs <linux-unionfs@vger.kernel.org>,
	Mike Baynton <mike@mbaynton.com>
Subject: [RFC PATCH 1/2] fs: allow detached mounts in clone_private_mount()
Date: Thu, 23 Jan 2025 20:19:48 +0100
Message-ID: <20250123-avancieren-erfreuen-3d61f6588fdd@brauner>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
References: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4761; i=brauner@kernel.org; h=from:subject:message-id; bh=Y4/RXfn1Jtp3rTKsWKfn4Yt78NwBpJAlGFaeXbm+cQA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRPmhZ2ckJdBOdr7neR8iIK2wsNGpslZ278pmwz9YvEv n61RssdHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNpZ2BkeHnoj4Swgs6bOm/L 3W2J370+de08843f+fPBHxu2XGJkX8bwh3+Gt/H/R5kBT0+q72s0PBcrLbsx8qWqx5nKZ7Orfq0 7wgkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

In container workloads idmapped mounts are often used as layers for
overlayfs. Recently I added the ability to specify layers in overlayfs
as file descriptors instead of path names. It should be possible to
simply use the detached mounts directly when specifying layers instead
of having to attach them beforehand. They are discarded after overlayfs
is mounted anyway so it's pointless system calls for userspace and
pointless locking for the kernel.

This just recently come up again in [1]. So enable clone_private_mount()
to use detached mounts directly. Following conditions must be met:

- Provided path must be the root of a detached mount tree.
- Provided path may not create mount namespace loops.
- Provided path must be mounted.

It would be possible to be stricter and require that the caller must
have CAP_SYS_ADMIN in the owning user namespace of the anonymous mount
namespace but since this restriction isn't enforced for move_mount()
there's no point in enforcing it for clone_private_mount().

Link: https://lore.kernel.org/r/fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com [1]
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/namespace.c | 78 ++++++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4013fbac354a..3985a695d373 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2287,6 +2287,28 @@ bool has_locked_children(struct mount *mnt, struct dentry *dentry)
 	return false;
 }
 
+/*
+ * Check that there aren't references to earlier/same mount namespaces in the
+ * specified subtree.  Such references can act as pins for mount namespaces
+ * that aren't checked by the mount-cycle checking code, thereby allowing
+ * cycles to be made.
+ */
+static bool check_for_nsfs_mounts(struct mount *subtree)
+{
+	struct mount *p;
+	bool ret = false;
+
+	lock_mount_hash();
+	for (p = subtree; p; p = next_mnt(p, subtree))
+		if (mnt_ns_loop(p->mnt.mnt_root))
+			goto out;
+
+	ret = true;
+out:
+	unlock_mount_hash();
+	return ret;
+}
+
 /**
  * clone_private_mount - create a private clone of a path
  * @path: path to clone
@@ -2295,6 +2317,8 @@ bool has_locked_children(struct mount *mnt, struct dentry *dentry)
  * will not be attached anywhere in the namespace and will be private (i.e.
  * changes to the originating mount won't be propagated into this).
  *
+ * This assumes caller has called or done the equivalent of may_mount().
+ *
  * Release with mntput().
  */
 struct vfsmount *clone_private_mount(const struct path *path)
@@ -2302,30 +2326,36 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	struct mount *old_mnt = real_mount(path->mnt);
 	struct mount *new_mnt;
 
-	down_read(&namespace_sem);
+	scoped_guard(rwsem_read, &namespace_sem)
 	if (IS_MNT_UNBINDABLE(old_mnt))
-		goto invalid;
+		return ERR_PTR(-EINVAL);
+
+	if (mnt_has_parent(old_mnt)) {
+		if (!check_mnt(old_mnt))
+			return ERR_PTR(-EINVAL);
+	} else {
+		/* Make sure this isn't something purely kernel internal. */
+		if (!is_anon_ns(old_mnt->mnt_ns))
+			return ERR_PTR(-EINVAL);
 
-	if (!check_mnt(old_mnt))
-		goto invalid;
+		/* Make sure we don't create mount namespace loops. */
+		if (!check_for_nsfs_mounts(old_mnt))
+			return ERR_PTR(-EINVAL);
+
+		if (!path_mounted(path))
+			return ERR_PTR(-EINVAL);
+	}
 
 	if (has_locked_children(old_mnt, path->dentry))
-		goto invalid;
+		return ERR_PTR(-EINVAL);
 
 	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
-	up_read(&namespace_sem);
-
 	if (IS_ERR(new_mnt))
-		return ERR_CAST(new_mnt);
+		return ERR_PTR(-EINVAL);
 
 	/* Longterm mount to be removed by kern_unmount*() */
 	new_mnt->mnt_ns = MNT_NS_INTERNAL;
-
 	return &new_mnt->mnt;
-
-invalid:
-	up_read(&namespace_sem);
-	return ERR_PTR(-EINVAL);
 }
 EXPORT_SYMBOL_GPL(clone_private_mount);
 
@@ -3123,28 +3153,6 @@ static inline int tree_contains_unbindable(struct mount *mnt)
 	return 0;
 }
 
-/*
- * Check that there aren't references to earlier/same mount namespaces in the
- * specified subtree.  Such references can act as pins for mount namespaces
- * that aren't checked by the mount-cycle checking code, thereby allowing
- * cycles to be made.
- */
-static bool check_for_nsfs_mounts(struct mount *subtree)
-{
-	struct mount *p;
-	bool ret = false;
-
-	lock_mount_hash();
-	for (p = subtree; p; p = next_mnt(p, subtree))
-		if (mnt_ns_loop(p->mnt.mnt_root))
-			goto out;
-
-	ret = true;
-out:
-	unlock_mount_hash();
-	return ret;
-}
-
 static int do_set_group(struct path *from_path, struct path *to_path)
 {
 	struct mount *from, *to;
-- 
2.45.2

