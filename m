Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34676 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeH0WZA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Aug 2018 18:25:00 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] test-appliance: store the base fs type for overlay test run
Date: Mon, 27 Aug 2018 21:39:05 +0300
Message-Id: <1535395145-19166-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The base fs is used by xfstests in several places, for example, to
check if need to disable extent zeroing for underlying ext4 base fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Ted,

This patch is complimentary to this change in fstests:
https://marc.info/?l=fstests&m=153539445716875&w=2

Thanks,
Amir.

 kvm-xfstests/test-appliance/files/root/runtests.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kvm-xfstests/test-appliance/files/root/runtests.sh b/kvm-xfstests/test-appliance/files/root/runtests.sh
index 1905493..5430dd7 100755
--- a/kvm-xfstests/test-appliance/files/root/runtests.sh
+++ b/kvm-xfstests/test-appliance/files/root/runtests.sh
@@ -379,6 +379,11 @@ do
 	    echo TEST_SET_EXCLUDE: $TEST_SET_EXCLUDE
 	    echo TEST_SET_EXCLUDE: $XFS_IO_AVOID >> "$RESULT_BASE/config"
 	fi
+	if [ "$FS" = overlay ]; then
+		# with an overlay configuration preserve base FSTYP
+		# in OVL_BASE_FSTYP
+		export OVL_BASE_FSTYP="$FSTESTTYP"
+	fi
 	export FSTYP=$FS
 	AEX=""
 	if test -n "$DO_AEX" ; then
-- 
2.7.4
