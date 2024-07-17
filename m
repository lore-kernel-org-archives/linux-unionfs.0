Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F751849D5
	for <linux-unionfs@vger.kernel.org>; Wed, 17 Jul 2024 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239668; cv=none; b=LENj22B5uVs69taOngS4sSdaeOe3iVhhA4SqenXizL7pSExgMGG3beNWTtfHKB32wTPlRBfUqgqP/SCFqVpFVJt8GrVwNKyPU/Lc0ptTxut14N0z/q/+RHg1QloRlQuRj9VlUVis5OtqIgdZAwHbH82jHloxTGgNiXVPdf0HSbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239668; c=relaxed/simple;
	bh=6D8O67LjCGICjjsJrj43e+neQYbCYawqOk9/3C5qJOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mDi+s0+6W00qku+8paxw5qG/PgqogJJnb4iKWK8xqgv0X318JZh8UrNXtJLDz4hS+liiVj2aCSXoq+e3De09ZJzrro9rO+eXpBb9Vjc2z11www8fuSJonp/uTDgzxm0srfumqMX9Ii8Oo64DvBq+E/4ovptyz43YmuV86EWD0xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mggg/K7V; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mggg/K7V"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-79ef82c6344so409564485a.2
        for <linux-unionfs@vger.kernel.org>; Wed, 17 Jul 2024 11:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721239666; x=1721844466; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msC1Y2e7bXumDID0URgkwmQXR/OIe6pw9aA2nKYkTNE=;
        b=mggg/K7Vv2lketnFZ+iFT0SY6e7MQkwc9RlxSK2j735BkqCAiXJMQFvkj4Tv8bwBwE
         /u31rn74VQzsOyCbeOp7GeOCq3kYkgZ0ybOhUTHuX9F2FzW8RFbcv5SvyM+kX3TTejC/
         p6fNZ59l7hEvBjK7COTj+n5n1a/WAVplFMnvy3+CPLWL5X0FYMOQjIfuf9MT9JvoYP7i
         4rshOpf9LJLeHP7bQ8AeeuBoImOmAYFpuME2+KIAuyLMfFhlbehbuFITfdUMLroAXC4q
         E6/R3kJKvp1qKDhYhcdhDcnykOlpx8LzxlzqYeo/Gx8tM8lB9cRgLHlJOOW6/YP0Micd
         dEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721239666; x=1721844466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=msC1Y2e7bXumDID0URgkwmQXR/OIe6pw9aA2nKYkTNE=;
        b=rduejiH7XglpZg0iCa8NTmxxux+3TDa9zwN8BZwYiS7tTb6SyqMZ0QJs5LUQ4p63j1
         YWMk7RNGD8VtoNVlKY0Oh252SpDLu6RABaDRUSuYJ7Y8p91sB58yTDxBVddXXAaiouEe
         L8sHE5x3UuoRvaJLYm7M5/if0EfqT09xHAeTMeiEPEv0vLFz2aD+4aobeqgY1BMh2mHi
         hrIGDLfokA1gXIareNWXFMq6sODDWgin82/hKMIxAZvZ1bNR3JueHMbzfJPlrcTtaPWw
         mpRzZd5RQ5HN/JksUKy9VHr5aFNQe1GdGlN/0nlqV8U7JkgdwI/SsKSzuXEG76S1d3+R
         7pBw==
X-Gm-Message-State: AOJu0YxdzYGa4mclGTb1q9YEb4WaqVQd5MVDNBdZOpwGjZyW/bqCj7Fw
	MmPn/JHlawPeEK93Hv/lpXOgBWINDa52ABzG1/KTAvhwTLcnlgaKcrVZUHSuLhbFzvTthR4gUPL
	GFIVkHsIvMkpDFuT9ZzCBFpMWsWA=
X-Google-Smtp-Source: AGHT+IFi5L6fudm8vSUIsMTdiejRFD3qD0JUOxyN7nVjtbwIi2+nhX+WVaEkfpMw9OLPLbA8BodFcJ4cbPso4ZotfhA=
X-Received: by 2002:a05:620a:6192:b0:79f:d0f:2b19 with SMTP id
 af79cd13be357-7a187513a75mr276776685a.68.1721239665765; Wed, 17 Jul 2024
 11:07:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPt2mGPUBsiZTWTPWFKY-oLNCNZBY9Vip5DJ7bzvbExtgfZc2g@mail.gmail.com>
 <CAOQ4uxggxOinJubYAzFbP2puUN=7FTCSkxPqM=aojwganC_zpA@mail.gmail.com> <CAPt2mGN9txjP2x7GJmGgU=JgnM87dAnOQBmqVSA0N=W17wMhng@mail.gmail.com>
