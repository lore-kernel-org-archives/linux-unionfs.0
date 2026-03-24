Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05953FE661
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364275; cv=none; b=rBsaYNK8Xcuzf6XHMEYECichl4o5HB/mowifQFjli8EgpQtvXrDapCXEGkpK009aJLysjY2YrZb7LadZCOuMub/4XoejDFRkozJ2B56dUoreJB3ZcaFAHvB+xI6sFs/r2GxxcYmQif22mrrHcILc3uCTYZk2pQHxfFVW+aFEeQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364275; c=relaxed/simple;
	bh=wP2VAd8uC5DoBq8oKC/ybQTbv78hd/KlwOq4UysuGKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZHDqyeq2emwCbLztRG4RMzfLHFkMQ4PMKnaO0DJam/iWO6MlDmTGxQmxWyy/+TCB58gAuTUOtx7FrgVl5QKRZxqc+mARAGZkjEs8Io0yCA/f1E+6PySpb4USGKWXQo/hM7jrH/UsWXpFsyfCic/6NitWS/enxLwX/WEvcgB0vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qr6hdSZb; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qr6hdSZb"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b97e6e48b24so266115266b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 07:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774364272; x=1774969072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q/aXTMfWMQJT4pRNTYB+hJHAjo0aqEPgFnREjQmLCXU=;
        b=Qr6hdSZby2gHgMLjDB7uw2qOPBFJVNyHWaZPMRALTzIvqnh91cEsf4m5jU/urRJyL3
         z/Q9Rv+++r6jXPoDNtfWMkzAkmYVUHu/LIj84G3RfG6gmUxVPT/qBQyerQjdoIO53Ey5
         4L4v9bVqrEY8hdTIBFm5NRV3bIGFKr272TgiqT2HzIv8OnqF9KolhxC+V9NPqLeqkT99
         BVIA6KfgaiuNHPla8CPFXc/yjeR83pbwyk+l+yg3W82kbF3Q8bfTnOsOg9XQqGI5YrdK
         eQ9R/LrKfBiyyjAyeFy0luW5UgW5L+ZOwDsrgw9HCMNDpkFq3jPqF0e5zptWi5NUGz30
         ao0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774364272; x=1774969072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/aXTMfWMQJT4pRNTYB+hJHAjo0aqEPgFnREjQmLCXU=;
        b=jUuFOPCyNXhVwitg+FogjEwbH77PDdJHM3lU44ZByCvTNXvlIaqRrcL0RwevFQlLI8
         IPyh2C+j1LjSMMNC1Lp+qcshjdeQv1ZVjQVohZ4H9o79nE0nhwNyu7KJ5MkyxelcR14V
         KBbF3nf6dTWYMHtiI8Oi0uQUMlzP+UbnwHrYfiSBfWIeulmyc6NVfxqcI3KoeQOPUupb
         Uw/K0lPha1uzZGW4Mz/6lZq7rEGkEteJ0z7AvMAblnrW9egNP5tytJFESTOq5TRr8Baq
         Bs5FBpfwHwlXwyFPNts4pTsZSE+zWJXLS+RQF03zZF4y7euUU6+eIkyOZCt8DQl0r8oj
         kL5A==
X-Forwarded-Encrypted: i=1; AJvYcCUlR1f53V57mvKhq1a87prNxfVdMYqfNjgLS4qlefMBtmtsIbbumg2K6/ZEwRxEF+bBkHgtUU2bttZucMhy@vger.kernel.org
X-Gm-Message-State: AOJu0YzdyPW2+3zUUHtnn7CeNPcXEh7PktJmlQztX0PREhMFqwBo70mr
	3VUcujbVOMiSX/zCA6eCND8anxKErNUZ+d4VhlYk44MhqCIQC36OLcL3
