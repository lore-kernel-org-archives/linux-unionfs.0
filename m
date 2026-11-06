Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793946097;
	b=jxdWtW8lck7cpStWs4Gudr+W0wRJqH0j8Rh8v9g60yngt+lsAkrCzEwFxlcWxbJG3VZx
	 WmsYs5UeH081/nFxpnTT2iJvH8N8764R5gkkFcPz7R+1umtgXPXxMXYfpWPLeVGjLpLO4
	 ohWjnMoYrpPzomkOtxIR11xHnzK6xOFH53ndiBtVSN9VjGdGAhsPZTakkhMxmSSYg8kQN
	 rDoj+OA8O0Gez1t7NcbYuy+DnYVGYK2udk4MqKH1f/86oK1jJD4zpdjGuI6vi0c4hTBHo
	 +KKYSLx98qMDtn95VjEbldf/YgSeQpLsHBGVHPr68UP+HD1nV+SQ0hyXUxa10/U9clQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946097;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=3LoKf20MwEHZIix2Qwz++dpjfh3HNxQ1Im8WwkUGPOo=;
	b=q0IZYNfYuGaxsQ+rONcjW5otE+FKu3NTP3Qd4O+pnLVWx5tknA6WdlUYzi0xQWbL4JPR
	 QNwEDRMAzPtb6ukUT4MjYgm/mNcDIus9zH1jcsWMIjtOpcMYro6mIjRH0iXeUMDH/3zyU
	 +rnYNr5xGMigfW1h515EobOqbjMKFSYwSfkRe/N6OrDhTipsS5UvmPulmMgcIvOegONSM
	 fTsuCk0Xo2JZZjuA+wFJBqbDSdJhkxUYGJLNEKjbitkrI0b5iEq0lU+NrTwgjsFAae+i2
	 WD3LhGox3k7czqiRbz0ZuwiHVU+B4DX2bA4h/IPEyP79HUC22XEwRasUcE7CGS3ckqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wxKlcO1b;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA61606A326
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 06:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFA61606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wxKlcO1b
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c423b145922so37745966b.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 22:21:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793946095; cv=none;
        d=google.com; s=arc-20260327;
        b=GntqdVgBH6zjGgAQbefd2AF57sNFrmbMwgiBbGIqA8Znu91XSyHmWMX7KbgEAwwa0i
         HrslUXalZ+Yhz1nJDGPzF+ljN1Z3BIR0ftNVdJ+n5Lo/pmXlVOAh+TMfZoQJDLETPVsz
         aXLSPwR9K0j5ID14KpQ4sA5M70NYTcJEKAUj4iwIgpg/xB/gt2SvZS7CU+CzwZFxNwCR
         b02YvjrwLDJpcZmqdoi0OHmcOepXdWitSU7lBPm9FMThEMumLMxoDTQJMx2+JfkX9D2A
         f5jEFXnUbCceduFc8B4x/Hdqg/qt/C7CPIjYwDMct31D3aOeblZQkW8EvX1GMr4rsZrJ
         1F0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3LoKf20MwEHZIix2Qwz++dpjfh3HNxQ1Im8WwkUGPOo=;
        fh=MFGww5WWwMbVBAGzYlobFNpyX4w0AV158eWpczIR550=;
        b=jOFvHZuoLbSC1NYGR0RWTkN4dUEhlcMHHQdjLGpZxI/llMuu3VCJFmGvvmpQs3zY4e
         4xo5P9Tx56buJOakTm0foj1hKMm82FmVyRVyb92lK9Sk+ODBgB3GOQ6roevj6DYNZMck
         /VHb2bDWtK7S36/NO37vyNXjgoaSZKwIfGbkmiNsqjkAqTPUBlIs4GG7iWqCk/+NPtlO
         d+azkdiXIxYxGaTnjD5JP7nApxZ6WfdYwSJe+viSUhvgcWrPgzZjoqM/dzjOGkvLXtXM
         EYQ4pj02JMlatae9wI1ldkMs7sSDt/mtTQ1RjjhRa4XwmOqCwPePM2nIha5QdFAOYxXE
         5G+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793946095; x=1794550895; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3LoKf20MwEHZIix2Qwz++dpjfh3HNxQ1Im8WwkUGPOo=;
        b=wxKlcO1bx1PdAfCk1mg5pkSwABsyOVIdUBN4Sfw8eKY5EOBVfKu6D4fqN7Wg+ejgTg
         WduUa0WBFAIsfjD4/64t50vUxyXrd0+AdycZaGmG/htMHRJNPtRaVcvjgR9z9h5k8xwE
         7dnIqfqXdVDJZdI/glcZBrY6D4SxegAK9P5ZOzsmXumTCdjv/Oc4AabEQ97lTPxlG0IL
         sLMlb9SdVQkQWcpPB125b2MD79+hmhljCGj5PX24oSzEFbHCCe7QQmu9y3g84dw1qUyp
         0kK60WjJSn9bKnCijTbHC1hEQ0rg4HDHh91uVODrBLm36xDmdKO+GZX/fc1NK+z5K1N2
         gkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793946095; x=1794550895;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3LoKf20MwEHZIix2Qwz++dpjfh3HNxQ1Im8WwkUGPOo=;
        b=gJbKn8nrKkP0b6EgIhiv7qWsMb/qhi34DNGiBxLBczQ6hJnb523TCISyRec0CClkVj
         U7VB1HZGDIVxtmkANVeFoNUognqMfccIdu9kahWhDARxNZ46Z73umnHqYEtszpxuydav
         u0vw+2XQl7uYfnPYSgmdXJPZrBhIRwKIJ0wOQwALe4nJat+ZLmKEnYHShdgNUTvEBa5l
         ZVjqK+ViRE2oN9vv5o6k/us4n2bG6rh9XihCYYHjjyHZxFSfG2sce6RwzfnrsiB2mwIP
         V9rrPjXF8sQ4x6RTu/qMMUbZFutEoPrK2o+x/Sn91DGRVIv1wP3oklWnfserlmB8CHoZ
         D4tw==
