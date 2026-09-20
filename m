Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5B38A299;
	Sun, 20 Sep 2026 20:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789936394; cv=none; b=eZS3GJHGcR9t+IYVqS4Om0cDZ9zulQlOEHiSsBC0+5bXRGgd3g/9wQ0kwIjJyaz5+84yD3UphDnqhZXn0IoTa8lbJYfG1Ll8mmunhxlnapqc2IlgzZXWhHmvP8WjS7pJjCRbRlnbqOvExLW5vTvMHqUZaZpcDOaIJTI2so9oiuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789936394; c=relaxed/simple;
	bh=Z/Dt8cvfGRnIXf6nNFWeW2ZqedX6xPyoZeBUpEJwk8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K71u1ULcTnAHSSPfQ6Mottkj8mPJQePd1C7eaBa+7yuKh7HxAYx6mHaL8tDyLgVCA7dlG4T6rCC9NGOMhfmArghsTRNISzf5TW6jdQof/YKf9I3MEEXNsEKAULyYtjXF0xIRFBJixyF+cA9q4sGu//S5YSlxPuWECTzviC4gFjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=W/wSXlLV; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="W/wSXlLV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=fYwd/oBcaSjxIlM0fBEuECJkcNn0BzAjYxEbToDhPhE=; b=W/wSXlLV7zyI
	Z6J/aaRn2pUUzk3BDld9zk5TxeaipK6OB5ookkbTp0AQKckscCe49GRSapoB9MPk5uAcZOqTOyTxj
	p7NM6JEoF0sP3ybuv76zVSD1Pjq2xe2vBGZWYI3aTQMgQVKC/54IyqVzyN/sLlf5fzRvHqNIXUwUK
	mkIJWJe8uzuoUF0CT+zdqo89dsrT5K4EzWjpGTtl6fEMECPszKX0O+ttCrOPB3hvYGCl34oA4rG3f
	rmHXuj6GbO7j9FvKqJfPahDRwa9jCr+kYEExteGOv91HAt9P/woJ2UBT3H5JfBjQ7E4Bq8SP5dv9n
	w6xFtkh2JVeHq46e1G9Oag==;
Received: from [151.115.150.205] (port=50122 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x8ODn-0000000BX7T-2SJH;
	Sun, 20 Sep 2026 22:33:11 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2 3/3] selftests: overlayfs: keep index copy up with mixed lower idmaps
Date: Sun, 20 Sep 2026 20:32:40 +0000
Message-ID: <20260920203239.2876221-5-Jeremy.Jean@oss.cyber.gouv.fr>
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

Add a copy-up test for mixed-idmap lower layers with
index=on,nfs_export=off.

Write through one hardlink alias and read through the other.
Check that both aliases still point to the same copied-up inode.
Check that the copied-up inode keeps the expected mapped owner.

Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 .../filesystems/overlayfs/idmapped_mounts.c   | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
index 0e94bd464f1c..ae99698c280a 100644
--- a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
+++ b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
@@ -219,6 +219,42 @@ static int setup_extra_layer(const char *base, const char *name)
 	return 0;
 }
 
+static int write_path(const char *path, const char *buf)
+{
+	size_t len = strlen(buf);
+	int fd;
+
+	fd = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0644);
+	if (fd < 0)
+		return -1;
+	if (write(fd, buf, len) != len) {
+		close(fd);
+		return -1;
+	}
+	if (close(fd))
+		return -1;
+	return 0;
+}
+
+static int read_fd_contents(int dirfd, const char *name, char *buf, size_t len)
+{
+	ssize_t n;
+	int fd;
+
+	fd = openat(dirfd, name, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, len - 1);
+	if (n < 0) {
+		close(fd);
+		return -1;
+	}
+	buf[n] = '\0';
+	if (close(fd))
+		return -1;
+	return 0;
+}
+
 /*
  * Mount an overlay inside user namespace @u1 (so the overlay sb's s_user_ns is
  * not the initial namespace) and idmap that overlay mount with @u2.  Runs in a
@@ -588,4 +624,71 @@ TEST_F(idmapped_overlay, nfs_export_same_sb_mixed_idmaps)
 	EXPECT_EQ(close(ovl), 0);
 }
 
+/*
+ * index=on without nfs_export still preserves lower hardlinks on copy up when
+ * same-superblock lower layers use different idmaps.  The copied-up alias must
+ * keep the same contents, inode identity, and owner as the path-selected lower.
+ */
+TEST_F(idmapped_overlay, index_copy_up_same_sb_mixed_idmaps)
+{
+	static const char lower_data[] = "lower\n";
+	static const char upper_data[] = "upper\n";
+	char lower1[PATH_MAX], lower2[PATH_MAX], upper[PATH_MAX], work[PATH_MAX];
+	char path[PATH_MAX], alias[PATH_MAX], buf[32];
+	struct stat st_file, st_alias, st_upper;
+	int fd_lower1, fd_lower2, ovl, fd;
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
+	snprintf(alias, sizeof(alias), "%s/l2/alias", self->base);
+	ASSERT_EQ(write_path(path, lower_data), 0);
+	ASSERT_EQ(chown(path, ID_HOST + 7, ID_HOST + 7), 0);
+	ASSERT_EQ(link(path, alias), 0);
+
+	fd_lower1 = idmapped_layer_fd(lower1, ID_HOST, ID_NS, ID_RANGE);
+	ASSERT_GE(fd_lower1, 0);
+	fd_lower2 = layer_fd(lower2);
+	ASSERT_GE(fd_lower2, 0);
+
+	ovl = ovl_mount_lower_fds(upper, work, fd_lower1, fd_lower2, "on", "off");
+	ASSERT_GE(ovl, 0);
+	EXPECT_EQ(close(fd_lower1), 0);
+	EXPECT_EQ(close(fd_lower2), 0);
+	ASSERT_EQ(ovl_idmap(ovl), 0);
+
+	fd = openat(ovl, "file", O_WRONLY | O_TRUNC);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, upper_data, sizeof(upper_data) - 1),
+		  sizeof(upper_data) - 1);
+	EXPECT_EQ(close(fd), 0);
+
+	ASSERT_EQ(read_fd_contents(ovl, "alias", buf, sizeof(buf)), 0);
+	EXPECT_STREQ(upper_data, buf);
+
+	ASSERT_EQ(fstatat(ovl, "file", &st_file, 0), 0);
+	ASSERT_EQ(fstatat(ovl, "alias", &st_alias, 0), 0);
+	EXPECT_EQ(st_file.st_ino, st_alias.st_ino);
+	EXPECT_EQ(st_file.st_nlink, 2);
+	EXPECT_EQ(st_alias.st_nlink, 2);
+	EXPECT_EQ(st_file.st_uid, ID_NS + 7);
+	EXPECT_EQ(st_file.st_gid, ID_NS + 7);
+	EXPECT_EQ(st_alias.st_uid, ID_NS + 7);
+	EXPECT_EQ(st_alias.st_gid, ID_NS + 7);
+
+	snprintf(path, sizeof(path), "%s/u/file", self->base);
+	ASSERT_EQ(stat(path, &st_upper), 0);
+	EXPECT_EQ(st_upper.st_uid, ID_HOST + 7);
+	EXPECT_EQ(st_upper.st_gid, ID_HOST + 7);
+
+	EXPECT_EQ(close(ovl), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3

