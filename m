Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C982F171BB
	for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 23:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779145963; cv=pass; b=chU3BMyMd2wPLiM4G2ZBaywIQzXGTwADCoaEop0Kv+XZF9XZXd2/4IwELE7Lp1N/KMIrvOg+oiPoY/w/R7LM8aDf38jEuRx3LrNNIFkXt3WXKBCcqvV1Rd2OtTUjh7Bu2nwK6caE4AusPFbh37kPmZf+aUK7A1gRX4PipWDyTQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779145963; c=relaxed/simple;
	bh=ZUehhhssQIFmaGUQqCT4Xs29swHFCaFH7l6xpHdcYpk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lIxrFTXYeMuGbDVFuntosgvhqkHAq5E/UM3c8E06m79YoLLaT1OwbKTcUJOp8r8u+gICzGxk4pGK7ObELSDrtrAAuUtZgdTS5s/7MzwvdFgufUz+GBLtE19f3eSEjSdXbA+Cygd/a7qnAy40Z7GeDql8Qs6YzNa89UzjE1DwwvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HcHLCdm5; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HcHLCdm5"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso17439505e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 May 2026 16:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779145960; cv=none;
        d=google.com; s=arc-20240605;
        b=hM1NoM8qjezd07xV3fK0g9WSAkmJzMkj5lWMR4YQleACvW8jXdQPaJhOfOnqOH2GXd
         vrcz8QnwbZuqsEA+AjphZa1DE8oD0f9WXYVXvp1ndexTiGoJDvTspjoyLtLvrmh4OfPZ
         z1arJQ7ZSbVIkmslh9tLLBDoUDhgA1O8XcJ7FV0Ea7ac3cycbHyfRHjSnQofNArKQiCk
         DSwSP6K/rhTQgokmTPdmtu46fvd/VF4ZMaN+5GK86Hq/LXusBMoFbUMWTjPSYus4t/78
         7OzgkTbMCGKZiOgo22QCLr2Fw3Vsqz/CLCwu6qp/OjgJHeCsMM0SUVPG7ItnCe2GwRi3
         ZWwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Ol66b8kKVYZPFuYH6vUoeuCC0cJCNOi44dQnPgvHjg=;
        fh=Cmf7TkEPFcBDz57tWBw4Bsl9rOtpQRsCoopm+L4QZ/A=;
        b=edQZD/8tBE+IfjWvfw29Ddq0QY8jRjNxX5rfewJmQVQ5Np7KKz8HH633I6MbOiQfvT
         w2Lasv/W479HHQYtgfSM6RV2CHB02pGSjOHUf5MNpJkl9yNImXmCT5hlUN4hoaIdbbq9
         w1tAI4Sl3NQgi9zUPeESSwOJRXMY2SpVruN6OJyINIO7xUZLUI94sMIgLO7ZKxg0FaAl
         Cu6SLtF1fsPPenrsgeJziNcBcIcpFFfYNFqmrvxOKRrDrbXsx1chQDmysibE14oK6zyr
         JixhZzaj2m50lP+E78bQiTA/fOdYEbvdRdCFBxhD+SsPCBtwMdImblxTex9ILzLo6cNa
         S2vQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779145960; x=1779750760; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ol66b8kKVYZPFuYH6vUoeuCC0cJCNOi44dQnPgvHjg=;
        b=HcHLCdm5FnIqse1niuQXDWsCkcRzz+5F0YOGXhxu09YJty62Kr/SzWCQsTmNq2sjfS
         9tJnYsGBDf3HMk2/W0WenuoiziRc8/snA5yKlpQa+SqX1nF2VY7xEzN587nRdTqOoL4q
         qIS8My2fAocSXaxm3GLtcMmDu+AskuA+LN180zo2yDRyxf+MkuQIArHed/GnavzpvDRc
         xlSB9n3x0OF67X96MafkhxL431nKg9H6KmGDHpZ6tr/AkBZGptWgYlm5VvWOS0w2CZlZ
         W818U/ygyCPThQfgwpwhQ64hLmbHga2j77ILBaKv4hlx9vPyYXJ3YqAG9aztZMZG6uIj
         SdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779145960; x=1779750760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Ol66b8kKVYZPFuYH6vUoeuCC0cJCNOi44dQnPgvHjg=;
        b=YzVARV1xQfXCosbGwG4PCF6I5dT8oi/JoSBFbyaG46rcjEf+LqRxpgUf9wgoYE9Irl
         DWzhRiZs9X5ZXCisnjAoJRkz82cvo98s6hWiEBjMwE+yDGdMAg+PCU0GaXhE5iyfO63g
         dilZEiudG5WEhz8X12DVmuKrtiSguSHgSPHLx3tamTyJ9PWVtacgBKYxpXTVgGg/yuYR
         1NBAhM3HLg636/G2CnQbjACaFdjnXKFJTx+Ez8HOEbLxRhi0l/F9fx3c/S2p8oBTi7wo
         qvFyxZz0HmuyUEUaHeQWIhiXVgcZacrA4Ps4AvIyLkwUB0MFME8YCz1WHpuBQjYtIkD0
         Htcw==
X-Forwarded-Encrypted: i=1; AFNElJ8JGSyqQb1xwPM33vGAGfW0Ti8pHO6dUuts4i1To8yYE1rxSBSHY6SVvCZurIDxWqFrzKUPkDhPF/FLd1td@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9Z0J5LT+ZxV6fthsPGhEpVa8Dq3eDPo8kZ65AKr2edU0qxFkR
	o/4J0iTw2taQI12nqd4fHzC5oegkEvAB3Pe3CoVrbfoYGxpMffQVezPDu2lNjUepRVJLdqzn0oT
	4+nrMH2uzopg0ev8VSVtiEAVVmOIAnlQ=
