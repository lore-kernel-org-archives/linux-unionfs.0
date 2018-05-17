Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2] ovl: add warning and replace some errnos when failing from copy-up
Date: Thu, 17 May 2018 14:29:45 +0800
Message-Id: <1526538585-12756-1-git-send-email-cgxu519@gmx.com>
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Currently when failing from copy-up there is no meaningful message
to indicate what was happeing and also directly exposing some copy-up
errors to user probably makes confusing. For example, if copy-up failed
by upperdir/workdir are belong to different project quotas, open(2) with
write mode will present error as -EXDEV(Cross-device link).

This patch adds proper warning message and replaces
errno(-EXDEV, -EOPNOTSUPP) with -EIO when failing from copy-up.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
v1->v2:
- Only replace -EXDEV and -EOPNOTSUPP because other errnos are meaningful.
(Suggested by Amir)
- Leave NFS export related copy-up warning as is because warning on copy up
failure along is not a good enough hint.
(Suggested by Amir)

 fs/overlayfs/copy_up.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8bede07..a6bfe3c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -825,6 +825,19 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	}
 	revert_creds(old_cred);
 
+	if (err) {
+		if (err == -EXDEV) {
+			pr_warn_ratelimited("overlayfs: copy up failed, probably caused by project quota. (%pd2, err=%i)\n",
+				    dentry, err);
+			err = -EIO;
+		} else {
+			pr_warn_ratelimited("overlayfs: copy up failed. (%pd2, err=%i)\n",
+				    dentry, err);
+			if (err == -EOPNOTSUPP)
+				err = -EIO;
+		}
+	}
+
 	return err;
 }
 
-- 
1.8.3.1
