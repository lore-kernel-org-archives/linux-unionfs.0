Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D43164D;
	Wed,  6 Nov 2024 03:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730863022; cv=none; b=X/EVdp0c0QtLWeECGc1racJOF6IzYtSS71nvaSZLF5t2xNqLTB5gM04mlHkNH0HOFCxAq12FtapEMBpg+oaSi+f8MRakGZJqKErPdoVaQAEFgirUwRvf8hfzDkH+RRhXnkh4zRkW9SuQsKXRXSg8MxTlXzcFcRr67my4d/0cSak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730863022; c=relaxed/simple;
	bh=mAwYq56Ckny4Ho9Mlsx1vd2PAhqtajPHxa+WQWCnS8k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=QWAQM4NlqQcOeJiEIOcfaBdtedLSEARYgwN0cx4pvCoqnnPxzbzj0YssjReFSzFaqKu9GrgdM9YnUOLa8G3VMxIhz+ZoN1UcUz5HDQyMn0ILjPcTdIZi2wD6pmPtg5YmgyZToG4E5R8GMJu4imYhcnfE6lpU++fHPlycnBAJwyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com; spf=pass smtp.mailfrom=cyphar.com; dkim=pass (2048-bit key) header.d=cyphar.com header.i=@cyphar.com header.b=wTnkm/su; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cyphar.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyphar.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyphar.com header.i=@cyphar.com header.b="wTnkm/su"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4XjqvW3Prgz9spB;
	Wed,  6 Nov 2024 04:10:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
	t=1730862615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/gZGoCD5UI6LTGnn0kBVJUOTO+trZM3GyZh7dVEgPsk=;
	b=wTnkm/suzb5f/6I4+qnbjnD5IjBffYtSZpMpSLSYMa8TzQge6IpUH2qinfAnEfLfwIz2Jf
	ibxeAYJnPG4p6KXHYzTvM8H53v8Uj+60+Lkf77rj94NgPlsfbRz++9oGYEkESsYkiSUjhS
	ZxrSRSxlKAQp3Xcrrqy50EtB+Efzxfpd6TLYU88V0jpQ9Qe7TM+bDr0New3xHT46jFQc3R
	reik5fX1NQyGfJts6MR05r0Ph1ZAk+I2YloieOogburfvDHolBohHtujp1cfNKgiivb5sq
	dnJAx8YRECM3q7XGKmpqJVwsjQV+CzOJVEvXRlXeYcmcfTQ4ivDPFohtwdHsQA==
From: Aleksa Sarai <cyphar@cyphar.com>
Date: Wed, 06 Nov 2024 14:09:58 +1100
Subject: [PATCH] overlayfs: port all superblock creation logging to fsopen
 logs
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241106-overlayfs-fsopen-log-v1-1-9d883be7e56e@cyphar.com>
X-B4-Tracking: v=1; b=H4sIAAbeKmcC/x3MQQqAIBBA0avErBtQs4KuEi2sRhsIDQeiiO6et
 HyL/x8QykwCQ/VAppOFUyzQdQXL5mIg5LUYjDJWa9VhOinv7vaCXtJBEfcUkDrrdd8a1cwOSnp
 k8nz923F63w+Zi6elZgAAAA==
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-unionfs@vger.kernel.org, linux-fs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=42050; i=cyphar@cyphar.com;
 h=from:subject:message-id; bh=mAwYq56Ckny4Ho9Mlsx1vd2PAhqtajPHxa+WQWCnS8k=;
 b=owGbwMvMwCWmMf3Xpe0vXfIZT6slMaRr3RPwvPN6+Rn96npfxegpsn2L/67YfbvI4p5w2Cs+2
 a46HgnRjlIWBjEuBlkxRZZtfp6hm+YvvpL8aSUbzBxWJpAhDFycAjCRe18YGb4sOytYWl7Urfig
 p9Ygl+8a0xs3g8SPCXFLz/TMPRPh/oPhn5HfsZ9ebp/z3xn/87x8afLUxSWCR7dtib34pGmv2eR
 7QvwA
X-Developer-Key: i=cyphar@cyphar.com; a=openpgp;
 fpr=C9C370B246B09F6DBCFC744C34401015D1D2D386
X-Rspamd-Queue-Id: 4XjqvW3Prgz9spB

overlayfs helpfully provides a lot of of information when setting up a
mount, but unfortunately when using the fsopen(2) API, a lot of this
information is mixed in with the general kernel log.

In addition, some of the logs can become a source of spam if programs
are creating many internal overlayfs mounts (in runc we use an internal
overlayfs mount to protect the runc binary against container breakout
attacks like CVE-2019-5736, and xino_auto=on caused a lot of spam in
dmesg because we didn't explicitly disable xino[1]).

By logging to the fs_context, userspace can get more accurate
information when using fsopen(2) and there is less dmesg spam for
systems where a lot of programs are using fsopen("overlay"). Legacy
mount(2) users will still see the same errors in dmesg as they did
before (though the prefix of the log messages will now be "overlay"
rather than "overlayfs").

[1]: https://bbs.archlinux.org/viewtopic.php?pid=2206551

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
In order to avoid passing fs_context everywhere, I opted to pass p_log
instead to functions that only did some ancilliary logging and only pass
fs_context to functions that already took ovl_fs_context. While I feel
this makes it clearer which functions are just using fs_context for
logging purposes, this makes overlayfs the first real user of p_log, and
I'm not sure how you folks might feel about that.

I've also tried to unify the layout of log messages (with some
exceptions) but I guess it's possible that keeping the existing
formatting might be important for programs that parse dmesg. Let me know
if you'd like to keep the existing (inconsistent) formatting.

Since this isn't explicitly documented, I aught to mention that the
fc_context logs are available even after *_fill_super is completed and
the superblock has been created, so logging info/warn messages in
*_fill_super is still fine and userspace will still be able to get the
logs after doing fsconfig(FSCONFIG_CREATE).
---
 fs/overlayfs/params.c | 151 ++++++++++++++------------------
 fs/overlayfs/params.h |   3 +-
 fs/overlayfs/super.c  | 232 ++++++++++++++++++++++++++------------------------
 3 files changed, 183 insertions(+), 203 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index e42546c6c5df..d72f642df38e 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -186,7 +186,7 @@ static int ovl_parse_monolithic(struct fs_context *fc, void *data)
 	return vfs_parse_monolithic_sep(fc, data, ovl_next_opt);
 }
 
