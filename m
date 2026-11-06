Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793967948;
	b=IZ2mm7Ukhmhk9ZcXMzI/FVmj6qUoVvePzJA/ooU9UPJzHclyNuzXS3Nq1C0qdcMp+OHU
	 gm+RLeGNps+GVCYTLueItsIwWD201Z+tkWun5i5gBOlHAHrXowlZW8eLr1Dro5L+Xcff9
	 RnnlJa4tFBAxk2sCyRZWBSio48Ld431xLc/EDV6lHrxpkhVFwRH/wBlSdanrfxzsmcT8v
	 rfEItLdS6d+WSoNGkMihb29DCMIgxPs3dZ9AnVV/HW8hdXghXOob8qzWusTwOnZw5EHc/
	 IcTJ7qOt+mDsV7kWUT8RIlijNivuQ57RKq7Z5k1Ccc/JjR1DQ/r9c3Gz97DFEwJSZ9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=biND84gyvQ4Ww/+reS5mUAmDmqVYBZzjVKHA036/rBw=;
	b=lolWTZ7YWwgAdG2I29+MoDqIsnOy7K1iy8WnyDtXWw06cm/X2JV8Mosv/xq3RBifgfjU
	 GteH9k48ALgDrPFNzaJHlx/T5S3KUaxW3EZ7IgH4kTMnt6d38zZECiZA3KPVcAV/oh7ZS
	 G/NfZxXx/FQxHabIMHBW6mGoRmXCI/uxIm16C/6FU+9ypdp7TGfMVHyfjFf/vlBQeS37L
	 DxTO/ik2A/2EGPWzJlfQZZ3WSYgjhNKR5X0eFCNQIziMkwjCfUyLg0IjIEDyDgPqSg8Cf
	 w6AcufODYPROQXwQCaROhpgiWrGBlZKxQWKlzOF4No08uLx/XG3N100fJjsNa8jasaA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PkJRg6VN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76096606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 12:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76096606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PkJRg6VN
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b203527bceso772144a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 04:25:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793967947; cv=none;
        d=google.com; s=arc-20260327;
        b=cAeh2P34eZaEHAPfpMhFFkmoAX3hYN1NrSu7YQN02qHgKmflQIhtxe0h1xBROaJsz8
         5YudiQuZAvBUWTBJOBONCG7y1Q9o0ocm61jNGKdppehIgYpI1Im30qtnPMJhxRuD1v3l
         oazf8o9qURCrmxdkJBNim7tnDu91Mu5TlU1CPdaUggJyTbYvQe/seDUZ/orUClpRw9MQ
         y1tnitf78gVxrN9nJ6mpWwadiMsl+WGsQDWKqyzOw3s24OH6VJHAvbiVQ2O4WH9a4UnJ
         d2wJypALzsPn7JHDIkiI+h9G9Ut4v0cktocFo/U+H1mo0OlXnhlcHgcjstI3c0ofQDYb
         ijmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=biND84gyvQ4Ww/+reS5mUAmDmqVYBZzjVKHA036/rBw=;
        fh=DMkBQGJUXeMV9Z2em878L5ubb4Im8GYqatxUyUq0FdU=;
        b=bgohyfqQvudLbUv+uM7G59onjZ/7XK5BaBKIfmM2nItC0lbtRRB+gY7BIj39fQXpGy
         JWdMmArGCqP+I9IQGUL8YcEAJH/z92LdtHaasInmhEGz7xWPjpqZlyshmqu1UUIS8/Uz
         RHBDoAHdc81ExGm+YCOpWY4zCjy332FCKLWXUayVhHzoCpV/m70FgEP1EBA2uW4DrjI6
         Tg6tCzNM0jNMCyTa+2yAJXoduZjGkr5Znk9hRKim7mdnTyugP1U5UDehM+U2s6WwAJDs
         yew4/VESOGv7dtl3reoeI/smZST9rs0DI/GynuOcdFqLTolVrHbY7DbzqFrRwHo7HNX1
         NzyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793967947; x=1794572747; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=biND84gyvQ4Ww/+reS5mUAmDmqVYBZzjVKHA036/rBw=;
        b=PkJRg6VNYihbyfnLfIFOj7ZIrpmzOUNhJlaZlQDimUnKp5DLbxYf6f62UcAxHxpC7c
         j+saqWgll/NCNgHkf1QNlhizjcinuG/wSVJ/GfVzDHeztNfPkkSr3vlvGVQ6Ye0oAh/I
         8pgXyMagBRd80Ocbu7M7sMBbOV+VRRBk5IB5DWeXAhXgceZ/OjPpxCYS6QDjhv2/b2jD
         px0ZcPt9Lp26S1nEetbjxSzUWbXlCdALNeSg5FQzfdH0NBpZEagsuOvP0sbRiuRX93Qs
         /gg6yuv6rNwjKhOgHEye3ZJ9s/5rkTlIrt2tb/GjDNI4UmzzHHmQtoIUTH+0YX+rstq3
         kGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793967947; x=1794572747;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=biND84gyvQ4Ww/+reS5mUAmDmqVYBZzjVKHA036/rBw=;
        b=2cr/D+8F1kObyvfSlIalpD1VSfzakQJLTPw/le0AozzB+TLJDlsD3+rmCYCOMLXIwz
         qWhfL2NB3TUdBSpL5tR7eUD10hcRpseUuc912uGpqpBQvgPQ5+BK1DDbEGtGWdW3GKF4
         bRKUIjKG4EFZL9IYrAKIrmWccAqt82fnE3UyLdo9SINqe4hSr3ShnTBQuclikjCjmxLf
         dfwkG8oWvk6tCOX7jMU0lHkQrs+liCkJXDiHDGvdtjKLvM/D90xuuqh6fN6cC3F28map
         0XVhwiRlCv06Jr7POPiymVXx+Ed51RkF6sy35t9YHBA8ZjJbYc6y5BxRYp2Z710WS42i
         6TTw==
