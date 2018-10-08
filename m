Return-Path: <rgoldwyn@suse.de>
Date: Mon, 8 Oct 2018 10:30:14 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] Open a new file instance if no read permissions on files
Message-ID: <20181008153014.vb4hd7xdpbsbbrxg@merlin>
References: <20181005214213.ickkfgu5a7tzzenk@merlin>
 <1538874061.4914.16.camel@linux.ibm.com>
 <20181008121455.za53z7kgfizgtiv7@merlin>
 <1539005279.15382.119.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1539005279.15382.119.camel@linux.ibm.com>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org, iforster@suse.de, fvogt@suse.de, miklos@szeredi.hu
List-ID: <linux-unionfs@vger.kernel.org>

On  9:27 08/10, Mimi Zohar wrote:
> On Mon, 2018-10-08 at 07:14 -0500, Goldwyn Rodrigues wrote:
> 
> > 
> > > >  
> > > > +	if (!(file->f_mode & FMODE_READ)) {
> > > > +		struct file *f;
> > > 
> > > I would define "struct file *f = file" above, at the beginning of
> > > function, and "free(f)" below, without modifying "file".
> > 
> > I suppose you mean fput(f).
> 
> yes
> 
> > Okay, if it makes code more understandable.
> 
> Thanks
> > 
> > > 
> > > > +		int flags = file->f_flags & ~(O_WRONLY | O_APPEND | O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
> > > 
> > > Doesn't O_RDONLY need to be added?
> > 
> > No. O_RDONLY is zero. But I think I should add it for readability. The
> > compiler will optimize it eventually.
> > 
> > > Please fix the line length.
> > > 
> > > 
> > > > +		f = dentry_open(&file->f_path, flags, file->f_cred);
> > > > +		if (IS_ERR(f))
> > > > +			return PTR_ERR(f);
> 
> It's late in the release cycle to be making this change. �Would it
> make sense for now to fallback to modifying the original file
> descriptor on failure and emit a message?

Yes, perhaps and it may still succeed. Won't it be misleading if it does?
Would ima_update_xattr() be a good place? Not sure if it would spew too
many messages if there is an issue. I am all in for modifying the
original file->f_flags on failure. Just not sure about the error
message.

Currently, when we perform IMA hash calculation on a O_WRONLY file with
overlayfs, there is no error in dmesg. Just EACCES on the _next_ write
which makes it difficult to conclude whats wrong.

-- 
Goldwyn
