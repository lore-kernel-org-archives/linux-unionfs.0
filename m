From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/5] Overlayfs exportfs tests
Date: Sun, 28 Jan 2018 11:22:31 +0200
Message-ID: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33194 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbeA1JVh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 28 Jan 2018 04:21:37 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

Assuming you did not get to reviewing the overlay/exportfs
v2 patches yet, here is a better version for you to test/review,
which I had tested with various OVERLAY_MOUNT_OPTIONS variants.

NFS export support patches are now on overlayfs-next and all
overlay/exportfs tests are expected to pass with overlayfs-next and
default kernel configuration.

Changes since v2:
- Fix the index feature requirement
- Implement _require_scratch_features (plural) to check dependent
  overlay features together (nfs_export and index)

Thanks,
Amir.

Amir Goldstein (5):
  fstests: implement require of multiple overlayfs features
  overlay: test encode/decode overlay file handles
  overlay: test encode/decode of non-samefs overlay file handles
  overlay: test encode/decode overlay file handles with renames
  overlay: test encode/decode of non-samefs overlay file handles with
    renames

 common/overlay        |  23 ++++-
 common/rc             |  15 +--
 tests/overlay/050     | 237 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/050.out |  31 ++++++
 tests/overlay/051     | 254 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/051.out |  31 ++++++
 tests/overlay/052     | 182 ++++++++++++++++++++++++++++++++++++
 tests/overlay/052.out |  22 +++++
 tests/overlay/053     | 198 +++++++++++++++++++++++++++++++++++++++
 tests/overlay/053.out |  22 +++++
 tests/overlay/group   |   4 +
 11 files changed, 1010 insertions(+), 9 deletions(-)
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
