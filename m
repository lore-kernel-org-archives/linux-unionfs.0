From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7/7] ovl: prevent copy on read if no upper/work dir
Date: Thu, 30 Mar 2017 14:26:20 +0300
Message-ID: <1490873180-7433-1-git-send-email-amir73il@gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33002 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753898AbdC3L0Q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 07:26:16 -0400
Received: by mail-wr0-f193.google.com with SMTP id u18so11205480wrc.0
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Mar 2017 04:26:15 -0700 (PDT)
In-Reply-To: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On ro mount there are only ro fd's, so all fd's of the same file
are always consistent on a ro overlay mount.  But, if overlay can
be later remounted rw, we need to copy on read anyway, so that
ro fd that was opened during ro mount will be consistent with
rw fd that is opened after remount rw.

Therefore, we need to disable consistent_fd feature only in case
there are no upper/work dirs, so overlay can never be mounted rw.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Patch 5 should have prevented copy on read for ro mount,
but forgot to do so.

This extra patch relaxes the ro mount constrain and also
enforces the stronger contrain of no copy up if no upper/work.

If you're ok with the patch series, I can either fold this
patch into patch 5 or fix patch 5 and keep this one separate.

Amir.

 fs/overlayfs/super.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ef159f8..688c0b0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -222,6 +222,12 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return err;
 }
 
+/* Will this overlay be forced to mount/remount ro? */
+static bool ovl_force_readonly(struct ovl_fs *ufs)
+{
+	return (!ufs->upper_mnt || !ufs->workdir);
+}
+
 /**
  * ovl_show_options
  *
@@ -243,7 +249,7 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ufs->config.redirect_dir != ovl_redirect_dir_def)
 		seq_printf(m, ",redirect_dir=%s",
 			   ufs->config.redirect_dir ? "on" : "off");
-	if (!(sb->s_flags & MS_RDONLY) &&
+	if (!ovl_force_readonly(ufs) &&
 	    ufs->config.consistent_fd != ovl_consistent_fd_def)
 		seq_printf(m, ",consistent_fd=%s",
 			   ufs->config.consistent_fd ? "on" : "off");
@@ -254,7 +260,7 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct ovl_fs *ufs = sb->s_fs_info;
 
-	if (!(*flags & MS_RDONLY) && (!ufs->upper_mnt || !ufs->workdir))
+	if (!(*flags & MS_RDONLY) && ovl_force_readonly(ufs))
 		return -EROFS;
 
 	return 0;
@@ -942,8 +948,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ufs->upper_mnt)
 		sb->s_flags |= MS_RDONLY;
 
-	/* Copy on read for consistent fd depends on clone support */
-	if (!ufs->cloneup)
+	/*
+	 * Copy on read for consistent fd depends on clone support.
+	 * On ro mount fd is always consistent, but if overlay can be
+	 * later remounted rw, we need to copy on read anyway, so that
+	 * ro fd that was opened during ro mount will be consistent with
+	 * rw fd that is opened after remount rw.
+	 */
+	if (!ufs->cloneup || ovl_force_readonly(ufs))
 		ufs->config.consistent_fd = false;
 
 	if (remote)
-- 
2.7.4
