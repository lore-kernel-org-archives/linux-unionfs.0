From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 11/18] ovl: Allocate bigger stack for origin
Date: Wed, 31 Jan 2018 16:13:22 -0500
Message-ID: <20180131211329.16328-12-vgoyal@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752319AbeAaVNn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:43 -0500
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Right now there is only one origin for upper dentry and we allocate space
to hold only one ovl_path. But with metacopy support, it is possible that
lower origin is a metacopy itself and we will continue the search for
lower most data entry and install that too in lower stack so that this
entry can be used for copy up later.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 27a069cd2bf4..ddb73b5a06d4 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -361,7 +361,8 @@ static int ovl_check_origin(struct dentry *upperdentry,
 
 	BUG_ON(*ctrp);
 	if (!*stackp)
-		*stackp = kmalloc(sizeof(struct ovl_path), GFP_KERNEL);
+		*stackp = kmalloc(sizeof(struct ovl_path) * numlower,
+				  GFP_KERNEL);
 	if (!*stackp) {
 		dput(origin);
 		return -ENOMEM;
-- 
2.13.6
