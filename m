Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18627101E4;
	Sat, 20 Jul 2024 07:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721460601; cv=none; b=AsE9FQMPcpGlqSX48F46vdr0RR+i6Y8ay8c+YnxLAnkp0KDTwKYjQCTM/hRTwx956O1iRlfFmPnNOeUZXij+a0dLCkh0LJR3DPLDdpaoJgcVKm5F1Nk1KT97eoDnJqIsnM9BPD3Y4m67S3PiyLgbeevsdH2+St1azsafD+WTeOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721460601; c=relaxed/simple;
	bh=Al6aVfBIhCHFatcLY04iGuUokb1VOXbeb5s3c/cS5cA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qr7ADsZDVpOldvZ+JuDxKCbxgUejEqCYtXw8dZJE6n4HW/jS4o80zE1s8aSUNHFZs/8MPA/u214SoR/9RRGDsttQhlT0bwaCPEgOi4Ck5EGktGDn8O24aPHvo9ZXgnRlq8exE7zLZMDDy2TRr6Ds47v1VfQj6oCJv9Z06l1f0NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QRLu7NNo; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRLu7NNo"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-79f190d8ebfso147909785a.3;
        Sat, 20 Jul 2024 00:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721460599; x=1722065399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KyiEXkg8t9DcsRnslV0Y8YYgPgdR37SamoTZ2OkDN+0=;
        b=QRLu7NNoQxLxdkwnoAE4ycR9Mh4n/sBBw7ZC5vH81pJu7nlz3jy50dDPw95Fb1dWOM
         FJ+hgojas76fTAGfprZQxlBSK1mXm/Pbt/ezry7QlM36TLTO5+1E7GGDCTldP3265Ai+
         +hooijiFkXZyySOjB5tNvZV0sGi4yqGE6J84DvlluPuCn2qBqFMdWkI1coWeb3KafNxn
         rA+sgatdVJrgnmZ/D331RQ6fjuj1cv7dLG6TxYcm42zEHAJUhp72gbrQs0IiwPwTghfY
         G3vDssSJEhD+mfBQZfU+jF8EBPvDW7vKUft5ML5WW0epoiUeX1rcu28RCwJmz4qmHg1i
         5HYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721460599; x=1722065399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KyiEXkg8t9DcsRnslV0Y8YYgPgdR37SamoTZ2OkDN+0=;
        b=vJOjUs2ZGmrAxVhGHIqs5GZoB2MuuW4DjuiAApmyIDqhpBiRJeqDauIx4paIJFF2ED
         5F2R732MN0wohRMcPwvloBm6aIOZVtbNV8AwsG7F2esVOefZAakGua8W/1JszDgLT5jr
         8Z3qY3u0opOO0Wkja5klBmHRuepKJ9XLSMmyp3VKEFwPBUhMQxfvofQvkK2S+uSFo4lD
         dSnHyI+cGh49XFzXm7dLTFQyweRZ9TAwlEAzvB72HdvcDkp/8Y3m+mGcB9F54E4bv25K
         xRkS3qfIG2xytJ8/STdQOyaVjzPJ4zc0Pk5H2m0QNmVCVB9TYIIP25iD7nhP3hpugpH0
         ON3A==
X-Forwarded-Encrypted: i=1; AJvYcCXHwUDd1qgCZzi2nkAjT7tCFB0Aex4frlIpCGVQmKhlZ1BLJSpkEv9dJVsUznBtzFq3fQ6fnWngGTBKS0Ls5pWLLzyNfymIam1b5VuN+HUaHx5MNKJh89RXk+d1M2rprgO1qj57KFBvDktmBA==
X-Gm-Message-State: AOJu0YyYC9vOSCzSsOGkru/3dDbRe465duFQWILl2jJkNa2NLcfuIKk3
	D/Ngif8puV9vdpU4//GPh0rnxeEeACC3HHSnfLTLfMw+hi7uKEJAis8t/M7IAfYcGK1BREn5qAO
	264TV97qQSHsDIVtCBNUFzQcTDyOg66FYBkA=
X-Google-Smtp-Source: AGHT+IEYqptZcG5urZeKyc6aaBYNSpj+IrhzCPzFcYsdPIJnp+UXnPDAue2FooNxPzZQ05Cv//INoq3FnBW87BKmtKc=
X-Received: by 2002:a05:620a:4594:b0:79f:3f6:55d5 with SMTP id
 af79cd13be357-7a1a122f7e0mr240367385a.0.1721460598711; Sat, 20 Jul 2024
 00:29:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240718034316.29844-1-feilv@asrmicro.com> <CAOQ4uxgqdOHJOT--sqf-HLtur6uKyk8mh=dkKzmdf8wupCVPhw@mail.gmail.com>
 <062f7b08f6dd4354877c24ea72e6d430@exch01.asrmicro.com>
