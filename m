From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 7/8] ovl: Return lower dentry if only metadata copy up took place
Date: Fri,  6 Oct 2017 13:47:16 -0400
Message-ID: <1507312037-30909-8-git-send-email-vgoyal@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752498AbdJFRrY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:47:24 -0400
In-Reply-To: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Upper dentry inode does not have data. So return lower dentry if upper
is only a metadata copy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 338fb0c3d345..0877b4baf14b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -101,10 +101,14 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 			err = ovl_check_append_only(d_inode(real), open_flags);
 			if (err)
 				return ERR_PTR(err);
+
+			if (ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
+				goto lower;
 		}
 		return real;
 	}
 
+lower:
 	real = ovl_dentry_lower(dentry);
 	if (!real)
 		goto bug;
-- 
2.13.5
