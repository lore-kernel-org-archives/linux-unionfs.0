Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AD83AB46F;
	Mon, 15 Jun 2026 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529632; cv=none; b=ONM26xlOdlKd4JhbDIjEMPeL7I/D6Fr4jBG25BT+6tqo6WJzp+2wfgujGxpidEGUvOsNv2qO5p0uUgEbrc43vy0Ph/WvVUHV1KTsTEZr/85BNDrCHoBzyjrQTcCfqa9wXUa2ejexrWw8lQK+WcaM7ejLI/Nx6btcVrD4ZNTvzw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529632; c=relaxed/simple;
	bh=KMK/FibSGNbN6/2kTfZBl+a83bJmiMxzfqz+Zso7oxc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OucUHJ+PJJlOLSPuin3E0KZpSRMMrJQyQKeFsGHHOxCGsHB9NTS0OqX+09Dq0/pcfNxO1BPCuTBmZOycmWRRyrCHKxjOYP2nSNPnjRqFfF4C8smTuxW+cm8hXQQqbx7WeziiFJSke9t8l6h/GXvQXgqHOJMKNAqQsXRFt2ucQRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mejL2P57; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mejL2P57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547601F000E9;
	Mon, 15 Jun 2026 13:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781529631;
	bh=V5d/6yGZe5U3nteRlT9o/0r0bifFgzvvBlIJ0EaoFNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mejL2P57kO/VFJRgR4hlwJbnc6N266wHiLYvEY8W72tQR4G7x1b7Yhe7MxMHNINZv
	 j/XoetMNbNqsOmQKhMuzPV4/vaFhApn9Ao7hVrNyvS1EMOoX153NsC6VW0WkGxIsh0
	 OTOhEHdF+bXkORSuhuYqD5HmXxwy/VOoy50AoL9VqalKCI07xG+zi63ikU0ZTwu+6e
	 E+2CfY85ATYb8hH4E5GWiDhkuw6irtXZ9z9YoXw79IuDGDl6zzmEFd7Tch2eZJnvgf
	 URW0+9etD8bkQtQ6DGIhLNvZckxMEO/JLZpkFAkntDFyhoJSgp6/iQgNERBQ0OnRVZ
	 KGqgR8cBz2scA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 15:19:57 +0200
Subject: [PATCH 08/10] selftests/filesystems/overlayfs: fix
 set_layers_via_fds link error
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-work-idmapped-overlayfs-v1-8-7381632aa402@kernel.org>
References: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
In-Reply-To: <20260615-work-idmapped-overlayfs-v1-0-7381632aa402@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=3078; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KMK/FibSGNbN6/2kTfZBl+a83bJmiMxzfqz+Zso7oxc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTp/+GtjYp72nd74nyDFdvs/p0x4no5tdX9T1zd0mnJ/
 /cLecxM6ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhISivD/6pD1tWsT+/yatxY
 1agYbGNmL7VBu+nAI499opv62yMXiTH8M3z7Q6qa7ZvA5rZCl39a/DvmTOhYV825a2G6MbOzGEM
 zAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

set_layers_via_fds.c calls open_tree() directly, but that wrapper is
not provided by all C libraries, so the test fails to link with
"undefined reference to open_tree" on toolchains without it.

Use sys_open_tree() from ../wrappers.h, the syscall wrapper already
used for move_mount(), fsmount() and friends here.  This is also a
prerequisite for building the new idmapped_mounts test added to this
directory.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/filesystems/overlayfs/set_layers_via_fds.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
index 3c0b93183348..7a293544233d 100644
--- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
+++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
@@ -624,7 +624,7 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 
 	ASSERT_EQ(sys_move_mount(fd_tmpfs, "", -EBADF, "/set_layers_via_fds_tmpfs", MOVE_MOUNT_F_EMPTY_PATH), 0);
 
-	fd_tmp = open_tree(fd_tmpfs, "u", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	fd_tmp = sys_open_tree(fd_tmpfs, "u", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(fd_tmp, 0);
 
 	layer_fds[0] = openat(fd_tmp, "upper", O_CLOEXEC | O_DIRECTORY | O_PATH);
@@ -633,25 +633,25 @@ TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
 	layer_fds[1] = openat(fd_tmp, "work", O_CLOEXEC | O_DIRECTORY | O_PATH);
 	ASSERT_GE(layer_fds[1], 0);
 
-	layer_fds[2] = open_tree(fd_tmpfs, "l1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[2] = sys_open_tree(fd_tmpfs, "l1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[2], 0);
 
-	layer_fds[3] = open_tree(fd_tmpfs, "l2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[3] = sys_open_tree(fd_tmpfs, "l2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[3], 0);
 
-	layer_fds[4] = open_tree(fd_tmpfs, "l3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[4] = sys_open_tree(fd_tmpfs, "l3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[4], 0);
 
-	layer_fds[5] = open_tree(fd_tmpfs, "l4", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[5] = sys_open_tree(fd_tmpfs, "l4", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[5], 0);
 
-	layer_fds[6] = open_tree(fd_tmpfs, "d1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[6] = sys_open_tree(fd_tmpfs, "d1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[6], 0);
 
-	layer_fds[7] = open_tree(fd_tmpfs, "d2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[7] = sys_open_tree(fd_tmpfs, "d2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[7], 0);
 
-	layer_fds[8] = open_tree(fd_tmpfs, "d3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	layer_fds[8] = sys_open_tree(fd_tmpfs, "d3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
 	ASSERT_GE(layer_fds[8], 0);
 
 	ASSERT_EQ(close(fd_tmpfs), 0);

-- 
2.47.3

