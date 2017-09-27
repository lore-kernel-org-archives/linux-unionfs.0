From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] overlay: fix _overlay_config_override of MOUNT_OPTIONS
Date: Wed, 27 Sep 2017 10:04:12 +0300
Message-ID: <1506495852-7295-5-git-send-email-amir73il@gmail.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33954 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdI0HDq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Sep 2017 03:03:46 -0400
In-Reply-To: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

The config variable OVERLAY_MOUNT_OPTIONS is used to configure
the overlay mount options when running ./check -overlay.
The config variable MOUNT_OPTIONS is used to configure the
mount options for base fs.

If config sets value of OVERLAY_MOUNT_OPTIONS and
does not set MOUNT_OPTIONS, the value of MOUNT_OPTIONS
may be leftover from previous _overlay_config_override, so
don't use that value for base fs mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/config b/common/config
index 71798f0..8844173 100644
--- a/common/config
+++ b/common/config
@@ -532,6 +532,10 @@ _overlay_config_override()
 	# Store original base fs vars
 	export OVL_BASE_TEST_DEV="$TEST_DEV"
 	export OVL_BASE_TEST_DIR="$TEST_DIR"
+	# If config does not set MOUNT_OPTIONS, its value may be
+	# leftover from previous _overlay_config_override, so
+	# don't use that value for base fs mount
+	[ "$MOUNT_OPTIONS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset MOUNT_OPTIONS
 	export OVL_BASE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
 
 	# Set TEST vars to overlay base and mount dirs inside base fs
-- 
2.7.4
