From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 05/10] overlay: allow SCRATCH_DEV to be the base fs mount point
Date: Thu, 16 Feb 2017 21:57:03 +0200
Message-ID: <1487275028-29885-6-git-send-email-amir73il@gmail.com>
References: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1487275028-29885-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

When configure SCRATCH_DEV to a mount point (and not to a directory therein)
then user will get a false positive error in scratch tests:

 $SCRATCH_DEV=/mnt/base/scratch is mounted but not on $SCRATCH_MNT=/mnt/scratch
 Already mounted result:
 /dev/sda6 on /mnt/base/scratch type xfs (rw,relatime,attr2,inode64,noquota)

This is due to the wrong `grep -F $SCRATCH_DEV` which matches the mount
point instead of the device in that mount.
Fix _check_mounted_on() to grep the pattern "$dev on " and "$dev on $mnt"
instead of just grepping for "$dev" and "$mnt" without the " on " anchor.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index 45e7202..866735d 100644
--- a/common/rc
+++ b/common/rc
@@ -1340,12 +1340,14 @@ _check_mounted_on()
 	local type=$5
 
 	# Note that we use -F here so grep doesn't try to interpret an NFS over
-	# IPv6 server as a regular expression
-	local mount_rec=`_mount | grep -F "$dev"`
+	# IPv6 server as a regular expression.  Because of that, we cannot use
+	# ^$dev so we use "$dev on " to avoid matching $dev to mount point field
+	# for overlay case, where $dev is a directory.
+	local mount_rec=`_mount | grep -F "$dev on "`
 	[ -n "$mount_rec" ] || return 1 # 1 = not mounted
 
 	# if it's mounted, make sure its on $mnt
-	if ! (echo $mount_rec | grep -q "$mnt")
+	if ! (echo $mount_rec | grep -q "$dev on $mnt")
 	then
 		echo "$devname=$dev is mounted but not on $mntname=$mnt - aborting"
 		echo "Already mounted result:"
-- 
2.7.4
