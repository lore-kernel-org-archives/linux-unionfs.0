Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A31C345EDC
	for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 09:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792228955; cv=none; b=g8tCh8IMhp2LhkiqQcYzvwqYHPNpK6/77EP4QgDcLZkTtZFTvXyxVF9AZg+M6wtd5aT65vEe+mYPBrLOdADCi5+o5z478uYuf7FPdS7FOMKZCLMLZEATVBvzuv91JFSy0ZPe/3enbmYPiNd/+sGdtoy+bZo87NpCxSg4k9yEmOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792228955; c=relaxed/simple;
	bh=uNSWk2DcH3LPZICBD746TFu+sNzj0B8D3y9K7VrQniM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lDEM0gfNDUB8HAXaXEcC5+mkh9RCT19PgEo7P9rNzsHIedT8HvVkRQZ8En4xls95Ot/IgXqI5bEDJ+IwxeZNB2yCxG3GSPLI79zM/n1n8hrl/cfQlRKte7FyB6aCVCDNb3GG65LdNrFXfXbZeU2x4zDW+rGxFpT9OP19HHD6Ftk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tN8+rCNv; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tN8+rCNv"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c169ae1cb26so311108366b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 02:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792228951; x=1792833751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lRwoqnriejBBoRSldEqkxsXtNf0LoDQmOzWPLuj7UWI=;
        b=tN8+rCNvR9IrrV59N9T800x962aj39WN7iC+FWrtsRLMAPQYBQ3QASrsAlLFsKjfwq
         wn/GPFvbNxS03u7eUcu3SFv44bVSgiWfN9hb+6OzRIzEmyf6Dy8lHiQsoM8RpJkcHnry
         9U2RW/biJiymTViof1hy8NggFuVD97IL6/N8RoUhBhYGQ2CyJuLiKCPE/5FmTXh8dfFl
         RRd62JS92Sag9WiYbItfzDAdD9xR17lHzTc85l+at3p/PmxRnwK4xznkMeev78e8HFSc
         j0ot/iDTuoTw4XuogM/UqGV+rP4RfXQvBVH3GvMRFxBiexper1kS0Q3xJZfrO9+CP1ZA
         OK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792228951; x=1792833751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lRwoqnriejBBoRSldEqkxsXtNf0LoDQmOzWPLuj7UWI=;
        b=xN7zG96nj/XH/NTL6yBCJh5aAKAMOtQbj+QudlV9YxHmNnUecHwU902xXNPZAL2JJc
         Sk7o+NW7+Wg1QentRC7nHDVaTJ27FUi30RYp5jz+RXLDbRrQm6aLrrpM34YylYIPKYwk
         4aa4SZ2Tirt83CYQhQGctWLaozrDY5FkB4t+SYlxXCerCaydo0JS0sbeQdDZbKAKNhbR
         Sg+4ngcCHEDTuDUBy3AEjWqLNHvrdIVwrseMTASyacFSp6GzW6ARaf9CHmsgIyhsTmkc
         2Kwdlv6PGPcZL+wa8dzUYYVfwAl7wPQQNHCc4zTCpvVI0FGHETtodWcCl7yU5/Cocd8C
         5gVg==
X-Forwarded-Encrypted: i=1; AKwUvBwxNDdQvaP3V6cQgZx6Pj7qBAtBCyWrMedAto96S1F3G1P+NY9xeoWKmPjeJWKBmTfWIMHGMMqJYc9UId3U@vger.kernel.org
X-Gm-Message-State: AFq9FYKFqkKbS0/8kobvcMEnl9rNmSC6qwUrpHt2oHtkefJYj+qFBfll
	5HuH18KDC14RixQDLLCeS3ZW6EtZUkEyZ6RhySD+sDk/me9rEp6BYejs
X-Gm-Gg: AYBFou1KfeXUWXzyMn1l5vSRENeaggsy7mq1lpnHR//d+tAL8bQZ67I4uWFkz9LF2rc
	u3U6NukM0sYPqd6iMpzB60bF36lA4IYv9L26A3/MSYv5ggAEsfB5Sw1ebaz9mA/8eadkIf1Wt3O
	ho44b6YONjqYKCNptzcftW4UE20no7g4vZ7hfYOsIGtBIa2xJbQv1XTBm0q0QbTrWpP9Q4NkSG+
	JiQmczlobnqHPcQ+kN5almmYOmX4l1iqjFLHZS4JFYx37heP9kVIjwwpaerJ4pyP+ShRiMDPWDm
	TTmC85k9NAqlconKFGltwqbgXuWsAKbfTaSnW0Nk7AmsKh8PINJPB1/u4ZNHaiwvzj6FbkXBSgw
	GYo5EwqlB8VKJ2HhXJRBp+PlLFJNSvtLu/HJ34AXtFHVbCop8ffZhDLhY2VLGI2ZZN28XELl9Jm
	tOd/xCFh2EIS60C/G2OBihGZh+2pBTYGQ25jvkmUDvNbACHNn2RqXhY25m2vJQPJXtrvAp831Vl
	frNvAWLcOL8sHzGsNfpUOOP8A==
