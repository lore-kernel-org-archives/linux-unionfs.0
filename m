Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7357386435;
	Sun, 20 Sep 2026 20:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789936394; cv=none; b=uLGruf2/zRnjFzS++tXmuMa23np+qJeJvat2cZN6WHvCQ9Uv2bP/WqX3/gbyhUje/KTlxrdAUpN09USdxxCjInhO7Q4lcU6K/YHrhXr2+Bv8IGJV1ItQfW2n2cJqtl0TcelkHjYR48jj2lXJILDpZBzsIja57LmaUxqCl7odTfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789936394; c=relaxed/simple;
	bh=+Z6R4JPI0HfvrQX5YZUZQ8/tqSlpbk6OUkHn2GB+0Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFTNNYXvISmABejS+wSj2UczQy3O0NP4TJfGWcoVNPzscU0A6Kzkt1UBAhAFLuqL2FNRSe+rYCg6brCT2TGk/bpF8fX1G23e88ursvhDV+Xp/nG6tkIiuQPzP3OejaAf/HbqZOpIiFd7PCdHiZTsfsOt6xpRsHbF6TyHMPRrnYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=rDDRz09s; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="rDDRz09s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=MhjTpSlr5gmWChbZz2KA69jFx1VHVzTNspVHfVseYbQ=; b=rDDRz09sywPZ
	D7+iOI7sioRCgQuSPiaX7HNKGBRsMtyy2ukF++fxdyqBuLF4odjx3JkKvYCkm3lJ2k4ShzERiSCuy
	kaqT1zhyTPQL4FKtir/QRUVm5V+5UC11/YRrC8bySyLqD/eI+kjvheQ+qZpgNON4L8rwnfsQ+yAMx
	AGVXbYsuFVROdIvDb1fHlWztq2ii5RoQUrcU+LkOTu1hLmFsabzzFS6xM33UUsvJ7Nph1ql9TRLBQ
	XqPO6n0zvjpx0jm8DbsflbnMR75LkuKrC0JkIPPlkmalIMjy21cGp+4Zr4F8HkPedrgZlJgNC4pzm
	339rk3MW4JvnFgMQhOmonA==;
Received: from [151.115.150.205] (port=50122 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x8ODn-0000000BX7T-0Nsk;
	Sun, 20 Sep 2026 22:33:11 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2 2/3] selftests: overlayfs: reject handles for mixed lower idmaps
Date: Sun, 20 Sep 2026 20:32:39 +0000
Message-ID: <20260920203239.2876221-4-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Add an idmapped overlay test for two lower layers that share a backing
superblock but use different idmaps. Mount with index=on,nfs_export=on and
verify decodable handle requests fail with EOPNOTSUPP after overlayfs falls
back to nfs_export=off.

Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 .../filesystems/overlayfs/idmapped_mounts.c   | 98 ++++++++++++++++++-
 1 file changed, 94 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
index 44a75839f4ed..0e94bd464f1c 100644
--- a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
+++ b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
@@ -159,8 +159,16 @@ static int idmapped_layer_fd(const char *path, int nsid, int hostid, int range)
 	return fd_tree;
 }
 
-/* Overlay with a layer passed by fd (idmapped) plus a plain upper/work. */
-static int ovl_mount_lower_fd(const char *upper, const char *work, int fd_lower)
+static int layer_fd(const char *path)
+{
+	return sys_open_tree(AT_FDCWD, path,
+			     OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+}
+
+/* Overlay with lower layers passed by fd plus a plain upper/work. */
+static int ovl_mount_lower_fds(const char *upper, const char *work,
+			       int fd_lower1, int fd_lower2,
+			       const char *index, const char *nfs_export)
 {
 	int fsfd, ovl;
 
@@ -171,8 +179,19 @@ static int ovl_mount_lower_fd(const char *upper, const char *work, int fd_lower)
 	if (sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "source", "test", 0) ||
 	    sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "upperdir", upper, 0) ||
 	    sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "workdir", work, 0) ||
