From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.10
Date: Sun, 11 Dec 2016 22:32:18 +0100
Message-ID: <20161211213218.GA27207@veci.piliscsaba.szeredi.hu>
References: <20161210204926.GL2622@veci.piliscsaba.szeredi.hu>
 <20161211021218.GK1555@ZenIV.linux.org.uk>
 <CAJfpegtfaZM4GAJSom9YqCv=hB8e7CGOcKzcyWtCqPtoDo-b=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34212 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753846AbcLKVc2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Dec 2016 16:32:28 -0500
Received: by mail-wm0-f66.google.com with SMTP id g23so7193253wme.1
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Dec 2016 13:32:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAJfpegtfaZM4GAJSom9YqCv=hB8e7CGOcKzcyWtCqPtoDo-b=w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Sun, Dec 11, 2016 at 02:51:15PM +0100, Miklos Szeredi wrote:
> On Sun, Dec 11, 2016 at 3:12 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sat, Dec 10, 2016 at 09:49:26PM +0100, Miklos Szeredi wrote:
> >> Hi Al,
> >>
> >> I usually send overlayfs pulls directly to Linus, but it it suits you, please
> >> feel free to pull from:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus
> >>

Force pushed updated patchset.  Changes:

 - fix module put order;
 - don't hide file op calls in a macro;
 - don't intercept ops by default (no action required on addition of new ones).

Incremental diff attached.

Please let me know if this will fly or not.  If not, I'll drop this part and do
one which handles this within the VFS.

Thanks,
Miklos

---
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 2dc252e262c1..7512e3e4bd1f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -326,31 +326,37 @@ void ovl_cleanup_fops_htable(void)
 	struct ovl_fops *ofop;
 
 	hash_for_each_safe(ovl_fops_htable, bkt, tmp, ofop, entry) {
-		module_put(ofop->owner);
 		fops_put(ofop->orig_fops);
+		module_put(ofop->owner);
 		kfree(ofop);
 	}
 }
 
-#define OVL_CALL_REAL_FOP(file, call) \
-	({ struct ovl_fops *__ofop =					 \
-			container_of(file->f_op, struct ovl_fops, fops); \
-	   WARN_ON(__ofop->magic != OVL_FOPS_MAGIC) ? -EIO :		 \
-		   __ofop->orig_fops->call;				 \
-	})
-
 static bool ovl_file_is_lower(struct file *file)
 {
 	return !OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
 }
 
+static const struct file_operations *ovl_orig_fops(struct file *file)
+{
+	struct ovl_fops *ofop = container_of(file->f_op, struct ovl_fops, fops);
+
+	if (WARN_ON(ofop->magic != OVL_FOPS_MAGIC))
+		return NULL;
+
+	return ofop->orig_fops;
+}
+
 static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
 	ssize_t ret;
 
-	if (likely(ovl_file_is_lower(file)))
-		return OVL_CALL_REAL_FOP(file, read_iter(iocb, to));
+	if (likely(ovl_file_is_lower(file))) {
+		const struct file_operations *f_op = ovl_orig_fops(file);
+
+		return f_op ? f_op->read_iter(iocb, to) : -EIO;
+	}
 
 	file = filp_clone_open(file);
 	if (IS_ERR(file))
@@ -364,8 +370,11 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (likely(ovl_file_is_lower(file)))
-		return OVL_CALL_REAL_FOP(file, mmap(file, vma));
+	if (likely(ovl_file_is_lower(file))) {
+		const struct file_operations *f_op = ovl_orig_fops(file);
+
+		return f_op ? f_op->mmap(file, vma) : -EIO;
+	}
 
 	file = filp_clone_open(file);
 	if (IS_ERR(file))
@@ -386,8 +395,9 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	int ret;
 
 	if (likely(ovl_file_is_lower(file))) {
-		return OVL_CALL_REAL_FOP(file,
-					 fsync(file, start, end, datasync));
+		const struct file_operations *f_op = ovl_orig_fops(file);
+
+		return f_op ? f_op->fsync(file, start, end, datasync) : -EIO;
 	}
 	file = filp_clone_open(file);
 	if (IS_ERR(file))
@@ -437,6 +447,9 @@ static struct ovl_fops *ovl_fops_get(struct file *file)
 	ofop->magic = OVL_FOPS_MAGIC;
 	ofop->orig_fops = fops_get(orig);
 
+	/* By default don't intercept: */
+	ofop->fops = *orig;
+
 	/* Intercept these: */
 	if (orig->read_iter)
 		ofop->fops.read_iter = ovl_read_iter;
@@ -447,24 +460,39 @@ static struct ovl_fops *ovl_fops_get(struct file *file)
 
 	/*
 	 * These should be intercepted, but they are very unlikely to be
-	 * a problem in practice.  Leave them alone for now.
+	 * a problem in practice.  Leave them alone for now:
+	 *
+	 * - copy_file_range
+	 * - clone_file_range
+	 * - dedupe_file_range
+	 *
+	 * Don't intercept these:
+	 *
+	 * - llseek
+	 * - unlocked_ioctl
+	 * - compat_ioctl
+	 * - flush
+	 * - release
+	 * - get_unmapped_area
+	 * - check_flags
+	 *
+	 * These will never be called on R/O file descriptors:
+	 *
+	 * - write
+	 * - write_iter
+	 * - splice_write
+	 * - sendpage
+	 * - fallocate
+	 *
+	 * Locking operations are already intercepted by vfs for ovl:
+	 *
+	 * - lock
+	 * - flock
+	 * - setlease
 	 */
-	ofop->fops.copy_file_range = orig->copy_file_range;
-	ofop->fops.clone_file_range = orig->clone_file_range;
-	ofop->fops.dedupe_file_range = orig->dedupe_file_range;
-
-	/* Don't intercept these: */
-	ofop->fops.llseek = orig->llseek;
-	ofop->fops.unlocked_ioctl = orig->unlocked_ioctl;
-	ofop->fops.compat_ioctl = orig->compat_ioctl;
-	ofop->fops.flush = orig->flush;
-	ofop->fops.release = orig->release;
-	ofop->fops.get_unmapped_area = orig->get_unmapped_area;
-	ofop->fops.check_flags = orig->check_flags;
 
 	/* splice_read should be generic_file_splice_read */
 	WARN_ON(orig->splice_read != generic_file_splice_read);
-	ofop->fops.splice_read = generic_file_splice_read;
 
 	/* These make no sense for "normal" files: */
 	WARN_ON(orig->read);
@@ -474,22 +502,6 @@ static struct ovl_fops *ovl_fops_get(struct file *file)
 	WARN_ON(orig->fasync);
 	WARN_ON(orig->show_fdinfo);
 
-	/*
-	 * Don't add those which are unneeded for O_RDONLY:
-	 *
-	 *  write
-	 *  write_iter
-	 *  splice_write
-	 *  sendpage
-	 *  fallocate
-	 *
-	 * Locking operations are already intercepted by vfs for ovl:
-	 *
-	 *  lock
-	 *  flock
-	 *  setlease
-	 */
-
 	hash_add_rcu(ovl_fops_htable, &ofop->entry, (long) orig);
 
 out_unlock:
