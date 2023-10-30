Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2B3C4332F
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Oct 2023 17:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbjJ3Rlk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 30 Oct 2023 13:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbjJ3Rlj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2023 13:41:39 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63EBA9
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 10:41:36 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6ce2cc39d12so3073358a34.1
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2023 10:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698687696; x=1699292496; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1hXdaU9CbEZ3zWtyzOH/S1Xyd+4S0V0Arv38oDCCeg=;
        b=Kve1r9iMOvT3/8Hu5LW5kaSWDqCZtW2Wgs0UuQzU8e9pGS/wbGvHOylhpOPlMik9Q0
         uBpjn9n7I9UoHy9lKCKAwEmdjsoj4YCrG323rE1wS/hfYV+7kQ4rN0QPMq3ub8gPxJdV
         VRUp3xDuFBIMp0lbuDFDkpnHyJMy4V9nnOomf8UP/+TNow02NBx9HhmKdf4Kh5NYv5ex
         z5s19Hz3bUfmRHBByzQwfhUDTFRZk44GKTKH3an3RncPQC+U9YXmVJY771yN+/snECC8
         mKytYFZ2PSZxywqE8L5+Srjr5bz8547HrGFF8Ozi0pFHuTdtB7zwEgBlrL7KmuCf+uKr
         A2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698687696; x=1699292496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1hXdaU9CbEZ3zWtyzOH/S1Xyd+4S0V0Arv38oDCCeg=;
        b=VOa2A83+gRZkCIWaATaUZhPOrCXdZ9gzOVkb7Xwi2c0nitkyfZeG9Gaspax9nQB0BO
         M7bHj5db/0sYHi+z+drAB48XzZ6intpGahBKE6Z7zyCmnNWwNEwNiCPrIjVdIzIruEsW
         WBU+NIP4nu9lmLBLyobwYgRhMZmnS9PV2PM80FQ8vpE9ya0nCQ22Py7rTAJFq7Q28fmK
         z/zzHvkqbJtHJkMypHrbU9Ng6h9EriWsussy+2CZzoho85vMPdIrQSiViPyYIdJ7fv4F
         2gnY9F9N4cW8aY+bdUBxt6x50UW57Y3QcHVwtTTaK18rx/odg8QhSUuJ6dNl1pa5B8dS
         Cupg==
X-Gm-Message-State: AOJu0Yx9lpEosmtr2bFd/Eu16OYa5Z4Lk0JGs/1RXx1HXK0ZDqvOUHzr
        6ELJdktSukUuhbQBVhJSWs1RHgkbwC8SHq4Qe7j2oynd
X-Google-Smtp-Source: AGHT+IEmSJduP1ccYHtIMQo6dv2LmtsHqsbvMjwSiN7ntARvxvr2QGCaYPOqjcx/MrtvlWuTj7h2wNrQ4liz2Avmy0Q=
X-Received: by 2002:a05:6870:7d10:b0:1ea:183d:ff63 with SMTP id
 os16-20020a0568707d1000b001ea183dff63mr14494769oab.46.1698687696138; Mon, 30
 Oct 2023 10:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20231030120419.478228-1-amir73il@gmail.com> <20231030120419.478228-4-amir73il@gmail.com>
 <CAJfpegs79eNFC_+ZV6mCu9Q__PNQmT-uM5=_ysufZAuTkJdK0w@mail.gmail.com>
