From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 14/18] ovl: Do not mark a non dir as _OVL_PATH_MERGE in ovl_path_type()
Date: Wed, 31 Jan 2018 16:13:25 -0500
Message-ID: <20180131211329.16328-15-vgoyal@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752781AbeAaVNn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:43 -0500
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

With the addition of an origin chain for regular files, it is possible
that we don't have an upperdentry and oe->numlower > 1 for non-dir. So
mark a path __OVL_TYPE_MERGE only if it is a directory.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3b509b691032..e717d561019d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -106,7 +106,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 				type |= __OVL_PATH_MERGE;
 		}
 	} else {
-		if (oe->numlower > 1)
+		if (oe->numlower > 1 && d_is_dir(dentry))
 			type |= __OVL_PATH_MERGE;
 	}
 	return type;
-- 
2.13.6
