From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Fri, 21 Oct 2016 11:12:11 +0200
Message-ID: <20161021091211.GI31239@veci.piliscsaba.szeredi.hu>
References: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
 <20161020204630.GA1000@redhat.com>
 <20161020205408.GB1000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161020205408.GB1000@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Oct 20, 2016 at 04:54:08PM -0400, Vivek Goyal wrote:
> On Thu, Oct 20, 2016 at 04:46:30PM -0400, Vivek Goyal wrote:
> 
> [..]
> > > +static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > > +{
> > > +	struct file *file = iocb->ki_filp;
> > > +	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
> > > +	ssize_t ret = -EINVAL;
> > > +
> > > +	if (likely(!isupper)) {
> > > +		const struct file_operations *fop = ovl_real_fop(file);
> > > +
> > > +		if (likely(fop->read_iter))
> > > +			ret = fop->read_iter(iocb, to);
> > > +	} else {
> > > +		struct file *upperfile = filp_clone_open(file);
> > > +
> > 
> > IIUC, every read of lower file will call filp_clone_open(). Looking at the
> > code of filp_clone_open(), I am concerned about the overhead of this call.
> > Is it significant? Don't want to be paying too much of penalty for read
> > operation on lower files. That would be a common case for containers.
> > 
> 
> Looks like I read the code in reverse. So if I open a file read-only,
> and if it has not been copied up, I will simply call read_iter() on
> lower filesystem. But if file has been copied up, then I will call
> filp_clone_open() and pay the cost. And this will continue till this
> file is closed by caller. 
> 
> When file is opened again, by that time it is upper file and we will
> install real fop in file (instead of overlay fop).

Right.

The lockdep issue seems to be real, we can't take i_mutex and s_vfs_rename_mutex
while mmap_sem is locked.  Fortunately copy up doesn't need mmap_sem, so we can
do it while unlocked and retry the mmap.

Here's an incremental workaround patch.

I don't like adding such workarounds to the VFS/MM but they are really cheap for
the non-overlay case and there doesn't appear to be an alternative in this case.

Thanks,
Miklos

---
 fs/overlayfs/inode.c |   19 +++++--------------
 mm/util.c            |   22 ++++++++++++++++++++++
 2 files changed, 27 insertions(+), 14 deletions(-)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -419,21 +419,12 @@ static int ovl_mmap(struct file *file, s
 	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
 	int err;
 
-	/*
-	 * Treat MAP_SHARED as hint about future writes to the file (through
-	 * another file descriptor).  Caller might not have had such an intent,
-	 * but we hope MAP_PRIVATE will be used in most such cases.
-	 *
-	 * If we don't copy up now and the file is modified, it becomes really
-	 * difficult to change the mapping to match that of the file's content
-	 * later.
-	 */
 	if (unlikely(isupper || vma->vm_flags & VM_MAYSHARE)) {
-		if (!isupper) {
-			err = ovl_copy_up(file->f_path.dentry);
-			if (err)
-				goto out;
-		}
+		/*
+		 * File should have been copied up by now. See vm_mmap_pgoff().
+		 */
+		if (WARN_ON(!isupper))
+			return -EIO;
 
 		file = filp_clone_open(file);
 		err = PTR_ERR(file);
--- a/mm/util.c
+++ b/mm/util.c
@@ -297,6 +297,28 @@ unsigned long vm_mmap_pgoff(struct file
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
+		/*
+		 * Special treatment for overlayfs:
+		 *
+		 * Take MAP_SHARED/PROT_READ as hint about future writes to the
+		 * file (through another file descriptor).  Caller might not
+		 * have had such an intent, but we hope MAP_PRIVATE will be used
+		 * in most such cases.
+		 *
+		 * If we don't copy up now and the file is modified, it becomes
+		 * really difficult to change the mapping to match that of the
+		 * file's content later.
+		 *
+		 * Copy up needs to be done without mmap_sem since it takes vfs
+		 * locks which would potentially deadlock under mmap_sem.
+		 */
+		if ((flag & MAP_SHARED) && !(prot & PROT_WRITE)) {
+			void *p = d_real(file->f_path.dentry, NULL, O_WRONLY);
+
+			if (IS_ERR(p))
+				return PTR_ERR(p);
+		}
+
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
