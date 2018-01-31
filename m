From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH] ovl: check lower ancestry on encode of lower dir
 file handle
Date: Wed, 31 Jan 2018 13:14:19 +0200
Message-ID: <CAOQ4uxgBnE1ftHz8uxYdByxMFZ+JuYfpZP+11oh6X3JYKj5Ehw@mail.gmail.com>
References: <1517348026-13629-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34560 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752618AbeAaLOU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 06:14:20 -0500
Received: by mail-yw0-f175.google.com with SMTP id t201so7202827ywf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 03:14:20 -0800 (PST)
In-Reply-To: <1517348026-13629-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 30, 2018 at 11:33 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> This change relaxes copy up on encode of merge dir with lower layer > 1
> and handles the case of encoding a merge dir with lower layer 1, where an
> ancestor is a non-indexed merge dir. In that case, decode of the lower
> file handle will not have been possible if the non-indexed ancestor is
> redirected before or after encode.
>
> Before encoding a non-upper directory file handle from real layer N, we
> need to check if it will be possible to reconnect an overlay dentry from
> the real lower decoded dentry. This is done by following the overlay
> ancestry up to a 'layer N connected' ancestor and verifying that all
> parents along the way are 'layer N connectable'. If an ancestor that is
> NOT 'layer N connectable' is found, we need to copy up an ancestor, which
> is 'layer N connectable', thus making that ancestor 'layer N connected'.
> For example:
>
>  layer 1: /a
>  layer 2: /a/b/c
>
> The overlay dentry /a is NOT 'layer 2 connectable', because if dir /a is
> copied up and renamed, upper dir /a will be indexed by lower dir /a from
> layer 1. The dir /a from layer 2 will never be indexed, so the alrogithm
> in ovl_lookup_real_ancestor() (*) will not be able to lookup a connected
> overlay dentry from the connected lower dentry /a/b/c.
>
> To avoid this problem on decode time, we need to copy up an ancestor of
> /a/b/c, which is 'layer 2 connectable', on encode time. That ancestor is
> /a/b. After copy up (and index) of /a/b, it will become 'layer 2 connected'
> and when the time comes to decode the file handle from lower dentry /a/b/c,
> ovl_lookup_real_ancestor() will find the indexed ancestor /a/b and decoding
> a connected overlay dentry will be accomplished.
>
> (*) the alrogithm in ovl_lookup_real_ancestor() can be improved to lookup
> an entry /a in the lower layers above layer N and find the indexed dir /a
> from layer 1. If that improvement is made, then the check for 'layer N
> connected' will need to verify there are no redirects in lower layers above
> layer N. In the example above, /a will be 'layer 2 connectable'. However,
> if layer 2 dir /a is a target of a layer 1 redirect, then /a will NOT be
> 'layer 2 connectable':
>
>  layer 1: /A (redirect = /a)
>  layer 2: /a/b/c
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> I was able to convince myself that this patch is correct and it passed
> all existing tests and some manual tests of the new cases.
>
> I was also able to convince myself that the single CONNECTED bit in dentry
> is all the optimization we need and that there is no added value in
> gathering more state information on lookup.
> This extra lookup information or redirected lower layers will be needed if
> we ever implement (*) above.
>
> Was I able to also convince you that this patch is correct? and that no
> extra lookup information is needed?
>
> I will write more tests to cover the cases handles by this change.
>
> Thanks,
> Amir.
>
>  fs/overlayfs/export.c    | 176 +++++++++++++++++++++++++++++++++++++++--------
>  fs/overlayfs/overlayfs.h |   1 +
>  2 files changed, 147 insertions(+), 30 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 07d70255095b..b545e3b8249f 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -19,6 +19,138 @@
>  #include <linux/ratelimit.h>
>  #include "overlayfs.h"
>
> +
> +static int ovl_encode_maybe_copy_up(struct dentry *dentry)
> +{
> +       int err;
> +
> +       if (ovl_dentry_upper(dentry))
> +               return 0;
> +
> +       err = ovl_want_write(dentry);
> +       if (!err) {
> +               err = ovl_copy_up(dentry);
> +               ovl_drop_write(dentry);
> +       }
> +
> +       if (err) {
> +               pr_warn_ratelimited("overlayfs: failed to copy up on encode (%pd2, err=%i)\n",
> +                                   dentry, err);
> +       }
> +
> +       return err;
> +}
> +
> +/*
> + * Before encoding a non-upper directory file handle from real layer N, we need
> + * to check if it will be possible to reconnect an overlay dentry from the real
> + * lower decoded dentry. This is done by following the overlay ancestry up to a
> + * 'layer N connected' ancestor and verifying that all parents along the way are
> + * 'layer N connectable'. If an ancestor that is NOT 'layer N connectable' is
> + * found, we need to copy up an ancestor, which is 'layer N connectable', thus
> + * making that ancestor 'layer N connected'. For example:
> + *
> + * layer 1: /a
> + * layer 2: /a/b/c
> + *
> + * The overlay dentry /a is NOT 'layer 2 connectable', because if dir /a is
> + * copied up and renamed, upper dir /a will be indexed by lower dir /a from
> + * layer 1. The dir /a from layer 2 will never be indexed, so the alrogithm (*)
> + * in ovl_lookup_real_ancestor() will not be able to lookup a connected overlay
> + * dentry from the connected lower dentry /a/b/c.
> + *
> + * To avoid this problem on decode time, we need to copy up an ancestor of
> + * /a/b/c, which is 'layer 2 connectable', on encode time. That ancestor is
> + * /a/b. After copy up (and index) of /a/b, it will become 'layer 2 connected'
> + * and when the time comes to decode the file handle from lower dentry /a/b/c,
> + * ovl_lookup_real_ancestor() will find the indexed ancestor /a/b and decoding
> + * a connected overlay dentry will be accomplished.
> + *
> + * (*) the alrogithm in ovl_lookup_real_ancestor() can be improved to lookup an
> + * entry /a in the lower layers above layer N and find the indexed dir /a from
> + * layer 1. If that improvement is made, then the check for 'layer N connected'
> + * will need to verify there are no redirects in lower layers above N. In the
> + * example above, /a will be 'layer 2 connectable'. However, if layer 2 dir /a
> + * is a target of a layer 1 redirect, then /a will NOT be 'layer 2 connectable':
> + *
> + * layer 1: /A (redirect = /a)
> + * layer 2: /a/b/c
> + */
> +static int ovl_dentry_connectable_layer(struct dentry *dentry)
> +{
> +       struct ovl_entry *oe = OVL_E(dentry);
> +
> +       /* We can get overlay root from root of any layer */
> +       if (dentry == dentry->d_sb->s_root)
> +               return oe->numlower;
> +
> +       /* We cannot get upper/overlay path from non-indexed lower dentry */
> +       if (ovl_dentry_upper(dentry) &&
> +           !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
> +               return 0;
> +
> +       /* Pure upper cannot be ancestor of non pure upper */
> +       if (WARN_ON(!oe->numlower))
> +               return 0;
> +
> +       /* We can get upper/overlay path from indexed/lower dentry */
> +       return oe->lowerstack[0].layer->idx;
> +}
> +
> +/*
> + * @dentry is 'connected' if all ancestors up to root or a 'connected' ancestor
> + * have the same uppermost lower layer as the origin's layer. We may need to
> + * copy up a 'connectable' ancestor to make it 'connected'. A 'connected' dentry
> + * cannot become non 'connected', so cache positive result in dentry flags.
> + */
> +static bool ovl_dentry_connect(struct dentry *dentry)
> +{
> +       struct dentry *next, *parent = NULL;
> +       int origin_layer;
> +       int err = 0;
> +
> +       if (ovl_dentry_test_flag(OVL_E_CONNECTED, dentry))
> +               return true;
> +
> +       if (WARN_ON(dentry == dentry->d_sb->s_root) ||
> +           WARN_ON(!ovl_dentry_lower(dentry)))
> +               return true;
> +
> +       /* Find the topmost origin layer connectable ancestor of @dentry */
> +       origin_layer = OVL_E(dentry)->lowerstack[0].layer->idx;
> +       next = dget(dentry);
> +       for (;;) {
> +               parent = dget_parent(next);
> +
> +               /*
> +                * If @parent is not origin layer connectable, then copy up
> +                * @next which is origin layer connectable and we are done.
> +                */
> +               if (ovl_dentry_connectable_layer(parent) < origin_layer) {
> +                       err = ovl_encode_maybe_copy_up(next);
> +                       break;
> +               }
> +
> +               /* If parent is connected we are done */
> +               if (ovl_dentry_test_flag(OVL_E_CONNECTED, dentry))
> +                       return true;

There are 2 co-canceling bugs here (dentry and return).
Apart from that, the patch passed the tests I written for copy up
of ancestor, so posting v2.

> +
> +               /* If parent is root or indexed we are done */
> +               if (parent == next || ovl_test_flag(OVL_INDEX, d_inode(parent)))
> +                       break;
> +
> +               dput(next);
> +               next = parent;
> +       }
> +
> +       dput(parent);
> +       dput(next);
> +
> +       if (!err)
> +               ovl_dentry_set_flag(OVL_E_CONNECTED, dentry);
> +       return !err;
> +}
> +
>  /*
>   * We only need to encode origin if there is a chance that the same object was
>   * encoded pre copy up and then we need to stay consistent with the same
> @@ -42,7 +174,7 @@
>   *
>   * (*) Connecting an overlay dir from real lower dentry is not always
>   * possible when there are redirects in lower layers. To mitigate this case,
> - * we copy up the lower dir first and then encode an upper dir file handle.
> + * we may copy up the lower dir first and then encode an upper dir file handle.
>   */
>  static bool ovl_should_encode_origin(struct dentry *dentry)
>  {
> @@ -51,41 +183,25 @@ static bool ovl_should_encode_origin(struct dentry *dentry)
>         if (!ovl_dentry_lower(dentry))
>                 return false;
>
> -       /*
> -        * Decoding a merge dir, whose origin's parent is under a redirected
> -        * lower dir is not always possible. As a simple aproximation, we do
> -        * not encode lower dir file handles when overlay has multiple lower
> -        * layers and origin is below the topmost lower layer.
> -        *
> -        * TODO: copy up only the parent that is under redirected lower.
> -        */
> -       if (d_is_dir(dentry) && ofs->upper_mnt &&
> -           OVL_E(dentry)->lowerstack[0].layer->idx > 1)
> -               return false;
> -
>         /* Decoding a non-indexed upper from origin is not implemented */
>         if (ovl_dentry_upper(dentry) &&
>             !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>                 return false;
>
> -       return true;
> -}
> -
> -static int ovl_encode_maybe_copy_up(struct dentry *dentry)
> -{
> -       int err;
> -
> -       if (ovl_dentry_upper(dentry))
> -               return 0;
> -
> -       err = ovl_want_write(dentry);
> -       if (err)
> -               return err;
> -
> -       err = ovl_copy_up(dentry);
> +       /*
> +        * Decoding a merge dir, whose origin's ancestor is under a redirected
> +        * lower dir is not always possible. As a simple aproximation, we do
> +        * not encode lower dir file handles when overlay has multiple lower
> +        * layers and origin is on a non 'connectable' layer.
> +        * ovl_dentry_connect() will try to make origin's layer 'connected' by
> +        * copying up a 'connectable' ancestor. If ovl_dentry_connect() cannot
> +        * find a 'connectable' ancestor, it will return false and then this
> +        * dentry will be copied up and encoded as an upper file handle.
> +        */
> +       if (d_is_dir(dentry) && ofs->upper_mnt)
> +               return ovl_dentry_connect(dentry);
>
> -       ovl_drop_write(dentry);
> -       return err;
> +       return true;
>  }
>
>  static int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 0df25a9c94bd..225ff1171147 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -40,6 +40,7 @@ enum ovl_inode_flag {
>  enum ovl_entry_flag {
>         OVL_E_UPPER_ALIAS,
>         OVL_E_OPAQUE,
> +       OVL_E_CONNECTED,
>  };
>
>  /*
> --
> 2.7.4
>
