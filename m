From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] common/rc: fix detection of already mounted test device
Date: Thu, 15 Dec 2016 17:01:58 +0800
Message-ID: <20161215090158.4466-1-eguan@redhat.com>
References: <20161215071931.31651-1-eguan@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54380 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752820AbcLOJEM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Dec 2016 04:04:12 -0500
In-Reply-To: <20161215071931.31651-1-eguan@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

I saw this failure in overlayfs testing:

+$SCRATCH_DEV=/mnt/ovl/scratch is mounted but not on $SCRATCH_MNT=/mnt/xfstests/mnt2 - aborting
+Already mounted result:
+/dev/sda5 on /mnt/ovl/scratch type xfs (rw,relatime,seclabel,attr2,inode64,logbsize=256k,sunit=512,swidth=1536,noquota)

Because we grep for TEST_DEV and SCRATCH_DEV in mount output to see
if test device is already mounted, and report failure if device is
not mounted at desired mount point, but in the case of overlayfs
testing these "test device"s are directories and may have other real
devices mounted there.

Fix it by checking TEST_DEV and SCRATCH_DEV at the beginning of
mount entries.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

v2: fix bug that regexp not working in grep -F

 common/rc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 26d715d..e960607 100644
--- a/common/rc
+++ b/common/rc
@@ -1363,7 +1363,7 @@ _require_scratch_nocheck()
     # mounted?
     # Note that we use -F here so grep doesn't try to interpret an NFS over
     # IPv6 server as a regular expression.
-    mount_rec=`_mount | grep -F $SCRATCH_DEV`
+    mount_rec=`_mount | grep -F "$SCRATCH_DEV on "`
     if [ "$mount_rec" ]
     then
         # if it's mounted, make sure its on $SCRATCH_MNT
@@ -1448,7 +1448,7 @@ _require_test()
     # mounted?
     # Note that we use -F here so grep doesn't try to interpret an NFS over
     # IPv6 server as a regular expression.
-    mount_rec=`_mount | grep -F $TEST_DEV`
+    mount_rec=`_mount | grep -F "$TEST_DEV on "`
     if [ "$mount_rec" ]
     then
         # if it's mounted, make sure its on $TEST_DIR
-- 
2.9.3
