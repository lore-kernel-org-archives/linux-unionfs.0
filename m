Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAE4313E17
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782220814; cv=pass; b=F1DxCuTglVFBG44UmV6iKp86/+lUOxYZAd2dkCryxuUgv1PT8UdUiS0P+zj9SZekR7ZFsHan4je0gCEk8rQBlfKuiBHTBr6R4pqZMoIvhCgbQ65xnmuJ0FuRZDSoeL3g6O3vFaZ5bMALK93ZOEzCN2U74MO1KvIgmCsNNyjuSng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782220814; c=relaxed/simple;
	bh=tvZvQkxCSCh3/4/RMMJj3R0A5q8F+4Nc9SfkK98lu+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JeDBSbRkSgCHAW84fY1OHKkmAaHdXOJbaP4WAw4bUVDtg4pg9E29KlF3T+Za8n8monTTYz9FLurk8XokGGDbwdJ5z5HTjGZ48mlzQAkVnto4LuBZh3vPRJoAfLge8KfgRqawVDYPhIwsd4sFMzG+HViA58Mc6a3pSakH+GJnUsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nux4biS3; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nux4biS3"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7fd6b4d5d49so9103337b3.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 06:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782220812; cv=none;
        d=google.com; s=arc-20260327;
        b=U9PZGP9PQEgboLmqyDc4BeuBOMdoZoc+840cr3Z223XXcYiB6Bj7GjgPhOWbWtOVDO
         BeAFaiiqlxXJWVlfxtWRT8uVILFr+IpM0zWMIc8HUH9sWnlasGw/jQHiHLXPbwZjsBp9
         x6npW8H4fpqvqU298NH5DGB4IZWbA2i0m3SPofe6bev/KslnX0asANRjYlLpKEYmNk2q
         J0r1ycwOEpZEDRn0jJsfjK29ozJ0Vlt80IubiDY5lUePanuZJfkuvMkNJLALT9OOuXIL
         MGpkjpRCOV4JQ6bgMy1eUBSeEIQE5dawBqtuksUEQmAYatLnZ6KUH2wr2WvWEuZxNBdx
         RM9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tvZvQkxCSCh3/4/RMMJj3R0A5q8F+4Nc9SfkK98lu+o=;
        fh=5mnb39+5VMT52D4D96E6w+zwnuPVxTxqW0T3JHCfVcs=;
        b=LoBKO0DtbGzU5qTeSYvovC9oLqpvViNMKB+opuOsRKnkYU7LpJkKf4kvekvMWU3Yxx
         luNppdSuIzeaPeyBSLKFapwNts7w4UV4W0TtZ5ldESM5sKRIvkz1EidlQSKENmz6XqO3
         ssErY4P3i86r/XLMiHZUCCzvYQdYmdy11QwV8LO3POnoM44mKz+JGwcVSM7R/u6SrVvh
         nFqcwXiCJwfY0F0R1x52UJnTXuup6XDQ1rLy2FjZ8GkVFJhE3k/jL1vqi2CIqpnEZQM+
         N5ro/Bpy63oxPqKcBSn07qIm3gyMGJOsZDOTWRuF98U27GSCE4qhAdJLDo6lpwq/Pyig
         M+Ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782220812; x=1782825612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvZvQkxCSCh3/4/RMMJj3R0A5q8F+4Nc9SfkK98lu+o=;
        b=Nux4biS3WR1mfHrE5AEpYr7nRtSGvtrFccoclB9/5S401HtXZjQmZsq5Vwy32QkU6F
         +wi4waZh9GF5J40rKjiYM/cwmWA1Iz9T5FFZCo5smtn7zjFOop+qa42xmXsmrHh2DQP3
         fBJmjg/ekkZSJlQvE1uoSuDlweHHZcdS5Rh7e0kYv7hlY0xvrWRnNS+X1ujSebXsmMsZ
         ZxxgQOc1JgO5WIZ1gzaX1O4RETztBPtU9Aia8waXdujJGPgNg8y5jx9EiiDT+Rhh+nrF
         QA93Kp1fgtEypSI9PyXOqeUfSJ/mTtc/MLZ1yUPK+/JId0/3NvB6bjwBFkioZALb2U0p
         qubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782220812; x=1782825612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tvZvQkxCSCh3/4/RMMJj3R0A5q8F+4Nc9SfkK98lu+o=;
        b=Y7EyHgeF9fH7XysCULnDRc4vWWIGPP3EvhDsK8fIA1/9/WqNN5ZwXOV+NdHAVEuBnn
         +97LptL53YL2ZI2SQ8GHJjulzH6yHYU9Q/v07gUCWXO7ua/7D4t+bCmKzCmNz//B/Kor
         h+JwjgQUMt74ZwcPLhP/jOOA8qO3Pu6gVTDMwNasSJTz/R81Ug/NzPG82Q2LM5slzUL9
         9dTsHcVseYfB0glNSysQbbEel645bmESXgXIgIIt0yzl+827n82j60iPI2kI4R+Zb8m/
         BHS/zEFbD/CN+EneElWzWvJ4fgZYMGQ8tEMu67bsAq+6K6yVAHfxqWUwAIdvWdgT/lXz
         /YDg==
