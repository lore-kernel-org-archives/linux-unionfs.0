From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] ovl: fix check for cursor
Date: Mon, 27 Oct 2014 13:43:15 +0100
Message-ID: <20141027124315.GA3021@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

ovl_cache_entry.name is now an array not a pointer, so it makes no sense
test for it being NULL.

Detected by coverity.

From: Miklos Szeredi <mszeredi@suse.cz>
Fixes: 68bf8611076a ("overlayfs: make ovl_cache_entry->name an array instead of pointer")
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/readdir.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -21,9 +21,10 @@ struct ovl_cache_entry {
 	unsigned int len;
 	unsigned int type;
 	u64 ino;
-	bool is_whiteout;
 	struct list_head l_node;
 	struct rb_node node;
+	bool is_whiteout;
+	bool is_cursor;
 	char name[];
 };
 
@@ -251,7 +252,7 @@ static int ovl_dir_mark_whiteouts(struct
 
 	mutex_lock(&dir->d_inode->i_mutex);
 	list_for_each_entry(p, rdd->list, l_node) {
-		if (!p->name)
+		if (!p->is_cursor)
 			continue;
 
 		if (p->type != DT_CHR)
@@ -307,7 +308,6 @@ static inline int ovl_dir_read_merged(st
 	}
 out:
 	return err;
-
 }
 
 static void ovl_seek_cursor(struct ovl_dir_file *od, loff_t pos)
@@ -316,7 +316,7 @@ static void ovl_seek_cursor(struct ovl_d
 	loff_t off = 0;
 
 	list_for_each_entry(p, &od->cache->entries, l_node) {
-		if (!p->name)
+		if (p->is_cursor)
 			continue;
 		if (off >= pos)
 			break;
@@ -389,7 +389,7 @@ static int ovl_iterate(struct file *file
 
 		p = list_entry(od->cursor.l_node.next, struct ovl_cache_entry, l_node);
 		/* Skip cursors */
-		if (p->name) {
+		if (!p->is_cursor) {
 			if (!p->is_whiteout) {
 				if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
 					break;
@@ -518,6 +518,7 @@ static int ovl_dir_open(struct inode *in
 	od->realfile = realfile;
 	od->is_real = (type != OVL_PATH_MERGE);
 	od->is_upper = (type != OVL_PATH_LOWER);
+	od->cursor.is_cursor = true;
 	file->private_data = od;
 
 	return 0;
