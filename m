Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752754AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 28/31] ovl: Disbale metacopy for MAP_SHARED mmap()
Date: Thu, 26 Apr 2018 15:10:10 -0400
Message-Id: <20180426191013.13219-29-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

When user chose the option of copying up a file when mmap(MAP_SHARED)
happens, then do full copy up and not just metacopy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index be531b79d2e5..d61c8355b892 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -304,7 +304,7 @@ static int ovl_pre_mmap(struct file *file, unsigned long prot,
 	 * later.
 	 */
 	if ((flag & MAP_SHARED) && ovl_copy_up_shared(file_inode(file)->i_sb))
-		err = ovl_copy_up(file_dentry(file));
+		err = ovl_copy_up_flags(file_dentry(file), O_WRONLY);
 
 	return err;
 }
-- 
2.13.6

