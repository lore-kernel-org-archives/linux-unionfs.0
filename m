Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Fix write leases on overlayfs
Date: Sat,  8 Jun 2019 16:57:15 +0300
Message-Id: <20190608135717.8472-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Mimi Zohar <zohar@linux.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

This series fixes a v4.19 regression.

It also provides correct semantics w.r.t RDONLY open counter
that Bruce also needed for nfsd.

I marked both patches for stable v4.19.

I verified the changes using modified LTP fcntl tests [1],
which I ran over xfs and overlayfs.

Thanks,
Amir.

[1] https://github.com/amir73il/ltp/commits/overlayfs-devel

Amir Goldstein (2):
  vfs: replace i_readcount with a biased i_count
  locks: eliminate false positive conflicts for write lease

 fs/locks.c                        | 26 ++++++++++++++----------
 include/linux/fs.h                | 33 +++++++++++++++++++------------
 security/integrity/ima/ima_main.c |  2 +-
 3 files changed, 37 insertions(+), 24 deletions(-)

-- 
2.17.1
