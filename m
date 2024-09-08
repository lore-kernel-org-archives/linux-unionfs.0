Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF9E62171
	for <linux-unionfs@vger.kernel.org>; Sun,  8 Sep 2024 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725804062; cv=none; b=OIqIy4PiS18CAfvvGVUbAnAFVDWkJZUqrNM4O5RZPyde1oN97o7ObkgxkUTeyzvM0rpAz9vJ23tJu1CyImQSQ1dDucFdiS13Ccf2iTLwpDpou10IpQw6r/cRvwsQ7gIYQdxOaP9iVwCJBC0MOeYJsF+c5+Ng6C0AJL4RwkQDHWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725804062; c=relaxed/simple;
	bh=k6C92YacFFgDrPxXlYv6GTyf8d8IALYWVMjsNNXzp2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npm7HjbIJhLUJUx14Rwv0wHiipaAw7Df5oL1iWETXSiPaezBxRywDs+Zw33BmhNS7o+CHjzbhcvXtIyndpsU73qKunEqHxdu2j612SmuQnWa6k0VHr4PrQWX05CikUTe/w6z/VFyRlmdDcENL3yg9Y7YvG1v51pGZDMjPcrIvwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SEuaqSmU; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SEuaqSmU"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5d5eec95a74so2095511eaf.1
        for <linux-unionfs@vger.kernel.org>; Sun, 08 Sep 2024 07:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725804059; x=1726408859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qnsswV9iZUhWDikooz5WOXXo60/2wploLmJ9pkediY8=;
        b=SEuaqSmU9llvi1Z4RKprdh2uQLYl4RnFDRf/GaiRWDcliYk82Ks0K9+qIKuxdEcggC
         qx87XQxEcTd6j6qm9jyzXE8ydmPb3bjq5Y+BB0asg5zWi67ehtadxvfvIFpSIx96ej9G
         kqvcJ5vtrCrmN3ZKLltdY9X6KhUALzddiTmrhBUgiSyYUWRYGfTuK9Fts14xbL+sq0e1
         s8vgTGGfTLDWkR6+N9CNDHK3BlnNctQugxnOoqszOAr4/ppzEYGmo8Yxeec/13JWhQqE
         jag3+Fqv60aV3Ax7qSMTq2OmgcZwB9lnLNlI7AY4p2VQLf5WFqNYvKqIkul58Y7E/9QF
         Uzsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725804059; x=1726408859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qnsswV9iZUhWDikooz5WOXXo60/2wploLmJ9pkediY8=;
        b=S7i1Sk2+PXfhKmoj6UpWcD6tS30OAe3DASDx5yB6P/4I/pGMV5oOu+nAqEbjsPIJdr
         s4UJMjg09gitpktTJFMv7vn3eaoKebK1GiIfpCDx+O5hZ8SPBInZhVBPcGa2C2v0oYqK
         Tx6O7TZb0SsFnl7HBo9FspS91tOCDjFd7soc9bTLyl1IRZxIlYN8yY5qNKGp6qV5uhlh
         073623Lbx64zAWI9p+6mpza3/hmHfuiABBA4xd9TlItlqYfCKeN1GdN99+n3LpCYvxX+
         pKkZfntF7YNHduVSPTtKLs9Q18jlO5HVSGn7f7Xq1r2AJouXBASk+NbxjWbhnAwRHMTA
         RD8w==
X-Gm-Message-State: AOJu0YyeZGWRIzCqTIkOQAlOp/bKo88TmhNfJMWWQjFwJYB4mOSuR8sQ
	fC8k9NL5wmxt0Brv4LBgzgcpmebbUmUUUqw6mlTorICJaLsXeVbt+Y7AW4N9I4/LBSDm7+/ugQy
	z/YBQlnTKgs+DNDILYRjVbXJrG8ykcrwy
X-Google-Smtp-Source: AGHT+IH8bjrWGEnWVXng6a1pH6ew1ZOWYSFK255hks1tCl4uOebj31K7ALM2OVzTZjxG/Ydj3XAw1JuFhpSr5PTGk/4=
X-Received: by 2002:a05:6358:2827:b0:1b5:a38c:11d1 with SMTP id
 e5c5f4694b2df-1b8386f6ad8mr932919555d.26.1725804059160; Sun, 08 Sep 2024
 07:00:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2e8c4e8b-3292-4ccf-bb63-12d7c0009ae9@mbaynton.com>
 <20240711035203.3367360-1-mike@mbaynton.com> <CAOQ4uxgxpnj1r-p9Y=OkP=Qk2YM9jZ37Pm0NBN1R=NagZuhioA@mail.gmail.com>
 <a05156b1-7cb9-470c-82c1-3d5cbd6611e6@mbaynton.com>
In-Reply-To: <a05156b1-7cb9-470c-82c1-3d5cbd6611e6@mbaynton.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 8 Sep 2024 16:00:48 +0200
Message-ID: <CAOQ4uxiez1UsTvoZpGG2DhAmbf0fLoe1pu4fB2X+9RCD95fF7A@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Fail if trusted xattrs are needed but caller
 lacks permission
To: Mike Baynton <mike@mbaynton.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Larsson <alexl@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 7, 2024 at 5:59=E2=80=AFPM Mike Baynton <mike@mbaynton.com> wro=
te:
>
> Hi Amir,
> I apologize for my unfamiliarity with the process. Would you be so kind
> as to point me to the next steps for this patch?

Your next step would be to ping the maintainers ;)

