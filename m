Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067490;
	b=DTKm8uiDqNMIP+vgrvMzra+GQvFQ4Dea/Oo7ill7cSfNYwtyeSmy3qUldu9pTd3AqPHk
	 c5C6YwB0wp2ADDQpaATj5IY3EpQllt41xvD+fgcB3Za2IiMajpPkCdrDIIHW1nyU0kg0M
	 1iS+ifb3fSKvIdfqIzeaabeelxgan24XpiLR+71mZ3QBhjmPgz/o5aPDMnIkRRjSZNkGY
	 xQySHYrfVHkC6Ed9F1qXWaFxLyo/khVDJdFlzivrtv+8LhOw+VlhwAn6N8jhu+HQhYE1Z
	 rrmRxrrBGBRCIL3qNeYZEg5AX2rVMVcnmYSuBCfURBGWfcf9w9sMlrpSKLdE45InuVg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Vq0Q39LXM4VUzYwbP3SUz820mgEbaQBYWUtx8Ww4j24=;
	b=C4TxtCwCNLcrifieSsQXEBt1nlTdGM2VYljvZceWEZS9LUQom3Ue9LoASFLYI8a+hUhF
	 qVdQJ36tVKABywxYitwQupq1MLYr4FqLQxm/nl1aY97gAJITGz8H4Mp1BpEv74z1kHOv6
	 fYmhdb/aO+A+RZeMe4/sJuNA1oqTDwDreV3NJtnDnlUFB4aQyATDIW2TuoVu0EcRMexTa
	 T0hJe5zh6reHJGxkS2LiNSLfoCVcq0xBahmR92tALeYJ1uQJFnZv3a4Ff78zGDypDEXgu
	 sVFpOiYVvh2nnitkw4lqqIbaBJEfU7TrWFvHJBtEs2SmgzpDAIsGhkLOuze81ifxr4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="kFcOd44/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC8606A334
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 16:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FBC8606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kFcOd44/
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so2143867a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 08:04:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794067488; cv=none;
        d=google.com; s=arc-20260327;
        b=pusVwOEx9nEvVsWkkTM3M6Czrze9xWnfcKwHnA7bR9XMLxJOT4/Aj/Lif1WXYHEG/A
         RN5+zzLG748Y+0v6YBbAe5NwtcOOZxmS4Zdo7sUnppWGzEQChCAjHAJ3sk3W8wokKWKb
         AFaUi3xVofrHF11l8uIGH0A0LQcD59H8JhgOeFZJcURliZTHTfkB7G1AKd4cc7lqpkcT
         Th6TPwJIc/hMBuf/nxDVHCy+80roSchzQNmMq3BxKXZK8WalmyMM7s3dd6Zh3iWluy+V
         iJ4V7NBT0bsPb0aV5Ryi/piEJgHyaXN8AxUEtb6qRi1RUFKIHS70Pf7zPb9pu4X34D/3
         Rgqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vq0Q39LXM4VUzYwbP3SUz820mgEbaQBYWUtx8Ww4j24=;
        fh=MFGww5WWwMbVBAGzYlobFNpyX4w0AV158eWpczIR550=;
        b=fguhuKzZ7F5zGy3YxKVgscs+VleEiIy2R5GYNDIsaS/ZjSQt9YM2+MAoXSxxMdF/Z0
         MeOBbn03v/x2+8PHZ79Drjgep0riTYtyVAhECOjGFttt5W1B3V/wtCEZeGul289Wk2bg
         Oun79RZfRt/O2At4xTlwEAIVH+Zvr1l0ia2s6N5T+78v2+2Sj6OfLCkqJej3fJY2Ex7r
         optWCoYoKKUfNky/bnsJmxxtHEmP7gG7f5pz1W3ZPG0FmKYa1VFyrbWvIEt2+bevT0tp
         rzVs3we83nVei670mEc0vCa4spJQqGbr9aBajuGC8xBmTJV4XWMwVTp6R4INrOfPCw3S
         skRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794067488; x=1794672288; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vq0Q39LXM4VUzYwbP3SUz820mgEbaQBYWUtx8Ww4j24=;
        b=kFcOd44/MUH7sZ22hnzbUMrmqaD2MnM//fBIlanHbC3FXQPmh63n9qao99dLJ6oykD
         JHzKT66qakEhuS9J+8mQjEkvl7hJhg8zsK0kVdRapiN9LNLGHvm1EE+AmuC8bGaxy7jH
         VjftYc7WFpdua5JTOARtV6nT8kIa74LqJJahzgDL3u9xN9j7SrwACg+y+LCYMpuTSL9A
         WXFCXauWt/1ppolLNngbU+GqOLXp/1fD529rI4d32VgcCkFgPrzR+kaB/F2mxJbAs3OQ
         skjN+QQQ3/kNcmKBKDrHPvp/9DycUlZFt2FaAqTSmcDxnZmLAO9M5la01j1rCmAwQFeb
         dFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794067488; x=1794672288;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vq0Q39LXM4VUzYwbP3SUz820mgEbaQBYWUtx8Ww4j24=;
        b=nEEuEHjawacRC1MaITpDl4M2jp6fd8TBze6yVX/hO86+SrqDvkRpt5TaGsEwObIeBY
         KiH2bISwjB4VWj2GnQ4dQCTRhhz994W+8CSit0gKPrsVqCIzPUaoMzB6UJgTahdh2Nf9
         vnD/2kFGFLdFfkf1uHqGkSdwWbuvbMJigO8SxqI0BhM7piubilrrXjlrUg19mAF82yij
         tE4uFYyQPQDog8r4ZuEe8JEzLQrwHkiGVlmwAZ2xVRumeIfNu/72RdOSN/1/qGPsFW9f
         f4j5GmHIsYd0Ei/yr8xHmjMQHwMqNCXVD7S5VtrQpxztQbtCkH6GJtb4bJYpFaDZcrBp
         3X3g==
