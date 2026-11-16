Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794858155;
	b=1c8rvCLnZatm3S+b1nX6v/iQmhjrKmjKxBSlFtLMylvN+Pc28917sJL5XyNwZ62BGvoG
	 7L2zHUZYeSHIsdB31884nwvWASVxxCPf2MwEDeNdbND+YKWX2VOn4Ej+ftMeLupcXvpKU
	 WkBE/TkdYHwoa6y4QEoUgYG3FJlvMNsp0GUzEfBI3j+cAVe8SpO3LfklOTnvHrnHdWBNN
	 OvE599qmXRtIZlWjT4IF1m5lvL9hyZZthVJDfa1WSk96STY6Gdfdi3u3q6i/XGdZsScJC
	 SmyetGONcnSfAWlUGqoNGZ3zWNf7jnULMB2mCR5L5ME5cpfCic0Eu4TrZL8iOZ/FD8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794858155;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3I26m1ZKPLTjPvcX7e66pLAPs7pMaHA7M5eZgrT0FBw=;
	b=B3u4H+grsygyWBKyJ7T48xxt2uUNKqln65UWUxorcNBzEJbh5qabQMhZYqVR+33hXb57
	 5F7aXX17XnPGqNiGGogUAdVMYoOf4gT7Zf6jMI3iGXF2DlBHaMXxcpp7qTkkOeaA/uMVj
	 5JbRQ/Ys2O2pw6dN/Li9XH/Uxtht6lJt4EtJHjXpNQKB+7NITL464Gt35IQmW1oD45vyD
	 4h7Ky3Ho0PQNsV+fT0UU28j9D9hVj5vlLHxL1d8oT9JIlJmYD9VU7GleFjS1p3JagBEdn
	 TJIhuBkMfsDIbPAUPdCtAcgBenLn0ftzSTGmXChgVNYddue4rgSZPawHr+bw8tWxTwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qXpk2RTu;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EF6606A32A
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2026 19:42:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57EF6606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qXpk2RTu
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-490f38e9688so163611f8f.0
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Nov 2026 11:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794858154; x=1795462954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3I26m1ZKPLTjPvcX7e66pLAPs7pMaHA7M5eZgrT0FBw=;
        b=qXpk2RTuQatVkqGl/4ukj2niDuP7xReXALWCWwisqQwQqzo4Vf2AcQXNYTHeo/e3as
         Xp8ogURkEfgco/CkyKmA58PQZI2A+r7IJ04lEpDBGn7QP+nQzbomQo+WJUx0Z2XAbJGJ
         LBUua0zBhiNyUVi9o0GWXYtiBus06ONFSLFvsWE3Sh3pKEjDQZvR6kDnwO88SFjoGJZU
         FuMjhm+sZO0n9tIPDwVE36U+qgCxwhkzzHCMk69DbdI3cCGJzlngeKdLCT7mfX3Pkhet
         DJoqe7PnoBKXdzdT53U4uadDGtRM5zNR+5juOhEcBi442KbFe3Kuj1LBO4zUldL90WiX
         wKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858154; x=1795462954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3I26m1ZKPLTjPvcX7e66pLAPs7pMaHA7M5eZgrT0FBw=;
        b=T/TkGYoCdSXqx4oJ+A2oFYMae1pkTPV9xCGEIAkj+Ho+aqGABqznQ9aVbODdZLfxOw
         cnD0Uepl6oLnN9rrGS3PZnIFAIF4W3Eog+7wBOqmas4ZQsH4LXwn97Z4kWzFrCFKqfJ4
         QtuexKJtkIA8Xo3Afn83epKzxnMl0HY6tqOYN1yggkjV7NOyH2+Wmu+VlW8IbZRRHeUH
         qHyRu+KbydAhfyAxOjNbCgacIzsEDA2P8EtLT7ffNjDFMwWUYvo9rEqbLscLlcg3lrH8
         vrWdRpTHBYBedx3xHFrthXxtFU3kkcm/71X621suTzo41m8Oj1vDpk+6jT+fgu6wUTVy
         7ngA==
