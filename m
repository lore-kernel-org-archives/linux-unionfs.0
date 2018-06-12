From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 14/39] ovl: stack file ops
Date: Tue, 12 Jun 2018 03:40:30 +0100
Message-ID: <20180612024029.GZ30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-15-mszeredi@redhat.com>
 <20180610041243.GJ30522@ZenIV.linux.org.uk>
 <CAJfpegtEGuBqmJ+6Kzd0456o0xyebe3LBk66xWQcuzsenqKVeg@mail.gmail.com>
 <20180612022926.GY30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180612022926.GY30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jun 12, 2018 at 03:29:26AM +0100, Al Viro wrote:

> It might (or might not) work for the filesystems you'd been testing
> on, but it's a lot of trouble waiting to happen.  Hell, try and use
> ecryptfs as lower layer, see how fast it'll blow up.  Sure, it's
> a dumb testcase, but I don't see how to check if something more
> realistic is trouble-free.
> 
> I'd been trying to come up with some way to salvage that kludge of yours,
> but I don't see any solutions.  We don't have good proxies for "this
> filesystem might be unsafe as lower layer" ;-/

Note that anything that uses file_dentry() anywhere near ->open(),
->read_iter() or ->write_iter() is an instant trouble with your scheme.
Such as
int nfs_open(struct inode *inode, struct file *filp)
{
        struct nfs_open_context *ctx;

        ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode, filp);
        if (IS_ERR(ctx)) 
                return PTR_ERR(ctx);
        nfs_file_set_open_context(filp, ctx);
        put_nfs_open_context(ctx);
        nfs_fscache_open_file(inode, filp);
        return 0;
}

You do want to support NFS for lower layers, right?
