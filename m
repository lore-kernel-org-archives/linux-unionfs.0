From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
Date: Fri, 14 Nov 2014 09:55:11 +0100
Message-ID: <20141114095511.789a76ac@gmail.com>
References: <20141107170242.GA333@tucsk>
	<20141108192723.444cecd2@gmail.com>
	<20141110090954.GB333@tucsk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/p_vrJLhdahIXUlaTpGM6w0h"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141110090954.GB333@tucsk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "A. Wan" <jm@mokwan.com>, Patrick Frisch <patrick@frischux.de>, Aaron Campbell <aaron@arbor.net>
List-Id: linux-unionfs@vger.kernel.org

--MP_/p_vrJLhdahIXUlaTpGM6w0h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

EL Mon, 10 Nov 2014 10:09:54 +0100
Miklos Szeredi <miklos@szeredi.hu> escrigu=C3=A9:

> Maybe it wasn't clear, but the number of lower layers isn't limited by
> FILESYSTEM_MAX_STACK_DEPTH,=20
sorry, you have been clear, it's me that have not explained the purpose
of that patch. This idea is also valid for the main overlayfs
development.
Consider that we have an encrypted partition and a live OS that
uses overlayfs and works over it, when the OS is started already
reaches the maximum stacking depth (2). Also, hardcoding parameters
into the code may be annoying because a change implies creating and
mantaining patches, otherwise when the parameter is configurable we can
change it in a config value.

Also, I include a patch to explain better my first statement,
would say lowerdirs has extended the functionality of lowerdir,
therefore we can discard the lowerdir case that only works with one
lower layer and rename lowerdirs to lowerdir. It's more simple and all
the functionality is preserved.=20
Regards,

Jordi Pujol


--MP_/p_vrJLhdahIXUlaTpGM6w0h
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=23-overlayfs_discard_specifically_support_only_one_read-only_layer.patch.txt

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c	2014-11-12 10:23:54.285960418 +0100
@@ -29,7 +29,6 @@ MODULE_VERSION(OVERLAYFS_VERSION);
 
 struct ovl_config {
 	char *lowerdir;
-	char *lowerdirs;
 	char *upperdir;
 	char *workdir;
 };
@@ -497,8 +496,6 @@ static int ovl_show_options(struct seq_f
 
 	if (ufs->config.lowerdir)
 		seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
-	if (ufs->config.lowerdirs)
-		seq_printf(m, ",lowerdirs=%s", ufs->config.lowerdirs);
 	if (ufs->config.upperdir) {
 		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
 		seq_printf(m, ",workdir=%s", ufs->config.workdir);
@@ -522,7 +519,6 @@ enum {
 
 static const match_table_t ovl_tokens = {
 	{OPT_LOWERDIR,			"lowerdir=%s"},
-	{OPT_LOWERDIRS,			"lowerdirs=%s"},
 	{OPT_UPPERDIR,			"upperdir=%s"},
 	{OPT_WORKDIR,			"workdir=%s"},
 	{OPT_ERR,			NULL}
@@ -555,13 +551,6 @@ static int ovl_parse_opt(char *opt, stru
 				return -ENOMEM;
 			break;
 
-		case OPT_LOWERDIRS:
-			kfree(config->lowerdirs);
-			config->lowerdirs = match_strdup(&args[0]);
-			if (!config->lowerdirs)
-				return -ENOMEM;
-			break;
-
 		case OPT_WORKDIR:
 			kfree(config->workdir);
 			config->workdir = match_strdup(&args[0]);
@@ -718,24 +707,18 @@ static int ovl_fill_super(struct super_b
 		goto out_free_config;
 
 	err = -EINVAL;
-	if (ufs->config.lowerdir && ufs->config.lowerdirs) {
-		pr_err("overlayfs: both 'lowerdir' and 'lowerdirs' not allowed\n");
-		goto out_free_config;
-	}
 	if (ufs->config.upperdir && !ufs->config.workdir) {
 		pr_err("overlayfs: missing 'workdir'\n");
 		goto out_free_config;
 	}
 	if (!ufs->config.upperdir &&
-	    !ufs->config.lowerdir && !ufs->config.lowerdirs) {
-		pr_err("overlayfs: no 'upperdir', 'lowerdir' or 'lowerdirs' specified\n");
+	    !ufs->config.lowerdir) {
+		pr_err("overlayfs: no 'upperdir' or 'lowerdir' specified\n");
 		goto out_free_config;
 	}
 
 	if (ufs->config.lowerdir) {
-		stacklen = 1;
-	} else if (ufs->config.lowerdirs) {
-		char *p = ufs->config.lowerdirs;
+		char *p = ufs->config.lowerdir;
 
 		for (;;) {
 			stacklen++;
@@ -780,15 +763,7 @@ static int ovl_fill_super(struct super_b
 	}
 
 	if (ufs->config.lowerdir) {
-		BUG_ON(numlower >= stacklen);
-
-		err = ovl_lower_dir(ufs->config.lowerdir, &stack[numlower], &ufs->lower_namelen, &sb->s_stack_depth);
-		if (err)
-			goto out_put_workpath;
-
-		numlower++;
-	} else if (ufs->config.lowerdirs) {
-		char *p = ufs->config.lowerdirs;
+		char *p = ufs->config.lowerdir;
 
 		for (;;) {
 			char *next = strchr(p, ':');

--MP_/p_vrJLhdahIXUlaTpGM6w0h--