X-Gm-Message-State: APuU4Z9qRRYIumsvghf6vHmH6K2Bsvv1Sj1Hn/pMbB5AbrbCeVpYUz8W
	HjZjTkHUQj5yHCzEKVYk8ODKceO9XFBMgNFNXzgpmJz4GMWyfTpPtPgTiSuaQzzp5vXgQf2np0h
	KCavh0fr8b/jj4EwP+rdlScgaMkzXV/RzYfqjnis=
X-Gm-Gg: AYBFou0WVsPSk8AybTV8bAZ4pq3C7k00uDj9auq41z3cRT64gixZd/nQ/+GbmnTkjl4
	AxDVv5dw0i7AfDFu0Oj8b4nNZVYVZPPBvPBlfKOKuJUJj877cj16jNxHrX2JweqyGlLydtmFt4r
	m1tI1AeTF7RgyV9omWqDAO3IEbpaZS7A1zj23o3Yb1S5zYyYP1xInm5HUmlC05oScTRcxjeKeRi
	ErCjmotSD9G0KmUqdqhcVn6hXspZv4wKEabACYgxMbKLT1JP04JlGUPIzEjTR3NaYtI8YvxlpBR
	qpFH704ch6J0YKJMqfJEaafK165mxleh7zJgA/wMPx0Mc9CiaFIlu2hzD4QmSwfWnKkELY4fWPQ
	wxKl2IHyPpCpcev+xylXeZqs5tgZmSFqR5RCy6qAoX0MyUfHA8PEMUmtCsaAJg7wUHxuqtQ==
X-Received: by 2002:a05:6402:440b:b0:6b5:64b3:82d7 with SMTP id
 4fb4d7f45d1cf-6b59753c6fbmr4233257a12.2.1794067487566; Sat, 07 Nov 2026
 08:04:47 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106155110.1145957-1-giuseppe@scrivano.org>
