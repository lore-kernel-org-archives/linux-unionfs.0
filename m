Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795176133;
	b=TDv0K/awV4YU9Hjcz4rzbIZUYDIxVJpfNR2i+cKXss4ixjeiETUUKfdux0kh6mRhtb1j
	 lO+e8F7y/SeG8GP+jQ3BWLlan94NW16ER8qEtjOMAGmXPc1s9dYQ24xAxqibJsy0i4loD
	 XM43wXvMYFfd34ieCe0XiUVwVSKNAjrJmPwfbC0hjzvoI9kfSPJ3Xj5Q/iSXr9qW42GwU
	 NULqDZHg61bbNiYErBCf5zK7WRUYRshvi1tuESHC6XJzFmnf0dKXr4qTsnJswBHIZ1O1c
	 q+XucLqzl5iWNi0fBWFRlSUgwqcj035XjZREmQraJLI8OWD2oxa5CYsuiETWPrRlw9A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795176133;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=M0GVSOJEv4Fg5tAe9BmtD544Iu6fdkKfVtmzI5e60Pc=;
	b=3X1NoMaDISRQ1dF8LazK5oMjEyz1qBRNycg6rQHcrvAxoRGXhyD0I4wTFlPobVU/sPmg
	 mrHLODWiyguHhyaivIQ+rnx3XHO/I644+EbeXdfe8h4YGgGd3Xelz3Xwe96LT0jWBV63D
	 k/R4CLFmpq+sFlrBAEDEO4p4CyhH44Ocgdnp4yCGeu/fBYurJcigiiBKulnpZmUTkJkbt
	 SA88GAh5PIqv8ej2w75nwllkGiXsryqRLQDHb9PBwObZhzpdAtIFFY9eNOyyGjXw/+TFG
	 M2pSsq8xtiYd4ORXSYxQtP5PKZ/6/D+Cv+haCDput2cX0licI8TLdkylsapideELYWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=elnT9W+K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4F9606A32A
	for <linux-unionfs@vger.kernel.org>; Fri, 20 Nov 2026 12:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F4F9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=elnT9W+K
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b8b20b2538so988620a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Nov 2026 04:02:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795176131; cv=none;
        d=google.com; s=arc-20260327;
        b=GxPn01I7R9jUyZHgIKzfG2ntHNBpzrDoC5wCLzANEUbumtacp2i/1eIxXtAK7yq3uL
         xBbaKKurIdQ8teV/Hm89bx5e+MXTzMbDL6vNQJrq4ijjQ3rximPyM+EK8+JhOpkPk5dY
         0L9I8HMyzP8lrzvxnCjrbmO3y6LZ0gLSxuJmkdYaR2D8SM5FanMvIqZseBkgYteUyxDu
         oMf1hb+iFoAf7OeImOLES1E6RpoUW69SHxI0Vwi9XwANX148l99qeXPTbsMB90ScOcB+
         V8RV4eHiE/U4QUebMItqGdbX+O3NngMwD4+ENL9HhyScaBhUdVtFAY0+XlFKXAspTNNg
         uIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M0GVSOJEv4Fg5tAe9BmtD544Iu6fdkKfVtmzI5e60Pc=;
        fh=1vZnIHbVd8mFBzc4iOKdlFWf5DRFaRCYD8iaxrAMzsU=;
        b=HmF2nn5OKUIi/7341jhQJNFTzXsPldAGlrysGOdLWfB91H4vSmLgrYRslHQCtaj4RP
         RC9saubIoq0A+8nOzLJMfcmOZtXhA3UKHLbWi0MXylZ8EKpow/4rlxKynbqof1Z7xANF
         lv3c/bL2+ZjWvfKeIXzgde3a8/WYST58c1Ql6pkmOy60ucFGH/kmeMqcquIHk/dV2ky/
         Gef4L9epq3TZ4Knra/4xWEKf8zty9YQ1NdjZA/OXi7PbjEjngbSffJtC9axrdlNA4GC0
         8tNsteKsol6PeZJjT36N/PAPh28ZPkFkHDtPM15T1Ix23ngA1Z45vwJSQbOeedYPTWi7
         HIKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795176131; x=1795780931; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M0GVSOJEv4Fg5tAe9BmtD544Iu6fdkKfVtmzI5e60Pc=;
        b=elnT9W+K/n8i6yiUeG/vwm+AuWZDS7DoUKbFQYRBMAXKO57CxAdbGuvEp7yGT/ng4A
         xJpGl84wP3dz5FzRKXe1mxeZZWeFygWYXwT6EcOzt3WuouvhCpt8slCtE+Rm50c3bBbG
         jZD32of3vcH4juNQdSqKW5qUD7leYDJAhDOQxBXy6f4E1VVwgUGsrWFBgn5AWyIRQSc6
         JcQ6v7aum1SoOt22UQcGQfTxneDcBIs/uwdywGcQfTLz0l74MV/l6wVVpNUg2sG+iumT
         sirvXsRGU3I3K+iqC1yO/eBQ8zKNZV/FNXSNl9BBJxM7mKFqWRkVuWq/6Wfdj9Uc+XEP
         6KSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795176131; x=1795780931;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M0GVSOJEv4Fg5tAe9BmtD544Iu6fdkKfVtmzI5e60Pc=;
        b=pbaenth5QB6ZCjCGAfcAKzhfhirSTBINt4DvbC3ezzO9/xIqropKFWo93m3PEFlmzH
         zzh952zYe5jkBXjZ+VgmHYuv/YxmFzVaYvAnXLE+Uj3nkYG7Y8+VsAXvilyxIJHVOQKc
         9iQjH1tIUEIW+GjKC7mE4WLNaPwrusdbfhfLgceC8d0/quRwe8uaoSlcvTPGvWITUXlR
         MATYnbKsBo45lmgTlo6BONwt2MhQHd8zHPxNnmKm/KQffBnkh8zCmifK/ZxjlP/zPo7O
         w34Zevja0zMw8uF6ohEMlDuNRU9Txbq/C9pp5d1HNMGvz6rIzYJHXghZazsZLcarfljl
         sPlA==
