Return-Path: <SRS0=6QjP=DC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E536AC4363D
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2A8206BE
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Sep 2020 16:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vVcIoVYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbgIYQhp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 12:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgIYQho (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Sep 2020 12:37:44 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8BCC0613CE;
        Fri, 25 Sep 2020 09:37:44 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q4so2958164ils.4;
        Fri, 25 Sep 2020 09:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WDHQgshnR2jNOPc1TU8tr1qYbvYsVn8CGoRl49F0USs=;
        b=vVcIoVYtHz1ya+N/I17YoiFtpTQeOlqXz7ouYN2sFxOSw61tXzR/tzwFG7QzQlYR3V
         s2hU2kYjFznlpUnAFDTFaaB52CK5TpJw0BM4usotnrnDmH6uNkq3MYwxrbWi8+oTXbhu
         PpBItgtBso4qMrNtbP5OfddgKFO1uFtCedAQjmO1ixA5qZGNMHlyrDL4/aaI8PQfheBV
         xJDgp5jNiuqWq0TwDrRr3eq66xEGCWG4QNrKdFZeoy/cNQ60yykkJQb4Un0NaWASO+sS
         6eJ+3s0LHY+rpqPKejixAF5ir7sYUUNrzVfJuBdvmcdqpHxHku042OlpA/WseTsw5QD3
         XeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WDHQgshnR2jNOPc1TU8tr1qYbvYsVn8CGoRl49F0USs=;
        b=bjk8AbPYZiI1C1PePg+oM+MDQ3Spccv5hIbacHiC0fD8p418wMkijuNeCRBeX83Bo6
         SbqjihI07gLjFWRpNLZJYsMk5rx6A9Sx5L/rUKWL8m7Nn+wweZ/7xpnk+ypT4jVF2E0Q
         MPxVyKtZBmqAk9BuMc40/OzMD2YLugt0G2veBpXU5Q1FCyMR7rhAdbTt02sKq9Sboe0b
         p4raKO2YbmPV8jrIrLG1RxNGNjtdnY/CwtAe+Z5lDtVUvDeEVVh6Dfi4DWa2Q0jCRTmI
         A2RpKx33r4/w76RRx5JsMDyyHneWD7kndwcI2q/ui/YRIv1GOAAGGFt9Pr7APa5xHO8+
         C7UA==
X-Gm-Message-State: AOAM533AqkT3F0Kk/UZ0iDOZrNmhG6xJGHYu1XQAml+tgC2EVdjXqpjV
        g0XDtkOd8Ddb6Pp/EEysQ6+BLdYBFNmYW/zb+aE=
X-Google-Smtp-Source: ABdhPJwgEl6F/ltU8KAwi8c4E6KklQ4GgYpSTJsH71vRDIznnAEg2ZPyVnmG+EMLoqsMWLQuHn8eermVS+iLEb6YIF0=
X-Received: by 2002:a92:8b41:: with SMTP id i62mr937844ild.9.1601051863853;
 Fri, 25 Sep 2020 09:37:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200925083507.13603-1-ptikhomirov@virtuozzo.com> <20200925083507.13603-2-ptikhomirov@virtuozzo.com>
In-Reply-To: <20200925083507.13603-2-ptikhomirov@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 25 Sep 2020 19:37:32 +0300
Message-ID: <CAOQ4uxjYhSWCFerfuJc8BGLHciHDo8vnkpB9kMwh3wmvovUq1w@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ovl: propagate ovl_fs to ovl_decode_real_fh and ovl_encode_real_fh
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 25, 2020 at 11:35 AM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This will be used in next patch to be able to change uuid checks and
> add uuid nullification based on ofs->config.index for a new "uuid=off"
> mode.
>
> CC: Amir Goldstein <amir73il@gmail.com>
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: linux-unionfs@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/copy_up.c   | 22 ++++++++++++----------
>  fs/overlayfs/export.c    | 10 ++++++----
>  fs/overlayfs/namei.c     | 19 ++++++++++---------
>  fs/overlayfs/overlayfs.h | 14 ++++++++------
>  fs/overlayfs/util.c      |  3 ++-
>  5 files changed, 38 insertions(+), 30 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 955ecd4030f0..3380039036d6 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -275,7 +275,8 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
>         return err;
>  }
>
> -struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
> +struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
> +                                 bool is_upper)
>  {
>         struct ovl_fh *fh;
>         int fh_type, dwords;
> @@ -328,8 +329,8 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
>         return ERR_PTR(err);
>  }
>
> -int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> -                  struct dentry *upper)
> +int ovl_set_origin(struct ovl_fs *ofs, struct dentry *dentry,
> +                  struct dentry *lower, struct dentry *upper)
>  {
>         const struct ovl_fh *fh = NULL;
>         int err;
> @@ -340,7 +341,7 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
>          * up and a pure upper inode.
>          */
>         if (ovl_can_decode_fh(lower->d_sb)) {
> -               fh = ovl_encode_real_fh(lower, false);
> +               fh = ovl_encode_real_fh(ofs, lower, false);
>                 if (IS_ERR(fh))
>                         return PTR_ERR(fh);
>         }
> @@ -362,7 +363,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
>         const struct ovl_fh *fh;
>         int err;
>
> -       fh = ovl_encode_real_fh(upper, true);
> +       fh = ovl_encode_real_fh(ofs, upper, true);
>         if (IS_ERR(fh))
>                 return PTR_ERR(fh);
>
> @@ -380,6 +381,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
>  static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
>                             struct dentry *upper)
>  {
> +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
>         struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
>         struct inode *dir = d_inode(indexdir);
>         struct dentry *index = NULL;
> @@ -402,7 +404,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
>         if (WARN_ON(ovl_test_flag(OVL_INDEX, d_inode(dentry))))
>                 return -EIO;
>
> -       err = ovl_get_index_name(origin, &name);
> +       err = ovl_get_index_name(ofs, origin, &name);
>         if (err)
>                 return err;
>
> @@ -411,7 +413,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
>         if (IS_ERR(temp))
>                 goto free_name;
>
> -       err = ovl_set_upper_fh(OVL_FS(dentry->d_sb), upper, temp);
> +       err = ovl_set_upper_fh(ofs, upper, temp);
>         if (err)
>                 goto out;
>
> @@ -521,7 +523,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>          * hard link.
>          */
>         if (c->origin) {
> -               err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> +               err = ovl_set_origin(ofs, c->dentry, c->lowerpath.dentry, temp);
>                 if (err)
>                         return err;
>         }
> @@ -700,7 +702,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
>  static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
>  {
>         int err;
> -       struct ovl_fs *ofs = c->dentry->d_sb->s_fs_info;
> +       struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
>         bool to_index = false;
>
>         /*
> @@ -722,7 +724,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
>
>         if (to_index) {
>                 c->destdir = ovl_indexdir(c->dentry->d_sb);
> -               err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
> +               err = ovl_get_index_name(ofs, c->lowerpath.dentry, &c->destname);
>                 if (err)
>                         return err;
>         } else if (WARN_ON(!c->parent)) {
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index ed35be3fafc6..41ebf52f1bbc 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -211,7 +211,8 @@ static int ovl_check_encode_origin(struct dentry *dentry)
>         return 1;
>  }
>
> -static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
> +static int ovl_dentry_to_fid(struct ovl_fs *ofs, struct dentry *dentry,
> +                            u32 *fid, int buflen)
>  {
>         struct ovl_fh *fh = NULL;
>         int err, enc_lower;
> @@ -226,7 +227,7 @@ static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
>                 goto fail;
>
>         /* Encode an upper or lower file handle */
> -       fh = ovl_encode_real_fh(enc_lower ? ovl_dentry_lower(dentry) :
> +       fh = ovl_encode_real_fh(ofs, enc_lower ? ovl_dentry_lower(dentry) :
>                                 ovl_dentry_upper(dentry), !enc_lower);
>         if (IS_ERR(fh))
>                 return PTR_ERR(fh);
> @@ -249,6 +250,7 @@ static int ovl_dentry_to_fid(struct dentry *dentry, u32 *fid, int buflen)
>  static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
>                          struct inode *parent)
>  {
> +       struct ovl_fs *ofs = OVL_FS(inode->i_sb);
>         struct dentry *dentry;
>         int bytes, buflen = *max_len << 2;
>
> @@ -260,7 +262,7 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
>         if (WARN_ON(!dentry))
>                 return FILEID_INVALID;
>
> -       bytes = ovl_dentry_to_fid(dentry, fid, buflen);
> +       bytes = ovl_dentry_to_fid(ofs, dentry, fid, buflen);
>         dput(dentry);
>         if (bytes <= 0)
>                 return FILEID_INVALID;
> @@ -680,7 +682,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
>         if (!ovl_upper_mnt(ofs))
>                 return ERR_PTR(-EACCES);
>
> -       upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
> +       upper = ovl_decode_real_fh(ofs, fh, ovl_upper_mnt(ofs), true);
>         if (IS_ERR_OR_NULL(upper))
>                 return upper;
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index a6162c4076db..f058bf8e8b87 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -150,8 +150,8 @@ static struct ovl_fh *ovl_get_fh(struct ovl_fs *ofs, struct dentry *dentry,
>         goto out;
>  }
>
> -struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
> -                                 bool connected)
> +struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
> +                                 struct vfsmount *mnt, bool connected)
>  {
>         struct dentry *real;
>         int bytes;
> @@ -354,7 +354,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>                     ofs->layers[i].fs->bad_uuid)
>                         continue;
>
> -               origin = ovl_decode_real_fh(fh, ofs->layers[i].mnt,
> +               origin = ovl_decode_real_fh(ofs, fh, ofs->layers[i].mnt,
>                                             connected);
>                 if (origin)
>                         break;
> @@ -450,7 +450,7 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
>         struct ovl_fh *fh;
>         int err;
>
> -       fh = ovl_encode_real_fh(real, is_upper);
> +       fh = ovl_encode_real_fh(ofs, real, is_upper);
>         err = PTR_ERR(fh);
>         if (IS_ERR(fh)) {
>                 fh = NULL;
> @@ -488,7 +488,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
>         if (IS_ERR_OR_NULL(fh))
>                 return ERR_CAST(fh);
>
> -       upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
> +       upper = ovl_decode_real_fh(ofs, fh, ovl_upper_mnt(ofs), true);
>         kfree(fh);
>
>         if (IS_ERR_OR_NULL(upper))
> @@ -640,12 +640,13 @@ static int ovl_get_index_name_fh(struct ovl_fh *fh, struct qstr *name)
>   * index dir was cleared. Either way, that index cannot be used to indentify
>   * the overlay inode.
>   */
> -int ovl_get_index_name(struct dentry *origin, struct qstr *name)
> +int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
> +                      struct qstr *name)
>  {
>         struct ovl_fh *fh;
>         int err;
>
> -       fh = ovl_encode_real_fh(origin, false);
> +       fh = ovl_encode_real_fh(ofs, origin, false);
>         if (IS_ERR(fh))
>                 return PTR_ERR(fh);
>
> @@ -694,7 +695,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
>         bool is_dir = d_is_dir(origin);
>         int err;
>
> -       err = ovl_get_index_name(origin, &name);
> +       err = ovl_get_index_name(ofs, origin, &name);
>         if (err)
>                 return ERR_PTR(err);
>
> @@ -805,7 +806,7 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
>         if (err)
>                 return err;
>
> -       err = ovl_set_origin(dentry, lower, upper);
> +       err = ovl_set_origin(ofs, dentry, lower, upper);
>         if (!err)
>                 err = ovl_set_impure(dentry->d_parent, upper->d_parent);
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 7bce2469fe55..b56b5f46f224 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -383,8 +383,8 @@ static inline int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
>         return ovl_check_fb_len(&fh->fb, fh_len - OVL_FH_WIRE_OFFSET);
>  }
>
> -struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
> -                                 bool connected);
> +struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
> +                                 struct vfsmount *mnt, bool connected);
>  int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
>                         struct dentry *upperdentry, struct ovl_path **stackp);
>  int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
> @@ -392,7 +392,8 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
>                       bool set);
>  struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
>  int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
> -int ovl_get_index_name(struct dentry *origin, struct qstr *name);
> +int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
> +                      struct qstr *name);
>  struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
>  struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
>                                 struct dentry *origin, bool verify);
> @@ -511,9 +512,10 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags);
>  int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
>                    struct dentry *new);
>  int ovl_set_attr(struct dentry *upper, struct kstat *stat);
> -struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
> -int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
> -                  struct dentry *upper);
> +struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
> +                                 bool is_upper);
> +int ovl_set_origin(struct ovl_fs *ofs, struct dentry *dentry,
> +                  struct dentry *lower, struct dentry *upper);
>
>  /* export.c */
>  extern const struct export_operations ovl_export_operations;
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 23f475627d07..44b4b62a8ac8 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -716,6 +716,7 @@ bool ovl_need_index(struct dentry *dentry)
>  /* Caller must hold OVL_I(inode)->lock */
>  static void ovl_cleanup_index(struct dentry *dentry)
>  {
> +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
>         struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
>         struct inode *dir = indexdir->d_inode;
>         struct dentry *lowerdentry = ovl_dentry_lower(dentry);
> @@ -725,7 +726,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
>         struct qstr name = { };
>         int err;
>
> -       err = ovl_get_index_name(lowerdentry, &name);
> +       err = ovl_get_index_name(ofs, lowerdentry, &name);
>         if (err)
>                 goto fail;
>
> --
> 2.26.2
>
