Return-Path: <yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH] fsck.overlay: add ovl_check_origin helper
Date: Fri, 23 Feb 2018 20:01:06 +0800
Message-ID: <20180223120106.32921-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, zhaohongjiang@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

For origin xattr, use fid in ovl_fh to consume file_handle, and use
open_by_handle_at to check validity of the origin ovl_fh. In auto mode,
the invalid origin xattr will remove automatic.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 check.c     | 135 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lib.c       |  10 +++++
 lib.h       |   4 +-
 overlayfs.c |  23 +++++++++++
 overlayfs.h |  33 +++++++++++++++
 5 files changed, 202 insertions(+), 3 deletions(-)

diff --git a/check.c b/check.c
index e109620..50c4585 100644
--- a/check.c
+++ b/check.c
@@ -24,6 +24,7 @@
 
 #include <stdlib.h>
 #include <stdio.h>
+#include <stddef.h>
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
@@ -169,11 +170,42 @@ static int ovl_get_redirect(int dirfd, const char *pathname,
 	return 0;
 }
 
+/*
+ * Get the origin file handle with the pathname, then check the validity of member
+ * in ovl_fh.
+ */
+static int ovl_get_fh(int dirfd, const char *pathname,
+		      struct ovl_fh **fh, bool *invalid)
+{
+	char *og = NULL;
+	ssize_t ret;
+
+	ret = get_xattr(dirfd, pathname, OVL_ORIGIN_XATTR, &og, NULL);
+	if (ret <= 0)
+		return ret;
+
+	ret = ovl_check_fh_len((struct ovl_fh *)og, ret);
+	if (ret) {
+		free(og);
+		if (ret == -EINVAL)
+			*invalid = true;
+	} else {
+		*fh = (struct ovl_fh *)og;
+	}
+
+	return 0;
+}
+
 static inline int ovl_remove_redirect(int dirfd, const char *pathname)
 {
 	return remove_xattr(dirfd, pathname, OVL_REDIRECT_XATTR);
 }
 
