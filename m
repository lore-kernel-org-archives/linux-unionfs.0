Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2900D15C15C
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 19:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737660009; cv=none; b=M3EPx5tcdD7svmm32qEJLGZdH3/MDqtpSxcFt9vY2wUhgV3KuPHK0g12m5mnG/rxPS96D0e9MywTiUeYZSOEmWOh9wtcN7P8b/GHd0clBCp1pRpUxUgx58ufrZE4vNONtqmz9dYSniHnM4N0SHRogGgh0B1bK0T2mvCdJLU5u3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737660009; c=relaxed/simple;
	bh=MdsjWymy9a6Ef1qq4BHZjoPn98MyfgJPoteE+msH6ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyCmw/gt6cy3ss7fRkt9ctfEIaZNRppQMzQ6vnouNnmnfTPycATU8mPG1V/hpf/40KdqRw7BPwQduL2umZUGfnPQ568FCYiVGQXbCR8e755yqhzxgWMlviO/2L5XE4Lv9qhPXwzwqznokWBTP7/k0IJO087XgRvRBBWTogoLXWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NxeaCa2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NxeaCa2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA30C4CED3;
	Thu, 23 Jan 2025 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737660009;
	bh=MdsjWymy9a6Ef1qq4BHZjoPn98MyfgJPoteE+msH6ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxeaCa2lzxspr3MHpFXLuTyMyyFaqrtz77V7VqGmLmqtgwhBcyAVcHvptjxTh9lrD
	 hv9eAkRybnjSHtalnTHEFBaeplUFAom4r2QFXTM7Ngl8fAQHOr5j+uV47gWCrUKEdl
	 PwaFRihDnVBhcvxIUb+m4dXaOb7r6W1fI4PIaqjSZ6o///N2MXgayv6OvOanoaMdZa
	 AllVDE050KBP3QzsdjDddv8v37OsVU3WpDOTrBylPvxTsQuUVFlVVV0XIwCT7K3sDb
	 R+CbxilGgGhnBwBXml11v0K+eGyAo5kwbQDP0CbZmOaeiR7Cnj28cBCOMNsiW3U2TA
	 x3ZgAeZ89gGnw==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	overlayfs <linux-unionfs@vger.kernel.org>,
	Mike Baynton <mike@mbaynton.com>
Subject: [RFC PATCH 2/2] selftests: add tests for using detached mount with overlayfs
Date: Thu, 23 Jan 2025 20:19:49 +0100
Message-ID: <20250123-erstbesteigung-angeeignet-1d30e64b7df2@brauner>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
References: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6241; i=brauner@kernel.org; h=from:subject:message-id; bh=MdsjWymy9a6Ef1qq4BHZjoPn98MyfgJPoteE+msH6ZA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRPmhbGwuV75ajeNat7N97ezDByO2Xls0jh9qWXom7B0 crJPXVaHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP52c/wP+w2z8mzAW2FfGzH 1xyVZZh+57WYc5vB9s+M+xdezuc6lcDIsE6k6Md68dPqT/vCiu8nuwh1HX51akp8h3dM8kzb9QU bOAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

Test that it is possible to use detached mounts as overlayfs layers.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 .../overlayfs/set_layers_via_fds.c            | 120 ++++++++++++++++++
 .../filesystems/overlayfs/wrappers.h          |  17 +++
 2 files changed, 137 insertions(+)

diff --git a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
index 1d0ae785a667..897e94a17543 100644
--- a/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
+++ b/tools/testing/selftests/filesystems/overlayfs/set_layers_via_fds.c
@@ -214,4 +214,124 @@ TEST_F(set_layers_via_fds, set_500_layers_via_fds)
 	ASSERT_EQ(close(fd_overlay), 0);
 }
 
