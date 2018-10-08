Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181006041531.30246-1-amir73il@gmail.com> <20181007160648.GY32577@ZenIV.linux.org.uk>
In-Reply-To: <20181007160648.GY32577@ZenIV.linux.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 8 Oct 2018 06:16:06 +0300
Message-ID: <CAOQ4uxgcEy1moAJZjj+CYX+1dWXw2rQOsOf2ZZps54WJPo6sbA@mail.gmail.com>
Subject: Re: [PATCH] ovl: untangle copy up call chain
Content-Type: text/plain; charset="UTF-8"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Oct 7, 2018 at 7:06 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sat, Oct 06, 2018 at 07:15:31AM +0300, Amir Goldstein wrote:
> > +static int ovl_link_tmpfile(struct ovl_copy_up_ctx *c, struct dentry *temp,
> > +                         struct dentry **newdentry)
> > +{
> > +     int err;
> > +     struct dentry *upper = NULL;
> > +     struct inode *udir = d_inode(c->destdir);
> > +
> > +     inode_lock_nested(udir, I_MUTEX_PARENT);
> > +     upper = lookup_one_len(c->destname.name, c->destdir, c->destname.len);
> > +     err = PTR_ERR(upper);
> > +     if (IS_ERR(upper))
> > +             goto out;
>
> dput(ERR_PTR(something)) will immediately oops on you...

And that's not the only braino in this patch:

+       unlock_rename(c->workdir, c->destdir);
+       if (err)
                ovl_cleanup(d_inode(c->workdir), temp);

Thanks for the review,
Amir.
