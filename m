Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE4377A9E
	for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 09:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792229327; cv=none; b=OYtoys8xZgowrDFVzadr0yoiq7kW+jFJYOmrJIimRZHe5NLHNWkO/ZGDCieDxtXKLJFaUiWkD6TZ7b/aHewWqzpDNTaxrIVAW5fZ1COVZaZxWM+TjMdhtcjww+LaP7HHYymAfSXhdYFvhoSk1q9gfX7EaoerFDmI1/oxdsJRm/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792229327; c=relaxed/simple;
	bh=uNSWk2DcH3LPZICBD746TFu+sNzj0B8D3y9K7VrQniM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PTYIhNUoHjm03vYrNRok31fYsAgbrVzWtVwP70kvlEJLCzyIQ7avU5FIreCVIcCX4HKKvsTsx8UQjHsr16cG/4ZF2bUE07Io7vmQNSFh6xG+NAZXVZnEQ28a+w/wqaa8hcW/h6+iyvF7kHrtJjREi/U9dxHDwt6gwaNfmS6E+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W/DpSdrX; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W/DpSdrX"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6afa651700eso777131a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Oct 2026 02:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792229323; x=1792834123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lRwoqnriejBBoRSldEqkxsXtNf0LoDQmOzWPLuj7UWI=;
        b=W/DpSdrX1DwWrYz3x8jACltcJWkVw/pPj6M+PTtqnLjq652IYJL6kr/8vlJoueO3V1
         SkAskxAwTkrSgbkisHC3m2vvmr3SkHs7hFl8H+LxfyTg7JuDKknsbnNZIkn450118G0B
         4UObjSIvqMjIv41tSU9ByKInGSowYbOmzAmutjsK3P3lvPgO/YwT4QzUXUFMV5C10UGS
         dobfV6fAWP0RQBCDTNohL1qj5GZX6u7zKsxvA/VwqHoDXTbkpGxFg0olA0xgZRHAm2Ar
         gm0/JE4LZiipbZdBFi9UWFZvvc96KRq+hrqtLb9i1ez7d3oI3zgyg7u79IEPA7fXNKuD
         dAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792229323; x=1792834123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lRwoqnriejBBoRSldEqkxsXtNf0LoDQmOzWPLuj7UWI=;
        b=dcYZNOH95XCGCLe0Wp9kwnq+4ZwK58NqTEr0gc20j82tvrY0PqPNpqpYOeLlnXBbBl
         i/0cks9kkBB/d0h1RhllMNVtt4xGXnW5sat8mzWjIgKxrzO7QQCLu0ek3yjvVTKEP6Pm
         JcX+de6XDBMDgxnUrifPfDOrXRBQpnuk9wvjJeey3V2ESmq8DqS+7NobwGC+Uf7nHX52
         FYYUl2DyR72FT4esHCuXt+bRjdPEWVvrNJOvV+PFWBuPnZART6H9vpWOvjUsns5WoHEB
         6pV6SdOn0HYFdhVqlHN1gZg/lFH5lbZIiYXkoJi6xJreXZ1rhSaj1zbvK7suGd2PV5V4
         4SeA==
X-Forwarded-Encrypted: i=1; AKwUvBwq7Uk5fePKIY17g9ooIVXcQj3um3mza4m46J2FDv6F9gs5gr4v3n5LchvMUjswPADr9jjeAqWmxff7O1Dr@vger.kernel.org
X-Gm-Message-State: AFq9FYKWt6XrE40PBHJ3XtIu/wiuc/whsKD7RjaRPkpSnDYSQI8GH3MM
	tNa/gplobgd/s6KzCS4eQEncTJw+DphjfPhxJhyJ8z/+oJgIGLgNlwJ0
X-Gm-Gg: AYBFou3dYFAEKtxTyptdEM8XPkdpXIUKG7/meRvP8v04uV+Gxy9sMyVbUkLB7ZRAUdU
	Tn/NfG0yAohlfic1x5fFbJZMe0L7qJwVxkgjkc1lh0Bj3k0YGPEvkWQ+2O0YIgzf92uyTqBVU1u
	MJ7DBOVFI1RVkgnvuWxShzE8x1VIUurL1fKGzC9JNz3nhW4HGZDGuPYDVz4rJ466aZKosiLy+qQ
	PeK6LGWjyNAT8Btf71sORiJ0krpPc8QXrdLnvwg9Zl8uaU+1UVqBKfFzlyfa8psgdI0zStBZPQB
	2/O1qKLTSdXFTUyJoNyEFz5H4LIN2gIz1EPV2Q68j06Qpx7jSi+50mtRDrsW7sOvZcEFu8LCMrS
	9eS+L33rvdeXZ9IQEBRFFMEt0OQP+RgroHwNa2s3EmVL8+ppH0Z1nMYEk8F//gESdFuiOBU4Zu5
	zlzJ87oy7RuvbK5xuAC4H+zyk9wIr/vfsRX88wnYMGNNZckMDIBp+IhZ/Wx+gr+HXi5+10Pr1H7
	edQCEukSvKvlXGlgf9Y8xtdaQ==
X-Received: by 2002:a17:906:9c96:b0:c40:5de7:33cc with SMTP id a640c23a62f3a-c419f706de3mr150385666b.36.1792229322377;
        Sat, 17 Oct 2026 02:28:42 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c409239b3acsm164011366b.86.2026.10.17.02.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 02:28:41 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2] src/vfs: skip whiteout-device fixtures on overlayfs
Date: Sat, 17 Oct 2026 11:28:40 +0200
Message-ID: <20261017092841.2364286-1-amir73il@gmail.com>
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

