Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1574129643-14664-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1574129643-14664-3-git-send-email-jiufei.xue@linux.alibaba.com>
 <CAOQ4uxhU0NGqX-P4XTJ+kf6sXNCnUCBxgp1u2-aDV5p15Jh+tg@mail.gmail.com>
 <142a7524-2587-7b1c-c5e0-3eb2d42b2762@linux.alibaba.com> <CAOQ4uxgR3KO9kXGdqif0A-QBrVLn9id2eFANMDprCz62jSAmaQ@mail.gmail.com>
 <e88b8262-c475-f969-ef65-d888aee20e20@linux.alibaba.com>
In-Reply-To: <e88b8262-c475-f969-ef65-d888aee20e20@linux.alibaba.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 19 Nov 2019 14:50:31 +0200
Message-ID: <CAOQ4uxiNxgVkAH_uG7tABFP7_X9EWQxcC2A00dkXTPJzToXhvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: implement async IO routines
Content-Type: text/plain; charset="UTF-8"
To: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> >>
> >> Refer to function generic_file_read_iter(), in direct IO path,
> >> file_accessed() is done before IO submission, so I think ovl_file_accessed()
> >> should be done here no matter completion/error or IO is queued.
> >
> > Mmm, it doesn't matter much if atime is updated before or after,
> > but ovl_file_accessed() does not only update atime, it also copies
> > ctime which could have been modified as a result of the io, so
> > I think it is safer to put it in the cleanup hook.
> >
>
> Can you give a more detailed description that a read op will modify
> ctime as a result of the io?
>
> I found that it will trigger BUG_ON(irqs_disabled()) while
> calling ovl_file_accessed() on async IO return path. The calltrace
> is pasted below:
>
> ovl_file_accessed
>   -> touch_atime
>     -> ovl_update_time
>       -> generic_update_time
>         -> __mark_inode_dirty
>           -> ext4_dirty_inode
>             -> __ext4_get_inode_loc
>               -> __find_get_block
>                 -> lookup_bh_lru
>                    -> check_irqs_on
>
> So I need more detail to find how to fix this issue.
>

It's not important. Please ignore. I din't know there was an issue
with placing touch_atime() in completion context.

Thanks,
Amir.