+TEST_F(set_layers_via_fds, set_layers_via_detached_mount_fds)
+{
+	int fd_context, fd_tmpfs, fd_overlay;
+	int layer_fds[] = { [0 ... 8] = -EBADF };
+	bool layers_found[] = { [0 ... 8] =  false };
+	size_t len = 0;
+	char *line = NULL;
+	FILE *f_mountinfo;
+
+	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
+	ASSERT_EQ(sys_mount(NULL, "/", NULL, MS_SLAVE | MS_REC, NULL), 0);
+
+	fd_context = sys_fsopen("tmpfs", 0);
+	ASSERT_GE(fd_context, 0);
+
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0), 0);
+	fd_tmpfs = sys_fsmount(fd_context, 0, 0);
+	ASSERT_GE(fd_tmpfs, 0);
+	ASSERT_EQ(close(fd_context), 0);
+
+	ASSERT_EQ(mkdirat(fd_tmpfs, "w", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "u", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "l1", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "l2", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "l3", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "l4", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "d1", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "d2", 0755), 0);
+	ASSERT_EQ(mkdirat(fd_tmpfs, "d3", 0755), 0);
+
+	layer_fds[0] = open_tree(fd_tmpfs, "w", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[0], 0);
+
+	layer_fds[1] = open_tree(fd_tmpfs, "u", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[1], 0);
+
+	layer_fds[2] = open_tree(fd_tmpfs, "l1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[2], 0);
+
+	layer_fds[3] = open_tree(fd_tmpfs, "l2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[3], 0);
+
+	layer_fds[4] = open_tree(fd_tmpfs, "l3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[4], 0);
+
+	layer_fds[5] = open_tree(fd_tmpfs, "l4", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[5], 0);
+
+	layer_fds[6] = open_tree(fd_tmpfs, "d1", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[6], 0);
+
+	layer_fds[7] = open_tree(fd_tmpfs, "d2", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[7], 0);
+
+	layer_fds[8] = open_tree(fd_tmpfs, "d3", OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(layer_fds[8], 0);
+
+	ASSERT_EQ(close(fd_tmpfs), 0);
+
+	fd_context = sys_fsopen("overlay", 0);
+	ASSERT_GE(fd_context, 0);
+
+	ASSERT_NE(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "lowerdir", NULL, layer_fds[2]), 0);
+
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "workdir",   NULL, layer_fds[0]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "upperdir",  NULL, layer_fds[1]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "lowerdir+", NULL, layer_fds[2]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "lowerdir+", NULL, layer_fds[3]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "lowerdir+", NULL, layer_fds[4]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "lowerdir+", NULL, layer_fds[5]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "datadir+",  NULL, layer_fds[6]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "datadir+",  NULL, layer_fds[7]), 0);
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_FD, "datadir+",  NULL, layer_fds[8]), 0);
+
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_SET_STRING, "metacopy", "on", 0), 0);
+
+	ASSERT_EQ(sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0), 0);
+
+	fd_overlay = sys_fsmount(fd_context, 0, 0);
+	ASSERT_GE(fd_overlay, 0);
+
+	ASSERT_EQ(sys_move_mount(fd_overlay, "", -EBADF, "/set_layers_via_fds", MOVE_MOUNT_F_EMPTY_PATH), 0);
+
+	f_mountinfo = fopen("/proc/self/mountinfo", "r");
+	ASSERT_NE(f_mountinfo, NULL);
+
+	while (getline(&line, &len, f_mountinfo) != -1) {
+		char *haystack = line;
+
+		if (strstr(haystack, "workdir=/tmp/w"))
+			layers_found[0] = true;
+		if (strstr(haystack, "upperdir=/tmp/u"))
+			layers_found[1] = true;
+		if (strstr(haystack, "lowerdir+=/tmp/l1"))
+			layers_found[2] = true;
+		if (strstr(haystack, "lowerdir+=/tmp/l2"))
+			layers_found[3] = true;
+		if (strstr(haystack, "lowerdir+=/tmp/l3"))
+			layers_found[4] = true;
+		if (strstr(haystack, "lowerdir+=/tmp/l4"))
+			layers_found[5] = true;
+		if (strstr(haystack, "datadir+=/tmp/d1"))
+			layers_found[6] = true;
+		if (strstr(haystack, "datadir+=/tmp/d2"))
+			layers_found[7] = true;
+		if (strstr(haystack, "datadir+=/tmp/d3"))
+			layers_found[8] = true;
+	}
+	free(line);
+
+	for (int i = 0; i < ARRAY_SIZE(layer_fds); i++) {
+		ASSERT_EQ(layers_found[i], true);
+		ASSERT_EQ(close(layer_fds[i]), 0);
+	}
+
+	ASSERT_EQ(close(fd_context), 0);
+	ASSERT_EQ(close(fd_overlay), 0);
+	ASSERT_EQ(fclose(f_mountinfo), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/filesystems/overlayfs/wrappers.h b/tools/testing/selftests/filesystems/overlayfs/wrappers.h
index 071b95fd2ac0..c38bc48e0cfa 100644
--- a/tools/testing/selftests/filesystems/overlayfs/wrappers.h
+++ b/tools/testing/selftests/filesystems/overlayfs/wrappers.h
@@ -44,4 +44,21 @@ static inline int sys_move_mount(int from_dfd, const char *from_pathname,
 		       to_pathname, flags);
 }
 
+#ifndef OPEN_TREE_CLONE
+#define OPEN_TREE_CLONE 1
+#endif
+
+#ifndef OPEN_TREE_CLOEXEC
+#define OPEN_TREE_CLOEXEC O_CLOEXEC
+#endif
+
+#ifndef AT_RECURSIVE
+#define AT_RECURSIVE 0x8000
+#endif
+
+static inline int sys_open_tree(int dfd, const char *filename, unsigned int flags)
+{
+	return syscall(__NR_open_tree, dfd, filename, flags);
+}
+
 #endif
-- 
2.45.2

