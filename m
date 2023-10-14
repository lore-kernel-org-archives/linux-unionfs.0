Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3545CDB465
	for <linux-unionfs@archiver.kernel.org>; Sat, 14 Oct 2023 06:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjJNGYP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 02:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjJNGYP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 14 Oct 2023 02:24:15 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C55BF
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Oct 2023 23:24:13 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-41b2bf4e9edso33442281cf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 13 Oct 2023 23:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697264652; x=1697869452; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeqLb84x+DqguqyH0RNGn202WnUylQrf0MGQOlASUMk=;
        b=lsZPwtXQRHAb370PuZUIivTh8+McvLPKSb/pE7lHFGBn7hvy3nh8kK/v9uEErT4t9r
         sGxTL1QYSCks/lf/vkW/gUbt8IvB9a00T3dNBFqhQDIwA9OCtQwzIjs7xqnOvVv/cHAr
         MeBXmhkjchuzzpMIRkAFMHNnNbgPShcENFPTROVltH74XjI/4M1AudTzTz3ffOduV6Qx
         5sxlRUxaxza/UNvw6rm151EMEcOMBPU+h9l5Wj36pNhCT3Fi1shGU355/gZmfeBp50gr
         18u4ya3lGux7zo0N5IErsw50ntFUYqzy3w4z+BVF1BsBdfosegcZHD4Z7orhF5Lg18lr
         ntNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697264652; x=1697869452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EeqLb84x+DqguqyH0RNGn202WnUylQrf0MGQOlASUMk=;
        b=fwRinCF94wzq9DAO+SO5/wq5g7n96wp+kZznUvqlY2cSaZ73i/83xWm8KG5BcqWhxH
         OlIDkEpoFkRuUrcUeq+dlHNKjUWu5r9e/3Wq4IQ0L4zNKbZ4CWp/O+WalXHV5fqKeciq
         tahU4403VVOG8ldoqK666D6HiZDy5g7Mr8ljMHI5PunFQmuMxcI3i+qggurpYNp9rPhE
         /WdwSets1hZMDkMmpzFUH+pH7PAHnxv8QCUkzV2xXIGzCibTquK3Q6IWPYQ26e9CiN14
         GJQGbY9BDaXHDLLuR0Xj+ydGFm74kY38p1hC3ttKsQ3JMPhs0Dj/4tSG/bvpIRW3rSS6
         7XJA==
X-Gm-Message-State: AOJu0Yyh/102cJCgFzl5IKV9TVWp4WDqbyukKoacL+AWwLI1OVaJ3vjv
        1PY6T8YSF0ZNZbV79mhv2d+t4QEop2Le4jpqrMg=
X-Google-Smtp-Source: AGHT+IEHUBu9xpOA3v7B2byhwz1FO1wv419Ot4W6FzSSjtbBP4C9x1zq4gdwUguGzlg9UfdIPr2AO84ksqwZQuJPEB8=
X-Received: by 2002:a05:622a:1450:b0:410:92ca:3dcd with SMTP id
 v16-20020a05622a145000b0041092ca3dcdmr3006036qtx.9.1697264652587; Fri, 13 Oct
 2023 23:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
In-Reply-To: <CAJfpegvgePB-==T=yTU1R+JVxKYsU_Bm18vWdW5hXWLGw=47PQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 14 Oct 2023 09:24:01 +0300
Message-ID: <CAOQ4uxiE89q62JHnxwm14FBShPORmX_h0EyDCBN-VKv6aTf5BQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Oct 13, 2023 at 6:36=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 11 Oct 2023 at 18:46, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Before commit b36a5780cb44 ("ovl: modify layer parameter parsing"),
> > spaces and commas in lowerdir mount option value used to be escaped usi=
ng
> > seq_show_option().
> >
> > In current upstream, when lowerdir value has a space, it is not escaped
> > in /proc/mounts, e.g.:
> >
> >   none /mnt overlay rw,relatime,lowerdir=3Dl l,upperdir=3Du,workdir=3Dw=
 0 0
