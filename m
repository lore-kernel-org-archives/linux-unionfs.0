From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 5/6] fsck.overlay: fix lower target lookup
Date: Thu, 28 Dec 2017 19:40:22 +0800
Message-ID: <20171228114023.43999-6-yi.zhang@huawei.com>
References: <20171228114023.43999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:3193 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753131AbdL1Ldb (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:33:31 -0500
In-Reply-To: <20171228114023.43999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Current lower target lookup only check pathname in each lower layer
directly, not consider the following two cases:

1) Target's parent paths were covered by a file or an opaque directory
   in a middle layer which is upper than origin target.
2) Target's parent paths contains a redirect directory point to another
   lower directory, changing base directory is needed while scaning
   each lower layers.

Therefore, we may find the wrong target or miss the correct one. This
patch add parent path checking when scaning target in a specific layer,
following redirect if we find a redirect directory and terminate if we
find a file/whiteout or opaque directory.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 check.c | 268 +++++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 207 insertions(+), 61 deletions(-)

diff --git a/check.c b/check.c
index 6db41cd..033d4ba 100644
--- a/check.c
+++ b/check.c
@@ -33,13 +33,25 @@
 #include "lib.h"
 #include "check.h"
 
-/* Underlying information */
-struct ovl_lower_check {
-	unsigned int type;	/* check extent type */
+/* Lookup context */
+struct ovl_lookup_ctx {
+	char *path;		/* absolute path for lookup */
+	size_t dirlen;		/* base directory length */
+	bool last;		/* in last lower layer ? */
+	bool skip;		/* skip self check */
+
+	char *redirect;		/* redirect path for next lookup */
+	bool stop;		/* stop lookup */
+
+	struct stat st;		/* target's stat(2) */
+	bool exist;		/* tatget exist or not */
+};
 
-	bool exist;
-	char path[PATH_MAX];	/* exist pathname found, only valid if exist */
-	struct stat st;		/* only valid if exist */
+/* Underlying target information */
+struct ovl_lower_data {
+	bool exist;		/* tatget exist or not */
+	char path[PATH_MAX];	/* tatget's pathname */
+	struct stat st;		/* target's stat(2) */
 };
 
 /* Redirect information */
@@ -177,38 +189,179 @@ static inline int ovl_ask_question(const char *question, const char *pathname,
 	return ask_question("", action);
 }
 
+static int ovl_lookup_single(const char *path, struct stat *st, bool *exist)
+{
+	int ret = 0;
+
+	if (lstat(path, st) == 0) {
+		*exist = true;
+	} else {
+		if (errno != ENOENT && errno != ENOTDIR) {
+			print_err(_("Cannot stat %s: %s\n"), path,
+				    strerror(errno));
+			ret = -1;
+		}
+		*exist = false;
+	}
+
+	return ret;
+}
+
+static int ovl_lookup_layer(struct ovl_lookup_ctx *lctx)
+{
+	char *path = sstrdup(lctx->path);
+	char *p = NULL, *base = NULL;
+	int ret = 0;
+
+	if (!lctx->skip) {
+		ret = ovl_lookup_single(path, &lctx->st, &lctx->exist);
+		if (ret)
+			goto out;
+	}
+
+	if (lctx->exist || lctx->last)
+		goto out;
+
+	/* Check if we should stop or redirect for the next layer's lookup */
+
+	/* Skip current target */
+	base = path + lctx->dirlen;
+	p = path + strlen(path);
+	for (; *p != '/' && p > base; p--)
+		*p = '\0';
+	*p = '\0';
+
+	/*
+	 * Iterate to the first item in the path. If a redirect dir was found,
+	 * change path for the next lookup. If an opaque directory or a file
+	 * was found, stop lookup.
+	 */
+	while (p > base) {
+		char *next = NULL, *redirect = NULL;
+		size_t name_len = 0;
+		bool exist = false;
+		struct stat st;
+
+		for (next = p; *next != '/'; next--) {
+			if (next < base)
+				goto out;
+		}
+
+		ret = ovl_lookup_single(path, &st, &exist);
+		if (ret)
+			goto out;
+		if (!exist)
+			goto next;
+
+		if (!is_dir(&st) || ovl_is_opaque(path)) {
+			lctx->stop = true;
+			goto out;
+		}
+
+		if (ovl_is_redirect(path)) {
+			name_len = p - (next + 1);
+			ret = ovl_get_redirect(path, lctx->dirlen, name_len,
+					       &redirect);
+			if (ret)
+				goto out;
+
+			free(lctx->redirect);
+			lctx->redirect =
+				path_pack(NULL, 0, redirect,
+					  path_pick(lctx->path, strlen(path)));
+			free(redirect);
+			goto out;
+		}
+next:
+		*next = '\0';
+		p = next;
+	}
+out:
+	free(path);
+	return ret;
+}
+
 /*
- * Scan each lower dir lower than 'start' and check type matching,
- * we stop scan if we found something.
- *
- * skip: skip whiteout.
+ * Lookup the lower layers have the same target with the specific one or not.
  *
+ * Scan each lower directory start from the layer of 'start' and lookup target
+ * until find something (skip target founded in start layer), Iterate parent
+ * directories and check directory type, following redirect directory and
+ * terminate scan if there is a file or an opaque directory exists.
  */
-static int ovl_check_lower(const char *pathname, int start,
-			   struct ovl_lower_check *chk, bool skip)
+static int ovl_lookup_lower(const char *pathname, int dirtype, int start,
+			    struct ovl_lower_data *od)
 {
-	struct stat st;
+	struct ovl_lookup_ctx lctx = {0};
 	int i;
+	int ret = 0;
 
-	for (i = start; i < lower_num; i++) {
-		path_pack(chk->path, sizeof(chk->path), lowerdir[i], pathname);
+	if (dirtype == OVL_UPPER)
+		start = 0;
 
-		if (lstat(chk->path, &st) != 0) {
-			if (errno != ENOENT && errno != ENOTDIR) {
-				print_err(_("Cannot stat %s: %s\n"),
-					    chk->path, strerror(errno));
-				return -1;
-			}
-			continue;
-		}
-		if (skip && is_whiteout(&st))
-			continue;
+	if (dirtype == OVL_UPPER) {
+		lctx.path = path_pack(NULL, 0, upperdir, pathname);
+		lctx.dirlen = strlen(upperdir);
+		lctx.skip = true;
 
-		chk->exist = true;
-		chk->st = st;
-		break;
+		ret = ovl_lookup_layer(&lctx);
+		if (ret)
+			goto out;
 	}
-	return 0;
+
+	for (i = start; !lctx.stop && !lctx.exist && i < lower_num; i++) {
+		lctx.path = path_pack(NULL, 0, lowerdir[i],
+				      (lctx.redirect) ? lctx.redirect : pathname);
+		lctx.dirlen = strlen(lowerdir[i]);
+		lctx.skip = (dirtype == OVL_LOWER && i == start) ? true : false;
+		lctx.last = (i == lower_num - 1) ? true : false;
+
+		ret = ovl_lookup_layer(&lctx);
+		if (ret)
+			goto out;
+	}
+
+	od->exist = lctx.exist;
+	if (od->exist) {
+		strncpy(od->path, lctx.path, sizeof(od->path));
+		od->st = lctx.st;
+	}
+out:
+	free(lctx.redirect);
+	free(lctx.path);
+	return ret;
+}
+
+/*
+ * The same as ovl_lookup_lower() except start from the layer of 'start',
+ * not skip any target founded.
+ */
+static int ovl_lookup(const char *pathname, int start, struct ovl_lower_data *od)
+{
+	struct ovl_lookup_ctx lctx = {0};
+	int i;
+	int ret = 0;
+
+	for (i = start; !lctx.stop && !lctx.exist && i < lower_num; i++) {
+		lctx.path = path_pack(NULL, 0, lowerdir[i],
+				      (lctx.redirect) ? lctx.redirect : pathname);
+		lctx.dirlen = strlen(lowerdir[i]);
+		lctx.last = (i == lower_num - 1) ? true : false;
+
+		ret = ovl_lookup_layer(&lctx);
+		if (ret)
+			goto out;
+	}
+
+	od->exist = lctx.exist;
+	if (od->exist) {
+		strncpy(od->path, lctx.path, sizeof(od->path));
+		od->st = lctx.st;
+	}
+out:
+	free(lctx.redirect);
+	free(lctx.path);
+	return ret;
 }
 
 /*
@@ -220,8 +373,7 @@ static int ovl_check_whiteout(struct scan_ctx *sctx)
 {
 	const char *pathname = sctx->pathname;
 	const struct stat *st = sctx->st;
-	struct ovl_lower_check chk = {0};
-	int start;
+	struct ovl_lower_data od = {0};
 	int ret = 0;
 
 	/* Is a whiteout ? */
@@ -238,12 +390,11 @@ static int ovl_check_whiteout(struct scan_ctx *sctx)
 	 * Scan each corresponding lower directroy under this layer,
 	 * check is there a file or dir with the same name.
 	 */
-	start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
-	ret = ovl_check_lower(path_pick(pathname, sctx->dirlen),
-			      start, &chk, true);
+	ret = ovl_lookup_lower(path_pick(pathname, sctx->dirlen),
+			       sctx->dirtype, sctx->num, &od);
 	if (ret)
 		return ret;
-	if (chk.exist && !is_whiteout(&chk.st))
+	if (od.exist && !is_whiteout(&od.st))
 		goto out;
 
 remove:
@@ -352,8 +503,9 @@ static void ovl_redirect_free(void)
 static int ovl_check_redirect(struct scan_ctx *sctx)
 {
 	const char *pathname = sctx->pathname;
-	struct ovl_lower_check chk = {0};
-	struct stat rst;
+	struct ovl_lower_data od = {0};
+	struct stat cover_st;
+	bool cover_exist = false;
 	char *redirect = NULL, *cover_path = NULL;
 	int start;
 	int ret = 0;
@@ -368,24 +520,22 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 	sctx->t_redirects++;
 
 	/* Redirect dir in last lower dir ? */
-	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1) {
-		start = lower_num;
+	if (sctx->dirtype == OVL_LOWER && sctx->num == lower_num-1)
 		goto remove;
-	}
 
 	/* Scan lower directories to check redirect dir exist or not */
 	start = (sctx->dirtype == OVL_LOWER) ? sctx->num + 1 : 0;
-	ret = ovl_check_lower(redirect, start, &chk, false);
+	ret = ovl_lookup(redirect, start, &od);
 	if (ret)
 		goto out;
-	if (chk.exist && is_dir(&chk.st)) {
+	if (od.exist && is_dir(&od.st)) {
 		char *tmp;
 
 		/* Check duplicate in same layer */
-		if (ovl_redirect_entry_find(chk.path, sctx->dirtype,
+		if (ovl_redirect_entry_find(od.path, sctx->dirtype,
 					    sctx->num, &tmp)) {
 			print_info("Duplicate redirect directory found:%s\n", pathname);
-			print_info("Origin:%s Previous:%s\n", chk.path, tmp);
+			print_info("Origin:%s Previous:%s\n", od.path, tmp);
 
 			sctx->i_redirects++;
 
@@ -396,24 +546,21 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 		}
 
 		ovl_redirect_entry_add(pathname, sctx->dirtype,
-				       sctx->num, chk.path);
+				       sctx->num, od.path);
 
 		/* Check and fix whiteout or opaque dir */
 		cover_path = path_pack(cover_path, 0, sctx->dirname, redirect);
-		if (lstat(cover_path, &rst) != 0) {
-			if (errno != ENOENT && errno != ENOTDIR) {
-				print_err(_("Cannot stat %s: %s\n"),
-					    cover_path, strerror(errno));
-				goto out;
-			}
-
+		ret = ovl_lookup_single(cover_path, &cover_st, &cover_exist);
+		if (ret)
+			goto out;
+		if (!cover_exist) {
 			/* Found nothing, create a whiteout */
 			if ((ret = ovl_create_whiteout(cover_path)))
 				goto out;
 
 			sctx->t_whiteouts++;
 
-		} else if (is_dir(&rst) && !ovl_is_opaque(cover_path) &&
+		} else if (is_dir(&cover_st) && !ovl_is_opaque(cover_path) &&
 			   !ovl_is_redirect(cover_path)) {
 
 			/*
@@ -443,14 +590,13 @@ remove_d:
 	sctx->i_redirects--;
 
 	/* If lower directory exist, ask user to add opaque xattr to cover it */
-	if (start < lower_num) {
-		if ((ret = ovl_check_lower(path_pick(pathname, sctx->dirlen),
-					   start, &chk, false)))
-			goto out;
-		if (chk.exist && is_dir(&chk.st) &&
-		    !ovl_ask_question("Is merged dir", pathname, 1))
-			ret = ovl_set_opaque(pathname);
-	}
+	if ((ret = ovl_lookup_lower(path_pick(pathname, sctx->dirlen),
+				    sctx->dirtype, sctx->num, &od)))
+		goto out;
+	if (od.exist && is_dir(&od.st) &&
+	    !ovl_ask_question("Is merged dir", pathname, 1))
+		ret = ovl_set_opaque(pathname);
+
 out:
 	free(cover_path);
 	free(redirect);
-- 
2.9.5
