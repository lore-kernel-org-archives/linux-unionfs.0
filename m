From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v7 06/14] ovl: Move couple of copy up functions in copy_up.c
Date: Thu, 16 Nov 2017 17:03:27 -0500
Message-ID: <20171116220335.13448-7-vgoyal@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936101AbdKPWDp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2017 17:03:45 -0500
In-Reply-To: <20171116220335.13448-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: vgoyal@redhat.com, amir73il@gmail.com, miklos@szeredi.hu

Right now two copy up related functions are part of inode.c. Amir suggested
it might be better to move these to copy_up.c. Hence this patch does that.
There will one more related function which will come in later patch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 30 ++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c   | 30 ------------------------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 303794bb9127..f84ba12c9b05 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -232,6 +232,36 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
+static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
+{
+	if (ovl_dentry_upper(dentry) &&
+	    ovl_dentry_has_upper_alias(dentry))
+		return false;
+
+	if (special_file(d_inode(dentry)->i_mode))
+		return false;
+
+	if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
+		return false;
+
+	return true;
+}
+
+int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
+{
+	int err = 0;
+
+	if (ovl_open_need_copy_up(dentry, file_flags)) {
+		err = ovl_want_write(dentry);
+		if (!err) {
+			err = ovl_copy_up_flags(dentry, file_flags);
+			ovl_drop_write(dentry);
+		}
+	}
+
+	return err;
+}
+
 struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
 {
 	struct ovl_fh *fh;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 00b6b294272a..e94a89e8a0f4 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -341,36 +341,6 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
-{
-	if (ovl_dentry_upper(dentry) &&
-	    ovl_dentry_has_upper_alias(dentry))
-		return false;
-
-	if (special_file(d_inode(dentry)->i_mode))
-		return false;
-
-	if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
-		return false;
-
-	return true;
-}
-
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
-{
-	int err = 0;
-
-	if (ovl_open_need_copy_up(dentry, file_flags)) {
-		err = ovl_want_write(dentry);
-		if (!err) {
-			err = ovl_copy_up_flags(dentry, file_flags);
-			ovl_drop_write(dentry);
-		}
-	}
-
-	return err;
-}
-
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags)
 {
 	struct dentry *alias;
-- 
2.13.6
