Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40320 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbeH0WPV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Aug 2018 18:15:21 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] overlay: do not set OVL_BASE_FSTYP value to "overlay"
Date: Mon, 27 Aug 2018 21:29:25 +0300
Message-Id: <1535394566-18837-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535394566-18837-1-git-send-email-amir73il@gmail.com>
References: <1535394566-18837-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The purpose of OVL_BASE_FSTYP is to store the value of FSTYP that is
found in a host config file section.

When there is no host config file or if user sets FSTYP=overlay in config
file, it makes no sense to store the value "overlay" in OVL_BASE_FSTYP
and it is better to leave it empty or leave its current value in tact.

This allows user to set OVL_BASE_FSTYP in config file or before running
the test to support queries about base fs, such as
_require_metadata_journaling, even when running an overlay test.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/config b/common/config
index 2f1f272..d85519a 100644
--- a/common/config
+++ b/common/config
@@ -530,7 +530,7 @@ _overlay_config_override()
 	[ -b "$TEST_DEV" ] || return 0
 
 	# Config file may specify base fs type, but we obay -overlay flag
-	export OVL_BASE_FSTYP="$FSTYP"
+	[ "$FSTYP" == overlay ] || export OVL_BASE_FSTYP="$FSTYP"
 	export FSTYP=overlay
 
 	# Store original base fs vars
-- 
2.7.4
