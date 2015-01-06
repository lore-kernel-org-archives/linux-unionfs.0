From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH] ovl: Fix opaque regression in ovl_lookup
Date: Tue, 6 Jan 2015 16:10:01 +0800
Message-ID: <54AB9859.6070704@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Current multi-layer support overlayfs has a regression in
.lookup(). If there is a directory in upperdir and a regular
file has same name in lowerdir in a merged directory, lower
file is hidden and upper directory is set to opaque in former
case. But it is changed in present code.

In lowerdir lookup path, if a found inode is not directory,
the type checking of previous inode is missing. This inode
will be copied to the lowerstack of ovl_entry directly.

That will lead to several wrong conditions, for example,
the reading of the directory in upperdir may return an error
like:

   ls: reading directory .: Not a directory

This patch makes the lowerdir lookup path check the opaque
for non-directory file too.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/overlayfs/super.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d50e3ed..47ab5f4 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -400,15 +400,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 *
 		 * FIXME: check for opaqueness maybe better done in remove code.
 		 */
-		if (!S_ISDIR(this->d_inode->i_mode)) {
+		if (!S_ISDIR(this->d_inode->i_mode))
 			opaque = true;
-		} else if (prev && (!S_ISDIR(prev->d_inode->i_mode) ||
-				    !S_ISDIR(this->d_inode->i_mode))) {
+
+		if (prev && (!S_ISDIR(prev->d_inode->i_mode) ||
+			     !S_ISDIR(this->d_inode->i_mode))) {
 			if (prev == upperdentry)
 				upperopaque = true;
 			dput(this);
 			break;
 		}
+
 		stack[ctr].dentry = this;
 		stack[ctr].mnt = lowerpath.mnt;
 		ctr++;
-- 
1.6.0.2

