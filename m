Return-Path: <SRS0=0kBH=DA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B33C2D0A8
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 13:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7C8A21BE5
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 13:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgIWNol (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:44:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:57826 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgIWNok (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 09:44:40 -0400
X-Greylist: delayed 3226 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2020 09:44:37 EDT
Received: from [192.168.15.198] (helo=snorch.sw.ru)
        by relay3.sw.ru with esmtp (Exim 4.94)
        (envelope-from <ptikhomirov@virtuozzo.com>)
        id 1kL4Dz-000pYm-D6; Wed, 23 Sep 2020 15:50:19 +0300
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ovl: introduce new "index=nouuid" option for inodes index feature
Date:   Wed, 23 Sep 2020 15:50:14 +0300
Message-Id: <20200923125014.181931-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This relaxes uuid checks for overlay index feature. It is only possible
in case there is only one filesystem for all the work/upper/lower
directories and bare file handles from this backing filesystem are uniq.
In case we have multiple filesystems here just fall back to normal
"index=on".

This is needed when overlayfs is/was mounted in a container with
index enabled (e.g.: to be able to resolve inotify watch file handles on
it to paths in CRIU), and this container is copied and started alongside
with the original one. This way the "copy" container can't have the same
uuid on the superblock and mounting the overlayfs from it later would
fail.

That is an example of the problem on top of loop+ext4:

dd if=/dev/zero of=loopbackfile.img bs=100M count=10
losetup -fP loopbackfile.img
losetup -a
  #/dev/loop0: [64768]:35 (/loop-test/loopbackfile.img)
mkfs.ext4 /root/loopbackfile.img
mkdir loop-mp
mount -o loop /dev/loop0 loop-mp
mkdir loop-mp/{lower,upper,work,merged}
mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
umount loop-mp/merged
umount loop-mp
e2fsck -f /dev/loop0
tune2fs -U random /dev/loop0

mount -o loop /dev/loop0 loop-mp
mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
  #mount: /loop-test/loop-mp/merged:
  #mount(2) system call failed: Stale file handle.

If you just change the uuid of the backing filesystem, overlay is not
mounting any more. In Virtuozzo we copy container disks (ploops) when
crate the copy of container and we require fs uuid to be uniq for a new
container.

CC: Amir Goldstein <amir73il@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-unionfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 fs/overlayfs/Kconfig     | 16 ++++++++++++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/super.c     | 56 ++++++++++++++++++++++++++++++----------
 3 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index dd188c7996b3..b00fd44006f9 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -61,6 +61,22 @@ config OVERLAY_FS_INDEX
 
 	  If unsure, say N.
 
+config OVERLAY_FS_INDEX_NOUUID
+	bool "Overlayfs: relax uuid checks of inodes index feature"
+	depends on OVERLAY_FS
+	depends on OVERLAY_FS_INDEX
+	help
+	  If this config option is enabled then overlay will skip uuid checks
+	  for index lower to upper inode map, this only can be done if all
+	  upper and lower directories are on the same filesystem where basic
+	  fhandles are uniq.
+
+	  It is needed to overcome possible change of uuid on superblock of the
+	  backing filesystem, e.g. when you copied the virtual disk and mount
+	  both the copy of the disk and the original one at the same time.
+
+	  If unsure, say N.
+
 config OVERLAY_FS_NFS_EXPORT
 	bool "Overlayfs: turn on NFS export feature by default"
 	depends on OVERLAY_FS
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b429c80879ee..2fd2cc515ad2 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -13,7 +13,7 @@ struct ovl_config {
 	bool redirect_dir;
 	bool redirect_follow;
 	const char *redirect_mode;
-	bool index;
+	int index;
 	bool nfs_export;
 	int xino;
 	bool metacopy;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4b38141c2985..617a5083e659 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -38,10 +38,16 @@ module_param_named(redirect_always_follow, ovl_redirect_always_follow,
 MODULE_PARM_DESC(redirect_always_follow,
 		 "Follow redirects even if redirect_dir feature is turned off");
 
-static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
-module_param_named(index, ovl_index_def, bool, 0644);
+#define OVL_INDEX_OFF          0
+#define OVL_INDEX_ON           1
+#define OVL_INDEX_NOUUID       2
+
+static int ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX_NOUUID) ?
+			   OVL_INDEX_NOUUID :
+			   IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
+module_param_named(index, ovl_index_def, int, 0644);
 MODULE_PARM_DESC(index,
-		 "Default to on or off for the inodes index feature");
+		 "Default to on, off or nouuid for the inodes index feature");
 
 static bool ovl_nfs_export_def = IS_ENABLED(CONFIG_OVERLAY_FS_NFS_EXPORT);
 module_param_named(nfs_export, ovl_nfs_export_def, bool, 0644);
@@ -352,8 +358,18 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_puts(m, ",default_permissions");
 	if (strcmp(ofs->config.redirect_mode, ovl_redirect_mode_def()) != 0)
 		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
-	if (ofs->config.index != ovl_index_def)
-		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
+	if (ofs->config.index != ovl_index_def) {
+		switch (ofs->config.index) {
+		case OVL_INDEX_OFF:
+			seq_puts(m, ",index=off");
+			break;
+		case OVL_INDEX_NOUUID:
+			seq_puts(m, ",index=nouuid");
+			break;
+		default:
+			seq_puts(m, ",index=on");
+		}
+	}
 	if (ofs->config.nfs_export != ovl_nfs_export_def)
 		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
 						"on" : "off");
@@ -404,6 +420,7 @@ enum {
 	OPT_REDIRECT_DIR,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_INDEX_NOUUID,
 	OPT_NFS_EXPORT_ON,
 	OPT_NFS_EXPORT_OFF,
 	OPT_XINO_ON,
@@ -422,6 +439,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR,		"redirect_dir=%s"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_INDEX_NOUUID,		"index=nouuid"},
 	{OPT_NFS_EXPORT_ON,		"nfs_export=on"},
 	{OPT_NFS_EXPORT_OFF,		"nfs_export=off"},
 	{OPT_XINO_ON,			"xino=on"},
@@ -532,12 +550,17 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			break;
 
 		case OPT_INDEX_ON:
-			config->index = true;
+			config->index = OVL_INDEX_ON;
 			index_opt = true;
 			break;
 
 		case OPT_INDEX_OFF:
-			config->index = false;
+			config->index = OVL_INDEX_OFF;
+			index_opt = true;
+			break;
+
+		case OPT_INDEX_NOUUID:
+			config->index = OVL_INDEX_NOUUID;
 			index_opt = true;
 			break;
 
@@ -592,7 +615,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			pr_info("option \"index=on\" is useless in a non-upper mount, ignore\n");
 			index_opt = false;
 		}
