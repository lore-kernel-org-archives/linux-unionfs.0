From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] ovl: Pass ovl_get_nlink() parameters in right order
Date: Mon, 27 Nov 2017 10:12:44 -0500
Message-ID: <20171127151244.GA22007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752401AbdK0PMp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 10:12:45 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org

Hi Amir,

I am wondering if this is a bug or it is supposed to be like this. I felt
it is a bug, so I generated a patch and sending it for your review.

Vivek


Right now we seem to be passing index as "lowerdentry" and origin.dentry
as "upperdentry". IIUC, we should pass these parameters in reversed order
and this looks like a bug.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 625ed8066570..5ef69bc09e0c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -435,7 +435,7 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 
 	/* Check if index is orphan and don't warn before cleaning it */
 	if (d_inode(index)->i_nlink == 1 &&
-	    ovl_get_nlink(index, origin.dentry, 0) == 0)
+	    ovl_get_nlink(origin.dentry, index, 0) == 0)
 		err = -ENOENT;
 
 	dput(origin.dentry);