X-Gm-Message-State: APuU4Z8kjA63XMR7jhTcYkCMlM+Z2tPPjSX93y0ogr0JOHXEdKfW2/6D
	bO3Fg1KyYYHt75iV6+pS/+Og+lBbRuk+2WjwSt7dB9jD4WDlTIOTse7yDa6ubNfe/vixdiNNeVb
	NIifEy2ATgtRwcX69AVcNUNtOIbX//Zs8O8FGcqo=
X-Gm-Gg: AYBFou1mhDyE8c2aS0Jysv37XlbIaeMogm5mPelkl4rTZqGJkjcNeY8UUrhGO1KLqrc
	LkQDQs3+RdR5nGkEKXhUEAsZHpNHyr5px4WL1OUuRSyMyYMfTXXfVNplN5K4jpmRTq+IRlRIz40
	dJdjaYh0eAKqh36Nd33UxlnUB2bMkN9n+1CscHIpMWUwJP6Gj5SjMdmI60eealWIkMj6t/6x46H
	Jw8AfWED2YIQVFU7FgOWHulQEoiRNTBtELsZOXOyMZa6nfYDCcKEyaC58cXn9EjEotH8rMY0cGH
	fj5OULSswlz9KvK4+RoTGWFWMiOfgbyVoJfx/vJyJmDsY7Q0YRdgv/IEPA2t3xjUcx2R1KHVHv9
	v1Zu/KPbTsLTyW1bzeXZe/ROYku6JD9A4E4jFfQoSsakhKHRTgKIChJ3XNKNmm4L/3UAbkQ==
X-Received: by 2002:a05:6402:4289:b0:6b5:911d:9598 with SMTP id
 4fb4d7f45d1cf-6b5977a3839mr1621740a12.10.1793967946360; Fri, 06 Nov 2026
 04:25:46 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105143138.484820-1-giuseppe@scrivano.org>
 <CAOQ4uxhmh7OpoGnNacFedBPm+jUQfDzv1QD4H+jTvb2kAPK=4Q@mail.gmail.com> <87tslumh6i.fsf@redhat.com>
In-Reply-To: <87tslumh6i.fsf@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Nov 2026 13:25:35 +0100
X-Gm-Features: AclHuK_x4a_eCnlq7MiuEi3pmqNdJyzwADz3cXpvbXjtEF-2dcRSnhKe1JEtJ1w
Message-ID: <CAOQ4uxijrkvG7=0M2nwEXW6BBm312Ra1jhq4n5rw_XkcmMattw@mail.gmail.com>
Subject: Re: [RFC][PATCH] overlay: always follow metacopy into data-only layers
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 10:40=E2=80=AFAM Giuseppe Scrivano <giuseppe@scrivan=
o.org> wrote:
>
> Hi Amir,
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > On Thu, Nov 5, 2026 at 3:37=E2=80=AFPM Giuseppe Scrivano <giuseppe@scri=
vano.org> wrote:
> >>
> >> A metacopy file with an absolute redirect to a data-only layer is foll=
owed
> >> without metacopy=3Don and redirect_dir=3Don only when it is in the las=
t lower
> >> layer.  In any other lower layer, the next iteration of the loop in
> >> ovl_lookup_layers() calls ovl_check_follow_redirect() with d->metacopy=
 set
> >> and fails with -EPERM.
> >>
> >> A mount with userxattr cannot have metacopy=3Don and redirect_dir=3Don=
, so a
> >> user namespace mount that stacks several metadata-only layers over a
> >> data-only layer can use the metacopy files of the last lower layer onl=
y:
> >>
> >>   mount -t overlay none -o userxattr,lowerdir+=3Dl3,lowerdir+=3Dl2,\
> >>         lowerdir+=3Dl1,datadir+=3Ddata,upperdir=3Du,workdir=3Dw m
> >>   cat m/low   # metacopy file in l1: works
> >>   cat m/mid   # metacopy file in l2: Operation not permitted
> >>
> >> Skip the check inside the loop for a metacopy file of a lower layer wi=
th an
> >> absolute redirect, on a mount that has data-only layers.  The lookup o=
f the
> >> data stays lazy and happens only in the data-only layers.  A metacopy =
file
> >> or a redirect in the upper layer is still refused.  With metacopy=3Don=
 and
