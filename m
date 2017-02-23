From: Xiong Zhou <xzhou@redhat.com>
Subject: [xfstests v4 0/8] bunch of overlay tests
Date: Thu, 23 Feb 2017 17:42:38 +0800
Message-ID: <1487842966-30986-1-git-send-email-xzhou@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54546 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbdBWJna (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Feb 2017 04:43:30 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, mszeredi@redhat.com, Xiong Zhou <xzhou@redhat.com>

v4:
  use --absolute-names for get/set fattr/facl
  add helper _require_and_mount_tmpfs
  mount tmpfs in TEST_DIR
  add entry for _require_command "$FLOCK_PROG" flock
  tune xattr filter case errno handling and log

v3:
  cc linux-unionfs
  rm -rf $tmp in cleanup
  checking exact errno in set/getfattr case
  sleep less in flock case

Xiong Zhou (8):
  overlay: disallow overlayfs as upperdir
  overlay: work dir in overlay inherits no ACLs
  overlay: test workdir cleanup in mounting
  overlay: permission check with cached acls in tmpfs
  overlay: filter out xattr starts with "trusted.overlay."
  overlay: can not change underlying immutable file
  overlay: test flock after copied up
  overlay: accessing stacked overlayfs files

 common/config         |   1 +
 common/rc             |  10 +++++
 tests/overlay/022     |  82 +++++++++++++++++++++++++++++++++++++
 tests/overlay/022.out |   2 +
 tests/overlay/023     |  79 ++++++++++++++++++++++++++++++++++++
 tests/overlay/023.out |   8 ++++
 tests/overlay/024     |  80 ++++++++++++++++++++++++++++++++++++
 tests/overlay/024.out |   2 +
 tests/overlay/025     |  81 +++++++++++++++++++++++++++++++++++++
 tests/overlay/025.out |   2 +
 tests/overlay/026     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/026.out |   6 +++
 tests/overlay/027     |  87 +++++++++++++++++++++++++++++++++++++++
 tests/overlay/027.out |   2 +
 tests/overlay/028     |  81 +++++++++++++++++++++++++++++++++++++
 tests/overlay/028.out |   2 +
 tests/overlay/029     | 100 +++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/029.out |   5 +++
 tests/overlay/group   |   8 ++++
 19 files changed, 748 insertions(+)
 create mode 100755 tests/overlay/022
 create mode 100644 tests/overlay/022.out
 create mode 100755 tests/overlay/023
 create mode 100644 tests/overlay/023.out
 create mode 100755 tests/overlay/024
 create mode 100644 tests/overlay/024.out
 create mode 100755 tests/overlay/025
 create mode 100644 tests/overlay/025.out
 create mode 100755 tests/overlay/026
 create mode 100644 tests/overlay/026.out
 create mode 100755 tests/overlay/027
 create mode 100644 tests/overlay/027.out
 create mode 100755 tests/overlay/028
 create mode 100644 tests/overlay/028.out
 create mode 100755 tests/overlay/029
 create mode 100644 tests/overlay/029.out

-- 
1.8.3.1
