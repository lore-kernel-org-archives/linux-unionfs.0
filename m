From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Mon, 18 Jun 2018 13:50:38 +0200
Message-ID: <20180618115038.GK23785@veci.piliscsaba.redhat.com>
References: <20180529144339.16538-15-mszeredi@redhat.com>
 <20180610041243.GJ30522@ZenIV.linux.org.uk>
 <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com>
 <20180612022926.GY30522@ZenIV.linux.org.uk>
 <20180612024029.GZ30522@ZenIV.linux.org.uk>
 <CAJfpegvUkcUw0GXxFesT6V2f27EXW7jkvBpvnG4XB49BPdvjjA@mail.gmail.com>
 <20180612182423.GA30522@ZenIV.linux.org.uk>
 <20180612183123.GB30522@ZenIV.linux.org.uk>
 <CAJfpegsnvxUNCaE4c1_UDKq169i8WBTMuWzyvyo8UvenqZCUXg@mail.gmail.com>
 <20180615054717.GC30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180615054717.GC30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 15, 2018 at 06:47:17AM +0100, Al Viro wrote:
> On Wed, Jun 13, 2018 at 11:21:30AM +0200, Miklos Szeredi wrote:

> > Looked at some other options...  What coda mmap does looks very
> > dubious.  It only sets f_mapping, not vm_file.  That's going to get
> > into all sorts of trouble when underlying fs tries to look at
> > file_inode() or worse, ->private_data.  Looks like that should be
> > converted to what overlayfs does, to have a remote chance of actually
> > not crashing on most filesystems.  Does anybody actually use coda
> > still?
> 
> Keep in mind that coda is using the local fs only as cache; IOW, its needs
> are much more limited than those of overlayfs - local r/w filesystem,
> disk-backed or tmpfs, used pretty much as a scratch space.

Look:

coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
{
[...]
	coda_file->f_mapping = host_file->f_mapping;
[...]
	return call_mmap(host_file, vma);
}

So that'll end up with vma->vm_file pointing to coda file, coda_file->f_mapping
pointing to host mapping.  Hence vm_ops and a_ops are going to come from host
file, but they'll be getting a "foreign" file with ->private_data and ->f_inode
pointing to coda structures.

For example:

int ext4_filemap_fault(struct vm_fault *vmf)
{
	struct inode *inode = file_inode(vmf->vma->vm_file)
	int err;

	down_read(&EXT4_I(inode)->i_mmap_sem);
[...]

There you have it: coda inode being interpreted as ext4 inode.  How is that
supposed to work?  How is it not blowing up?  What am I missing?

Thanks,
Miklos
