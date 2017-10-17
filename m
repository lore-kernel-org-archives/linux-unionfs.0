From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 00/14] Overlayfs NFS export support
Date: Tue, 17 Oct 2017 19:44:17 +0300
Message-ID: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos,

This series implements NFS export support [3] and is based on
two prep patch sets [1][2] posted earlier to overlayfs list.
NFS export is enabled for overlayfs mount with the 'verify_dir'
and 'index=all' mount options.

The current implementation will copy up and index directories when
directory file handles are encoded. Those extra copy ups could be
avoided in the future.

The current implementation does NOT support encoding connectable
non-dir file handles for all overlay path types, so overlayfs should
not be exported with the 'subtree_check' option.
I hope this is not a show stopper for merging NFS export support?

You'll notice that the series start by implementing naiive support
for pure upper files export and later on, replaces the implementation
of some of the operations. This may seem strange, but I found it
convenient to progress slowly between testable mile stones and I find
the series easier to review this way. Let me know if you want me to
change the way that this series is organized to get rid of code that
is later removed.

To unit test overlayfs file handles, I enhanced xfstest open_by_handle
test utility to encode/decode directories and check several other cases
that were not covered by the original xfstest test. On my xfstests NFS
export branch [4], there are two generic tests and one overlayfs specific
test on the 'exportfs' group.

I also ran the NFSTest nfstest_posix group on an exported overlayfs
mount, but that test only creates pure upper files in overlay upper dir,
so it is not much of a stress to the implementation.

Amir.

[1] https://github.com/amir73il/linux/commits/ovl-verify-dir
[2] https://github.com/amir73il/linux/commits/ovl-index-all
[3] https://github.com/amir73il/linux/commits/ovl-nfs-export
[4] https://github.com/amir73il/xfstests/commits/ovl-nfs-export

Amir Goldstein (14):
  ovl: hash all overlay inodes for NFS export
  ovl: grab i_count reference of lower inode
  ovl: use d_splice_alias() in place of d_add() in lookup
  ovl: copy up of disconnected dentries
  ovl: encode/decode pure-upper non-connectable file handles
  ovl: encode pure-upper connectable file handles
  ovl: decode pure-upper connectable file handles
  ovl: encode/decode struct ovl_fh format file handles
  ovl: encode non-pure-upper non-connectable file handles
  ovl: obtain a non-pure-upper disconnected dentry
  ovl: decode non-pure-upper non-connectable file handles
  ovl: reconnect non-pure-upper dir file handles
  ovl: wire up NFS export support
  ovl: document NFS export

 Documentation/filesystems/overlayfs.txt |  61 +++++
 fs/overlayfs/Makefile                   |   3 +-
 fs/overlayfs/copy_up.c                  |  74 ++++--
 fs/overlayfs/export.c                   | 433 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  23 +-
 fs/overlayfs/namei.c                    |  96 ++++---
 fs/overlayfs/overlayfs.h                |  32 ++-
 fs/overlayfs/super.c                    |  25 ++
 fs/overlayfs/util.c                     |  13 +-
 9 files changed, 678 insertions(+), 82 deletions(-)
 create mode 100644 fs/overlayfs/export.c

-- 
2.7.4
