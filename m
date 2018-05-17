Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ovl: add warning and replace errno when failing from copy-up
Date: Thu, 17 May 2018 12:27:16 +0800
Message-Id: <1526531236-21809-1-git-send-email-cgxu519@gmx.com>
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Currently when failing from copy-up there is no meaningful message
to indicate what was happeing and also directly exposing copy-up
error to user probably makes confusing. For example, if copy-up failed
by upperdir/workdir are belong to different project quotas, write mode
open will present error as -EXDEV(Cross-device link).

This patch adds proper warning message and replaces errno with -EIO
when failing from copy-up.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/overlayfs/copy_up.c | 10 ++++++++++
 fs/overlayfs/export.c  |  4 +---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8bede07..4e1f890 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -825,6 +825,16 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	}
 	revert_creds(old_cred);
 
+	if (err) {
+		if (err == -EXDEV)
+			pr_warn_ratelimited("overlayfs: copy up failed, probably caused by project quota. (%pd2, err=%i)\n",
+				    dentry, err);
+		else
+			pr_warn_ratelimited("overlayfs: copy up failed. (%pd2, err=%i)\n",
+				    dentry, err);
+		err = -EIO;
+	}
+
 	return err;
 }
 
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 425a946..c66477f 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -30,9 +30,7 @@ static int ovl_encode_maybe_copy_up(struct dentry *dentry)
 	if (!err) {
 		err = ovl_copy_up(dentry);
 		ovl_drop_write(dentry);
-	}
-
-	if (err) {
+	} else {
 		pr_warn_ratelimited("overlayfs: failed to copy up on encode (%pd2, err=%i)\n",
 				    dentry, err);
 	}
-- 
1.8.3.1
