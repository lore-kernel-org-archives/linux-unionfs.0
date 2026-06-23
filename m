Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3933CEB83
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 08:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782204228; cv=none; b=WZc8QK5QiPNdOAD+ELhuuhb9s6eTqm2USFT1Nzr7MCdL4vImV+A1cVVyOwyftgrwqy3Os91hoDsouguiF3qX4MCuVLgOkOoMBqUeJ7ca897i/WLlxvX9JbObpXSxNkY++byRr4D//lgYxvt2vWXMzbCRJb+71eeIElRd7RUaEEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782204228; c=relaxed/simple;
	bh=lfg1srceIJ1eSFRNPMtQ+KrzrlvWOOb6x0DAdIGCSJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bevJnvYvPEBjVyVP2bYviyHPGPZ2fVmSnyCkKzpAiCvqzTnuYdwkQ4rWzDaExL/5ZMzRgptk7igMJinEI/PvFSql1nZUNLFaxL1QUTeNG688NAP5x/hxrHvBGxLmIxsjOsmb/cjuc50pxn34/pE7cSbAv1YGpeyOqEN29HTpyGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OmF45IuJ; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmF45IuJ"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-36dac5d5d05so2197999a91.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 01:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782204227; x=1782809027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zue6mlJlY9UrWuLeq7Lq3jONG08MvTf5WYEeZtfkWvw=;
        b=OmF45IuJJVIFXCvC7qeRWzvRjsiU/1zYyKq8wLJRrHC5jHiNKKsEVwV3qC3yOq5BRB
         lHbOPdFUu0mkUtSrHO8N/+MY1PZfpeOOPIGGFnQp0YjLhm0LcwOINc5DRfAza14vT2KP
         NcG4UyMb3Z5QGIc+FSaKQkQiS7hZRqBfpKW++smWtQLSCnPHJq05ccoJGZNYod268Qnj
         o1R5TMhvM6pFL7ga/n/uLPbEzmBPYpf02NHgPXBjK7JSroBLNTM6SjZwwEDYqK0LL/vn
         8xdnDxwXamIkviMj/45R7dWzJXcpSVSJzC1hmSKTtXlIw6MBbAloc0+hUCyYUsj50qjF
         zDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782204227; x=1782809027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zue6mlJlY9UrWuLeq7Lq3jONG08MvTf5WYEeZtfkWvw=;
        b=JdHUKBGWAGUpWhUXB0/xHDHe8fT1nlBJzuOheiUW7a4OlR2cwGnnfqXE/d4IxXFWQ3
         JQoYCv9nrEAouF+ugoYMAo5jBk8rzlvwNa5J4083Udt8sYIjiQOCgQfkgGlyc8zv5Paj
         QIsWP5GM/3llAoWRGu6dFD+BtTAsv141vBGgY/GlkAtFBUgH5bkPhYg9/rMSWGUPtdI9
         zOrGwdfVmkVAbRTfMMHL/9fRINAjVzAKASH09l0WDdHYnq/Fd8oIgu5bJwb/JVpEdlCu
         JpjxogR/nFxGaXtGdZvUsNam1oa1pmOHMTO+eppiKqrunypJg2k6Wu32FY7QfEicZosL
         IxrQ==
X-Gm-Message-State: AOJu0YwEvkMylve99rVApbO/1Z8f2QTk5zv1w4JmQPmRqx+14mPz7Swy
	L8z3s/6zM6MOhsY5KCMvqMrJphRNrDNcmu7eyfQ1Qhv8WNnwV2WfgdHJ
X-Gm-Gg: AfdE7ckVp/JJjpy3UVoSpla6SVq819WzVeLK+pDIwwHR1f1ZgYQGCfu07hG1rOUHpft
	udRIe9X3U4qJ3ZkGavAtK/3rBBS6XIvzdjTyc13R5kS2zC3+fN4JyCPUT0J5MuQN57QEXY3H5Tt
	THWJiLWDBjT6oI+i71ix0SexgNZZdQsByX38dpufQ0EIX1JONg02R12nr3eJHzK7YrrhA637RdI
	CKH8fFVRKRXWwRCVE7/tna0ISCm8IhgBRe9d0Z06GQgegyD1Cs1SblZhLplQc56X17m5brdcI4h
	dFGgpdjNE7jEcqCguoQPdeH8eMBrsbTeznYNDh2hWFStiyC4cB+9XxJ1cZegONKWnLZcVj8V++J
	8CN6ndYAbw7SIkde2KTX5DOx1iw+cFnv1VheqilBvxjceNrYKmN3UkaY9h/63Dswo2Hh8svG4ux
	nsELIWVkrqLSqCJDet25dYPqNw6P7qDyRFOH5MIDWKRjaoMTg/egnQEe6PhRQWz69g
