From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 0/4] ovl: Do not hold s_vfs_rename_mutex during data copy up
Date: Sat, 12 Nov 2016 21:36:00 +0200
Message-ID: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

With these changes, different files data can be copied up concurrently and
data copy up will not block copy up of other files nor will it block other
rename operations on the underlaying fs.

Following 3 cleanup patches, the last patch implements the following locking
scheme:

Directories:
  <maybe> inode_lock(ovl_inode)
    lock_rename(workdir, upperdir)
      copy up dir to workdir
      move dir to upperdir

Special and zero size files:
  inode_lock(ovl_inode)
    lock_rename(workdir, upperdir)
      copy up file to workdir (no data)
      move file to upperdir

Regular files with data:
  inode_lock(ovl_inode)
    lock_rename(workdir, upperdir)
      copy up file to workdir (no data)
    unlock_rename(workdir, upperdir)
      copy data to file in workdir
    lock_rename(workdir, upperdir)
      move file to upperdir

Those changes are sanitity tested with xfstest -g quick, pjdfstest and
unionmount-testsuite.

Also tested that during copy up of 4gb file, it is possible to touch small files
on same overlay without blocking and rename files in underlying fs

Rename or touch the 4gb file before copy up is done will block until copy up is
done and complete there after.

Amir Goldstein (4):
  vfs: update documentation for inode operation locking rules
  ovl: add helper ovl_dentry_is_upper()
  ovl: fold ovl_copy_up_truncate() into ovl_copy_up()
  ovl: allow concurrent copy up data of differnt files

 Documentation/filesystems/Locking |  27 +++++-----
 fs/overlayfs/copy_up.c            | 100 ++++++++++++++++++++++++++++++++------
 fs/overlayfs/dir.c                |   4 +-
 fs/overlayfs/inode.c              |  36 ++------------
 fs/overlayfs/overlayfs.h          |   4 +-
 fs/overlayfs/readdir.c            |   2 +-
 fs/overlayfs/util.c               |   7 +++
 7 files changed, 116 insertions(+), 64 deletions(-)

-- 
2.7.4