X-Received: by 2002:a17:906:99c2:b0:c41:825d:ed8c with SMTP id a640c23a62f3a-c41825dfa20mr182468866b.26.1792228951225;
        Sat, 17 Oct 2026 02:22:31 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40918c6e6asm156844966b.53.2026.10.17.02.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 02:22:30 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2] src/vfs: skip whiteout-device fixtures on overlayfs
Date: Sat, 17 Oct 2026 11:22:29 +0200
Message-ID: <20261017092229.2363746-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

The idmapped mount tests create a whiteout device,
mknod(S_IFCHR, makedev(0, 0)), as a fixture: a whiteout device is the
only character device an unprivileged caller may create, since it is
exempt from the CAP_MKNOD check. overlayfs reserves a 0:0 character
device as its on-disk whiteout marker, so ovl_mknod() returns -EPERM
and the fixture cannot be created, failing generic/633, generic/696 and
generic/697 on overlayfs.

Add a whiteout_device_supported() helper and skip the whiteout-device
fixtures and the checks that depend on them on overlayfs. The
makedev(5, 1) "creation must fail" probes are unaffected and keep
running. No-op on every other filesystem.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes since v1 [1]:
- Patch "probe O_TMPFILE support..." already merged
- Repalce is_overlayfs() probe with whiteout_device_supported()

[1] https://lore.kernel.org/linux-unionfs/20260615-overlay-idmapped-vfstest-v1-0-c6b3b2228092@kernel.org/

 src/vfs/idmapped-mounts.c | 154 ++++++++++++++++++++------------------
 src/vfs/utils.c           |  25 +++++++
 src/vfs/utils.h           |   1 +
 3 files changed, 107 insertions(+), 73 deletions(-)

diff --git a/src/vfs/idmapped-mounts.c b/src/vfs/idmapped-mounts.c
index 3e1b6987..1cca86dc 100644
--- a/src/vfs/idmapped-mounts.c
+++ b/src/vfs/idmapped-mounts.c
@@ -432,6 +432,7 @@ out:
 
 int tcore_fsids_mapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, hardlink_target_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -534,7 +535,7 @@ int tcore_fsids_mapped(const struct vfstest_info *info)
 			die("failure: create");
 
 		/* create character device */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0)))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0)))
 			die("failure: create");
 
 		/* create symlink */
@@ -734,6 +735,7 @@ out:
 /* Validate that changing file ownership works correctly on idmapped mounts. */
 int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd1 = -EBADF, open_tree_fd2 = -EBADF;
 	struct mount_attr attr1 = {
@@ -763,7 +765,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 	}
 
 	/* create character device */
-	if (mknodat(info->t_dir1_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0))) {
+	if (whiteout_dev && mknodat(info->t_dir1_fd, CHRDEV1, S_IFCHR | 0644, makedev(0, 0))) {
 		log_stderr("failure: mknodat");
 		goto out;
 	}
@@ -824,7 +826,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -856,7 +858,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -911,7 +913,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -941,7 +943,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: fchownat");
 		goto out;
 	}
-	if (fchownat(info->t_dir1_fd, CHRDEV1, 2000, 2000, 0)) {
+	if (whiteout_dev && fchownat(info->t_dir1_fd, CHRDEV1, 2000, 2000, 0)) {
 		log_stderr("failure: fchownat");
 		goto out;
 	}
@@ -971,7 +973,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 2000, 2000)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 2000, 2000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1001,7 +1003,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 12000, 12000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 12000, 12000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1031,7 +1033,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 32000, 32000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 32000, 32000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1063,7 +1065,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, HARDLINK1, 1000, 1000, 0))
 			die("failure: fchownat");
-		if (!fchownat(info->t_dir1_fd, CHRDEV1, 1000, 1000, 0))
+		if (whiteout_dev && !fchownat(info->t_dir1_fd, CHRDEV1, 1000, 1000, 0))
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1078,7 +1080,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd2, HARDLINK1, 1000, 1000, 0))
 			die("failure: fchownat");
