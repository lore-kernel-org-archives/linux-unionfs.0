From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 0/5] Overlayfs exportfs tests
Date: Tue, 30 Jan 2018 08:12:17 +0200
Message-ID: <1517292742-15624-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39229 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbeA3GLW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Jan 2018 01:11:22 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

Following a version with fixes to your review comments on v3.

Changes since v3:
- Fix inconsistent comments in link/unlink tests
- Call _require_overlay_scratch_features (plural) from tests
  that require overlay features together (nfs_export and index)
- Comment in those cases

Thanks,
Amir.

Amir Goldstein (5):
  fstests: implement require of multiple overlayfs features
  overlay: test encode/decode overlay file handles
  overlay: test encode/decode of non-samefs overlay file handles
  overlay: test encode/decode overlay file handles with renames
  overlay: test encode/decode of non-samefs overlay file handles with
    renames

 common/overlay        |  27 +++++-
 common/rc             |   2 +-
 tests/overlay/050     | 239 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/050.out |  31 ++++++
 tests/overlay/051     | 256 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/051.out |  31 ++++++
 tests/overlay/052     | 184 ++++++++++++++++++++++++++++++++++++
 tests/overlay/052.out |  22 +++++
 tests/overlay/053     | 200 +++++++++++++++++++++++++++++++++++++++
 tests/overlay/053.out |  22 +++++
 tests/overlay/group   |   4 +
 11 files changed, 1012 insertions(+), 6 deletions(-)
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
