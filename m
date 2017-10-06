From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ovl: Relax same fs constraint for constant d_ino
Date: Fri,  6 Oct 2017 14:55:35 +0530
Message-ID: <20171006092535.15199-3-chandan@linux.vnet.ibm.com>
References: <20171006092535.15199-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751784AbdJFJZB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 05:25:01 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v969OxE6034906
        for <linux-unionfs@vger.kernel.org>; Fri, 6 Oct 2017 05:25:01 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2de41csddh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 05:25:01 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 6 Oct 2017 03:25:00 -0600
In-Reply-To: <20171006092535.15199-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, miklos@szeredi.hu

For a pure upper dir in a non-samefs setup, ovl_getattr() returns the
overlay inode number as the value of st_ino. To keep in line with this
behaviour, ovl_fill_real() has been modified to return overlay inode
number of the "." entry as the d_ino of a pure upper dir.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/overlayfs/readdir.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 02f48cb..21e82ff 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -428,7 +428,6 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
  * sure that d_ino will be consistent with st_ino from stat(2).
  */
 static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
-
 {
 	struct dentry *dir = path->dentry;
 	struct dentry *this = NULL;
@@ -436,9 +435,6 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	u64 ino = p->real_ino;
 	int err = 0;
 
-	if (!ovl_same_sb(dir->d_sb))
-		goto out;
-
 	if (p->name[0] == '.') {
 		if (p->len == 1) {
 			this = dget(dir);
@@ -470,8 +466,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
 		if (err)
 			goto fail;
-
-		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
+		if (d_is_dir(this) || ovl_same_sb(this->d_sb))
+			WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		ino = stat.ino;
 	}
 
@@ -593,6 +589,7 @@ struct ovl_readdir_translate {
 	struct ovl_dir_cache *cache;
 	struct dir_context ctx;
 	u64 parent_ino;
+	u64 current_ino;
 };
 
 static int ovl_fill_real(struct dir_context *ctx, const char *name,
@@ -605,6 +602,8 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
 
 	if (rdt->parent_ino && strcmp(name, "..") == 0)
 		ino = rdt->parent_ino;
+	else if (rdt->current_ino && namelen == 1 && name[0] == '.')
+		ino = rdt->current_ino;
 	else if (rdt->cache) {
 		struct ovl_cache_entry *p;
 
@@ -645,6 +644,9 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 			return PTR_ERR(rdt.cache);
 	}
 
+	if (!ovl_same_sb(dir->d_sb))
+		rdt.current_ino = dir->d_inode->i_ino;
+
 	return iterate_dir(od->realfile, &rdt.ctx);
 }
 
@@ -665,9 +667,9 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		 * dir is impure then need to adjust d_ino for copied up
 		 * entries.
 		 */
-		if (ovl_same_sb(dentry->d_sb) &&
-		    (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
-		     OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)))) {
+		if (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
+		     OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)) ||
+		     !ovl_same_sb(dentry->d_sb)) {
 			return ovl_iterate_real(file, ctx);
 		}
 		return iterate_dir(od->realfile, ctx);
-- 
2.9.5
