From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 7/9] ovl: update cache version of impure parent on rename
Date: Wed,  1 Nov 2017 22:22:51 +0200
Message-ID: <1509567773-25590-8-git-send-email-amir73il@gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:53590 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755211AbdKAUWV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 16:22:21 -0400
Received: by mail-wr0-f194.google.com with SMTP id u40so3001166wrf.10
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 13:22:20 -0700 (PDT)
In-Reply-To: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

ovl_rename() updates dir cache version for impure old parent if an entry
with copy up origin is moved into old parent, but it did not update
cache version if the entry moved out of old parent has a copy up origin.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ef533198be45..70af6b470420 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1075,6 +1075,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			drop_nlink(d_inode(new));
 	}
 
+	ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old));
 	ovl_dentry_version_inc(old->d_parent,
 			       !overwrite && ovl_type_origin(new));
 	ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old));
-- 
2.7.4
