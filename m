Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EA2181310
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jul 2024 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721230638; cv=none; b=YIPLA6GmervaDN/eU0E2xUdLgMTyuIkDLbSSC3NCA3rrZlntWkqNVZ5FfBm8UK+JmlaMMFwWrqLfNDbezi7n7HVtEYG2G1xa/XmOnKAWWN7bp8Eq3N7gl0IF2cUx/+I5O8vOenUtT7xHFl3bneK/z3zjBTfqXaqTTIRVyj5AIp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721230638; c=relaxed/simple;
	bh=gwEytMsA1olwofIBR2+Tu4ssGmBVEz6CoNRzN69Q1Jc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WtIXrA1JXq6N6xVKaQAbd1MGucVWtzO2x0jXimP4RrYWu4Uioe4hjUrV2Cytkyfo5j1X7w1cvtpJz4whrIT7FfefRJeARqbetvuqzfixk5kpyDYQIAQw75/OpdJ6vmXkS7qssdYP8IbXx7ndIDQriv3bDJHswA7/UzbBKIc8Be4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com; spf=pass smtp.mailfrom=dneg.com; dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b=UKzc0whT; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dneg.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dneg.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dneg.com header.i=@dneg.com header.b="UKzc0whT"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7037c464792so193501a34.2
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jul 2024 08:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dneg.com; s=google; t=1721230635; x=1721835435; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2iRxqvkysWOWq9aGstIDE/eBd34Lsba4gGwKUKaSMCY=;
        b=UKzc0whTUdxRbvaSGuMfdtuBrsgbENITKFN/VFHdn74BoIpY6SLI87bVn9ehqYvu2G
         KtISRB+IL7vSAZFLaXb4i8xV+smwwbFN58bAPfPxCbe0q4UcIx/sguhW/LTmbwqcevjF
         aB/pwzSeYM5Fo4xkEOLA6Oa/moz2+WF12ZUKlpFqfXFdUdQJyRSi3yUA4JiQra9ZPmiJ
         GESVcB8ipN6RXmVCu+G8fCA3HahmkDTAdUPzXn9SWj8aTzn4nRrO2siF88S0+acVWHy+
         +T0TuUTJ9g46BXZ1y+rq8HOSCbHcF3P4C+YOQMT4oadYfx+X5xictLg/JA/1BBvJV4OA
         a68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721230635; x=1721835435;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2iRxqvkysWOWq9aGstIDE/eBd34Lsba4gGwKUKaSMCY=;
        b=fSBKPl7Eekl6QnrFpVPEC/PS5vSU5vfcTvK//5aZu2Jjqpu6SZbCoChTc9NWsldBu8
         /e12Mr30cx+6q/xgnSyB1AFZKz35YtfGEIZAgGMERd+0y29o36wq4xUANtxcofnd2krj
         UHZd/B6y275+3+As/js0Uk46rkOt3CH7alM1FMUAU8IG7ob4+Whyoxz1MOWAYL9ecsK9
         Yluwgi6QDU//6ZD+cl68/K/bLoZmLPcp2oGRtwFpiEKHDIUVoMktV7SbDvuNmOOWpWjm
         nDtZsjbHAVvt8iJm3ESvMfvob3D7S5VjYaFXxk7g4S/7tyAHbfEjcH4GNtUrRKl3U0od
         cVGw==
X-Gm-Message-State: AOJu0YxH5KS4GIm7o8NdTyCPn/1fdkRpf3D5JUCKIYbTv5TkdtizvCjS
	UcmMKnI2aALu4vM3hZ2gKIBnE/SV/BMltM9Y/keI2iOunOnNFIIFRClFl+yMc81xE/1YxmHzuQl
	07DS3D/Z4HigvhaOEQYfIjwCuoqHbqYTKOzJnMw==
