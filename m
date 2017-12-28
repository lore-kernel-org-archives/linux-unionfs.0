From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 6/6] fsck.overlay: add impure xattr check
Date: Thu, 28 Dec 2017 19:40:23 +0800
Message-ID: <20171228114023.43999-7-yi.zhang@huawei.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171228114023.43999-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

An impure directory is a directory with "trusted.overlay.impure" xattr
valued 'y', which indicate that this directory may contain copy-uped
targets from lower layers. In oredr to prevent 'd_ino' change while
copy-up (it create a new inode in upper layer) in getdents(2), impure
xattr will be set in the parent directory, letting overlay filesystem
check and get d_ino from lower origin target to ensure consistent d_ino.

There are three situations of setting impure xattr:
1) Copyup lower target in a directory.
2) Link an origined target (already copy-uped, have origin xattr) into
   a directory.
3) Rename an origined target (include merged subdirectories) into a
   new directory.

So, if a direcotry which contains several origined targets or redirect
directories, the impure xattr should be set. If not, fix this xattr.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 README.md | 22 +++++++++++++++-
 check.c   | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 lib.c     | 63 +++++++++++++++++++++++++++++++++++-----------
 lib.h     | 25 +++++++++++++------
 4 files changed, 168 insertions(+), 28 deletions(-)

diff --git a/README.md b/README.md
index 2e6146f..cdbd382 100644
--- a/README.md
+++ b/README.md
@@ -47,6 +47,26 @@ If an invalid redirect xattr was removed by fsck and there is a corresponding
 lower directory with the same name exists, not sure this directory is merged
 or not, ask user to make a decision.
 
+Impure directories
+------------------
+
+An impure directory is a directory with "trusted.overlay.impure" xattr valued
+'y', which indicate that this directory may contain copy-uped targets from lower
+layers. In oredr to prevent 'd_ino' change while copy-up (it create a new
+inode in upper layer) in getdents (see getdents(2)), impure xattr will be set
+in the parent directory, letting overlay filesystem check and get d_ino from
+lower origin target to ensure consistent d_ino.
+
+There are three situations of setting impure xattr:
+1) Copyup lower target in a directory.
+2) Link an origined target (already copy-uped, have origin xattr) into
+   a directory.
+3) Rename an origined target (include merged subdirectories) into a
+   new directory.
+
+So, if a direcotry which contains several origined targets or redirect
+directories, the impure xattr should be set. If not, fix this xattr.
+
 Usage
 =====
 
@@ -88,6 +108,6 @@ Todo
    mounted with relative path. Should modify kernel together to support.
 2. Check and fix invalid redirect xattr through origin xattr.
 3. Symbolic link check.
-4. Check origin/impure/nlink xattr.
+4. Check origin/nlink xattr.
 5. Check index feature consistency.
 6. ...
diff --git a/check.c b/check.c
index 033d4ba..05293c5 100644
--- a/check.c
+++ b/check.c
@@ -111,9 +111,9 @@ static inline bool ovl_is_opaque(const char *pathname)
 	return is_dir_xattr(pathname, OVL_OPAQUE_XATTR);
 }
 
-static inline int ovl_remove_opaque(const char *pathname)
+static inline bool ovl_is_impure(const char *pathname)
 {
-	return remove_xattr(pathname, OVL_OPAQUE_XATTR);
+	return is_dir_xattr(pathname, OVL_IMPURE_XATTR);
 }
 
 static inline int ovl_set_opaque(const char *pathname)
@@ -121,6 +121,11 @@ static inline int ovl_set_opaque(const char *pathname)
 	return set_xattr(pathname, OVL_OPAQUE_XATTR, "y", 1);
 }
 
