Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11441156C6A;
	Fri, 23 Aug 2024 09:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724406726; cv=none; b=cK2KAGawdjRj3mcB6md3gVTKL8mMeTpTM4LVUp2b+MpzB85lVOFBu9t7GoecZvjakdd2mllOMh5JXL7VeXucPFxVIDsgc7lREtdVq7rA6nkboQ9G6eDOZaCvGFrSLjxCAiIknIuZQz7Sr3uLBSMG6+Ik3jA+2HqWdeyQ3yNwu3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724406726; c=relaxed/simple;
	bh=l7yJBmBJaUXRDvUA/wvOnInGRqHbvu8UAxKW1P23waY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KgV+I3HTC5eaC4BwXCMCENOEBDCo2Lllie6zuPN1C0tKyO22cqteesTmGJZdt+cSHfclJwJyguyE4/9iyTxk5lwBo9/wFdjdqwbdb338dwVGVBenOmdZAeqotd67ZXE5z6y6huSvmCd5hZW6UW7aKmiiBzQAachnikSGGkyvpnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K6Z6EuYG; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K6Z6EuYG"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7a1dac7f0b7so106476885a.0;
        Fri, 23 Aug 2024 02:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724406724; x=1725011524; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KF+oKewm8qGzODrWrtagmzMY3xL2amYeuybX44SPuqA=;
        b=K6Z6EuYGwks/1HN1BWjWP9CPXlJqDvPwbrfGJ1TSRlJxN7I9RsF2qSNI7dbziKHAdB
         q14PZlidud1REzSRT3xU3i1a73F8c1rBZYFnqAyTGQocsTTSE0gpOuNT8ox0wFZAWal6
         lgnrOQ9tKJTZlYk1JAXB+DLOA1VoqcdNSHBWdqfk+WYqE5QKNqRY7C/WXXuen8pSmgmk
         yrP0CN4jHqeijIXTewy4iDjldfgGI4t66Afvd62vGERHRdTPmrWzdofVzeOUXFGgIzV4
         1UZU86lmC2Eq+gRaKU37mgVcy1bxFGN4pf38/RQDNyiEf4O11E9XskT12ktosYgjgzQM
         2UfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724406724; x=1725011524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KF+oKewm8qGzODrWrtagmzMY3xL2amYeuybX44SPuqA=;
        b=kDaQBDmWnK+1AX/47T11EYMUCXfMQTBq48nkSQSd9fZWHsBjZG5MyxfdrxXfQYsHDd
         +OgMIzK/W47odYnjioMDRVDOJObeoljNe/LqEsigAonkwfsTQlXqe4/ePVRhYv2WW1SN
         Al8pgnHihl2XY8lo7IDENIcrPejaD2Zq+2GFQlRaNzjiJDKhvEHgqeZXvcQQsmn8IuTu
         uvJhGo0nMzYcwpjNGoJ7HRbtvcZZ098CYNQl+I3RH11aI82ccgvUrvpYk20UKf2yEUQo
         Mz6Q3drGdpnH4ZtRbQ8bel+DWWgPeRqXYTpDC5Ea6WDvcyNdShK7I3JEsLRjUe5von28
         flZg==
X-Forwarded-Encrypted: i=1; AJvYcCU8iGX/Tk0M2POKKWDIptMOBLONkf05hXdv9EVwEJx5RKWJlGfQrc0fYCOYwMnam0RyfX6WR+nj3MnK0JA=@vger.kernel.org, AJvYcCVyx1/MNYGllEqk0s9k21eU/xhn9bsLr+rVSrZWQ51zVC1sRiCGVgGUqU+yCxhJrnlZcJPIVOUAu0xB/bH4EA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxiDnD0OJL0EmGC+p47uJrAyPL5VmwT/Yf9NY3sl6WXJpawiKlu
	mHMZDqAATp0UTpVxZaTf4+cHjon8eSEKSK1xEgMpdXrmvfP4fGUmmnzDdOPwXwsJdKc0abhVA/J
	p8B58mS/VpxtURM2SmtRTzFXm7y8=
