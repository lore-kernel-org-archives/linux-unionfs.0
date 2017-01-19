From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] overlayfs: support freeze/thaw/syncfs
Date: Thu, 19 Jan 2017 14:13:26 +0200
Message-ID: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos,

I implemented freeze/thaw of overlayfs, because I need it for
overlay snapshots (CoW decision is made before mnt_wat_write(upper)
and I need to serialize it with snapshot take).

Not sure if there are other use cases for overlayfs freeze??

Tested freeze stress with xfstest generic/068 generic/390.

While staring at the code, I realized that syncfs(2) for overlayfs
seems broken.  It looks like only inodes are synced and upper fs
metadata is not being flushed, but I could be wrong.

Tested sync sanity with -g quick (although no test calls syncfs directly).
Tested the usual unionmount sanity over xfs and over tmpfs.

I am not sure exactly how to write a test case to verify this alleged
breakage?

Jan,

Can you please have a look?

Thanks,

Amir.

Amir Goldstein (2):
  ovl: support freeze/thaw super
  ovl: properly implement sync_filesystem()

 fs/overlayfs/super.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

-- 
2.7.4

