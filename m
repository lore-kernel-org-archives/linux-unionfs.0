From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v4 2/5] fsck.overlay: correct redirect xattr check
Date: Thu, 18 Jan 2018 11:50:53 +0800
Message-ID: <20180118035056.17358-3-yi.zhang@huawei.com>
References: <20180118035056.17358-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180118035056.17358-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com, yizhang089@gmail.com
List-Id: linux-unionfs@vger.kernel.org

When we found a valid redirect xattr and the lower origin targed was
covered by a directory, it could be 1) an another redirect directory,
or 2) an opaque directory created after rename in overlayfs or 3) a
general directory created in the underlying directory when overlay is
offline. Currently, we only handled case 2, this patch cover the other
two cases.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 README.md |  27 ++++++----
 check.c   | 179 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 159 insertions(+), 47 deletions(-)

diff --git a/README.md b/README.md
index 95dd790..da6c48c 100644
--- a/README.md
+++ b/README.md
@@ -25,15 +25,24 @@ If an redirect directory is found, the following must be met:
 
 1) The directory path pointed by redirect xattr should exist in one of lower
    layers.
-2) The origin directory should be redirected only once, which means there is
-   only one redirect xattr point to this origin directory in all layers.
-3) A whiteout or an opaque directory with the same name to origin should exist
-   in the same directory as the redirect directory.
-
-If not, 1) The redirect xattr is invalid and need to remove 2) One of the
-redirect xattr is redundant but not sure which one is, ask user or warn in
-auto mode 3) Create a whiteout device or set opaque xattr to an existing
-directory if the parent directory was meregd or remove xattr if not.
+2) There must be something with the same name to the rename origin in upper
+   layer covering the lower target, could be a whiteout or a generic file,
+   could be an opaque directory or another redirect direcotry but not a merge
+   directory.
+3) The origin directory should be redirected by only once, which means this
+   origin directory should be redirected by an unique directory in all layers.
+
+If not,
+1) The redirect xattr is invalid and should remove.
+2) If nothing covering the redirect origin target, fix the missing whiteout.
+   If the redirect origin is covered by a generic directory, it becomes a
+   subcase of duplicate redirect directory (redirect direcotry duplicate with
+   an existing merge directory). Not sure the origin is a merge directory or
+   a redirected directory, so there are two options can fix this inconsistency:
+   a) remove the redirect xattr fsck found, or b) set opaque to the covering
+   directory. Ask user by default or warn in auto mode.
+3) Record redirect xattrs but not sure which one is invalid, ask user by
+   default and warn in auto mode.
 
 Usage
 =====
diff --git a/check.c b/check.c
index e73307d..e5415c9 100644
--- a/check.c
+++ b/check.c
@@ -470,6 +470,48 @@ static bool ovl_redirect_entry_find(const char *origin, int ostack,
 	return false;
 }
 
+static void ovl_redirect_entry_del(const char *origin, int ostack)
+{
+	struct ovl_redirect_entry *entry;
+	struct list_head *node, *tmp;
+
+	if (list_empty(&redirect_list))
+		return;
+
+	list_for_each_safe(node, tmp, &redirect_list) {
+		entry = list_entry(node, struct ovl_redirect_entry, list);
+
+		if (entry->ostack == ostack && !strcmp(entry->origin, origin)) {
+			print_debug(_("Redirect entry del: [%s %s %d][%s %d]\n"),
+				      entry->pathname,
+				      (entry->dirtype == OVL_UPPER) ? "upper" : "lower",
+				      (entry->dirtype == OVL_UPPER) ? 0 : entry->stack,
+				      entry->origin, entry->ostack);
+
+			list_del_init(node);
+			free(entry->pathname);
+			free(entry->origin);
+			free(entry);
+			return;
+		}
+	}
+}
+
+static bool ovl_redirect_is_duplicate(const char *origin, int ostack)
+{
+	int dirtype, stack;
+	char *dup;
+
+	if (ovl_redirect_entry_find(origin, ostack, &dirtype, &stack, &dup)) {
+		print_debug("Duplicate redirect dir found: Origin:%s in lower %d, "
+			    "Previous:%s in %s %d\n",
+			    origin, ostack, dup,
+			    (dirtype == OVL_UPPER) ? "upper" : "lower", stack);
+		return true;
+	}
+	return false;
+}
+
 static void ovl_redirect_free(void)
 {
 	struct ovl_redirect_entry *entry;
@@ -484,15 +526,72 @@ static void ovl_redirect_free(void)
 	}
 }
 
