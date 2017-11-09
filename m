From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 10/15] ovl: Return lower dentry if only metadata copy up took place
Date: Thu,  9 Nov 2017 15:50:14 -0500
Message-ID: <20171109205019.11409-11-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30497 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753293AbdKIUuc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:32 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

Upper dentry inode does not have data. So return lower dentry if upper
is only a metadata copy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 84b8f6dc0f61..5cb19781763d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -101,14 +101,19 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 
 	real = ovl_dentry_upper(dentry);
 	if (real && (!inode || inode == d_inode(real))) {
+		bool metacopy = !ovl_has_upperdata(dentry);
 		if (!inode) {
 			err = ovl_check_append_only(d_inode(real), open_flags);
 			if (err)
 				return ERR_PTR(err);
+
+			if (unlikely(metacopy))
+				goto lower;
 		}
 		return real;
 	}
 
+lower:
 	real = ovl_dentry_lower(dentry);
 	if (!real)
 		goto bug;
-- 
2.13.6
