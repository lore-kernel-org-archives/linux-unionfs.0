From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/7] overlay hardlink tests
Date: Tue,  4 Jul 2017 14:40:27 +0300
Message-ID: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Eryu,

Sorry, v1 had an unintentional squashed patch, so re-posting v2.

overlay/018 was written to track the non-standard behavior of
overlayfs, where lower hardlinks are broken on copy up.

While working on fixing the hardlinks breakage issue, I found
several false positives and uncovered cases in the test.

This series addresses the shortcomings of the original overlay/018
test and introduces three more tests to overlay/hardlink group.

Thanks,
Amir.

Amir Goldstein (7):
  overlay/018: re-factor and add to hardlink group
  overlay/018: print hardlink content to golden output
  overlay/018: test broken hardlinks after mount cycle
  overlay/018: test lower hardlinks re-unite on copy up
  overlay: test concurrent copy up of lower hardlinks
  overlay: test nlink accounting of overlay hardlinks
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
