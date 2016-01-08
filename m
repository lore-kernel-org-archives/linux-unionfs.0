From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH] ovl: fix getcwd() failure after unsuccessful rmdir
Date: Fri,  8 Jan 2016 23:09:59 +0800
Message-ID: <1452265799-4549-1-git-send-email-rui.y.wang@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: viro@zeniv.linux.org.uk, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, rui.y.wang@intel.com
List-Id: linux-unionfs@vger.kernel.org

ovl_remove_upper() should do d_drop() only after it successfully
removes the dir, otherwise a subsequent getcwd() system call will
fail, breaking userspace programs.

This is to fix: https://bugzilla.kernel.org/show_bug.cgi?id=110491

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 fs/overlayfs/dir.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 692ceda..36d6a5b 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -618,7 +618,8 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	 * sole user of this dentry.  Too tricky...  Just unhash for
 	 * now.
 	 */
-	d_drop(dentry);
+	if (!err)
+		d_drop(dentry);
 	mutex_unlock(&dir->i_mutex);
 
 	return err;
-- 
1.7.5.4
