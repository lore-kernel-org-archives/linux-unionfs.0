Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE736EA99
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Jul 2026 14:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607537; cv=pass; b=C3ehQ/W66+dselUn1xfD7yH9mV/ZwTqJw1uL8CrMrq1b95h0/JhFSfNHMcfvNt49XiRskUKD1XIf5z/6PUu6iKsuGN/u1T8nN18m/WO+Gez4RHPzXcSKlZkJMhbKN8ufvz+ujeIq+2WQGM+1ps0Lzfn4EKdLty25SEygdrLby0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607537; c=relaxed/simple;
	bh=V+vuL0j1CDdaZ4B2w4C4rlJ2/cn1tosD1AB7fGsK18g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LXZZ2pAGs5cFk+ZGQy1LBYvorufBhdN1g2TKdQ2cHw8r3P0dtp1R5d18qicX/kC4RTh8CBcMf5c5M3J5nB6R+33ahBHc93mm/r87GfhUYA71UMGZV7m1Xyyau3UT+Aq9MwdRLzQI9OWA18iO25RQ2HUMW9vhPSSrjLcKcwR1xSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O7/KyWE+; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7/KyWE+"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69a0ccd9669so1995968a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Jul 2026 07:32:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783607534; cv=none;
        d=google.com; s=arc-20260327;
        b=FSNK4JGUPRDked91uK2Qb2zltKkqP0Qfl6oRP6xf48js4kb7z+zjRH8j01/4MFvrvU
         t9rJKyjpZWFB/VJRvPeUbqI2RthFnlcsXxkLjCRomnW+uYC6t6MC8bG63WI8f9TvJ6Qu
         b7HZL9RikgkUspQR22ukkIFeJU+wmLGRvH+6dso5/kcklp6Ks/4IX/FlMI/LX/MabLTQ
         009F7S/RP4emMJ3CxobtJDCzzxR5frt0KovHjaMa/GNVEhuOQ2tWi4YIgR82Zg05r773
         V83hkaMomCfwsndTxxmOWzLQ/NPdmdGX2a1I/fuqdAlJAPZipHw2Gj5uXR7HiQCxqMeu
         VQDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xhzYe1XjtaTfQ052TLMa/MvT2DI4Z/2XBeyITmqTEjM=;
        fh=griOtbMVYRtrHwDsNt09kjFkNypB4C3BNFxIpnzc1g4=;
        b=pofxPULcUjmexdBkmV7XaNIJPMGOIvyyMAryTBNga7zQ/9R3xdTdKSFIYTYNH2AO/R
         uvqyFvTN6S+GfIg1fJhnvJ2etbfbISko1oZmXSichtjWfiEtA8VnF3/X8nj6t47q1AWr
         tt/WU6Ywj1X4kuPWbdTBGEV8JHyxSllsaDvKVoy16Ju2IYxnir8TnjkujNVdwGcRaHnf
         IMZDHA43FEaKXQiYloBE+9RPnUv4ceDLONeT5gZq9jBV274FDbn4ejYJDAJ1RwQ+GBJJ
         IxZibsg+UTGqV6YTVbdd4KC7a709lJ7cuzr+VxPx5jKpg5ugDbC70oRueOsmQvFHPSQY
         B5/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783607534; x=1784212334; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xhzYe1XjtaTfQ052TLMa/MvT2DI4Z/2XBeyITmqTEjM=;
        b=O7/KyWE+y6ah8SKUEau4X6rsSTeI5LcfWGUIzU8Wtion9C+SD1nmIODKPpmIsoKrrh
         HiSEn6TwdZctQyMb1yv7aitw6jSRILjMFYXiPixTwm2kN6DfG8ZkA0lA429KmYiByvcy
         UXN6l82m+94NDmsWERpSpMAgwM+BwADhyLL54J1ONR1aDbXNA16dPET4SfPD4onl0pcp
         1SeEC9NP7fpx1jAHFnMOGVH+jMIPA2NFxdRZnqDUawg6tyQJTgkqa6z9mqigZLBqSRUU
         bdct+sGe/pZlqZI53bS0gEKjUAC1bvzg+PtQRm9n+WWg7a/qlK8Ps1jNLpIhjl+r22+G
         MJIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783607534; x=1784212334;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xhzYe1XjtaTfQ052TLMa/MvT2DI4Z/2XBeyITmqTEjM=;
        b=HSTcuYLw7krBcTv02NvMyKCtnil/iLI+euDjuf6i8lwEKAuytyzMQFutjBDVDtpOdT
         pzkXvCC0w/yZdo8h+fN9z0hcoNSlKMjJwt8e3BkgGDltw/wkd8GclzMBUiEtpLsXvs81
         5UdLxQAUdF9b1m0ZhgQ4loVSHkNmIY+xoS49low1DguL2zlbU2GlCBy0YLh+JxigoTId
         cDuBZhuzdhBUWm0uf0z5BOJuZdgzNCN7glqtPh6lVSgDNU81FTie/8wjNX5O6XKiJIOp
         0mERT6OueL0nTLv1LaG6M7ICsEaOGpt5rRV9+/ncIojiiD1EIZ8W3i6jrzO7FPHXut4E
         tuow==
