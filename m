Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/4] ovl: relax WARN_ON() real inode attributes mismatch
Date: Tue, 15 May 2018 13:26:10 +0300
Message-Id: <1526379972-20923-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs should cope with online changes to underlying layer
without crashing the kernel, which is what xfstest overlay/019
checks.

This test may sometimes trigger WARN_ON() in ovl_create_or_link()
when linking an overlay inode that has been changed on underlying
layer.

Replace those WARN_ON() with pr_warn_ratelimited() to prevent
test from failing and because this is more appropriate to the
use case.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 62e6733b755c..25b339278684 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -525,9 +525,17 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	if (!err) {
 		struct inode *realinode = d_inode(ovl_dentry_upper(dentry));
 
-		WARN_ON(inode->i_mode != realinode->i_mode);
-		WARN_ON(!uid_eq(inode->i_uid, realinode->i_uid));
-		WARN_ON(!gid_eq(inode->i_gid, realinode->i_gid));
+		if (inode->i_mode != realinode->i_mode ||
+		    !uid_eq(inode->i_uid, realinode->i_uid) ||
+		    !gid_eq(inode->i_gid, realinode->i_gid)) {
+			pr_warn_ratelimited("overlayfs: real inode attributes mismatch (%pd2, %o.%u.%u != %o.%u.%u).\n",
+				dentry, inode->i_mode,
+				from_kuid(&init_user_ns, inode->i_uid),
+				from_kgid(&init_user_ns, inode->i_gid),
+				realinode->i_mode,
+				from_kuid(&init_user_ns, realinode->i_uid),
+				from_kgid(&init_user_ns, realinode->i_gid));
+		}
 	}
 	return err;
 }
-- 
2.7.4
