Return-Path: <michael.weiss@aisec.fraunhofer.de>
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
Subject: [PATCH] ovl: Introduce mount option hide_paths
Date: Wed, 10 Apr 2019 12:01:51 +0200
Message-Id: <20190410100150.13939-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
List-ID: <linux-unionfs@vger.kernel.org>

Currently, if an overlayfs is mounted, the path names of lowerdir,
upperdir and workdir are visible in /proc/<pid>/mounts and so on.

However, in namespaced environments, e.g., lxc or docker, the
path names leak information of the host's directory structure.

With the new mount option 'hide_paths' this information is not shown
in proc anymore.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---

Hi Folks,

while implementing some os level virtulization framework using overlayfs
to craft my rootfs for a container, I realized that the fsoptions
shown in /proc/<pid>/mounts remain the same after a move mount.
Thus, in the new mount namespace of the container the former paths
of the root namespace used to craft the rootfs are leaked to the
container.

I think this is also useful for those Docker or LXC guys to allow using
their container runtimes in more security related use cases.

Cheers,
Michael

 Documentation/filesystems/overlayfs.txt | 16 ++++++++++++++++
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 19 ++++++++++++++-----
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index eef7d9d259e8..ec615e8932a8 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -469,6 +469,22 @@ verified on mount time to check that upper file handles are not stale.
 This verification may cause significant overhead in some cases.
 
 
+Hiding path information
+-----------------------
+
+In namespace environments, it can be required to hide information
+about the host's overlay structure for a mountpoint.
+
+E.g., if a rootfs is build by overlaying several read-only and a writable
+path and a move mount to the mountpoint is performed later for a mount
+namespace, then the options for lowerdir,upperdir and workdir includes the
+original path names. After a chroot these paths are even not existing anymore.
+
+However, /proc/<pid>/mounts will show the obsolete information in that case.
+To avoid this information leakage, the mount option "hide_paths" can be used to
+remove the path related options from the relevant proc files.
+
+
 Testsuite
 ---------
 
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ec237035333a..00abcef6fb30 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -20,6 +20,7 @@ struct ovl_config {
 	bool nfs_export;
 	int xino;
 	bool metacopy;
+	bool hide_paths;
 };
 
 struct ovl_sb {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0116735cc321..195a84dbbd94 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -24,7 +24,6 @@ MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
 
-
 struct ovl_dir_cache;
 
 #define OVL_MAX_STACK 500
@@ -343,10 +342,14 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ofs = sb->s_fs_info;
 
-	seq_show_option(m, "lowerdir", ofs->config.lowerdir);
-	if (ofs->config.upperdir) {
-		seq_show_option(m, "upperdir", ofs->config.upperdir);
-		seq_show_option(m, "workdir", ofs->config.workdir);
+	if (ofs->config.hide_paths) {
+		seq_puts(m, ",hide_paths");
+	} else {
+		seq_show_option(m, "lowerdir", ofs->config.lowerdir);
+		if (ofs->config.upperdir) {
+			seq_show_option(m, "upperdir", ofs->config.upperdir);
+			seq_show_option(m, "workdir", ofs->config.workdir);
+		}
 	}
 	if (ofs->config.default_permissions)
 		seq_puts(m, ",default_permissions");
@@ -401,6 +404,7 @@ enum {
 	OPT_XINO_AUTO,
 	OPT_METACOPY_ON,
 	OPT_METACOPY_OFF,
+	OPT_HIDE_PATHS,
 	OPT_ERR,
 };
 
@@ -419,6 +423,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_XINO_AUTO,			"xino=auto"},
 	{OPT_METACOPY_ON,		"metacopy=on"},
 	{OPT_METACOPY_OFF,		"metacopy=off"},
+	{OPT_HIDE_PATHS,		"hide_paths"},
 	{OPT_ERR,			NULL}
 };
 
@@ -557,6 +562,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->metacopy = false;
 			break;
 
+		case OPT_HIDE_PATHS:
+			config->hide_paths = true;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
-- 
2.20.1
