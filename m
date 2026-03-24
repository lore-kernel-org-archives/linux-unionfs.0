Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162352F2607
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774375466; cv=pass; b=K5A+Lz+Jko7005yNJuuEHhdYETXPKN3FBaR/4xn8RXLKT7xN2WbTAH9rAgu0ZUrg4pOwUC1L3j810xmZZd+s/RhoAdI0ewRRiOkfcyWEhzxYkUB0acP724vqL71zsgiA+FqJ5jWmq//4JcwPPEWnAwIubwpcX/EuI99bsgMTn8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774375466; c=relaxed/simple;
	bh=emqsr4yhpoMepZHOsTv9LkDRC7zw1AcGq2if2A/giNc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VLF5WxyOLKqHCedlw54pwXWG8jg9TfR9zhEre54V8py0CSDARLfbHjn136FuVl38V2JDRhsG4TiGrapfLwL9npEGtyssI0hc9XuuI+Sew4cAA4i8C/Z7OSKGkT18UAkWcubJGr/mbFBQ5ej0GwGE48kylQtTIqrX1dDS8xy9tsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uzsdO2D/; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uzsdO2D/"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-509069a7a7fso58661cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 11:04:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774375464; cv=none;
        d=google.com; s=arc-20240605;
        b=CjTO9fSiA+WY9fTJAlgyYIkUjU1NYSE80HYhEiu6Mg696zv8/oyuk/wwjdmvOeZ/2f
         vxA2zppUYY4omUvUZ1JGOrqZAS5BsbezN50huzJ0iDqXoFUY9rmsWyRwlsJxCZhzeBiB
         70ij/aIJihxagblHT59x0bkC/ZTYplahvw9HVLjJ4Gu4mYNeDFsqMSE6GT2xk119m7pP
         EeizSMCuAEC+YnopUCo5bTJ2YIL2rn1fgAfgJk/QfsFLYQFzqImTcs1IqnS6N+DThvcL
         VjI5EnT0+dusmYEBseaRSFL+5eSR3jikLiCHL7Emap4p91frsU+785xeYp23iFA4ZxmV
         45og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FF7oPJfW4iF5f8VU9N3vuVBQzmdBcYy88XbrlgZkFbs=;
        fh=x6Sx2zP3y06C7hYx0VTVYXnmeGqnb22E04GUv+i1VYg=;
        b=hhHgS6vCigdUMkw8c+nEKojTV1eK/cJkaaIGZy0qxbcRP2j2b5HWW4BT8BphoAQHhS
         9TW0qcJop/vHGTAVoGF6gnvmY7Z4WtyoZj2mniwrd/hQ2+kp+8bq05651sr1kEV23iUs
         BGwv5am5c4Xdcg9wc4Xuk3PHIC9E29Hx5mJN/ezRm56CHeZV2hOMMO/3TfWuKFESdXWS
         FAhUyjw/cEwuK2yebvrRyiZwqfDpa+VdhEkgjT7JmwKNicRaf9uMU5KA6mV4SR59ZU3u
         GCygAf9FdT1AqEGHlaVyFOwglkAJ2j9PYcO7jxMyXG1VN6dNX0nFgUJ2X684qXonycT6
         fi6g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774375464; x=1774980264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FF7oPJfW4iF5f8VU9N3vuVBQzmdBcYy88XbrlgZkFbs=;
        b=uzsdO2D/2/l56DZFH3E+8vxkpeamBzpRji7A+TqOaKHkWNSnnMZmTCQMNXUbfk7gIj
         MhgHZhNUVbaRkqg9POcQeiQUVTnIOtjfRMfdolDblnUUALczZEyivKcitxOOJ89sxHo0
         3228Y97GYNAh1OYOBmv56TSr3jV0SVWN6pP9U30K+Xkp7Z3pNVQ8hheJCj9MMitvqzl2
         WbtNUdWyZwvhVZaF0fO+hFTDMJwD/W0zvGyqIhRntBeNGiLZJHpWc95s0l5QOxMrz+tq
         dixuFm0ir39z2DdE+fNuvxxNGqAdNQlhr1vynRNUcWqdHtfJ6o/CARgm75bshOCpQiPS
         94Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774375464; x=1774980264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FF7oPJfW4iF5f8VU9N3vuVBQzmdBcYy88XbrlgZkFbs=;
        b=QQoi2XOtwThylg/3fWnm/FiaIyMW07nolqsKBU6YH426l0UZiaYvWoQ4DOA2DAVIlv
         FNhpKz2okC/karrGNwx5onmWJhrwK6GLoQmlfXaG3M4EpVXEg3DYUZtyoJokovtBFxJo
         hYlBehWuhO+L54r16yQCEnbrbes2flNSSB6pxDY9Y+Hzl3pMo/EEVgQzGw4QvsY/nzuL
         vMmcjW7iCt3wyvSghdCJXSsxafMXJmvCAn+b5fO/9N1r7tBvBGlXd2dMeqnY42NTp/lh
         K2ljmjDaUDyquX7RJlGdgH3F5ROikq07Qc4D01VzLZSVgfwRKhgdXPiW/ILYLt+TU3Nn
         QhrA==