In-Reply-To: <062f7b08f6dd4354877c24ea72e6d430@exch01.asrmicro.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 20 Jul 2024 10:29:47 +0300
Message-ID: <CAOQ4uxgC7OJ+TF0Gw-ZdSTpq1goGgfmgWNwsx_hqOwiiFB-UHg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fsync after metadata copy-up via mount option "upsync=strict"
To: =?UTF-8?B?THYgRmVp77yI5ZCV6aOe77yJ?= <feilv@asrmicro.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	=?UTF-8?B?WHUgTGlhbmdode+8iOW+kOiJr+iZju+8iQ==?= <lianghuxu@asrmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 12:55=E2=80=AFPM Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=
=EF=BC=89 <feilv@asrmicro.com> wrote:
>
>
> >
> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Amir Goldstein [mailto:amir73il@gmail.com]
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2024=E5=B9=B47=E6=9C=8819=E6=97=
=A5 15:24
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Lv Fei=EF=BC=88=E5=90=95=E9=A3=9E=EF=BC=89=
 <feilv@asrmicro.com>
> > =E6=8A=84=E9=80=81: miklos@szeredi.hu; linux-unionfs@vger.kernel.org; l=
inux-kernel@vger.kernel.org; Xu Lianghu=EF=BC=88=E5=BE=90=E8=89=AF=E8=99=8E=
=EF=BC=89 > <lianghuxu@asrmicro.com>
> > =E4=B8=BB=E9=A2=98: Re: [PATCH] ovl: fsync after metadata copy-up via m=
ount option "upsync=3Dstrict"
> >
> > On Thu, Jul 18, 2024 at 6:43=E2=80=AFAM Fei Lv <feilv@asrmicro.com> wro=
te:
> > >
> > > If a directory only exist in low layer, create a new file in it
> > > trigger directory copy-up. Permission lost of the new directory in
> > > upper layer was observed during power-cut stress test.
> >
> > You should specify that this outcome happens on very specific upper fs =
(i.e. ubifs) which does not enforce ordering on storing of metadata changes=
.
>
> OK.
>
> >
> > >
> > > Fix by adding new mount opion "upsync=3Dstrict", make sure data/metad=
ata
> > > of copied up directory written to disk before renaming from tmp to
> > > final destination.
> > >
> > > Signed-off-by: Fei Lv <feilv@asrmicro.com>
> > > ---
> > > OPT_sync changed to OPT_upsync since mount option "sync" already used=
.
> >
> > I see. I don't like the name "upsync" so much, it has other meanings ho=
w about using the option "fsync"?
>
> OK.
>
> >
> > Here is a suggested documentation (which should be accompanied to any p=
atch)
>
> OK.
>
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst
> > b/Documentation/filesystems/overlayfs.rst
> > index 165514401441..f8183ddf8c4d 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -742,6 +742,42 @@ controlled by the "uuid" mount option, which suppo=
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
on post system crash.
> > +
> > +Without the fdatasync(2) call, there is no guarantee that the observed
> > +data after a system crash will be either the old or the new data, but
> > +in practice, the observed data after crash is often the old or new dat=
a or a mix of both.
> > +
> > +When overlayfs file is modified for the first time, copy up will creat=
e
> > +a copy of the lower file and its parent directories in the upper layer=
.
> > +In case of a system crash, if fdatasync(2) was not called after the
> > +modification, the upper file could end up with no data at all (i.e.
> > +zeros), which would be an unusual outcome.  To avoid this experience,
> > +overlayfs calls fsync(2) on the upper file before completing the copy =
up with rename(2) to make the copy > up "atomic".
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
> > >
> > >  fs/overlayfs/copy_up.c   | 21 +++++++++++++++++++++
> > >  fs/overlayfs/ovl_entry.h | 20 ++++++++++++++++++--
> > >  fs/overlayfs/params.c    | 33 +++++++++++++++++++++++++++++----
> > >  fs/overlayfs/super.c     |  2 +-
> > >  4 files changed, 69 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c index
> > > a5ef2005a2cc..b6f021ad7a43 100644
> > > --- a/fs/overlayfs/copy_up.c
> > > +++ b/fs/overlayfs/copy_up.c
> > > @@ -243,6 +243,21 @@ static int ovl_verify_area(loff_t pos, loff_t po=
s2, loff_t len, loff_t totlen)
> > >         return 0;
> > >  }
> > >
> > > +static int ovl_copy_up_sync(struct path *path) {
> > > +       struct file *new_file;
> > > +       int err;
> > > +
> > > +       new_file =3D ovl_path_open(path, O_LARGEFILE | O_WRONLY);
> >
> > I don't think any of those O_ flags are needed for fsync.
> > Can a directory be opened O_WRONLY???
>
> This function may be called with file or directory, shall I need to use d=
ifferent
> flags? Such as below:
>
> static int ovl_copy_up_sync(struct path *path, bool is_dir)
> {
>         struct file *new_file;
>         int flags;
>         int err;
>
>         flags =3D is_dir ? (O_RDONLY | O_DIRECTORY) : (O_LARGEFILE | O_WR=
ONLY);
>         new_file =3D ovl_path_open(path, flags);
>         if (IS_ERR(new_file))
>                 return PTR_ERR(new_file);
>
>         err =3D vfs_fsync(new_file, 0);
 >         fput(new_file);
>
>         return err;
> }
>

You do not need O_WRONLY nor O_LARGEFILE for fsync of a regular file
just use O_RDONLY unconditionally.

> >
> > > +       if (IS_ERR(new_file))
> > > +               return PTR_ERR(new_file);
> > > +
> > > +       err =3D vfs_fsync(new_file, 0);
> > > +       fput(new_file);
> > > +
> > > +       return err;
> > > +}
> > > +
> > >  static int ovl_copy_up_file(struct ovl_fs *ofs, struct dentry *dentr=
y,
> > >                             struct file *new_file, loff_t len)  { @@
> > > -701,6 +716,9 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_c=
tx *c, struct dentry *temp)
> > >                 err =3D ovl_set_attr(ofs, temp, &c->stat);
> > >         inode_unlock(temp->d_inode);
> > >
> > > +       if (!err && ovl_should_sync_strict(ofs))
> > > +               err =3D ovl_copy_up_sync(&upperpath);
> > > +
> > >         return err;
> > >  }
> > >
> > > @@ -1104,6 +1122,9 @@ static int ovl_copy_up_meta_inode_data(struct o=
vl_copy_up_ctx *c)
> > >         ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
> > >         ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
> > >         ovl_set_upperdata(d_inode(c->dentry));
> > > +
> > > +       if (!err && ovl_should_sync_strict(ofs))
> > > +               err =3D ovl_copy_up_sync(&upperpath);
> >
> > fsync was probably already called in ovl_copy_up_file() making this cal=
l redundant and fsync of the removal > of metacopy xattr does not add any s=
afety.
>
> My original idea was that ovl_should_sync and ovl_should_sync_strict shou=
ld not be enabled at the same time.

