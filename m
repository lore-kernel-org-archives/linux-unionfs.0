From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v7 14/14] ovl: Enable metadata only feature
Date: Thu, 16 Nov 2017 17:03:35 -0500
Message-ID: <20171116220335.13448-15-vgoyal@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936233AbdKPWDp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2017 17:03:45 -0500
In-Reply-To: <20171116220335.13448-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: vgoyal@redhat.com, amir73il@gmail.com, miklos@szeredi.hu

All the bits are in patches before this. So it is time to enable the
metadata only copy up feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 3f59b98340f7..c70f5dbddd3b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -276,9 +276,6 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
-	/* TODO: Will enable metacopy in last patch of series */
-	return false;
-
 	if (!ofs->config.metacopy)
 		return false;
 
-- 
2.13.6