-	    sys_fsconfig(fsfd, FSCONFIG_SET_FD, "lowerdir+", NULL, fd_lower) ||
-	    sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0))
+	    sys_fsconfig(fsfd, FSCONFIG_SET_FD, "lowerdir+", NULL, fd_lower1))
+		goto err;
+	if (fd_lower2 >= 0 &&
+	    sys_fsconfig(fsfd, FSCONFIG_SET_FD, "lowerdir+", NULL, fd_lower2))
+		goto err;
+	if (index &&
+	    sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "index", index, 0))
+		goto err;
+	if (nfs_export &&
+	    sys_fsconfig(fsfd, FSCONFIG_SET_STRING, "nfs_export",
+			 nfs_export, 0))
+		goto err;
+	if (sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0))
 		goto err;
 
 	ovl = sys_fsmount(fsfd, 0, 0);
@@ -183,6 +202,23 @@ static int ovl_mount_lower_fd(const char *upper, const char *work, int fd_lower)
 	return -1;
 }
 
+static int ovl_mount_lower_fd(const char *upper, const char *work, int fd_lower)
+{
+	return ovl_mount_lower_fds(upper, work, fd_lower, -1, NULL, NULL);
+}
+
+static int setup_extra_layer(const char *base, const char *name)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "%s/%s", base, name);
+	if (mkdir(path, 0755) && errno != EEXIST)
+		return -1;
+	if (chown(path, ID_HOST, ID_HOST))
+		return -1;
+	return 0;
+}
+
 /*
  * Mount an overlay inside user namespace @u1 (so the overlay sb's s_user_ns is
  * not the initial namespace) and idmap that overlay mount with @u2.  Runs in a
@@ -498,4 +534,58 @@ TEST_F(idmapped_overlay, nfs_export_handles)
 	EXPECT_EQ(close(ovl), 0);
 }
 
+/*
+ * Lower file handles cannot be decoded safely when two lower layers share a
+ * superblock but use different idmaps.  nfs_export should be disabled for that
+ * layout, so a normal decodable handle request must fail with EOPNOTSUPP.
+ */
+TEST_F(idmapped_overlay, nfs_export_same_sb_mixed_idmaps)
+{
+	char lower1[PATH_MAX], lower2[PATH_MAX], upper[PATH_MAX], work[PATH_MAX];
+	char path[PATH_MAX], mnt[128];
+	union {
+		struct file_handle fh;
+		char buf[sizeof(struct file_handle) + MAX_HANDLE_SZ];
+	} fhu;
+	struct file_handle *fh = &fhu.fh;
+	int fd_lower1, fd_lower2, ovl, mount_id;
+
+	if (!ovl_supported())
+		SKIP(return, "overlayfs not supported");
+
+	snprintf(lower1, sizeof(lower1), "%s/l", self->base);
+	snprintf(lower2, sizeof(lower2), "%s/l2", self->base);
+	snprintf(upper, sizeof(upper), "%s/u", self->base);
+	snprintf(work, sizeof(work), "%s/w", self->base);
+	ASSERT_EQ(setup_extra_layer(self->base, "l2"), 0);
+
+	snprintf(path, sizeof(path), "%s/l2/file", self->base);
+	ASSERT_EQ(mknod(path, S_IFREG | 0644, 0), 0);
+	ASSERT_EQ(chown(path, ID_HOST + 7, ID_HOST + 7), 0);
+
+	fd_lower1 = idmapped_layer_fd(lower1, ID_HOST, ID_NS, ID_RANGE);
+	ASSERT_GE(fd_lower1, 0);
+	fd_lower2 = layer_fd(lower2);
+	ASSERT_GE(fd_lower2, 0);
+
+	ovl = ovl_mount_lower_fds(upper, work, fd_lower1, fd_lower2, "on", "on");
+	if (ovl < 0)
+		SKIP(return, "overlayfs nfs_export not supported");
+	EXPECT_EQ(close(fd_lower1), 0);
+	EXPECT_EQ(close(fd_lower2), 0);
+
+	snprintf(mnt, sizeof(mnt), "%s/mnt", self->base);
+	ASSERT_EQ(mkdir(mnt, 0755), 0);
+	ASSERT_EQ(sys_move_mount(ovl, "", AT_FDCWD, mnt,
+				 MOVE_MOUNT_F_EMPTY_PATH), 0);
+
+	snprintf(path, sizeof(path), "%s/file", mnt);
+	fh->handle_bytes = MAX_HANDLE_SZ;
+	errno = 0;
+	EXPECT_EQ(name_to_handle_at(AT_FDCWD, path, fh, &mount_id, 0), -1);
+	EXPECT_EQ(errno, EOPNOTSUPP);
+
+	EXPECT_EQ(close(ovl), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3