In-Reply-To: <CAJfpegs79eNFC_+ZV6mCu9Q__PNQmT-uM5=_ysufZAuTkJdK0w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 30 Oct 2023 19:41:24 +0200
Message-ID: <CAOQ4uxhgWhe0NTS9p0=B+tqEjOgYKsxCFJd=iJb46M0MF04Gvw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ovl: refactor layer parsing helpers
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 30, 2023 at 5:37=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 30 Oct 2023 at 13:04, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > In preparation for new mount options to add lowerdirs one by one,
> > generalize ovl_parse_param_upperdir() into helper ovl_parse_layer()
> > with bool @upper argument that will be false for adding lower layers.
> >
> > Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
> > Link: https://lore.kernel.org/r/CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=
=3DQFUxpFJE+=3DRQ@mail.gmail.com/
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/params.c | 116 ++++++++++++++++++++++--------------------
> >  1 file changed, 62 insertions(+), 54 deletions(-)
> >
> > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > index 0bf754a69e91..9a9238eac730 100644
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -43,7 +43,7 @@ module_param_named(metacopy, ovl_metacopy_def, bool, =
0644);
> >  MODULE_PARM_DESC(metacopy,
> >                  "Default to on or off for the metadata only copy up fe=
ature");
> >
> > -enum {
> > +enum ovl_opt {
> >         Opt_lowerdir,
> >         Opt_upperdir,
> >         Opt_workdir,
> > @@ -238,19 +238,8 @@ static int ovl_mount_dir_noesc(const char *name, s=
truct path *path)
> >                 pr_err("failed to resolve '%s': %i\n", name, err);
> >                 goto out;
> >         }
> > -       err =3D -EINVAL;
> > -       if (ovl_dentry_weird(path->dentry)) {
> > -               pr_err("filesystem on '%s' not supported\n", name);
> > -               goto out_put;
> > -       }
> > -       if (!d_is_dir(path->dentry)) {
> > -               pr_err("'%s' not a directory\n", name);
> > -               goto out_put;
> > -       }
>
> This will lose the check for lowerdir, no?
>

oops. I guess I'll need to add a test case...

> >         return 0;
> >
> > -out_put:
> > -       path_put_init(path);
> >  out:
> >         return err;
> >  }
> > @@ -268,7 +257,7 @@ static void ovl_unescape(char *s)
> >         }
> >  }
> >
> > -static int ovl_mount_dir(const char *name, struct path *path, bool upp=
er)
> > +static int ovl_mount_dir(const char *name, struct path *path)
> >  {
> >         int err =3D -ENOMEM;
> >         char *tmp =3D kstrdup(name, GFP_KERNEL);
> > @@ -276,60 +265,81 @@ static int ovl_mount_dir(const char *name, struct=
 path *path, bool upper)
> >         if (tmp) {
> >                 ovl_unescape(tmp);
> >                 err =3D ovl_mount_dir_noesc(tmp, path);
> > -
> > -               if (!err && upper && path->dentry->d_flags & DCACHE_OP_=
REAL) {
> > -                       pr_err("filesystem on '%s' not supported as upp=
erdir\n",
> > -                              tmp);
> > -                       path_put_init(path);
> > -                       err =3D -EINVAL;
> > -               }
> >                 kfree(tmp);
> >         }
> >         return err;
> >  }
> >
> > -static int ovl_parse_param_upperdir(const char *name, struct fs_contex=
t *fc,
> > -                                   bool workdir)
> > +static int ovl_mount_dir_check(struct fs_context *fc, const struct pat=
h *path,
> > +                              enum ovl_opt layer, const char *name, bo=
ol upper)
> >  {
> > -       int err;
> > -       struct ovl_fs *ofs =3D fc->s_fs_info;
> > -       struct ovl_config *config =3D &ofs->config;
> > -       struct ovl_fs_context *ctx =3D fc->fs_private;
> > -       struct path path;
> > -       char *dup;
> > +       if (ovl_dentry_weird(path->dentry))
> > +               return invalfc(fc, "filesystem on %s not supported", na=
me);
> >
> > -       err =3D ovl_mount_dir(name, &path, true);
> > -       if (err)
> > -               return err;
> > +       if (!d_is_dir(path->dentry))
> > +               return invalfc(fc, "%s is not a directory", name);
>
> This can result in:
>
>   overlay: lowerdir+ is not a directory
>
> Which is somewhat confusing.  Not sure how mount/libmount will present
> such option error messages, as that does not currently work.
>
> So the kernel could be really nice about it and tell the user which
> lowerdir (layer index).   But libmount could also indicate which
> option failed, in which case indicating the layer would not be needed.
>   OTOH when using the legacy API we do need to tell the user whether
> it was upperdir or workdir, but that doesn't affect lowerdir+.   So
> some compromise and negotiation with util-linux devs is needed.
>

What a mess. I prefer to restore the old pr_err messages with the
pathname for now, because they are more likely to help the users
fix the problem.

We could sort it better when we add support for path parameters.
At least with path params, we would know that it is not legacy mount API.

Thanks,
Amir.
