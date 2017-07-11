From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 03/10] ovl: fix origin verification of index dir
Date: Tue, 11 Jul 2017 15:58:36 +0300
Message-ID: <1499777923-29410-4-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32848 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755558AbdGKM6j (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:39 -0400
Received: by mail-wr0-f195.google.com with SMTP id x23so32114506wrb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:38 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Commit 54fb347e836f ("ovl: verify index dir matches upper dir")
introduced a new ovl_fh flag OVL_FH_FLAG_PATH_UPPER to indicate
an upper file handle, but forgot to add the flag to the mask of
valid flags, so index dir origin verification always discards
existing origin and stores a new one.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7aa1c48390a5..8bfb35cb77c3 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -47,7 +47,8 @@ enum ovl_flag {
 /* Is the real inode encoded in fid an upper inode? */
 #define OVL_FH_FLAG_PATH_UPPER	(1 << 2)
 
-#define OVL_FH_FLAG_ALL (OVL_FH_FLAG_BIG_ENDIAN | OVL_FH_FLAG_ANY_ENDIAN)
+#define OVL_FH_FLAG_ALL (OVL_FH_FLAG_BIG_ENDIAN | OVL_FH_FLAG_ANY_ENDIAN | \
+			 OVL_FH_FLAG_PATH_UPPER)
 
 #if defined(__LITTLE_ENDIAN)
 #define OVL_FH_FLAG_CPU_ENDIAN 0
-- 
2.7.4
