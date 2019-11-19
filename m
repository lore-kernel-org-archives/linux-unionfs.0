Return-Path: <jiufei.xue@linux.alibaba.com>
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [PATCH 0/2] ovl: implement async IO routines 
Date: Tue, 19 Nov 2019 10:14:01 +0800
Message-Id: <1574129643-14664-1-git-send-email-jiufei.xue@linux.alibaba.com>
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

ovl stacks regular file operations now. However it doesn't implement
async IO routines and will convert async IOs to sync IOs which is not
expected.

This patchset implements overlayfs async IO routines.

Jiufei Xue (2)
vfs: add vfs_iocb_iter_[read|write] helper functions
ovl: implement async IO routines

 fs/overlayfs/file.c      |   97 ++++++-----------------------------------------
 fs/overlayfs/overlayfs.h |    2
 fs/overlayfs/super.c     |   12 -----
 fs/read_write.c          |   58 ----------------------------
 include/linux/fs.h       |   16 -------
 5 files changed, 16 insertions(+), 169 deletions(-)
