From: Xiong Zhou <xzhou@redhat.com>
Subject: [xfstests v3 0/8] bunch of overlay tests
Date: Mon, 20 Feb 2017 16:48:36 +0800
Message-ID: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752307AbdBTIs7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Feb 2017 03:48:59 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, mszeredi@redhat.com, Xiong Zhou <xzhou@redhat.com>

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

 tests/overlay/022     |  82 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/022.out |   2 +
 tests/overlay/023     |  81 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/023.out |   8 ++++
 tests/overlay/024     |  80 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/024.out |   2 +
 tests/overlay/025     |  85 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/025.out |   2 +
 tests/overlay/026     |  99 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/026.out |   5 +++
 tests/overlay/027     |  87 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/027.out |   2 +
 tests/overlay/028     |  80 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/028.out |   2 +
 tests/overlay/029     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/029.out |   5 +++
 tests/overlay/group   |   8 ++++
 17 files changed, 730 insertions(+)
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
