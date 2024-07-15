Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D323BF
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 10:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721038065; cv=none; b=EWTMeMGHIjV24s1BBdCR3BMLQS42MAqPdC8iZdPbRiECpItrf8QG1fS7Td6ga2ZmlbQP3HyagwPqCQHeYDrTEXvKi+5ZGeCpBxontEVqWNOtgUmcqJ+pE+Qprox+Msm/v3MHUgflwqJNRCPsK/fGYey8msVNOUqFT/nOjeFuYpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721038065; c=relaxed/simple;
	bh=8bGN3XwN0+juc0i638a+XLiqfyAk52IATx9Hx2pCJy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JzEDQGVelbEOsdW04efS/pAxqMC4jS931miEwSN8jiMr8ieiAPsRrNZeGt1kp0OiZ4pu+cLQW5tD8B1u0KYcLkCtPKGF9/bgh24WxY0rR8iYUfN9/aDiza5YR1kFfGIc/R7bnXD59kQbFSafWRyB3ATX2LEdoN9zgEOBSg+VQ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVxCp/2Z; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVxCp/2Z"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3d9dbbaa731so1896554b6e.3
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jul 2024 03:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721038062; x=1721642862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dG6z5qzkl78aRmSnAkS+LGPYdkJQbALjh+D1XQfMPq8=;
        b=FVxCp/2Z8a1VN+gKyNWmCRX+ZwmUi9a/kyxRqVFtd/4VK85iAILBVwiEER9CVDfflX
         9xCopl5GNBMMv7isrPkmlQqZiViOXtZHTcWz0T2So0vLKaMAYHcx4LiYxhUbz1GHFrhS
         qimQHlG8Q3gu4wkkCJUxT0nUeT8sY8vBulLCNsWuMd8VmnnY4AUiaWogNEHo/l0aXpYj
         Jjvqr8jK2uGeT5vokLmHAHR9i3HwjJeiwlt5vMQrVdFdIl7tqDQsR41ozYG/xVJzPUhh
         qbzFW2AQiss7IDmUt29qTA6aOwvAFmZiZR+u2podEpqglF+sLjzcup7Dzxm6UQTCHiob
         ioGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721038062; x=1721642862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dG6z5qzkl78aRmSnAkS+LGPYdkJQbALjh+D1XQfMPq8=;
        b=K1e7u4zNSWSqVJDgdEWwIDbESR93bx+DChH2FfsFN10CW3BfKBQ1cnQSManszEL3GQ
         OsjEgIVKxy/PoT8t6J59ERg3aWq+1yEXvMS6gZAyUch+iC4VstpumtxjPn6oNuIb1FWk
         DNEhGtjyIi/Z0Q9FIOPzE3ksVNcz2TsiUg2ROyv10mpv8TgdFlmpVzgZl10CwK/nC4qm
         R0WdASNhIH523hwA6F94Ufdtrq8+R8U6v4ganaSP9PWGP3F0zeNCTpr72jKCgzM9qx6F
         4ro0J1kKTf7K+FkvHDiT6U0m4mjYppcEe3uLw8f2eu5k/T+9uLjMA/b1bxw0qQn/cVjm
         XneQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfcYKkJwLFjZyUj1G8eAjdaYxlCnJCutIGHJGos4GP514UnVlGGZTtfH4S2JLnxas1Va3UUwhgoEd0VEap5Svclv9tCZl2HCm3rilaAg==
X-Gm-Message-State: AOJu0Yz7L0aIj8X7H3bJFsEHBj8z5olQpKUhxcV6TxNbRDG4FLgIQYbS
	5hMPbN1b3L8KdnFikBYB56ZA320YSIhiaH8lWNh91UsHyyJigUqijSs7zd2lPtViHJWLPc+8m4w
	exDCSovU/2gaGexk2SU7miUVfqMC5ohJek7s=
X-Google-Smtp-Source: AGHT+IFy4klZeqj0GYNnt93Vv1qEaCRHyJTW4bFYH1FcqgStDD0zhsVlRz7A69iyxN5CvEgK5/ipdscine9oDHfBKxc=
X-Received: by 2002:a05:6808:bcb:b0:3d9:243a:7b02 with SMTP id
 5614622812f47-3d93c0845a2mr17809457b6e.40.1721038062052; Mon, 15 Jul 2024
 03:07:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a2391c78f3974c5d92aa53574bde4eca@exch01.asrmicro.com>
 <CAOQ4uxj-pOvmw1-uXR3qVdqtLjSkwcR9nVKcNU_vC10Zyf2miQ@mail.gmail.com> <d75ce286091046438f8828554eb3f781@exch01.asrmicro.com>
