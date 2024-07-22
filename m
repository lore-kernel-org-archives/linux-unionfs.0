Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA114B95E;
	Mon, 22 Jul 2024 10:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721643307; cv=none; b=r2QA6eVFWKR9eZs7x5TOASCyXDNRpuQkxDW0cI+v7cmXnrassr7vhem16wDjD8hT7uJ560FK8Ymlv6stnaVFfKGSiUP5kbh7fRrPksNjMMFKx5sEZW1r5XSQgC5wst4Qaj2BeNK3KkGGI/DcABEPevCN1rJLR77oAdfNWi1tZss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721643307; c=relaxed/simple;
	bh=K0eM665ecBX+x2YquiaLMD/JyQ5nVs9KzVg9eqsRkDE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=irCEJ96er2EuTtAJJ0ogwBGQuiBuAUhmyfSGl9CIA6cj4EL4hd8njVAyp5WlYNN17aZpz1tOee0CsYswm2oLmDRnR3n2c17DqQJZT+p9aH+GAkTo1nsL21SNMDINeJoN2rBilLjOB94PmY5VJWKr0AF1bRIxlbVnEfoEEyadgT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch01.asrmicro.com (exch01.asrmicro.com [10.1.24.121])
	by spam.asrmicro.com with ESMTPS id 46MAEjxF078742
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Mon, 22 Jul 2024 18:14:45 +0800 (GMT-8)
	(envelope-from feilv@asrmicro.com)
Received: from localhost (10.26.128.141) by exch01.asrmicro.com (10.1.24.121)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Mon, 22 Jul 2024 18:14:48
 +0800
From: Fei Lv <feilv@asrmicro.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>, <linux-unionfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lianghuxu@asrmicro.com>,
        <feilv@asrmicro.com>
Subject: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
Date: Mon, 22 Jul 2024 18:14:43 +0800
Message-ID: <20240722101443.10768-1-feilv@asrmicro.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch03.asrmicro.com (10.1.24.118) To exch01.asrmicro.com
 (10.1.24.121)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 46MAEjxF078742

For upper filesystem which does not enforce ordering on storing of
metadata changes(e.g. ubifs), when overlayfs file is modified for
the first time, copy up will create a copy of the lower file and
its parent directories in the upper layer. Permission lost of the
new upper parent directory was observed during power-cut stress test.

Fix by adding new mount opion "fsync=strict", make sure data/metadata of
copied up directory written to disk before renaming from tmp to final
destination.

Signed-off-by: Fei Lv <feilv@asrmicro.com>
---
V1 -> V2:
 1. change open flags from "O_LARGEFILE | O_WRONLY" to "O_RDONLY".
 2. change mount option to "fsync=ordered/strict/volatile".
 3. ovl_should_sync_strict() implies ovl_should_sync().
 4. remove redundant ovl_should_sync_strict from ovl_copy_up_meta_inode_data.
 5. update commit log.
 6. update documentation overlayfs.rst.

 Documentation/filesystems/overlayfs.rst | 39 +++++++++++++++++++++++++
 fs/overlayfs/copy_up.c                  | 18 ++++++++++++
 fs/overlayfs/ovl_entry.h                | 20 +++++++++++--
 fs/overlayfs/params.c                   | 33 ++++++++++++++++++---
 fs/overlayfs/super.c                    |  2 +-
 5 files changed, 105 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 165514401441..a783e57bdb57 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -742,6 +742,45 @@ controlled by the "uuid" mount option, which supports these values:
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
index a5ef2005a2cc..d99a18afceb8 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -243,6 +243,21 @@ static int ovl_verify_area(loff_t pos, loff_t pos2, loff_t len, loff_t totlen)
 	return 0;
 }
 
+static int ovl_copy_up_sync(struct path *path)
+{
+	struct file *new_file;
+	int err;
+
+	new_file = ovl_path_open(path, O_RDONLY);
+	if (IS_ERR(new_file))
+		return PTR_ERR(new_file);
+
+	err = vfs_fsync(new_file, 0);
+	fput(new_file);
+
+	return err;
+}
+
 static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
 			    struct file *new_file, loff_t len)
 {
@@ -701,6 +716,9 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 		err = ovl_set_attr(ofs, temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
+	if (!err && ovl_should_sync_strict(ofs))
+		err = ovl_copy_up_sync(&upperpath);
+
 	return err;
 }
 
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index cb449ab310a7..7f6d2effd5f1 100644
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
@@ -120,7 +126,17 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 
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
index 4860fcc4611b..c4aac288b7e0 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -58,6 +58,7 @@ enum ovl_opt {
 	Opt_xino,
 	Opt_metacopy,
 	Opt_verity,
+	Opt_fsync,
 	Opt_volatile,
 };
 
@@ -139,6 +140,23 @@ static int ovl_verity_mode_def(void)
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
 	fsparam_string("lowerdir+",         Opt_lowerdir_add),
@@ -154,6 +172,7 @@ const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_enum("xino",                Opt_xino, ovl_parameter_xino),
 	fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter_bool),
 	fsparam_enum("verity",              Opt_verity, ovl_parameter_verity),
+	fsparam_enum("fsync",               Opt_fsync, ovl_parameter_fsync),
 	fsparam_flag("volatile",            Opt_volatile),
 	{}
 };
@@ -617,8 +636,11 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
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
@@ -802,9 +824,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->index = false;
 	}
 
-	if (!config->upperdir && config->ovl_volatile) {
+	if (!config->upperdir && ovl_is_volatile(config)) {
 		pr_info("option \"volatile\" is meaningless in a non-upper mount, ignoring it.\n");
-		config->ovl_volatile = false;
+		config->fsync_mode = ovl_fsync_mode_def();
 	}
 
 	if (!config->upperdir && config->uuid == OVL_UUID_ON) {
@@ -997,8 +1019,11 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
-	if (ofs->config.ovl_volatile)
+	if (ovl_is_volatile(&ofs->config))
 		seq_puts(m, ",volatile");
+	else if (ofs->config.fsync_mode != ovl_fsync_mode_def())
+		seq_printf(m, ",fsync=%s",
+			   ovl_fsync_mode(&ofs->config));
 	if (ofs->config.userxattr)
 		seq_puts(m, ",userxattr");
 	if (ofs->config.verity_mode != ovl_verity_mode_def())
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 06a231970cb5..824cbcf40523 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -750,7 +750,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 * For volatile mount, create a incompat/volatile/dirty file to keep
 	 * track of it.
 	 */
-	if (ofs->config.ovl_volatile) {
+	if (ovl_is_volatile(&ofs->config)) {
 		err = ovl_create_volatile_dirty(ofs);
 		if (err < 0) {
 			pr_err("Failed to create volatile/dirty file.\n");

base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
-- 
2.45.2

