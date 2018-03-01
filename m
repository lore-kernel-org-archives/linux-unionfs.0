Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180301064526.17216-1-houtao1@huawei.com>
References: <20180301064526.17216-1-houtao1@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Mar 2018 14:10:45 +0200
Message-ID: <CAOQ4uxj0SAyJUAaGOvAhp_iOzo3-51ntQzeivDvoKfjDefjvVg@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] overlay: hardlink all whiteout files into a
 single one
Content-Type: text/plain; charset="UTF-8"
To: Hou Tao <houtao1@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 1, 2018 at 8:45 AM, Hou Tao <houtao1@huawei.com> wrote:
> Now each whiteout file will be assigned a new inode. To reduce the
> overhead of allocating and freeing inodes in upper fs, creating a
> singleton whiteout file under workdir and hardlink all whiteout files
> into it.
>
> The effect is obvious: under a KVM VM, the time used for removing the
> linux kernel source tree is reduced from 17s to 10s.
>
> Got the idea from aufs4.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
> v3:
>     * rebased on 4.16-rc3
>     * add a limitation on the hardlinks of singleton whiteout, and it
>       can be adjusted by module param singleton_wt_link_max. During
>       the mount procoess, if the value of limit is less than or equal to 1,
>       the singleon whiteout will be disabled (suggested by Amir)
>     * rename ovl_make_singleton_whiteout_nolock() to
>       ovl_make_singleton_whiteout_locked() (also from Amir)
>     * check errors more strictly: treat singleton whiteout creation
>       failure as an error and abort the mount or unlink procedure
>     * remove unnecessary mnt_want_write() from ovl_make_singleton_whiteout(),
>       because mnt_want_write() has been invoked by its caller.
>     * document the lock assertions for newly-added helpers
> v2:
>     * address the comments from Miklos and Amir: handle -EMLINK and -EXDEV
>       when hard-linking whiteout file to the singleton
>
>     * move the singleton whiteout from workbasedir to workdir to simplify
>       the lock of inodes
> v1:
>     * https://www.spinics.net/lists/linux-unionfs/msg04023.html
> ---
>  fs/overlayfs/dir.c       | 150 +++++++++++++++++++++++++++++++++++++++++++++--
>  fs/overlayfs/overlayfs.h |   5 +-
>  fs/overlayfs/ovl_entry.h |   5 ++
>  fs/overlayfs/readdir.c   |   2 +-
>  fs/overlayfs/super.c     |   5 ++
>  fs/overlayfs/util.c      |   4 +-
>  6 files changed, 161 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 839709c7803a..c87360d22f92 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -24,6 +24,12 @@ module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
>  MODULE_PARM_DESC(ovl_redirect_max,
>                  "Maximum length of absolute redirect xattr value");
>
> +static unsigned int ovl_singleton_wt_link_max = 255;
> +module_param_named(singleton_whiteout_link_max,
> +               ovl_singleton_wt_link_max, uint, 0644);
> +MODULE_PARM_DESC(ovl_singleton_wt_link_max,
> +               "Maximum hardlinks of a whiteout singleton");
> +
>  int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
>  {
>         int err;
> @@ -62,18 +68,149 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
>         return temp;
>  }
>
> +#define OVL_SINGLETON_WHITEOUT_NAME "whiteout"
> +
> +/* caller holds write lock (i_rwsem) of dir */
> +static int ovl_make_singleton_whiteout_locked(struct ovl_fs *ofs,
> +               struct dentry *dir, const char *name)
> +{
> +       int err = 0;
> +       struct inode *inode = d_inode(dir);
> +       struct dentry *whiteout;
> +
> +       whiteout = lookup_one_len(name, dir, strlen(name));
> +       if (IS_ERR(whiteout))
> +               return PTR_ERR(whiteout);
> +
> +       if (ovl_is_whiteout(whiteout)) {
> +               ofs->whiteout = whiteout;
> +       } else if (!whiteout->d_inode) {
> +               err = ovl_do_whiteout(inode, whiteout);
> +               if (!err)
> +                       ofs->whiteout = whiteout;
> +               else
> +                       dput(whiteout);
> +       } else {
> +               /*
> +                * fallback to creating new whiteout file if
> +                * a non-whiteout file already exists
> +                */
> +               dput(whiteout);
> +       }
> +
> +       return err;
> +}
> +
> +/*
> + * create a new whiteout file under workdir if it doesn't exist.
> + * If a non-whiteout file already exists, no error will be reported
> + * and the needed whiteout file will be newly created instead of
> + * being linked to a singleton whiteout.
> + */
> +int ovl_make_singleton_whiteout(struct ovl_fs *ofs)
> +{
> +       int err;
> +       struct inode *dir;
> +
> +       /* disable singleton whiteout */
> +       if (ovl_singleton_wt_link_max <= 1)
> +               return 0;
> +
> +       dir = d_inode(ofs->workdir);
> +       inode_lock_nested(dir, I_MUTEX_PARENT);
> +
> +       err = ovl_make_singleton_whiteout_locked(ofs, ofs->workdir,
> +                       OVL_SINGLETON_WHITEOUT_NAME);
> +
> +       inode_unlock(dir);
> +
> +       return err;
> +}
> +
> +/*
> + * caller holds i_mutex of workdir to ensure the operations
> + * on the singletion whiteout are serialized.
> + */
> +static int ovl_link_to_singleton_whiteout(struct ovl_fs *ofs,
> +               struct dentry *whiteout, bool *create_instead)
> +{
> +       int err;
> +       struct inode *wdir = d_inode(ofs->workdir);
> +       struct dentry *singleton;
> +       bool retried = false;
> +
> +       *create_instead = false;
> +retry:
> +       singleton = ofs->whiteout;
> +       /* Create a new singletion whiteout when the limit is exceeded */
> +       if (1 < ovl_singleton_wt_link_max &&

It's hard for me to look at this Java style where constant comes first...

> +               singleton->d_inode->i_nlink >= ovl_singleton_wt_link_max)
> +               err = -EMLINK;
> +       else
> +               err = ovl_do_link(singleton, wdir, whiteout, false);
> +
> +       if (!err) {
> +               goto out;
> +       } else if (err == -EMLINK && !retried) {
> +               /*
> +                * The singleton already has the maximum number of links to it,
> +                * so remove the old singleton and create a new one
> +                */
> +               ofs->whiteout = NULL;
> +               err = ovl_do_unlink(wdir, singleton);
> +               if (err) {
> +                       dput(singleton);
> +                       goto out;
> +               }
> +
> +               dput(singleton);
> +               err = ovl_make_singleton_whiteout_locked(ofs, ofs->workdir,
> +                               OVL_SINGLETON_WHITEOUT_NAME);
> +               if (err)
> +                       goto out;
> +
> +               retried = true;
> +               if (ofs->whiteout)
> +                       goto retry;
> +               else
> +                       goto out_fallback;
> +       } else if (err == -EXDEV) {
> +               /*
> +                * upper fs may have a project id different than singleton,
> +                * so fall back to create whiteout directly
> +                */

I know I pointed out the EXDEV case, but would also like to point out that
if link fails to different proj id, so will rename, so maybe we can fail the
whiteout already.

> +               goto out_fallback;
> +       } else {
> +               goto out;
> +       }
> +
> +out_fallback:
> +       *create_instead = true;
> +out:
> +       return err;


You don't really need those labels.
You get return err instead of goto out
and you can *create_instead = true instead of goto out_fallback
If you ask me, I would return 1 for create_instead and avoid the
create_instead argument altogether.


> +}
> +
>  /* caller holds i_mutex on workdir */
> -static struct dentry *ovl_whiteout(struct dentry *workdir)
> +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *workdir)
>  {
>         int err;
>         struct dentry *whiteout;
>         struct inode *wdir = workdir->d_inode;
> +       bool create_instead;
>
>         whiteout = ovl_lookup_temp(workdir);
>         if (IS_ERR(whiteout))
>                 return whiteout;
>
> -       err = ovl_do_whiteout(wdir, whiteout);
> +       if (workdir == ofs->workdir && ofs->whiteout)

That's a damn shame, because for rm -rf of a large lower tree,
the whiteouts from upper dir will be removed anyway, but the
whiteouts from index dir with nfs_export=on will stay forever
(or until we figure out the best way to clean them), so deduplicating
the whiteouts in index dir will be most beneficial.

The reason I am not objecting to merge of singleton whiteout as is
is because the right way to implement singleton whiteout for
index dir would be to use the index dir as the work dir, as Miklos
suggested (i.e. ofs->workdir == ofs->indexdir), so there will
always be only one directory where whiteouts are created.

> +               err = ovl_link_to_singleton_whiteout(ofs, whiteout,
> +                               &create_instead);

A construct of if else without {} should be limited to one line.
You will avoid that problem if you drop create_instead arg.

> +       else
> +               create_instead = true;
> +
> +       if (create_instead)

That could be if (err > 0) if you follow my suggestion

> +               err = ovl_do_whiteout(wdir, whiteout);
> +

Thanks,
Amir.
