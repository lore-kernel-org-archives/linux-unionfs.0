Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/3] Overlayfs file handle decode optimization
Date: Sun, 11 Mar 2018 13:22:51 +0200
Message-Id: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

This is the 2nd revision of patch set to optimize file handle decode.
It is available on branch ovl-nfs-export on my github [1].

Patch 2 introduces a semantic change to exportfs_decode_fh() to allow
callers to opt-out of reconnecting the dentry. I like this minimal
semantic chance, but if you think I should factor-out a "_noreconnect"
variant of exportfs_decode_fh(), I can do that. Also, in
ovl_lower_fh_to_d(), if we get a disconnected directory dentry and we
end up needing a connected dentry, we drop the reference to the
disconnected dentry and call exportfs_decode_fh() again without
opting-out of reconnect. I could also export exportfs_reconnect_path()
for that case, but seems unnecessary to do that as the disconnected
dentry will likely still be in cache anyway.

To verify optimization, I ran all the overlay/exportfs tests with trace
prints in index lookup and reconnect functions to verify that reconnect
is not called when decoding a lower dir file handle of a deleted dir.
Detailed analysis on this test results are in commit message of the last
patch.

Thanks,
Amir.

Changes since v1:
- Discard hash inodes by file handle
- Lookup in inode cache before lookup in index dir
- Lookup underlying fs inode cache without reconnect lower dir

[1] https://github.com/amir73il/linux/commits/ovl-nfs-export

Amir Goldstein (3):
  ovl: disambiguate ovl_encode_fh()
  ovl: do not try to reconnect a disconnected origin dentry
  ovl: lookup in inode cache first when decoding lower file handle

 fs/exportfs/expfs.c      |  9 +++++++
 fs/overlayfs/copy_up.c   |  6 ++---
 fs/overlayfs/export.c    | 70 +++++++++++++++++++++++++++---------------------
 fs/overlayfs/namei.c     | 20 +++++++-------
 fs/overlayfs/overlayfs.h |  7 ++---
 5 files changed, 66 insertions(+), 46 deletions(-)

-- 
2.7.4