X-Forwarded-Encrypted: i=1; AJvYcCUKT+miZfSyB5ZloCMUrYMH+Ptb4HkXqER40vKgSLC0sxSm5pDwo/+l3lcSICVYTESrmT7jurhlsncncDC2@vger.kernel.org
X-Gm-Message-State: AOJu0YxhdwUtF1BaoRrLG7qHehV1uJZAjrtw0BOIzt+yBMTaQ2+VPlNr
	5XiUjetW5P/uCIK4Cbnk0LP50ozCM295mb8PhUeplPOK1V2JVIfwHjcd1TttI7TQlo2Qx3MOld4
	KkbDfxLv87OOC0uTN0MERzuE0pKAEyYbb3IeDugkn
X-Gm-Gg: ATEYQzzkk2Q1atC71EqWjn/x//9TtKCmB8AUnfXk3E8DGbom0wpwZLJhGgj93mujfnG
	cUgh3PUDoWUx8jT5+Jp+GvTzaPTwf3JSm4KUgtzgxVEFjWSy7W6sanO08NWpYcsEGfPS/bpEUVJ
	DJQ8vEkhTX1v7N+YMO6qxBUyCHocdlim+6BzgSbWb8VaWKqHHZ1YjSWZbThjMhwMAbySu6u6vYd
	hCDdEeIUrgYIAIGW1bx7e9+wAnYd0HxrtJ4WG6SelGo5B89tC3Clvi5RHyShQ4PcucOZbTT3aAa
	7rn7rUQ=
X-Received: by 2002:a05:622a:9008:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-50b82227924mr1104551cf.8.1774375463254; Tue, 24 Mar 2026
 11:04:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324145750.90719-1-amir73il@gmail.com>
In-Reply-To: <20260324145750.90719-1-amir73il@gmail.com>
From: Chenglong Tang <chenglongtang@google.com>
Date: Tue, 24 Mar 2026 11:04:12 -0700
X-Gm-Features: AQROBzCWrkB2hFIuziNLaT9vU_zLPQ6hf4f4ZmYyGhMbWS7SgDXORLQcWAZoyX4
Message-ID: <CAOdxtTY0jsqrJVXH=eQzYcowEpkDxwrk1DMgg8QD4ojygWJQ_Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: make fsync after metadata copy-up opt-in mount option
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, Fei Lv <feilv@asrmicro.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Regarding the patch: because we are currently locked to the 6.12 LTS
kernel, this patch doesn't apply cleanly to our tree (due to missing
mainline dependencies like the str_on_off helper).

Since we are actively tracking this for a Google COS customer
escalation, do you have a rough timeline for when you expect this to
be merged into mainline and subsequently picked up by the 6.12 stable
queue?

We will officially pull it into the COS tree as soon as it lands in
linux-stable.

Thanks again for the excellent support,

Chenglong

On Tue, Mar 24, 2026 at 7:57=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> From: Fei Lv <feilv@asrmicro.com>
>
> Commit 7d6899fb69d25 ("ovl: fsync after metadata copy-up") was done to
> fix durability of overlayfs copy up on an upper filesystem which does
> not enforce ordering on storing of metadata changes (e.g. ubifs).
>
> In an earlier revision of the regressing commit by Lei Lv, the metadata
> fsync behavior was opt-in via a new "fsync=3Dstrict" mount option.
> We were hoping that the opt-in mount option could be avoided, so the
> change was only made to depend on metacopy=3Doff, in the hope of not
> hurting performance of metadata heavy workloads, which are more likely
> to be using metacopy=3Don.
>
> This hope was proven wrong by a performance regression report from Google
> COS workload after upgrade to kernel 6.12.
>
> This is an adaptation of Lei's original "fsync=3Dstrict" mount option
> to the existing upstream code.
>
> The new mount option is mutually exclusive with the "volatile" mount
> option, so the latter is now an alias to the "fsync=3Dvolatile" mount
> option.
>
> Reported-by: Chenglong Tang <chenglongtang@google.com>
> Closes: https://lore.kernel.org/linux-unionfs/CAOdxtTadAFH01Vui1FvWfcmQ8j=
H1O45owTzUcpYbNvBxnLeM7Q@mail.gmail.com/
> Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxgKC1SgjMWre=3DfUb00v8r=
xtd6sQi-S+dxR8oDzAuiGu8g@mail.gmail.com/
> Fixes: 7d6899fb69d25 ("ovl: fsync after metadata copy-up")
> Depends: 50e638beb67e0 ("ovl: Use str_on_off() helper in ovl_show_options=
()")
> Cc: stable@vger.kernel.org # v6.12
> Signed-off-by: Fei Lv <feilv@asrmicro.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> The linked conversion was concluded with:
> "Now we just need to hope that users won't come shouting about
> performance regressions."
>
> Well, users came shouting.
>
> I am going to queue this up for an explicit opt-in to strict
> metadata fsync.
>
> Your review comment on the original fsync=3Dstrict patch are
> already addressed by the upstream commit (no double fsync).
>
> Thanks,
> Amir.
>
>
>  Documentation/filesystems/overlayfs.rst | 39 +++++++++++++++++++++++++
>  fs/overlayfs/copy_up.c                  |  6 ++--
>  fs/overlayfs/ovl_entry.h                | 20 +++++++++++--
>  fs/overlayfs/params.c                   | 32 ++++++++++++++++----
>  fs/overlayfs/super.c                    |  2 +-
>  5 files changed, 88 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index af5a69f87da42..f9ef3d101c172 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -783,6 +783,45 @@ controlled by the "uuid" mount option, which support=
s these values:
>      mounted with "uuid=3Don".
>
>
> +Durability and copy up
> +----------------------
> +
> +The fsync(2) and fdatasync(2) system calls ensure that the metadata and
> +data of a file, respectively, are safely written to the backing
> +storage, which is expected to guarantee the existence of the information=
 post
> +system crash.
> +
> +Without the fdatasync(2) call, there is no guarantee that the observed
> +data after a system crash will be either the old or the new data, but
> +in practice, the observed data after crash is often the old or new data =
or a
> +mix of both.
> +
> +When overlayfs file is modified for the first time, copy up will create
> +a copy of the lower file and its parent directories in the upper layer.
> +In case of a system crash, if fdatasync(2) was not called after the
> +modification, the upper file could end up with no data at all (i.e.
> +zeros), which would be an unusual outcome.  To avoid this experience,
> +overlayfs calls fsync(2) on the upper file before completing the copy up=
 with
> +rename(2) to make the copy up "atomic".
> +
> +Depending on the backing filesystem (e.g. ubifs), fsync(2) before
> +rename(2) may not be enough to provide the "atomic" copy up behavior
> +and fsync(2) on the copied up parent directories is required as well.
> +
> +Overlayfs can be tuned to prefer performance or durability when storing
> +to the underlying upper layer.  This is controlled by the "fsync" mount
> +option, which supports these values:
> +
> +- "ordered": (default)
> +    Call fsync(2) on upper file before completion of copy up.
> +- "strict":
> +    Call fsync(2) on upper file and directories before completion of cop=
y up.
> +- "volatile": [*]
> +    Prefer performance over durability (see `Volatile mount`_)
> +
> +[*] The mount option "volatile" is an alias to "fsync=3Dvolatile".
> +
> +
>  Volatile mount
>  --------------
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 758611ee4475f..eca285a2d0c5b 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -1146,15 +1146,15 @@ static int ovl_copy_up_one(struct dentry *parent,=
 struct dentry *dentry,
>                 return -EOVERFLOW;
>
>         /*
> -        * With metacopy disabled, we fsync after final metadata copyup, =
for
> +        * With "fsync=3Dstrict", we fsync after final metadata copyup, f=
or
>          * both regular files and directories to get atomic copyup semant=
ics
>          * on filesystems that do not use strict metadata ordering (e.g. =
ubifs).
>          *
> -        * With metacopy enabled we want to avoid fsync on all meta copyu=
p
> +        * By default, we want to avoid fsync on all meta copyup, because
>          * that will hurt performance of workloads such as chown -R, so w=
e
>          * only fsync on data copyup as legacy behavior.
>          */
> -       ctx.metadata_fsync =3D !OVL_FS(dentry->d_sb)->config.metacopy &&
> +       ctx.metadata_fsync =3D ovl_should_sync_strict(OVL_FS(dentry->d_sb=
)) &&
>                              (S_ISREG(ctx.stat.mode) || S_ISDIR(ctx.stat.=
mode));
>         ctx.metacopy =3D ovl_need_meta_copy_up(dentry, ctx.stat.mode, fla=
gs);
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 1d4828dbcf7ac..dbb2242647ce4 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -5,6 +5,12 @@
>   * Copyright (C) 2016 Red Hat, Inc.
>   */
>
> +enum {
> +       OVL_FSYNC_ORDERED,
> +       OVL_FSYNC_STRICT,
> +       OVL_FSYNC_VOLATILE,
> +};
> +
>  struct ovl_config {
>         char *upperdir;
>         char *workdir;
> @@ -18,7 +24,7 @@ struct ovl_config {
>         int xino;
>         bool metacopy;
>         bool userxattr;
> -       bool ovl_volatile;
> +       int fsync_mode;
>  };
>
>  struct ovl_sb {
> @@ -122,7 +128,17 @@ static inline struct ovl_fs *OVL_FS(struct super_blo=
ck *sb)
>
>  static inline bool ovl_should_sync(struct ovl_fs *ofs)
>  {
> -       return !ofs->config.ovl_volatile;
> +       return ofs->config.fsync_mode !=3D OVL_FSYNC_VOLATILE;
> +}
> +
> +static inline bool ovl_should_sync_strict(struct ovl_fs *ofs)
> +{
> +       return ofs->config.fsync_mode =3D=3D OVL_FSYNC_STRICT;
> +}
> +
> +static inline bool ovl_is_volatile(struct ovl_config *config)
> +{
> +       return config->fsync_mode =3D=3D OVL_FSYNC_VOLATILE;
>  }
>
>  static inline unsigned int ovl_numlower(struct ovl_entry *oe)
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 8111b437ae5d9..ba860bb92439a 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -58,6 +58,7 @@ enum ovl_opt {
>         Opt_xino,
>         Opt_metacopy,
>         Opt_verity,
> +       Opt_fsync,
>         Opt_volatile,
>         Opt_override_creds,
>  };
> @@ -140,6 +141,23 @@ static int ovl_verity_mode_def(void)
>         return OVL_VERITY_OFF;
>  }
>
> +static const struct constant_table ovl_parameter_fsync[] =3D {
> +       { "ordered",    OVL_FSYNC_ORDERED  },
> +       { "strict",     OVL_FSYNC_STRICT   },
> +       { "volatile",   OVL_FSYNC_VOLATILE },
> +       {}
> +};
> +
> +static const char *ovl_fsync_mode(struct ovl_config *config)
> +{
> +       return ovl_parameter_fsync[config->fsync_mode].name;
> +}
> +
> +static int ovl_fsync_mode_def(void)
> +{
> +       return OVL_FSYNC_ORDERED;
> +}
> +
>  const struct fs_parameter_spec ovl_parameter_spec[] =3D {
>         fsparam_string_empty("lowerdir",    Opt_lowerdir),
>         fsparam_file_or_string("lowerdir+", Opt_lowerdir_add),
> @@ -155,6 +173,7 @@ const struct fs_parameter_spec ovl_parameter_spec[] =
=3D {
>         fsparam_enum("xino",                Opt_xino, ovl_parameter_xino)=
,
>         fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter_b=
ool),
>         fsparam_enum("verity",              Opt_verity, ovl_parameter_ver=
ity),
> +       fsparam_enum("fsync",               Opt_fsync, ovl_parameter_fsyn=
c),
>         fsparam_flag("volatile",            Opt_volatile),
>         fsparam_flag_no("override_creds",   Opt_override_creds),
>         {}
> @@ -665,8 +684,11 @@ static int ovl_parse_param(struct fs_context *fc, st=
ruct fs_parameter *param)
>         case Opt_verity:
>                 config->verity_mode =3D result.uint_32;
>                 break;
> +       case Opt_fsync:
> +               config->fsync_mode =3D result.uint_32;
> +               break;
>         case Opt_volatile:
> -               config->ovl_volatile =3D true;
> +               config->fsync_mode =3D OVL_FSYNC_VOLATILE;
>                 break;
>         case Opt_userxattr:
>                 config->userxattr =3D true;
> @@ -870,9 +892,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context =
*ctx,
>                 config->index =3D false;
>         }
>
> -       if (!config->upperdir && config->ovl_volatile) {
> +       if (!config->upperdir && ovl_is_volatile(config)) {
>                 pr_info("option \"volatile\" is meaningless in a non-uppe=
r mount, ignoring it.\n");
> -               config->ovl_volatile =3D false;
> +               config->fsync_mode =3D ovl_fsync_mode_def();
>         }
>
>         if (!config->upperdir && config->uuid =3D=3D OVL_UUID_ON) {
> @@ -1070,8 +1092,8 @@ int ovl_show_options(struct seq_file *m, struct den=
try *dentry)
>                 seq_printf(m, ",xino=3D%s", ovl_xino_mode(&ofs->config));
>         if (ofs->config.metacopy !=3D ovl_metacopy_def)
>                 seq_printf(m, ",metacopy=3D%s", str_on_off(ofs->config.me=
tacopy));
> -       if (ofs->config.ovl_volatile)
> -               seq_puts(m, ",volatile");
> +       if (ofs->config.fsync_mode !=3D ovl_fsync_mode_def())
> +               seq_printf(m, ",fsync=3D%s", ovl_fsync_mode(&ofs->config)=
);
>         if (ofs->config.userxattr)
>                 seq_puts(m, ",userxattr");
>         if (ofs->config.verity_mode !=3D ovl_verity_mode_def())
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index d4c12feec0392..0822987cfb51c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -776,7 +776,7 @@ static int ovl_make_workdir(struct super_block *sb, s=
truct ovl_fs *ofs,
>          * For volatile mount, create a incompat/volatile/dirty file to k=
eep
>          * track of it.
>          */
> -       if (ofs->config.ovl_volatile) {
> +       if (ovl_is_volatile(&ofs->config)) {
>                 err =3D ovl_create_volatile_dirty(ofs);
>                 if (err < 0) {
>                         pr_err("Failed to create volatile/dirty file.\n")=
;
> --
> 2.53.0
>
