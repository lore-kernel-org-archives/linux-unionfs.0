From: Ritesh Harjani <riteshh@linux.ibm.com>
Subject: [PATCH 0/1] Use inode_lock/unlock class of provided APIs in filesystems
Date: Thu,  5 Dec 2019 16:09:01 +0530
Message-ID: <20191205103902.23618-1-riteshh@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: willy@infradead.org, linux-fsdevel@vger.kernel.org, jlayton@kernel.org, viro@zeniv.linux.org.uk
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nfs@vger.kernel.org, devel@lists.orangefs.org, linux-unionfs@vger.kernel.org, Ritesh Harjani <riteshh@linux.ibm.com>
List-Id: linux-unionfs@vger.kernel.org

Matthew Wilcox in [1] suggested that it will be a good idea
to define some missing API instead of directly using i_rwsem in
filesystems drivers for lock/unlock/downgrade purposes.

This patch does that work. No functionality change in this patch.

After this there are only lockdep class of APIs at certain places
in filesystems which are directly using i_rwsem and second is XFS,
but it seems to be anyway defining it's own xfs_ilock/iunlock set
of APIs and 'iolock' naming convention for this lock.

[1]: https://www.spinics.net/lists/linux-ext4/msg68689.html

Ritesh Harjani (1):
  fs: Use inode_lock/unlock class of provided APIs in filesystems

 fs/btrfs/delayed-inode.c |  2 +-
 fs/btrfs/ioctl.c         |  4 ++--
 fs/ceph/io.c             | 24 ++++++++++++------------
 fs/nfs/io.c              | 24 ++++++++++++------------
 fs/orangefs/file.c       |  4 ++--
 fs/overlayfs/readdir.c   |  2 +-
 fs/readdir.c             |  4 ++--
 include/linux/fs.h       | 21 +++++++++++++++++++++
 8 files changed, 53 insertions(+), 32 deletions(-)

-- 
2.20.1
