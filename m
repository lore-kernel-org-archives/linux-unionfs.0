From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 10/13] ovl: Return lower dentry if only metadata copy up took place
Date: Wed, 25 Oct 2017 15:09:32 -0400
Message-ID: <1508958575-14086-11-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932352AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Upper dentry inode does not have data. So return lower dentry if upper
is only a metadata copy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 32e3d4b..4cf1f98 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -101,10 +101,15 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 			err = ovl_check_append_only(d_inode(real), open_flags);
 			if (err)
 				return ERR_PTR(err);
+
+			if (ovl_dentry_check_upperdata(dentry) &&
+			    !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))
+				goto lower;
 		}
 		return real;
 	}
 
+lower:
 	real = ovl_dentry_lower(dentry);
 	if (!real)
 		goto bug;
-- 
2.5.5
