From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/7] More NFS file handle unit tests
Date: Thu,  2 Nov 2017 12:15:32 +0200
Message-ID: <1509617739-15744-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Eryu,

This series enhances test coverage for generic NFS file handles
encode/decode functionality and adds a new gereric/exportfs test.

Please note that the new test output includes the temporary test
number 500, so don't forget to fix those when renaming the test.

The enhanced open_by_handle program is going to be used later on for
overlayfs specific exportfs tests [1].

The open_by_handle program is limited to encoding "non-connectable"
file handles (used by nfsd on 'no_subtree_check' exports), because there
is no user available API (that I know of) to encode a "connecctable" file
handle (used by nfsd on 'subtree_check' exports). I used a test patch
"test connectable file handles", available on my tree [1] to tun the tests
with "connectable" file handles.

I verified that the new test passes on xfs, ext4, ext2, btrfs, f2fs.
However, the test fails on tmpfs due to:
"open_by_handle() returned 116 incorrectly on an unlinked open file!"

This happens because tmpfs uses d_find_alias() to get a decoded dentry,
but d_find_alias() skips unhashed (deleted with refcount) dentries.

I don't know if being able to decode a file handle of a deleted but open
file is a requirement for nfsd or just a recommendation, but IMO it is a
common case that is worth testing, even if tmpfs (or other file systems)
choose not to fix this.

Bruce, Jeff,

What is your view on this issue?

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/commits/ovl-nfs-export
[2] https://github.com/amir73il/linux/commits/ovl-nfs-export-v1

Amir Goldstein (7):
  open_by_handle: add filename to error reports
  open_by_handle: test file handles of renamed files
  open_by_handle: test content of open file handle
  open_by_handle: test directory file handle
  open_by_handle: test file handles of open files
  generic/426: factor out helper functions
  fstests: add test with more open by file handle use cases

 src/open_by_handle.c  | 247 ++++++++++++++++++++++++++++++++++++++++++++------
 tests/generic/426     |  40 +++++---
 tests/generic/426.out |   4 +
 tests/generic/500     | 119 ++++++++++++++++++++++++
 tests/generic/500.out |  10 ++
 tests/generic/group   |   1 +
 6 files changed, 383 insertions(+), 38 deletions(-)
 create mode 100755 tests/generic/500
 create mode 100644 tests/generic/500.out

-- 
2.7.4
