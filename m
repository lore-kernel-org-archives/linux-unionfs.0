From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 7/8] ovl: update cache version of impure parent on rename
Date: Thu,  2 Nov 2017 22:38:10 +0200
Message-ID: <1509655091-13630-8-git-send-email-amir73il@gmail.com>
References: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55795 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934444AbdKBUhh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 16:37:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id y83so1351714wmc.4
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 13:37:37 -0700 (PDT)
In-Reply-To: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

ovl_rename() updates dir cache version for impure old parent if an entry
with copy up origin is moved into old parent, but it did not update
cache version if the entry moved out of old parent has a copy up origin.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ef533198be45..26aef3b5f007 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1075,9 +1075,10 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			drop_nlink(d_inode(new));
 	}
 
-	ovl_dentry_version_inc(old->d_parent,
-			       !overwrite && ovl_type_origin(new));
+	ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old));
 	ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old));
+	if (!overwrite)
+		ovl_dentry_version_inc(old->d_parent, ovl_type_origin(new));
 
 out_dput:
 	dput(newdentry);
-- 
2.7.4