In-Reply-To: <d75ce286091046438f8828554eb3f781@exch01.asrmicro.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Jul 2024 13:07:30 +0300
Message-ID: <CAOQ4uxhJET3v7+7+Cw-wnsRbpPa6ufRDFYaGYWD9RYLgfUxRZA@mail.gmail.com>
Subject: Re: overlayfs issue: dir permission lost during overlayfs copy-up
To: =?UTF-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 9:07=E2=80=AFAM Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=
=EF=BC=89 <feilv@asrmicro.com> wrote:
>
>
>
> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Amir Goldstein [mailto:amir73il@gmail.com]
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2024=E5=B9=B47=E6=9C=8812=E6=97=
=A5 17:41
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=EF=BC=89=
 <feilv@asrmicro.com>
> > =E6=8A=84=E9=80=81: miklos@szeredi.hu; overlayfs <linux-unionfs@vger.ke=
rnel.org>
> > =E4=B8=BB=E9=A2=98: Re: overlayfs issue: dir permission lost during ove=
rlayfs copy-up
> >
> > On Fri, Jul 12, 2024 at 7:18=E2=80=AFAM Lv Fei=EF=BC=88=E5=90=95=E9=A3=
=9E=EF=BC=89 <feilv@asrmicro.com> wrote:
> > >
> > >
> > >
> > > Dear Amir,
> > >
> > >
> > >
> > > Seems issue disappeared with below changes, can you help review below=
 patch?
