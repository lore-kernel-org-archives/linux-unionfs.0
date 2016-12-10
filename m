From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] vfs misc fixes
Date: Sat, 10 Dec 2016 21:33:34 +0100
Message-ID: <20161210203334.GJ2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git misc

- Fix bad_inode;
- fixes in copy_file_range.

Thanks,
Miklos

---
Miklos Szeredi (4):
      bad_inode: add missing i_op initializers
      vfs: check file types in vfs_copy_file_range()
      vfs: check PREAD/PWRITE in vfs_copy_file_range()
      vfs: reorder checks in vfs_copy_file_range()

---
 fs/bad_inode.c  | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/read_write.c | 36 ++++++++++++++++++++++++++----------
 2 files changed, 77 insertions(+), 14 deletions(-)