In-Reply-To: <CAPt2mGN9txjP2x7GJmGgU=JgnM87dAnOQBmqVSA0N=W17wMhng@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 17 Jul 2024 21:07:34 +0300
Message-ID: <CAOQ4uxjFbOD_XfbzoYGd=4u4y7rK6UtJ1G82VkP1Pc_S0z7yfw@mail.gmail.com>
Subject: Re: overlayfs: NFS lowerdir changes & opaque negative lookups
To: Daire Byrne <daire@dneg.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 6:37=E2=80=AFPM Daire Byrne <daire@dneg.com> wrote:
>
> On Fri, 12 Jul 2024 at 00:30, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> >
> > One more thing that could help said service is if overlayfs
> > supported a hybrid mode of redirect_dir=3Dfollow,metacopy=3Don,
> > where redirect is enabled for regular files for metacopy, but NOT
> > enabled for directories (which was redirect_dir original use case).
> >
> > This way, the service could run the command line:
> > $ mv /ovl/blah/thing /ovl/local
> > then "mv" will get EXDEV for moving directories and will create
> > opaque directories in their place and it will recursively move all
> > the files to the opaque directories.
> >
> > Actually, current code does not even check for redirect_dir=3Don
> > (i.e. in ovl_can_move()) before setting redirect xattr on regular
> > metacopy files.
> >
> > So as far as I can tell, the following UNTESTED patch might
> > be acceptable, so you can try it out if you like if you think this
> > will help you implement to suggestions above:
> >
> > --- a/fs/overlayfs/params.c
> > +++ b/fs/overlayfs/params.c
> > @@ -824,15 +824,9 @@ int ovl_fs_params_verify(const struct ovl_fs_conte=
xt *ctx,
> >                 config->metacopy =3D true;
> >         }
> >
> > -       /*
> > -        * This is to make the logic below simpler.  It doesn't make an=
y other
> > -        * difference, since redirect_dir=3Don is only used for upper.
> > -        */
> > -       if (!config->upperdir && config->redirect_mode =3D=3D OVL_REDIR=
ECT_FOLLOW)
> > -               config->redirect_mode =3D OVL_REDIRECT_ON;
> > -
> >         /* Resolve verity -> metacopy -> redirect_dir dependency */
> > -       if (config->metacopy && config->redirect_mode !=3D OVL_REDIRECT=
_ON) {
> > +       if (config->metacopy && config->redirect_mode !=3D OVL_REDIRECT=
_ON &&
> > +                               config->redirect_mode !=3D OVL_REDIRECT=
_FOLLOW) {
> >                 if (set.metacopy && set.redirect) {
> >                         pr_err("conflicting options:
> > metacopy=3Don,redirect_dir=3D%s\n",
> >                                ovl_redirect_mode(config));
> > --
> >
> > Apologies in advance if this idea is flawed.
>
> I finally got around to testing this out
> (metacopy=3Don,redirect_dir=3Dfollow). I had to munge it slightly for
> v6.3.7 (because that's what I had quickly to hand on this
> workstation).
>
> So then I did something like:
>
> mkdir /ovl/lib (makes new opaque dir)
> mv /ovl/blah/thing/version/lib/* /ovl/lib/
> rm -rf  /ovl/blah/thing/version/lib
> mv /ovl/lib /ovl/blah/thing/version/lib
>
> With this I get an opaque lib dir and new (non-opaque) dirs below with
> all files containing xattr redirects to the lower level files.
>
> One issue I came across is that it was failing to "mv" symlinks:
>
> mv: cannot move '/ovl/blah/thing/version/lib/libpcre.so' to
> '/ovl/lib/libpcre.so': No such device or address
> mv: cannot move '/ovl/blah/thing/version/lib/libpcre.so.1' to
> '/ovl/lib/libpcre.so.1': No such device or address
>

Not sure. You'll need to debug the problem.

> Where the lib in the same dir they point to was "moved" just fine.
> Again, I can't be certain that my munge of the patch for v6.3.7 isn't
> at fault.
>
> Apart from that, clearly this is a much faster way to build a metadata
> overlay with a root opaque directory in the way that I wanted
> (localising all library dirs and associated lookups).
>
> One doubt, I only need an opaque directory at the top (lib) and then
> everything in the tree below will always come from the upper overlay
> right? So lib/stuff/python2 where lib is opaque and stuff and python2
> are just dirs that would normally be merged but for the opaque lib
> dir? I'm probably confusing myself a little at this point.

If we want to use accurate terminology, lib is not "opaque", but it is
a "pure upper". it only needs to be "opaque" if there is a lower dir
below it that needs to be hidden, so lib will become "opaque" when
you move it *back* into place above the former lower lib dir.

The story with stuff/python2 is - when they are moved into the
opaque lib, they are pure upper and not opaque, then when
lib is moved back, the whole tree just moves so stuff/python2
remain pure upper and not opaque.

Unless I missed something...

>
> I'm aware you can have the redirect on a dir below the lib directory
> to get back to the lower dir contents again. I'm just not sure when
> you are many dir levels down past the only opaque one.
>

With redirect_dir=3Dfollow, new dir redirects are not created when moving
directories. Only non-dir metacopy redirects are created.

Thanks,
Amir.
