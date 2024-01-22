Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6633DB8B
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 11:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705921794; cv=none; b=XcUU07r1/EpdEp29CDySYUAvC7GtOwWq1er8puMtQItrzGsl/ZLwgp5lRvFQYX/6TVuc5Q7oo1LYdXmTAwtZXzDWsBr2/ggvDQDL2uQsxw9XWrn2eA/7cAjMl42zjmYM+nfI1ElXNssSlKmEbM0ktxEKlvzubUhLDGOzY0B7BHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705921794; c=relaxed/simple;
	bh=VrG0zme86WIq40hBoG4MgrssTkXY3l90lLl5v+Uhh8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V4sRHZlx3DGgiYFUITk7ZcoB8mpdi+5nsIsybT7duqBDTEICaHH2Lnz4yBjiH31/NFoa/yFr0g4SsxNwWvRx3V5ofgCEVCirbwk1/Qn00N2TShI8spil7a/tUKgx/LxSpu5pyJvtVOxqkcNS1L/k6smFqFC6/RzOPlAYJzF3l1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvpmoiqV; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvpmoiqV"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-68198aa2c7fso15979326d6.3
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 03:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705921791; x=1706526591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bdKl3nZ6Qk8yZrvWRXO+gTh1NPQzW6W8mTKgW1LTNk=;
        b=gvpmoiqVLN2xIvdYlGvqt99K3p6yLESsT59LtF97MEA15mdQEd62QzPwIQt2rPEPWf
         MHYJOB42NKAy7tXJMUS36majGozfDxSsm9IV6pkXRk4Xmtk4aAvPngW4XhbDbe9SbkTK
         vYYyrPIzHirSVqzXb1RQIkvMWspiBckmr/sibcCe55O+pBwYO6yBzwrmMbOwSwRp/sxy
         UOP/LnGZ3rDI6hVkpCa7khbpTlUrrOdhtb8LHtwo8+X8dhkbtv0mCWlfq5h7qjdXC4Hl
         VWqk7f3U2hfQJo3Em+b4neE/MnawfZQcZ5LO8dDTh4LjiwLCaEO7USkfwLDEXVrShjWR
         5egA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705921791; x=1706526591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7bdKl3nZ6Qk8yZrvWRXO+gTh1NPQzW6W8mTKgW1LTNk=;
        b=YmDf4NOdmaesa+xWrL/okxAKMz1CgYGKlaqdQ2xb3oFnIXdRxI/GKP9XVcWetl4zsq
         cKc2Kcz1lEJoNT26YUfxBI55xKbODbAbpC5fan0a7MkivohwExhCy1hAP+zGiH6s0SFW
         zlnitqY5JHvY5sMsbGeYOZcmbf2wEyH1UGDjLZFZxPwW996eAwVQhnHmbvVjpRe1z9dn
         2pGnXcTBk7oS4O85TIH8mIg8wGUK0tFN2PyJPPTI+2v2gJ/ZZRPnFfbGiJqO6ZMFr8I6
         bpds8vc4Y5N+ikaAztg7cofYoz/Rln03YzdkGZQojEUgYjFCXf4yIgu0F8CT6EDfPLdK
         k7Hg==
X-Gm-Message-State: AOJu0Yyhx9r7x6NIHUMQqopqIWFaol7rKt1rhQcng77nBdSE30aTkbEY
	eqnxMbR4tGXb5Hx2EtD28QfvuNbn5or16cjwON1BV6DgwLne1iiB3xTAnwQnOJUoFWrlJTOoHMP
	borbkC1uv+FuwvhXRFDaaHUzcfC4=
X-Google-Smtp-Source: AGHT+IGuibu+auzZr5qN3KnWqj4IxuJhyuHg99a95SiTvEdh5av5qAaIJgpzL9o82wK2xxs5iJaNTsWi4GPr3DSg/OM=
X-Received: by 2002:a05:6214:5197:b0:686:9442:6a66 with SMTP id
 kl23-20020a056214519700b0068694426a66mr876778qvb.28.1705921790963; Mon, 22
 Jan 2024 03:09:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121150532.313567-1-amir73il@gmail.com> <3679657b0589ee31d09fb9db140fe57121989a69.camel@redhat.com>
