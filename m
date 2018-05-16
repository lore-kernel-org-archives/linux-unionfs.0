MIME-Version: 1.0
In-Reply-To: <1526379972-20923-4-git-send-email-amir73il@gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
	<1526379972-20923-4-git-send-email-amir73il@gmail.com>
Date: Wed, 16 May 2018 12:41:16 +0200
Message-ID: <CAJfpegsP-GrgenqRcc9-YrHHxWrtq1ApswD=FimUid4-8hXhBg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: create helper ovl_create_temp()
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 15, 2018 at 12:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Al Viro suggested to simplify callers of ovl_create_real() by
> returning the created dentry (or ERR_PTR) from ovl_create_real().
> This is a spin off of his suggestion, which is cleaner in my opinion.
>
> Also created a wrapper ovl_create_temp_dir() and used it in
> ovl_create_index() instead of calling ovl_do_mkdir(), so now all callers
> of ovl_do_mkdir() are routed through ovl_create_real(), which paves the
> way for Al's fix for non-hashed result from vfs_mkdir().
>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c   | 27 +++++++--------------------
>  fs/overlayfs/dir.c       | 47 +++++++++++++++++++++++++++++------------------
>  fs/overlayfs/overlayfs.h |  9 ++++++++-
>  3 files changed, 44 insertions(+), 39 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 8bede0742619..4ba16cbeaec2 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -365,14 +365,10 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
>         if (err)
>                 return err;
>
> -       temp = ovl_lookup_temp(indexdir);
> +       temp = ovl_create_temp_dir(indexdir);

#define OVL_DIR_CATTR(m) (&(struct cattr) { .mode = S_IFDIR | (m) })
        temp = ovl_create_temp(indexdir, OVL_DIR_CATTR(0), NULL);

>         if (IS_ERR(temp))
>                 goto temp_err;
>
> -       err = ovl_do_mkdir(dir, temp, S_IFDIR, true);
> -       if (err)
> -               goto out;
> -
>         err = ovl_set_upper_fh(upper, temp);
>         if (err)
>                 goto out_cleanup;
> @@ -501,22 +497,13 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
>         if (new_creds)
>                 old_creds = override_creds(new_creds);
>
> -       if (c->tmpfile) {
> +       if (c->tmpfile)
>                 temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
> -               if (IS_ERR(temp))
> -                       goto temp_err;
> -       } else {
> -               temp = ovl_lookup_temp(c->workdir);
> -               if (IS_ERR(temp))
> -                       goto temp_err;
> -
> -               err = ovl_create_real(d_inode(c->workdir), temp, &cattr,
> -                                     NULL, true);
> -               if (err) {
> -                       dput(temp);
> -                       goto out;
> -               }
> -       }
> +       else
> +               temp = ovl_create_temp(c->workdir, &cattr, NULL);
> +       if (IS_ERR(temp))
> +               goto temp_err;
> +
>         err = 0;
>         *tempp = temp;
>  out:
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 25b339278684..45f5f9232e71 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -160,6 +160,26 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
>         return err;
>  }
>
> +struct dentry *ovl_create_temp(struct dentry *workdir, struct cattr *attr,
> +                              struct dentry *hardlink)

Talking of cleanups, can we put hardlink into cattr as well?  (separate patch)

> +{
> +       struct inode *wdir = workdir->d_inode;
> +       struct dentry *temp;
> +       int err;
> +
> +       temp = ovl_lookup_temp(workdir);
> +       if (IS_ERR(temp))
> +               return temp;

What's wrong with viro's version of  dentry in ovl_create_real()?
Turns this whole function into:

        return ovl_create_real(d_inode(workdir),
ovl_lookup_temp(workdir), attr, hardlink, true);

> +
> +       err = ovl_create_real(wdir, temp, attr, hardlink, true);
> +       if (err) {
> +               dput(temp);
> +               return ERR_PTR(err);
> +       }
> +
> +       return temp;
> +}
> +
>  static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
>                                int xerr)
>  {
> @@ -292,15 +312,11 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
>         if (upper->d_parent->d_inode != udir)
>                 goto out_unlock;
>
> -       opaquedir = ovl_lookup_temp(workdir);
> +       opaquedir = ovl_create_temp_dir(workdir);

Where has the mode gone?

>         err = PTR_ERR(opaquedir);
>         if (IS_ERR(opaquedir))
> -               goto out_unlock;
> -
> -       err = ovl_create_real(wdir, opaquedir,
> -                             &(struct cattr){.mode = stat.mode}, NULL, true);
>         if (err)
> -               goto out_dput;
> +               goto out_unlock;
>
>         err = ovl_copy_xattr(upper, opaquedir);
>         if (err)
> @@ -331,7 +347,6 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
>
>  out_cleanup:
>         ovl_cleanup(wdir, opaquedir);
> -out_dput:
>         dput(opaquedir);
>  out_unlock:
>         unlock_rename(workdir, upperdir);
> @@ -392,20 +407,16 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
>         if (err)
>                 goto out;
>
> -       newdentry = ovl_lookup_temp(workdir);
> -       err = PTR_ERR(newdentry);
> -       if (IS_ERR(newdentry))
> -               goto out_unlock;
> -
>         upper = lookup_one_len(dentry->d_name.name, upperdir,
>                                dentry->d_name.len);
>         err = PTR_ERR(upper);
>         if (IS_ERR(upper))
> -               goto out_dput;
> +               goto out_unlock;
>
> -       err = ovl_create_real(wdir, newdentry, cattr, hardlink, true);
> -       if (err)
> -               goto out_dput2;
> +       newdentry = ovl_create_temp(workdir, cattr, hardlink);
> +       err = PTR_ERR(newdentry);
> +       if (IS_ERR(newdentry))
> +               goto out_dput;
>
>         /*
>          * mode could have been mutilated due to umask (e.g. sgid directory)
> @@ -454,9 +465,9 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
>         err = ovl_instantiate(dentry, inode, newdentry, !!hardlink);
>         newdentry = NULL;
>  out_dput2:
> -       dput(upper);
> -out_dput:
>         dput(newdentry);
> +out_dput:
> +       dput(upper);
>  out_unlock:
>         unlock_rename(workdir, upperdir);
>  out:
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 642b25702092..967183175ef5 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -369,6 +369,7 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
>
>  /* dir.c */
>  extern const struct inode_operations ovl_dir_inode_operations;
> +int ovl_cleanup(struct inode *dir, struct dentry *dentry);
>  struct dentry *ovl_lookup_temp(struct dentry *workdir);
>  int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
>                              struct dentry *dentry);
> @@ -380,7 +381,13 @@ struct cattr {
>  int ovl_create_real(struct inode *dir, struct dentry *newdentry,
>                     struct cattr *attr,
>                     struct dentry *hardlink, bool debug);
> -int ovl_cleanup(struct inode *dir, struct dentry *dentry);
> +struct dentry *ovl_create_temp(struct dentry *workdir, struct cattr *attr,
> +                              struct dentry *hardlink);
> +
> +static inline struct dentry *ovl_create_temp_dir(struct dentry *workdir)
> +{
> +       return ovl_create_temp(workdir, &(struct cattr){.mode = S_IFDIR}, NULL);
> +}
>
>  /* file.c */
>  extern const struct file_operations ovl_file_operations;
> --
> 2.7.4
>