-static ssize_t ovl_parse_param_split_lowerdirs(char *str)
+static ssize_t ovl_parse_param_split_lowerdirs(struct p_log *log, char *str)
 {
 	ssize_t nr_layers = 1, nr_colons = 0;
 	char *s, *d;
@@ -199,10 +199,8 @@ static ssize_t ovl_parse_param_split_lowerdirs(char *str)
 			bool next_colon = (*(s + 1) == ':');
 
 			nr_colons++;
-			if (nr_colons == 2 && next_colon) {
-				pr_err("only single ':' or double '::' sequences of unescaped colons in lowerdir mount option allowed.\n");
-				return -EINVAL;
-			}
+			if (nr_colons == 2 && next_colon)
+				return inval_plog(log, "only single ':' or double '::' sequences of unescaped colons in lowerdir mount option allowed");
 			/* count layers, not colons */
 			if (!next_colon)
 				nr_layers++;
@@ -214,10 +212,8 @@ static ssize_t ovl_parse_param_split_lowerdirs(char *str)
 		*d = *s;
 		if (!*s) {
 			/* trailing colons */
-			if (nr_colons) {
-				pr_err("unescaped trailing colons in lowerdir mount option.\n");
-				return -EINVAL;
-			}
+			if (nr_colons)
+				return inval_plog(log, "unescaped trailing colons in lowerdir mount option");
 			break;
 		}
 		nr_colons = 0;
@@ -226,22 +222,17 @@ static ssize_t ovl_parse_param_split_lowerdirs(char *str)
 	return nr_layers;
 }
 
-static int ovl_mount_dir_noesc(const char *name, struct path *path)
+static int ovl_mount_dir_noesc(struct p_log *log, const char *name,
+			       struct path *path)
 {
 	int err = -EINVAL;
 
-	if (!*name) {
-		pr_err("empty lowerdir\n");
-		goto out;
-	}
-	err = kern_path(name, LOOKUP_FOLLOW, path);
-	if (err) {
-		pr_err("failed to resolve '%s': %i\n", name, err);
-		goto out;
-	}
-	return 0;
+	if (!*name)
+		return inval_plog(log, "empty lowerdir");
 
-out:
+	err = kern_path(name, LOOKUP_FOLLOW, path);
+	if (err)
+		error_plog(log, "failed to resolve '%s': %i", name, err);
 	return err;
 }
 
@@ -258,14 +249,15 @@ static void ovl_unescape(char *s)
 	}
 }
 
-static int ovl_mount_dir(const char *name, struct path *path)
+static int ovl_mount_dir(struct p_log *log, const char *name,
+			 struct path *path)
 {
 	int err = -ENOMEM;
 	char *tmp = kstrdup(name, GFP_KERNEL);
 
 	if (tmp) {
 		ovl_unescape(tmp);
-		err = ovl_mount_dir_noesc(tmp, path);
+		err = ovl_mount_dir_noesc(log, tmp, path);
 		kfree(tmp);
 	}
 	return err;
@@ -378,9 +370,9 @@ static int ovl_parse_layer(struct fs_context *fc, const char *layer_name, enum o
 		return -ENOMEM;
 
 	if (upper || layer == Opt_lowerdir)
-		err = ovl_mount_dir(name, &path);
+		err = ovl_mount_dir(&fc->log, name, &path);
 	else
-		err = ovl_mount_dir_noesc(name, &path);
+		err = ovl_mount_dir_noesc(&fc->log, name, &path);
 	if (err)
 		goto out_free;
 
@@ -448,10 +440,8 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 	if (!*name)
 		return 0;
 
-	if (*name == ':') {
-		pr_err("cannot append lower layer\n");
-		return -EINVAL;
-	}
+	if (*name == ':')
+		return invalfc(fc, "cannot append lower layer");
 
 	// Store user provided lowerdir string to show in mount options
 	ctx->lowerdir_all = kstrdup(name, GFP_KERNEL);
@@ -463,12 +453,12 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 		return -ENOMEM;
 
 	err = -EINVAL;
-	nr_lower = ovl_parse_param_split_lowerdirs(dup);
+	nr_lower = ovl_parse_param_split_lowerdirs(&fc->log, dup);
 	if (nr_lower < 0)
 		goto out_err;
 
 	if (nr_lower > OVL_MAX_STACK) {
-		pr_err("too many lower directories, limit is %d\n", OVL_MAX_STACK);
+		errorfc(fc, "too many lower directories, limit is %d", OVL_MAX_STACK);
 		goto out_err;
 	}
 
@@ -493,7 +483,7 @@ static int ovl_parse_param_lowerdir(const char *name, struct fs_context *fc)
 			 * there are no data layers.
 			 */
 			if (ctx->nr_data > 0) {
-				pr_err("regular lower layers cannot follow data lower layers\n");
+				errorfc(fc, "regular lower layers cannot follow data lower layers");
 				goto out_err;
 			}
 
@@ -597,9 +587,8 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		config->userxattr = true;
 		break;
 	default:
-		pr_err("unrecognized mount option \"%s\" or missing value\n",
-		       param->key);
-		return -EINVAL;
+		return invalfc(fc, "unrecognized mount option \"%s\" or missing value",
+			       param->key);
 	}
 
 	return err;
@@ -750,44 +739,43 @@ void ovl_free_fs(struct ovl_fs *ofs)
 	kfree(ofs);
 }
 
