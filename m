Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C111FA3;
	Thu, 18 Jul 2024 03:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721274219; cv=none; b=JDuOwUMtUiGHs40g64DVSHHyy+sM8HW0L0lEhq7hL4OAMNLc0ZRLaamz6GvcmNuk3quRcer1emjojkVXZHzwVLyl1+/efMhs3xvA1MetwgS9Oqx3yS0dk6Zlk8Q4NacWTttsVNmSA7BALVzfE/S5ruHeaqJwTdu7qks+Gc0i7UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721274219; c=relaxed/simple;
	bh=YSWdZWNY9yqjagTXHnDy+F0jL4bF72Rvkx/oZp+FnW0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Gm9RnF/6xKOU0WN17I7GFbmj0W8z+m0IMOzKJ5sKe0pW4qea6zOH1ObE/yOQOcBckW8eeo3QQwBpqhazMc1KX5ck7ZXlYHEaHHUl7nEg/GS+J/6ddtgvCPo5si6TQ3YpQA48fpZUT5gdCBuGUwRR3VypHG5jOaQAb+Z7yWIVES0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch01.asrmicro.com (exch01.asrmicro.com [10.1.24.121])
	by spam.asrmicro.com with ESMTPS id 46I3hM4L005816
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Thu, 18 Jul 2024 11:43:22 +0800 (GMT-8)
	(envelope-from feilv@asrmicro.com)
Received: from localhost (10.26.128.141) by exch01.asrmicro.com (10.1.24.121)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Thu, 18 Jul 2024 11:43:24
 +0800
From: Fei Lv <feilv@asrmicro.com>
To: <miklos@szeredi.hu>, <amir73il@gmail.com>, <linux-unionfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lianghuxu@asrmicro.com>,
        <feilv@asrmicro.com>
Subject: [PATCH] ovl: fsync after metadata copy-up via mount option "upsync=strict"
Date: Thu, 18 Jul 2024 11:43:15 +0800
Message-ID: <20240718034316.29844-1-feilv@asrmicro.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch01.asrmicro.com (10.1.24.121) To exch01.asrmicro.com
 (10.1.24.121)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 46I3hM4L005816

If a directory only exist in low layer, create a new file in it trigger
directory copy-up. Permission lost of the new directory in upper layer
was observed during power-cut stress test.

Fix by adding new mount opion "upsync=strict", make sure data/metadata of
copied up directory written to disk before renaming from tmp to final
destination.

Signed-off-by: Fei Lv <feilv@asrmicro.com>
---
OPT_sync changed to OPT_upsync since mount option "sync" already used.

 fs/overlayfs/copy_up.c   | 21 +++++++++++++++++++++
 fs/overlayfs/ovl_entry.h | 20 ++++++++++++++++++--
 fs/overlayfs/params.c    | 33 +++++++++++++++++++++++++++++----
 fs/overlayfs/super.c     |  2 +-
 4 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a5ef2005a2cc..b6f021ad7a43 100644
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
+	new_file = ovl_path_open(path, O_LARGEFILE | O_WRONLY);
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
 
@@ -1104,6 +1122,9 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
 	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
 	ovl_set_upperdata(d_inode(c->dentry));
+
+	if (!err && ovl_should_sync_strict(ofs))
+		err = ovl_copy_up_sync(&upperpath);
 out_free:
 	kfree(capability);
 out:
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index cb449ab310a7..4592e6f7dcf7 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -5,6 +5,12 @@
  * Copyright (C) 2016 Red Hat, Inc.
  */
 
+enum {
+	OVL_SYNC_DATA,
+	OVL_SYNC_STRICT,
+	OVL_SYNC_OFF,
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
+	int sync_mode;
 };
 
 struct ovl_sb {
@@ -120,7 +126,17 @@ static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 
 static inline bool ovl_should_sync(struct ovl_fs *ofs)
 {
-	return !ofs->config.ovl_volatile;
+	return ofs->config.sync_mode == OVL_SYNC_DATA;
+}
+
+static inline bool ovl_should_sync_strict(struct ovl_fs *ofs)
+{
+	return ofs->config.sync_mode == OVL_SYNC_STRICT;
+}
+
+static inline bool ovl_is_volatile(struct ovl_config *config)
+{
+	return config->sync_mode == OVL_SYNC_OFF;
 }
 
 static inline unsigned int ovl_numlower(struct ovl_entry *oe)
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 4860fcc4611b..5d5538dd3de7 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -58,6 +58,7 @@ enum ovl_opt {
 	Opt_xino,
 	Opt_metacopy,
 	Opt_verity,
+	Opt_upsync,
 	Opt_volatile,
 };
 
@@ -139,6 +140,23 @@ static int ovl_verity_mode_def(void)
 	return OVL_VERITY_OFF;
 }
 
+static const struct constant_table ovl_parameter_upsync[] = {
+	{ "data",	OVL_SYNC_DATA      },
+	{ "strict",	OVL_SYNC_STRICT    },
+	{ "off",	OVL_SYNC_OFF       },
+	{}
+};
+
+static const char *ovl_upsync_mode(struct ovl_config *config)
+{
+	return ovl_parameter_upsync[config->sync_mode].name;
+}
+
+static int ovl_upsync_mode_def(void)
+{
+	return OVL_SYNC_DATA;
+}
+
 const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_string_empty("lowerdir",    Opt_lowerdir),
 	fsparam_string("lowerdir+",         Opt_lowerdir_add),
@@ -154,6 +172,7 @@ const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_enum("xino",                Opt_xino, ovl_parameter_xino),
 	fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter_bool),
 	fsparam_enum("verity",              Opt_verity, ovl_parameter_verity),
+	fsparam_enum("upsync",              Opt_upsync, ovl_parameter_upsync),
 	fsparam_flag("volatile",            Opt_volatile),
 	{}
 };
@@ -617,8 +636,11 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_verity:
 		config->verity_mode = result.uint_32;
 		break;
+	case Opt_upsync:
+		config->sync_mode = result.uint_32;
+		break;
 	case Opt_volatile:
-		config->ovl_volatile = true;
+		config->sync_mode = OVL_SYNC_OFF;
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
+		config->sync_mode = ovl_upsync_mode_def();
 	}
 
 	if (!config->upperdir && config->uuid == OVL_UUID_ON) {
@@ -997,8 +1019,11 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
-	if (ofs->config.ovl_volatile)
+	if (ovl_is_volatile(&ofs->config))
 		seq_puts(m, ",volatile");
+	else if (ofs->config.sync_mode != ovl_upsync_mode_def())
+		seq_printf(m, ",upsync=%s",
+			   ovl_upsync_mode(&ofs->config));
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

