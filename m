From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 00/17] Overlayfs NFS export support
Date: Thu,  4 Jan 2018 19:20:32 +0200
Message-ID: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36426 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbeADRUi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:38 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This is the 2nd revision of series that implements NFS export support.
This series is based on a series of prep patches [1] that implement
the "verify" feature and were posted earlier to overlayfs list.
The complete work is available here [2].

NFS export is enabled for overlayfs mount when the opt-in "verify"
feature is enabled, because decoding file handles requires the full
index that "verify" feature creates.

The first patch in the series in the Documentation update with a brief
overview of the implementation, so reviewers can learn what to expect
further along the series.

The 1st revision copied up and indexed all directories on file handle
encode. This revision only copies up directories on encode with a
multiple lower layers setup. This is done to reduce the complexity of
decoding directory file handles and ensure that an encoded dir inode
is either upper or the top lower dir.

The current implementation does not support encoding connectable
non-dir file handles. When overlayfs is exported with the 'subtree_check'
exportfs option, NFS client will get lookup errors and NFS server logs will
have warnings like these:
  "overlayfs: connectable file handles not supported; \
              use 'no_subtree_check' exportfs option"

To unit test overlayfs file handles, I enhanced xfstest open_by_handle
test utility to encode/decode directories and check several other cases
that were not covered by the original xfstest test. On my xfstests NFS
export branch [3], there are two generic tests and two overlayfs specific
test on the 'exportfs' group - one for samefs setup and one for non-samefs
with two lower layers setup.

To sanity test NFS exported overlayfs, I made a hacky test patch to
unionmount-testsuite [4], which runs all the tests on an NFS mount to
localhost, while setting up and rotating the overlay mount on the exported
local share.

I also ran the NFSTest [5] nfstest_posix group on an exported overlayfs
mount, but that test only creates pure upper files in overlay upper dir,
so it is not much of a stress to the implementation. This test found one
problem with non uptodate overlay inode mtime. The last patch is the series
solves this problem in nfsd. It is reviewed by Jeff.

Amir.

[1] https://github.com/amir73il/linux/commits/ovl-index-all
[2] https://github.com/amir73il/linux/commits/ovl-nfs-export-v2
[3] https://github.com/amir73il/xfstests/commits/ovl-nfs-export
[4] https://github.com/amir73il/unionmount-testsuite/commits/ovl-nfs-export
[5] http://wiki.linux-nfs.org/wiki/index.php/NFStest

Amir Goldstein (17):
  ovl: document NFS export
  ovl: encode pure upper file handles
  ovl: decode pure upper file handles
  ovl: decode connected upper dir file handles
  ovl: encode non-indexed upper file handles
  ovl: copy up before encoding dir file handle when ofs->numlower > 1
  ovl: encode lower file handles
  ovl: decode lower non-dir file handles
  ovl: decode indexed non-dir file handles
  ovl: decode lower file handles of unlinked but open files
  ovl: decode indexed dir file handles
  ovl: decode pure lower dir file handles
  ovl: hash directory inodes for NFS export
  ovl: lookup connected ancestor of dir in inode cache
  ovl: lookup indexed ancestor of lower dir
  ovl: wire up NFS export support
  nfsd: encode stat->mtime for getattr instead of inode->i_mtime

 Documentation/filesystems/overlayfs.txt |  59 +++
 fs/locks.c                              |   6 +-
 fs/nfsd/nfsxdr.c                        |   1 +
 fs/overlayfs/Kconfig                    |   2 +
 fs/overlayfs/Makefile                   |   3 +-
 fs/overlayfs/export.c                   | 636 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  29 +-
 fs/overlayfs/namei.c                    |  34 +-
 fs/overlayfs/overlayfs.h                |  16 +
 fs/overlayfs/super.c                    |  11 +
 fs/overlayfs/util.c                     |   4 +-
 11 files changed, 778 insertions(+), 23 deletions(-)
 create mode 100644 fs/overlayfs/export.c

-- 
2.7.4