-int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
+int ovl_fs_params_verify(struct fs_context *fc,
 			 struct ovl_config *config)
 {
+	const struct ovl_fs_context *ctx = fc->fs_private;
 	struct ovl_opt_set set = ctx->set;
 
 	/* Workdir/index are useless in non-upper mount */
 	if (!config->upperdir) {
 		if (config->workdir) {
-			pr_info("option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
-				config->workdir);
+			infofc(fc, "option \"workdir=%s\" is useless in a non-upper mount, ignore",
+			       config->workdir);
 			kfree(config->workdir);
 			config->workdir = NULL;
 		}
 		if (config->index && set.index) {
-			pr_info("option \"index=on\" is useless in a non-upper mount, ignore\n");
+			infofc(fc, "option \"index=on\" is useless in a non-upper mount, ignore");
 			set.index = false;
 		}
 		config->index = false;
 	}
 
 	if (!config->upperdir && config->ovl_volatile) {
-		pr_info("option \"volatile\" is meaningless in a non-upper mount, ignoring it.\n");
+		infofc(fc, "option \"volatile\" is meaningless in a non-upper mount, ignoring it");
 		config->ovl_volatile = false;
 	}
 
 	if (!config->upperdir && config->uuid == OVL_UUID_ON) {
-		pr_info("option \"uuid=on\" requires an upper fs, falling back to uuid=null.\n");
+		infofc(fc, "option \"uuid=on\" requires an upper fs, falling back to uuid=null");
 		config->uuid = OVL_UUID_NULL;
 	}
 
 	/* Resolve verity -> metacopy dependency */
 	if (config->verity_mode && !config->metacopy) {
 		/* Don't allow explicit specified conflicting combinations */
-		if (set.metacopy) {
-			pr_err("conflicting options: metacopy=off,verity=%s\n",
-			       ovl_verity_mode(config));
-			return -EINVAL;
-		}
+		if (set.metacopy)
+			return invalfc(fc, "conflicting options: metacopy=off,verity=%s",
+				       ovl_verity_mode(config));
 		/* Otherwise automatically enable metacopy. */
 		config->metacopy = true;
 	}
@@ -801,23 +789,21 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 
 	/* Resolve verity -> metacopy -> redirect_dir dependency */
 	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
-		if (set.metacopy && set.redirect) {
-			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
-			return -EINVAL;
-		}
-		if (config->verity_mode && set.redirect) {
-			pr_err("conflicting options: verity=%s,redirect_dir=%s\n",
-			       ovl_verity_mode(config), ovl_redirect_mode(config));
-			return -EINVAL;
-		}
+		if (set.metacopy && set.redirect)
+			return invalfc(fc, "conflicting options: metacopy=on,redirect_dir=%s",
+				       ovl_redirect_mode(config));
+		if (config->verity_mode && set.redirect)
+			return invalfc(fc, "conflicting options: verity=%s,redirect_dir=%s",
+				       ovl_verity_mode(config),
+				       ovl_redirect_mode(config));
+
 		if (set.redirect) {
 			/*
 			 * There was an explicit redirect_dir=... that resulted
 			 * in this conflict.
 			 */
-			pr_info("disabling metacopy due to redirect_dir=%s\n",
-				ovl_redirect_mode(config));
+			infofc(fc, "disabling metacopy due to redirect_dir=%s",
+			       ovl_redirect_mode(config));
 			config->metacopy = false;
 		} else {
 			/* Automatically enable redirect otherwise. */
@@ -829,17 +815,16 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	if (config->nfs_export && !config->index) {
 		if (!config->upperdir &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
-			pr_info("NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
+			infofc(fc, "NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off");
 			config->nfs_export = false;
 		} else if (set.nfs_export && set.index) {
-			pr_err("conflicting options: nfs_export=on,index=off\n");
-			return -EINVAL;
+			return invalfc(fc, "conflicting options: nfs_export=on,index=off");
 		} else if (set.index) {
 			/*
 			 * There was an explicit index=off that resulted
 			 * in this conflict.
 			 */
-			pr_info("disabling nfs_export due to index=off\n");
+			infofc(fc, "disabling nfs_export due to index=off");
 			config->nfs_export = false;
 		} else {
 			/* Automatically enable index otherwise. */
@@ -849,31 +834,29 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 
 	/* Resolve nfs_export -> !metacopy && !verity dependency */
 	if (config->nfs_export && config->metacopy) {
-		if (set.nfs_export && set.metacopy) {
-			pr_err("conflicting options: nfs_export=on,metacopy=on\n");
-			return -EINVAL;
-		}
+		if (set.nfs_export && set.metacopy)
+			return invalfc(fc, "conflicting options: nfs_export=on,metacopy=on");
 		if (set.metacopy) {
 			/*
 			 * There was an explicit metacopy=on that resulted
 			 * in this conflict.
 			 */
-			pr_info("disabling nfs_export due to metacopy=on\n");
+			infofc(fc, "disabling nfs_export due to metacopy=on");
 			config->nfs_export = false;
 		} else if (config->verity_mode) {
 			/*
 			 * There was an explicit verity=.. that resulted
 			 * in this conflict.
 			 */
-			pr_info("disabling nfs_export due to verity=%s\n",
-				ovl_verity_mode(config));
+			infofc(fc, "disabling nfs_export due to verity=%s",
+			       ovl_verity_mode(config));
 			config->nfs_export = false;
 		} else {
 			/*
 			 * There was an explicit nfs_export=on that resulted
 			 * in this conflict.
 			 */
-			pr_info("disabling metacopy due to nfs_export=on\n");
+			infofc(fc, "disabling metacopy due to nfs_export=on");
 			config->metacopy = false;
 		}
 	}
@@ -882,20 +865,14 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	/* Resolve userxattr -> !redirect && !metacopy && !verity dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
-		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
-			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
-			       ovl_redirect_mode(config));
-			return -EINVAL;
-		}
-		if (config->metacopy && set.metacopy) {
-			pr_err("conflicting options: userxattr,metacopy=on\n");
-			return -EINVAL;
-		}
-		if (config->verity_mode) {
-			pr_err("conflicting options: userxattr,verity=%s\n",
-			       ovl_verity_mode(config));
-			return -EINVAL;
-		}
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW)
+			return invalfc(fc, "conflicting options: userxattr,redirect_dir=%s",
+				       ovl_redirect_mode(config));
+		if (config->metacopy && set.metacopy)
+			return invalfc(fc, "conflicting options: userxattr,metacopy=on");
+		if (config->verity_mode)
+			return invalfc(fc, "conflicting options: userxattr,verity=%s",
+				       ovl_verity_mode(config));
 		/*
 		 * Silently disable default setting of redirect and metacopy.
 		 * This shall be the default in the future as well: these
@@ -934,10 +911,8 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		 */
 	}
 
-	if (ctx->nr_data > 0 && !config->metacopy) {
-		pr_err("lower data-only dirs require metacopy support.\n");
-		return -EINVAL;
-	}
+	if (ctx->nr_data > 0 && !config->metacopy)
+		return invalfc(fc, "lower data-only dirs require metacopy support");
 
 	return 0;
 }
diff --git a/fs/overlayfs/params.h b/fs/overlayfs/params.h
index c96d93982021..0ffe64277134 100644
--- a/fs/overlayfs/params.h
+++ b/fs/overlayfs/params.h
@@ -37,7 +37,6 @@ struct ovl_fs_context {
 
 int ovl_init_fs_context(struct fs_context *fc);
 void ovl_free_fs(struct ovl_fs *ofs);
-int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
-			 struct ovl_config *config);
+int ovl_fs_params_verify(struct fs_context *fc, struct ovl_config *config);
 int ovl_show_options(struct seq_file *m, struct dentry *dentry);
 const char *ovl_xino_mode(struct ovl_config *config);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fe511192f83c..69c6c25990ac 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -272,7 +272,7 @@ static const struct super_operations ovl_super_operations = {
 #define OVL_WORKDIR_NAME "work"
 #define OVL_INDEXDIR_NAME "index"
 
-static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
+static struct dentry *ovl_workdir_create(struct p_log *log, struct ovl_fs *ofs,
 					 const char *name, bool persist)
 {
 	struct inode *dir =  ofs->workbasedir->d_inode;
@@ -356,33 +356,33 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 out_dput:
 	dput(work);
 out_err:
-	pr_warn("failed to create directory %s/%s (errno: %i); mounting read-only\n",
-		ofs->config.workdir, name, -err);
+	warn_plog(log, "failed to create directory %s/%s (errno: %i); mounting read-only",
+		  ofs->config.workdir, name, -err);
 	work = NULL;
 	goto out_unlock;
 }
 
-static int ovl_check_namelen(const struct path *path, struct ovl_fs *ofs,
-			     const char *name)
+static int ovl_check_namelen(struct p_log *log, const struct path *path,
+			     struct ovl_fs *ofs, const char *name)
 {
 	struct kstatfs statfs;
 	int err = vfs_statfs(path, &statfs);
 
 	if (err)
-		pr_err("statfs failed on '%s'\n", name);
+		error_plog(log, "statfs failed on '%s'", name);
 	else
 		ofs->namelen = max(ofs->namelen, statfs.f_namelen);
 
 	return err;
 }
 
-static int ovl_lower_dir(const char *name, struct path *path,
+static int ovl_lower_dir(struct p_log *log, const char *name, struct path *path,
 			 struct ovl_fs *ofs, int *stack_depth)
 {
 	int fh_type;
 	int err;
 
-	err = ovl_check_namelen(path, ofs, name);
+	err = ovl_check_namelen(log, path, ofs, name);
 	if (err)
 		return err;
 
@@ -397,8 +397,8 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	     (ofs->config.index && ofs->config.upperdir)) && !fh_type) {
 		ofs->config.index = false;
 		ofs->config.nfs_export = false;
-		pr_warn("fs on '%s' does not support file handles, falling back to index=off,nfs_export=off.\n",
-			name);
+		warn_plog(log, "fs on '%s' does not support file handles, falling back to index=off,nfs_export=off",
+			  name);
 	}
 	ofs->nofh |= !fh_type;
 	/*
@@ -408,8 +408,8 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	if (ofs->config.xino == OVL_XINO_AUTO &&
 	    ofs->config.upperdir && !fh_type) {
 		ofs->config.xino = OVL_XINO_OFF;
-		pr_warn("fs on '%s' does not support file handles, falling back to xino=off.\n",
-			name);
+		warn_plog(log, "fs on '%s' does not support file handles, falling back to xino=off",
+			  name);
 	}
 
 	/* Check if lower fs has 32bit inode numbers */
@@ -433,8 +433,9 @@ static bool ovl_workdir_ok(struct dentry *workdir, struct dentry *upperdir)
 	return ok;
 }
 
-static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
-			  struct inode **ptrap, const char *name)
+static int ovl_setup_trap(struct p_log *log, struct super_block *sb,
+			  struct dentry *dir, struct inode **ptrap,
+			  const char *name)
 {
 	struct inode *trap;
 	int err;
@@ -443,7 +444,7 @@ static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
 	err = PTR_ERR_OR_ZERO(trap);
 	if (err) {
 		if (err == -ELOOP)
-			pr_err("conflicting %s path\n", name);
+			error_plog(log, "conflicting %s path", name);
 		return err;
 	}
 
@@ -457,21 +458,22 @@ static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
  * for example, an old overlay mount is leaked and now its upperdir is
  * attempted to be used as a lower layer in a new overlay mount.
  */
-static int ovl_report_in_use(struct ovl_fs *ofs, const char *name)
+static int ovl_report_in_use(struct p_log *log, struct ovl_fs *ofs,
+			     const char *name)
 {
 	if (ofs->config.index) {
-		pr_err("%s is in-use as upperdir/workdir of another mount, mount with '-o index=off' to override exclusive upperdir protection.\n",
-		       name);
+		error_plog(log, "%s is in-use as upperdir/workdir of another mount, mount with '-o index=off' to override exclusive upperdir protection.",
+			   name);
 		return -EBUSY;
 	} else {
-		pr_warn("%s is in-use as upperdir/workdir of another mount, accessing files from both mounts will result in undefined behavior.\n",
-			name);
+		warn_plog(log, "%s is in-use as upperdir/workdir of another mount, accessing files from both mounts will result in undefined behavior.",
+			  name);
 		return 0;
 	}
 }
 
-static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
-			 struct ovl_layer *upper_layer,
+static int ovl_get_upper(struct p_log *log, struct super_block *sb,
+			 struct ovl_fs *ofs, struct ovl_layer *upper_layer,
 			 const struct path *upperpath)
 {
 	struct vfsmount *upper_mnt;
@@ -479,16 +481,16 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 
 	/* Upperdir path should not be r/o */
 	if (__mnt_is_readonly(upperpath->mnt)) {
-		pr_err("upper fs is r/o, try multi-lower layers mount\n");
+		error_plog(log, "upper fs is r/o, try multi-lower layers mount");
 		err = -EINVAL;
 		goto out;
 	}
 
-	err = ovl_check_namelen(upperpath, ofs, ofs->config.upperdir);
+	err = ovl_check_namelen(log, upperpath, ofs, ofs->config.upperdir);
 	if (err)
 		goto out;
 
-	err = ovl_setup_trap(sb, upperpath->dentry, &upper_layer->trap,
+	err = ovl_setup_trap(log, sb, upperpath->dentry, &upper_layer->trap,
 			     "upperdir");
 	if (err)
 		goto out;
@@ -496,7 +498,7 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 	upper_mnt = clone_private_mount(upperpath);
 	err = PTR_ERR(upper_mnt);
 	if (IS_ERR(upper_mnt)) {
-		pr_err("failed to clone upperpath\n");
+		error_plog(log, "failed to clone upperpath");
 		goto out;
 	}
 
@@ -521,7 +523,7 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 	if (ovl_inuse_trylock(ovl_upper_mnt(ofs)->mnt_root)) {
 		ofs->upperdir_locked = true;
 	} else {
-		err = ovl_report_in_use(ofs, "upperdir");
+		err = ovl_report_in_use(log, ofs, "upperdir");
 		if (err)
 			goto out;
 	}
@@ -632,8 +634,8 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 	return 0;
 }
 
-static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
-			    const struct path *workpath)
+static int ovl_make_workdir(struct p_log *log, struct super_block *sb,
+			    struct ovl_fs *ofs, const struct path *workpath)
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *workdir;
@@ -647,14 +649,15 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		return err;
 
-	workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
+	workdir = ovl_workdir_create(log, ofs, OVL_WORKDIR_NAME, false);
 	err = PTR_ERR(workdir);
 	if (IS_ERR_OR_NULL(workdir))
 		goto out;
 
 	ofs->workdir = workdir;
 
-	err = ovl_setup_trap(sb, ofs->workdir, &ofs->workdir_trap, "workdir");
+	err = ovl_setup_trap(log, sb, ofs->workdir, &ofs->workdir_trap,
+			     "workdir");
 	if (err)
 		goto out;
 
@@ -670,7 +673,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	d_type = err;
 	if (!d_type)
-		pr_warn("upper fs needs to support d_type.\n");
+		warn_plog(log, "upper fs needs to support d_type");
 
 	/* Check if upper/work fs supports O_TMPFILE */
 	tmpfile = ovl_do_tmpfile(ofs, ofs->workdir, S_IFREG | 0);
@@ -678,7 +681,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (ofs->tmpfile)
 		fput(tmpfile);
 	else
-		pr_warn("upper fs does not support tmpfile.\n");
+		warn_plog(log, "upper fs does not support tmpfile");
 
 
 	/* Check if upper/work fs supports RENAME_WHITEOUT */
@@ -688,30 +691,30 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	rename_whiteout = err;
 	if (!rename_whiteout)
-		pr_warn("upper fs does not support RENAME_WHITEOUT.\n");
+		warn_plog(log, "upper fs does not support RENAME_WHITEOUT");
 
 	/*
 	 * Check if upper/work fs supports (trusted|user).overlay.* xattr
 	 */
 	err = ovl_setxattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE, "0", 1);
 	if (err) {
-		pr_warn("failed to set xattr on upper\n");
+		warn_plog(log, "failed to set xattr on upper");
 		ofs->noxattr = true;
 		if (ovl_redirect_follow(ofs)) {
 			ofs->config.redirect_mode = OVL_REDIRECT_NOFOLLOW;
-			pr_warn("...falling back to redirect_dir=nofollow.\n");
+			warn_plog(log, "...falling back to redirect_dir=nofollow");
 		}
 		if (ofs->config.metacopy) {
 			ofs->config.metacopy = false;
-			pr_warn("...falling back to metacopy=off.\n");
+			warn_plog(log, "...falling back to metacopy=off");
 		}
 		if (ofs->config.index) {
 			ofs->config.index = false;
-			pr_warn("...falling back to index=off.\n");
+			warn_plog(log, "...falling back to index=off");
 		}
 		if (ovl_has_fsid(ofs)) {
 			ofs->config.uuid = OVL_UUID_NULL;
-			pr_warn("...falling back to uuid=null.\n");
+			warn_plog(log, "...falling back to uuid=null");
 		}
 		/*
 		 * xattr support is required for persistent st_ino.
@@ -719,10 +722,10 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		 */
 		if (ofs->config.xino == OVL_XINO_AUTO) {
 			ofs->config.xino = OVL_XINO_OFF;
-			pr_warn("...falling back to xino=off.\n");
+			warn_plog(log, "...falling back to xino=off");
 		}
 		if (err == -EPERM && !ofs->config.userxattr)
-			pr_info("try mounting with 'userxattr' option\n");
+			info_plog(log, "try mounting with 'userxattr' option");
 		err = 0;
 	} else {
 		ovl_removexattr(ofs, ofs->workdir, OVL_XATTR_OPAQUE);
@@ -735,7 +738,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 */
 	if (ovl_dentry_remote(ofs->workdir) &&
 	    (!d_type || !rename_whiteout || ofs->noxattr)) {
-		pr_err("upper fs missing required features.\n");
+		error_plog(log, "upper fs missing required features");
 		err = -EINVAL;
 		goto out;
 	}
@@ -747,7 +750,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (ofs->config.ovl_volatile) {
 		err = ovl_create_volatile_dirty(ofs);
 		if (err < 0) {
-			pr_err("Failed to create volatile/dirty file.\n");
+			error_plog(log, "failed to create volatile/dirty file");
 			goto out;
 		}
 	}
@@ -756,7 +759,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
 	if (ofs->config.index && !fh_type) {
 		ofs->config.index = false;
-		pr_warn("upper fs does not support file handles, falling back to index=off.\n");
+		warn_plog(log, "upper fs does not support file handles, falling back to index=off");
 	}
 	ofs->nofh |= !fh_type;
 
@@ -766,7 +769,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	/* NFS export of r/w mount depends on index */
 	if (ofs->config.nfs_export && !ofs->config.index) {
-		pr_warn("NFS export requires \"index=on\", falling back to nfs_export=off.\n");
+		warn_plog(log, "NFS export requires \"index=on\", falling back to nfs_export=off.");
 		ofs->config.nfs_export = false;
 	}
 out:
@@ -774,42 +777,38 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	return err;
 }
 
-static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
-			   const struct path *upperpath,
+static int ovl_get_workdir(struct p_log *log, struct super_block *sb,
+			   struct ovl_fs *ofs, const struct path *upperpath,
 			   const struct path *workpath)
 {
 	int err;
 
-	err = -EINVAL;
-	if (upperpath->mnt != workpath->mnt) {
-		pr_err("workdir and upperdir must reside under the same mount\n");
-		return err;
-	}
-	if (!ovl_workdir_ok(workpath->dentry, upperpath->dentry)) {
-		pr_err("workdir and upperdir must be separate subtrees\n");
-		return err;
-	}
+	if (upperpath->mnt != workpath->mnt)
+		return inval_plog(log, "workdir and upperdir must reside under the same mount");
+	if (!ovl_workdir_ok(workpath->dentry, upperpath->dentry))
+		return inval_plog(log, "workdir and upperdir must be separate subtrees");
 
 	ofs->workbasedir = dget(workpath->dentry);
 
 	if (ovl_inuse_trylock(ofs->workbasedir)) {
 		ofs->workdir_locked = true;
 	} else {
-		err = ovl_report_in_use(ofs, "workdir");
+		err = ovl_report_in_use(log, ofs, "workdir");
 		if (err)
 			return err;
 	}
 
-	err = ovl_setup_trap(sb, ofs->workbasedir, &ofs->workbasedir_trap,
+	err = ovl_setup_trap(log, sb, ofs->workbasedir, &ofs->workbasedir_trap,
 			     "workdir");
 	if (err)
 		return err;
 
-	return ovl_make_workdir(sb, ofs, workpath);
+	return ovl_make_workdir(log, sb, ofs, workpath);
 }
 
-static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
-			    struct ovl_entry *oe, const struct path *upperpath)
+static int ovl_get_indexdir(struct p_log *log, struct super_block *sb,
+			    struct ovl_fs *ofs, struct ovl_entry *oe,
+			    const struct path *upperpath)
 {
 	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *indexdir;
@@ -828,7 +827,7 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 	/* Verify lower root is upper root origin */
 	err = ovl_verify_origin_fh(ofs, upperpath->dentry, fh, true);
 	if (err) {
-		pr_err("failed to verify upper root origin\n");
+		error_plog(log, "failed to verify upper root origin");
 		goto out;
 	}
 
@@ -837,12 +836,12 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 	ofs->workdir_trap = NULL;
 	dput(ofs->workdir);
 	ofs->workdir = NULL;
-	indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
+	indexdir = ovl_workdir_create(log, ofs, OVL_INDEXDIR_NAME, true);
 	if (IS_ERR(indexdir)) {
 		err = PTR_ERR(indexdir);
 	} else if (indexdir) {
 		ofs->workdir = indexdir;
-		err = ovl_setup_trap(sb, indexdir, &ofs->workdir_trap,
+		err = ovl_setup_trap(log, sb, indexdir, &ofs->workdir_trap,
 				     "indexdir");
 		if (err)
 			goto out;
@@ -861,18 +860,18 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 						      upperpath->dentry, true,
 						      false);
 			if (err)
-				pr_err("failed to verify index dir 'origin' xattr\n");
+				error_plog(log, "failed to verify index dir 'origin' xattr");
 		}
 		err = ovl_verify_upper(ofs, indexdir, upperpath->dentry, true);
 		if (err)
-			pr_err("failed to verify index dir 'upper' xattr\n");
+			error_plog(log, "failed to verify index dir 'upper' xattr");
 
 		/* Cleanup bad/stale/orphan index entries */
 		if (!err)
 			err = ovl_indexdir_cleanup(ofs);
 	}
 	if (err || !indexdir)
-		pr_warn("try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
+		error_plog(log, "try deleting index dir or mounting with '-o index=off' to disable inodes index");
 
 out:
 	mnt_drop_write(mnt);
@@ -917,7 +916,8 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 }
 
 /* Get a unique fsid for the layer */
-static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
+static int ovl_get_fsid(struct p_log *log, struct ovl_fs *ofs,
+			const struct path *path)
 {
 	struct super_block *sb = path->mnt->mnt_sb;
 	unsigned int i;
@@ -943,16 +943,17 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 			warn = true;
 		}
 		if (warn) {
-			pr_warn("%s uuid detected in lower fs '%pd2', falling back to xino=%s,index=off,nfs_export=off.\n",
-				uuid_is_null(&sb->s_uuid) ? "null" :
-							    "conflicting",
-				path->dentry, ovl_xino_mode(&ofs->config));
+			warn_plog(log,
+				  "%s uuid detected in lower fs '%pd2', falling back to xino=%s,index=off,nfs_export=off",
+				  uuid_is_null(&sb->s_uuid) ? "null" :
+							      "conflicting",
+				  path->dentry, ovl_xino_mode(&ofs->config));
 		}
 	}
 
 	err = get_anon_bdev(&dev);
 	if (err) {
-		pr_err("failed to get anonymous bdev for lowerpath\n");
+		error_plog(log, "failed to get anonymous bdev for lowerpath");
 		return err;
 	}
 
@@ -974,11 +975,12 @@ static int ovl_get_data_fsid(struct ovl_fs *ofs)
 
 
 static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
-			  struct ovl_fs_context *ctx, struct ovl_layer *layers)
+			  struct fs_context *fc, struct ovl_layer *layers)
 {
 	int err;
 	unsigned int i;
 	size_t nr_merged_lower;
+	struct ovl_fs_context *ctx = fc->fs_private;
 
 	ofs->fs = kcalloc(ctx->nr + 2, sizeof(struct ovl_sb), GFP_KERNEL);
 	if (ofs->fs == NULL)
@@ -998,7 +1000,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	 */
 	err = get_anon_bdev(&ofs->fs[0].pseudo_dev);
 	if (err) {
-		pr_err("failed to get anonymous bdev for upper fs\n");
+		errorfc(fc, "failed to get anonymous bdev for upper fs");
 		return err;
 	}
 
@@ -1015,7 +1017,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		int fsid;
 
 		if (i < nr_merged_lower)
-			fsid = ovl_get_fsid(ofs, &l->path);
+			fsid = ovl_get_fsid(&fc->log, ofs, &l->path);
 		else
 			fsid = ovl_get_data_fsid(ofs);
 		if (fsid < 0)
@@ -1028,12 +1030,13 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		 * the upperdir/workdir is in fact in-use by our
 		 * upperdir/workdir.
 		 */
-		err = ovl_setup_trap(sb, l->path.dentry, &trap, "lowerdir");
+		err = ovl_setup_trap(&fc->log, sb, l->path.dentry, &trap,
+				     "lowerdir");
 		if (err)
 			return err;
 
 		if (ovl_is_inuse(l->path.dentry)) {
-			err = ovl_report_in_use(ofs, "lowerdir");
+			err = ovl_report_in_use(&fc->log, ofs, "lowerdir");
 			if (err) {
 				iput(trap);
 				return err;
@@ -1043,7 +1046,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		mnt = clone_private_mount(&l->path);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
-			pr_err("failed to clone lowerpath\n");
+			errorfc(fc, "failed to clone lowerpath");
 			iput(trap);
 			return err;
 		}
@@ -1077,7 +1080,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	 */
 	if (ofs->numfs - !ovl_upper_mnt(ofs) == 1) {
 		if (ofs->config.xino == OVL_XINO_ON)
-			pr_info("\"xino=on\" is useless with all layers on same fs, ignore.\n");
+			infofc(fc, "\"xino=on\" is useless with all layers on same fs, ignore");
 		ofs->xino_mode = 0;
 	} else if (ofs->config.xino == OVL_XINO_OFF) {
 		ofs->xino_mode = -1;
@@ -1094,15 +1097,15 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	}
 
 	if (ofs->xino_mode > 0) {
-		pr_info("\"xino\" feature enabled using %d upper inode bits.\n",
-			ofs->xino_mode);
+		infofc(fc, "\"xino\" feature enabled using %d upper inode bits",
+		       ofs->xino_mode);
 	}
 
 	return 0;
 }
 
 static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
-					    struct ovl_fs_context *ctx,
+					    struct fs_context *fc,
 					    struct ovl_fs *ofs,
 					    struct ovl_layer *layers)
 {
@@ -1111,19 +1114,19 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	size_t nr_merged_lower;
 	struct ovl_entry *oe;
 	struct ovl_path *lowerstack;
+	struct ovl_fs_context *ctx = fc->fs_private;
 
 	struct ovl_fs_context_layer *l;
 
-	if (!ofs->config.upperdir && ctx->nr == 1) {
-		pr_err("at least 2 lowerdir are needed while upperdir nonexistent\n");
-		return ERR_PTR(-EINVAL);
-	}
+	if (!ofs->config.upperdir && ctx->nr == 1)
+		return ERR_PTR(invalfc(fc, "at least 2 lowerdir are needed while upperdir nonexistent"));
 
 	err = -EINVAL;
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];
 
