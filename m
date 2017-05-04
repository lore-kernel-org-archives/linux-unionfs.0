From: Rock Lee <rockdotlee@gmail.com>
Subject: [PATCH] ovl: fix dir cache leak for ovl_cache_get
Date: Thu,  4 May 2017 00:07:13 -0700
Message-ID: <1493881633-3451-1-git-send-email-rockdotlee@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35812 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdEDHHW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 03:07:22 -0400
Received: by mail-pf0-f194.google.com with SMTP id u26so180038pfd.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 00:07:22 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: amir73il@gmail.com, linux-unionfs@vger.kernel.org, Rock Lee <rockdotlee@gmail.com>

In ovl_cache_get, there is a chance that ovl_dentry_version_get and
cache->version are not equal. Before set the cache to NULL, free it
first.

Signed-off-by: Rock Lee <rockdotlee@gmail.com>
---
 fs/overlayfs/readdir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..b3af3d3 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -331,6 +331,8 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 		cache->refcount++;
 		return cache;
 	}
+
+	kfree(cache);
 	ovl_set_dir_cache(dentry, NULL);
 
 	cache = kzalloc(sizeof(struct ovl_dir_cache), GFP_KERNEL);
-- 
1.9.1