X-Forwarded-Encrypted: i=1; AL+hErFR1ubx8L1OtkoJldM3SGYC0ySIE0YN8JH4UhrzCSgQiDMf8HVIXsUWnypqM1IWBZc/Ff4aQmrtYwn1CzzC@vger.kernel.org
X-Gm-Message-State: APuU4Z9Zt2lZelmoYkgkh9tRgOp5gDafqmd4m/ayEU7+RDt3PpPZjpzM
	3yQkc8Unvwfayf/sUxvpOHLnVPma0f52RY42aMgQazJFMW4tYkfTszAs1SQrvLZskOM0GClPsL9
	tI+js4wtXx9fCunxjwjSO2vze4gc0Pa0=
X-Gm-Gg: AZFdTZfvVgVhlEL12xjLsakNWXmAuAqybghUn9AV6+ME3uN7XgwKj3Kihoo4CLHTJOH
	V2MuAV3L20cWrWrSiWe73pE6T3YJGd4gNZhTigkCn8wqjHXCetJXYiqs58yi44vzGUrggLWGLiC
	Q+w5XrF3LLm2QgY32lARFvElDR+ezsNBApMYiaX8cNKZmrEIPH6sOospX/ezmSHFvmHoGUQ6T+8
	tdqsNJOCnU0a5VvVzaaEtv3u7PzwN+CU50P43Oi8XWcetDmfzxqYZ2p3jF8d1VtN/shxPEqdWYL
	BkDtZHZ771oR9K9bIp/E/TPRM4Nnjgv+zSrky+0D0KkrxkFGYYGLh6ZuJYOMUE3iTGeWY2wINCh
	T73h003YFKmPsUfJISVOyMzpJKCV+Cn0thUMqEFZSr4xeeLMN+RX+Y2QX1ch/iGLWjrTzug==
