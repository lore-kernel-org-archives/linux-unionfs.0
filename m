From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix check for cursor
Date: Mon, 27 Oct 2014 13:48:48 +0100
Message-ID: <20141027124848.GB3021@tucsk.piliscsaba.szeredi.hu>
References: <20141027124315.GA3021@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:60331 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaJ0Msw (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 27 Oct 2014 08:48:52 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so5587102wgh.12
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Oct 2014 05:48:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20141027124315.GA3021@tucsk.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

D'oh, I must remember to review own patches *before* sending them, not after...

Here's an updated one.

Thanks,
Miklos
---

Subject: ovl: fix check for cursor
From: Miklos Szeredi <mszeredi@suse.cz>

ovl_cache_entry.name is now an array not a pointer, so it makes no sense
test for it being NULL.

Detected by coverity.

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
+		if (p->is_cursor)
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
