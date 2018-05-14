Return-Path: <viro@ftp.linux.org.uk>
Date: Mon, 14 May 2018 16:39:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATCH] ovl_create_index(): vfs_mkdir() might succeed
 leaving dentry negative unhashed
Message-ID: <20180514153900.GG30522@ZenIV.linux.org.uk>
References: <20180512012557.GJ30522@ZenIV.linux.org.uk>
 <CAJfpegvU9BM+BL7CyxERNnYNpdG=hpXSZSNL7KcZ4-qR3XUbcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvU9BM+BL7CyxERNnYNpdG=hpXSZSNL7KcZ4-qR3XUbcA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 14, 2018 at 05:04:44PM +0200, Miklos Szeredi wrote:
> On Sat, May 12, 2018 at 3:25 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > [same story as with the previous two patches]
> >
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 8bede0742619..cdd8f8816d2a 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -373,6 +373,22 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
> >         if (err)
> >                 goto out;
> >
> > +       if (unlikely(d_unhashed(temp))) {
> > +               struct dentry *d = lookup_one_len(temp->d_name.name,
> > +                                                 temp->d_parent,
> > +                                                 temp->d_name.len);
> > +               if (IS_ERR(d)) {
> > +                       err = PTR_ERR(d);
> > +                       goto out;
> 
> This violates the "If -1 is returned, no directory shall be created" rule.

So does NFS, for that matter...  If you use weird filesystems as layers,
you get corner cases.  Note that on NFS we'll probably have to go for
that possibility (== argument unhashed negative after success) on mkdir,
in case when it's reexported and somebody is playing silly buggers with
races.

> lookup_one_len() does various permission checks.  The normal DAC check
> is not a worry, because of the lock on the parent. But is it
> guaranteed that MAC allows lookup if it allowed mkdir?

*shrug*

Or it can be set so that rmdir won't be allowed afterwards, or...
There are all kinds of ways to set idiotic LSM that would screw overlayfs.
Doctor, it hurts when I do it...  But then you know what I think of
Linux S&M community in general...

Right now you code would fail with -EIO in all those cases, AFAICS.  So you
might get a stray -EPERM...
