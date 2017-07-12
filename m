From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] fstest: add helper _require_fs_feature
Date: Wed, 12 Jul 2017 12:43:24 +0300
Message-ID: <1499852605-27759-2-git-send-email-amir73il@gmail.com>
References: <1499852605-27759-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34523 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdGLJnO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jul 2017 05:43:14 -0400
In-Reply-To: <1499852605-27759-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

The helper is used to test if a specific filesystem feature can
be enabled. Currently only implemented testing overlayfs features.

Overalyfs features (e.g. redirect_dir, index) are configurable from
Kconfig (the build default), by module parameter (the system default)
and per mount using the mount option ${feature}=[on|off].

The helper is going to be used by overlay tests, which depend
on the inodes index feature.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/common/rc b/common/rc
index b505365..260b48d 100644
--- a/common/rc
+++ b/common/rc
@@ -3626,6 +3626,54 @@ _get_fs_sysfs_attr()
 	cat /sys/fs/${FSTYP}/${dname}/${attr}
 }
 
+# Print the value of a filesystem module parameter
+# at /sys/module/$FSTYP/parameters/$PARAM
+#
+# Usage example (FSTYP=overlay):
+#   _get_fs_module_param index
+_get_fs_module_param()
+{
+	cat /sys/module/${FSTYP}/parameters/${1} 2>/dev/null
+}
+
+# Generic test for specific filesystem feature.
+# Currently only implemented to test overlayfs features.
+_require_fs_feature()
+{
+	local feature=$1
+
+	case "$FSTYP" in
+	    overlay)
+		# overalyfs features (e.g. redirect_dir, index) are
+		# configurable from Kconfig (the build default), by module
+		# parameter (the system default) and per mount by mount
+		# option ${feature}=[on|off].
+		#
+		# If the module parameter does not exist then there is no
+		# point in checking the mount option.
+		local default=`_get_fs_module_param ${feature}`
+		[ "$default" = Y ] || [ "$default" = N ] || \
+			_notrun "feature '${feature}' not supported by ${FSTYP}"
+
+	        _scratch_mkfs > /dev/null 2>&1
+	        _scratch_mount -o ${feature}=on || \
+	                _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
+		# Check options to be sure. For example, Overlayfs will fallback to
+		# index=off if underlying fs does not support file handles.
+		# Overlayfs only displays mount option if it differs from the default.
+		# Overlayfs may enable the feature, but fallback to read-only mount.
+		((( [ "$default" = N ] && _fs_options $SCRATCH_DEV | grep -q "${feature}=on" ) || \
+		  ( [ "$default" = Y ] && ! _fs_options $SCRATCH_DEV | grep -q "${feature}=off" )) && \
+		    touch $SCRATCH_MNT/foo 2>/dev/null ) || \
+	                _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
+		_scratch_unmount
+		;;
+	    *)
+		_fail "Test for feature '${feature}' of ${FSTYP} is not implemented"
+		;;
+	esac
+}
+
 
 init_rc
 
-- 
2.7.4
