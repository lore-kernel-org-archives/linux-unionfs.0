From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Wed, 17 Jan 2018 14:20:54 +0200
Message-ID: <CAOQ4uxjyWUxo0EZw4jKD6JYMjm8ftZe29QHniS4rtS4uauni1Q@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-5-git-send-email-amir73il@gmail.com> <CAJfpeguk+KVWkLr8ihGE0c8aDgaNHfnjf3DcuUQi1g5KZHObOw@mail.gmail.com>
 <CAOQ4uxijgqiAjKysA-HZFLa+b2nETMhq9aW8rjv=hwCq1B8tfw@mail.gmail.com>
 <CAJfpegvCVX-YEMRDfKTYM2Au=2bNT3RcX=uNyt9KO1EmBJOvuA@mail.gmail.com> <CAOQ4uxggufAEqD2WhReTax9eyEzJQdpdb7E=+zrgcYz1CQVY=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:35976 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbeAQMUz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jan 2018 07:20:55 -0500
In-Reply-To: <CAOQ4uxggufAEqD2WhReTax9eyEzJQdpdb7E=+zrgcYz1CQVY=Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jan 17, 2018 at 1:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Jan 15, 2018 at 4:56 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
> [...]
>> >>
>> >> So, a working algorithm would be going up to the first connected
>> >> parent or root, lock parent, lookup name and restart.  Not guaranteed
>> >> to finish, since not protected against always racing with renames.
>> >> Can we take s_vfs_rename_sem on ovl to prevent that?
>> >>
>> >
>> > Sounds like a simple and good enough solution.
>> > Do we really need the locking of parent and restart connect if
>> > we take s_vfs_rename_sem around ovl_lookup_real()?
>>
>> No, but s_vfs_rename_sem is a really heavyweight solution, we should
>> do better than that for decoding a file handle.
>>
>> And we probably don't need anything else, since rename on ancestor
>> means renamed dir is connected, and hopefully not evicted from the
>> cache until we repeat the walk up.
>>
>> So need to lock parent, lookup ovl dentry, verify we got the same
>> upper, if not retry icache lookup.
>>
>> Not sure we need to worry about that "hopefully".  Hopefully not.
>>
>
> Something like this??
>
> This is just the raw fix to patch 4/17 without the icache lookup
> that is added by later patches.
>
> I added rename_lock seqlock around backwalk to connected ancestor
> and take_dentry_name_snapshot() for the stability of real name
> during overlay lookup.
>
> I considered also storing OVL_I(d_inode(connected))->version
> inside seqlock and comparing it to version in case lookup of child
> failed. This could help us distinguish between overlay rename and
> underlying rename (overlay dir version did not change) and return
> ESTALE instead of restarting lookup in the latter case.
> Wasn't sure if that was a good idea and what we loose if we leave it out.

Well, if nothing else, it's a good idea for preventing endless loop
due to bugs...
adding some snippets below.

