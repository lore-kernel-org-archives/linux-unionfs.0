From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/5] overlayfs: support freeze/thaw
Date: Tue, 31 Jan 2017 10:34:54 +0200
Message-ID: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos,

Patches 1-3 address your review comments and some
issues I found with fallocate() and copy_file_range()
helpers.
They are supposed to replace the patch already in overlayfs-next
97e147358bea ("vfs: wrap write f_ops with file_{start,end}_write()")

Let me know if you want me to rebase them on top of the already
committed change.

Patches 4-5 implement overlayfs freeze and are more of an RFC
at this point, but they are tested.

v3:
- Verify regular file before calling file_start_write()

v2:
- file_start_write() gets freeze protection on both upper and overlay
- convert file ops wraped with sb_start_write() to file_start_write()

v1:
- freeze upper on freeze of overlay

Amir Goldstein (5):
  vfs: deny fallocate() on directory
  vfs: deny copy_file_range() for non regular files
  vfs: wrap write f_ops with file_{start,end}_write()
  vfs: freeze protect overlay inode on file_start_write()
  ovl: support freeze/thaw super

 fs/open.c            | 14 ++++++--------
 fs/overlayfs/super.c | 12 ++++++++++++
 fs/read_write.c      |  9 +++++++--
 include/linux/fs.h   | 43 +++++++++++++++++++++++++++++--------------
 4 files changed, 54 insertions(+), 24 deletions(-)

-- 
2.7.4

