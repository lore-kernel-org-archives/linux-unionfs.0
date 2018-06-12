From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Tue, 12 Jun 2018 11:24:39 +0200
Message-ID: <CAJfpegvUkcUw0GXxFesT6V2f27EXW7jkvBpvnG4XB49BPdvjjA@mail.gmail.com>
References: <20180529144339.16538-1-mszeredi@redhat.com> <20180529144339.16538-15-mszeredi@redhat.com>
 <20180610041243.GJ30522@ZenIV.linux.org.uk> <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com>
 <20180612022926.GY30522@ZenIV.linux.org.uk> <20180612024029.GZ30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612024029.GZ30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jun 12, 2018 at 4:40 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jun 12, 2018 at 03:29:26AM +0100, Al Viro wrote:
>
>> It might (or might not) work for the filesystems you'd been testing
>> on, but it's a lot of trouble waiting to happen.  Hell, try and use
>> ecryptfs as lower layer, see how fast it'll blow up.  Sure, it's
>> a dumb testcase, but I don't see how to check if something more
>> realistic is trouble-free.

That's funny, because when dhowells added the patch to make f_path
point to the overlay, I was fighting tooth and claw against that
change on the grounds of being unsafe, but it went through regardless
(and was in fact one of the biggest headaches in overlay/vfs
interaction).

So you might be right that there are bugs in the handling of ecryptfs,
etc, however the patchset is guaranteed not to cause regressions in
this area.

And yes, it would be best to get rid of that kludge once and for all.

>>
>> I'd been trying to come up with some way to salvage that kludge of yours,
>> but I don't see any solutions.  We don't have good proxies for "this
>> filesystem might be unsafe as lower layer" ;-/
>
> Note that anything that uses file_dentry() anywhere near ->open(),
> ->read_iter() or ->write_iter() is an instant trouble with your scheme.
> Such as
> int nfs_open(struct inode *inode, struct file *filp)
> {
>         struct nfs_open_context *ctx;
>
>         ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode, filp);
>         if (IS_ERR(ctx))
>                 return PTR_ERR(ctx);
>         nfs_file_set_open_context(filp, ctx);
>         put_nfs_open_context(ctx);
>         nfs_fscache_open_file(inode, filp);
>         return 0;
> }
>
> You do want to support NFS for lower layers, right?

There's no change regarding how file_dentry() works.  We've just
pushed these weird files (f_path points to overlay, f_inode points to
underlay) down into the guts of overlayfs and are not directly
referenced from the file table anymore.  That shouldn't make *any*
difference from the lower fs's pov.

The only difference is that now the real file has creds inherited from
mounter task.  If lower filesystem's a_ops did some permission
checking based on that, then that might make a difference in behavior.
But I guess that difference would be in the positive direction, making
behavior more consistent.

Thanks,
Miklos
