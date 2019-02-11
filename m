Return-Path: <iforster@suse.com>
From: Ignaz Forster <iforster@suse.com>
Subject: [RFC PATCH 0/5] Fix overlayfs on EVM
Date: Mon, 11 Feb 2019 17:53:18 +0100
Message-Id: <20190211165323.9369-1-iforster@suse.com>
To: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: Fabian Vogt <fvogt@suse.com>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

From: Ignaz Forster <iforster@suse.de>

This patch series tries to solve several problems found when using
EVM on an overlay file system.

Especially patch 4 and 5 will need further discussion; patch 4 will
introduce follow up problems, patch 5 can be considered a workaround
at best.

Ignaz Forster (4):
  Rename ima_post_create_tmpfile
  Execute IMA post create hook in vfs_create
  Ignore IMA / EVM xattrs during copy_up
  Use __vfs_getxattr to get overlayfs xattrs

Mimi Zohar (1):
  evm: instead of using the overlayfs i_ino, use the real i_ino

 fs/namei.c                          |  6 ++++--
 fs/overlayfs/inode.c                |  3 ++-
 include/linux/ima.h                 |  4 ++--
 security/integrity/evm/evm_crypto.c |  3 +++
 security/integrity/evm/evm_main.c   | 23 +++++++++++++++++++++++
 security/integrity/ima/ima_main.c   | 10 +++++-----
 6 files changed, 39 insertions(+), 10 deletions(-)

-- 
2.20.1