+static inline int ovl_remove_origin(int dirfd, const char *pathname)
+{
+	return remove_xattr(dirfd, pathname, OVL_ORIGIN_XATTR);
+}
+
 static inline int ovl_create_whiteout(int dirfd, const char *pathname)
 {
 	if (mknodat(dirfd, pathname, S_IFCHR | WHITEOUT_MOD, makedev(0, 0))) {
@@ -758,6 +790,97 @@ out:
 }
 
 /*
+ * Get origin file handle stored in the xattr, check it's invalid
+ * or not. In auto-mode, invalid origin xattr will be removed directly.
+ */
+static int ovl_check_origin(struct scan_ctx *sctx)
+{
+	struct ovl_fh *fh = NULL;
+	struct file_handle *fhp = NULL;
+	struct stat stat;
+	bool invalid = false;
+	int i;
+	int ret;
+	int fid_len;
+	int fd;
+
+	/* Get origin */
+	ret = ovl_get_fh(sctx->dirfd, sctx->pathname, &fh, &invalid);
+	if (ret < 0)
+		return -1;
+
+	/* Cannot get ovl_fh, maybe not set or unrecognized */
+	if (!fh && !invalid)
+		return 0;
+
+	print_debug(_("File or dir \"%s\" has origin\n"), sctx->pathname);
+	sctx->t_origins++;
+
+	/* ovl_fh is invalid */
+	if (invalid)
+		goto remove;
+
+	/* Origin file in last lower dir? */
+	if (sctx->dirtype == OVL_LOWER && sctx->stack == lower_num -1)
+		goto remove;
+
+	fid_len = fh->len - offsetof(struct ovl_fh, fid);
+	fhp = smalloc(sizeof(struct file_handle) + fid_len);
+	fhp->handle_bytes = fh->len - offsetof(struct ovl_fh, fid);
+	fhp->handle_type = fh->type;
+	memcpy(fhp->f_handle, fh->fid, fid_len);
+
+	/* Scan lower directories to check origin xattr's validity */
+	i = sctx->dirtype == OVL_UPPER ? 0 : sctx->stack + 1;
+	for (; i < lower_num; i++) {
+		fd = open_by_handle_at(lowerfd[i], fhp, O_RDONLY);
+
+		if (fd == -1) {
+			if (errno == ESTALE || errno == ENOENT)
+				continue;
+
+			print_err(_("Error open_by_handle_at %s:%s\n"),
+				    sctx->pathname, strerror(errno));
+			ret = -1;
+			goto out;
+		}
+
+		ret = fstat(fd, &stat);
+		if (ret) {
+			print_err(_("Cannot fstat origin file in %s of %s:%s\n"),
+				    lowerdir[i], sctx->pathname, strerror(errno));
+			goto out2;
+		}
+
+		if (stat.st_mode != sctx->st->st_mode)
+			goto remove;
+
+		goto out2;
+	}
+
+remove:
+	sctx->i_origins++;
+
+	/* Remove origin xattr or ask user */
+	if (!ovl_ask_action("Invalid origin xattr", sctx->pathname, sctx->dirtype,
+			    sctx->stack, "Remove origin", 1))
+		goto out;
+
+	ret = ovl_remove_origin(sctx->dirfd, sctx->pathname);
+	if (ret)
+		goto out;
+
+	sctx->i_origins--;
+	sctx->t_origins--;
+out2:
+	close(fd);
+out:
+	free(fhp);
+	free(fh);
+	return ret;
+}
+
+/*
  * If a directory has origin target and redirect/merge subdirectories in it,
  * it may contain copied up targets. In order to avoid 'd_ino' change after
  * lower target copy-up or rename (which will create a new inode),
@@ -870,9 +993,11 @@ static struct scan_operations ovl_scan_ops[OVL_SCAN_PASS][2] = {
 			.whiteout = ovl_check_whiteout,
 			.impurity = ovl_count_impurity,
 			.impure = ovl_check_impure,
+			.origin = ovl_check_origin,
 		},
 		[OVL_LOWER] = {
 			.whiteout = ovl_check_whiteout,
+			.origin = ovl_check_origin,
 		},
 	}/* Pass Two */
 };
@@ -892,11 +1017,12 @@ static void ovl_scan_report(struct scan_ctx *sctx)
 {
 	if (flags & FL_VERBOSE) {
 		print_info(_("Scan %d directories, %d files, "
-			     "%d/%d whiteouts, %d/%d redirect dirs "
-			     "%d missing impure\n"),
+			     "%d/%d whiteouts, %d/%d redirect dirs, "
+			     "%d/%d origins, %d missing impure\n"),
 			     sctx->directories, sctx->files,
 			     sctx->i_whiteouts, sctx->t_whiteouts,
 			     sctx->i_redirects, sctx->t_redirects,
+			     sctx->i_origins, sctx->t_origins,
 			     sctx->m_impure);
 	}
 }
@@ -916,6 +1042,11 @@ static void ovl_scan_check(struct scan_ctx *sctx)
 			     sctx->i_redirects);
 		incons = true;
 	}