+static int ovl_do_remove_redirect(int dirfd, const char *pathname,
+				  int dirtype, int stack,
+				  int *total, int *invalid)
+{
+	struct ovl_lookup_data od = {0};
+	int du_dirtype, du_stack;
+	char *duplicate;
+	int ret;
+
+	ret = ovl_remove_redirect(dirfd, pathname);
+	if (ret)
+		goto out;
+
+	(*total)--;
+	(*invalid)--;
+
+	/* If lower corresponding dir exists, ask user to set opaque */
+	ret = ovl_lookup_lower(pathname, dirtype, stack, &od);
+	if (ret)
+		goto out;
+
+	if (!od.exist || !is_dir(&od.st))
+		goto out;
+
+	if (ovl_ask_question("Should set opaque dir", pathname,
+			     dirtype, stack, 0)) {
+		ret = ovl_set_opaque(dirfd, pathname);
+		goto out;
+	}
+
+	if (ovl_redirect_entry_find(od.pathname, od.stack, &du_dirtype,
+				    &du_stack, &duplicate)) {
+		/*
+		 * The redirect dir point to the same lower origin becomes
+		 * duplicate, should re-ask
+		 */
+		if ((du_dirtype == dirtype) && (du_stack == stack) &&
+		    ovl_ask_action("Duplicate redirect directory",
+                                   duplicate, du_dirtype, du_stack,
+                                   "Remove redirect", 0)) {
+			(*invalid)++;
+			ret = ovl_do_remove_redirect(dirfd, duplicate, dirtype,
+						     stack, total, invalid);
+			if (ret)
+				goto out;
+
+			ovl_redirect_entry_del(od.pathname, od.stack);
+		}
+	}
+out:
+	return ret;
+}
+
 /*
  * Get redirect origin directory stored in the xattr, check it's invlaid
  * or not, In auto-mode, invalid redirect xattr will be removed directly.
  * Do the follow checking:
  * 1) Check the origin directory exist or not. If not, remove xattr.
- * 2) Count how many directories the origin directory was redirected by.
- *    If more than one, there must be some inconsistency but not sure
- *    which one is invalid, ask user or warn in auto mode.
- * 3) Check and fix the missing whiteout or opaque in redierct parent dir.
+ * 2) Check and fix the missing whiteout of the redirect origin target.
+ * 3) Check redirect xattr duplicate with merge directory or another
+ *    redirect directory.
+ * 4) When an invalid redirect xattr is removed from a directory, also check
+ *    whether it will duplicate with another redirect directory if the lower
+ *    corresponding directory exists.
+ * 5) If a duplicate redirect xattr is found, not sure which one is invalid
+ *    and how to deal with it, so ask user by default.
  */
 static int ovl_check_redirect(struct scan_ctx *sctx)
 {
@@ -523,43 +622,30 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 		goto out;
 
 	if (od.exist && is_dir(&od.st)) {
-		int dirtype, stack;
-		char *dup;
-
-		/* Check duplicate redirect xattr */
-		if (ovl_redirect_entry_find(od.pathname, od.stack,
-					    &dirtype, &stack, &dup)) {
-			print_info("Duplicate redirect dir found:%s\n", pathname);
-			print_info("Origin:%s in lower %d, "
-				   "Previous:%s in %s %d\n",
-				   od.pathname, od.stack, dup,
-				   (dirtype == OVL_UPPER) ? "upper" : "lower",
-				   stack);
-
+		/* Check duplicate with another redirect dir */
+		if (ovl_redirect_is_duplicate(od.pathname, od.stack)) {
 			sctx->i_redirects++;
 
 			/*
 			 * Not sure which one is invalid, don't remove in
 			 * auto mode
 			 */
-			if (ovl_ask_action("Duplicate redirect xattr", pathname,
-					   sctx->dirtype, sctx->stack,
-					   "Remove", 0))
+			if (ovl_ask_action("Duplicate redirect directory",
+					   pathname, sctx->dirtype, sctx->stack,
+					   "Remove redirect", 0))
 				goto remove_d;
+			else
+				goto out;
 		}
 
-		/* Now, this redirect xattr is valid */
-		ovl_redirect_entry_add(pathname, sctx->dirtype, sctx->stack,
-				       od.pathname, od.stack);
-
-		/* Check and fix whiteout or opaque dir */
+		/* Check duplicate with merge dir */
 		ret = ovl_lookup_single(sctx->dirfd, redirect, &cover_st,
 					&cover_exist);
 		if (ret)
 			goto out;
 		if (!cover_exist) {
 			/* Found nothing, create a whiteout */
-			if (ovl_ask_action("Missing cover whiteout", pathname,
+			if (ovl_ask_action("Missing whiteout", pathname,
 					   sctx->dirtype, sctx->stack,
 					   "Add", 1)) {
 				ret = ovl_create_whiteout(sctx->dirfd, redirect);
@@ -569,13 +655,33 @@ static int ovl_check_redirect(struct scan_ctx *sctx)
 				sctx->t_whiteouts++;
 			}
 		} else if (is_dir(&cover_st) &&
-			   !ovl_is_opaque(sctx->dirfd, redirect)) {
-
-			/* Found a directory but not opaqued, fix opaque xattr */
-			if ((ret = ovl_set_opaque(sctx->dirfd, redirect)))
+			   !ovl_is_opaque(sctx->dirfd, redirect) &&
+			   !ovl_is_redirect(sctx->dirfd, redirect)) {
+			/*
+			 * Found a directory merge with the same origin,
+			 * ask user to remove this duplicate redirect xattr
+			 * or set opaque to the cover directory
+			 */
+			sctx->i_redirects++;
+			if (ovl_ask_action("Duplicate redirect directory",
+					   pathname, sctx->dirtype, sctx->stack,
+					   "Remove redirect", 0)) {
+				goto remove_d;
+			} else if (ovl_ask_question("Should set opaque dir",
+						    redirect, sctx->dirtype,
+						    sctx->stack, 0)) {
+				ret = ovl_set_opaque(sctx->dirfd, redirect);
+				if (ret)
+					goto out;
+			} else {
 				goto out;
+			}
 		}
 
+		/* Now, this redirect xattr is valid */
+		ovl_redirect_entry_add(pathname, sctx->dirtype, sctx->stack,
+				       od.pathname, od.stack);
+
 		goto out;
 	}
 
@@ -583,16 +689,13 @@ remove:
 	sctx->i_redirects++;
 
 	/* Remove redirect xattr or ask user */
-	if (!ovl_ask_action("Invalid redirect xattr", pathname, sctx->dirtype,
-			    sctx->stack, "Remove", 1))
+	if (!ovl_ask_action("Invalid redirect directory", pathname, sctx->dirtype,
+			    sctx->stack, "Remove redirect", 1))
 		goto out;
 remove_d:
-	ret = ovl_remove_redirect(sctx->dirfd, pathname);
-	if (ret)
-		goto out;
-
-	sctx->t_redirects--;
-	sctx->i_redirects--;
+	ret = ovl_do_remove_redirect(sctx->dirfd, pathname, sctx->dirtype,
+				     sctx->stack, &sctx->t_redirects,
+				     &sctx->i_redirects);
 out:
 	free(redirect);
 	return ret;
-- 
2.9.5
