From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 19/39] ovl: add ovl_mmap()
Date: Mon, 11 Jun 2018 09:58:32 +0200
Message-ID: <20180611075832.GH23785@veci.piliscsaba.redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-20-mszeredi@redhat.com>
 <20180610052447.GN30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180610052447.GN30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jun 10, 2018 at 06:24:59AM +0100, Al Viro wrote:
> On Tue, May 29, 2018 at 04:43:19PM +0200, Miklos Szeredi wrote:
> > Implement stacked mmap.
> > 
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > ---
> >  fs/overlayfs/file.c | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> > 
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index 7b47dce4b072..4057bbf2e141 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -255,6 +255,33 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
> >  	return ret;
> >  }
> >  
> > +static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	struct fd real;
> > +	const struct cred *old_cred;
> > +	int ret;
> > +
> > +	ret = ovl_real_fdget(file, &real);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* transfer ref: */
> > +	fput(vma->vm_file);
> > +	vma->vm_file = get_file(real.file);
> > +	fdput(real);
> > +
> > +	if (!vma->vm_file->f_op->mmap)
> > +		return -ENODEV;
> 
> That's broken.  ->mmap() failure will fput(file), not fput(vma->vm_file).
> What's more, _here_ your "corner case" is a huge DoS - open file r/o,
> then have somebody else trigger copyup, then do tons of MAP_PRIVATE
> mmaps on the r/o descriptor.  *EACH* *OF* *THEM* will open a separate
> struct file and stash into into new vmas.
> 
> NAK with extreme prejudice, sensu PTerry...

Okay, okay, got it now.  Incremental below.  It's a step back (mmap after
copy-up will get old data), but not a regression from current state.  Obviously
need to fix properly and I think that's doable together with dealing with shared
map coherency.


diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index f801e1175a0b..b5a6bcc1bcfa 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -282,26 +282,30 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct fd real;
+	struct file *realfile = file->private_data;
 	const struct cred *old_cred;
 	int ret;
 
-	ret = ovl_real_fdget(file, &real);
-	if (ret)
-		return ret;
+	if (!realfile->f_op->mmap)
+		return -ENODEV;
 
-	/* transfer ref: */
-	fput(vma->vm_file);
-	vma->vm_file = get_file(real.file);
-	fdput(real);
+	if (WARN_ON(file != vma->vm_file))
+		return -EIO;
 
-	if (!vma->vm_file->f_op->mmap)
-		return -ENODEV;
+	vma->vm_file = get_file(realfile);
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = call_mmap(vma->vm_file, vma);
 	revert_creds(old_cred);
 
+	if (ret) {
+		/* Drop reference count from new vm_file value */
+		fput(realfile);
+	} else {
+		/* Drop reference count from previous vm_file value */
+		fput(file);
+	}
+
 	ovl_file_accessed(file);
 
 	return ret;
