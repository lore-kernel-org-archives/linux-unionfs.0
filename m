Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794069619;
	b=JmEbPWntywnQgAz2EhpBervu9Mtnuxx7hGyIt5JsBhDvZY9xhjU9qHiHRA7/ysBhlPnW
	 ISHhziVcLZm3L4VN4w+2CggP8beex/IHRP+P6LItACVka2cv5lMUqBczAHqkh/WJtV8St
	 ZME50gYyQ1tcBEh5jLKjGxtAbhlI2M+Pp8uGYxDom6pfObRTDZCRdUBeTazeHPO97NS+j
	 L0vq8mYZtc2OkBkHH01afPWzasT+8AJ1KCWumDVmdRzBYGEaKXNSK9ewZwmVTdHlrjUU5
	 9cSL1iSctt207vmxNoTeLsOyVybk5S96hV2H8nz4bFW4k+ASjEkNa66a0QcljonjJ5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069619;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=P102u/KfAvAMy2Uhe25cVvZ30EJJG+mM5dBukytkjdw=;
	b=u9zNKCzQ+EUbZvxx4IgMZ1snUisgm3R2pHiTq1gyLCIslRVBPTwZuK12UrGRUfZGCYel
	 DdyvAmPjAjX6O3Zz1LmVu1SjQbOW2B+THwd4oOzulCNGsP0wI2d2bHXdir6aem7bltSB4
	 QiGvaMQbdnDd4DvedmP7u47LouAriLeFX5i9eyZdJjZsV4Mq3Qd6gsWXg2dOr3Fyys3Xk
	 dGHy2517MJVbsllUwxeNK0+hQHavpRP88ic5bl23IoD6fWhM8KFvoEIhM0niR2FCdd0tk
	 D67A866juMsUNx7fkiMrXxFW/jIsFOKUCi7Qy3nMpTzp4zL4weFZWiNF9kRKDg9Pt1A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=suHYdsqA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1632606A326
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 16:40:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1632606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=suHYdsqA
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b577addee9so1919588a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 08:40:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794069617; cv=none;
        d=google.com; s=arc-20260327;
        b=cLVA0NQFV/UQxQubVnUrDY6TMUK0gxVF4lyV7dcc9cDeuz983CJnTCI+9qyXXpDYDp
         vrTpKamoemUJ+MLsaZewmvunMOrUH7wYA2HFy8C2KQgeIcDaUn/eZXGPkcfk7WiNA7Bz
         YxKgYHJRtA14KXPGSDIW/apGyPoP/o2JGcf7F7lF9TjN1naKdSxIONwuVxiYfAw7Rkm/
         //jnwwBAU5HVHirYPdtMn0dDiKEtzTRztCFN+CnWI5FFIzJcSRIRzxzqC79JQhSNEIJB
         q4F1gaNG8V6zdZVcZOKOmpAE8KektRUYsXscdNTn4wU65LfYZGiLnt2sdzrdHqPAVLyR
         8Ymg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P102u/KfAvAMy2Uhe25cVvZ30EJJG+mM5dBukytkjdw=;
        fh=MFGww5WWwMbVBAGzYlobFNpyX4w0AV158eWpczIR550=;
        b=SnzPGWpZ62Nm3Do+Jr62Orx1++Tq5KkXEl8PL8fbg/O6HLQ78eHu6tBS2lNCM5cZL4
         PlpcagCAs6oyqQRlZSSydxlqOL3SLSeD+aIwip/8EGy9jDdYBzH5j3cFz4vzc25vvwU/
         oQHbrsCjMOZ57lHNPmm4fYjmlAIbaUXMNXw3Slp1lsA/L1RWoM27TeBRduZRqr4FUoJq
         h39PMuOE511hZ7vsF4KqdDWbZWJoe1Bep5FyLauwpw9UIVzhL2aL/b1X5X3cJk7n59JT
         1sYxSDQXzC1j8fIvc+ly8pg+/VZOGl6/LlRq9Q4kJ27BeHjp2MMVa1zyAGqguPSpAiGr
         rYWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794069617; x=1794674417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P102u/KfAvAMy2Uhe25cVvZ30EJJG+mM5dBukytkjdw=;
        b=suHYdsqAiJD/2MVTRXRqssbtJzyLUl30ahijRzMzSqKGawsFxYRzRtY9KWVyuGMqTN
         TLKIss6Fgrd2KSY52Kf/ZnONdzYJ/T/Z/DnPGUSSYeqkpCT7Vbl3i/YVlDyxavuP85mP
         g2DexYyd5xMpHunNe2J9Rn/Q/9fiTKlMWpWVv9HjIa/AG09bseyfsaC0GMl2gbfumpOv
         sM0dBQ/mi/v39hDPbK3RZ6HUPCkDJgV6GDhdSjZv4xDrZWPdY5wisuwU6+Y/fnusrPc0
         m7rzRpoK7OqlgwRO0PFOs+xICWf2TXDCMfkTr5kwFYDr43kjAuPMc5ASQFCCSN4K3++e
         BoXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794069617; x=1794674417;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P102u/KfAvAMy2Uhe25cVvZ30EJJG+mM5dBukytkjdw=;
        b=aaUhpsBFN4N7HpjpVTA7TbI5ocf/WZB/TJw6Tj7AJKWzg/MDfl3Hw43ePsXBMK4Z8D
         WZohY2tRK+Lg8Rw9/5Gq3n0OPoyvDsNQbZqqNPqX0rwG/Udp3+8hrCdbSghBxEoGB1CC
         Khb1O5s+kWR0mkcPs9uK1xun6KYbyg0+XoJOGL98Dp/79Ti0myrZRp+bOp+HIymwmorJ
         zLVtFU6bYf23vizcPD8YjCtXx7BGt9R4TrAnP9D74kCQsAwQC796la5YrFYbfS35AyPp
         9czGDjQbIAg2yC7MCD9/P44kJ/xsMM8pnyjhrRh6kC74Ry1v1IjPiAFvW15z4SxTD0bU
         o2OA==