+static inline int ovl_set_impure(const char *pathname)
+{
+	return set_xattr(pathname, OVL_IMPURE_XATTR, "y", 1);
+}
+
 static int ovl_get_redirect(const char *pathname, size_t dirlen,
 			    size_t filelen, char **redirect)
 {
@@ -166,11 +171,20 @@ static inline int ovl_create_whiteout(const char *pathname)
 
 static inline bool ovl_is_redirect(const char *pathname)
 {
-       bool exist = false;
-       ssize_t ret;
+	bool exist = false;
+	ssize_t ret;
+
+	ret = get_xattr(pathname, OVL_REDIRECT_XATTR, NULL, &exist);
+	return ret ? false : exist;
+}
+
+static inline bool ovl_is_origin(const char *pathname)
+{
+	bool exist = false;
+	ssize_t ret;
 
-       ret = get_xattr(pathname, OVL_REDIRECT_XATTR, NULL, &exist);
-       return ret ? false : exist;
+	ret = get_xattr(pathname, OVL_ORIGIN_XATTR, NULL, &exist);
+	return ret ? false : exist;
 }
 
 static inline int ovl_ask_action(const char *description, const char *pathname,
@@ -503,6 +517,7 @@ static void ovl_redirect_free(void)
 static int ovl_check_redirect(struct scan_ctx *sctx)
 {
 	const char *pathname = sctx->pathname;
+	struct scan_dir_data *parent_ddata = sctx->ddata;
 	struct ovl_lower_data od = {0};
 	struct stat cover_st;
 	bool cover_exist = false;
@@ -545,6 +560,9 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 				goto remove_d;
 		}
 
+		/* Now, this redirect xattr is valid */
+		if (parent_ddata)
+			parent_ddata->redirects++;
 		ovl_redirect_entry_add(pathname, sctx->dirtype,
 				       sctx->num, od.path);
 
@@ -603,9 +621,65 @@ out:
 	return ret;
 }
 
+/*
+ * Get origin xattr stored in the target. We cannot check validity for
+ * current overlay filesystem, so trust this is valid now.
+ */
+static int ovl_check_origin(struct scan_ctx *sctx)
+{
+	const char *pathname = sctx->pathname;
+	struct scan_dir_data *parent_ddata = sctx->ddata;
+
+	if (!ovl_is_origin(pathname))
+		return 0;
+	if (parent_ddata)
+		parent_ddata->origins++;
+
+	return 0;
+}
+
+/*
+ * If a directory has origined target and redirect subdirectories in it,
+ * it may contain copy-up targets. In order to avoid 'd_ino' change after
+ * lower target copyup or renameed (which will create a new inode),
+ * 'impure xattr' will be setted in the parent directory to indicate
+ * overlayfs show origin 'd_ino' when iterate directory.
+ *
+ * Missing "impure xattr" will cause wrong 'd_ino' in readdir() of impure
+ * directory, so check origined or redirected target in a directory and
+ * fix "impure xattr" if necessary.
+ */
+static int ovl_check_impure(struct scan_ctx *sctx)
+{
+	const char *pathname = sctx->pathname;
+	struct scan_dir_data *cur_ddata = sctx->ddata;
+	int ret = 0;
+
+	/*
+	 * Impure xattr should be set if current directory has redirect
+	 * directory or origin targets.
+	 */
+	if (!cur_ddata->origins && !cur_ddata->redirects)
+		goto out;
+
+	/* Fix impure xattrs */
+	if (!ovl_is_impure(pathname)) {
+		if (ovl_ask_action("Missing impure xattr",
+				   pathname, "Fix", 1)) {
+			ret = ovl_set_impure(pathname);
+			if (ret)
+				goto out;
+		}
+	}
+out:
+	return ret;
+}
+
 static struct scan_operations ovl_scan_ops = {
 	.whiteout = ovl_check_whiteout,
 	.redirect = ovl_check_redirect,
+	.origin = ovl_check_origin,
+	.impure = ovl_check_impure,
 };
 
 static void ovl_scan_report(struct scan_ctx *sctx)
diff --git a/lib.c b/lib.c
index 497d357..524246d 100644
--- a/lib.c
+++ b/lib.c
@@ -165,8 +165,17 @@ const char *path_pick(const char *path, int baselen)
 	return (*p == '/') ? p+1 : p;
 }
 
-static inline int __check_entry(struct scan_ctx *sctx,
-				  int (*do_check)(struct scan_ctx *))
+static void scan_entry_init(struct scan_ctx *sctx, FTSENT *ftsent)
+{
+	sctx->pathname = ftsent->fts_path;
+	sctx->pathlen = ftsent->fts_pathlen;
+	sctx->filename = ftsent->fts_name;
+	sctx->filelen = ftsent->fts_namelen;
+	sctx->st = ftsent->fts_statp;
+}
+
+static inline int scan_check_entry(int (*do_check)(struct scan_ctx *),
+				   struct scan_ctx *sctx)
 {
 	return do_check ? do_check(sctx) : 0;
 }