Sorry, as both me and Miklos were on vacation during July,
nobody picked up this patch.

I did skim over the mailing list for missed patches after my vacation,
but I somehow missed it.

I will queue it up and designate it for stable v6.6+.
v6.6 added overlayfs verity feature, but lower datadir was added
already in v6.5.
However, 1. v6.5 is not an LTS kernel, 2. the params.c refactoring
in v6.5 makes it hard to backport beyond v6.6.

Thanks,
Amir.


>
> My team took a wrong turn building on data-only layers on account of my
> not vetting the feature inside user namespaces well enough -- I just
> checked "does it mount and enumerate files successfully." I'm hoping the
> most good that can come from that blunder is saving someone else from
> the same fate in future.
>
> Regards
> Mike
>
> On 7/11/24 08:35, Amir Goldstein wrote:
> > On Thu, Jul 11, 2024 at 7:05=E2=80=AFAM Mike Baynton <mike@mbaynton.com=
> wrote:
> >>
> >> Some overlayfs features require permission to read/write trusted.*
> >> xattrs. These include redirect_dir, verity, metacopy, and data-only
> >> layers. This patch adds additional validations at mount time to stop
> >> overlays from mounting in certain cases where the resulting mount woul=
d
> >> not function according to the user's expectations because they lack
> >> permission to access trusted.* xattrs (for example, not global root.)
> >>
> >> Similar checks in ovl_make_workdir() that disable features instead of
> >> failing are still relevant and used in cases where the resulting mount
> >> can still work "reasonably well." Generally, if the feature was enable=
d
> >> through kernel config or module option, any mount that worked before
> >> will still work the same; this applies to redirect_dir and metacopy. T=
he
> >> user must explicitly request these features in order to generate a mou=
nt
> >> failure. Verity and data-only layers on the other hand must be explict=
ly
> >> requested and have no "reasonable" disabled or degraded alternative, s=
o
> >> mounts attempting either always fail.
> >>
> >> "lower data-only dirs require metacopy support" moved down in case
> >> userxattr is set, which disables metacopy.
> >>
> >> Signed-off-by: Mike Baynton <mike@mbaynton.com>
> >
> > Looks nice
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >
> >> ---
> >>
> >>  v1 -> v2 not specific to data-only layers, punt on metacopy disable
> >>           due to xattr write errors creating a conflicting configurati=
on
> >>           when data-only layers are present.
> >>
> >>  fs/overlayfs/params.c | 39 +++++++++++++++++++++++++++++++++------
> >>  1 file changed, 33 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> >> index 4860fcc4611b..107c43e5e4cb 100644
> >> --- a/fs/overlayfs/params.c
> >> +++ b/fs/overlayfs/params.c
> >> @@ -782,11 +782,6 @@ int ovl_fs_params_verify(const struct ovl_fs_cont=
ext *ctx,
> >>  {
> >>         struct ovl_opt_set set =3D ctx->set;
> >>
> >> -       if (ctx->nr_data > 0 && !config->metacopy) {
> >> -               pr_err("lower data-only dirs require metacopy support.=
\n");
> >> -               return -EINVAL;
> >> -       }
> >> -
> >>         /* Workdir/index are useless in non-upper mount */
> >>         if (!config->upperdir) {
> >>                 if (config->workdir) {
> >> @@ -910,7 +905,6 @@ int ovl_fs_params_verify(const struct ovl_fs_conte=
xt *ctx,
> >>                 }
> >>         }
> >>
> >> -
> >>         /* Resolve userxattr -> !redirect && !metacopy && !verity depe=
ndency */
> >>         if (config->userxattr) {
> >>                 if (set.redirect &&
> >> @@ -938,6 +932,39 @@ int ovl_fs_params_verify(const struct ovl_fs_cont=
ext *ctx,
> >>                 config->metacopy =3D false;
> >>         }
> >>
> >> +       /*
> >> +        * Fail if we don't have trusted xattr capability and a featur=
e was
> >> +        * explicitly requested that requires them.
> >> +        */
> >> +       if (!config->userxattr && !capable(CAP_SYS_ADMIN)) {
> >> +               if (set.redirect &&
> >> +                   config->redirect_mode !=3D OVL_REDIRECT_NOFOLLOW) =
{
> >> +                       pr_err("redirect_dir requires permission to ac=
cess trusted xattrs\n");
> >> +                       return -EPERM;
> >> +               }
> >> +               if (config->metacopy && set.metacopy) {
> >> +                       pr_err("metacopy requires permission to access=
 trusted xattrs\n");
> >> +                       return -EPERM;
> >> +               }
> >> +               if (config->verity_mode) {
> >> +                       pr_err("verity requires permission to access t=
rusted xattrs\n");
> >> +                       return -EPERM;
> >> +               }
> >> +               if (ctx->nr_data > 0) {
> >> +                       pr_err("lower data-only dirs require permissio=
n to access trusted xattrs\n");
> >> +                       return -EPERM;
> >> +               }
> >> +               /*
> >> +                * Other xattr-dependent features should be disabled w=
ithout
> >> +                * great disturbance to the user in ovl_make_workdir()=
.
> >> +                */
> >> +       }
> >> +
> >> +       if (ctx->nr_data > 0 && !config->metacopy) {
> >> +               pr_err("lower data-only dirs require metacopy support.=
\n");
> >> +               return -EINVAL;
> >> +       }
> >> +
> >>         return 0;
> >>  }
> >>
> >> --
> >> 2.34.1
> >>
> >>
>
