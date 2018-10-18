Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Overlay inode lock cleanups
Date: Thu, 18 Oct 2018 18:37:12 +0300
Message-Id: <20181018153714.3834-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

First patch removes pretty big ugliness.
Second patch is just a matter of taste, so as you wish.

I'll use this opportunity to recap the queue of my proposed patches for
v4.20, so you can see if you missed to consider any of them:

* 5401b99fcbb9 - (overlayfs-devel) ovl: abstract ovl_inode lock with a helper
* 8edcbcef4e55 - ovl: remove the 'locked' argument of ovl_nlink_{start,end}
* bd2ea818ecca - ovl: relax requirement for non null uuid of lower fs
* 19c221c3a6b5 - ovl: disable new features for deprecated upper fs
* 1c785e83823c - ovl: untangle copy up call chain
* b67871490628 - (ovl-fixes) ovl: fix recursive oi->lock in ovl_link()
* e39a0eb89ae4 - vfs: fix FIGETBSZ ioctl on an overlayfs file
* 431d5170b91d - ovl: fix error handling in ovl_verify_set_fh()
* 388b00daecb8 - kernel/acct.c: fix locking order when switching acct files

Thanks,
Amir.

Amir Goldstein (2):
  ovl: remove the 'locked' argument of ovl_nlink_{start,end}
  ovl: abstract ovl_inode lock with a helper

 fs/overlayfs/dir.c       | 21 ++++++++++----------
 fs/overlayfs/overlayfs.h | 14 +++++++++++--
 fs/overlayfs/util.c      | 43 +++++++++++++++++++---------------------
 3 files changed, 43 insertions(+), 35 deletions(-)

-- 
2.17.1
