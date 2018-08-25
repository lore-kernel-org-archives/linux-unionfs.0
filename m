MIME-Version: 1.0
In-Reply-To: <CAOQ4uxj=3N28eSX1papQU4n3bt-J7S=_NhtTFq0xV1k0WgH-Ug@mail.gmail.com>
References: <1535101371-26461-1-git-send-email-amir73il@gmail.com>
	<20180824233901.GA2234@dastard>
	<CAOQ4uxj=3N28eSX1papQU4n3bt-J7S=_NhtTFq0xV1k0WgH-Ug@mail.gmail.com>
Date: Sat, 25 Aug 2018 22:04:22 +0200
Message-ID: <CAJfpegtCj=bgVQ5SOD-WfSfU9=auderyYnYboUJtnCr8OcPdMA@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix GPF in swapfile_activate of file from overlayfs
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Aug 25, 2018 at 12:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> Actually, I believe the intention was that fs developers don't need to worry
> about using file_inode() at all, because before the change we had:
>
> - file passed in to xfs f_op's and a_ops is either overlay file OR xfs file
> - file_inode() of either overlay/xfs file in xfs context is always xfs inode
> - file->f_path in xfs context, BTW, was overlay path and therefore,
>   XFS_IOC_OPEN_BY_HANDLE was slightly broken in overlayfs over xfs,
>   as were several other fs specific ioctls
>
> After stacked file operations change we should have the rules:
>
> 1. file passed in to xfs f_op's is always xfs file (*)
> 2. file passed in to xfs a_ops is always xfs file (**)
> 3. file_inode() of overlay file is an overlay inode
>
> (*) as explicit file argument or on iocb->ki_filp
> (**) as explicit file argument or on ->vm_file
>
> I believe that swapfile leaking an overlay file into xfs was an oversight,
> that is breaking rule #2.

Correct.

I believe the root cause is this

    /* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
    file->f_mapping = realfile->f_mapping;

in ovl_open().  So lets start with removing that.  That should fix any
oopses related to this, but we'll have some other issues:

 1) open(..., O_DIRECT) will return an error

This is easy to fix:  add ovl_file_aops with a dummy ovl_direct_IO()
function that will never be called.

 2) swapon() will return an error

First question that comes to mind:  does anybody care?  I wouldn't
think swapfiles would be an important feature for overlayfs, but we
did support them up till now, so removing support might cause a
regression somewhere out there.   Unfortunate...

Thanks,
Miklos
