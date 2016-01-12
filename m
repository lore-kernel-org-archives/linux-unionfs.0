From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 1/3] common: remove all files in $SCRATCH_DEV for overlayfs in _scratch_cleanup_files()
Date: Tue, 12 Jan 2016 16:30:26 +0800
Message-ID: <1452587428-26305-1-git-send-email-eguan@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760920AbcALIax (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 12 Jan 2016 03:30:53 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

All files in lower/upper dirs should be removed for overlayfs in
_scratch_cleanup_files(), not only files in merged dir, otherwise files
from lower dir won't be removed.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---

No update in v2.

 common/rc | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index 5135260..75d1582 100644
--- a/common/rc
+++ b/common/rc
@@ -701,9 +701,17 @@ _mkfs_dev()
 # remove all files in $SCRATCH_MNT, useful when testing on NFS/CIFS
 _scratch_cleanup_files()
 {
-	_scratch_mount
-	rm -rf $SCRATCH_MNT/*
-	_scratch_unmount
+	case $FSTYP in
+	overlay)
+		# $SCRATCH_DEV is a valid directory in overlay case
+		rm -rf $SCRATCH_DEV/*
+		;;
+	*)
+		_scratch_mount
+		rm -rf $SCRATCH_MNT/*
+		_scratch_unmount
+		;;
+	esac
 }
 
 _scratch_mkfs()
-- 
1.8.3.1
