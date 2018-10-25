Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181008042523.4134-1-amir73il@gmail.com> <CAJfpegtGtYWbOvVZcobOO_d1OO6GhYEqE=u3OCEG2Cbsm34Eqw@mail.gmail.com>
In-Reply-To: <CAJfpegtGtYWbOvVZcobOO_d1OO6GhYEqE=u3OCEG2Cbsm34Eqw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 25 Oct 2018 15:54:46 +0300
Message-ID: <CAOQ4uxiGamj54LXQBWjMQPWY5JUk3vYtNOToufN=Qaq+hruAiA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: untangle copy up call chain
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

> > +static struct dentry *ovl_get_tmpfile(struct ovl_copy_up_ctx *c)
> > +{
> > +       int err;
> > +       struct dentry *temp;
> > +       const struct cred *old_creds = NULL;
> > +       struct cred *new_creds = NULL;
> > +
> > +       err = security_inode_copy_up(c->dentry, &new_creds);
> > +       temp = ERR_PTR(err);
> > +       if (err < 0)
> > +               goto out;
> > +
> > +       if (new_creds)
> > +               old_creds = override_creds(new_creds);
> > +
> > +       temp = ovl_do_tmpfile(c->destdir, c->stat.mode);
>
> This changes c->workdir to c->destdir.   Shouldn't normally matter, but...
>
> I changed this back, and we can discuss the merits of this change in
> the context of a separate patch.
>

Indeed. I wrote about this change the cover of the first posting, but
it got lost
in cover of 2nd posting. I thought that using c->workdir was due to an oversight
I didn't realize that it had merits or that it mattered at all.
I don't mind either way.

Other changes sound good.

Thanks,
Amir.