X-Gm-Message-State: APuU4Z/uNfRfcQ8zZRjWGKVTlxu2Xjdp1ry+n1yDZvI0uBLFpy/C1vg1
	s5kj0sUrqPCuEqxswM8YZq3gNMcFI15bOstn+gmLzb1Jz8Vol7gNflQSq1JmNE6Ne6i1bU3tXTl
	ZSl7mlnWhT9GEob4eZZfmJLV8UZ4fTVTRjM7oxsw=
X-Gm-Gg: AYBFou3OXT1gCmilCPrFORWYIf7Ypv1dAqlvK92MvMwCqTwRX8vkz2O5s7TXTCQkdnu
	CKUidJdRfI+jOfWV2EyNAXuouvyl5XvFKCRdc3hzcEF+juCJO0asLHite/73QfDvqyiMjQKNwaE
	Lpx7B3xjwH/ui18kf8llF/jQPKJf6Q9CF8Ezh1DomcsEhUnsO+NGGhMmG6gBzMpnwpxGz/ttIE7
	Jl1kYOuI6UYcToDpmhZ1rMDmS7ReDO9JdmqGLc3pNl9XAPPh0MQ3VtemTbNd4p0dcJOLSw2Z4in
	TJ+VlmmUDlOusov/9E6vXfsazG1DXsqxlE18qfKmKw8Cyr53VL32DB+J+p0w7XTJuj06EqB9nad
	kYdv0LvEozFYxIj/OlalqXx4ss+rALFFn8hFSafd5geEQKIjpzIJXMXE0f/TTV6qTLbfHuNkccv
	Eiqwf9kpzgi+va6Eo=
