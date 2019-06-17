Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53413 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFQN6v (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Jun 2019 09:58:51 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: fix _scratch_remount with xfs_info 5.0.0
Date: Mon, 17 Jun 2019 16:58:43 +0300
Message-Id: <20190617135843.12659-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

xfs_info version 5.0.0 started using findmnt to find the
filesystem to query. This change resulted in a regression
of _scratch_remount when testing overlay over xfs.
For example, test overlay/035, started to report:
[not run] overlay/035 -- upper fs needs to support d_type

Internally, '_overlay_scratch_mount -o remount' calls
'_supports_filetype $OVL_BASE_SCRATCH_MNT -o remount'
and with the following example mounts:

/dev/vdf /vdf xfs rw,relatime,attr2,inode64,noquota 0 0
/vdf /vdf/ovl-mnt overlay rw,lowerdir=/vdf/lower,upperdir=/vdf/upper...

'_supports_filetype /vdf' returns false and reports:
"/vdf/ovl-mnt: Not on a mounted XFS filesystem".

Regardless of the change in xfs_info, which I proposed a fix
for, there is no reason to test d_type support on remount.
Therefore, fix the regression by skipping unneeded overlayfs
mount logic on remount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

I think this fix is desired regardless of the proposed
xfs_info fix [1].

Thanks,
Amir.

[1] https://marc.info/?l=linux-xfs&m=156077152313826&w=2

 common/overlay | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/common/overlay b/common/overlay
index 00946a94..65c639e9 100644
--- a/common/overlay
+++ b/common/overlay
@@ -105,6 +105,11 @@ _overlay_base_scratch_mount()
 
 _overlay_scratch_mount()
 {
+	if echo "$*" | grep -q remount; then
+		$MOUNT_PROG $SCRATCH_MNT $*
+		return
+	fi
+
 	_overlay_base_scratch_mount && \
 		_overlay_mount $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT $*
 }
-- 
2.17.1