X-Forwarded-Encrypted: i=1; AL+hErEgl7aMI9lB4PQdXb/tl/s/ZNa3Z8CRFMgM40EPb3MWpq+No7EP60GggCQDXW/tJVOw3Sg28gSkfwez+f8Z@vger.kernel.org
X-Gm-Message-State: APuU4Z+E9Rnycr6yI0tQs3MpLnhXN71CCmI8xGhd9M2gf9G8q3H3KSS2
	z4dfCRhcEaeL1IvbjP/Z0BRH9ICfRyqdS8nsEZWtZw8MTsLhpqXy9tdU
X-Gm-Gg: AZFdTZepuAx7131u922AG4mPVkilW/rrXe86tyH26egA6xfmmj4WDw65EC1d/8fmR0i
	XTrAWqM41J+0umvJj1Tikk8FYZO8H5APeHcLJOL5DOUaMuOT43qhuitjuqLrE3E/E77QdZ2uRk6
	jbOI1N3/0yZ7fvBqwd1si3DnwoUvb5DL2XtlBTad+EBmdBNMkqvM6oqrrwv6fG+jjlIXWRFl+mp
	6VQEoTpZPg4cj22ressXUW425wAdxO+qC/HD3mrOiZDvUsY7qeK4qKvNjK3MS0m4fscnk2O45ei
	4RseuWPiUBJmr/zeRUtr34WpLblOZdnkb8eMDVy/Tr+m6yV7sU6hRyOWbId7qHJxjBnXylwFyQM
	/IhNdntfTgZ8MRNOJi50eyKBJhvSLjwxa53OVENzRNqjnGW78ZKTlAIglqSqSS+bcTjDmmwYhMm
	Eeh8aKMfakCJ90IiIxwChC2rT5gMqMX+ckY4C1hPUiEHbBgx5bnZ0n1QdkxDUTUr8KsSonryMYk
	wbQtEAfvoOEyZedPvKMVkr+AAanEsvG1jZxQ/epQ9y3bfYnjdvVqtfIkLpz0HbLJLyqebM+ioki
	NuhdQqbCBrxpL2yMQ71NreljzOsb0LLm+9N1OMoQ0153ILK1qQkTdbBi0wOAfYeralcuM/byynR
	xNROG/tXryzMRbuyb28H0VYwpPJVayu85nDY=
X-Received: by 2002:a05:6000:460d:b0:492:9c9:65de with SMTP id ffacd0b85a97d-4a36bd51e25mr1195437f8f.5.1794858153672;
        Mon, 16 Nov 2026 11:42:33 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60d9fff8sm25294154f8f.52.2026.11.16.11.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 11:42:33 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] selftests/ovl: test pseudo filesystem upper and lower with data-only layers
Date: Mon, 16 Nov 2026 20:42:32 +0100
Message-ID: <20261116194232.940309-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A pseudo filesystem lower layer is now refused along with data-only
layers and a pseudo filesystem is refused as upper layer.

Split the lowerdir_sysfs test, so that sysfs as a regular lower layer
is still expected to mount, but sysfs as a lower layer along with a
data-only layer is expected to fail.

Add tests that sysfs as upperdir is refused via legacy mount options
and via fsconfig by path and by file descriptor, and a tmpfs upperdir
control test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

This applies on top of your selftest patch [1] and adapts it to the
expanded ban in "ovl: refuse pseudo filesystem layers in some setups".

On a kernel without the pseudo series, datadir_sysfs,
lowerdir_sysfs_with_datadir and upperdir_sysfs fail as expected
(sysfs upper falls back to a read-only mount) and the rest pass.
I did not test it with the full series.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20261116-work-loop-pseudo-v3-34-8cbbea1cf34f@kernel.org/

 .../filesystems/overlayfs/pseudo_datadir.c    | 83 ++++++++++++++++++-
 1 file changed, 80 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
index 3b59fd3e9f5c2..903c893d7b4c8 100644
--- a/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
+++ b/tools/testing/selftests/filesystems/overlayfs/pseudo_datadir.c
@@ -22,6 +22,7 @@ static int setup_tmp(void)
 	if (sys_mount("tmpfs", "/tmp", "tmpfs", 0, NULL))
 		return -errno;
 	if (mkdir("/tmp/lower", 0755) || mkdir("/tmp/data", 0755) ||
+	    mkdir("/tmp/upper", 0755) || mkdir("/tmp/work", 0755) ||
 	    mkdir("/tmp/merged", 0755))
 		return -errno;
 	return 0;
