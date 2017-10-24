From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] ovl: declare index feature backward compatible
Date: Tue, 24 Oct 2017 13:02:59 +0300
Message-ID: <1508839381-24750-3-git-send-email-amir73il@gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:49715 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752236AbdJXKCh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 06:02:37 -0400
Received: by mail-wm0-f68.google.com with SMTP id b189so14488214wmd.4
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 03:02:36 -0700 (PDT)
In-Reply-To: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Kconfig description on OVERLAY_FS_INDEX states that "the inodes index
feature is read-only backward compatible" and that mounting an overlay
with index enabled, disabled and then enabled again "will have
unexpected results."

Commit d1712d8fef03 ("ovl: fix EIO from lookup of non-indexed upper")
makes the results of this enable/disable/enable maneuver just as
expected and the results of a plain enable of index feature on existing
overlay - some hardlinks may have already been broken and new hardlinks
will not be broken on copy up.

Now that there is a dedicated config option to opt-in in for backward
incompatible index feature, remove the backward compatibility clause from
Kconfig description of OVERLAY_FS_INDEX.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index e5e6dec7d177..02295e10ffbe 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -37,13 +37,6 @@ config OVERLAY_FS_INDEX
 	  The inodes index feature prevents breaking of lower hardlinks on copy
 	  up.
 
-	  Note, that the inodes index feature is read-only backward compatible.
-	  That is, mounting an overlay which has an index dir on a kernel that
-	  doesn't support this feature read-only, will not have any negative
-	  outcomes.  However, mounting the same overlay with an old kernel
-	  read-write and then mounting it again with a new kernel, will have
-	  unexpected results.
-
 config OVERLAY_FS_INDEX_INCOMPAT
 	bool "Overlayfs: support incompatible index feature"
 	depends on OVERLAY_FS_INDEX
-- 
2.7.4
