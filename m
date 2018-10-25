Return-Path: <vgoyal@redhat.com>
Date: Thu, 25 Oct 2018 09:38:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] ovl: untangle copy up call chain
Message-ID: <20181025133840.GD20565@redhat.com>
References: <20181008042523.4134-1-amir73il@gmail.com>
 <CAJfpegtGtYWbOvVZcobOO_d1OO6GhYEqE=u3OCEG2Cbsm34Eqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtGtYWbOvVZcobOO_d1OO6GhYEqE=u3OCEG2Cbsm34Eqw@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 25, 2018 at 02:44:15PM +0200, Miklos Szeredi wrote:

[..]
> > -static struct dentry *ovl_get_tmpfile(struct ovl_copy_up_ctx *c)
> > +static struct dentry *ovl_get_workdir_temp(struct ovl_copy_up_ctx *c)
> >  {
> >         int err;
> >         struct dentry *temp;
> > @@ -484,10 +510,32 @@ static struct dentry *ovl_get_tmpfile(struct ovl_copy_up_ctx *c)
> >         if (new_creds)
> >                 old_creds = override_creds(new_creds);
> >
> > -       if (c->tmpfile)
> > -               temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
> > -       else
> > -               temp = ovl_create_temp(c->workdir, &cattr);
> > +       temp = ovl_create_temp(c->workdir, &cattr);
> > +out:
> > +       if (new_creds) {
> > +               revert_creds(old_creds);
> 
> Not new in this patch, but it looks like this will Oops if old_creds
> is NULL, which happens if security_inode_copy_up() returns an error.
> 

If security_inode_copy_up() fails, then new_creds will be null too. And
in that case we will never call revert_creds(old_creds)?

IOW, new_creds should be returned by security_inode_copy_up() only if
it succeeds. Otherwise new_creds should be left untouched by hook.

> Trivial to fix, but I'm not sure we need the put_cred(new_creds) in
> the failed security_inode_copy_up() case.  Vivek, do you remember the
> reason for this error cleanup?

Same, In case of failure, new_creds should be NULL and we will never
call put_cred(new_creds).

So I can't see the bug. What am I missing?

Thanks
Vivek