In-Reply-To: <3679657b0589ee31d09fb9db140fe57121989a69.camel@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 22 Jan 2024 13:09:39 +0200
Message-ID: <CAOQ4uxh5x_-1j8HViCutVkghA1Uh-va+kJshCuvB+ep7WjmOFg@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Alexander Larsson <alexl@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2024 at 12:14=E2=80=AFPM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> On Sun, 2024-01-21 at 17:05 +0200, Amir Goldstein wrote:
> > An opaque directory cannot have xwhiteouts, so instead of marking an
> > xwhiteouts directory with a new xattr, overload overlay.opaque xattr
> > for marking both opaque dir ('y') and xwhiteouts dir ('x').
> >
> > This is more efficient as the overlay.opaque xattr is checked during
> > lookup of directory anyway.
> >
> > This also prevents unnecessary checking the xattr when reading a
> > directory without xwhiteouts, i.e. most of the time.
> >
> > Note that the xwhiteouts marker is not checked on the upper layer and
> > on the last layer in lowerstack, where xwhiteouts are not expected.
> >
> > Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
> > Cc: <stable@vger.kernel.org> # v6.7
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos,
> >
> > Alex has reported a problem with your suggested approach of requiring
> > xwhiteouts xattr on layers root dir [1].
> >
> > Following counter proposal, amortizes the cost of checking opaque
> > xattr
> > on directories during lookup to also check for xwhiteouts.
> >
> > This change requires the following change to test overlay/084:
> >
> > --- a/tests/overlay/084
> > +++ b/tests/overlay/084
> > @@ -115,7 +115,8 @@ do_test_xwhiteout()
> >
> >         mkdir -p $basedir/lower $basedir/upper $basedir/work
> >         touch $basedir/lower/regular $basedir/lower/hidden
> > $basedir/upper/hidden
> > -       setfattr -n $prefix.overlay.whiteouts -v "y" $basedir/upper
> > +       # overlay.opaque=3D"x" means directory has xwhiteout children
> > +       setfattr -n $prefix.overlay.opaque -v "x" $basedir/upper
> >         setfattr -n $prefix.overlay.whiteout -v "y"
> > $basedir/upper/hidden
> >
> >
> > Alex,
> >
> > Please let us know if this change is acceptable for composefs.
>
> Yes, this looks very good to me. (Minor comments below)
> I'll do some testing on this.
>

Excellent, I'll be expecting your RVB/Tested-by.