X-Forwarded-Encrypted: i=1; AHgh+RrU6Akun6+vTgLwNihvup3tLFrHC3MJKe8U0/Tyerd6lnDTbiLapz//mRc6DiSLvZVK0RD4maSfgDeZi47s@vger.kernel.org
X-Gm-Message-State: AOJu0YxfdUDCOi7EYlPS1AmSdLW0yHdFwLsLqqlD2XoZfHwkVImYeuXk
	wT+sQn5PCGM+BUJ/G1I762mILc2Vb0wezUvxs75tZncYVJ/qVKeRqRYgGpwxWgB141TYDwe/QAE
	Znk6JU8jeK0uv+r4bn3FaXAS+uuAHXzo=
X-Gm-Gg: AfdE7ckl0gs/iP80fIS/mpTeJwh8pltDrA2Jo6edHO1jGW9KWk/cSf/9ZG24zZSjDlS
	ReCMXlSbEVapWCZGibjLwznNACyv9456aZBcoDU4m/IByGBJUPrO4QR2MvKIRJ9TvCOqq6g008a
	31b0z2ATe1L+t9mzBQ2Jqtw9df2wb2K30l5q2DFvi0VtQUlXxE+hDS9WN1s9MR8saWL6Aem/OmG
	Qn3Hox/yVj7Au/niTwcr/BO6TlsUOLAoSeGjjTHCdnIhu3NaPzVfpLY0i7gtVtVH0sLM7MZqg==
X-Received: by 2002:a05:6402:4512:b0:697:8136:6d85 with SMTP id
 4fb4d7f45d1cf-69ab445d5b3mr3087023a12.3.1783607533539; Thu, 09 Jul 2026
 07:32:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com> <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
 <87wlv57dt1.fsf@redhat.com> <CAJfpegtTixwWSh9M-9NbwP0nUbJJ9rh0rxqO7BzgK7Su_RpM+A@mail.gmail.com>
 <87o6gh79yi.fsf@redhat.com> <CAJfpegvUEEbFnCa1N9k3gMXpw46YFpWuta=G6brON1=xU36bgw@mail.gmail.com>
In-Reply-To: <CAJfpegvUEEbFnCa1N9k3gMXpw46YFpWuta=G6brON1=xU36bgw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 9 Jul 2026 16:32:02 +0200
X-Gm-Features: AVVi8Ce_W-yxg-OnXjZQCWKXwRdUfH6E4eFRwx41VYV2twepSkLr2IZMZq1JXHI
Message-ID: <CAOQ4uxgZuJ+=RQDh3577H7PFAfYyF=wRJ55aPuuUW814Htrmbw@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Daan De Meyer <daan.j.demeyer@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 9:45=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> w=
rote:
>
> On Wed, 8 Jul 2026 at 17:55, Giuseppe Scrivano <gscrivan@redhat.com> wrot=
e:
> >
> > Miklos Szeredi <miklos@szeredi.hu> writes:
> >
> > > On Wed, 8 Jul 2026 at 16:32, Giuseppe Scrivano <gscrivan@redhat.com> =
wrote:
> > >
> > >> Amir suggested to add that functionality when I've asked for some
> > >> feedback before sending the patch here.  I am fine to drop it if thi=
s is
> > >> the consensus although I see its utility from user space.
> > >
> > > How about a completely different interface:
> > >
> > > int get_fd_opt(const char *name, unsigned int index, unsigned int fla=
gs);
> > >
> > > Enumerating layers would be as easy as passing an index stating from
> > > zero and stopping when -ERANGE is received.
> > >
> > > It would work for all filesystems that use files as options.  No more
> > > fs specific ioctls.
> >
> > Is a new syscall really justified for such a narrow use case?
>
> That's the reason I advocate pseudo fs based solutions.  Let's see, we
> had a proposal to use openat(), something. like:
>
> openat(base_fd, "mount/options/lowerdir+/0", O_ALT | O_PATH);
>

Ack for this, but please don't use mount/options/... it's a bit ugly
because most mount options are not opan-able.

Please stick to something logical like "fs/layers/N" corresponding to
ovl_fs::layers, where layer 0 is reserved for upper.
We could also support opening by aliases fs/layers/upper->0 etc,
but no rush IMO.

What I am contemplating is whether we should implement
introspection of the ovl_entry stack for merge dirs in addition or instead
introspection of fs/layers.

IIRC, the root dir stack does NOT hold references to lowerdata dirs,
so support for "fs/layers/N" is still needed.

For directories we could implement "real/0..N" with aliases
real/upper->0 real/origin->1.

For a regular file we could have constant aliases real/upper->0
real/lower->1 real/lowerdata->2 and/or dynamic aliases
real/data->{0,1,2}, real/metadata->{0,1}, real/origin->{0,1}.

Those could be used to implement "revert to origin".
Specifically, I think Daan asked for it during the last LSFMM.
Although I don't think we currently store the original lowerdata
in ovl_entry when lookup is done post data copy up.

Thanks,
Amir.