X-Google-Smtp-Source: AGHT+IE+9MBFTTaSe+4WuRyxsnhB5OGDZHuXsre4gh9ylJWGjTQWe1eUjoCdyr6dNFddSWm3li6jfQEPQduY+civgcE=
X-Received: by 2002:a05:620a:2547:b0:7a2:c2a:c9f8 with SMTP id
 af79cd13be357-7a6896e3b1fmr170597485a.1.1724406723456; Fri, 23 Aug 2024
 02:52:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240722101443.10768-1-feilv@asrmicro.com> <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhP03BHK8gDmeySxkacGvy9BToZkb5nTgaegWxJPAuG8A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Aug 2024 11:51:52 +0200
Message-ID: <CAOQ4uxgbbadOC_LCYRk-muFKYH3QNVnD+ZEH+si-V1i3En66Bw@mail.gmail.com>
Subject: Re: [PATCH V2] ovl: fsync after metadata copy-up via mount option "fsync=strict"
To: Fei Lv <feilv@asrmicro.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lianghuxu@asrmicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2024 at 3:56=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Jul 22, 2024 at 1:14=E2=80=AFPM Fei Lv <feilv@asrmicro.com> wrote=
:
> >
> > For upper filesystem which does not enforce ordering on storing of
> > metadata changes(e.g. ubifs), when overlayfs file is modified for
> > the first time, copy up will create a copy of the lower file and
> > its parent directories in the upper layer. Permission lost of the
> > new upper parent directory was observed during power-cut stress test.
> >
> > Fix by adding new mount opion "fsync=3Dstrict", make sure data/metadata=
 of
> > copied up directory written to disk before renaming from tmp to final
> > destination.
> >
> > Signed-off-by: Fei Lv <feilv@asrmicro.com>
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> but I'd also like to wait for an ACK from Miklos on this feature.
>
> As for timing, we are in the middle of the merge window for 6.11-rc1,
> so we have some time before this can be considered for 6.12.
> I will be on vacation for most of this development cycle, so either
> Miklos will be able to queue it for 6.12 or I may be able to do
> near the end of the 6.11 cycle.
>

Miklos,

Please let me know what you think of this approach to handle ubifs upper.
If you like it, I can queue this up for v6.12.

Thanks,
Amir.

