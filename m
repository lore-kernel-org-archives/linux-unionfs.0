From: xuw2015@gmail.com
Subject: [PATCH 1/2] fs: export d_exchange for the fs with FS_RENAME_DOSE_D_MOVE
Date: Thu,  3 Sep 2015 17:12:11 +0800
Message-ID: <1441271532-10386-1-git-send-email-xuw2015@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Geroge Wang <xuw2015@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

From: Geroge Wang <xuw2015@gmail.com>

d_move is exported for specified file systems, we should export
d_exchange also.

Signed-off-by: George Wang <xuw2015@gmail.com>
---
 fs/dcache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9b5fe50..a6de9b0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2694,6 +2694,7 @@ void d_exchange(struct dentry *dentry1, struct dentry *dentry2)
 
 	write_sequnlock(&rename_lock);
 }
+EXPORT_SYMBOL(d_exchange);
 
 /**
  * d_ancestor - search for an ancestor
-- 
1.8.3.1