X-Received: by 2002:a17:907:9411:b0:c41:9228:baef with SMTP id
 a640c23a62f3a-c4d34a6e657mr123545466b.8.1793946094933; Thu, 05 Nov 2026
 22:21:34 -0800 (PST)
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
In-Reply-To: <20261105143138.484820-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Nov 2026 07:21:23 +0100
X-Gm-Features: AclHuK_ynsYgRDwiX3MIHrqQF2zQ-81IUU4PGkCQlPPBpdP8O843cjxCMHAbxG4
Message-ID: <CAOQ4uxhmh7OpoGnNacFedBPm+jUQfDzv1QD4H+jTvb2kAPK=4Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] overlay: always follow metacopy into data-only layers
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 3:37=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivano=
.org> wrote:
>
> A metacopy file with an absolute redirect to a data-only layer is followe=
d
> without metacopy=3Don and redirect_dir=3Don only when it is in the last l=
ower
> layer.  In any other lower layer, the next iteration of the loop in
> ovl_lookup_layers() calls ovl_check_follow_redirect() with d->metacopy se=
t
> and fails with -EPERM.
>
> A mount with userxattr cannot have metacopy=3Don and redirect_dir=3Don, s=
o a
> user namespace mount that stacks several metadata-only layers over a
> data-only layer can use the metacopy files of the last lower layer only:
>
>   mount -t overlay none -o userxattr,lowerdir+=3Dl3,lowerdir+=3Dl2,\
>         lowerdir+=3Dl1,datadir+=3Ddata,upperdir=3Du,workdir=3Dw m
>   cat m/low   # metacopy file in l1: works
>   cat m/mid   # metacopy file in l2: Operation not permitted
>
> Skip the check inside the loop for a metacopy file of a lower layer with =
an
> absolute redirect, on a mount that has data-only layers.  The lookup of t=
he
> data stays lazy and happens only in the data-only layers.  A metacopy fil=
e
> or a redirect in the upper layer is still refused.  With metacopy=3Don an=
d
> redirect_dir=3Don the loop already continues after such a file, so only
> mounts that failed with -EPERM are affected.
>
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> ---
>  fs/overlayfs/namei.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ca899fdfaafd..02c64a5652a0 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1087,6 +1087,14 @@ struct ovl_lookup_ctx {
>         unsigned int ctr;
>  };
>
> +/* A metacopy file of a lower layer whose lowerdata is in a data-only la=
yer */
> +static bool ovl_is_datalayer_redirect(struct ovl_lookup_ctx *ctx,
> +                                     struct ovl_lookup_data *d)
> +{
> +       return d->metacopy && ctx->ctr && OVL_FS(d->sb)->numdatalayer &&
> +              d->absolute_redirect;

To further reduce risk, assuming that in the intended use case the data
references always carry a digest, can we reinforce this to
d->metacopy > OVL_METACOPY_MIN_SIZE?

> +}
> +
>  static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_look=
up_data *d)
>  {
>         struct dentry *dentry =3D ctx->dentry;
> @@ -1154,7 +1162,8 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx =
*ctx, struct ovl_lookup_data
>         for (i =3D 0; !d->stop && i < ovl_numlower(poe); i++) {
>                 struct ovl_path lower =3D ovl_lowerstack(poe)[i];
>
> -               if (!ovl_check_follow_redirect(d)) {
> +               if (!ovl_is_datalayer_redirect(ctx, d) &&
> +                   !ovl_check_follow_redirect(d)) {
>                         err =3D -EPERM;
>                         return err;
>                 }

That's too promiscuous IMO to continue to loop as if nothing.
You subject says "always follow metacopy into data-only layers"
but this allows also following metacopy from l2 to l1 if there is a
datalower and that makes no sense.

What you would need to do is taint the lookup ctx in case we decided to
follow against the follow_redirect/metacopy config in such a way
that finding anything in the lower layers, even a whiteout or opaque
object, will fail the lookup, because then we are not really allowing
the intended follow into data-only layers.

But I prefer to do it differently, see below

> @@ -1238,7 +1247,7 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx =
*ctx, struct ovl_lookup_data
>          * Defer lookup of lowerdata in data-only layers to first access.
>          * Don't require redirect=3Dfollow and metacopy=3Don in this case=
.
>          */
> -       if (d->metacopy && ctx->ctr && ofs->numdatalayer && d->absolute_r=
edirect) {
> +       if (ovl_is_datalayer_redirect(ctx, d)) {
>                 d->metacopy =3D 0;
>                 ctx->ctr++;
>         } else if (!ovl_check_follow_redirect(d)) {
> --
> 2.56.0
>
>

If the tooling can be changed we could introduce a special data-only
follow marker and in this case we could just break out of the layers
loop when it is encountered.

Another option is to implement opt-in to redirect_dir=3Dfollowdata
which only allows following absolute redirects to the data-only layers
which will stop the layers loop on first found redirect and requires
a data-only layer of course.

I prefer this option if it meets the user case's needs,
because verifying that the redirect doesn't redirect to a lower layer
just complicates the code for a corner case and runs unneeded
cycles for no good reason.

Thanks,
Amir.