-		if (!fchownat(open_tree_fd2, CHRDEV1, 1000, 1000, 0))
+		if (whiteout_dev && !fchownat(open_tree_fd2, CHRDEV1, 1000, 1000, 0))
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd2, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1093,7 +1095,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (fchownat(open_tree_fd1, HARDLINK1, 1000, 1000, 0))
 			die("failure: fchownat");
-		if (fchownat(open_tree_fd1, CHRDEV1, 1000, 1000, 0))
+		if (whiteout_dev && fchownat(open_tree_fd1, CHRDEV1, 1000, 1000, 0))
 			die("failure: fchownat");
 		if (fchownat(open_tree_fd1, SYMLINK1, 2000, 2000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1108,7 +1110,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1123,7 +1125,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1138,7 +1140,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, HARDLINK1, 0, 1000, 1000))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 1000, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 1000, 1000))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, SYMLINK1, AT_SYMLINK_NOFOLLOW, 2000, 2000))
 			die("failure: expected_uid_gid");
@@ -1166,7 +1168,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 1000, 1000)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 1000, 1000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1196,7 +1198,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 11000, 11000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 11000, 11000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1226,7 +1228,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 31000, 31000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 31000, 31000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1258,7 +1260,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, HARDLINK1, 0, 0, 0))
 			die("failure: fchownat");
-		if (!fchownat(info->t_dir1_fd, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !fchownat(info->t_dir1_fd, CHRDEV1, 0, 0, 0))
 			die("failure: fchownat");
 		if (!fchownat(info->t_dir1_fd, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1273,7 +1275,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd1, HARDLINK1, 0, 0, 0))
 			die("failure: fchownat");
-		if (!fchownat(open_tree_fd1, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !fchownat(open_tree_fd1, CHRDEV1, 0, 0, 0))
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd1, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1288,7 +1290,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: fchownat");
 		if (fchownat(open_tree_fd2, HARDLINK1, 0, 0, 0))
 			die("failure: fchownat");
-		if (fchownat(open_tree_fd2, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && fchownat(open_tree_fd2, CHRDEV1, 0, 0, 0))
 			die("failure: fchownat");
 		if (!fchownat(open_tree_fd2, SYMLINK1, 3000, 3000, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW))
 			die("failure: fchownat");
@@ -1303,7 +1305,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(info->t_dir1_fd, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1318,7 +1320,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, HARDLINK1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd1, SYMLINK1, AT_SYMLINK_NOFOLLOW, info->t_overflowuid, info->t_overflowgid))
 			die("failure: expected_uid_gid");
@@ -1333,7 +1335,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, HARDLINK1, 0, 0, 0))
 			die("failure: expected_uid_gid");
-		if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 0, 0))
 			die("failure: expected_uid_gid");
 		if (!expected_uid_gid(open_tree_fd2, SYMLINK1, AT_SYMLINK_NOFOLLOW, 2000, 2000))
 			die("failure: expected_uid_gid");
