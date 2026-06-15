Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9219E405C4C;
	Mon, 15 Jun 2026 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781537623; cv=none; b=Ige+GREmlcUpTWzC09TZ86sg/lwOq/UiXLAZ+nATI5hUvmkg9XfN3zIJH0CNNUWnJ+v0jwdebeWHugfwKjqe7/fliLnY232qtri/GY68Tmh8lCZdlCiC3jN2s6zNxoUvZZLOb0lbwtxJtQeSUtdQx9ENDHSO9nhklhMwRGN6x3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781537623; c=relaxed/simple;
	bh=quoZJuoDa0DFiAQ3H655/BDWveFMiCVqv1x/1n9pjyE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kUGpSx5jvdjz8cK79s0fsJk3yHcCrrMtdl8VzXQpEAhtlGO/K464ncOr2vT+ioUXFluvHmMm5PIrDijBZsf0F6NSaN8nH1vwSTRIwn56lpZ5zSdOzD+sV5bX4S9pTMO53hht0iMmhzZdXDJLznnbhhC2KNJWDaudBVCGFNjNzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1hLTdWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1hLTdWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE7E1F00A3D;
	Mon, 15 Jun 2026 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781537620;
	bh=t2AJrJAEjTCD+iGfesqZNBTi5yxoPOqpHP97cdovcgY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h1hLTdWZrRYce5XUL/ZR9M3uyMSYPzEVIoz/zYPt435/iLnN4JB4QsiWcEliR6XvG
	 2YchrWnfZinoW6n28/zTDxrDNsGxPDU24LqnSwvsl4cL49lV9p0PHYMJA+gaIzKbD4
	 x/sAcmSHJYV07BABHfh6eXKWAszSKlPRAiLn3ugphvJlNW1yv2qX8CfRJ+0sEedeDs
	 AYb4jqhj/C5acT24TA+ZmAT7SOROm0zBlyOWyrF+eerPcUC+IEoHv77YTwkdozff6s
	 JDheEedYjUQBU4oiOZgcwWKE8vp9RmIseRUSJx3Yj8+R9CUDae7HW/lOO1P5EVmjmA
	 rUxyET8ugvm1w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 15 Jun 2026 17:33:30 +0200
Subject: [PATCH 2/2] src/vfs: skip whiteout-device fixtures on overlayfs
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-overlay-idmapped-vfstest-v1-2-c6b3b2228092@kernel.org>
References: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
In-Reply-To: <20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Zorro Lang <zlang@kernel.org>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fstests@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f5839
X-Developer-Signature: v=1; a=openpgp-sha256; l=30824; i=brauner@kernel.org;
 h=from:subject:message-id; bh=quoZJuoDa0DFiAQ3H655/BDWveFMiCVqv1x/1n9pjyE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZSPuqh9Za1T16eDArJXHCjrA/plyJ4tqsGVdVdlbrx
 DtrnTraUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJEjzxl+s2te2XCskeWXisIr
 kaB/59rEcu72vUkxuRHv+mbWwYX/vBn+R04u6kx2ZuoItH6vsORp73xnLpnKEwvV3nDO+uL0Yt1
 rNgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The idmapped mount tests create a whiteout device,
mknod(S_IFCHR, makedev(0, 0)), as a fixture: a whiteout device is the
only character device an unprivileged caller may create, since it is
exempt from the CAP_MKNOD check. overlayfs reserves a 0:0 character
device as its on-disk whiteout marker, so ovl_mknod() returns -EPERM
and the fixture cannot be created, failing generic/633, generic/696 and
generic/697 on overlayfs.

Add an is_overlayfs() helper and skip the whiteout-device fixtures and
the checks that depend on them on overlayfs. The makedev(5, 1)
"creation must fail" probes are unaffected and keep running. No-op on
every other filesystem.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 src/vfs/idmapped-mounts.c | 154 ++++++++++++++++++++++++----------------------
 src/vfs/utils.c           |   5 ++
 src/vfs/utils.h           |   1 +
 3 files changed, 87 insertions(+), 73 deletions(-)

diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
index 8f8441c9..e3779655 100644
--- a/src/vfs/idmapped-mounts.c
+++ b/src/vfs/idmapped-mounts.c
@@ -433,6 +433,7 @@ out:
 
 int tcore_fsids_mapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, hardlink_target_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -535,7 +536,7 @@ int tcore_fsids_mapped(const struct vfstest_info *info)
 			die("failure: create");
 
 		/* create character device */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0)))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0)))
 			die("failure: create");
 
 		/* create symlink */
@@ -735,6 +736,7 @@ out:
 /* Validate that changing file ownership works correctly on idmapped mounts. */
 int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd1 = -EBADF, open_tree_fd2 = -EBADF;
 	struct mount_attr attr1 = {
@@ -764,7 +766,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 	}
 
 	/* create character device */
-	if (mknodat(info->t_dir1_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0))) {
+	if (whiteout_dev && mknodat(info->t_dir1_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0))) {
 		log_stderr("failure: mknodat");
 		goto out;
 	}
@@ -825,7 +827,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -857,7 +859,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -912,7 +914,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -942,7 +944,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: fchownat");
 		goto out;
 	}
-	if (fchownat(info->t_dir1_fd, CHRDEV1, 2000, 2000, 0)) {
+	if (whiteout_dev && fchownat(info->t_dir1_fd, CHRDEV1, 2000, 2000, 0)) {
 		log_stderr("failure: fchownat");
 		goto out;
 	}
@@ -972,7 +974,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 2000, 2000)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 2000, 2000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1002,7 +1004,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 12000, 12000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 12000, 12000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1032,7 +1034,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 32000, 32000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 32000, 32000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1064,7 +1066,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, HARDLINK1, 1000, 1000, 0))
 			die("failure: fchownat");
-		if (!fchownat(info->t_dir1_fd, CHRDEV1, 1000, 1000, 0))
+		if (whiteout_dev && !fchownat(info->t_dir1_fd, CHRDEV1, 1000, 1000, 0))
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1079,7 +1081,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd2, HARDLINK1, 1000, 1000, 0))
 			die("failure: fchownat");
-		if (!fchownat(open_tree_fd2, CHRDEV1, 1000, 1000, 0))
+		if (whiteout_dev && !fchownat(open_tree_fd2, CHRDEV1, 1000, 1000, 0))
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd2, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1094,7 +1096,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (fchownat(open_tree_fd1, HARDLINK1, 1000, 1000, 0))
 			die("failure: fchownat");
-		if (fchownat(open_tree_fd1, CHRDEV1, 1000, 1000, 0))
+		if (whiteout_dev && fchownat(open_tree_fd1, CHRDEV1, 1000, 1000, 0))
 			die("failure: fchownat");
 		if (fchownat(open_tree_fd1, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1109,7 +1111,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1124,7 +1126,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1139,7 +1141,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, HARDLINK1, 0, 1000, 1000))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 1000, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 1000, 1000))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, SYMLINK1, AT_SYMLINK_NOFOLLOW, 2000, 2000))
 			die("failure: expected_uid_gid");
@@ -1167,7 +1169,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 1000, 1000)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 1000, 1000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1197,7 +1199,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 11000, 11000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 11000, 11000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1227,7 +1229,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 31000, 31000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 31000, 31000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1259,7 +1261,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, HARDLINK1, 0, 0, 0))
 			die("failure: fchownat");
-		if (!fchownat(info->t_dir1_fd, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !fchownat(info->t_dir1_fd, CHRDEV1, 0, 0, 0))
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1274,7 +1276,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd1, HARDLINK1, 0, 0, 0))
 			die("failure: fchownat");
-		if (!fchownat(open_tree_fd1, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !fchownat(open_tree_fd1, CHRDEV1, 0, 0, 0))
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd1, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1289,7 +1291,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (fchownat(open_tree_fd2, HARDLINK1, 0, 0, 0))
 			die("failure: fchownat");
-		if (fchownat(open_tree_fd2, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && fchownat(open_tree_fd2, CHRDEV1, 0, 0, 0))
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd2, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1304,7 +1306,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1319,7 +1321,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1334,7 +1336,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, HARDLINK1, 0, 0, 0))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 0, 0))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, SYMLINK1, AT_SYMLINK_NOFOLLOW, 2000, 2000))
 			die("failure: expected_uid_gid");