> > >
> > >
> > >
> > > Thank you!
> > >
> > >
> > >
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > >
> > > index 48bca5817f..e543b5563d 100644
> > >
> > > --- a/fs/overlayfs/copy_up.c
> > >
> > > +++ b/fs/overlayfs/copy_up.c
> > >
> > > @@ -851,9 +851,11 @@ static int ovl_copy_up_one(struct dentry *parent=
,
> > > struct dentry *dentry,
> > >
> > >
> > >
> > > int ovl_copy_up_flags(struct dentry *dentry, int flags)
> > >
> > > {
> > >
> > > +       struct super_block *sb =3D dentry->d_sb;
> > >
> > >         int err =3D 0;
> > >
> > >         const struct cred *old_cred;
> > >
> > >         bool disconnected =3D (dentry->d_flags & DCACHE_DISCONNECTED)=
;
> > >
> > > +       unsigned int copies =3D 0;
> > >
> > >
> > >
> > >         /*
> > >
> > >          * With NFS export, copy up can get called for a disconnected=
 non-dir.
> > >
> > > @@ -887,9 +889,14 @@ int ovl_copy_up_flags(struct dentry *dentry, int
> > > flags)
> > >
> > >
> > >
> > >                 dput(parent);
> > >
> > >                 dput(next);
> > >
> > > +
> > >
> > > +               copies++;
> > >
> > >         }
> > >
> > >         ovl_revert_creds(dentry->d_sb, old_cred);
> > >
> > >
> > >
> > > +       if (copies && d_is_dir(dentry) && sb->s_op->sync_fs)
> > >
> > > +               sb->s_op->sync_fs(sb, 1);
> > >
> > > +
> > >
> >
> > I am not sure if it is acceptable to add sync to parent dir copy up alt=
hough this should be > relatively rare so maybe its fine??
> > but if you do add sync you should be using fsync on the copied up paren=
t directory - not ->sync_fs.
> >
> > Anyway, this check is wrong.
> > You should not be checking for d_is_dir(dentry), you should be checking=
 if any *parents* were copied > up,
> >
> > See more about this below...
> >
> > >
> > >
> > >
> > > =E5=8F=91=E4=BB=B6=E4=BA=BA: Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=EF=BC=
=89
> > > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2024=E5=B9=B47=E6=9C=8812=E6=97=
=A5 11:35
> > > =E6=94=B6=E4=BB=B6=E4=BA=BA: 'amir73il@gmail.com' <amir73il@gmail.com=
>
> > > =E4=B8=BB=E9=A2=98: overlayfs issue: dir permission lost during overl=
ayfs copy-up
> > >
> > >
> > >
> > >
> > >
> > > Dear Amir,
> > >
> > >
> > >
> > > Sorry to bother you.
> > >
> > >
> > >
> > > Recently, we had a problem with overlayfs dir copy-up flow.
> > >
> > >
> > >
> > > Description:
> > >
> > > If a dir eyelyn/ exist in low layer, not exist in upper layer, after =
creating a new file(e.g. > eyelyn/ eyelyn.log) in this dir from overlayfs, =
permission of eyelyn/ may be abnormal after > power-cut.
> > >
> > > If add a sync after creating a new file, permission of eyelyn/ is alw=
ays correct.
> > >
> > >
> > >
> > > Kernel Version:
> > >
> > > Linux OpenWrt 5.4.276+ #25 PREEMPT Fri Jul 12 02:21:17 UTC 2024 armv7=
l
> > > GNU/Linux
> > >
> > >
> > >
> > > Test Step:
> > >
> > > 1. mount =E2=80=93t squashfs /dev/mtdblock19 /system/etc
> > >
> > > root@OpenWrt:/system/etc# ls -l
> > >
> > > drwxr-xr-x    2 root     root             3 Jul 11  2024 eyelyn/
> > >
> > >
> > >
> > > 2. mount =E2=80=93t ubifs ubi0:etc /overlay/etc
> > >
> > > root@OpenWrt:/overlay/etc# ls -l
> > >
> > > drwxr-xr-x    8 root     root          1360 Jan  1 08:01 root/
> > >
> > > drwxr-xr-x    3 root     root           224 Jan  1 08:00 work/
> > >
> > > root@OpenWrt:/overlay/etc# ls -al root/
> > >
> > > drwxr-xr-x    8 root     root          1360 Jan  1 08:01 ./
> > >
> > > drwxr-xr-x    4 root     root           288 Jan  1 08:00 ../
> > >
> > >
> > >
> > > 3. mount =E2=80=93t overlay /system/etc -o
> > > noatime,lowerdir=3D/system/etc,upperdir=3D/overlay/etc/root,workdir=
=3D/overl
> > > ay/etc/work
> > >
> > >
> > >
> > > 4. echo system > /system/etc /eyelyn/eyelyn.log
> > >
> > >
> > >
> > > 5. power cut
> > >
> > >
> > >
> > > 6. after next power on, sometimes dir eyelyn/ has wrong permission
> > > (d---------)
> > >
> > >
> > >
> > > mount =E2=80=93t ubifs ubi0:etc /overlay/etc
> > >
> > > root@OpenWrt:/overlay/etc# ls -l root/
> > >
> > > d---------   1 root     root           232 Jan  1 08:00 eyelyn
> > >
> > > root@OpenWrt:/overlay/etc# ls =E2=80=93l system/etc/eyelyn/eyelyn.log
> > >
> > > -rw-r--r--    1 root     root             0 Jan  1 08:00 /system/etc/=
eyelyn/eyelyn.log
> > >
> > >
> > >
> > > if we add sync to step 4, that is =E2=80=9Cecho system > /system/etc =
/eyelyn/eyelyn.log && sync=E2=80=9D, then > everything is right.
> > >
> > >
> > >
> > > Do you have any suggestions?
> > >
> > >
> >
> >
> > Overlayfs creates the upper dir in work directory, sets its metadata an=
d only then moves it into > place, so the above is an "issue" with ubifs.
> >
> > The thing about this "issue" is that the behavior that after move the o=
ld permissions cannot be > observed is not defined by POSIX, but it is the =
facto the behavior of most of the modern filesystems > (xfs, ext4 and most =
probably btrfs).
> >
> > If you want to add a feature that adds fsync to copied up parent direct=
ories for filesystems like > ubifs that are not "strictly ordered metadata"=
 then I think this needs to be an opt-in feature.
> >
> > I must admit that this requirement from the upper fs is not documented =
and cannot be automatically > tested by overlayfs (fs do not advertise "str=
ictly ordered metadata" property). It just happens to > be true for most of=
 the common fs used as upper fs.
> >
> > I wish we had called the mount option "volatile" "sync=3Dnone" and then=
 we could have added > "sync=3Dstrict" for this and "sync=3Ddata" as the de=
fault.
> > We can still do that and have "volatile" be an alias for "sync=3Dnone".
> >
> > Thanks,
> > Amir.
>
> Very glad to receive your reply, Thank you for explanation.
> As you suggested, I try to add mount option "sync=3Dstrict", change to us=
e fsync for parent dir. Please help have a look.
>

Ok, but if you want to submit this change please follow
https://www.kernel.org/doc/html/latest/process/submitting-patches.html
See comments below

> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 48bca5817f..4258b8da8d 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -851,6 +851,7 @@ static int ovl_copy_up_one(struct dentry *parent, str=
uct dentry *dentry,
>
>  int ovl_copy_up_flags(struct dentry *dentry, int flags)
>  {
> +       struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;

ofs =3D OVL_FS(dentry->d_sb);

>         int err =3D 0;
>         const struct cred *old_cred;
>         bool disconnected =3D (dentry->d_flags & DCACHE_DISCONNECTED);
> @@ -884,6 +885,24 @@ int ovl_copy_up_flags(struct dentry *dentry, int fla=
gs)
>                 }
>
>                 err =3D ovl_copy_up_one(parent, next, flags);
> +               if (ofs->config.volatile_sync && d_is_dir(next)) {
> +                       struct path upperpath;
> +                       struct file *new_file;
> +
> +                       ovl_path_upper(next, &upperpath);
> +
> +                       new_file =3D ovl_path_open(&upperpath,
> +                                               O_LARGEFILE | O_WRONLY);
> +                       if (!IS_ERR(new_file)) {
> +                               if (ofs->config.volatile_sync =3D=3D
> +                                   OVL_VOLATILE_SYNC_DATA)
> +                                       vfs_fsync(new_file, 1);

Not needed already done in ovl_copy_up_file()

> +                               else
> +                                       vfs_fsync(new_file, 0);
> +
> +                               fput(new_file);
> +                       }
> +               }

Not the right place for fsync.
This should be at the end of ovl_copy_up_metadata()
similar to fsync at the end of ovl_copy_up_file().
The check for sync mode should be abstracted by the helper
like ovl_should_sync(), maybe ovl_should_sync_strict()

>
>                 dput(parent);
>                 dput(next);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 2daba08f78..873d997fb9 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -5,6 +5,12 @@
>   * Copyright (C) 2016 Red Hat, Inc.
>   */
>
> +enum {
> +       OVL_VOLATILE_SYNC_NONE,
> +       OVL_VOLATILE_SYNC_DATA,
> +       OVL_VOLATILE_SYNC_STRICT,
> +};
> +
>  struct ovl_config {
>         char *lowerdir;
>         char *upperdir;
> @@ -18,6 +24,7 @@ struct ovl_config {
>         int xino;
>         bool metacopy;
>         bool override_creds;
> +       int volatile_sync;

This word volatile_ is unneeded and wrong. "volatile" means "no sync"
Please *replace the config ovl_volatile with sync_mode, don't keep both
and grep for all access to ovl_volatile to replace them with adjusted
sync_mode code.

>  };
>
>  struct ovl_sb {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 093af1dcbd..68dee1850b 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -416,6 +416,9 @@ enum {
>         OPT_METACOPY_OFF,
>         OPT_OVERRIDE_CREDS_ON,
>         OPT_OVERRIDE_CREDS_OFF,
> +       OPT_VOLATILE_SYNC_NONE,
> +       OPT_VOLATILE_SYNC_DATA,
> +       OPT_VOLATILE_SYNC_STRICT,

This word _VOLATILE_ is unneeded and wrong. "volatile" means "no sync"
Which version are you basing your patch on?
You should be developing on top of current upstream kernel, where this
parsing code is at params.c.

You should follow the example of ovl_parameter_verity()
which accepts enum values {off, on, require} which is quite the
same as what you want for sync mode.

>         OPT_ERR,
>  };
>
> @@ -436,6 +439,9 @@ static const match_table_t ovl_tokens =3D {
>         {OPT_METACOPY_OFF,              "metacopy=3Doff"},
>         {OPT_OVERRIDE_CREDS_ON,         "override_creds=3Don"},
>         {OPT_OVERRIDE_CREDS_OFF,        "override_creds=3Doff"},
> +       {OPT_VOLATILE_SYNC_NONE,        "sync=3Dnone"},
> +       {OPT_VOLATILE_SYNC_DATA,        "sync=3Ddata"},
> +       {OPT_VOLATILE_SYNC_STRICT,      "sync=3Dstrict"},

Note that you need to add the new sync option AND keep the legacy
"volatile" mount option.

>         {OPT_ERR,                       NULL}
>  };
>
> @@ -495,6 +501,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config=
 *config)
>         if (!config->redirect_mode)
>                 return -ENOMEM;
>         config->override_creds =3D ovl_override_creds_def;
> +       config->volatile_sync =3D OVL_VOLATILE_SYNC_ DATA;
>
>         while ((p =3D ovl_next_opt(&opt)) !=3D NULL) {
>                 int token;
> @@ -583,6 +590,18 @@ static int ovl_parse_opt(char *opt, struct ovl_confi=
g *config)
>                         config->override_creds =3D false;
>                         break;
>
> +               case OPT_VOLATILE_SYNC_NONE:
> +                       config->volatile_sync =3D OVL_VOLATILE_SYNC_NONE;
> +                       break;
> +
> +               case OPT_VOLATILE_SYNC_DATA:
> +                       config->volatile_sync =3D OVL_VOLATILE_SYNC_DATA;
> +                       break;
> +
> +               case OPT_VOLATILE_SYNC_STRICT:
> +                       config->volatile_sync =3D OVL_VOLATILE_SYNC_STRIC=
T;
> +                       break;
> +


And effectively the two mount options to do the same, i.e.:

case Opt_sync:
                config->sync_mode =3D result.uint_32;
                break;
case Opt_volatile:
                config->sync_mode =3D OVL_SYNC_OFF;
                break;

>                 default:
>                         pr_err("overlayfs: unrecognized mount option \"%s=
\" or missing value\n", p);
>                         return -EINVAL;
>

Also need to display the mode in ovl_show_options().

Thanks,
Amir,