-		err = ovl_lower_dir(l->name, &l->path, ofs, &sb->s_stack_depth);
+		err = ovl_lower_dir(&fc->log, l->name, &l->path, ofs,
+				    &sb->s_stack_depth);
 		if (err)
 			return ERR_PTR(err);
 	}
@@ -1131,11 +1134,11 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	err = -EINVAL;
 	sb->s_stack_depth++;
 	if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
-		pr_err("maximum fs stacking depth exceeded\n");
+		errorfc(fc, "maximum fs stacking depth exceeded");
 		return ERR_PTR(err);
 	}
 
-	err = ovl_get_layers(sb, ofs, ctx, layers);
+	err = ovl_get_layers(sb, ofs, fc, layers);
 	if (err)
 		return ERR_PTR(err);
 
@@ -1162,9 +1165,9 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
  * - another layer of this overlayfs instance
  * - upper/work dir of any overlayfs instance
  */
-static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
-			   struct dentry *dentry, const char *name,
-			   bool is_lower)
+static int ovl_check_layer(struct p_log *log, struct super_block *sb,
+			   struct ovl_fs *ofs, struct dentry *dentry,
+			   const char *name, bool is_lower)
 {
 	struct dentry *next = dentry, *parent;
 	int err = 0;
@@ -1178,9 +1181,9 @@ static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
 	while (!err && parent != next) {
 		if (is_lower && ovl_lookup_trap_inode(sb, parent)) {
 			err = -ELOOP;
-			pr_err("overlapping %s path\n", name);
+			error_plog(log, "overlapping %s path", name);
 		} else if (ovl_is_inuse(parent)) {
-			err = ovl_report_in_use(ofs, name);
+			err = ovl_report_in_use(log, ofs, name);
 		}
 		next = parent;
 		parent = dget_parent(next);
@@ -1195,13 +1198,15 @@ static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
 /*
  * Check if any of the layers or work dirs overlap.
  */
-static int ovl_check_overlapping_layers(struct super_block *sb,
+static int ovl_check_overlapping_layers(struct p_log *log,
+					struct super_block *sb,
 					struct ovl_fs *ofs)
 {
 	int i, err;
 
 	if (ovl_upper_mnt(ofs)) {
-		err = ovl_check_layer(sb, ofs, ovl_upper_mnt(ofs)->mnt_root,
+		err = ovl_check_layer(log, sb, ofs,
+				      ovl_upper_mnt(ofs)->mnt_root,
 				      "upperdir", false);
 		if (err)
 			return err;
@@ -1213,14 +1218,14 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 		 * workbasedir.  In that case, we already have their traps in
 		 * inode cache and we will catch that case on lookup.
 		 */
-		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir",
-				      false);
+		err = ovl_check_layer(log, sb, ofs, ofs->workbasedir,
+				      "workdir", false);
 		if (err)
 			return err;
 	}
 
 	for (i = 1; i < ofs->numlayer; i++) {
-		err = ovl_check_layer(sb, ofs,
+		err = ovl_check_layer(log, sb, ofs,
 				      ofs->layers[i].mnt->mnt_root,
 				      "lowerdir", true);
 		if (err)
@@ -1304,14 +1309,14 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!cred)
 		goto out_err;
 
-	err = ovl_fs_params_verify(ctx, &ofs->config);
+	err = ovl_fs_params_verify(fc, &ofs->config);
 	if (err)
 		goto out_err;
 
 	err = -EINVAL;
 	if (ctx->nr == 0) {
 		if (!(fc->sb_flags & SB_SILENT))
-			pr_err("missing 'lowerdir'\n");
+			errorfc(fc, "missing 'lowerdir'");
 		goto out_err;
 	}
 
@@ -1342,7 +1347,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (ofs->config.xino != OVL_XINO_OFF) {
 		ofs->xino_mode = BITS_PER_LONG - 32;
 		if (!ofs->xino_mode) {
-			pr_warn("xino not supported on 32bit kernel, falling back to xino=off.\n");
+			warnfc(fc, "xino not supported on 32bit kernel, falling back to xino=off");
 			ofs->config.xino = OVL_XINO_OFF;
 		}
 	}
@@ -1355,11 +1360,11 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 
 		err = -EINVAL;
 		if (!ofs->config.workdir) {
-			pr_err("missing 'workdir'\n");
+			errorfc(fc, "missing 'workdir'");
 			goto out_err;
 		}
 
-		err = ovl_get_upper(sb, ofs, &layers[0], &ctx->upper);
+		err = ovl_get_upper(&fc->log, sb, ofs, &layers[0], &ctx->upper);
 		if (err)
 			goto out_err;
 
@@ -1368,12 +1373,13 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 			ofs->errseq = errseq_sample(&upper_sb->s_wb_err);
 			if (errseq_check(&upper_sb->s_wb_err, ofs->errseq)) {
 				err = -EIO;
-				pr_err("Cannot mount volatile when upperdir has an unseen error. Sync upperdir fs to clear state.\n");
+				errorfc(fc, "Cannot mount volatile when upperdir has an unseen error. Sync upperdir fs to clear state.");
 				goto out_err;
 			}
 		}
 
-		err = ovl_get_workdir(sb, ofs, &ctx->upper, &ctx->work);
+		err = ovl_get_workdir(&fc->log, sb, ofs,
+				      &ctx->upper, &ctx->work);
 		if (err)
 			goto out_err;
 
@@ -1383,7 +1389,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 		sb->s_stack_depth = upper_sb->s_stack_depth;
 		sb->s_time_gran = upper_sb->s_time_gran;
 	}
-	oe = ovl_get_lowerstack(sb, ctx, ofs, layers);
+	oe = ovl_get_lowerstack(sb, fc, ofs, layers);
 	err = PTR_ERR(oe);
 	if (IS_ERR(oe))
 		goto out_err;
@@ -1393,7 +1399,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 		sb->s_flags |= SB_RDONLY;
 
 	if (!ovl_origin_uuid(ofs) && ofs->numfs > 1) {
-		pr_warn("The uuid=off requires a single fs for lower and upper, falling back to uuid=null.\n");
+		warnfc(fc, "The uuid=off requires a single fs for lower and upper, falling back to uuid=null.");
 		ofs->config.uuid = OVL_UUID_NULL;
 	} else if (ovl_has_fsid(ofs) && ovl_upper_mnt(ofs)) {
 		/* Use per instance persistent uuid/fsid */
@@ -1401,7 +1407,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 
 	if (!ovl_force_readonly(ofs) && ofs->config.index) {
-		err = ovl_get_indexdir(sb, ofs, oe, &ctx->upper);
+		err = ovl_get_indexdir(&fc->log, sb, ofs, oe, &ctx->upper);
 		if (err)
 			goto out_free_oe;
 
@@ -1410,7 +1416,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 			sb->s_flags |= SB_RDONLY;
 	}
 
-	err = ovl_check_overlapping_layers(sb, ofs);
+	err = ovl_check_overlapping_layers(&fc->log, sb, ofs);
 	if (err)
 		goto out_free_oe;
 
@@ -1418,13 +1424,13 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!ofs->workdir) {
 		ofs->config.index = false;
 		if (ovl_upper_mnt(ofs) && ofs->config.nfs_export) {
-			pr_warn("NFS export requires an index dir, falling back to nfs_export=off.\n");
+			warnfc(fc, "NFS export requires an index dir, falling back to nfs_export=off.");
 			ofs->config.nfs_export = false;
 		}
 	}
 
 	if (ofs->config.metacopy && ofs->config.nfs_export) {
-		pr_warn("NFS export is not supported with metadata only copy up, falling back to nfs_export=off.\n");
+		warnfc(fc, "NFS export is not supported with metadata only copy up, falling back to nfs_export=off.");
 		ofs->config.nfs_export = false;
 	}
 

---
base-commit: 59b723cd2adbac2a34fc8e12c74ae26ae45bf230
change-id: 20241106-overlayfs-fsopen-log-e64f175203ba

Best regards,
-- 
Aleksa Sarai <cyphar@cyphar.com>

