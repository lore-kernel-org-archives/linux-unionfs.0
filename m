From: Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
Date: Wed, 21 Nov 2018 11:43:56 +0900
Message-ID: <20181121024400.4346-1-devel@etsukata.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: andi@firstfloor.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, Bob Peterson <rpeterso@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-unionfs@vger.kernel.org
Cc: Eiichi Tsukata <devel@etsukata.com>
List-Id: linux-unionfs@vger.kernel.org

Some file systems (including ext4, xfs, ramfs ...) have the following
problem as I've described in the commit message of the 1/4 patch.

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

Note: Some file systems which indivisually implements llseek() and hold
      inode mutex lock in it are not affected. ex:) btrfs, ocfs2

Patch 1: re-implements inode lock for SEEK_END in generic_file_llseek()
Patch 2 to 4: implement inode lock for SEEK_END in each file systems

Eiichi Tsukata (4):
  vfs: fix race between llseek SEEK_END and write
  ext4: fix race between llseek SEEK_END and write
  f2fs: fix race between llseek SEEK_END and write
  overlayfs: fix race between llseek SEEK_END and write

 fs/btrfs/file.c     |  2 +-
 fs/ext4/file.c      | 10 ++++++++++
 fs/f2fs/file.c      |  6 +-----
 fs/fuse/file.c      |  5 +++--
 fs/gfs2/file.c      |  3 ++-
 fs/overlayfs/file.c | 23 ++++++++++++++++++++---
 fs/read_write.c     | 37 ++++++++++++++++++++++++++++++++++---
 include/linux/fs.h  |  2 ++
 8 files changed, 73 insertions(+), 15 deletions(-)

-- 
2.19.1
