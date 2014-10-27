From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Locking problem in overlayfs
Date: Mon, 27 Oct 2014 15:42:01 +0100
Message-ID: <20141027144201.GD3021@tucsk.piliscsaba.szeredi.hu>
References: <20141027141935.GC3021@tucsk.piliscsaba.szeredi.hu>
 <5394.1414418718@warthog.procyon.org.uk>
 <6032.1414420761@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44218 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaJ0OmJ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 27 Oct 2014 10:42:09 -0400
Received: by mail-lb0-f173.google.com with SMTP id l4so786393lbv.32
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Oct 2014 07:42:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <6032.1414420761@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Mon, Oct 27, 2014 at 02:39:21PM +0000, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Uh-oh.  We changed nesting late in the cycle and I didn't retest with lockdep.
> > 
> > And it's actually harmless, but AFAICS needs another level of nesting between
> > I_MUTEX_CHILD and I_MUTEX_NORMAL.
> 
> In an overlay directory that shadows an empty lower directory, say
> /mnt/a/empty102, do:
> 
> 	touch /mnt/a/empty102/x
> 	unlink /mnt/a/empty102/x
> 	rmdir /mnt/a/empty102


Yes, following (untested) patch should fix it:

Thanks,
Miklos

diff --git a/fs/namei.c b/fs/namei.c
index 42df664e95e5..922f27068c4c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2497,7 +2497,7 @@ struct dentry *lock_rename(struct dentry *p1, struct dentry *p2)
 	}
 
 	mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
-	mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_CHILD);
+	mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_PARENT2);
 	return NULL;
 }
 EXPORT_SYMBOL(lock_rename);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 910553f37aca..de77b5c62d72 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -569,7 +569,7 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 {
 	struct ovl_cache_entry *p;
 
-	mutex_lock_nested(&upper->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&upper->d_inode->i_mutex, I_MUTEX_CHILD);
 	list_for_each_entry(p, list, l_node) {
 		struct dentry *dentry;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4e41a4a331bb..01036262095f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -639,11 +639,13 @@ static inline int inode_unhashed(struct inode *inode)
  * 2: child/target
  * 3: xattr
  * 4: second non-directory
- * The last is for certain operations (such as rename) which lock two
+ * 5: second parent (when locking independent directories in rename)
+ *
+ * I_MUTEX_NONDIR2 is for certain operations (such as rename) which lock two
  * non-directories at once.
  *
  * The locking order between these classes is
- * parent -> child -> normal -> xattr -> second non-directory
+ * parent[2] -> child -> grandchild -> normal -> xattr -> second non-directory
  */
 enum inode_i_mutex_lock_class
 {
@@ -651,7 +653,8 @@ enum inode_i_mutex_lock_class
 	I_MUTEX_PARENT,
 	I_MUTEX_CHILD,
 	I_MUTEX_XATTR,
-	I_MUTEX_NONDIR2
+	I_MUTEX_NONDIR2,
+	I_MUTEX_PARENT2,
 };
 
 void lock_two_nondirectories(struct inode *, struct inode*);