X-Gm-Message-State: APuU4Z9gnUr6LtQVL81fQGWKWqCYUBypxl6z9zuVAnSBpN2ZBSJBHP/h
	EhlbUztN53+mRX1S+7aH4SKZMNb50oPaGUzPwF7YY3VPiyGGEsbfXUhHhohtGoq59ikRS3H5qAq
	3HlmUgpJLgrWYn1mRVa7hzCj/APNYtV8=
X-Gm-Gg: AYBFou3UX6rRbQBqvFoNjo0Pe1Wb/mgGqmKgaXGrV4MYnygpWysIqNKzG6+BIhb9idE
	OGqR1BvuJ/3EC3n4sDmCL+3mqcXEHroO4SCPjksgjBx35pqw0Oc4+16O74cF9UsWvZiqY5dgSBM
	1Elcy3OcDxhUXRvAXTczG5+IqXbLpB4H+32ESLEF+hAqM5tdgpZUtfR18/786faUC+yI5LYI4eI
	XjyItFTL5jhS7Pywm/sH8XX2aKDV2yCE40EZTkhc5H1bSGQ+SmizdQBnl6zvzYr82Zm8492B0VW
	woj5UUVmFVANAzJg25pElWgTldHTJxJ1aUGkDnfsDjFn5dlplEI7uuvy2pd6cMKopVur4dZ2zjI
	HVShzpSDmZ1CKegk61uPlecc6PZzNCtOOb6hhucx3QTdtqVydaOQ2C2CHJ7Dj8u2SLZc65A==
X-Received: by 2002:a05:6402:2748:b0:6b6:e905:b045 with SMTP id
 4fb4d7f45d1cf-6b6e905b211mr3209063a12.3.1794069616883; Sat, 07 Nov 2026
 08:40:16 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106155110.1145957-1-giuseppe@scrivano.org> <CAOQ4uxgAd0+Z1Le_oXWJ9JD0AoKvZung_N22A+n3F_XPEQ9JMg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgAd0+Z1Le_oXWJ9JD0AoKvZung_N22A+n3F_XPEQ9JMg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 17:40:04 +0100
X-Gm-Features: AclHuK-JnM6ZGlLLK5_EkCUd7I8IqzcpyGxmalMxMsHSobyRmhL2SxTDUascSTg
Message-ID: <CAOQ4uxhVD=OjY7ro4rpbYu7aRC_eLybG+crLAQBFgMyHdw2Fgg@mail.gmail.com>
Subject: Re: [PATCH] overlay: add redirect_dir=followdata
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 5:04=E2=80=AFPM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Fri, Nov 6, 2026 at 4:51=E2=80=AFPM Giuseppe Scrivano <giuseppe@scriva=
no.org> wrote:
> >
> > A metacopy file with an absolute redirect to a data-only layer is
> > followed without metacopy=3Don and redirect_dir=3Don only when it is in=
 the