@@ -187,8 +196,6 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 	}
 
 	while ((ftsent = fts_read(ftsp)) != NULL) {
-		int err;
-
 		print_debug(_("Scan:%-3s %2d %7jd   %-40s %s\n"),
 			(ftsent->fts_info == FTS_D) ? "d" :
 			(ftsent->fts_info == FTS_DNR) ? "dnr" :
@@ -202,26 +209,54 @@ int scan_dir(struct scan_ctx *sctx, struct scan_operations *sop)
 			ftsent->fts_path, ftsent->fts_name);
 
 		/* Fillup base context */
-		sctx->pathname = ftsent->fts_path;
-		sctx->pathlen = ftsent->fts_pathlen;
-		sctx->filename = ftsent->fts_name;
-		sctx->filelen = ftsent->fts_namelen;
-		sctx->st = ftsent->fts_statp;
+		scan_entry_init(sctx, ftsent);
 
 		switch (ftsent->fts_info) {
 		case FTS_F:
 			sctx->files++;
+
+			/* Check origin */
+			ret = scan_check_entry(sop->origin, sctx);
+			if (ret)
+				goto out;
 			break;
 		case FTS_DEFAULT:
 			/* Check whiteouts */
-			err = __check_entry(sctx, sop->whiteout);
-			ret = (err) ? err : ret;
+			ret = scan_check_entry(sop->whiteout, sctx);
+			if (ret)
+				goto out;
+
+			/* Check origin */
+			ret = scan_check_entry(sop->origin, sctx);
+			if (ret)
+				goto out;
 			break;
 		case FTS_D:
-			/* Check redirect xattr */
 			sctx->directories++;
-			err = __check_entry(sctx, sop->redirect);
-			ret = (err) ? err : ret;
+
+			/* Check redirect xattr */
+			ret = scan_check_entry(sop->redirect, sctx);
+			if (ret)
+				goto out;
+
+			/* Check origin */
+			ret = scan_check_entry(sop->origin, sctx);
+			if (ret)
+				goto out;
+
+			/* Save current dir data and create new one */
+			ftsent->fts_pointer = sctx->ddata;
+			sctx->ddata = smalloc(sizeof(struct scan_dir_data));
+			break;
+		case FTS_DP:
+			/* Check impure xattr */
+			ret = scan_check_entry(sop->impure, sctx);
+			if (ret)
+				goto out;
+
+			/* Restore parent's dir data */
+			free(sctx->ddata);
+			sctx->ddata = ftsent->fts_pointer;
 			break;
 		case FTS_NS:
 		case FTS_DNR:
diff --git a/lib.h b/lib.h
index 5d94836..5fec773 100644
--- a/lib.h
+++ b/lib.h
@@ -52,33 +52,44 @@
 /* Xattr */
 #define OVL_OPAQUE_XATTR	"trusted.overlay.opaque"
 #define OVL_REDIRECT_XATTR	"trusted.overlay.redirect"
+#define OVL_ORIGIN_XATTR	"trusted.overlay.origin"
+#define OVL_IMPURE_XATTR	"trusted.overlay.impure"
 
 
-/* Directories scan data struct */
+/* Directories scan data structs */
+struct scan_dir_data {
+	int origins;		/* origin number in this directory (no iterate) */
+	int redirects;		/* redirect number in this directory (no iterate) */
+};
+
 struct scan_ctx {
 	const char *dirname;	/* upper/lower root dir */
 	size_t dirlen;		/* strlen(dirlen) */
 	int dirtype;		/* OVL_UPPER or OVL_LOWER */
 	int num;		/* lower dir depth, lower type use only */
 
+	int files;		/* total files */
+	int directories;	/* total directories */
+	int t_whiteouts;	/* total whiteouts */
+	int i_whiteouts;	/* invalid whiteouts */
+	int t_redirects;	/* total redirect dirs */
+	int i_redirects;	/* invalid redirect dirs */
+
 	const char *pathname;	/* file path from the root */
 	size_t pathlen;		/* strlen(pathname) */
 	const char *filename;	/* filename */
 	size_t filelen;		/* strlen(filename) */
 	struct stat *st;	/* file stat */
 
-	int files;
-	int directories;
-	int t_whiteouts;	/* total whiteouts */
-	int i_whiteouts;	/* invalid whiteouts */
-	int t_redirects;	/* total redirect dirs */
-	int i_redirects;	/* invalid redirect dirs */
+	struct scan_dir_data *ddata;	/* parent dir data of current target */
 };
 
 /* Directories scan callback operations struct */
 struct scan_operations {
 	int (*whiteout)(struct scan_ctx *);
 	int (*redirect)(struct scan_ctx *);
+	int (*origin)(struct scan_ctx *);
+	int (*impure)(struct scan_ctx *);
 };
 
 static inline void set_st_inconsistency(int *st)
-- 
2.9.5