> >
> > Thanks,
> > Amir.
> >
> > [1]
> > https://lore.kernel.org/linux-unionfs/5ee3a210f8f4fc89cb750b3d1a378a0ff=
0187c9f.camel@redhat.com/
> >
> >  fs/overlayfs/namei.c     | 32 +++++++++++++++++++-------------
> >  fs/overlayfs/overlayfs.h | 17 +++++++++++++----
> >  fs/overlayfs/ovl_entry.h |  2 ++
> >  fs/overlayfs/readdir.c   |  5 +++--
> >  fs/overlayfs/super.c     |  9 +++++++++
> >  fs/overlayfs/util.c      | 34 ++++++++++++++--------------------
> >  6 files changed, 60 insertions(+), 39 deletions(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 984ffdaeed6c..caccf3803796 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -18,10 +18,11 @@
> >
> >  struct ovl_lookup_data {
> >       struct super_block *sb;
> > -     struct vfsmount *mnt;
> > +     const struct ovl_layer *layer;
> >       struct qstr name;
> >       bool is_dir;
> >       bool opaque;
> > +     bool xwhiteouts;
> >       bool stop;
> >       bool last;
> >       char *redirect;
> > @@ -201,17 +202,13 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs
> > *ofs, struct ovl_fh *fh,
> >       return real;
> >  }
> >
> > -static bool ovl_is_opaquedir(struct ovl_fs *ofs, const struct path
> > *path)
> > -{
> > -     return ovl_path_check_dir_xattr(ofs, path,
> > OVL_XATTR_OPAQUE);
> > -}
> > -
> >  static struct dentry *ovl_lookup_positive_unlocked(struct
> > ovl_lookup_data *d,
> >                                                  const char *name,
> >                                                  struct dentry
> > *base, int len,
> >                                                  bool
> > drop_negative)
> >  {
> > -     struct dentry *ret =3D lookup_one_unlocked(mnt_idmap(d->mnt),
> > name, base, len);
> > +     struct dentry *ret =3D lookup_one_unlocked(mnt_idmap(d->layer-
> > >mnt), name,
> > +                                              base, len);
> >
> >       if (!IS_ERR(ret) && d_flags_negative(smp_load_acquire(&ret-
> > >d_flags))) {
> >               if (drop_negative && ret->d_lockref.count =3D=3D 1) {
> > @@ -232,10 +229,13 @@ static int ovl_lookup_single(struct dentry
> > *base, struct ovl_lookup_data *d,
> >                            size_t prelen, const char *post,
> >                            struct dentry **ret, bool
> > drop_negative)
> >  {
> > +     struct ovl_fs *ofs =3D OVL_FS(d->sb);
> >       struct dentry *this;
> >       struct path path;
> >       int err;
> >       bool last_element =3D !post[0];
> > +     bool is_upper =3D d->layer->idx =3D=3D 0;
> > +     char val;
> >
> >       this =3D ovl_lookup_positive_unlocked(d, name, base, namelen,
> > drop_negative);
> >       if (IS_ERR(this)) {
> > @@ -253,8 +253,8 @@ static int ovl_lookup_single(struct dentry *base,
> > struct ovl_lookup_data *d,
> >       }
> >
> >       path.dentry =3D this;
> > -     path.mnt =3D d->mnt;
> > -     if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
> > +     path.mnt =3D d->layer->mnt;
> > +     if (ovl_path_is_whiteout(ofs, &path)) {
> >               d->stop =3D d->opaque =3D true;
> >               goto put_and_out;
> >       }
> > @@ -272,7 +272,7 @@ static int ovl_lookup_single(struct dentry *base,
> > struct ovl_lookup_data *d,
> >                       d->stop =3D true;
> >                       goto put_and_out;
> >               }
> > -             err =3D ovl_check_metacopy_xattr(OVL_FS(d->sb), &path,
> > NULL);
> > +             err =3D ovl_check_metacopy_xattr(ofs, &path, NULL);
> >               if (err < 0)
> >                       goto out_err;
> >
> > @@ -292,7 +292,11 @@ static int ovl_lookup_single(struct dentry
> > *base, struct ovl_lookup_data *d,
> >               if (d->last)
> >                       goto out;
> >
> > -             if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
> > +             /* overlay.opaque=3Dx means xwhiteouts directory */
> > +             val =3D ovl_get_opaquedir_val(ofs, &path);
> > +             if (last_element && !is_upper && val =3D=3D 'x') {
> > +                     d->xwhiteouts =3D true;
> > +             } else if (val =3D=3D 'y') {
> >                       d->stop =3D true;
> >                       if (last_element)
> >                               d->opaque =3D true;
> > @@ -1055,7 +1059,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> > struct dentry *dentry,
> >       old_cred =3D ovl_override_creds(dentry->d_sb);
> >       upperdir =3D ovl_dentry_upper(dentry->d_parent);
> >       if (upperdir) {
> > -             d.mnt =3D ovl_upper_mnt(ofs);
> > +             d.layer =3D &ofs->layers[0];
> >               err =3D ovl_lookup_layer(upperdir, &d, &upperdentry,
> > true);
> >               if (err)
> >                       goto out;
> > @@ -1111,7 +1115,7 @@ struct dentry *ovl_lookup(struct inode *dir,
> > struct dentry *dentry,
> >               else if (d.is_dir || !ofs->numdatalayer)
> >                       d.last =3D lower.layer->idx =3D=3D
> > ovl_numlower(roe);
> >
> > -             d.mnt =3D lower.layer->mnt;
> > +             d.layer =3D lower.layer;
> >               err =3D ovl_lookup_layer(lower.dentry, &d, &this,
> > false);
> >               if (err)
> >                       goto out_put;
> > @@ -1278,6 +1282,8 @@ struct dentry *ovl_lookup(struct inode *dir,
> > struct dentry *dentry,
> >
> >       if (upperopaque)
> >               ovl_dentry_set_opaque(dentry);
> > +     if (d.xwhiteouts)
> > +             ovl_dentry_set_xwhiteouts(dentry);
> >
> >       if (upperdentry)
> >               ovl_dentry_set_upper_alias(dentry);
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index 5ba11eb43767..410b3bfc3afc 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -70,6 +70,8 @@ enum ovl_entry_flag {
> >       OVL_E_UPPER_ALIAS,
> >       OVL_E_OPAQUE,
> >       OVL_E_CONNECTED,
> > +     /* Lower stack may contain xwhiteout entries */
> > +     OVL_E_XWHITEOUTS,
> >  };
> >
> >  enum {
> > @@ -476,6 +478,8 @@ void ovl_dentry_clear_flag(unsigned long flag,
> > struct dentry *dentry);
> >  bool ovl_dentry_test_flag(unsigned long flag, struct dentry
> > *dentry);
> >  bool ovl_dentry_is_opaque(struct dentry *dentry);
> >  bool ovl_dentry_is_whiteout(struct dentry *dentry);
> > +bool ovl_dentry_is_xwhiteouts(struct dentry *dentry);
> > +void ovl_dentry_set_xwhiteouts(struct dentry *dentry);
> >  void ovl_dentry_set_opaque(struct dentry *dentry);
> >  bool ovl_dentry_has_upper_alias(struct dentry *dentry);
> >  void ovl_dentry_set_upper_alias(struct dentry *dentry);
> > @@ -494,11 +498,10 @@ struct file *ovl_path_open(const struct path
> > *path, int flags);
> >  int ovl_copy_up_start(struct dentry *dentry, int flags);
> >  void ovl_copy_up_end(struct dentry *dentry);
> >  bool ovl_already_copied_up(struct dentry *dentry, int flags);
> > -bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path
> > *path,
> > -                           enum ovl_xattr ox);
> > +char ovl_get_dir_xattr_val(struct ovl_fs *ofs, const struct path
> > *path,
> > +                        enum ovl_xattr ox);
> >  bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct
> > path *path);
> >  bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct
> > path *path);
> > -bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const
> > struct path *path);
> >  bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
> >                        const struct path *upperpath);
> >
> > @@ -573,7 +576,13 @@ static inline bool ovl_is_impuredir(struct
> > super_block *sb,
> >               .mnt =3D ovl_upper_mnt(ofs),
> >       };
> >
> > -     return ovl_path_check_dir_xattr(ofs, &upperpath,
> > OVL_XATTR_IMPURE);
> > +     return ovl_get_dir_xattr_val(ofs, &upperpath,
> > OVL_XATTR_IMPURE) =3D=3D 'y';
> > +}
> > +
> > +static inline char ovl_get_opaquedir_val(struct ovl_fs *ofs,
> > +                                      const struct path *path)
> > +{
> > +     return ovl_get_dir_xattr_val(ofs, path, OVL_XATTR_OPAQUE);
> >  }
> >
> >  static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 5fa9c58af65f..0b7b21745ba3 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -86,6 +86,8 @@ struct ovl_fs {
> >       /* Shared whiteout cache */
> >       struct dentry *whiteout;
> >       bool no_shared_whiteout;
> > +     /* xwhiteouts may exist in lower layers */
> > +     bool xwhiteouts;
>
> This comment is a bit off, this is now only used for the root dir.
>
> >       /* r/o snapshot of upperdir sb's only taken on volatile
> > mounts */
> >       errseq_t errseq;
> >  };
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index e71156baa7bc..edef4e3401de 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -165,7 +165,8 @@ static struct ovl_cache_entry
> > *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
> >       p->is_upper =3D rdd->is_upper;
> >       p->is_whiteout =3D false;
> >       /* Defer check for overlay.whiteout to ovl_iterate() */
> > -     p->check_xwhiteout =3D rdd->in_xwhiteouts_dir && d_type =3D=3D
> > DT_REG;
> > +     p->check_xwhiteout =3D rdd->in_xwhiteouts_dir &&
> > +                         !rdd->is_upper && d_type =3D=3D DT_REG;
> >
>
> Maybe we can move the is_upper check to where we set in_xwhiteouts_dir?
>
> >       if (d_type =3D=3D DT_CHR) {
> >               p->next_maybe_whiteout =3D rdd->first_maybe_whiteout;
> > @@ -306,7 +307,7 @@ static inline int ovl_dir_read(const struct path
> > *realpath,
> >               return PTR_ERR(realfile);
> >
> >       rdd->in_xwhiteouts_dir =3D rdd->dentry &&
> > -             ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry-
> > >d_sb), realpath);
> > +             ovl_dentry_is_xwhiteouts(rdd->dentry);
>
> Now that the xwhiteout flag is on the dentry, it will be set for all
> layers. Maybe we can avoid setting in_whiteouts_dir for the lowermost
> layer?
>

Applied this diff and pushed to the ovl-fixes branch.

Will wait for ACK from Miklos before sending PR.

Thanks,
Amir.


diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 0b7b21745ba3..c089e5ff37b5 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -86,7 +86,7 @@ struct ovl_fs {
        /* Shared whiteout cache */
        struct dentry *whiteout;
        bool no_shared_whiteout;
-       /* xwhiteouts may exist in lower layers */
+       /* xwhiteouts may exist in lower layer root dirs */
        bool xwhiteouts;
        /* r/o snapshot of upperdir sb's only taken on volatile mounts */
        errseq_t errseq;
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index edef4e3401de..3168e851ca1f 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -165,8 +165,7 @@ static struct ovl_cache_entry
*ovl_cache_entry_new(struct ovl_readdir_data *rdd,
        p->is_upper =3D rdd->is_upper;
        p->is_whiteout =3D false;
        /* Defer check for overlay.whiteout to ovl_iterate() */
-       p->check_xwhiteout =3D rdd->in_xwhiteouts_dir &&
-                           !rdd->is_upper && d_type =3D=3D DT_REG;
+       p->check_xwhiteout =3D rdd->in_xwhiteouts_dir && d_type =3D=3D DT_R=
EG;

        if (d_type =3D=3D DT_CHR) {
                p->next_maybe_whiteout =3D rdd->first_maybe_whiteout;
@@ -306,8 +305,9 @@ static inline int ovl_dir_read(const struct path *realp=
ath,
        if (IS_ERR(realfile))
                return PTR_ERR(realfile);

-       rdd->in_xwhiteouts_dir =3D rdd->dentry &&
-               ovl_dentry_is_xwhiteouts(rdd->dentry);
+       /* No need to check for xwhiteouts in upper and lowermost layers */
+       rdd->in_xwhiteouts_dir =3D !rdd->is_upper && !rdd->is_lowest &&
+               rdd->dentry && ovl_dentry_is_xwhiteouts(rdd->dentry);
        rdd->first_maybe_whiteout =3D NULL;
        rdd->ctx.pos =3D 0;
