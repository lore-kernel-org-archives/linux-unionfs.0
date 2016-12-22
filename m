From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 4/4] ovl: use RENAME_DT_WHT to optimize ovl_dir_read_merged()
Date: Thu, 22 Dec 2016 19:25:35 +0200
Message-ID: <1482427535-12801-5-git-send-email-amir73il@gmail.com>
References: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:33998 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941680AbcLVR0A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Dec 2016 12:26:00 -0500
Received: by mail-wj0-f195.google.com with SMTP id ez4so2624578wjd.1
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Dec 2016 09:25:59 -0800 (PST)
In-Reply-To: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Try to use the new vfs rename flag RENAME_DT_WHT, to request from
underlying file system to mark whiteout directory entries as DT_WHT
instead of DT_CHR.

When whiteouts are classified as DT_WHT, ovl_dir_read_merged() can
distinguish between whiteouts to real character devices without
having to stat the suspect inodes.

Because this is only done for optimization, it is not a problem
if file system does not respect the new RENAME_DT_WHT flag, which
is most likely the case, so we retry the rename without the flag.

Even if DT_WHT type is set on rename using an experimental file
system patch, file system repair tools may later re-classify the
file type. That would break the optimization, but will not break
the functionality of ovl_dir_read_merged().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c     | 12 +++++++++---
 fs/overlayfs/readdir.c |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 16e06dd..0e1c3f2 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -630,7 +630,13 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 	struct dentry *upper;
 	struct dentry *opaquedir = NULL;
 	int err;
-	int flags = 0;
+	/*
+	 * Mark whiteout objects as DT_WHT instead of DT_CHR, so it easy
+	 * to distinguish them real character devices in iterate_dir().
+	 * File system repair tools may re-classify the file type
+	 * and that will break optimization, but not functionality.
+	 */
+	int flags = RENAME_DT_WHT;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -665,12 +671,12 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 		goto out_dput_upper;
 
 	if (d_is_dir(upper))
-		flags = RENAME_EXCHANGE;
+		flags |= RENAME_EXCHANGE;
 
 	err = ovl_do_rename(wdir, whiteout, udir, upper, flags);
 	if (err)
 		goto kill_whiteout;
-	if (flags)
+	if (flags & RENAME_EXCHANGE)
 		ovl_cleanup(wdir, upper);
 
 	ovl_dentry_version_inc(dentry->d_parent);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..32c5c96 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -98,7 +98,7 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	p->len = len;
 	p->type = d_type;
 	p->ino = ino;
-	p->is_whiteout = false;
+	p->is_whiteout = (d_type == DT_WHT);
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
-- 
2.7.4
