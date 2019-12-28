Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
 <1535374564-8257-7-git-send-email-amir73il@gmail.com> <BC68C02C-E6E5-4414-A1D2-D36D335738E2@dilger.ca>
In-Reply-To: <BC68C02C-E6E5-4414-A1D2-D36D335738E2@dilger.ca>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Dec 2019 12:10:38 +0200
Message-ID: <CAOQ4uxjuJ-6Tw3vw1qahjp2LrGPx=eZfZA9qk47=mWSamEiF+g@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] ovl: add ovl_fadvise()
Content-Type: text/plain; charset="UTF-8"
To: Andreas Dilger <adilger@dilger.ca>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Dec 28, 2019 at 7:49 AM Andreas Dilger <adilger@dilger.ca> wrote:
>
> On Aug 27, 2018, at 6:56 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Implement stacked fadvise to fix syscalls readahead(2) and fadvise64(2)
> > on an overlayfs file.
>
> I was just looking into the existence of the "new" fadvise() method in
> the VFS being able to communicate application hints directly to the
> filesystem to see if it could be used to address the word size issue in
> https://bugzilla.kernel.org/show_bug.cgi?id=205957 without adding a new
> syscall, and came across this patch and the 4/6 patch that adds the
> vfs_fadvise() function itself (copied below for clarity).
>
> It seems to me that this implementation is broken?  Only vfs_fadvise()
> is called from the fadvise64() syscall, and it will call f_op->fadvise()
> if the filesystem provides this method.  Only overlayfs provides the
> .fadvise method today.  However, it looks that ovl_fadvise() calls back
> into vfs_fadvise() again, in a seemingly endless loop?
>

You are confusing endless loop with recursion that has a stop condition.
The entire concept of stacked filesystem is recursion back into vfs.
This is essentially what most of the ovl file operations do, but they recurse
on the "real.file", which is supposed to be on a filesystem with lower
sb->s_stack_depth (FILESYSTEM_MAX_STACK_DEPTH is 2).

> It seems like generic_fadvise() should be EXPORT_SYMBOL() so that any
> filesystem that implements its own .fadvise method can do its own thing,
> and then call generic_fadvise() to handle the remaining MM-specific work.
>
> Thoughts?

Sure makes sense.
Overlayfs just doesn't need to call the generic helper.

Thanks,
Amir.