X-Gm-Gg: ATEYQzzU8XAh1yZHkhk56ael04FipAMwuNGdsQ3/6dOSSARqafbqsWU5dHhJaYJwNx8
	EcfNbxEJKqmcM2ElMECzUXe3ZgDjph55pxpHT8V9bfX5PcSodWPzOOyFHU000CEfk7Zd+DkIXdA
	3XYwucZcXwI16Z33x6w5b6C+Q/EP3Q2DoH4sdBvFd2JNU2rdjsnZBebiUTtOHtTM7cHIDTP7Kb9
	kUrpEDZ+AVNtXSMzzHN7IMHnbRudGYrkInAdiZPYwe6cP0f+X0ldXRddH+xP8nzPVfUII0X08le
	RP2psNbuGnp9xM47F+di0WJo+PzeA0qhPJUZVusL98xEDPm1kics6xyqI+F8Jrm+rR4U6oZ3/2E
	AhMNHoq6Hoyj607BGn1zZlBiWzeUsXVioMdo0tXd6NMvbnE/7TaQ0rUmaONnBiJ8UmNhV/vGPdE
	aUOQDXRB1b2RKB2sNk6wyPgg+b2NEMQo2zZG5/KoyQCmGlrXo7PaI2dSKjPzHRPk+K9RreitXrM
	0F1s8uBvDPsQzLIFnrk/I/o1FqC
X-Received: by 2002:a17:906:2691:b0:b97:d126:c007 with SMTP id a640c23a62f3a-b982f37d448mr863944066b.30.1774364271624;
        Tue, 24 Mar 2026 07:57:51 -0700 (PDT)