X-Forwarded-Encrypted: i=1; AHgh+RpaMXpezGSLJJ8mWMHUz4JgefyharlBszcYDEUEne9MkSm3mTbpdzAIC0wcfQwIGVbPVuNykNyWAoFNT/LZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwvfI4s0K7CWCCCbqvRdt7AqaPKxoWL4WtkUtnezmF96+8oPTDt
	CRUVNuXFao0C3q91k9FOykddPy1MDQ6Gz3CmQFQeh8RXGigJKh+KZ/VjDbC0+c427mCPiMfWvpw
	PqivEcoX3bjd3zHOCqqouXNBTNLfnm6g=
X-Gm-Gg: AfdE7cmKu5vnjRTK4Hhjh1+UIMI6eJ3eISFQ/8btvroMj4/9TuWywR7PPpIyXD5f9gz
	ZLdQ5UUKhA6+RER7qZSfh9kbdyaoyHiv/YD0cIe2jxzDTqWeEASqeYeC7X2rWThrre8GMb+Eic6
	UQ1GHGooAI79mjGhbcAxlRzPQfjJArC1vp98WYNf3f63OEOmCTL7HHxV9QSgWvWf6I0n9pWj3aB
	TpEAvtruM6Qng+Qlnbq/FajS4GkcLBaeaeM+BdBHiK7K8ZBVG/P14KwULfnxhokbjSyLmalh1tm
	EAmYJ8NDsw29CqwtaP89uuFmtp5ryw==
X-Received: by 2002:a05:690c:e159:10b0:7fd:6024:e3cc with SMTP id
 00721157ae682-806745bca82mr29719907b3.31.1782220812363; Tue, 23 Jun 2026
 06:20:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623084337.54344-1-laoar.shao@gmail.com> <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com> <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com> <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com> <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com> <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
 <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com> <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com>
 <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com>
In-Reply-To: <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 21:19:36 +0800
X-Gm-Features: AVVi8CdDUPFZYCVzXKGZ3W0fULc5knnZG0NRJ77rbWbRjLW69vXvjSwMVoBwzkM
Message-ID: <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, 
	fuweid89@gmail.com, Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 9:11=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
> (+try to cc more FS people for visibility.)
>
> On 2026/6/23 20:47, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 7:59=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
> >>
> >>
> >> On 2026/6/23 19:38, Yafang Shao wrote:
> >>> On Tue, Jun 23, 2026 at 6:25=E2=80=AFPM Gao Xiang <hsiangkao@linux.al=
ibaba.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2026/6/23 18:18, Yafang Shao wrote:
> >>>>> On Tue, Jun 23, 2026 at 6:12=E2=80=AFPM Gao Xiang <hsiangkao@linux.=
alibaba.com> wrote:
> >>>>>>
> >>>>
> >>>> ...
> >>>>
> >>>>>>
> >>>>>> Again, I don't want such customized messy breaks userspace
> >>>>>> again; with that patch, container runtime needs to consider
> >>>>>> if `volatile` is the default which just breaks the existing
> >>>>>> containerd versions.
> >>>>>
> >>>>> I'll leave this debate to the overlayfs maintainers ;)
> >>>>
> >>>> On my own perspective and be responsible for common users
> >>>> (and as a containerd maintainer [1]),
> >>>
> >>> No wonder containerd is getting harder and harder to use ;)
> >>
> >> What do you mean, can you explain exactly?
> >>
> >> You're just adding a new way to break the existing
> >> applications, no? You just breaks previous shipped
> >> containerd.
> >
> > It's your responsibility to handle the cases where "strict" is
> > explicitly required. Please do your homework. It is not the kernel's
> > fault.
>
> How do you modify the existing applications and scripts
> to adapt your incompatible new Kconfig?

Why do you still insist it's "incompatible"? As far as I can see,
mounting on the same directory is a very rare case, especially in
production environments. If your use case relies on "strict", then
simply don't turn it on. Everything across our large fleet of servers
works perfectly well with it.

>
> >
> >>
> >> Add a way to change the default behavior is fine, but
> >> the new default behavior should be worked with the
> >> same functionality and compatible, but switching to
> >> `volatile` feature is non-compatible and what is why
> >> containerd dropped volatile.
> >
> > It only adds a dynamically changeable config. Why do you insist it
> > breaks everything? Users can always change it whenever they need.
>
> Can you find any Kconfig option that changes user-visible
> default functionality and causes almost any user
> application that relies on remounting to fail to mount
> again? If so, I think we should Cc Linus now.

I can't get you.

--=20
Regards
Yafang