> >> redirect_dir=3Don the loop already continues after such a file, so onl=
y
> >> mounts that failed with -EPERM are affected.
> >>
> >> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> >> ---
> >>  fs/overlayfs/namei.c | 13 +++++++++++--
> >>  1 file changed, 11 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> >> index ca899fdfaafd..02c64a5652a0 100644
> >> --- a/fs/overlayfs/namei.c
> >> +++ b/fs/overlayfs/namei.c
> >> @@ -1087,6 +1087,14 @@ struct ovl_lookup_ctx {
> >>         unsigned int ctr;
> >>  };
> >>
> >> +/* A metacopy file of a lower layer whose lowerdata is in a data-only=
 layer */
> >> +static bool ovl_is_datalayer_redirect(struct ovl_lookup_ctx *ctx,
> >> +                                     struct ovl_lookup_data *d)
> >> +{
> >> +       return d->metacopy && ctx->ctr && OVL_FS(d->sb)->numdatalayer =
&&
> >> +              d->absolute_redirect;
> >
> > To further reduce risk, assuming that in the intended use case the data
> > references always carry a digest, can we reinforce this to
> > d->metacopy > OVL_METACOPY_MIN_SIZE?
>
> I am not planning to use it only with fsverity.  I'd like to use this
> also on file systems where fs-verity is not supported, or if an user
> decides to opt-out for any reason.
>
> >
> >> +}
> >> +
> >>  static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_l=
ookup_data *d)
> >>  {
> >>         struct dentry *dentry =3D ctx->dentry;
> >> @@ -1154,7 +1162,8 @@ static int ovl_lookup_layers(struct ovl_lookup_c=
tx *ctx, struct ovl_lookup_data
> >>         for (i =3D 0; !d->stop && i < ovl_numlower(poe); i++) {
> >>                 struct ovl_path lower =3D ovl_lowerstack(poe)[i];
> >>
> >> -               if (!ovl_check_follow_redirect(d)) {
> >> +               if (!ovl_is_datalayer_redirect(ctx, d) &&
> >> +                   !ovl_check_follow_redirect(d)) {
> >>                         err =3D -EPERM;
> >>                         return err;
> >>                 }
> >
> > That's too promiscuous IMO to continue to loop as if nothing.
> > You subject says "always follow metacopy into data-only layers"
> > but this allows also following metacopy from l2 to l1 if there is a
> > datalower and that makes no sense.
> >
> > What you would need to do is taint the lookup ctx in case we decided to
> > follow against the follow_redirect/metacopy config in such a way
> > that finding anything in the lower layers, even a whiteout or opaque
> > object, will fail the lookup, because then we are not really allowing
> > the intended follow into data-only layers.
> >
> > But I prefer to do it differently, see below
> >
> >> @@ -1238,7 +1247,7 @@ static int ovl_lookup_layers(struct ovl_lookup_c=
tx *ctx, struct ovl_lookup_data
> >>          * Defer lookup of lowerdata in data-only layers to first acce=
ss.
> >>          * Don't require redirect=3Dfollow and metacopy=3Don in this c=
ase.
> >>          */
> >> -       if (d->metacopy && ctx->ctr && ofs->numdatalayer && d->absolut=
e_redirect) {
> >> +       if (ovl_is_datalayer_redirect(ctx, d)) {
> >>                 d->metacopy =3D 0;
> >>                 ctx->ctr++;
> >>         } else if (!ovl_check_follow_redirect(d)) {
> >> --
> >> 2.56.0
> >>
> >>
> >
> > If the tooling can be changed we could introduce a special data-only
> > follow marker and in this case we could just break out of the layers
> > loop when it is encountered.
> >
> > Another option is to implement opt-in to redirect_dir=3Dfollowdata
> > which only allows following absolute redirects to the data-only layers
> > which will stop the layers loop on first found redirect and requires
> > a data-only layer of course.
> >
> > I prefer this option if it meets the user case's needs,
> > because verifying that the redirect doesn't redirect to a lower layer
> > just complicates the code for a corner case and runs unneeded
> > cycles for no good reason.
>
> from an initial test, this seems to work for me.  If I don't encounter
> other issues, I'll send another version later.
>

Giuseppe,

FYI, Sashiko reported an existing bug in following redirects
to data-only layers:

https://sashiko.dev/#/bug/linux-2cc24e0b-fbdc-4cf1-aded-cfd19c2918ee

I assigned it to you because I figured since you are touching this code
anyway you may be able to reproduce and test the claim in the bug
and fix it (?).

And speaking of tests see fstests test overlay/089:
# This is a variant of test overlay/080 with userxattr and without
# redirect_dir/metacopy options

Please clone it to cover the new redirect_dir=3Dfollowdata case
and if possible to cover the bug that Sashiko found.

Thanks,
Amir.
