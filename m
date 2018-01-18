From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v4 5/5] fsck.overlay: add impure xattr check
Date: Thu, 18 Jan 2018 11:50:56 +0800
Message-ID: <20180118035056.17358-6-yi.zhang@huawei.com>
References: <20180118035056.17358-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4245 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754129AbeARDoD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jan 2018 22:44:03 -0500
In-Reply-To: <20180118035056.17358-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com, yizhang089@gmail.com

An impure directory is a directory with "trusted.overlay.impure" xattr
valued 'y', which indicate that this directory may contain copied up
targets from lower layers.
If a target copy-up from lower to upper layer, it's 'd_ino'
(see getdents(2)) will change from lower's 'd_ino' to upper's (a new
inode will be created in upper layer). So the impure xattr should be
set to the parent directory to prompt overlay filesystem to get and
return the origin 'd_ino', thus ensuring the consistentcy of 'd_ino'.

There are three situations of setting impure xattr in overlay
filesystem:
1) Copy-up lower target in a directory.
2) Link an origin target (already copied up, have origin xattr) into a
   directory.
3) Rename an origin target (include merge subdirectories) into a new
   directory.

So, the impure xattr should be set if a direcotry contains origin
targets or redirect/merge subdirectories. If not, fix the impure xattr.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 README.md | 22 ++++++++++++++++++
 check.c   | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 lib.c     |  5 ++++
 lib.h     |  3 +++
 4 files changed, 102 insertions(+), 6 deletions(-)

diff --git a/README.md b/README.md
index da6c48c..56aae66 100644
--- a/README.md
+++ b/README.md
@@ -44,6 +44,28 @@ If not,
 3) Record redirect xattrs but not sure which one is invalid, ask user by
    default and warn in auto mode.
 
+Impure directories
+------------------
+
+An impure directory is a directory with "trusted.overlay.impure" xattr valued
+'y', which indicate that this directory may contain copied up targets from lower
+layers.
+If a target copy-up from lower to upper layer, it's 'd_ino' (see getdents(2))
+will change from lower's 'd_ino' to upper's (a new inode will be created in
+upper layer). So the impure xattr should be set to the parent directory to
+prompt overlay filesystem to get and return the origin 'd_ino', thus ensuring
+the consistentcy of 'd_ino'.
+
+There are three situations of setting impure xattr in overlay filesystem:
+1) Copy-up lower target in a directory.
+2) Link an origin target (already copied up, have origin xattr) into a
+   directory.
+3) Rename an origin target (include merge subdirectories) into a new
+   directory.
+
+So, the impure xattr should be set if a direcotry contains origin targets or
+redirect/merge subdirectories. If not, fix the impure xattr.
+
 Usage
 =====
 
diff --git a/check.c b/check.c
index f0b3ff4..ca7cd88 100644
--- a/check.c
+++ b/check.c
@@ -132,6 +132,16 @@ static inline int ovl_set_opaque(int dirfd, const char *pathname)
 	return set_xattr(dirfd, pathname, OVL_OPAQUE_XATTR, "y", 1);
 }
 
+static inline int ovl_is_impure(int dirfd, const char *pathname)
+{
+	return is_dir_xattr(dirfd, pathname, OVL_IMPURE_XATTR);
+}
+
+static inline int ovl_set_impure(int dirfd, const char *pathname)
+{
+	return set_xattr(dirfd, pathname, OVL_IMPURE_XATTR, "y", 1);
+}
+
 static int ovl_get_redirect(int dirfd, const char *pathname,
 			    char **redirect)
 {
@@ -708,6 +718,54 @@ out:
 	return ret;
 }
 
