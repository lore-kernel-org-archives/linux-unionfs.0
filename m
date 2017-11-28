From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] Overlayfs orphan index cleanup tests
Date: Tue, 28 Nov 2017 18:41:59 +0200
Message-ID: <1511887322-29254-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:44294 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbdK1QmA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:42:00 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

Vivek found a bug with the index nlink accounting of the index feature
that was introduced in kernel v4.13.

The bug was there from the first implementation of index and the
tests I wrote to verify nlink accounting (overlay/033,034) did not
cover the bug use case.

The first regression test (overlay/047) demonstrates the effects
of the bug on end user.

The second regression test (overlay/048) adds the missing test coverage
of the existing nlink accounting tests.

The kernel bug was hiding a bug in test overlay/042, so Vivek's
kernel fix broke the test. The last patch fixes the wrong/broken test.

Amir.

Amir Goldstein (3):
  overlay: regression test for hardlink breakage after unlink and mount
  overlay: regression test for orphan index cleanup on mount
  overlay/042: remove wrong check for empty index

 tests/overlay/042     |   4 --
 tests/overlay/047     | 107 ++++++++++++++++++++++++++++++++++++++
 tests/overlay/047.out |  16 ++++++
 tests/overlay/048     | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/048.out |  18 +++++++
 tests/overlay/group   |   2 +
 6 files changed, 284 insertions(+), 4 deletions(-)
 create mode 100755 tests/overlay/047
 create mode 100644 tests/overlay/047.out
 create mode 100755 tests/overlay/048
 create mode 100644 tests/overlay/048.out

-- 
2.7.4