In-Reply-To: <20261106155110.1145957-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 17:04:35 +0100
X-Gm-Features: AclHuK9K6W6N1JlJ-Bveh9bY6yskfaK7rUAxGklwCvewpZCcXB4453DTxWjPxMw
Message-ID: <CAOQ4uxgAd0+Z1Le_oXWJ9JD0AoKvZung_N22A+n3F_XPEQ9JMg@mail.gmail.com>
Subject: Re: [PATCH] overlay: add redirect_dir=followdata
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 4:51=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivano=
.org> wrote:
>
> A metacopy file with an absolute redirect to a data-only layer is
> followed without metacopy=3Don and redirect_dir=3Don only when it is in t=
he
> last lower layer.
>
> A mount with userxattr cannot have metacopy=3Don and redirect_dir=3Don, s=
o
> a user namespace mount that stacks several metadata-only layers over a
> data-only layer can use the metacopy files of the last lower layer
> only:
>
>   mount -t overlay none -o userxattr,lowerdir+=3Dl3,lowerdir+=3Dl2,\
>         lowerdir+=3Dl1,datadir+=3Ddata,upperdir=3Du,workdir=3Dw m
>   cat m/low   # metacopy file in l1: works
>   cat m/mid   # metacopy file in l2: Operation not permitted
>
> Add the opt-in mount option redirect_dir=3Dfollowdata.  Like
> redirect_dir=3Dfollow it creates no redirects, but it follows only the
> absolute redirect of a lower metacopy file, and only into the data-only
> layers: the first such file found stops the lookup in the lower layers,
> so the lower layers below it are never consulted, and the lookup of the
> data stays lazy and happens only in the data-only layers.
>

Giuseppe,

Your patch does what I asked correctly, but I changed my mind about
how I want to structure this change.
I would like to fix the issue you raised in v1 without user opt-in and
I would like to include

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for
lower -> data redirect")

Because I think that fixing this for the lowermost layer only
was incomplete and incorrect.

Miklos' argument
    Minimize the risk by only enabling redirect from a single lower layer t=
o a
    data layer iff a data layer is specified.  The only way to access a dat=
a
    layer is to enable this, so there's really no reason not to enable this=
.

The risk is just as minimal if we follow only redirects to data layer
from any lower layer in case of userxattr when following other
redirects is not allowed.


> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> ---
>  Documentation/filesystems/overlayfs.rst | 27 +++++++++++++++++++++++--
>  fs/overlayfs/namei.c                    | 15 ++++++++++++++
>  fs/overlayfs/overlayfs.h                |  9 ++++++++-
>  fs/overlayfs/params.c                   | 19 ++++++++++++++---
>  4 files changed, 64 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 16c35b491dad..dbaf7200b6a6 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -244,6 +244,10 @@ Mount options:
>  - "redirect_dir=3Doff":
>      If "redirect_always_follow" is enabled in the kernel/module config,
>      this "off" translates to "follow", otherwise it translates to "nofol=
low".
> +- "redirect_dir=3Dfollowdata":
> +    Redirects are not created.  Only absolute redirects of metacopy file=
s
> +    in lower layers to data-only lower layers are followed (see
> +    "Data-only lower layers" below).  Requires a data-only lower layer.
>

Please put this in order.
Please keep it brief in this list
(absolute and metacopy are redundant bloat)

@@ -239,6 +239,9 @@ Mount options:
     Redirects are enabled.
 - "redirect_dir=3Dfollow":
     Redirects are not created, but followed.
+- "redirect_dir=3Dfollowdata":
+    Redirects are not created.
+    Only redirects from lower to lowerdata are followed.
 - "redirect_dir=3Dnofollow":
     Redirects are not created and not followed.
 - "redirect_dir=3Doff":

>  When the NFS export feature is enabled, every copied up directory is
>  indexed by the file handle of the lower inode and a file handle of the
> @@ -418,8 +422,8 @@ pointed by REDIRECT. This should not be possible on l=
ocal system as setting
>  "trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
>  for untrusted layers like from a pen drive.
>
> -Note: redirect_dir=3D{off|nofollow|follow[*]} and nfs_export=3Don mount =
options
> -conflict with metacopy=3Don, and will result in an error.
> +Note: redirect_dir=3D{off|nofollow|follow[*]|followdata} and nfs_export=
=3Don
> +mount options conflict with metacopy=3Don, and will result in an error.
>
>  [*] redirect_dir=3Dfollow only conflicts with metacopy=3Don if upperdir=
=3D... is
>  given.
> @@ -465,6 +469,25 @@ layers may be used together with "userxattr", in whi=
ch case careful attention
>  must be given to privileges needed to change the "user.overlay.redirect"=
 xattr
