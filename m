MIME-Version: 1.0
In-Reply-To: <20181008042523.4134-1-amir73il@gmail.com>
References: <20181008042523.4134-1-amir73il@gmail.com>
Date: Thu, 25 Oct 2018 14:44:15 +0200
Message-ID: <CAJfpegtGtYWbOvVZcobOO_d1OO6GhYEqE=u3OCEG2Cbsm34Eqw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: untangle copy up call chain
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

[Cc Vivek for a question inline]

On Mon, Oct 8, 2018 at 6:25 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> In an attempt to dedup ~100 LOC, we ended up creating a tangled call
> chain, whose branches merge and diverge in several points according to
> the immutable c->tmpfile copy up mode.
>
> This call chain was hard to analyse for locking correctness because the
> locking requirements for the c->tmpfile flow were very different from
> the locking requirements for the !c->tmpfile flow (i.e. directory vs.
> regulare file copy up).
>
> Split the copy up helpers of the c->tmpfile flow from those of the
> !c->tmpfile (i.e. workdir) flow and remove the c->tmpfile mode from
> copy up context.
>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> I've managed to mess up error handling in 3 out of 6 helpers in v1.
> Better take a close look that I did not miss more...
>
> Thanks,
> Amir.
>
>  fs/overlayfs/copy_up.c | 155 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 114 insertions(+), 41 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 1cc797a08a5b..78a5049f7a5a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -395,7 +395,6 @@ struct ovl_copy_up_ctx {
>         struct dentry *destdir;
>         struct qstr destname;
>         struct dentry *workdir;
> -       bool tmpfile;
>         bool origin;
>         bool indexed;
>         bool metacopy;
> @@ -440,8 +439,14 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
>         return err;
>  }
>
> -static int ovl_install_temp(struct ovl_copy_up_ctx *c, struct dentry *temp,
> -                           struct dentry **newdentry)
> +/*
> + * Move temp file from workdir into place on upper dir.
> + * Used when copying up directories and when upper fs doesn't support O_TMPFILE.
> + *
> + * Caller must hold ovl_lock_rename_workdir().
> + */
> +static int ovl_rename_temp(struct ovl_copy_up_ctx *c, struct dentry *temp,
> +                          struct dentry **newdentry)
>  {
>         int err;
>         struct dentry *upper;
> @@ -451,19 +456,40 @@ static int ovl_install_temp(struct ovl_copy_up_ctx *c, struct dentry *temp,
>         if (IS_ERR(upper))
>                 return PTR_ERR(upper);
>
> -       if (c->tmpfile)
> -               err = ovl_do_link(temp, udir, upper);
> -       else
> -               err = ovl_do_rename(d_inode(c->workdir), temp, udir, upper, 0);
> +       err = ovl_do_rename(d_inode(c->workdir), temp, udir, upper, 0);
> +       if (!err)
> +               *newdentry = dget(temp);
> +       dput(upper);
>
> +       return err;
> +}
> +
> +/* Link O_TMPFILE into place on upper dir */
> +static int ovl_link_tmpfile(struct ovl_copy_up_ctx *c, struct dentry *temp,
> +                           struct dentry **newdentry)
> +{
> +       int err;
> +       struct dentry *upper = NULL;
> +       struct inode *udir = d_inode(c->destdir);
> +
> +       inode_lock_nested(udir, I_MUTEX_PARENT);
> +
> +       upper = lookup_one_len(c->destname.name, c->destdir, c->destname.len);
> +       err = PTR_ERR(upper);
> +       if (IS_ERR(upper))
> +               goto out;
> +
> +       err = ovl_do_link(temp, udir, upper);
>         if (!err)
> -               *newdentry = dget(c->tmpfile ? upper : temp);
> +               *newdentry = dget(upper);
>         dput(upper);
>
> +out:
> +       inode_unlock(udir);
>         return err;
>  }
>
> -static struct dentry *ovl_get_tmpfile(struct ovl_copy_up_ctx *c)
> +static struct dentry *ovl_get_workdir_temp(struct ovl_copy_up_ctx *c)
>  {
>         int err;
>         struct dentry *temp;
> @@ -484,10 +510,32 @@ static struct dentry *ovl_get_tmpfile(struct ovl_copy_up_ctx *c)
>         if (new_creds)
>                 old_creds = override_creds(new_creds);
>
> -       if (c->tmpfile)
> -               temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
> -       else
> -               temp = ovl_create_temp(c->workdir, &cattr);
> +       temp = ovl_create_temp(c->workdir, &cattr);
> +out:
> +       if (new_creds) {
> +               revert_creds(old_creds);

Not new in this patch, but it looks like this will Oops if old_creds
is NULL, which happens if security_inode_copy_up() returns an error.

Trivial to fix, but I'm not sure we need the put_cred(new_creds) in
the failed security_inode_copy_up() case.  Vivek, do you remember the
reason for this error cleanup?

> +               put_cred(new_creds);
> +       }
> +
> +       return temp;
> +}
> +
> +static struct dentry *ovl_get_tmpfile(struct ovl_copy_up_ctx *c)
> +{
> +       int err;
> +       struct dentry *temp;
> +       const struct cred *old_creds = NULL;
> +       struct cred *new_creds = NULL;
> +
> +       err = security_inode_copy_up(c->dentry, &new_creds);
> +       temp = ERR_PTR(err);
> +       if (err < 0)
> +               goto out;
> +
> +       if (new_creds)
> +               old_creds = override_creds(new_creds);
> +
> +       temp = ovl_do_tmpfile(c->destdir, c->stat.mode);

This changes c->workdir to c->destdir.   Shouldn't normally matter, but...

I changed this back, and we can discuss the merits of this change in
the context of a separate patch.

>  out:
>         if (new_creds) {
>                 revert_creds(old_creds);
> @@ -548,37 +596,39 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>         return err;
>  }
>
> -static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
> +/*
> + * Copyup using workdir to prepare temp file.
> + * Used when copying up directories and when upper fs doesn't support O_TMPFILE.
> + */
> +static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
>  {
> -       struct inode *udir = c->destdir->d_inode;
>         struct inode *inode;
>         struct dentry *newdentry = NULL;
>         struct dentry *temp;
>         int err;
>
> -       temp = ovl_get_tmpfile(c);
> +       err = ovl_lock_rename_workdir(c->workdir, c->destdir);
> +       if (err)
> +               return err;
> +
> +       temp = ovl_get_workdir_temp(c);
> +       err = PTR_ERR(temp);
>         if (IS_ERR(temp))
> -               return PTR_ERR(temp);
> +               goto out;
>
>         err = ovl_copy_up_inode(c, temp);
>         if (err)
> -               goto out;
> +               goto out_cleanup;
>
>         if (S_ISDIR(c->stat.mode) && c->indexed) {
>                 err = ovl_create_index(c->dentry, c->lowerpath.dentry, temp);
>                 if (err)
> -                       goto out;
> +                       goto out_cleanup;
>         }
>
> -       if (c->tmpfile) {
> -               inode_lock_nested(udir, I_MUTEX_PARENT);
> -               err = ovl_install_temp(c, temp, &newdentry);
> -               inode_unlock(udir);
> -       } else {
> -               err = ovl_install_temp(c, temp, &newdentry);
> -       }
> +       err = ovl_rename_temp(c, temp, &newdentry);
>         if (err)
> -               goto out;
> +               goto out_cleanup;
>
>         if (!c->metacopy)
>                 ovl_set_upperdata(d_inode(c->dentry));
> @@ -587,10 +637,41 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
>         if (S_ISDIR(inode->i_mode))
>                 ovl_set_flag(OVL_WHITEOUTS, inode);
>
> -out:
> -       if (err && !c->tmpfile)
> +out_cleanup:
> +       if (err)
>                 ovl_cleanup(d_inode(c->workdir), temp);

This is a bit awkward: ovl_cleanup() will be called IFF we'd jumped to
out_cleanup.  So I moved this error cleanup till after the return.

>         dput(temp);
> +out:
> +       unlock_rename(c->workdir, c->destdir);
> +       return err;
> +
> +}
> +
> +/* Copyup using O_TMPFILE which does not require cross dir locking */
> +static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
> +{
> +       struct dentry *newdentry = NULL;
> +       struct dentry *temp;
> +       int err;
> +
> +       temp = ovl_get_tmpfile(c);
> +       if (IS_ERR(temp))
> +               return PTR_ERR(temp);
> +
> +       err = ovl_copy_up_inode(c, temp);
> +       if (err)
> +               goto out;
> +
> +       err = ovl_link_tmpfile(c, temp, &newdentry);
> +       if (err)
> +               goto out;
> +
> +       if (!c->metacopy)
> +               ovl_set_upperdata(d_inode(c->dentry));
> +       ovl_inode_update(d_inode(c->dentry), newdentry);
> +
> +out:
> +       dput(temp);
>         return err;
>
>  }
> @@ -646,18 +727,10 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
>         }
>
>         /* Should we copyup with O_TMPFILE or with workdir? */
> -       if (S_ISREG(c->stat.mode) && ofs->tmpfile) {
> -               c->tmpfile = true;
> -               err = ovl_copy_up_locked(c);
> -       } else {
> -               err = ovl_lock_rename_workdir(c->workdir, c->destdir);
> -               if (!err) {
> -                       err = ovl_copy_up_locked(c);
> -                       unlock_rename(c->workdir, c->destdir);
> -               }
> -       }
> -
> -
> +       if (S_ISREG(c->stat.mode) && ofs->tmpfile)
> +               err = ovl_copy_up_tmpfile(c);
> +       else
> +               err = ovl_copy_up_workdir(c);
>         if (err)
>                 goto out;
>
> --
> 2.17.1
>
