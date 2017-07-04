From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/6] overlay hardlink tests
Date: Tue,  4 Jul 2017 14:20:28 +0300
Message-ID: <1499167234-22779-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35065 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbdGDLUT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Jul 2017 07:20:19 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

overlay/018 was written to track the non-standard behavior of
overlayfs, where lower hardlinks are broken on copy up.

While working on fixing the hardlinks breakage issue, I found
several false positives and uncovered cases in the test.

This series addresses the shortcomings of the original overlay/018
test and introduces two more tests to overlay/hardlink group.

Thanks,
Amir.

Amir Goldstein (6):
  overlay/018: re-factor and add to hardlink group
  overlay/018: print hardlink content to golden output
  overlay/018: test broken hardlinks after mount cycle
  overlay/018: test lower hardlinks re-unite on copy up
  overlay: test concurrent copy up of lower hardlinks
  overlay: test dropping nlink below zero

 tests/overlay/018     |  60 ++++++++++++++++----
 tests/overlay/018.out |  21 ++++++-
 tests/overlay/032     | 102 ++++++++++++++++++++++++++++++++++
 tests/overlay/032.out |   4 ++
 tests/overlay/033     | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/033.out |  69 +++++++++++++++++++++++
 tests/overlay/034     |  91 ++++++++++++++++++++++++++++++
 tests/overlay/034.out |   2 +
 tests/overlay/group   |   5 +-
 9 files changed, 489 insertions(+), 14 deletions(-)
 create mode 100755 tests/overlay/032
 create mode 100644 tests/overlay/032.out
 create mode 100755 tests/overlay/033
 create mode 100644 tests/overlay/033.out
 create mode 100755 tests/overlay/034
 create mode 100644 tests/overlay/034.out

-- 
2.7.4