+/*
+ * If a directory has origin target and redirect/merge subdirectories in it,
+ * it may contain copied up targets. In order to avoid 'd_ino' change after
+ * lower target copy-up or rename (which will create a new inode),
+ * 'impure xattr' will be set in the parent directory, it is used to prompt
+ * overlay filesystem to get and return the origin 'd_ino' in getdents(2).
+ *
+ * Missing "impure xattr" will lead to return wrong 'd_ino' of impure directory.
+ * So check origin target and redirect/merge subdirs in a specified directory,
+ * and fix "impure xattr" if necessary.
+ */
+static int ovl_check_impure(struct scan_ctx *sctx)
+{
+	struct scan_dir_data *dirdata = sctx->dirdata;
+
+	if (!dirdata)
+		return 0;
+
+	/*
+	 * Impure xattr should be set if directory has redirect/merge
+	 * subdir or origin targets.
+	 */
+	if (!dirdata->origins && !dirdata->mergedirs &&
+	    !dirdata->redirects)
+		return 0;
+
+	if (ovl_is_impure(sctx->dirfd, sctx->pathname))
+		return 0;
+
+	/* Fix impure xattrs */
+	if (ovl_ask_action("Missing impure xattr", sctx->pathname,
+			   sctx->dirtype, sctx->stack, "Fix", 1)) {
+		if (ovl_set_impure(sctx->dirfd, sctx->pathname))
+			return -1;
+	} else {
+		/*
+		 * Note: not enforce to fix the case of directory that
+		 * only contains general merge subdirs because it could
+		 * be an newly created overlay image and fix by overlay
+		 * filesystem after mount.
+		 */
+		if (dirdata->origins || dirdata->redirects)
+			sctx->m_impure++;
+	}
+
+	return 0;
+}
+
 static int ovl_count_origin(struct scan_ctx *sctx)
 {
 	struct scan_dir_data *parent = sctx->dirdata;
@@ -760,8 +818,9 @@ static int ovl_count_unreal(struct scan_ctx *sctx)
  *            of redirect directory, include duplicate redirect
  *            directory. After this pass, the hierarchical structure
  *            of each layer's directories becomes consistent.
- * -Pass two: iterate through all directories, and find and check
- *            validity of whiteouts.
+ * -Pass two: Iterate through all directories, and find and check
+ *            validity of whiteouts, and check missing impure xattr
+ *            in upperdir.
  */
 
 static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
@@ -778,6 +837,7 @@ static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
 			.whiteout = ovl_check_whiteout,
 			.origin = ovl_count_origin,
 			.unreal = ovl_count_unreal,
+			.impure = ovl_check_impure,
 		},
 		[OVL_LOWER] = {
 			.whiteout = ovl_check_whiteout,
@@ -787,7 +847,7 @@ static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
 
 static char *ovl_scan_desc[OVL_SCAN_PASS] = {
 	"Checking redirect xattr and directory tree",
-	"Checking whiteouts"
+	"Checking whiteouts and impure xattr"
 };
 
 static void ovl_scan_clean(void)
@@ -800,10 +860,12 @@ static void ovl_scan_report(struct scan_ctx *sctx)
 {
 	if (flags & FL_VERBOSE) {
 		print_info(_("Scan %d directories, %d files, "
-			     "%d/%d whiteouts, %d/%d redirect dirs\n"),
+			     "%d/%d whiteouts, %d/%d redirect dirs "
+			     "%d missing impure\n"),
 			     sctx->directories, sctx->files,
 			     sctx->i_whiteouts, sctx->t_whiteouts,
-			     sctx->i_redirects, sctx->t_redirects);
+			     sctx->i_redirects, sctx->t_redirects,
+			     sctx->m_impure);
 	}
 }
 
@@ -815,6 +877,9 @@ static void ovl_scan_check(struct scan_ctx *sctx)
 	else if (sctx->i_redirects)
 		print_info(_("Invalid redirect directories %d left!\n"),
 			     sctx->i_redirects);
+	else if (sctx->m_impure)
+		print_info(_("Directories %d missing impure xattr!\n"),
+			     sctx->m_impure);
 	else
 		return;
 
@@ -829,7 +894,8 @@ int ovl_scan_fix(void)
 	int ret;
 
 	if (flags & FL_VERBOSE)
-		print_info(_("Scan and fix: [whiteouts|redirect dir]\n"));
+		print_info(_("Scan and fix: "
+			     "[whiteouts|redirect dir|impure dir]\n"));
 
 	for (i = 0; i < OVL_SCAN_PASS; i++) {
 		if (flags & FL_VERBOSE)
diff --git a/lib.c b/lib.c
index 03bd8eb..19eab65 100644
--- a/lib.c
+++ b/lib.c
@@ -253,6 +253,11 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 			sctx->dirdata = smalloc(sizeof(struct scan_dir_data));
 			break;
 		case FTS_DP:
+			/* Check impure xattr */
+			ret = scan_check_entry(sop->impure, sctx);
+			if (ret)
+				goto out;
+
 			/* Restore parent's dir data */
 			free(sctx->dirdata);
 			sctx->dirdata = ftsent->fts_pointer;
diff --git a/lib.h b/lib.h
index 60e620e..8d1d936 100644
--- a/lib.h
+++ b/lib.h
@@ -55,6 +55,7 @@
 #define OVL_OPAQUE_XATTR	"trusted.overlay.opaque"
 #define OVL_REDIRECT_XATTR	"trusted.overlay.redirect"
 #define OVL_ORIGIN_XATTR	"trusted.overlay.origin"
+#define OVL_IMPURE_XATTR	"trusted.overlay.impure"
 
 
 /* Directories scan data structs */
@@ -76,6 +77,7 @@ struct scan_ctx {
 	int i_whiteouts;	/* invalid whiteouts */
 	int t_redirects;	/* total redirect dirs */
 	int i_redirects;	/* invalid redirect dirs */
+	int m_impure;		/* missing inpure dirs */
 
 	const char *pathname;	/* path relative to overlay root */
 	const char *filename;	/* filename */
@@ -89,6 +91,7 @@ struct scan_operations {
 	int (*redirect)(struct scan_ctx *);
 	int (*origin)(struct scan_ctx *);
 	int (*unreal)(struct scan_ctx *);
+	int (*impure)(struct scan_ctx *);
 };
 
 static inline void set_inconsistency(int *status)
-- 
2.9.5
