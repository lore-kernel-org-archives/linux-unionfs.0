From: Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH v1 2/4] ext4: fix race between llseek SEEK_END and write
Date: Wed, 21 Nov 2018 11:43:58 +0900
Message-ID: <20181121024400.4346-3-devel@etsukata.com>
References: <20181121024400.4346-1-devel@etsukata.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: andi@firstfloor.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-unionfs@vger.kernel.org
Cc: Eiichi Tsukata <devel@etsukata.com>
List-Id: linux-unionfs@vger.kernel.org

Implement individual lock for SEEK_END for ext4 which directly calls
generic_file_llseek_size().

Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 fs/ext4/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 69d65d49837b..6479f3066043 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -477,6 +477,16 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	default:
 		return generic_file_llseek_size(file, offset, whence,
 						maxbytes, i_size_read(inode));
+	case SEEK_END:
+		/*
+		 * protects against inode size race with write so that llseek
+		 * doesn't see inode size being updated in generic_perform_write
+		 */
+		inode_lock_shared(inode);
+		offset = generic_file_llseek_size(file, offset, whence,
+						  maxbytes, i_size_read(inode));
+		inode_unlock_shared(inode);
+		return offset;
 	case SEEK_HOLE:
 		inode_lock_shared(inode);
 		offset = iomap_seek_hole(inode, offset, &ext4_iomap_ops);
-- 
2.19.1