X-Gm-Gg: Acq92OGJZojnUQxij64zhjfBK5NLhAEOd884fs6MkWDqLQvnLto9HwmoF0pDDz9tm44
	y2g9iD56tQo4xZBwW2clwVgGARvJVh9Wzkvg9z1yhJzrow/8xHsF9co4D3m0WLOqAKJ1cOvErEx
	aB0XR3Tg695aKZzd+05HmgekRaChc8eX/we1rs7s1VoWOIEjd2xyPS/K45EpijcgupoiyGO+HCm
	nbmJ5De4ZO7BR/PC+mufgAoHc41Nbg6UHaxX6oFxhoSJE6mwOoljavDlUHPDwTrG+b3GsQhCYhv
	DjGH2A==
X-Received: by 2002:a05:600c:a30a:b0:48e:62ec:f264 with SMTP id
 5b1f17b1804b1-48fe61f29femr207981055e9.17.1779145959932; Mon, 18 May 2026
 16:12:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
 <20260516004004.1455526-13-joannelkoong@gmail.com> <CAOQ4uxjMPPp-R37yKoOs1kGUdAOmnp3keVWvfuxi1r8jrxAcTA@mail.gmail.com>
 <agjDGBQPG2WpDTWO@fedora.fritz.box>
In-Reply-To: <agjDGBQPG2WpDTWO@fedora.fritz.box>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 16:12:26 -0700
X-Gm-Features: AVHnY4Lyu5M_Gh_zQS9q8KGunX9dmEQnO4OzkJ7iWv58OHW2RUtnn_wMfB6yDiM
Message-ID: <CAJnrk1b_55hMTRxtV8QKBqdfEhT_LQK2byat+x-a8Xrj4nicnw@mail.gmail.com>
Subject: Re: Re: [PATCH v2 12/21] fuse: add struct fuse_entry2_out and helpers
 for extended entry replies
To: Horst Birthelmer <horst@birthelmer.de>
Cc: Amir Goldstein <amir73il@gmail.com>, miklos@szeredi.hu, fuse-devel@lists.linux.dev, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 12:29=E2=80=AFPM Horst Birthelmer <horst@birthelmer=
.de> wrote:
>
> On Sat, May 16, 2026 at 07:25:05PM +0200, Amir Goldstein wrote:
> > On Sat, May 16, 2026 at 2:52=E2=80=AFAM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > >
> > > Add struct fuse_entry2_out, which is a new extended entry reply struc=
t
> > > that carries a backing_id and statx attributes. This will be necessar=
y
> > > for setting fuse passthrough on inodes.
> > >
> > > Add helpers that subsequent commits will use to process fuse_entry2_o=
ut
> > > for passthrough support for lookup, revalidate, and create.
> > > fuse_statx_to_attr() is also moved to earlier in the file to avoid
> > > forward declaring.
> > >
> >
> > I think you had a discussion with Miklos about whether
> > it makes sense to do a compound response for LOOKUP+STATX.
> > I don't remember the conclusion, but if this can save us all the
> > if (use_entry2) { } else {} all over the code, then I think it is worth=
 it.
> >
> > Can you give me the bottom line from your discussion or was there
> > no conclusion reached?

I think the conclusion was that for fusex it will be compounded, but
I'm not sure what Miklos is thinking for fuse.

> >
> > If we do that, where do we return backing_id?
> > Could make use of the reserved[] fields in fuse_statx_out.
> >
> > I happen to have a test patch at the tip of my fuse-backing-inode-wip
> > branch:
> > 6e296625eafd6 fuse: support setting backing inode passthrough on getatt=
r
> >
> > It's not using the statx response, and it was just done for testing,
> > but in theory,
> > if a server wants to  change an inode from non-passthrough to
> > yes-passthrough mid lifetime
> > doing this on attribute cache expiry may make more sense than on entry
> > timeout expiry, because backing_id is an attribute of the inode not the=
 dentry.

I like this idea but I think for supporting yes passthrough -> no
passthrough, it would have to go through an ioctl mechanism since the
getattr could be passed through. In that case, I was thinking it would
be better to have the interfaces be consistent (eg both yes
passthrough -> no passthrough and no passthrough -> yes passthrough go
through an ioctl interface).

I think even with the backing id as part of statx and lookup+statx
compounded together, there would still have to be the "if (use_entry2)
{} else {}" branching logic to handle the new slimmed-down-lookup
differently from old lookup).

>
> Hi Amir,
>
> I see there is a lot of talk about using the compounds in a couple of dif=
ferent contexts.
> I really have to apologize for not having the latest patch ready by now, =
but I'm
> a bit unsure how to do it.
>
> I'm not entirely sure if compounds will only be a thing for fusex or if i=
t will ever
> be accepted for the classic FUSE.

I'm not sure what the plan is either. I think this will get clarified
on Thursday hopefully.

Thanks,
Joanne

>
> I actually have a patch that I have not tested well enough, since I have =
to maintain
> our own version and then have to do the fusex one and probably the new ve=
rison for
> the classic FUSE version.
>
> So, sorry about that, but I'm not having enough clarity on what to focus =
on.
>
> >
> > Not sure if this is making any sense.
> >
> > Thanks,
> > Amir.
> >
>
> Horst