>  to prevent misuse.
>
> +Without "metacopy=3Don", only a metacopy file in the lowest of the lower=
 layers
> +that are not data-only may redirect to a data-only layer; lookup of such=
 a
> +metacopy file in any lower layer above it fails with EPERM.  Since "user=
xattr"
> +cannot be used together with "metacopy=3Don" and "redirect_dir=3Don", st=
acking
> +several lower layers of metacopy files over data-only layers needs the
> +"redirect_dir=3Dfollowdata" mount option.  For example::
> +
> +  mount -t overlay none -o userxattr,redirect_dir=3Dfollowdata,\
> +        lowerdir+=3D/l1,lowerdir+=3D/l2,lowerdir+=3D/l3,datadir+=3D/do1 =
/merged
> +
> +With "redirect_dir=3Dfollowdata", a metacopy file in any lower layer tha=
t has
> +an absolute redirect stops the lookup in the lower layers: the lower lay=
ers
> +below it are not looked up, and the data is looked up only in the data-o=
nly
> +layers.  As for a metacopy file in the lowest lower layer, the "verity" =
mount
> +option decides whether a fs-verity digest is verified or required on ope=
n.
> +Directory redirects, relative redirects, and metacopy files and redirect=
s in
> +the upper layer are rejected, as they are without this option.  Mounting=
 with
> +"redirect_dir=3Dfollowdata" fails if there is no data-only layer.
> +

It's too verbal for my taste. ask the agent to keep it brief please.
This is a corner case. I don't want io include full bug descriptions in thi=
s
overview document.

Honestly, with the auto enable of followdata in userxattr, the paragraph
above needs only minor adaptations to be accurate.
It doesn't even say anything about the current lowermost limitation.