> > last lower layer.
> >
> > A mount with userxattr cannot have metacopy=3Don and redirect_dir=3Don,=
 so
> > a user namespace mount that stacks several metadata-only layers over a
> > data-only layer can use the metacopy files of the last lower layer
> > only:
> >
> >   mount -t overlay none -o userxattr,lowerdir+=3Dl3,lowerdir+=3Dl2,\
> >         lowerdir+=3Dl1,datadir+=3Ddata,upperdir=3Du,workdir=3Dw m
> >   cat m/low   # metacopy file in l1: works
> >   cat m/mid   # metacopy file in l2: Operation not permitted
> >
> > Add the opt-in mount option redirect_dir=3Dfollowdata.  Like
> > redirect_dir=3Dfollow it creates no redirects, but it follows only the
> > absolute redirect of a lower metacopy file, and only into the data-only
> > layers: the first such file found stops the lookup in the lower layers,
> > so the lower layers below it are never consulted, and the lookup of the
> > data stays lazy and happens only in the data-only layers.
> >
>
> Giuseppe,
>
> Your patch does what I asked correctly, but I changed my mind about
> how I want to structure this change.
> I would like to fix the issue you raised in v1 without user opt-in and
> I would like to include
>
> Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for
> lower -> data redirect")
>
> Because I think that fixing this for the lowermost layer only
> was incomplete and incorrect.
>
> Miklos' argument
>     Minimize the risk by only enabling redirect from a single lower layer=
 to a
>     data layer iff a data layer is specified.  The only way to access a d=
ata
>     layer is to enable this, so there's really no reason not to enable th=
is.
>
> The risk is just as minimal if we follow only redirects to data layer
> from any lower layer in case of userxattr when following other
> redirects is not allowed.
>
>
> > Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 27 +++++++++++++++++++++++--
> >  fs/overlayfs/namei.c                    | 15 ++++++++++++++
> >  fs/overlayfs/overlayfs.h                |  9 ++++++++-
> >  fs/overlayfs/params.c                   | 19 ++++++++++++++---
> >  4 files changed, 64 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/fi=
lesystems/overlayfs.rst
> > index 16c35b491dad..dbaf7200b6a6 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -244,6 +244,10 @@ Mount options:
> >  - "redirect_dir=3Doff":
> >      If "redirect_always_follow" is enabled in the kernel/module config=
,
> >      this "off" translates to "follow", otherwise it translates to "nof=
ollow".
> > +- "redirect_dir=3Dfollowdata":
> > +    Redirects are not created.  Only absolute redirects of metacopy fi=
les
> > +    in lower layers to data-only lower layers are followed (see
> > +    "Data-only lower layers" below).  Requires a data-only lower layer=
.
> >
>
> Please put this in order.
> Please keep it brief in this list
> (absolute and metacopy are redundant bloat)
>
> @@ -239,6 +239,9 @@ Mount options:
>      Redirects are enabled.
>  - "redirect_dir=3Dfollow":
>      Redirects are not created, but followed.
> +- "redirect_dir=3Dfollowdata":
> +    Redirects are not created.
> +    Only redirects from lower to lowerdata are followed.
>  - "redirect_dir=3Dnofollow":
>      Redirects are not created and not followed.
>  - "redirect_dir=3Doff":
>
> >  When the NFS export feature is enabled, every copied up directory is
> >  indexed by the file handle of the lower inode and a file handle of the
> > @@ -418,8 +422,8 @@ pointed by REDIRECT. This should not be possible on=
 local system as setting
