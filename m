Return-Path: <SRS0=YYYA=4H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155BBC34047
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8848B2176D
	for <linux-unionfs@archiver.kernel.org>; Wed, 19 Feb 2020 14:25:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="WFPLNBbe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgBSOZ6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 09:25:58 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40624 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbgBSOZ6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Feb 2020 09:25:58 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so739534iop.7
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Feb 2020 06:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vmH2v1JFe9qnMjF7Nz79wPBMuo9C/JhfGwE5X5rxws=;
        b=WFPLNBbeZFEAQEiTDS9mc/xBztW3kOXQZ5fdtwnfBEKFFhbU9VB7ZyIpILGTxLqLT3
         KfiCdRsWXvQED6QKalRbLkQBTohdBc8pkPjl6GS3wAMMOigKhPcGaLKXf8uKtfTmKfWb
         lyvPKBxEbs4WGV//L91UBmbpyPe6M3nRsEyj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vmH2v1JFe9qnMjF7Nz79wPBMuo9C/JhfGwE5X5rxws=;
        b=NtL774FQMWmVGkwne1utgvRt2zGJZWqYCRsr01/lfhrncV3AwLiQL7geD9r9wkAnKN
         NXjAS5Tq4Bim2YYm0JP+F99WjMymJzfInhTUvfTYs/SoTRbsCGhkTdBfROYsbf4AANKc
         kr/OyuiySm/68nm3rQBZFQcG/kh5vom/dAeN798UKqzsfsBE+Ys8o7Fi/cfCohnqSloD
         4NPgMu6Agkx4Ges7NOH/99kk6PKBvWUMuT6dTBTn28eWt+3OU1+qGWO5GUzOtViVmPVr
         7uTnjKuqYtrk3TRPIvrd+hF3o8+WY6cSvRzGLvWZ+YXxYVjLimvosgvpsw+xFYv8z6FM
         bnZg==
X-Gm-Message-State: APjAAAU5FCErx7Q+WYL8yw25VmnLlz4aMnQ+I6EAteTi21tUDMvVJLlX
        tPS12rtg7981dZ5cV7Ok1Ef+ZOvpTTn6Csuu7G5B2wVs
X-Google-Smtp-Source: APXvYqwZtrbqWi+fm7kNbXK9mwJsxVuTHNYZzuA7ZgxI6AS8sqkDYxTnY92CoJJOi5WiY3cUUNBWbPSzQYlQQoDepP0=
X-Received: by 2002:a6b:24b:: with SMTP id 72mr18279817ioc.63.1582122356857;
 Wed, 19 Feb 2020 06:25:56 -0800 (PST)