>  Since kernel version v6.8, "data-only" lower layers can also be added us=
ing
>  the "datadir+" mount options and the fsconfig syscall from new mount api=
.
>  For example::
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..c7ce26af5edf 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1087,6 +1087,17 @@ struct ovl_lookup_ctx {
>         unsigned int ctr;
>  };
>
> +/*
> + * With redirect_dir=3Dfollowdata, the absolute redirect of a lower meta=
copy
> + * file is followed only into the data-only layers.
> + */
> +static bool ovl_is_followdata_redirect(struct ovl_lookup_ctx *ctx,
> +                                      struct ovl_lookup_data *d)
> +{
> +       return ovl_redirect_followdata(OVL_FS(d->sb)) && ctx->ctr &&
> +              d->metacopy && d->absolute_redirect;
> +}
> +
>  static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_look=
up_data *d)
>  {
>         struct dentry *dentry =3D ctx->dentry;
> @@ -1224,6 +1235,10 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx=
 *ctx, struct ovl_lookup_data
>                         ctx->ctr++;
>                 }
>
> +               /* Lookup of lowerdata in the data-only layers only */
> +               if (ovl_is_followdata_redirect(ctx, d))
> +                       d->stop =3D true;
> +
>                 if (d->stop)
>                         break;
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 92da556598da..a9c93ba69e10 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -80,6 +80,7 @@ enum {
>         OVL_REDIRECT_FOLLOW,    /* ...it translates to either "follow"  *=
/
>         OVL_REDIRECT_NOFOLLOW,  /* ...or "nofollow".                    *=
/
>         OVL_REDIRECT_ON,
> +       OVL_REDIRECT_FOLLOWDATA,        /* Only follow to data-only layer=
s */

order after follow please

>  };
>
>  enum {
> @@ -629,7 +630,13 @@ static inline char ovl_get_opaquedir_val(struct ovl_=
fs *ofs,
>
>  static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
>  {
> -       return ofs->config.redirect_mode !=3D OVL_REDIRECT_NOFOLLOW;
> +       return ofs->config.redirect_mode !=3D OVL_REDIRECT_NOFOLLOW &&
> +              ofs->config.redirect_mode !=3D OVL_REDIRECT_FOLLOWDATA;
> +}

This is confusing because followdata does follow.

Looking at current users of this helper

                if (ovl_redirect_follow(ofs)) {
                        ofs->config.redirect_mode =3D OVL_REDIRECT_NOFOLLOW=
;
                        pr_warn("...falling back to redirect_dir=3Dnofollow=
.\n");
                }

I think should be true for followdata

        bool check_redirect =3D (ovl_redirect_follow(ofs) || ofs->numdatala=
yer);

twice in ovl_lookup and ovl_lookup_layer
should be true for followdata and || ofs->numdatalayer) can be dropped
because ofs->numdatalayer should imply at least followdata

Lastly, ovl_check_follow_redirect() either not reachable or should
be fixed anyway to deal with followdata.

> +
> +static inline bool ovl_redirect_followdata(struct ovl_fs *ofs)
> +{
> +       return ofs->config.redirect_mode =3D=3D OVL_REDIRECT_FOLLOWDATA;
>  }
>
>  static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 5a15e5478a6b..72a5e38daf20 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -109,6 +109,7 @@ const struct constant_table ovl_parameter_redirect_di=
r[] =3D {
>         { "follow",     OVL_REDIRECT_FOLLOW   },
>         { "nofollow",   OVL_REDIRECT_NOFOLLOW },
>         { "on",         OVL_REDIRECT_ON       },
> +       { "followdata", OVL_REDIRECT_FOLLOWDATA },
>         {}
>  };
>
> @@ -988,10 +989,16 @@ int ovl_fs_params_verify(const struct ovl_fs_contex=
t *ctx,
>         }
>
>
> -       /* Resolve userxattr -> !redirect && !metacopy dependency */
> +       /*
> +        * Resolve userxattr -> !redirect && !metacopy dependency.
> +        * redirect_dir=3Dfollowdata creates no redirects and follows onl=
y the
> +        * absolute redirects of lower metacopy files into data-only laye=
rs,
> +        * like a metacopy file in the last lower layer does without it.

I don't want any mention of this last-lower behavior
I consider it a mistake so please don't document it.

> +        */
>         if (config->userxattr) {
>                 if (set.redirect &&
> -                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) {
> +                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW &&
> +                   config->redirect_mode !=3D OVL_REDIRECT_FOLLOWDATA) {
>                         pr_err("conflicting options: userxattr,redirect_d=
ir=3D%s\n",
>                                ovl_redirect_mode(config));
>                         return -EINVAL;
> @@ -1006,10 +1013,16 @@ int ovl_fs_params_verify(const struct ovl_fs_cont=
ext *ctx,
>                  * options must be explicitly enabled if used together wi=
th
>                  * userxattr.
>                  */
> -               config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;
> +               if (config->redirect_mode !=3D OVL_REDIRECT_FOLLOWDATA)
> +                       config->redirect_mode =3D OVL_REDIRECT_NOFOLLOW;

We want to auto select followdata, not nofollow
This way we get the best behavior with userxattr without opt-in and
we also make the behavior visible in /proc/mountinfo.

>                 config->metacopy =3D false;
>         }
>
> +       if (config->redirect_mode =3D=3D OVL_REDIRECT_FOLLOWDATA && !ctx-=
>nr_data) {
> +               pr_err("redirect_dir=3Dfollowdata requires a data-only la=
yer\n");
> +               return -EINVAL;
> +       }
> +

I think the opposite should also be rejected NOFOLLOW with data-only layers
cannot work. Is this already checked?

Sorry for taking a turn in the design request.
I hope I haven't left anything important out this time.

Thanks,
Amir.

P.S. There are already three lowerdata follow related fixes on my
ovl-fixes branch
in github (one from you).
* 9e84bab320b32 - (ovl-fixes) ovl: do not check the deferred lowerdata
redirect on index lookup
* 3549dc048920c - ovl: fix leak of lowerdata redirect on ovl_get_inode() fa=
ilure
* ba19b2fdeb79e - ovl: do not always clear absolute_redirect
Please test your work based on this branch.
The two new fixes don't have a reproduction that could fit in your fstest.
