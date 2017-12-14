From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 09/18] fsck.overlay: add counter of checked objects
Date: Thu, 14 Dec 2017 14:47:38 +0800
Message-ID: <20171214064747.20999-10-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Count files, sub-directories, whiteouts, opaque directories, redirect
directories (total/invalid/delete/creat) when scaning and fixing
underlying directories of overlayfs. Warn user if any invalid left after
fsck.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 lib.c   |  5 ++++-
 lib.h   | 14 ++++++++++++++
 3 files changed, 78 insertions(+), 4 deletions(-)
 mode change 100755 => 100644 check.c

diff --git a/check.c b/check.c
old mode 100755
new mode 100644
index b26638e..b3a8607
--- a/check.c
+++ b/check.c
@@ -199,6 +199,8 @@ static int ovl_check_whiteout(struct scan_ctx *sctx)
 	if (!is_whiteout(st))
 		return 0;
 
+	sctx->whiteouts[SC_TOTAL]++;
+
 	/* Is Whiteout in the bottom lower dir ? */
 	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
 		goto remove;
@@ -216,6 +218,7 @@ static int ovl_check_whiteout(struct scan_ctx *sctx)
 		goto out;
 
 remove:
+	sctx->whiteouts[SC_INVALID]++;
 	/* Remove orphan whiteout directly or ask user */
 	print_info(_("Orphan whiteout: %s "), pathname);
 	if (!ask_question("Remove", 1))
@@ -227,6 +230,7 @@ remove:
 			    strerror(errno));
 		return ret;
 	}
+	sctx->whiteouts[SC_INVALID_DEL]++;
 out:
 	return ret;
 }
@@ -252,6 +256,8 @@ static int ovl_check_opaque(struct scan_ctx *sctx)
 	if (!ovl_is_opaque(pathname))
 		goto out;
 
+	sctx->opaques[SC_TOTAL]++;
+
 	/* Opaque dir in last lower dir ? */
 	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
 		goto remove;
@@ -278,12 +284,15 @@ static int ovl_check_opaque(struct scan_ctx *sctx)
 		goto out;
 
 remove:
+	sctx->opaques[SC_INVALID]++;
 	/* Remove opaque xattr or ask user */
 	print_info(_("Invalid opaque xattr: %s "), pathname);
 	if (!ask_question("Remove", 1))
 		return 0;
 
 	ret = ovl_remove_opaque(pathname);
+	if (!ret)
+		sctx->opaques[SC_INVALID_DEL]++;
 out:
 	return ret;
 }
@@ -381,6 +390,7 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 		return ret;
 
 	print_debug(_("Dir %s has redirect %s\n"), pathname, redirect);
+	sctx->redirects[SC_TOTAL]++;
 
 	/* Redirect dir in last lower dir ? */
 	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
@@ -401,6 +411,7 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 			print_info("origin:%s current:%s last:%s\n",
 				   chk.path, pathname, tmp);
 
+			sctx->redirects[SC_INVALID]++;
 			set_st_inconsistency(&status);
 		}
 
@@ -418,23 +429,34 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 			}
 
 			/* Found nothing, create a whiteout */
-			ret = ovl_create_whiteout(redirect_rpath);
+			if ((ret = ovl_create_whiteout(redirect_rpath)))
+				goto out;
+
+			sctx->whiteouts[SC_CREATE]++;
+			sctx->whiteouts[SC_TOTAL]++;
 
 		} else if (is_dir(&rst) && !ovl_is_opaque(redirect_rpath)) {
 			/* Found a directory but not opaqued, fix opaque xattr */
-			ret = ovl_set_opaque(redirect_rpath);
+			if ((ret = ovl_set_opaque(redirect_rpath)))
+				goto out;
+
+			sctx->opaques[SC_CREATE]++;
+			sctx->opaques[SC_TOTAL]++;
 		}
 
 		goto out;
 	}
 
 remove:
+	sctx->redirects[SC_INVALID]++;
 	/* Remove redirect xattr or ask user */
 	print_info(_("Invalid redirect xattr: %s "), pathname);
 	if (!ask_question("Remove", 1))
 		goto out;
 
 	ret = ovl_remove_redirect(pathname);
+	if (!ret)
+		sctx->redirects[SC_INVALID_DEL]++;
 out:
 	free(redirect);
 	return ret;
@@ -446,6 +468,40 @@ static struct scan_operations ovl_scan_ops = {
 	.redirect = ovl_check_redirect,
 };
 