X-Received: by 2002:a17:90b:590e:b0:36c:e254:4db with SMTP id 98e67ed59e1d1-37dd16ccc33mr1907067a91.6.1782204226610;
        Tue, 23 Jun 2026 01:43:46 -0700 (PDT)
Received: from yafangs-Air ([240e:46d:2300:2990:20e5:8079:39b6:54c3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc563c168sm9293620a12.20.2026.06.23.01.43.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Jun 2026 01:43:46 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] ovl: Allow changing default fsync_mode
Date: Tue, 23 Jun 2026 16:43:37 +0800
Message-ID: <20260623084337.54344-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have enabled "volatile" fsync_mode on our Kubernetes production
environment to prevent container exit from being blocked when there
are many dirty pages to flush. This has worked well without introducing
any issues.

However, on some of our production servers, upgrading the container
runtime to support the "volatile" mount option is not straightforward [0].
To address this, we want to enable it by default within the kernel.

Add a Kconfig option to set the default fsync_mode at build time, and
allow it to be overridden dynamically via a module parameter when
loading overlayfs. This also aligns with how other features are
configured.

Link: https://github.com/containerd/containerd/issues/6406 [0]
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 fs/overlayfs/Kconfig  | 15 +++++++++++++++
 fs/overlayfs/params.c | 40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 2ac67e04a6fb..4aeae8232c39 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -134,3 +134,18 @@ config OVERLAY_FS_DEBUG
 	  Say Y here to enable extra debugging checks in overlayfs.
 
 	  If unsure, say N.
+
+config OVERLAY_FS_FSYNC_MODE
+	int "Overlayfs: default fsync mode"
+	depends on OVERLAY_FS
+	range 0 2
+	default 1
+	help
+	  Set the default fsync mode for Overlayfs.
+
+	  0: volatile - Do not sync filesystem on fsync
+	  1: auto     - Automatically detect sync behavior (default)
+	  2: strict   - Always sync filesystem on fsync
+
+	  This can be overridden at runtime via the fsync_mode module
+	  parameter or per-mount with the 'fsync=' mount option.
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index c93fcaa45d4a..e0c88cf19d51 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -153,11 +153,49 @@ static const char *ovl_fsync_mode(struct ovl_config *config)
 	return ovl_parameter_fsync[config->fsync_mode].name;
 }
 
+static int ovl_default_fsync = CONFIG_OVERLAY_FS_FSYNC_MODE;
 static int ovl_fsync_mode_def(void)
 {
-	return OVL_FSYNC_AUTO;
+	return ovl_default_fsync;
 }
 
+static int ovl_fsync_mode_set(const char *val, const struct kernel_param *kp)
+{
+	int i;
+	int *p = kp->arg;
+
+	if (!val)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(ovl_parameter_fsync); i++) {
+		if (sysfs_streq(val, ovl_parameter_fsync[i].name)) {
+			*p = ovl_parameter_fsync[i].value;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int ovl_fsync_mode_get(char *buffer, const struct kernel_param *kp)
+{
+	int val = *(int *)kp->arg;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ovl_parameter_fsync); i++) {
+		if (ovl_parameter_fsync[i].value == val)
+			return sysfs_emit(buffer, "%s\n", ovl_parameter_fsync[i].name);
+	}
+	return sysfs_emit(buffer, "unknown\n");
+}
+
+static const struct kernel_param_ops ovl_fsync_mode_ops = {
+	.set = ovl_fsync_mode_set,
+	.get = ovl_fsync_mode_get,
+};
+
+module_param_cb(fsync_mode, &ovl_fsync_mode_ops, &ovl_default_fsync, 0644);
+MODULE_PARM_DESC(fsync_mode, "fsync mode: auto, volatile, strict (default: auto)");
+
 const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_string_empty("lowerdir",    Opt_lowerdir),
 	fsparam_file_or_string("lowerdir+", Opt_lowerdir_add),
-- 
2.52.0

