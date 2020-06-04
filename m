Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1A1C433DF
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 16:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73E720738
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 16:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgFDQNH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:13:07 -0400
Received: from relay.sw.ru ([185.231.240.75]:35432 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729745AbgFDQNF (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 12:13:05 -0400
Received: from [172.16.25.93] (helo=amikhalitsyn-pc0.sw.ru)
        by relay3.sw.ru with esmtp (Exim 4.93)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1jgsUC-0003Zt-U1; Thu, 04 Jun 2020 19:12:56 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     miklos@szeredi.hu
Cc:     avagin@openvz.org, ptikhomirov@virtuozzo.com,
        khorenko@virtuozzo.com, vvs@virtuozzo.com, ktkhai@virtuozzo.com,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] overlayfs: add mnt_id paths options
Date:   Thu,  4 Jun 2020 19:11:33 +0300
Message-Id: <20200604161133.20949-3-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This patch adds config OVERLAY_FS_PATH_OPTIONS_MNT_ID
compile-time option, and "mnt_id_path_opts" runtime module option.
If enabled, user may see mnt_ids for lowerdir, upperdir paths
in mountinfo in separate lowerdir_mnt_id/upperdir_mnt_id options.

This patch is very helpful to checkpoint/restore functionality
of overlayfs mounts in case when we have overmounts on
lowerdir, workdir, upperdir paths.

Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 fs/overlayfs/Kconfig     | 26 ++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/super.c     | 15 +++++++++++++++
 fs/overlayfs/util.c      | 21 +++++++++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index c24988527ef3..2797869c8d16 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -154,4 +154,30 @@ config OVERLAY_FS_DYNAMIC_RESOLVE_PATH_OPTIONS
 
 	  For more information, see Documentation/filesystems/overlayfs.txt
 
+	  If unsure, say N.
+
+config OVERLAY_FS_PATH_OPTIONS_MNT_ID
+	bool "Overlayfs: show mnt_id for all mount paths options"
+	default y
+	depends on OVERLAY_FS
+	help
+	  This option helps checkpoint/restore of overlayfs mounts.
+	  If N selected, old behavior is saved.
+
+	  If this config option is enabled then in overlay filesystems mount
+	  options you will be able to see additional parameters lowerdir_mnt_id/
+	  upperdir_mnt_id with corresponding mnt_ids.
+
+	  It's also possible to change this behavior on overlayfs module loading or
+	  through sysfs (mnt_id_path_opts parameter).
+
+	  Disable this to get a backward compatible with previous kernels configuration,
+	  but in this case checkpoint/restore functionality for overlayfs mounts
+	  may not fully work.
+
+	  If backward compatibility is not an issue, then it is safe and
+	  recommended to say Y here.
+
+	  For more information, see Documentation/filesystems/overlayfs.txt
+
 	  If unsure, say N.
\ No newline at end of file
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8722ed556e11..980fe06d15b5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -305,6 +305,8 @@ ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
 void print_path_option(struct seq_file *m, const char *name, struct path *path);
 void print_paths_option(struct seq_file *m, const char *name,
 			struct path *paths, unsigned int num);
+void print_mnt_id_option(struct seq_file *m, const char *name, struct path *path);
+void print_mnt_ids_option(struct seq_file *m, const char *name,
 			struct path *paths, unsigned int num);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a449b6bb4b20..ee2ed125341c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -57,6 +57,10 @@ static bool ovl_dyn_path_opts = IS_ENABLED(CONFIG_OVERLAY_FS_DYNAMIC_RESOLVE_PAT
 module_param_named(dyn_path_opts, ovl_dyn_path_opts, bool, 0644);
 MODULE_PARM_DESC(dyn_path_opts, "dyn_path_opts feature enabled");
 
+static bool ovl_mnt_id_path_opts = IS_ENABLED(OVERLAY_FS_PATH_OPTIONS_MNT_ID);
+module_param_named(mnt_id_path_opts, ovl_mnt_id_path_opts, bool, 0644);
+MODULE_PARM_DESC(mnt_id_path_opts, "mnt_id_path_opts feature enabled");
+
 static void ovl_entry_stack_free(struct ovl_entry *oe)
 {
 	unsigned int i;
@@ -362,6 +366,17 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 			seq_show_option(m, "workdir", ofs->config.workdir);
 		}
 	}
+
+	if (ovl_mnt_id_path_opts) {
+		print_mnt_ids_option(m, "lowerdir_mnt_id", ofs->lowerpaths, ofs->numlayer);
+		/*
+		 * We don't need to show mnt_id for workdir because it
+		 * on the same mount as upperdir.
+		 */
+		if (ofs->config.upperdir)
+			print_mnt_id_option(m, "upperdir_mnt_id", &ofs->upperpath);
+	}
+
 	if (ofs->config.default_permissions)
 		seq_puts(m, ",default_permissions");
 	if (strcmp(ofs->config.redirect_mode, ovl_redirect_mode_def()) != 0)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 36bb98c14d35..85106b2ed00a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -14,6 +14,7 @@
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
 #include <linux/seq_file.h>
+#include "../mount.h"
 #include "overlayfs.h"
 
 int ovl_want_write(struct dentry *dentry)
@@ -941,3 +942,23 @@ void print_paths_option(struct seq_file *m, const char *name,
 		seq_path(m, &paths[i], ", \t\n\\");
 	}
 }
+
+void print_mnt_id_option(struct seq_file *m, const char *name, struct path *path)
+{
+	seq_show_option(m, name, "");
+	seq_printf(m, "%i", real_mount(path->mnt)->mnt_id);
+}
+
+void print_mnt_ids_option(struct seq_file *m, const char *name,
+			struct path *paths, unsigned int num)
+{
+	int i;
+
+	seq_show_option(m, name, "");
+
+	for (i = 0; i < num; i++) {
+		if (i)
+			seq_putc(m, ':');
+		seq_printf(m, "%i", real_mount(paths[i].mnt)->mnt_id);
+	}
+}
-- 
2.17.1