+	if (sctx->i_origins) {
+		print_info(_("Invalid origins %d left!\n"),
+			     sctx->i_origins);
+		incons = true;
+	}
 	if (sctx->m_impure) {
 		print_info(_("Directories %d missing impure xattr!\n"),
 			     sctx->m_impure);
diff --git a/lib.c b/lib.c
index 4d9536a..2aee0dc 100644
--- a/lib.c
+++ b/lib.c
@@ -244,6 +244,11 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 			ret = scan_check_entry(sop->impurity, sctx);
 			if (ret)
 			        goto out;
+
+			/* Check origins */
+			ret = scan_check_entry(sop->origin, sctx);
+			if (ret)
+				goto out;
 			break;
 		case FTS_DEFAULT:
 			/* Check whiteouts */
@@ -264,6 +269,11 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 			if (ret)
 				goto out;
 
+			/* Check origins */
+			ret = scan_check_entry(sop->origin, sctx);
+			if (ret)
+				goto out;
+
 			/* Save current dir data and create new one for subdir */
 			ftsent->fts_pointer = sctx->dirdata;
 			sctx->dirdata = smalloc(sizeof(struct scan_dir_data));
diff --git a/lib.h b/lib.h
index 880a8c3..5f7fdaa 100644
--- a/lib.h
+++ b/lib.h
@@ -71,7 +71,9 @@ struct scan_ctx {
 	int i_whiteouts;	/* invalid whiteouts */
 	int t_redirects;	/* total redirect dirs */
 	int i_redirects;	/* invalid redirect dirs */
-	int m_impure;		/* missing inpure dirs */
+	int t_origins;		/* total origins */
+	int i_origins;		/* invalid origins */
+	int m_impure;		/* missing impure dirs */
 
 	const char *pathname;	/* path relative to overlay root */
 	const char *filename;	/* filename */
diff --git a/overlayfs.c b/overlayfs.c
index 93b4cad..c2f0840 100644
--- a/overlayfs.c
+++ b/overlayfs.c
@@ -19,6 +19,8 @@
  */
 
 #include <stddef.h>
+#include <errno.h>
+#include "overlayfs.h"
 
 /*
  * Split directories to individual one.
@@ -70,3 +72,24 @@ char *ovl_next_opt(char **s)
 	*s = NULL;
 	return sbegin;
 }
+
+/*
+ * Check the validity of ovl_fh.
+ */
+int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
+{
+	if (fh_len < sizeof(struct ovl_fh) || fh_len < fh->len)
+		return -EINVAL;
+
+	if (fh->magic != OVL_FH_MAGIC)
+		return -EINVAL;
+
+	if (fh->version > OVL_FH_VERSION || fh->flags & ~OVL_FH_FLAG_ALL)
+		return -ENODATA;
+
+	if (!(fh->flags & OVL_FH_FLAG_ANY_ENDIAN) &&
+	    (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
+		return -ENODATA;
+
+	return 0;
+}
diff --git a/overlayfs.h b/overlayfs.h
index e3798aa..9913912 100644
--- a/overlayfs.h
+++ b/overlayfs.h
@@ -42,7 +42,40 @@
 #define OVL_ORIGIN_XATTR	"trusted.overlay.origin"
 #define OVL_IMPURE_XATTR	"trusted.overlay.impure"
 
+#define OVL_FH_VERSION 0
+#define OVL_FH_MAGIC 0xfb
+
+#define OVL_FH_FLAG_BIG_ENDIAN (1 << 0)
+#define OVL_FH_FLAG_ANY_ENDIAN (1 << 1)
+#define OVL_FH_FLAG_PATH_UPPER (1 << 2)
+#define OVL_FH_FLAG_ALL (OVL_FH_FLAG_BIG_ENDIAN | OVL_FH_FLAG_ANY_ENDIAN | \
+			OVL_FH_FLAG_PATH_UPPER)
+#include <endian.h>
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define OVL_FH_FLAG_CPU_ENDIAN 0
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define OVL_FH_FLAG_CPU_ENDIAN  OVL_FH_FLAG_BIG_ENDIAN
+#else
+#error Endianness not defined
+#endif
+
+#include <stdint.h>
+typedef struct {
+	uint8_t b[16];
+}uuid_t;
+
+struct ovl_fh {
+	uint8_t version;
+	uint8_t magic;
+	uint8_t len;
+	uint8_t flags;
+	uint8_t type;
+	uuid_t uuid;
+	uint8_t fid[0];
+};
+
 unsigned int ovl_split_lowerdirs(char *lower);
 char *ovl_next_opt(char **s);
+int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
 
 #endif /* OVL_OVERLAYFS_H */
-- 
2.13.6
