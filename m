From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v4 3/5] fsck.overlay: add origin count
Date: Thu, 18 Jan 2018 11:50:54 +0800
Message-ID: <20180118035056.17358-4-yi.zhang@huawei.com>
References: <20180118035056.17358-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180118035056.17358-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com, yizhang089@gmail.com
List-Id: linux-unionfs@vger.kernel.org

Count origin targets in a directory in scan pass two, will be use
for impure xattr check.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c | 22 ++++++++++++++++++++++
 lib.c   | 19 +++++++++++++++++++
 lib.h   |  9 ++++++++-
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/check.c b/check.c
index e5415c9..e46aea7 100644
--- a/check.c
+++ b/check.c
@@ -180,6 +180,13 @@ static inline bool ovl_is_redirect(int dirfd, const char *pathname)
 	return exist;
 }
 
+static inline bool ovl_is_origin(int dirfd, const char *pathname)
+{
+	bool exist = false;
+	get_xattr(dirfd, pathname, OVL_ORIGIN_XATTR, NULL, &exist);
+	return exist;
+}
+
 static inline int ovl_ask_action(const char *description, const char *pathname,
 				 int dirtype, int stack,
 				 const char *question, int action)
@@ -701,6 +708,20 @@ out:
 	return ret;
 }
 
+static int ovl_count_origin(struct scan_ctx *sctx)
+{
+	struct scan_dir_data *parent = sctx->dirdata;
+
+	if (!parent)
+		return 0;
+
+	if (ovl_is_origin(sctx->dirfd, sctx->pathname))
+		parent->origins++;
+
+	return 0;
+}
+
+
 /*
  * Scan Pass:
  * -Pass one: Iterate through all directories, and check validity
@@ -723,6 +744,7 @@ static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
 	{
 		[OVL_UPPER] = {
 			.whiteout = ovl_check_whiteout,
+			.origin = ovl_count_origin,
 		},
 		[OVL_LOWER] = {
 			.whiteout = ovl_check_whiteout,
diff --git a/lib.c b/lib.c
index 3d9185c..dff3426 100644
--- a/lib.c
+++ b/lib.c
@@ -219,6 +219,11 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 		switch (ftsent->fts_info) {
 		case FTS_F:
 			sctx->files++;
+
+			/* Check origin xattr */
+			ret = scan_check_entry(sop->origin, sctx);
+			if (ret)
+			        goto out;
 			break;
 		case FTS_DEFAULT:
 			/* Check whiteouts */
@@ -233,6 +238,20 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 			ret = scan_check_entry(sop->redirect, sctx);
 			if (ret)
 				goto out;
+
+			/* Check origin xattr */
+			ret = scan_check_entry(sop->origin, sctx);
+			if (ret)
+				goto out;
+
+			/* Save current dir data and create new one for subdir */
+			ftsent->fts_pointer = sctx->dirdata;
+			sctx->dirdata = smalloc(sizeof(struct scan_dir_data));
+			break;
+		case FTS_DP:
+			/* Restore parent's dir data */
+			free(sctx->dirdata);
+			sctx->dirdata = ftsent->fts_pointer;
 			break;
 		case FTS_NS:
 		case FTS_DNR:
diff --git a/lib.h b/lib.h
index 2245752..450a4cb 100644
--- a/lib.h
+++ b/lib.h
@@ -54,9 +54,14 @@
 /* Xattr */
 #define OVL_OPAQUE_XATTR	"trusted.overlay.opaque"
 #define OVL_REDIRECT_XATTR	"trusted.overlay.redirect"
+#define OVL_ORIGIN_XATTR	"trusted.overlay.origin"
 
 
-/* Directories scan data struct */
+/* Directories scan data structs */
+struct scan_dir_data {
+       int origins;		/* origin number in this directory (no iterate) */
+};
+
 struct scan_ctx {
 	const char *dirname;	/* overlay base dir */
 	int dirfd;		/* dir descriptor */
@@ -73,12 +78,14 @@ struct scan_ctx {
 	const char *pathname;	/* path relative to overlay root */
 	const char *filename;	/* filename */
 	struct stat *st;	/* file stat */
+	struct scan_dir_data *dirdata;	/* parent dir data of current (could be null) */
 };
 
 /* Directories scan callback operations struct */
 struct scan_operations {
 	int (*whiteout)(struct scan_ctx *);
 	int (*redirect)(struct scan_ctx *);
+	int (*origin)(struct scan_ctx *);
 };
 
 static inline void set_inconsistency(int *status)
-- 
2.9.5