X-Google-Smtp-Source: AGHT+IGJTQ27J0pnGFt0VIJI6q7S9kXM2M/8JW6N8yLZN7JDCmYqYp+q2rppWphVKhrkmOGiLWCzf8GJTH6stXP08r8=
X-Received: by 2002:a05:6830:6582:b0:703:662a:4627 with SMTP id
 46e09a7af769-708e3814182mr1959138a34.35.1721230634680; Wed, 17 Jul 2024
 08:37:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
In-Reply-To: <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com>
From: Daire Byrne <daire@dneg.com>
Date: Wed, 17 Jul 2024 16:36:29 +0100
Message-ID: <CAPt2mGN9txjP2x7GJmGgU=JgnM87dAnOQBmqVSA0N=W17wMhng@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Jul 2024 at 00:30, Amir Goldstein <amir73il@gmail.com> wrote:
>
>
> One more thing that could help said service is if overlayfs
> supported a hybrid mode of redirect_dir=follow,metacopy=on,
> where redirect is enabled for regular files for metacopy, but NOT
> enabled for directories (which was redirect_dir original use case).
>
> This way, the service could run the command line:
> $ mv /ovl/blah/thing /ovl/local
> then "mv" will get EXDEV for moving directories and will create
> opaque directories in their place and it will recursively move all
> the files to the opaque directories.
>
> Actually, current code does not even check for redirect_dir=on
> (i.e. in ovl_can_move()) before setting redirect xattr on regular
> metacopy files.
>
> So as far as I can tell, the following UNTESTED patch might
> be acceptable, so you can try it out if you like if you think this
> will help you implement to suggestions above:
>
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -824,15 +824,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
>                 config->metacopy = true;
>         }
>
> -       /*
> -        * This is to make the logic below simpler.  It doesn't make any other
> -        * difference, since redirect_dir=on is only used for upper.
> -        */
> -       if (!config->upperdir && config->redirect_mode == OVL_REDIRECT_FOLLOW)
> -               config->redirect_mode = OVL_REDIRECT_ON;
> -
>         /* Resolve verity -> metacopy -> redirect_dir dependency */
> -       if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
> +       if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON &&
> +                               config->redirect_mode != OVL_REDIRECT_FOLLOW) {
>                 if (set.metacopy && set.redirect) {
>                         pr_err("conflicting options:
> metacopy=on,redirect_dir=%s\n",
>                                ovl_redirect_mode(config));
> --
>
> Apologies in advance if this idea is flawed.

I finally got around to testing this out
(metacopy=on,redirect_dir=follow). I had to munge it slightly for
v6.3.7 (because that's what I had quickly to hand on this
workstation).

So then I did something like:

mkdir /ovl/lib (makes new opaque dir)
mv /ovl/blah/thing/version/lib/* /ovl/lib/
rm -rf  /ovl/blah/thing/version/lib
mv /ovl/lib /ovl/blah/thing/version/lib

With this I get an opaque lib dir and new (non-opaque) dirs below with
all files containing xattr redirects to the lower level files.

One issue I came across is that it was failing to "mv" symlinks:

mv: cannot move '/ovl/blah/thing/version/lib/libpcre.so' to
'/ovl/lib/libpcre.so': No such device or address
mv: cannot move '/ovl/blah/thing/version/lib/libpcre.so.1' to
'/ovl/lib/libpcre.so.1': No such device or address

Where the lib in the same dir they point to was "moved" just fine.
Again, I can't be certain that my munge of the patch for v6.3.7 isn't
at fault.

Apart from that, clearly this is a much faster way to build a metadata
overlay with a root opaque directory in the way that I wanted
(localising all library dirs and associated lookups).

One doubt, I only need an opaque directory at the top (lib) and then
everything in the tree below will always come from the upper overlay
right? So lib/stuff/python2 where lib is opaque and stuff and python2
are just dirs that would normally be merged but for the opaque lib
dir? I'm probably confusing myself a little at this point.

I'm aware you can have the redirect on a dir below the lib directory
to get back to the lower dir contents again. I'm just not sure when
you are many dir levels down past the only opaque one.

Cheers,

Daire