@@ -1361,7 +1363,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
+	if (whiteout_dev && !expected_uid_gid(info->t_dir1_fd, CHRDEV1, 0, 0, 0)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1391,7 +1393,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd1, CHRDEV1, 0, 10000, 10000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -1421,7 +1423,7 @@ int tcore_expected_uid_gid_idmapped_mounts(const struct vfstest_info *info)
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
-	if (!expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
+	if (whiteout_dev && !expected_uid_gid(open_tree_fd2, CHRDEV1, 0, 30000, 30000)) {
 		log_stderr("failure: expected_uid_gid");
 		goto out;
 	}
@@ -3781,6 +3783,7 @@ out:
 
 int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -3881,10 +3884,10 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		/*
@@ -3906,7 +3909,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -3918,7 +3921,7 @@ int tcore_setgid_create_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -3957,6 +3960,7 @@ out:
 
 int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -4051,10 +4055,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (!is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && !is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		if (!expected_uid_gid(open_tree_fd, FILE1, 0, 0, 0))
@@ -4066,7 +4070,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 0))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -4078,7 +4082,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -4168,10 +4172,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		/*
@@ -4193,7 +4197,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -4205,7 +4209,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -4293,10 +4297,10 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 			die("failure: is_setgid");
 
 		/* create a whiteout device via mknodat() vfs_mknod */
-		if (mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
+		if (whiteout_dev && mknodat(open_tree_fd, CHRDEV1, S_IFCHR | S_ISGID | S_IXGRP, 0))
 			die("failure: mknodat");
 
-		if (is_setgid(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && is_setgid(open_tree_fd, CHRDEV1, 0))
 			die("failure: is_setgid");
 
 		if (!expected_uid_gid(open_tree_fd, FILE1, 0, 0, 0))
@@ -4308,7 +4312,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 0))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 0))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -4320,7 +4324,7 @@ int tcore_setgid_create_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -7675,6 +7679,7 @@ out:
  */
 static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -7793,13 +7798,13 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
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
@@ -7821,7 +7826,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -7833,7 +7838,7 @@ static int setgid_create_umask_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -7889,6 +7894,7 @@ out:
  */
 static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -8028,13 +8034,13 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
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
@@ -8056,7 +8062,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8068,7 +8074,7 @@ static int setgid_create_umask_idmapped_in_userns(const struct vfstest_info *inf
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8123,6 +8129,7 @@ out:
  */
 static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -8248,13 +8255,13 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
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
@@ -8276,7 +8283,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8288,7 +8295,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8383,13 +8390,13 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
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
@@ -8411,7 +8418,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 10000, 10000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 10000, 10000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8423,7 +8430,7 @@ static int setgid_create_acl_idmapped(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8478,6 +8485,7 @@ out:
  */
 static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 {
+	bool whiteout_dev = whiteout_device_supported(info->t_dir1_fd);
 	int fret = -1;
 	int file1_fd = -EBADF, open_tree_fd = -EBADF;
 	struct mount_attr attr = {
@@ -8624,13 +8632,13 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
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
@@ -8652,7 +8660,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8664,7 +8672,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
@@ -8766,13 +8774,13 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
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
@@ -8794,7 +8802,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (!expected_uid_gid(open_tree_fd, FILE2, 0, 0, 1000))
 			die("failure: check ownership");
 
-		if (!expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
+		if (whiteout_dev && !expected_uid_gid(open_tree_fd, CHRDEV1, 0, 0, 1000))
 			die("failure: check ownership");
 
 		if (unlinkat(open_tree_fd, FILE1, 0))
@@ -8806,7 +8814,7 @@ static int setgid_create_acl_idmapped_in_userns(const struct vfstest_info *info)
 		if (unlinkat(open_tree_fd, FILE2, 0))
 			die("failure: delete");
 
-		if (unlinkat(open_tree_fd, CHRDEV1, 0))
+		if (whiteout_dev && unlinkat(open_tree_fd, CHRDEV1, 0))
 			die("failure: delete");
 
 		/* create tmpfile via filesystem tmpfile api */
diff --git a/src/vfs/utils.c b/src/vfs/utils.c
index 0b435afe..0094adc3 100644
--- a/src/vfs/utils.c
+++ b/src/vfs/utils.c
@@ -955,6 +955,31 @@ bool openat_tmpfile_supported(int dirfd)
 	return true;
 }
 
+/*
+ * A 0:0 character device is the only device node an unprivileged caller may
+ * create, so the idmapped mount tests use one as a fixture. overlayfs reserves
+ * that dev_t as its whiteout marker and ovl_mknod() rejects it with EPERM.
+ * Probe on the base mount as the filesystem owner so a filesystem that later
+ * allows the node keeps the coverage. Any error other than EPERM is reported.
+ */
+bool whiteout_device_supported(int dirfd)
+{
+	static const char name[] = ".whiteout_probe";
+
+	if (!mknodat(dirfd, name, S_IFCHR | 0644, makedev(0, 0))) {
+		if (unlinkat(dirfd, name, 0))
+			return log_errno(false, "failure: unlinkat");
+		return true;
+	}
+
+	if (errno == EPERM) {
+		errno = 0;
+		return false;
+	}
+
+	return log_errno(false, "failure: mknodat");
+}
+
 /*
  * There'll be scenarios where you'll want to see the attributes associated with
  * a directory tree during debugging or just to make sure things look correct.
diff --git a/src/vfs/utils.h b/src/vfs/utils.h
index c086885a..41b2f499 100644
--- a/src/vfs/utils.h
+++ b/src/vfs/utils.h
@@ -372,5 +372,6 @@ extern bool is_setgid(int dfd, const char *path, int flags);
 extern bool is_sticky(int dfd, const char *path, int flags);
 extern bool is_ixgrp(int dfd, const char *path, int flags);
 extern bool openat_tmpfile_supported(int dirfd);
+extern bool whiteout_device_supported(int dirfd);
 
 #endif /* __IDMAP_UTILS_H */
-- 
2.55.0

