From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 2/3] ovl: simplify ovl_check_empty_and_clear()
Date: Tue, 31 Oct 2017 23:45:49 +0200
Message-ID: <1509486350-21362-3-git-send-email-amir73il@gmail.com>
References: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:47173 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932605AbdJaVpN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 17:45:13 -0400
Received: by mail-wr0-f196.google.com with SMTP id y39so344282wrd.4
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 14:45:12 -0700 (PDT)
In-Reply-To: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Filter out non-whiteout non-upper entries from list of merge dir entries
while checking if merge dir is empty in ovl_check_empty_dir().
The remaining work for ovl_clear_empty() is to clear all entries on the
list.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c     |  5 ++---
 fs/overlayfs/readdir.c | 27 ++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index cc961a3bd3bd..4edef400fe51 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -300,7 +300,6 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 {
 	int err;
 	struct dentry *ret = NULL;
-	enum ovl_path_type type = ovl_path_type(dentry);
 	LIST_HEAD(list);
 
 	err = ovl_check_empty_dir(dentry, &list);
@@ -313,13 +312,13 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 	 * When removing an empty opaque directory, then it makes no sense to
 	 * replace it with an exact replica of itself.
 	 *
-	 * If no upperdentry then skip clearing whiteouts.
+	 * If upperdentry has whiteouts, clear them.
 	 *
 	 * Can race with copy-up, since we don't hold the upperdir mutex.
 	 * Doesn't matter, since copy-up can't create a non-empty directory
 	 * from an empty one.
 	 */
-	if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
+	if (!list_empty(&list))
 		ret = ovl_clear_empty(dentry, &list);
 
 out_free:
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index ec902a7c1f4d..333de85d6de4 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -26,6 +26,7 @@ struct ovl_cache_entry {
 	struct list_head l_node;
 	struct rb_node node;
 	struct ovl_cache_entry *next_maybe_whiteout;
+	bool is_upper;
 	bool is_whiteout;
 	char name[];
 };
@@ -158,6 +159,7 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	/* Defer setting d_ino for upper entry to ovl_iterate() */
 	if (ovl_calc_d_ino(rdd, p))
 		p->ino = 0;
+	p->is_upper = rdd->is_upper;
 	p->is_whiteout = false;
 
 	if (d_type == DT_CHR) {
@@ -856,7 +858,7 @@ const struct file_operations ovl_dir_operations = {
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 {
 	int err;
-	struct ovl_cache_entry *p;
+	struct ovl_cache_entry *p, *n;
 	struct rb_root root = RB_ROOT;
 
 	err = ovl_dir_read_merged(dentry, list, &root);
@@ -865,18 +867,29 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 
 	err = 0;
 
-	list_for_each_entry(p, list, l_node) {
-		if (p->is_whiteout)
-			continue;
+	list_for_each_entry_safe(p, n, list, l_node) {
+		/*
+		 * Select whiteouts in upperdir, they should
+		 * be cleared when deleting this directory.
+		 */
+		if (p->is_whiteout) {
+			if (p->is_upper)
+				continue;
+			goto del_entry;
+		}
 
 		if (p->name[0] == '.') {
 			if (p->len == 1)
-				continue;
+				goto del_entry;
 			if (p->len == 2 && p->name[1] == '.')
-				continue;
+				goto del_entry;
 		}
 		err = -ENOTEMPTY;
 		break;
+
+del_entry:
+		list_del(&p->l_node);
+		kfree(p);
 	}
 
 	return err;
@@ -890,7 +903,7 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 	list_for_each_entry(p, list, l_node) {
 		struct dentry *dentry;
 
-		if (!p->is_whiteout)
+		if (WARN_ON(!p->is_whiteout || !p->is_upper))
 			continue;
 
 		dentry = lookup_one_len(p->name, upper, p->len);
-- 
2.7.4