>
> > ---
> > V1 -> V2:
> >  1. change open flags from "O_LARGEFILE | O_WRONLY" to "O_RDONLY".
> >  2. change mount option to "fsync=3Dordered/strict/volatile".
> >  3. ovl_should_sync_strict() implies ovl_should_sync().
> >  4. remove redundant ovl_should_sync_strict from ovl_copy_up_meta_inode=
_data.
> >  5. update commit log.
> >  6. update documentation overlayfs.rst.
> >
> >  Documentation/filesystems/overlayfs.rst | 39 +++++++++++++++++++++++++
> >  fs/overlayfs/copy_up.c                  | 18 ++++++++++++
> >  fs/overlayfs/ovl_entry.h                | 20 +++++++++++--
> >  fs/overlayfs/params.c                   | 33 ++++++++++++++++++---
> >  fs/overlayfs/super.c                    |  2 +-
> >  5 files changed, 105 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/fi=
lesystems/overlayfs.rst
> > index 165514401441..a783e57bdb57 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -742,6 +742,45 @@ controlled by the "uuid" mount option, which suppo=
rts these values:
> >      mounted with "uuid=3Don".
> >
> >
> > +Durability and copy up
> > +----------------------
> > +
> > +The fsync(2) and fdatasync(2) system calls ensure that the metadata an=
d
> > +data of a file, respectively, are safely written to the backing
> > +storage, which is expected to guarantee the existence of the informati=
on post
> > +system crash.
> > +
> > +Without the fdatasync(2) call, there is no guarantee that the observed
> > +data after a system crash will be either the old or the new data, but
> > +in practice, the observed data after crash is often the old or new dat=
a or a
> > +mix of both.
> > +
> > +When overlayfs file is modified for the first time, copy up will creat=
e
> > +a copy of the lower file and its parent directories in the upper layer=
.
> > +In case of a system crash, if fdatasync(2) was not called after the
> > +modification, the upper file could end up with no data at all (i.e.
> > +zeros), which would be an unusual outcome.  To avoid this experience,
> > +overlayfs calls fsync(2) on the upper file before completing the copy =
up with
> > +rename(2) to make the copy up "atomic".
> > +
> > +Depending on the backing filesystem (e.g. ubifs), fsync(2) before
> > +rename(2) may not be enough to provide the "atomic" copy up behavior
> > +and fsync(2) on the copied up parent directories is required as well.
> > +
> > +Overlayfs can be tuned to prefer performance or durability when storin=
g
> > +to the underlying upper layer.  This is controlled by the "fsync" moun=
t
> > +option, which supports these values:
> > +
> > +- "ordered": (default)
> > +    Call fsync(2) on upper file before completion of copy up.
> > +- "strict":
> > +    Call fsync(2) on upper file and directories before completion of c=
opy up.
> > +- "volatile": [*]
> > +    Prefer performance over durability (see `Volatile mount`_)
> > +
> > +[*] The mount option "volatile" is an alias to "fsync=3Dvolatile".
> > +
> > +
> >  Volatile mount
> >  --------------
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index a5ef2005a2cc..d99a18afceb8 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -243,6 +243,21 @@ static int ovl_verify_area(loff_t pos, loff_t pos2=
, loff_t len, loff_t totlen)
> >         return 0;
> >  }
> >
> > +static int ovl_copy_up_sync(struct path *path)
> > +{
> > +       struct file *new_file;
> > +       int err;
> > +
> > +       new_file =3D ovl_path_open(path, O_RDONLY);
> > +       if (IS_ERR(new_file))
> > +               return PTR_ERR(new_file);
> > +
> > +       err =3D vfs_fsync(new_file, 0);
> > +       fput(new_file);
> > +
> > +       return err;
> > +}
> > +
> >  static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentry,
> >                             struct file *new_file, loff_t len)
> >  {
> > @@ -701,6 +716,9 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_=
ctx *c, struct dentry *temp)
> >                 err =3D ovl_set_attr(ofs, temp, &c->stat);
> >         inode_unlock(temp->d_inode);
> >
> > +       if (!err && ovl_should_sync_strict(ofs))
> > +               err =3D ovl_copy_up_sync(&upperpath);
> > +
> >         return err;
> >  }
> >
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index cb449ab310a7..7f6d2effd5f1 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -5,6 +5,12 @@
> >   * Copyright (C) 2016 Red Hat, Inc.
> >   */
> >
> > +enum {
> > +       OVL_FSYNC_ORDERED,
> > +       OVL_FSYNC_STRICT,
> > +       OVL_FSYNC_VOLATILE,
> > +};
> > +
> >  struct ovl_config {
> >         char *upperdir;
> >         char *workdir;
> > @@ -18,7 +24,7 @@ struct ovl_config {
> >         int xino;
> >         bool metacopy;
> >         bool userxattr;
> > -       bool ovl_volatile;
> > +       int fsync_mode;
> >  };
> >
> >  struct ovl_sb {
> > @@ -120,7 +126,17 @@ static inline struct ovl_fs *OVL_FS(struct super_b=
lock *sb)
> >
> >  static inline bool ovl_should_sync(struct ovl_fs *ofs)
> >  {
> > -       return !ofs->config.ovl_volatile;
> > +       return ofs->config.fsync_mode !=3D OVL_FSYNC_VOLATILE;
> > +}
> > +
> > +static inline bool ovl_should_sync_strict(struct ovl_fs *ofs)
> > +{
> > +       return ofs->config.fsync_mode =3D=3D OVL_FSYNC_STRICT;
> > +}
> > +
> > +static inline bool ovl_is_volatile(struct ovl_config *config)
> > +{
> > +       return config->fsync_mode =3D=3D OVL_FSYNC_VOLATILE;
> >  }
> >
> >  static inline unsigned int ovl_numlower(struct ovl_entry *oe)
> > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > index 4860fcc4611b..c4aac288b7e0 100644
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -58,6 +58,7 @@ enum ovl_opt {
> >         Opt_xino,
> >         Opt_metacopy,
> >         Opt_verity,
> > +       Opt_fsync,
> >         Opt_volatile,
> >  };
> >
> > @@ -139,6 +140,23 @@ static int ovl_verity_mode_def(void)
> >         return OVL_VERITY_OFF;
> >  }
> >
> > +static const struct constant_table ovl_parameter_fsync[] =3D {
> > +       { "ordered",    OVL_FSYNC_ORDERED  },
> > +       { "strict",     OVL_FSYNC_STRICT   },
> > +       { "volatile",   OVL_FSYNC_VOLATILE },
> > +       {}
> > +};
> > +
> > +static const char *ovl_fsync_mode(struct ovl_config *config)
> > +{
> > +       return ovl_parameter_fsync[config->fsync_mode].name;
> > +}
> > +
> > +static int ovl_fsync_mode_def(void)
> > +{
> > +       return OVL_FSYNC_ORDERED;
> > +}
> > +
> >  const struct fs_parameter_spec ovl_parameter_spec[] =3D {
> >         fsparam_string_empty("lowerdir",    Opt_lowerdir),
> >         fsparam_string("lowerdir+",         Opt_lowerdir_add),
> > @@ -154,6 +172,7 @@ const struct fs_parameter_spec ovl_parameter_spec[]=
 =3D {
> >         fsparam_enum("xino",                Opt_xino, ovl_parameter_xin=
o),
> >         fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter=
_bool),
> >         fsparam_enum("verity",              Opt_verity, ovl_parameter_v=
erity),
> > +       fsparam_enum("fsync",               Opt_fsync, ovl_parameter_fs=
ync),
> >         fsparam_flag("volatile",            Opt_volatile),
> >         {}
> >  };
> > @@ -617,8 +636,11 @@ static int ovl_parse_param(struct fs_context *fc, =
struct fs_parameter *param)
> >         case Opt_verity:
> >                 config->verity_mode =3D result.uint_32;
> >                 break;
> > +       case Opt_fsync:
> > +               config->fsync_mode =3D result.uint_32;
> > +               break;
> >         case Opt_volatile:
> > -               config->ovl_volatile =3D true;
> > +               config->fsync_mode =3D OVL_FSYNC_VOLATILE;
> >                 break;
> >         case Opt_userxattr:
> >                 config->userxattr =3D true;
> > @@ -802,9 +824,9 @@ int ovl_fs_params_verify(const struct ovl_fs_contex=
t *ctx,
> >                 config->index =3D false;
> >         }
> >
> > -       if (!config->upperdir && config->ovl_volatile) {
> > +       if (!config->upperdir && ovl_is_volatile(config)) {
> >                 pr_info("option \"volatile\" is meaningless in a non-up=
per mount, ignoring it.\n");
> > -               config->ovl_volatile =3D false;
> > +               config->fsync_mode =3D ovl_fsync_mode_def();
> >         }
> >
> >         if (!config->upperdir && config->uuid =3D=3D OVL_UUID_ON) {
> > @@ -997,8 +1019,11 @@ int ovl_show_options(struct seq_file *m, struct d=
entry *dentry)
> >         if (ofs->config.metacopy !=3D ovl_metacopy_def)
> >                 seq_printf(m, ",metacopy=3D%s",
> >                            ofs->config.metacopy ? "on" : "off");
> > -       if (ofs->config.ovl_volatile)
> > +       if (ovl_is_volatile(&ofs->config))
> >                 seq_puts(m, ",volatile");
> > +       else if (ofs->config.fsync_mode !=3D ovl_fsync_mode_def())
> > +               seq_printf(m, ",fsync=3D%s",
> > +                          ovl_fsync_mode(&ofs->config));
> >         if (ofs->config.userxattr)
> >                 seq_puts(m, ",userxattr");
> >         if (ofs->config.verity_mode !=3D ovl_verity_mode_def())
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 06a231970cb5..824cbcf40523 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -750,7 +750,7 @@ static int ovl_make_workdir(struct super_block *sb,=
 struct ovl_fs *ofs,
> >          * For volatile mount, create a incompat/volatile/dirty file to=
 keep
> >          * track of it.
> >          */
> > -       if (ofs->config.ovl_volatile) {
> > +       if (ovl_is_volatile(&ofs->config)) {
> >                 err =3D ovl_create_volatile_dirty(ofs);
> >                 if (err < 0) {
> >                         pr_err("Failed to create volatile/dirty file.\n=
");
> >
> > base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
> > --
> > 2.45.2
> >
