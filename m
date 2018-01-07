From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/7] Overlayfs exportfs tests
Date: Sun,  7 Jan 2018 20:07:18 +0200
Message-ID: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:47097 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754254AbeAGSGg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 7 Jan 2018 13:06:36 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Eryu,

Following patches were used to test overlayfs NFS export.

Patches 1-5 improve generic/exportfs tests, by adding test coverage
of some directory file handle use cases.

Patches 6-7 add two overlay specific tests for NFS file handles
for overlay setup of same fs and non same fs.

The new overlay tests don't run on upstream kernel and pass with
my overlayfs NFS export V2 branch [1]. You may want to wait with
merging those tests until overlayfs NFS support is merged - up to you,
but a review would be most welcome.

Merging patches 1-5 seems like a good idea to me regardless of
overlayfs NFS export support.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nfs-export-v2

Amir Goldstein (7):
  open_by_handle: store and load file handles from file
  open_by_handle: verify dir content only with -r flag
  generic/exportfs: golden output is not silent
  generic/exportfs: store and load file handles from file
  generic/exportfs: add a test case for renamed parent dir
  overlay: test encode/decode overlay file handles
  overlay: test encode/decode of non-samefs overlay file handles

 src/open_by_handle.c  | 112 +++++++++++++-----
 tests/generic/426     |   1 -
 tests/generic/426.out |   1 -
 tests/generic/467     |  37 ++++--
 tests/generic/467.out |  10 +-
 tests/overlay/050     | 291 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/050.out |  50 ++++++++
 tests/overlay/051     | 311 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/051.out |  50 ++++++++
 tests/overlay/group   |   2 +
 10 files changed, 822 insertions(+), 43 deletions(-)
 create mode 100755 tests/overlay/050
 create mode 100644 tests/overlay/050.out
 create mode 100755 tests/overlay/051
 create mode 100644 tests/overlay/051.out

-- 
2.7.4
