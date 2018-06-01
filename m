Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] overlay: nicer report when features are not supported
Date: Fri,  1 Jun 2018 13:44:16 +0300
Message-Id: <1527849857-22951-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1527849857-22951-1-git-send-email-amir73il@gmail.com>
References: <1527849857-22951-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Commit ea7ad43 ("fstests: implement require of multiple overlayfs
features") changed the message when tests are not run due to missing
overlayfs feature.

Restore the check for existing module param before trying to mount
which restores the old message format, e.g.:

[not run] feature 'metacopy' not supported by overlay

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/common/overlay b/common/overlay
index e99e64f..b526f24 100644
--- a/common/overlay
+++ b/common/overlay
@@ -140,9 +140,6 @@ __check_scratch_overlay_feature()
 	# configurable from Kconfig (the build default), by module
 	# parameter (the system default) and per mount by mount
 	# option ${feature}=[on|off].
-	#
-	# If the module parameter does not exist then there is no
-	# point in checking the mount option.
 	local default=`_get_fs_module_param ${feature}`
 	[ "$default" = Y ] || [ "$default" = N ] || \
 		_notrun "feature '${feature}' not supported by ${FSTYP}"
@@ -164,12 +161,16 @@ _require_scratch_overlay_features()
 	local opts="rw"
 
 	for feature in ${features[*]}; do
+		# If the module parameter does not exist then there is no
+		# point in checking the mount option.
+		_get_fs_module_param ${feature} > /dev/null 2>&1 || \
+			_notrun "feature '${feature}' not supported by overlay"
 		opts+=",${feature}=on"
 	done
 
 	_scratch_mkfs > /dev/null 2>&1
 	_try_scratch_mount -o $opts || \
-		_notrun "overlay options '$opts' cannot be enabled on ${SCRATCH_DEV}"
+	        _notrun "overlay features '${features[*]}' cannot be enabled on ${SCRATCH_DEV}"
 
 	for feature in ${features[*]}; do
 		__check_scratch_overlay_feature ${feature}
-- 
2.7.4
