From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] test-appliance: add xfs/reflink config
Date: Sun,  6 Nov 2016 12:23:16 +0200
Message-ID: <1478427797-8969-2-git-send-email-amir73il@gmail.com>
References: <1478427797-8969-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36205 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbcKFMTs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Nov 2016 07:19:48 -0500
In-Reply-To: <1478427797-8969-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/reflink | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/reflink

diff --git a/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/reflink b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/reflink
new file mode 100644
index 0000000..f4e9ecb
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/reflink
@@ -0,0 +1,3 @@
+SIZE=small
+export XFS_MKFS_OPTIONS="-m rmapbt=1,reflink=1"
+TESTNAME="XFS reflink"
-- 
2.7.4