X-Received: by 2002:a05:6402:4048:20b0:6b6:e857:19d8 with SMTP id
 4fb4d7f45d1cf-6ba37e69801mr1554757a12.10.1795176130876; Fri, 20 Nov 2026
 04:02:10 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
 <CAOQ4uxhXTeTv_ydiQoq6-dvbw-ttFKkdNVUJanKmF6haSnbFWg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhXTeTv_ydiQoq6-dvbw-ttFKkdNVUJanKmF6haSnbFWg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 13:01:58 +0100
X-Gm-Features: Aa3M54rz6j7Tjpjymbfp8C8fSyvFWnIM9Qg1tGNKh3Bsrszg_pg9YMNZMouy94Y
Message-ID: <CAOQ4uxgMO7DQVFwOsK2NTad2bwyktYr4fyeCEFWWVZK5pmqdAA@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] ovl: only sync what was written through the overlay
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
	Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chengguang Xu <charliecgxu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 7:14=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Nov 18, 2026 at 6:03=E2=80=AFPM Josef Bacik <josef@toxicpanda.com=
> wrote:
> >
> > v1: https://lore.kernel.org/all/20261027-b4-ovl-containerized-sync-v1-0=
-802e512379a6@toxicpanda.com/
> > v2: https://lore.kernel.org/all/20261029-b4-ovl-containerized-sync-v2-0=
-4e9f08e4a052@toxicpanda.com/
> > v3: https://lore.kernel.org/all/20261104-b4-ovl-containerized-sync-v3-0=
-8daa20144f53@toxicpanda.com/
> > v4: https://lore.kernel.org/all/20261106-b4-ovl-containerized-sync-v4-0=
-6ddde0b7dd8a@toxicpanda.com/
> > v5: https://lore.kernel.org/all/20261107-b4-ovl-containerized-sync-v5-0=
-d34b4ae57fdf@toxicpanda.com/
> > v6: https://lore.kernel.org/all/20261110-b4-ovl-containerized-sync-v6-0=
-43d1be16a4d6@toxicpanda.com/
> >
> > I've completely redesigned this, because there were so many problems
> > that I kept tripping over trying to maintain state between the upper an=
d
> > the lower inode. I'm not in love with this design either, but it's the
> > simplest. I'm hoping somebody spots something obvious and we can do it =
a
> > different way.
>

I assume that you asked your alter ego Claude this question, because it gav=
e me
some tips of how to do it differently.

I guess it depends on how you ask...

I asked for less complexity, easier to review, and keep the requirements
that syncfs duration remains low in the worst case.

I also asked to look at Chengguang's v12 work from 2020 which
I remembered was simpler to review, but had some problems:

https://lore.kernel.org/r/20200506095307.23742-1-cgxu519@mykernel.net/

I got a few suggestions that I liked:

1. Serialize syncfs calls with ovl s_sync_lock and use dirty list as v12 di=
d

One list for the tracked/dirty
local spliced list for syncfs
Which workload would it hurt? anything important?
Certainly won't matter for the unmount case that triggered this patch set.
Holding upper s_umount shared during the walk will remove complexity
around freeze of upper and reduces the 3 states to just one dirty/tracked s=
tate.
Less logic to reason about.

2. Replace inode references and shrinker with reclaim list

Only an evicted tracked an linked ovl_inode needs to be added to the
reclaim list and ihold the upper inode
syncfs synced the tracked list (no extra upper ref) and the reclaim
list (with extra upper ref)
This should get rid of the shrinker hooks

This is not simple but maybe a lesser evil than the shrinkers?
Not sure.

3. Try to gate more ovl_track_inode() in existing helpers

Similar to ovl_copyattr()
Many metadata modification already have to be gated by ovl_drop_write()
or the higher level ovl_{rename,link}_end()
we can add both old new to the rename helper
even make them scoped

I will wait for your feedback before diving into review of v7.

Thanks,
Amir.
