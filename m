From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/7] overlay hardlink tests
Date: Wed,  5 Jul 2017 15:01:59 +0300
Message-ID: <1499256126-21866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33529 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbdGEMBs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 08:01:48 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

overlay/018 and the three new tests added to overlay/hardlink
group, pass with the current overlayfs-next branch.

overlay/033-034 were added to test a new mechanism of persistent
overlay nlink accounting, that was added along with the fix to
breaking hardlinks on copy up.

overlay/034 passes on current upstream kernel, because the
behavior of breaking hardlinks on copy up cancels the nlink
accounting effects.

Changes from v2:
- Better commentary for overlay/034 and overlay/032
- Increase copy up file size of overlay/032 to 1g

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
 tests/overlay/032     | 109 ++++++++++++++++++++++++++++++++++++
 tests/overlay/032.out |   4 ++
 tests/overlay/033     | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/033.out |  69 +++++++++++++++++++++++
 tests/overlay/034     | 107 ++++++++++++++++++++++++++++++++++++
 tests/overlay/034.out |   2 +
 tests/overlay/group   |   5 +-
 9 files changed, 512 insertions(+), 14 deletions(-)
 create mode 100755 tests/overlay/032
 create mode 100644 tests/overlay/032.out
 create mode 100755 tests/overlay/033
 create mode 100644 tests/overlay/033.out
 create mode 100755 tests/overlay/034
 create mode 100644 tests/overlay/034.out

-- 
2.7.4
