Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/2] Fix misaligned ovl_fh
Date: Fri, 15 Nov 2019 13:33:02 +0200
Message-Id: <20191115113304.16209-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

Beyond the regular tests, this has also been tortured
with my ovl-nested patches and tests.
Those have been very useful in flushing out nfs export bugs in the past
and they have also flushed out a few bugs from the RFC patch I sent
yesterday.

Thanks,
Amir.

Changes since RFC:
- Fix bug in ovl_verify_index()
- Open code ovl_dentry_to_fh() [Al]
- Zero buffer in ovl_encode_real_fh() [Al]
- Support decoding old (misaligned) file handles from the wire [Al]
- Add patch to simplify memory allocation in ovl_encode_real_fh() [Al]

Amir Goldstein (2):
  ovl: make sure that real fid is 32bit aligned in memory
  ovl: don't use a temp buf for encoding real fh

 fs/overlayfs/copy_up.c   | 53 +++++++++++++-------------
 fs/overlayfs/export.c    | 80 ++++++++++++++++++++++++----------------
 fs/overlayfs/namei.c     | 44 +++++++++++-----------
 fs/overlayfs/overlayfs.h | 34 ++++++++++++++---
 4 files changed, 124 insertions(+), 87 deletions(-)

-- 
2.17.1