MIME-Version: 1.0
References: <20200101175814.14144-1-amir73il@gmail.com> <20200101175814.14144-6-amir73il@gmail.com>
In-Reply-To: <20200101175814.14144-6-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 19 Feb 2020 15:25:45 +0100
Message-ID: <CAJfpegvPBwBpmcY60CcypYRAGgQr44ONz8TSzdBUq2tPmOXBbA@mail.gmail.com>
Subject: Re: [PATCH 5/7] ovl: avoid possible inode number collisions with xino=on
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jan 1, 2020 at 6:58 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> When xino feature is enabled and a real directory inode number
> overflows the lower xino bits, we cannot map this directory inode
> number to a unique and persistent inode number and we fall back to
> the real inode st_ino and overlay st_dev.
>
> The real inode st_ino with high bits may collide with a lower inode
> number on overlay st_dev that was mapped using xino.
>
> To avoid possible collision with legitimate xino values, map a non
> persistent inode number to a dedicated range in the xino address space.
> The dedicated range is created by adding one more bit to the number of
> reserved high xino bits.  We could have added just one more fsid, but
> that would have had the undesired effect of changing persistent overlay
> inode numbers on kernel or require more complex xino mapping code.
>
> The non persistent inode number is allocated with get_next_ino()
> and stored in i_generation.  To reduce the burn rate of get_next_ino()
> numbers in the system, we avoid calling get_next_ino() on non dir,
> because we are not going to use it and we reuse i_generation from
> recycled ovl_inode objects.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/inode.c     | 54 ++++++++++++++++++++++++++++++++--------
>  fs/overlayfs/overlayfs.h |  7 ++++++
>  fs/overlayfs/super.c     | 28 ++++++++++++---------
>  3 files changed, 66 insertions(+), 23 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 04e8e8de2012..415d9efa4799 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -79,6 +79,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
>  {
>         bool samefs = ovl_same_fs(dentry->d_sb);
>         unsigned int xinobits = ovl_xino_bits(dentry->d_sb);
> +       unsigned int shift = 64 - xinobits;
>
>         if (samefs) {
>                 /*
> @@ -89,7 +90,6 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
>                 stat->dev = dentry->d_sb->s_dev;
>                 return 0;
>         } else if (xinobits) {
> -               unsigned int shift = 64 - xinobits;
>                 /*
>                  * All inode numbers of underlying fs should not be using the
>                  * high xinobits, so we use high xinobits to partition the
> @@ -116,11 +116,25 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
>                  * overlay mount boundaries.
>                  *
>                  * If not all layers are on the same fs the pair {real st_ino;
> -                * overlay st_dev} is not unique, so use the non persistent
> -                * overlay st_ino for directories.
> +                * overlay st_dev} is not unique, so use a non persistent
> +                * overlay st_ino for directories, which is allocated with
> +                * get_next_ino() and stored in i_generation.
> +                *
> +                * To avoid ino collision with legitimate xino values from upper
> +                * layer (fsid 0), use fsid 1 to map the non persistent inode
> +                * numbers to the unified st_ino address space.
> +                *
> +                * In this case (xino bits overflow on directory inode), the
> +                * value of overlay inode st_ino will not be consistent with
> +                * d_ino and i_ino. i_ino will have the value of the real inode
> +                * i_ino and d_ino will have either the value of i_ino or the
> +                * value of st_ino, depending on the directory iteration mode
> +                * that is used on the parent (i.e. real/merge/impure).
>                  */
>                 stat->dev = dentry->d_sb->s_dev;
> -               stat->ino = dentry->d_inode->i_ino;
> +               stat->ino = dentry->d_inode->i_generation;

I think we should avoid misusing i_generation for this.  It's
confusing and not woth it, IMO.

> +               if (xinobits)
> +                       stat->ino |= ((u64)1) << shift;

I don't like this magic shifting.


>         } else {
>                 /*
>                  * For non-samefs setup, if we cannot map all layers st_ino
> @@ -128,7 +142,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
>                  * is unique per underlying fs, so we use the unique anonymous
>                  * bdev assigned to the underlying fs.
>                  */
> -               stat->dev = OVL_FS(dentry->d_sb)->fs[fsid].pseudo_dev;
> +               stat->dev = ovl_dentry_fs(dentry, fsid)->pseudo_dev;
>         }
>
>         return 0;
> @@ -564,6 +578,7 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
>  static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
>  {
>         int xinobits = ovl_xino_bits(inode->i_sb);
> +       bool overflow = ino >> (64 - xinobits);
>
>         /*
>          * When d_ino is consistent with st_ino (samefs or i_ino has enough
> @@ -571,13 +586,30 @@ static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
>          * so inode number exposed via /proc/locks and a like will be
>          * consistent with d_ino and st_ino values. An i_ino value inconsistent
>          * with d_ino also causes nfsd readdirplus to fail.
> +        *
> +        * When real inode bits overflow into xino bits, we leave i_ino value as
> +        * the real inode to be consitent with d_ino.  For directory inodes on
> +        * non-samefs with xino disabled or xino overflow, we reserve a unique
> +        * 32bit generation number, to be used for resolving st_ino collisions
> +        * in ovl_map_dev_ino(). With xino disabled, this 32bit number is also
> +        * used as i_ino.
>          */
> -       if (ovl_same_dev(inode->i_sb)) {
> -               inode->i_ino = ino;
> -               if (xinobits && fsid && !(ino >> (64 - xinobits)))
> -                       inode->i_ino |= (unsigned long)fsid << (64 - xinobits);
> -       } else {
> -               inode->i_ino = get_next_ino();
> +       inode->i_ino = ino;
> +       if (ovl_same_dev(inode->i_sb) && !overflow) {
> +               inode->i_ino |= (unsigned long)fsid << (64 - xinobits);

While this makes sense on 64bit arch, it's going to overflow on 32bit
(due to i_ino being "unsigned long").

> +       } else if (S_ISDIR(inode->i_mode)) {
> +               /*
> +                * Reuse unique 32bit ino from recycled ovl_inode object.
> +                * get_next_ino() wraps around at 32bit, but may be extended
> +                * to 64bit in the future, so be prepared.
> +                */
> +               if (!inode->i_generation) {
> +                       inode->i_generation = (u32)get_next_ino();
> +                       if (unlikely(!inode->i_generation))
> +                               inode->i_generation = (u32)get_next_ino();
> +               }

And this is really messy.   How about an atomic64_t counter in ovl_fs
instead?  Do we really care about the performance of inode allocation
for the overflow case?

> +               if (!ovl_same_dev(inode->i_sb))
> +                       inode->i_ino = inode->i_generation;
>         }
>  }
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 140510d24d9f..c0b15fd2b395 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -311,6 +311,13 @@ static inline unsigned int ovl_xino_bits(struct super_block *sb)
>         return ofs->xino_bits;
>  }
>
> +static inline struct ovl_sb *ovl_dentry_fs(struct dentry *dentry, int fsid)
> +{
> +       /* fsid bit 1 is reserved for non persistent ino range */
> +       WARN_ON_ONCE(fsid & 1);
> +       return &OVL_FS(dentry->d_sb)->fs[fsid >> 1];

Again, magic shifts.  Would be so much nicer to leave the fsid
definition as the index into the ->fs array and deal with this when
creating the st_ino/i_ino values.

> +}
> +
>  /* All layers on same fs? */
>  static inline bool ovl_same_fs(struct super_block *sb)
>  {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index d072f982d3de..d636a23df541 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1272,8 +1272,8 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
>         return true;
>  }
>
> -/* Get a unique fsid for the layer */
> -static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
> +/* Get a unique fs for the layer */
> +static int ovl_get_fs(struct ovl_fs *ofs, const struct path *path)
>  {
>         struct super_block *sb = path->mnt->mnt_sb;
>         unsigned int i;
> @@ -1353,9 +1353,9 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
>         for (i = 0; i < numlower; i++) {
>                 struct vfsmount *mnt;
>                 struct inode *trap;
> -               int fsid;
> +               int n;
>
> -               err = fsid = ovl_get_fsid(ofs, &stack[i]);
> +               err = n = ovl_get_fs(ofs, &stack[i]);
>                 if (err < 0)
>                         goto out;
>
> @@ -1387,9 +1387,10 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
>                 ofs->layers[ofs->numlower].trap = trap;
>                 ofs->layers[ofs->numlower].mnt = mnt;
>                 ofs->layers[ofs->numlower].idx = ofs->numlower;
> -               ofs->layers[ofs->numlower].fsid = fsid;
> -               ofs->layers[ofs->numlower].fs = &ofs->fs[fsid];
> -               ofs->fs[fsid].is_lower = true;
> +               /* fsid bit 1 is reserved for non persistent ino range */
> +               ofs->layers[ofs->numlower].fsid = n << 1;
> +               ofs->layers[ofs->numlower].fs = &ofs->fs[n];
> +               ofs->fs[n].is_lower = true;
>         }
>
>         /*
> @@ -1398,7 +1399,8 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
>          * free high bits in underlying fs to hold the unique fsid.
>          * If overlayfs does encounter underlying inodes using the high xino
>          * bits reserved for fsid, it emits a warning and uses the original
> -        * inode number.
> +        * inode number or a non persistent inode number allocated from a
> +        * dedicated range.
>          */
>         if (ofs->numfs == 1 || (ofs->numfs == 2 && !ofs->upper_mnt)) {
>                 if (ofs->config.xino == OVL_XINO_ON)
> @@ -1408,11 +1410,13 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
>         } else if (ofs->config.xino == OVL_XINO_ON && !ofs->xino_bits) {
>                 /*
>                  * This is a roundup of number of bits needed for encoding
> -                * fsid, where fsid 0 is reserved for upper fs even with
> -                * lower only overlay.
> +                * fsid, where fsid 0 is reserved for upper fs (even with
> +                * lower only overlay) and fsid bit 1 is reserved for the non
> +                * persistent inode number range that is used for resolving
> +                * xino lower bits overflow.
>                  */
> -               BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 31);
> -               ofs->xino_bits = ilog2(ofs->numfs - 1) + 1;
> +               BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 30);
> +               ofs->xino_bits = ilog2(ofs->numfs - 1) + 2;


Just realized, this patch is obsolete (xino_bits ->xino_mode).

Anyway, I think the comments are valid for the updated patch as well.

Thanks,
Miklos