>
> I tested this code, but only with upper file handles of course
> (xfstest generic/467).
>
> Please let me know what you think.
>
> Thanks,
> Amir.
>
> ================================================================
>
> From 337543c3fcdf9323d3720d17ab6fc13e287bbec1 Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il@gmail.com>
> Date: Thu, 28 Dec 2017 18:36:16 +0200
> Subject: [PATCH v3 4/17] ovl: decode connected upper dir file handles
>
> Until this change, we decoded upper file handles by instantiating an
> overlay dentry from the real upper dentry. This is sufficient to handle
> pure upper files, but insufficient to handle merge/impure dirs.
>
> To that end, if decoded real upper dir is connected and hashed, we
> lookup an overlay dentry with the same path as the real upper dir.
> If decoded real upper is non-dir, we instantiate a disconnected overlay
> dentry as before this change.
>
> Because ovl_fh_to_dentry() returns a connected overlay dir dentry,
> exportfs never needs to call get_parent() and get_name() to reconnect an
> upper overlay dir. Because connectable non-dir file handles are not
> supported, exportfs will not be able to use fh_to_parent() and get_name()
> methods to reconnect a disconnected non-dir to its parent. Therefore, the
> methods get_parent() and get_name() are implemented just to print out a
> sanity warning and the method fh_to_parent() is implemented to warn the
> user that using the 'subtree_check' exportfs option is not supported.
>
> An alternative approach could have been to implement instantiating of
> an overlay directory inode from origin/index and implement get_parent()
> and get_name() by calling into underlying fs operations and them
> instantiating the overlay parent dir.
>
> The reasons for not choosing the get_parent() approach were:
> - Obtaining a disconnected overlay dir dentry would requires a
>   delicate re-factoring of ovl_lookup() to get a dentry with overlay
>   parent info. It was preferred to avoid doing that re-factoring unless
>   it was proven worthy.
> - Going down the path of disconnected dir would mean that the (non
>   trivial) code path of d_splice_alias() could be traveled and that
>   meant writing more tests and introduces race cases that are very hard
>   to hit on purpose. Taking the path of connecting overlay dentry by
>   forward lookup is therefore the safe and boring way to avoid surprises.
>
> The culprit of the chosen "connected overlay dentry" approach:
> - We need to take special care to rename of ancestors while connecting
>   the overlay dentry by real dentry path. These subtleties are usually
>   handled by generic exportfs and VFS code.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/export.c | 215 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 214 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 557c29928e98..35f37a72d55e 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -130,6 +130,188 @@ static struct dentry *ovl_obtain_alias(struct
> super_block *sb,
>         return dentry;
>  }
>
> +/*
> + * Lookup a child overlay dentry whose real dentry is @real.
> + * If @real is on upper layer, we lookup a child overlay dentry with the same
> + * name as the real dentry. Otherwise, we need to consult index for lookup.
> + */
> +static struct dentry *ovl_lookup_real_one(struct dentry *parent, u64 ver,
> +                                         struct dentry *real,
> +                                         struct ovl_layer *layer)
> +{
> +       struct dentry *this;
> +       struct name_snapshot name;
> +       int err;
> +
> +       /* TODO: use index when looking up by lower real dentry */
> +       if (layer->idx)
> +               return ERR_PTR(-EACCES);
> +
> +       /*
> +        * Lookup overlay dentry by real name. The parent mutex protects us
> +        * from racing with overlay rename. If the overlay dentry that is
> +        * above real has already been moved to a different parent, then this
> +        * lookup will fail to find a child dentry whose real dentry is @real
> +        * and we will have to restart the lookup of real path from the top.
> +        *
> +        * We also need to take a snapshot of real dentry name to protect us
> +        * from racing with underlying layer rename. In this case, we don't
> +        * care about returning ESTALE, only from referencing a free name
> +        * pointer.
> +        *
> +        * TODO: try to lookup the renamed overlay dentry in inode cache by
> +        *       real inode.
> +        */
> +       inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);

+       err = -ECHILD;
+       if (ovl_dentry_version_get(parent) != ver)
+               goto fail;
+

