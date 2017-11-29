From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v9 15/15] ovl: Enable metadata only feature
Date: Wed, 29 Nov 2017 10:54:48 -0500
Message-ID: <20171129155448.32721-16-vgoyal@redhat.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933569AbdK2Py7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Nov 2017 10:54:59 -0500
In-Reply-To: <20171129155448.32721-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

All the bits are in patches before this. So it is time to enable the
metadata only copy up feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0bfc1df13b79..469552eaad5f 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -247,9 +247,6 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
-	/* TODO: Will enable metacopy in last patch of series */
-	return false;
-
 	if (!ofs->config.metacopy)
 		return false;
 
-- 
2.13.6
