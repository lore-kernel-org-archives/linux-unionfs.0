From: Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH v1 1/4] vfs: fix race between llseek SEEK_END and write
Date: Wed, 21 Nov 2018 11:43:57 +0900
Message-ID: <20181121024400.4346-2-devel@etsukata.com>
References: <20181121024400.4346-1-devel@etsukata.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: andi@firstfloor.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-unionfs@vger.kernel.org
Cc: Eiichi Tsukata <devel@etsukata.com>
List-Id: linux-unionfs@vger.kernel.org

The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
removed almost all locks in llseek() including SEEK_END. It based on the
idea that write() updates size atomically. But in fact, write() can be
divided into two or more parts in generic_perform_write() when pos
straddles over the PAGE_SIZE, which results in updating size multiple
times in one write(). It means that llseek() can see the size being
updated during write().

This race changes behavior of some applications. 'tail' is one of those
applications. It reads range [pos, pos_end] where pos_end is obtained
via llseek() SEEK_END. Sometimes, a read line could be broken.

reproducer:

  $ while true; do echo 123456 >> out; done
  $ while true; do tail out | grep -v 123456 ; done

example output(take 30 secs):

  12345
  1
  1234
  1
  12
  1234

This patch re-introduces generic_file_llseek_unlocked() and implements a
lock for SEEK_END/DATA/HOLE in generic_file_llseek(). I replaced all
generic_file_llseek() callers with _unlocked() if they are called with a
inode lock.

All file systems which call generic_file_llseek_size() directly
are fixed in the later commits.

Fixes: ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/btrfs/file.c    |  2 +-
 fs/fuse/file.c     |  5 +++--
 fs/gfs2/file.c     |  3 ++-
 fs/read_write.c    | 37 ++++++++++++++++++++++++++++++++++---
 include/linux/fs.h |  2 ++
 5 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a3c22e16509b..ec932fa0f8a9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3256,7 +3256,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 	switch (whence) {
 	case SEEK_END:
 	case SEEK_CUR:
-		offset = generic_file_llseek(file, offset, whence);
+		offset = generic_file_llseek_unlocked(file, offset, whence);
 		goto out;
 	case SEEK_DATA:
 	case SEEK_HOLE:
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b52f9baaa3e7..e220b848929b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2336,13 +2336,14 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int whence)
 	case SEEK_SET:
 	case SEEK_CUR:
 		 /* No i_mutex protection necessary for SEEK_CUR and SEEK_SET */
-		retval = generic_file_llseek(file, offset, whence);
+		retval = generic_file_llseek_unlocked(file, offset, whence);
 		break;
 	case SEEK_END:
 		inode_lock(inode);
 		retval = fuse_update_attributes(inode, file);
 		if (!retval)
-			retval = generic_file_llseek(file, offset, whence);
+			retval = generic_file_llseek_unlocked(file, offset,
+							      whence);
 		inode_unlock(inode);
 		break;
 	case SEEK_HOLE:
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 45a17b770d97..171df9550c27 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -66,7 +66,8 @@ static loff_t gfs2_llseek(struct file *file, loff_t offset, int whence)
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
-			error = generic_file_llseek(file, offset, whence);
+			error = generic_file_llseek_unlocked(file, offset,
+							     whence);
 			gfs2_glock_dq_uninit(&i_gh);
 		}
 		break;
diff --git a/fs/read_write.c b/fs/read_write.c
index bfcb4ced5664..859dbac5b2f6 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -131,6 +131,24 @@ generic_file_llseek_size(struct file *file, loff_t offset, int whence,
 }
 EXPORT_SYMBOL(generic_file_llseek_size);
 
+/**
+ * generic_file_llseek_unlocked - lockless generic llseek implementation
+ * @file:	file structure to seek on
+ * @offset:	file offset to seek to
+ * @whence:	type of seek
+ *
+ */
+loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
+				    int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	return generic_file_llseek_size(file, offset, whence,
+					inode->i_sb->s_maxbytes,
+					i_size_read(inode));
+}
+EXPORT_SYMBOL(generic_file_llseek_unlocked);
+
 /**
  * generic_file_llseek - generic llseek implementation for regular files
  * @file:	file structure to seek on
@@ -144,10 +162,23 @@ EXPORT_SYMBOL(generic_file_llseek_size);
 loff_t generic_file_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
+	loff_t retval;
 
-	return generic_file_llseek_size(file, offset, whence,
-					inode->i_sb->s_maxbytes,
-					i_size_read(inode));
+	switch (whence) {
+	default:
+		return generic_file_llseek_unlocked(file, offset, whence);
+	case SEEK_END:
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		/*
+		 * protects against inode size race with write so that llseek
+		 * doesn't see inode size being updated in write.
+		 */
+		inode_lock_shared(inode);
+		retval = generic_file_llseek_unlocked(file, offset, whence);
+		inode_unlock_shared(inode);
+		return retval;
+	}
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c95c0807471f..ee35d7c013cb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3054,6 +3054,8 @@ extern loff_t noop_llseek(struct file *file, loff_t offset, int whence);
 extern loff_t no_llseek(struct file *file, loff_t offset, int whence);
 extern loff_t vfs_setpos(struct file *file, loff_t offset, loff_t maxsize);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int whence);
+extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
+		int whence);
 extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
 		int whence, loff_t maxsize, loff_t eof);
 extern loff_t fixed_size_llseek(struct file *file, loff_t offset,
-- 
2.19.1
