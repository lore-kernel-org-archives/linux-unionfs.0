From: xuw2015@gmail.com
Subject: [PATCH 2/2] ovl: ovl_rename2 should do d_move by itself
Date: Thu,  3 Sep 2015 17:12:12 +0800
Message-ID: <1441271532-10386-2-git-send-email-xuw2015@gmail.com>
References: <1441271532-10386-1-git-send-email-xuw2015@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbbICJMT (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 3 Sep 2015 05:12:19 -0400
In-Reply-To: <1441271532-10386-1-git-send-email-xuw2015@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: George Wang <xuw2015@gmail.com>

From: George Wang <xuw2015@gmail.com>

ovl always creates new inode regardless of the fact that upper hardlink
shares same inode. If we do rename with dentries shared inode, there is
no real opertions, but vfs_rename will do the d_move after that.
And an intersting result will appear. The following step will explain
it:

echo 1234 > src
link src tgt
rename(src, tgt)
rm -f src
rm -f tgt

In upper level, src(upper) and tgt(upper) shares same inode; in ovl
level, src(ovl) and tgt(ovl) uses different inode. vfs_rename did
d_move, and dentry src(ovl) is renamed tgt, and dentry tgt(ovl) is
released. When unlink src, a new dentry src(ovl) is created, and is
removed, src(upper) is also removed; and then unlink tgt, renamed dentry
src(ovl) is removed, src(upper) is also removed(but for upper fs, the
src has already be removed).

ovl should call d_move/d_exchange by itself, then it can control wether
or not does it.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/overlayfs/dir.c   | 10 ++++++++++
 fs/overlayfs/super.c |  1 +
 2 files changed, 11 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 692ceda..1b02688 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -915,6 +915,16 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 	ovl_dentry_version_inc(old->d_parent);
 	ovl_dentry_version_inc(new->d_parent);
 
+	/*
+	 *FS_RENAME_DOES_D_MOVE is set in fs_flags, we need to do d_move/d_exchange
+	 *by ourselves. overwrite means no RENAME_EXCHANGE in flags, just do d_move;
+	 *d_exchange otherwise.
+	 */
+	if (overwrite)
+		d_move(old, new);
+	else
+		d_exchange(old, new);
+
 out_dput:
 	dput(newdentry);
 out_unlock:
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7466ff3..0395653 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1097,6 +1097,7 @@ static struct file_system_type ovl_fs_type = {
 	.name		= "overlay",
 	.mount		= ovl_mount,
 	.kill_sb	= kill_anon_super,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE,
 };
 MODULE_ALIAS_FS("overlay");
 
-- 
1.8.3.1
