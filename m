From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] ovl: properly implement sync_fs()
Date: Fri, 27 Jan 2017 19:41:29 +0200
Message-ID: <1485538889-14240-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

overlayfs syncs all inode pages on sync_filesystem(), but it also
needs to call s_op->sync_fs() of upper fs for metadata sync.

This fixes correctness of syncfs(2) as demonstrated by following
xfs specific test:

xfs_sync_stats()
{
	echo $1
	echo -n "xfs_log_force = "
	grep log /proc/fs/xfs/stat  | awk '{ print $5 }'
}

xfs_sync_stats "before touch"
touch x
xfs_sync_stats "after touch"
xfs_io -c syncfs .
xfs_sync_stats "after syncfs"
xfs_io -c fsync x
xfs_sync_stats "after fsync"
xfs_io -c fsync x
xfs_sync_stats "after fsync #2"

When this test is run in overlay mount over xfs, log force
count does not increase with syncfs command.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Miklos,

Re-posting this one proven bug fix detached from the overlay freeze series
that needs more work.

If you have some free cycles, I would love to get some feedback on
the change "vfs: freeze protect overlay inode on file_start_write()"

Thanks,
Amir.

v3:
- Added reviewed-by hch
- Detached from ovl freeze series

v2:
- Add test case to commit msg

v1:
- Same code as v3

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 6792bb7..346f668 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -160,6 +160,25 @@ static void ovl_put_super(struct super_block *sb)
 	kfree(ufs);
 }
 
+static int ovl_sync_fs(struct super_block *sb, int wait)
+{
+	struct ovl_fs *ufs = sb->s_fs_info;
+	struct super_block *upper_sb;
+	int ret;
+
+	if (!ufs->upper_mnt)
+		return 0;
+	upper_sb = ufs->upper_mnt->mnt_sb;
+	if (!upper_sb->s_op->sync_fs)
+		return 0;
+
+	/* real inodes have already been synced by sync_filesystem(ovl_sb) */
+	down_read(&upper_sb->s_umount);
+	ret = upper_sb->s_op->sync_fs(upper_sb, wait);
+	up_read(&upper_sb->s_umount);
+	return ret;
+}
+
 /**
  * ovl_statfs
  * @sb: The overlayfs super block
@@ -222,6 +241,7 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
+	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
 	.show_options	= ovl_show_options,
 	.remount_fs	= ovl_remount,
-- 
2.7.4

