Return-Path: <willy@infradead.org>
Date: Sat, 27 Oct 2018 06:23:39 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/1] man-page: copy_file_range(2) allow for cross-device
 copies
Message-ID: <20181027132339.GZ25444@bombadil.infradead.org>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-3-olga.kornievskaia@gmail.com>
 <20181027091240.GK6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181027091240.GK6311@dastard>
To: Dave Chinner <david@fromorbit.com>
Cc: Olga Kornievskaia <olga.kornievskaia@gmail.com>, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 08:12:40PM +1100, Dave Chinner wrote:
> > @@ -131,7 +132,8 @@ There is not enough space on the target filesystem to complete the copy.
> >  .B EXDEV
> >  The files referred to by
> >  .IR file_in " and " file_out
> > -are not on the same mounted filesystem.
> > +are not on the same mounted filesystem when the kernel does not support
> > +cross device file copy.
> 
> Kernel can support cross device file copy, the filesystem may not.
> 
> EXDEV
> 	One of the files specified by file_in and file_out are on a
> 	filesystem that does not support cross device copies.

I mentioned this in my last review, and Olga pointed out that one of
the changes in this patch means the kernel will do the copy using
do_splice_direct if the filesystem doesn't support cross-device copying.
We should keep this error documented for those on old kernels, but the
kernel will never return -EXDEV any more.