> >
> > which results in broken output of the mount utility:
> >
> >   none on /mnt type overlay (rw,relatime,lowerdir=3Dl)
> >
> > Store the original lowerdir mount options before unescaping and show
> > them using the same escaping used for seq_show_option() in addition to
> > escaping the colon separator character.
> >
> > Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/params.c | 38 +++++++++++++++++++++++---------------
> >  1 file changed, 23 insertions(+), 15 deletions(-)
> >
> > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > index 95b751507ac8..1429767a84bc 100644
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -164,7 +164,8 @@ static ssize_t ovl_parse_param_split_lowerdirs(char=
 *str)
> >
> >         for (s =3D d =3D str;; s++, d++) {
> >                 if (*s =3D=3D '\\') {
> > -                       s++;
> > +                       /* keep esc chars in split lowerdir */
> > +                       *d++ =3D *s++;
> >                 } else if (*s =3D=3D ':') {
> >                         bool next_colon =3D (*(s + 1) =3D=3D ':');
> >
> > @@ -239,7 +240,7 @@ static void ovl_unescape(char *s)
> >         }
> >  }
> >
> > -static int ovl_mount_dir(const char *name, struct path *path)
> > +static int ovl_mount_dir(const char *name, struct path *path, bool upp=
er)
> >  {
> >         int err =3D -ENOMEM;
> >         char *tmp =3D kstrdup(name, GFP_KERNEL);
> > @@ -248,7 +249,7 @@ static int ovl_mount_dir(const char *name, struct p=
ath *path)
> >                 ovl_unescape(tmp);
> >                 err =3D ovl_mount_dir_noesc(tmp, path);
> >
> > -               if (!err && path->dentry->d_flags & DCACHE_OP_REAL) {
> > +               if (!err && upper && path->dentry->d_flags & DCACHE_OP_=
REAL) {
> >                         pr_err("filesystem on '%s' not supported as upp=
erdir\n",
> >                                tmp);
> >                         path_put_init(path);
> > @@ -269,7 +270,7 @@ static int ovl_parse_param_upperdir(const char *nam=
e, struct fs_context *fc,
> >         struct path path;
> >         char *dup;
> >
> > -       err =3D ovl_mount_dir(name, &path);
> > +       err =3D ovl_mount_dir(name, &path, true);
> >         if (err)
> >                 return err;
> >
> > @@ -472,7 +473,7 @@ static int ovl_parse_param_lowerdir(const char *nam=
e, struct fs_context *fc)
> >                 l =3D &ctx->lower[nr];
> >                 memset(l, 0, sizeof(*l));
> >
> > -               err =3D ovl_mount_dir_noesc(dup_iter, &l->path);
> > +               err =3D ovl_mount_dir(dup_iter, &l->path, false);
> >                 if (err)
> >                         goto out_put;
> >
> > @@ -950,16 +951,23 @@ int ovl_show_options(struct seq_file *m, struct d=
entry *dentry)
> >         struct super_block *sb =3D dentry->d_sb;
> >         struct ovl_fs *ofs =3D OVL_FS(sb);
> >         size_t nr, nr_merged_lower =3D ofs->numlayer - ofs->numdatalaye=
r;
> > -       char **lowerdatadirs =3D &ofs->config.lowerdirs[nr_merged_lower=
];
> > -
> > -       /* lowerdirs[] starts from offset 1 */
> > -       seq_printf(m, ",lowerdir=3D%s", ofs->config.lowerdirs[1]);
> > -       /* dump regular lower layers */
> > -       for (nr =3D 2; nr < nr_merged_lower; nr++)
> > -               seq_printf(m, ":%s", ofs->config.lowerdirs[nr]);
> > -       /* dump data lower layers */
> > -       for (nr =3D 0; nr < ofs->numdatalayer; nr++)
> > -               seq_printf(m, "::%s", lowerdatadirs[nr]);
> > +
> > +       /*
> > +        * lowerdirs[] starts from offset 1, then
> > +        * >=3D 0 regular lower layers prefixed with : and
> > +        * >=3D 0 data-only lower layers prefixed with ::
> > +        *
> > +        * we need to escase comma and space like seq_show_option() doe=
s and
> > +        * we also need to escape the colon separator from lowerdir pat=
hs.
> > +        */
> > +       seq_puts(m, ",lowerdir=3D");
> > +       for (nr =3D 1; nr < ofs->numlayer; nr++) {
> > +               if (nr > 1)
> > +                       seq_putc(m, ':');
> > +               if (nr >=3D nr_merged_lower)
> > +                       seq_putc(m, ':');
> > +               seq_escape(m, ofs->config.lowerdirs[nr], ":,=3D \t\n\\"=
);
>
> This is too eager.   Just need to escape what seq_show_option() would
> escape, which is comma and whitespace.   The '=3D' is  not need escaped
> in values only in keys (and that likely never triggers).

Right. I will remove =3D.

> Colons should have stayed escaped as "\:", so no point in adding another
> level of escape.

Yeh, unless the colon are not escaped because they were set via new api.
In this case, I would like to escape them in mountinfo (e.g. "a:b" =3D> "a\=
072b").
This way, libmount would be able to parse mountinfo correctly in the future
and learn how to iterate lowerdirs, even before fsinfo().
I am not even sure if fsinfo() is going to be able to iterate lowerdirs, so
escaping colons may be needed there as well.

>
> Yes, this two level escape is pretty confusing, considering that
> commas are escaped on both levels if using the old API.  When using
> the new API commas need not be escaped, but can be, since the same
> unescaping is done.   Not a serious issue as backslash in filenames is
> basically nonexistent, but an inconsistency nonetheless.

In general, I think we should be conservative and if escaping in mountinfo
doesn't hurt we should not change it.
Applications should consume mountinfo via libmount and libmount already
unescapes the seq_show_option() format.

>
> Following choices exist:
>
> 1) should the redundant escaping be left in mountinfo?

Absolutely yes. I don't think it is redundant at all.
It may be redundant in fsinfo(), when lowerdirs can be iterated?
but mountinfo output is a single monolothic string
even if lowerdirs were set individually by new mount api.

>
> 2) should FSCONFIG_SET_STRING accept escaped commas?
>

Well, it already does.
If you are considering to change that retroactively then my argument
is that IMO userspace needs to be able to pass in \: in lowerdirs
and see it in mountinto (and mount command output) as long as
libmount does not know how to split lowerdirs by itself.
Otherwise, replaying the options from mountinfo into libmount will not
work correctly.

> 3) should unescaped commas on FSCONFIG_SET_STRING (and
> FSCONFIG_SET_PATH) be double escaped in mountinfo?
>

Too much escaping in the sentence. I could not parse it ;)
For example, if "a:b" is set via FSCONFIG_SET_{STRING,PATH}
IMO mount info should output "a\072b", for the aforementioned reasons.
If by "double escaped" you meant "a\:b" or "a\134\072b", then I don't think
this is necessary.

> Currently it's yes, yes, no.  I'm fine with leaving things as they
> are, but at least the documentation should be clear on what should
> happen.

OK.
How is that:

--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -339,6 +339,18 @@ The specified lower directories will be stacked
beginning from the
 rightmost one and going left.  In the above example lower1 will be the
 top, lower2 the middle and lower3 the bottom layer.

+Note: directory names containing colons can be provided as lower layer by
+escaping the colons with a single backslash.  For example:
+
+  mount -t overlay overlay -olowerdir=3D/a\:lower\:\:dir /merged
+
+Since kernel version v6.5, directory names containing colons can also
+be provided as lower layer using the fsconfig syscall from new mount api:
+
+  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/a:lower::dir", 0);
+
+In the latter case, colons in lower layer directory names will be escaped
+as an octal characters (\072) when displayed in /proc/self/mountinfo.

The wording of the last sentence above is somewhat legalish -
De facto, since v6.5,y, we will escape ":" to "\072" no matter via which ap=
i
we got it and regardless of whether it is also escaped with "\:" or not. bu=
t
we only need to commit to this rule for unescaped colons via new mount api.

I will add this documentation to the fix patch and retain escaping of ":".

Thanks,
Amir.
