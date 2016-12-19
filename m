From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] ovl: use rb_entry()
Date: Mon, 19 Dec 2016 22:56:43 +0800
Message-ID: <5d780509406819c42d134325f79d615f5ec3f693.1482159346.git.geliangtang@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36482 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756133AbcLSO4v (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Dec 2016 09:56:51 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

To make the code clearer, use rb_entry() instead of container_of() to
deal with rbtree.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 fs/overlayfs/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..401bdc4 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -58,7 +58,7 @@ struct ovl_dir_file {
 
 static struct ovl_cache_entry *ovl_cache_entry_from_node(struct rb_node *n)
 {
-	return container_of(n, struct ovl_cache_entry, node);
+	return rb_entry(n, struct ovl_cache_entry, node);
 }
 
 static struct ovl_cache_entry *ovl_cache_entry_find(struct rb_root *root,
-- 
2.9.3
