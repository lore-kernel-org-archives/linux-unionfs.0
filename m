From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 21/23] ovl: use inodes index on readonly mount
Date: Thu,  8 Jun 2017 18:00:47 +0300
Message-ID: <1496934049-11216-1-git-send-email-amir73il@gmail.com>
References: <CAOQ4uxjptLTC_qX5RpcCAwQyyRCq+Y7RHuXThCN32oChZL50Kg@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34734 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdFHPAo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Jun 2017 11:00:44 -0400
In-Reply-To: <CAOQ4uxjptLTC_qX5RpcCAwQyyRCq+Y7RHuXThCN32oChZL50Kg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

The inodes index is needed also with readonly mount to find indexed
lower hardlinks. Also, a readonly overlay mount can be remounted
readonly and then overlay dentries in cache should already have
the index entry cached.

Therefore, we need to disable the inodes index feature only in case
there are no upper/work dirs, and not when mounting readonly per
user request.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b53c08f70b1a..4cf18850b4de 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -251,6 +251,12 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
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
@@ -282,7 +288,7 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct ovl_fs *ufs = sb->s_fs_info;
 
-	if (!(*flags & MS_RDONLY) && (!ufs->upper_mnt || !ufs->workdir))
+	if (!(*flags & MS_RDONLY) && ovl_force_readonly(ufs))
 		return -EROFS;
 
 	return 0;
@@ -1060,7 +1066,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
-	if (!(sb->s_flags & MS_RDONLY) && ufs->config.index) {
+	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
 		/* Verify lower root is upper root origin */
 		err = ovl_verify_set_origin(upperpath.dentry,
 					    ufs->lower_mnt[0], stack[0].dentry,
@@ -1085,8 +1091,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		} else {
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
 		}
-
 	}
+	/* Show index=off/on in /proc/mounts for any of the reasons above */
+	if (!ufs->indexdir)
+		ufs->config.index = false;
 
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
-- 
2.7.4