You have it wrong.

The ovl_should_sync() helper does not mean sync_mode=3D=3Dordered,
it means sync_mode!=3Dvolatile
It literally means "should overlayfs respect fsync"
and it is used in several places in the code.

So ovl_should_sync_strict() always implies ovl_should_sync().

> The reasons are as follows:
> If bothe ovl_should_sync and ovl_should_sync_strict return ture for "fsyn=
c=3Dstrict",
> and power cut between ovl_copy_up_file and ovl_copy_up_metadata for file =
copy-up,
> seems this file may also lost permission?

fsync of file in ovl_copy_up_file() the file is either an O_TMPFILE
or in the workdir. no risk involved even with ubifs.

>
> >
> > >  out_free:
> > >         kfree(capability);
> > >  out:
> > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h inde=
x
> > > cb449ab310a7..4592e6f7dcf7 100644
> > > --- a/fs/overlayfs/ovl_entry.h
> > > +++ b/fs/overlayfs/ovl_entry.h
> > > @@ -5,6 +5,12 @@
> > >   * Copyright (C) 2016 Red Hat, Inc.
> > >   */
> > >
> > > +enum {
> > > +       OVL_SYNC_DATA,
> > > +       OVL_SYNC_STRICT,
> > > +       OVL_SYNC_OFF,
> > > +};
> > > +
> > >  struct ovl_config {
> > >         char *upperdir;
> > >         char *workdir;
> > > @@ -18,7 +24,7 @@ struct ovl_config {
> > >         int xino;
> > >         bool metacopy;
> > >         bool userxattr;
> > > -       bool ovl_volatile;
> > > +       int sync_mode;
> > >  };
> > >
> > >  struct ovl_sb {
> > > @@ -120,7 +126,17 @@ static inline struct ovl_fs *OVL_FS(struct
> > > super_block *sb)
> > >
> > >  static inline bool ovl_should_sync(struct ovl_fs *ofs)  {
> > > -       return !ofs->config.ovl_volatile;
> > > +       return ofs->config.sync_mode =3D=3D OVL_SYNC_DATA;
> >
> >     return ofs->config.sync_mode !=3D OVL_SYNC_OFF; or
> >     return ofs->config.sync_mode !=3D OVL_FSYNC_VOLATILE;
>
> There are risks if ovl_should_sync and ovl_should_sync_strict enabled at =
the same time.
> The reasons are above.
>

No. see above.

Let me know if I misunderstood your concern.

Thanks,
Amir.