@@ -60,6 +61,54 @@ static int set_layer(int fd_context, const char *key, const char *path,
 	return ret;
 }
 
+/* Mount an overlayfs with the legacy "upperdir=" and "workdir=" options. */
+static int mount_upperdir(const char *upper, const char *work)
+{
+	char opts[256];
+
+	snprintf(opts, sizeof(opts), "lowerdir=/tmp/lower,upperdir=%s,workdir=%s",
+		 upper, work);
+	if (sys_mount("overlay", "/tmp/merged", "overlay", 0, opts))
+		return -errno;
+	if (umount2("/tmp/merged", 0))
+		return -errno;
+	return 0;
+}
+
+/* Create an overlayfs with "upperdir" and "workdir" through fsconfig. */
+static int fsmount_upper(const char *upper, const char *work, bool by_fd)
+{
+	int fd_context, fd_mnt, ret;
+
+	fd_context = sys_fsopen("overlay", FSOPEN_CLOEXEC);
+	if (fd_context < 0)
+		return -errno;
+
+	ret = set_layer(fd_context, "lowerdir+", "/tmp/lower", by_fd);
+	if (ret)
+		goto out;
+	ret = set_layer(fd_context, "upperdir", upper, by_fd);
+	if (ret)
+		goto out;
+	ret = set_layer(fd_context, "workdir", work, by_fd);
+	if (ret)
+		goto out;
+
+	if (sys_fsconfig(fd_context, FSCONFIG_CMD_CREATE, NULL, NULL, 0)) {
+		ret = -errno;
+		goto out;
+	}
+
+	fd_mnt = sys_fsmount(fd_context, FSMOUNT_CLOEXEC, 0);
+	if (fd_mnt < 0)
+		ret = -errno;
+	else
+		close(fd_mnt);
+out:
+	close(fd_context);
+	return ret;
+}
+
 /* Create an overlayfs with "lowerdir+" and "datadir+" through fsconfig. */
 static int fsmount_layers(const char *lower, const char *data, bool by_fd)
 {
@@ -123,9 +172,37 @@ TEST(lowerdir_sysfs)
 	ASSERT_EQ(setup_tmp(), 0);
 
 	EXPECT_EQ(mount_lowerdir("/sys/kernel:/tmp/lower"), 0);
-	EXPECT_EQ(mount_lowerdir("/sys/kernel::/tmp/data"), 0);
-	EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", false), 0);
-	EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", true), 0);
+}
+
+TEST(lowerdir_sysfs_with_datadir)
+{
+	ASSERT_EQ(setup_tmp(), 0);
+
+	EXPECT_EQ(mount_lowerdir("/sys/kernel::/tmp/data"), -EINVAL);
+	EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", false), -EINVAL);
+	EXPECT_EQ(fsmount_layers("/sys/kernel", "/tmp/data", true), -EINVAL);
+}
+
+/*
+ * Without the check, sysfs as upperdir falls back to a read-only mount
+ * because the work dir cannot be created.
+ */
+TEST(upperdir_sysfs)
+{
+	ASSERT_EQ(setup_tmp(), 0);
+
+	EXPECT_EQ(mount_upperdir("/sys/block", "/sys/bus"), -EINVAL);
+	EXPECT_EQ(fsmount_upper("/sys/block", "/sys/bus", false), -EINVAL);
+	EXPECT_EQ(fsmount_upper("/sys/block", "/sys/bus", true), -EINVAL);
+}
+
+TEST(upperdir_tmpfs)
+{
+	ASSERT_EQ(setup_tmp(), 0);
+
+	EXPECT_EQ(mount_upperdir("/tmp/upper", "/tmp/work"), 0);
+	EXPECT_EQ(fsmount_upper("/tmp/upper", "/tmp/work", false), 0);
+	EXPECT_EQ(fsmount_upper("/tmp/upper", "/tmp/work", true), 0);
 }
 
 TEST_HARNESS_MAIN
-- 
2.56.1