> +       take_dentry_name_snapshot(&name, real);
> +       this = lookup_one_len(name.name, parent, strlen(name.name));
> +       err = PTR_ERR(this);
> +       if (IS_ERR(this)) {
> +               goto fail;
> +       } else if (!this || !this->d_inode) {
> +               dput(this);
> +               err = -ENOENT;
> +               goto fail;
> +       } else if (ovl_dentry_upper(this) != real) {
> +               dput(this);
> +               err = -ESTALE;
> +               goto fail;
> +       }
> +
> +out:
> +       release_dentry_name_snapshot(&name);
> +       inode_unlock(d_inode(parent));
> +       return this;
> +
> +fail:
> +       pr_warn_ratelimited("overlayfs: failed to lookup one by real
> (%pd2, layer=%d, parent=%pd2, err=%i)\n",
> +                           real, layer->idx, parent, err);
> +       this = ERR_PTR(err);
> +       goto out;
> +}
> +
> +/*
> + * Lookup an overlay dentry whose real dentry is @real.
> + * If @real is on upper layer, we lookup a child overlay dentry with the same
> + * path the real dentry. Otherwise, we need to consult index for lookup.
> + */
> +static struct dentry *ovl_lookup_real(struct super_block *sb,
> +                                     struct dentry *real,
> +                                     struct ovl_layer *layer)
> +{
> +       struct dentry *connected;
> +       unsigned int seq;
> +       int err = 0;
> +
> +       /* TODO: use index when looking up by lower real dentry */
> +       if (layer->idx)
> +               return ERR_PTR(-EACCES);
> +
> +       connected = dget(sb->s_root);
> +       while (!err) {
> +               struct dentry *next, *this;
> +               struct dentry *parent = NULL;
> +               struct dentry *real_connected = layer->mnt->mnt_root;

That's a bug. 'real_connected' should be forwarded to real dentry of
'connected'. A later patch implements ovl_dentry_real_at().

+               struct dentry *real_connected = ovl_dentry_upper(connected);

> +
> +               if (real_connected == real)
> +                       break;
> +
> +               /*
> +                * Find the topmost dentry not yet connected. Taking rename_lock
> +                * so at least we don't race with rename when walking back to
> +                * 'real_connected'.
> +                */
> +               seq = read_seqbegin(&rename_lock);

+               inode_lock(d_inode(connected));
+               ver = ovl_dentry_version_get(connected);
+               inode_unlock(d_inode(connected));

> +               next = dget(real);
> +               for (;;) {
> +                       parent = dget_parent(next);
> +
> +                       if (real_connected == parent)
> +                               break;
> +
> +                       /*
> +                        * If real file has been moved out of the layer root
> +                        * directory, we will eventully hit the real fs root.
> +                        */
> +                       if (parent == next) {
> +                               err = -EXDEV;
> +                               break;
> +                       }
> +
> +                       dput(next);
> +                       next = parent;
> +               }
> +
> +               if (!read_seqretry(&rename_lock, seq) && !err) {
> +                       this = ovl_lookup_real_one(connected, ver, next, layer);
> +                       /*
> +                        * Lookup of child in overlay can fail when racing with
> +                        * overlay rename of child away from 'connected' parent.
> +                        * In this case, we need to restart the lookup from the
> +                        * top, because we cannot trust that 'real_connected' is
> +                        * still an ancestor of 'real'.
> +                        */
> +                       if (IS_ERR(this)) {
> +                               err = PTR_ERR(this);
> +                               if (err == -ECHILD) {
> +                                       this = dget(sb->s_root);
> +                                       err = 0;
> +                               }
> +                       }
> +                       if (!err) {
> +                               dput(connected);
> +                               connected = this;
> +                       }
> +               }
> +
> +               dput(parent);
> +               dput(next);
> +       }
> +
> +       if (err)
> +               goto fail;
> +
> +       return connected;
> +
> +fail:
> +       pr_warn_ratelimited("overlayfs: failed to lookup by real
> (%pd2, layer=%d, connected=%pd2, err=%i)\n",
> +                           real, layer->idx, connected, err);
> +       dput(connected);
> +       return ERR_PTR(err);
> +}
> +
> +
> +/*
> + * Get an overlay dentry from upper/lower real dentries.
> + */
> +static struct dentry *ovl_get_dentry(struct super_block *sb,
> +                                    struct dentry *upper,
> +                                    struct ovl_path *lowerpath)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +       struct ovl_layer layer = { .mnt = ofs->upper_mnt };
> +
> +       /* TODO: get non-upper dentry */
> +       if (!upper)
> +               return ERR_PTR(-EACCES);
> +
> +       /*
> +        * Obtain a disconnected overlay dentry from a non-dir real upper
> +        * dentry.
> +        */
> +       if (!d_is_dir(upper))
> +               return ovl_obtain_alias(sb, upper, NULL);
> +
> +       /* Removed empty directory? */
> +       if ((upper->d_flags & DCACHE_DISCONNECTED) || d_unhashed(upper))
> +               return ERR_PTR(-ENOENT);
> +
> +       /*
> +        * If real upper dentry is connected and hashed, get a connected
> +        * overlay dentry with the same path as the real upper dentry.
> +        */
> +       return ovl_lookup_real(sb, upper, &layer);
> +}
> +
>  static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
>                                         struct ovl_fh *fh)
>  {
> @@ -144,7 +326,7 @@ static struct dentry *ovl_upper_fh_to_d(struct
> super_block *sb,
>         if (IS_ERR_OR_NULL(upper))
>                 return upper;
>
> -       dentry = ovl_obtain_alias(sb, upper, NULL);
> +       dentry = ovl_get_dentry(sb, upper, NULL);
>         dput(upper);
>
>         return dentry;
> @@ -183,7 +365,38 @@ static struct dentry *ovl_fh_to_dentry(struct
> super_block *sb, struct fid *fid,
>         return ERR_PTR(err);
>  }
>
> +static struct dentry *ovl_fh_to_parent(struct super_block *sb, struct fid *fid,
> +                                      int fh_len, int fh_type)
> +{
> +       pr_warn_ratelimited("overlayfs: connectable file handles not
> supported; use 'no_subtree_check' exportfs option.\n");
> +       return ERR_PTR(-EACCES);
> +}
> +
> +static int ovl_get_name(struct dentry *parent, char *name,
> +                       struct dentry *child)
> +{
> +       /*
> +        * ovl_fh_to_dentry() returns connected dir overlay dentries and
> +        * ovl_fh_to_parent() is not implemented, so we should not get here.
> +        */
> +       WARN_ON_ONCE(1);
> +       return -EIO;
> +}
> +
> +static struct dentry *ovl_get_parent(struct dentry *dentry)
> +{
> +       /*
> +        * ovl_fh_to_dentry() returns connected dir overlay dentries, so we
> +        * should not get here.
> +        */
> +       WARN_ON_ONCE(1);
> +       return ERR_PTR(-EIO);
> +}
> +
>  const struct export_operations ovl_export_operations = {
>         .encode_fh      = ovl_encode_inode_fh,
>         .fh_to_dentry   = ovl_fh_to_dentry,
> +       .fh_to_parent   = ovl_fh_to_parent,
> +       .get_name       = ovl_get_name,
> +       .get_parent     = ovl_get_parent,
>  };
> --
> 2.7.4
