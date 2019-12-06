Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: relax WARN_ON() on rename to self
Date: Fri,  6 Dec 2019 08:33:36 +0200
Message-Id: <20191206063336.9722-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
List-ID: <linux-unionfs@vger.kernel.org>

In ovl_rename(), if new upper is hardlinked to old upper underneath
overlayfs before upper dirs are locked, user will get an ESTALE error
and a WARN_ON will be printed.

Changes to underlying layers while overlayfs is mounted may result in
unexpected behavior, but it shouldn't crash the kernel and it shouldn't
trigger WARN_ON() either, so relax this WARN_ON().

Reported-by: syzbot+bb1836a212e69f8e201a@syzkaller.appspotmail.com
Fixes: 804032fabb3b ("ovl: don't check rename to self")
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 702aa63f6774..29abdb1d3b5c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1170,7 +1170,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	if (newdentry == trap)
 		goto out_dput;
 
-	if (WARN_ON(olddentry->d_inode == newdentry->d_inode))
+	if (olddentry->d_inode == newdentry->d_inode)
 		goto out_dput;
 
 	err = 0;
-- 
2.17.1