Received: from localhost (2001-1c00-570d-ee00-4ce2-3481-21c7-16a7.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:4ce2:3481:21c7:16a7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-668d22914ecsm4874911a12.21.2026.03.24.07.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 07:57:51 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Fei Lv <feilv@asrmicro.com>,
	Chenglong Tang <chenglongtang@google.com>,
	stable@vger.kernel.org
Subject: [PATCH] ovl: make fsync after metadata copy-up opt-in mount option
Date: Tue, 24 Mar 2026 15:57:50 +0100
Message-ID: <20260324145750.90719-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fei Lv <feilv@asrmicro.com>

Commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up") was done to
fix durability of overlayfs copy up on an upper filesystem which does
not enforce ordering on storing of metadata changes (e.g. ubifs).

In an earlier revision of the regressing commit by Lei Lv, the metadata
fsync behavior was opt-in via a new "fsync=strict" mount option.
We were hoping that the opt-in mount option could be avoided, so the
change was only made to depend on metacopy=off, in the hope of not
hurting performance of metadata heavy workloads, which are more likely
to be using metacopy=on.

This hope was proven wrong by a performance regression report from Google
COS workload after upgrade to kernel 6.12.

This is an adaptation of Lei's original "fsync=strict" mount option
to the existing upstream code.

The new mount option is mutually exclusive with the "volatile" mount
option, so the latter is now an alias to the "fsync=volatile" mount
option.

Reported-by: Chenglong Tang <chenglongtang@google.com>
Closes: https://lore.kernel.org/linux-unionfs/CAOdxtTadAFH01Vui1FvWfcmQ8jH1O45owTzUcpYbNvBxnLeM7Q@mail.gmail.com/
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxgKC1SgjMWre=fUb00v8rxtd6sQi-S+dxR8oDzAuiGu8g@mail.gmail.com/
Fixes: 7d6899fb69d25 ("ovl: fsync after metadata copy-up")
Depends: 50e638beb67e0 ("ovl: Use str_on_off() helper in ovl_show_options()")
Cc: stable@vger.kernel.org # v6.12
Signed-off-by: Fei Lv <feilv@asrmicro.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

The linked conversion was concluded with:
"Now we just need to hope that users won't come shouting about
performance regressions."

Well, users came shouting.

I am going to queue this up for an explicit opt-in to strict
metadata fsync.

Your review comment on the original fsync=strict patch are
already addressed by the upstream commit (no double fsync).

Thanks,
Amir.


 Documentation/filesystems/overlayfs.rst | 39 +++++++++++++++++++++++++
 fs/overlayfs/copy_up.c                  |  6 ++--
 fs/overlayfs/ovl_entry.h                | 20 +++++++++++--
 fs/overlayfs/params.c                   | 32 ++++++++++++++++----
 fs/overlayfs/super.c                    |  2 +-
 5 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index af5a69f87da42..f9ef3d101c172 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -783,6 +783,45 @@ controlled by the "uuid" mount option, which supports these values:
     mounted with "uuid=on".
 
 
+Durability and copy up
+----------------------
+
+The fsync(2) and fdatasync(2) system calls ensure that the metadata and
+data of a file, respectively, are safely written to the backing
+storage, which is expected to guarantee the existence of the information post
+system crash.
+
+Without the fdatasync(2) call, there is no guarantee that the observed
+data after a system crash will be either the old or the new data, but
+in practice, the observed data after crash is often the old or new data or a
+mix of both.
+
+When overlayfs file is modified for the first time, copy up will create
+a copy of the lower file and its parent directories in the upper layer.
+In case of a system crash, if fdatasync(2) was not called after the
+modification, the upper file could end up with no data at all (i.e.
+zeros), which would be an unusual outcome.  To avoid this experience,
+overlayfs calls fsync(2) on the upper file before completing the copy up with
+rename(2) to make the copy up "atomic".
+
+Depending on the backing filesystem (e.g. ubifs), fsync(2) before
+rename(2) may not be enough to provide the "atomic" copy up behavior
+and fsync(2) on the copied up parent directories is required as well.
+
+Overlayfs can be tuned to prefer performance or durability when storing
+to the underlying upper layer.  This is controlled by the "fsync" mount
+option, which supports these values:
+
+- "ordered": (default)
+    Call fsync(2) on upper file before completion of copy up.
+- "strict":
+    Call fsync(2) on upper file and directories before completion of copy up.
+- "volatile": [*]
+    Prefer performance over durability (see `Volatile mount`_)
+
+[*] The mount option "volatile" is an alias to "fsync=volatile".
+
+
 Volatile mount
 --------------
 
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 758611ee4475f..eca285a2d0c5b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1146,15 +1146,15 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		return -EOVERFLOW;
 
 	/*
-	 * With metacopy disabled, we fsync after final metadata copyup, for
+	 * With "fsync=strict", we fsync after final metadata copyup, for
 	 * both regular files and directories to get atomic copyup semantics
 	 * on filesystems that do not use strict metadata ordering (e.g. ubifs).
 	 *
-	 * With metacopy enabled we want to avoid fsync on all meta copyup
+	 * By default, we want to avoid fsync on all meta copyup, because
 	 * that will hurt performance of workloads such as chown -R, so we
 	 * only fsync on data copyup as legacy behavior.
 	 */
-	ctx.metadata_fsync = !OVL_FS(dentry->d_sb)->config.metacopy &&
+	ctx.metadata_fsync = ovl_should_sync_strict(OVL_FS(dentry->d_sb)) &&
 			     (S_ISREG(ctx.stat.mode) || S_ISDIR(ctx.stat.mode));
 	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
 
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 1d4828dbcf7ac..dbb2242647ce4 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -5,6 +5,12 @@
  * Copyright (C) 2016 Red Hat, Inc.
  */
 
+enum {
+	OVL_FSYNC_ORDERED,
+	OVL_FSYNC_STRICT,
+	OVL_FSYNC_VOLATILE,
+};
+
 struct ovl_config {
 	char *upperdir;
 	char *workdir;
@@ -18,7 +24,7 @@ struct ovl_config {
 	int xino;
 	bool metacopy;
 	bool userxattr;
-	bool ovl_volatile;
+	int fsync_mode;
 };
 
 struct ovl_sb {
@@ -122,7 +128,17 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 
 static inline bool ovl_should_sync(struct ovl_fs *ofs)
 {
-	return !ofs->config.ovl_volatile;
+	return ofs->config.fsync_mode != OVL_FSYNC_VOLATILE;
+}
+
+static inline bool ovl_should_sync_strict(struct ovl_fs *ofs)
+{
+	return ofs->config.fsync_mode == OVL_FSYNC_STRICT;
+}
+
+static inline bool ovl_is_volatile(struct ovl_config *config)
+{
+	return config->fsync_mode == OVL_FSYNC_VOLATILE;
 }
 
 static inline unsigned int ovl_numlower(struct ovl_entry *oe)
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 8111b437ae5d9..ba860bb92439a 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -58,6 +58,7 @@ enum ovl_opt {
 	Opt_xino,
 	Opt_metacopy,
 	Opt_verity,
+	Opt_fsync,
 	Opt_volatile,
 	Opt_override_creds,
 };
@@ -140,6 +141,23 @@ static int ovl_verity_mode_def(void)
 	return OVL_VERITY_OFF;
 }
 
+static const struct constant_table ovl_parameter_fsync[] = {
+	{ "ordered",	OVL_FSYNC_ORDERED  },
+	{ "strict",	OVL_FSYNC_STRICT   },
+	{ "volatile",	OVL_FSYNC_VOLATILE },
+	{}
+};
+
+static const char *ovl_fsync_mode(struct ovl_config *config)
+{
+	return ovl_parameter_fsync[config->fsync_mode].name;
+}
+
+static int ovl_fsync_mode_def(void)
+{
+	return OVL_FSYNC_ORDERED;
+}
+
 const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_string_empty("lowerdir",    Opt_lowerdir),
 	fsparam_file_or_string("lowerdir+", Opt_lowerdir_add),
@@ -155,6 +173,7 @@ const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_enum("xino",                Opt_xino, ovl_parameter_xino),
 	fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter_bool),
 	fsparam_enum("verity",              Opt_verity, ovl_parameter_verity),
+	fsparam_enum("fsync",               Opt_fsync, ovl_parameter_fsync),
 	fsparam_flag("volatile",            Opt_volatile),
 	fsparam_flag_no("override_creds",   Opt_override_creds),
 	{}
@@ -665,8 +684,11 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_verity:
 		config->verity_mode = result.uint_32;
 		break;
+	case Opt_fsync:
+		config->fsync_mode = result.uint_32;
+		break;
 	case Opt_volatile:
-		config->ovl_volatile = true;
+		config->fsync_mode = OVL_FSYNC_VOLATILE;
 		break;
 	case Opt_userxattr:
 		config->userxattr = true;
@@ -870,9 +892,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->index = false;
 	}
 
