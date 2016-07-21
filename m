From: <zhangaihua1@huawei.com>
Subject: [PATCH] ovl: support ltp/testcase/bin/inotify04 on overlayfs
Date: Thu, 21 Jul 2016 18:19:51 +0800
Message-ID: <1469096391-4247-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: Aihua Zhang <zhangaihua1@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

From: Aihua Zhang <zhangaihua1@huawei.com>

after patch:
[root@localhost bin]# ./inotify04
inotify04    1  TPASS  :  got event: wd=1 mask=400 cookie=0 len=0 name=""
inotify04    2  TPASS  :  got event: wd=1 mask=8000 cookie=0 len=0 name=""
inotify04    3  TPASS  :  got event: wd=2 mask=4 cookie=0 len=0 name=""
inotify04    4  TPASS  :  got event: wd=2 mask=400 cookie=0 len=0 name=""
inotify04    5  TPASS  :  got event: wd=2 mask=8000 cookie=0 len=0 name=""

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
 fs/dcache.c          |    8 ++++++--
 fs/overlayfs/inode.c |    2 +-
 include/linux/fs.h   |    1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7654509..0db095d 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -313,7 +313,9 @@ static void dentry_iput(struct dentry * dentry)
 		hlist_del_init(&dentry->d_u.d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
-		if (!inode->i_nlink)
+		if ((!inode->i_nlink) ||
+			((inode->i_flags & S_SPECIAL_OVL) &&
+			(1 == inode->i_nlink)))
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
 			dentry->d_op->d_iput(dentry, inode);
@@ -339,7 +341,9 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	dentry_rcuwalk_barrier(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
-	if (!inode->i_nlink)
+	if ((!inode->i_nlink) ||
+		((inode->i_flags & S_SPECIAL_OVL) &&
+		(1 == inode->i_nlink)))
 		fsnotify_inoderemove(inode);
 	if (dentry->d_op && dentry->d_op->d_iput)
 		dentry->d_op->d_iput(dentry, inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e696ba3..eb57b96 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -399,7 +399,7 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 
 	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
-	inode->i_flags |= S_NOATIME | S_NOCMTIME;
+	inode->i_flags |= S_NOATIME | S_NOCMTIME | S_SPECIAL_OVL;
 
 	switch (mode) {
 	case S_IFDIR:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2a41353..6e763d7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1610,6 +1610,7 @@ struct super_operations {
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
 #define S_NOSEC		4096	/* no suid or xattr security attributes */
+#define S_SPECIAL_OVL   8192    /* special inode means ovlerlayfs */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
-- 
1.7.1