-		config->index = false;
+		config->index = OVL_INDEX_OFF;
 	}
 
 	err = ovl_parse_redirect_mode(config, config->redirect_mode);
@@ -644,7 +667,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->nfs_export = false;
 		} else {
 			/* Automatically enable index otherwise. */
-			config->index = true;
+			config->index = OPT_INDEX_ON;
 		}
 	}
 
@@ -859,7 +882,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	fh_type = ovl_can_decode_fh(path->dentry->d_sb);
 	if ((ofs->config.nfs_export ||
 	     (ofs->config.index && ofs->config.upperdir)) && !fh_type) {
-		ofs->config.index = false;
+		ofs->config.index = OVL_INDEX_OFF;
 		ofs->config.nfs_export = false;
 		pr_warn("fs on '%s' does not support file handles, falling back to index=off,nfs_export=off.\n",
 			name);
@@ -1259,7 +1282,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	err = ovl_do_setxattr(ofs->workdir, OVL_XATTR_OPAQUE, "0", 1, 0);
 	if (err) {
 		ofs->noxattr = true;
-		ofs->config.index = false;
+		ofs->config.index = OPT_INDEX_OFF;
 		ofs->config.metacopy = false;
 		pr_warn("upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
 		err = 0;
@@ -1282,7 +1305,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	/* Check if upper/work fs supports file handles */
 	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
 	if (ofs->config.index && !fh_type) {
-		ofs->config.index = false;
+		ofs->config.index = OVL_INDEX_OFF;
 		pr_warn("upper fs does not support file handles, falling back to index=off.\n");
 	}
 
@@ -1458,7 +1481,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
 		bad_uuid = true;
 		if (ofs->config.index || ofs->config.nfs_export) {
-			ofs->config.index = false;
+			ofs->config.index = OVL_INDEX_OFF;
 			ofs->config.nfs_export = false;
 			pr_warn("%s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
 				uuid_is_null(&sb->s_uuid) ? "null" :
@@ -1889,9 +1912,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto out_free_oe;
 
+	if (ofs->config.index == OVL_INDEX_NOUUID && ofs->numfs > 1) {
+		pr_warn("The index=nouuid requires a single fs for lower and upper, falling back to index=on.\n");
+		ofs->config.index = OVL_INDEX_ON;
+	}
+
 	/* Show index=off in /proc/mounts for forced r/o mount */
 	if (!ofs->indexdir) {
-		ofs->config.index = false;
+		ofs->config.index = OVL_INDEX_OFF;
 		if (ovl_upper_mnt(ofs) && ofs->config.nfs_export) {
 			pr_warn("NFS export requires an index dir, falling back to nfs_export=off.\n");
 			ofs->config.nfs_export = false;
-- 
2.26.2