-	if (!config->upperdir && config->ovl_volatile) {
+	if (!config->upperdir && ovl_is_volatile(config)) {
 		pr_info("option \"volatile\" is meaningless in a non-upper mount, ignoring it.\n");
-		config->ovl_volatile = false;
+		config->fsync_mode = ovl_fsync_mode_def();
 	}
 
 	if (!config->upperdir && config->uuid == OVL_UUID_ON) {
@@ -1070,8 +1092,8 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_printf(m, ",xino=%s", ovl_xino_mode(&ofs->config));
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s", str_on_off(ofs->config.metacopy));
-	if (ofs->config.ovl_volatile)
-		seq_puts(m, ",volatile");
+	if (ofs->config.fsync_mode != ovl_fsync_mode_def())
+		seq_printf(m, ",fsync=%s", ovl_fsync_mode(&ofs->config));
 	if (ofs->config.userxattr)
 		seq_puts(m, ",userxattr");
 	if (ofs->config.verity_mode != ovl_verity_mode_def())
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d4c12feec0392..0822987cfb51c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -776,7 +776,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 * For volatile mount, create a incompat/volatile/dirty file to keep
 	 * track of it.
 	 */
-	if (ofs->config.ovl_volatile) {
+	if (ovl_is_volatile(&ofs->config)) {
 		err = ovl_create_volatile_dirty(ofs);
 		if (err < 0) {
 			pr_err("Failed to create volatile/dirty file.\n");
-- 
2.53.0