@@ -1362,7 +1364,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1392,7 +1394,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1422,7 +1424,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -3782,6 +3784,7 @@ out:
 
 int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -3882,10 +3885,10 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		/*
@@ -3907,7 +3910,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -3919,7 +3922,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -3958,6 +3961,7 @@ out:
 
 int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -4052,10 +4056,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (!is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && !is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		if (!expected_uid_gid(open_tree_fd, FILE1, 0, 0, 0))
@@ -4067,7 +4071,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 0))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -4079,7 +4083,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -4169,10 +4173,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		/*
@@ -4194,7 +4198,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -4206,7 +4210,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -4294,10 +4298,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		if (!expected_uid_gid(open_tree_fd, FILE1, 0, 0, 0))
@@ -4309,7 +4313,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 0))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -4321,7 +4325,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -7676,6 +7680,7 @@ out:
  */
 static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -7794,13 +7799,13 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 			die("failure: is_ixgrp");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
-		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_ixgrp");
 
 		/*
@@ -7822,7 +7827,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -7834,7 +7839,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -7890,6 +7895,7 @@ out:
  */
 static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -8029,13 +8035,13 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
 			die("failure: is_ixgrp");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
-		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_ixgrp");
 
 		/*
@@ -8057,7 +8063,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8069,7 +8075,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8124,6 +8130,7 @@ out:
  */
 static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -8249,13 +8256,13 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 			die("failure: is_ixgrp");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
-		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_ixgrp");
 
 		/*
@@ -8277,7 +8284,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8289,7 +8296,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8384,13 +8391,13 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 			die("failure: is_ixgrp");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
-		if (!is_ixgrp(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && !is_ixgrp(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_ixgrp");
 
 		/*
@@ -8412,7 +8419,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8424,7 +8431,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8479,6 +8486,7 @@ out:
  */
 static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 {
+	bool whiteout_dev = !is_overlayfs(info->t_fstype);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -8625,13 +8633,13 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 			die("failure: is_ixgrp");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
-		if (is_ixgrp(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_ixgrp(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_ixgrp");
 
 		/*
@@ -8653,7 +8661,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8665,7 +8673,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8767,13 +8775,13 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (!is_ixgrp(open_tree_fd, FILE2, 0))
 			 die("failure: is_ixgrp");
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
-		if (!is_ixgrp(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && !is_ixgrp(open_tree_fd, CHRDEV1, 0))
 			 die("failure: is_ixgrp");
 
 		/*
@@ -8795,7 +8803,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8807,7 +8815,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
diff --git a/src/vfs/utils.c b/src/vfs/utils.c
index 0b435afe..9cdbeca6 100644
--- a/src/vfs/utils.c
+++ b/src/vfs/utils.c
@@ -742,6 +742,11 @@ static bool is_xfs(const char *fstype)
 	return enabled;
 }
 
+bool is_overlayfs(const char *fstype)
+{
+	return !strcmp(fstype, "overlay");
+}
+
 bool xfs_irix_sgid_inherit_enabled(const char *fstype)
 {
 	static int enabled = -1;
diff --git a/src/vfs/utils.h b/src/vfs/utils.h
index c086885a..70c4001d 100644
--- a/src/vfs/utils.h
+++ b/src/vfs/utils.h
@@ -372,5 +372,6 @@ extern bool is_setgid(int dfd, const char *path, int flags);
 extern bool is_sticky(int dfd, const char *path, int flags);
 extern bool is_ixgrp(int dfd, const char *path, int flags);
 extern bool openat_tmpfile_supported(int dirfd);
+extern bool is_overlayfs(const char *fstype);
 
 #endif /* __IDMAP_UTILS_H */

-- 
2.47.3

