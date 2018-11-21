From: Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH v1 3/4] f2fs: fix race between llseek SEEK_END and write
Date: Wed, 21 Nov 2018 11:43:59 +0900
Message-ID: <20181121024400.4346-4-devel@etsukata.com>
References: <20181121024400.4346-1-devel@etsukata.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: andi@firstfloor.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-unionfs@vger.kernel.org
Cc: Eiichi Tsukata <devel@etsukata.com>
List-Id: linux-unionfs@vger.kernel.org

This patch itself seems to be just a cleanup but with the
commit b25bd1d9fd87 ("vfs: fix race between llseek SEEK_END and write")
it fixes race.

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/f2fs/file.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 88b124677189..14a923607eff 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -447,15 +447,11 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 
 static loff_t f2fs_llseek(struct file *file, loff_t offset, int whence)
 {
-	struct inode *inode = file->f_mapping->host;
-	loff_t maxbytes = inode->i_sb->s_maxbytes;
-
 	switch (whence) {
 	case SEEK_SET:
 	case SEEK_CUR:
 	case SEEK_END:
-		return generic_file_llseek_size(file, offset, whence,
-						maxbytes, i_size_read(inode));
+		return generic_file_llseek(file, offset, whence);
 	case SEEK_DATA:
 	case SEEK_HOLE:
 		if (offset < 0)
-- 
2.19.1