> >  "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possibl=
e
> >  for untrusted layers like from a pen drive.
> >
> > -Note: redirect_dir=3D{off|nofollow|follow[*]} and nfs_export=3Don moun=
t options
> > -conflict with metacopy=3Don, and will result in an error.
> > +Note: redirect_dir=3D{off|nofollow|follow[*]|followdata} and nfs_expor=
t=3Don
> > +mount options conflict with metacopy=3Don, and will result in an error=
.
> >
> >  [*] redirect_dir=3Dfollow only conflicts with metacopy=3Don if upperdi=
r=3D... is
> >  given.
> > @@ -465,6 +469,25 @@ layers may be used together with "userxattr", in w=
hich case careful attention
> >  must be given to privileges needed to change the "user.overlay.redirec=
t" xattr
> >  to prevent misuse.
> >
> > +Without "metacopy=3Don", only a metacopy file in the lowest of the low=
er layers
> > +that are not data-only may redirect to a data-only layer; lookup of su=
ch a
> > +metacopy file in any lower layer above it fails with EPERM.  Since "us=
erxattr"
> > +cannot be used together with "metacopy=3Don" and "redirect_dir=3Don", =
stacking
> > +several lower layers of metacopy files over data-only layers needs the
> > +"redirect_dir=3Dfollowdata" mount option.  For example::
> > +
> > +  mount -t overlay none -o userxattr,redirect_dir=3Dfollowdata,\
> > +        lowerdir+=3D/l1,lowerdir+=3D/l2,lowerdir+=3D/l3,datadir+=3D/do=
1 /merged
> > +
> > +With "redirect_dir=3Dfollowdata", a metacopy file in any lower layer t=
hat has
> > +an absolute redirect stops the lookup in the lower layers: the lower l=
ayers
> > +below it are not looked up, and the data is looked up only in the data=
-only
> > +layers.  As for a metacopy file in the lowest lower layer, the "verity=
" mount
> > +option decides whether a fs-verity digest is verified or required on o=
pen.
> > +Directory redirects, relative redirects, and metacopy files and redire=
cts in
> > +the upper layer are rejected, as they are without this option.  Mounti=
ng with
> > +"redirect_dir=3Dfollowdata" fails if there is no data-only layer.
> > +
>
> It's too verbal for my taste. ask the agent to keep it brief please.
> This is a corner case. I don't want io include full bug descriptions in t=
his
> overview document.
>
> Honestly, with the auto enable of followdata in userxattr, the paragraph
> above needs only minor adaptations to be accurate.
> It doesn't even say anything about the current lowermost limitation.
>
> >  Since kernel version v6.8, "data-only" lower layers can also be added =
using
> >  the "datadir+" mount options and the fsconfig syscall from new mount a=
pi.
> >  For example::
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index ca899fdfaafd..c7ce26af5edf 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -1087,6 +1087,17 @@ struct ovl_lookup_ctx {
> >         unsigned int ctr;
> >  };
> >
> > +/*
> > + * With redirect_dir=3Dfollowdata, the absolute redirect of a lower me=
tacopy
> > + * file is followed only into the data-only layers.
> > + */
> > +static bool ovl_is_followdata_redirect(struct ovl_lookup_ctx *ctx,
> > +                                      struct ovl_lookup_data *d)
> > +{
> > +       return ovl_redirect_followdata(OVL_FS(d->sb)) && ctx->ctr &&
> > +              d->metacopy && d->absolute_redirect;
> > +}
> > +
> >  static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lo=
okup_data *d)
> >  {
> >         struct dentry *dentry =3D ctx->dentry;
> > @@ -1224,6 +1235,10 @@ static int ovl_lookup_layers(struct ovl_lookup_c=
tx *ctx, struct ovl_lookup_data
> >                         ctx->ctr++;
> >                 }
> >
> > +               /* Lookup of lowerdata in the data-only layers only */
> > +               if (ovl_is_followdata_redirect(ctx, d))
> > +                       d->stop =3D true;
> > +
> >                 if (d->stop)
> >                         break;
> >
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index 92da556598da..a9c93ba69e10 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -80,6 +80,7 @@ enum {
> >         OVL_REDIRECT_FOLLOW,    /* ...it translates to either "follow" =
 */
> >         OVL_REDIRECT_NOFOLLOW,  /* ...or "nofollow".                   =
 */
> >         OVL_REDIRECT_ON,
> > +       OVL_REDIRECT_FOLLOWDATA,        /* Only follow to data-only lay=
ers */
>
> order after follow please
>
> >  };
> >
> >  enum {
> > @@ -629,7 +630,13 @@ static inline char ovl_get_opaquedir_val(struct ov=
l_fs *ofs,
> >
> >  static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
> >  {
> > -       return ofs->config.redirect_mode !=3D OVL_REDIRECT_NOFOLLOW;
> > +       return ofs->config.redirect_mode !=3D OVL_REDIRECT_NOFOLLOW &&
> > +              ofs->config.redirect_mode !=3D OVL_REDIRECT_FOLLOWDATA;
> > +}
>
> This is confusing because followdata does follow.
>
> Looking at current users of this helper
>
>                 if (ovl_redirect_follow(ofs)) {
>                         ofs->config.redirect_mode =3D OVL_REDIRECT_NOFOLL=
OW;
>                         pr_warn("...falling back to redirect_dir=3Dnofoll=
ow.\n");
>                 }
>
> I think should be true for followdata

On second thought, this case does not need to fallthrough
followdata -> nofollow
perhaps it could even fallthrough to followdata

So up to whether you want to keep the helpers as is or change
them.
The check_redirect condition still should be fixed though.

>
>         bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdata=
layer);
>
> twice in ovl_lookup and ovl_lookup_layer
> should be true for followdata and || ofs->numdatalayer) can be dropped
> because ofs->numdatalayer should imply at least followdata
>
> Lastly, ovl_check_follow_redirect() either not reachable or should
> be fixed anyway to deal with followdata.
>
> > +
> > +static inline bool ovl_redirect_followdata(struct ovl_fs *ofs)
> > +{
> > +       return ofs->config.redirect_mode =3D=3D OVL_REDIRECT_FOLLOWDATA=
;
> >  }
> >
> >  static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
> > diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> > index 5a15e5478a6b..72a5e38daf20 100644
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -109,6 +109,7 @@ const struct constant_table ovl_parameter_redirect_=
dir[] =3D {
> >         { "follow",     OVL_REDIRECT_FOLLOW   },
> >         { "nofollow",   OVL_REDIRECT_NOFOLLOW },
> >         { "on",         OVL_REDIRECT_ON       },
> > +       { "followdata", OVL_REDIRECT_FOLLOWDATA },

This should obviously also be reordered to match the enum

> >         {}
> >  };
> >
> > @@ -988,10 +989,16 @@ int ovl_fs_params_verify(const struct ovl_fs_cont=
ext *ctx,
> >         }
> >
> >
> > -       /* Resolve userxattr -> !redirect && !metacopy dependency */
> > +       /*
> > +        * Resolve userxattr -> !redirect && !metacopy dependency.
> > +        * redirect_dir=3Dfollowdata creates no redirects and follows o=
nly the
> > +        * absolute redirects of lower metacopy files into data-only la=
yers,
> > +        * like a metacopy file in the last lower layer does without it=
.
>
> I don't want any mention of this last-lower behavior
> I consider it a mistake so please don't document it.
>
> > +        */
> >         if (config->userxattr) {
> >                 if (set.redirect &&
> > -                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) {
> > +                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW &&
> > +                   config->redirect_mode !=3D OVL_REDIRECT_FOLLOWDATA)=
 {
> >                         pr_err("conflicting options: userxattr,redirect=
_dir=3D%s\n",
> >                                ovl_redirect_mode(config));
> >                         return -EINVAL;
> > @@ -1006,10 +1013,16 @@ int ovl_fs_params_verify(const struct ovl_fs_co=
ntext *ctx,
> >                  * options must be explicitly enabled if used together =
with
> >                  * userxattr.
> >                  */
> > -               config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;
> > +               if (config->redirect_mode !=3D OVL_REDIRECT_FOLLOWDATA)
> > +                       config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW=
;
>
> We want to auto select followdata, not nofollow
> This way we get the best behavior with userxattr without opt-in and
> we also make the behavior visible in /proc/mountinfo.

Sorry, I should have said auto select followdata in case of ctx->nr_data

>
> >                 config->metacopy =3D false;
> >         }
> >
> > +       if (config->redirect_mode =3D=3D OVL_REDIRECT_FOLLOWDATA && !ct=
x->nr_data) {
> > +               pr_err("redirect_dir=3Dfollowdata requires a data-only =
layer\n");
> > +               return -EINVAL;
> > +       }
> > +
>
> I think the opposite should also be rejected NOFOLLOW with data-only laye=
rs
> cannot work. Is this already checked?
>

I know this is technically a regression for users with lowerdata that
had explicit nofollow, but I don't think this is a real concern, because
there is no specific reason for people to do that with the current auto
fallback to nofollow with userxattr.

Thanks,
Amir.