+static void ovl_scan_report(struct scan_ctx *sctx)
+{
+	int i_whiteouts, i_opaques, i_redirects;
+
+	if (flags | FL_VERBOSE) {
+		print_info(_("Scan %d directories, %d files\n"),
+			   sctx->directories, sctx->files);
+		print_info(_("Whiteouts: %d/%d/%d/%d [Total/Invalid/Deleted/Create]\n"),
+			   sctx->whiteouts[SC_TOTAL], sctx->whiteouts[SC_INVALID],
+			   sctx->whiteouts[SC_INVALID_DEL], sctx->whiteouts[SC_CREATE]);
+		print_info(_("Opaque directories: %d/%d/%d/%d [Total/Invalid/Deleted/Create]\n"),
+			   sctx->opaques[SC_TOTAL], sctx->opaques[SC_INVALID],
+			   sctx->opaques[SC_INVALID_DEL], sctx->opaques[SC_CREATE]);
+		print_info(_("Redirect directories: %d/%d/%d/%d [Total/Invalid/Deleted/Create]\n"),
+			   sctx->redirects[SC_TOTAL], sctx->redirects[SC_INVALID],
+			   sctx->redirects[SC_INVALID_DEL], sctx->redirects[SC_CREATE]);
+	}
+
+	i_whiteouts = sctx->whiteouts[SC_INVALID] - sctx->whiteouts[SC_INVALID_DEL];
+	i_opaques = sctx->opaques[SC_INVALID] - sctx->opaques[SC_INVALID_DEL];
+	i_redirects = sctx->redirects[SC_INVALID] - sctx->redirects[SC_INVALID_DEL];
+
+	if (i_whiteouts)
+		print_info(_("Invalid whiteouts %d left!\n"), i_whiteouts);
+	else if (i_opaques)
+		print_info(_("Invalid opaque directories %d left!\n"), i_opaques);
+	else if (i_redirects)
+		print_info(_("Invalid redirect directories %d left!\n"), i_redirects);
+	else
+		return;
+
+	set_st_inconsistency(&status);
+}
+
 static void ovl_scan_clean(void)
 {
 	/* Clean redirect entry record */
@@ -455,7 +511,7 @@ static void ovl_scan_clean(void)
 /* Scan upperdir and each lowerdirs, check and fix inconsistency */
 int ovl_scan_fix(void)
 {
-	struct scan_ctx sctx;
+	struct scan_ctx sctx = {0};
 	unsigned int i;
 	int ret = 0;
 
@@ -489,6 +545,7 @@ int ovl_scan_fix(void)
 			goto out;
 	}
 out:
+	ovl_scan_report(&sctx);
 	ovl_scan_clean();
 	return ret;
 }
diff --git a/lib.c b/lib.c
index ecc5d27..7495af5 100644
--- a/lib.c
+++ b/lib.c
@@ -198,7 +198,6 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 			ftsent->fts_level, ftsent->fts_statp->st_size,
 			ftsent->fts_path, ftsent->fts_name);
 
-
 		/* Fillup base context */
 		sctx->pathname = ftsent->fts_path;
 		sctx->pathlen = ftsent->fts_pathlen;
@@ -207,6 +206,9 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 		sctx->st = ftsent->fts_statp;
 
 		switch (ftsent->fts_info) {
+		case FTS_F:
+			sctx->files++;
+			break;
 		case FTS_DEFAULT:
 			/* Check whiteouts */
 			err = __check_entry(sctx, sop->whiteout);
@@ -214,6 +216,7 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 			break;
 		case FTS_D:
 			/* Check opaque and redirect */
+			sctx->directories++;
 			err = __check_entry(sctx, sop->opaque);
 			ret = (ret || !err) ? ret : err;
 
diff --git a/lib.h b/lib.h
index e389ed6..0f0b526 100644
--- a/lib.h
+++ b/lib.h
@@ -38,6 +38,14 @@
 #define OVL_OPAQUE_XATTR	"trusted.overlay.opaque"
 #define OVL_REDIRECT_XATTR	"trusted.overlay.redirect"
 
+enum scan_count_type {
+	SC_TOTAL = 0,		/* total check num */
+	SC_INVALID,		/* total invalid num */
+	SC_INVALID_DEL,		/* deleted invalid num */
+	SC_CREATE,		/* create num */
+	SC_MAX,
+};
+
 /* Directories scan data struct */
 struct scan_ctx {
 	const char *dirname;	/* upper/lower root dir */
@@ -50,6 +58,12 @@ struct scan_ctx {
 	const char *filename;	/* filename */
 	size_t filelen;		/* strlen(filename) */
 	struct stat *st;	/* file stat */
+
+	int files;
+	int directories;
+	int whiteouts[SC_MAX];
+	int redirects[SC_MAX];
+	int opaques[SC_MAX];
 };
 
 /* Directories scan callback operations struct */
-- 
2.9.5
