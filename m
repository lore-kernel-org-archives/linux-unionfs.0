From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/7] Overlayfs exportfs tests
Date: Tue, 23 Jan 2018 22:59:05 +0200
Message-ID: <1516741152-20345-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:41329 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbeAWU6P (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 Jan 2018 15:58:15 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

This is the 2nd revision of test for overlayfs NFS export.

Changes since v1:
- Added new generic/exportfs test instead of changing existing test
- Addressed review comments on open_by_handle [-i|-o] patch
- Added the test that uses open_by_handle [-i|-o] in the same patch
- Split new overlay/exportfs tests to four tests, a pair of tests
  for samefs and a pair of tests for non-samefs configuration.
- For each configuration, one test requires and enables redirect_dir
  for directory rename test cases and both tests require and enable
  nfs_export feature.

The new overlay tests don't run on upstream kernel and pass with
my overlayfs NFS export V3 branch [1]. You may want to wait with
merging those tests until overlayfs NFS support is merged.

Merging patches 1-3 seems like a good idea to me regardless of
overlayfs NFS export support.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nfs-export-v3

Amir Goldstein (7):
  open_by_handle: verify dir content only with -r flag
  generic/exportfs: golden output is not silent
  generic/exportfs: test decoding file handles after cycle mount
  overlay: test encode/decode overlay file handles
  overlay: test encode/decode of non-samefs overlay file handles
  overlay: test encode/decode overlay file handles with renames
  overlay: test encode/decode of non-samefs overlay file handles with
    renames

 src/open_by_handle.c  | 143 ++++++++++++++++++++++------
 tests/generic/426     |   1 -
 tests/generic/426.out |   1 -
 tests/generic/467     |   1 -
 tests/generic/467.out |   1 -
 tests/generic/477     | 107 +++++++++++++++++++++
 tests/generic/477.out |   5 +
 tests/generic/group   |   1 +
 tests/overlay/050     | 237 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/050.out |  31 ++++++
 tests/overlay/051     | 254 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/051.out |  31 ++++++
 tests/overlay/052     | 183 ++++++++++++++++++++++++++++++++++++
 tests/overlay/052.out |  22 +++++
 tests/overlay/053     | 199 +++++++++++++++++++++++++++++++++++++++
 tests/overlay/053.out |  22 +++++
 tests/overlay/group   |   4 +
 17 files changed, 1208 insertions(+), 35 deletions(-)
 create mode 100755 tests/generic/477
 create mode 100644 tests/generic/477.out
 create mode 100755 tests/overlay/050
 create mode 100644 tests/overlay/050.out
 create mode 100755 tests/overlay/051
 create mode 100644 tests/overlay/051.out
 create mode 100755 tests/overlay/052
 create mode 100644 tests/overlay/052.out
 create mode 100755 tests/overlay/053
 create mode 100644 tests/overlay/053.out

-- 
2.7.4
