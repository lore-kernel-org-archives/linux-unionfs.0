Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1837F31D387
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Sep 2025 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297086; cv=none; b=jZnyJuusXKKx+aiFVEbHKOg65vk7nJyHeZmcig9K/SIXYYVve233qlWxDLxj68xEcTM8Ulce5SqJ7tsktQ77jnirjn711TXbi0zgkx6f4qS/NwtzD6CjbJsfPmTVrA/M0vP2irglcytbq4NQJlf01WzyIJYB2ljeKmZG3ZMw7rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297086; c=relaxed/simple;
	bh=dQyUfF40H1BfACBXs1bM9Z16j+bX3eztAVI7x8T9QyY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pmQH4V2zdrBJdJhZp/h9Nkk9VPAth+kpORUdtUbAou7BS63NN+VdwzgqWwxa4Jvf4igCKu1dnr5vRvTeF3mzsEqfKj25HviqjINtqBPt8pBHv5pGF7+pwq1DgoAC1zW9CmZkXHnbXSvFPRfGGgTWIERTBmm4v/83UcE/1a4WRkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XG5szcBt; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XG5szcBt"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61a8c134533so3882778a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Sep 2025 08:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758297082; x=1758901882; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQyUfF40H1BfACBXs1bM9Z16j+bX3eztAVI7x8T9QyY=;
        b=XG5szcBtt+khLIa3V1bFWe61mXJw5dIg25jiE4Iwhf6Y7wtmS6AmIdmjNoXeRyb+Q5
         M/eCPNolH2Wvc3NcIenqEV76FPG9a2gFnXRnNxuc+YL/gbyTbKvZRYgGAATGsnA7Loti
         EX7x3Z+eQz7n+01+WFIwGV+MWNErlDx75CE1aBLvIqCCfEA+U0D7VCCwiHBgRbeja21p
         sP4G12o9q4iWEeZC+NOHSfdoMUvIqk41mH54qenYqMg7ob6XPFF3wWtN2sApvl0MMigD
         A0GToNs8n4uJmwp/TEyEVPQEeDhNPvr05xCj5ezgtxuNGckWqmGbc9E04F2WIzuvTAEV
         GySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758297082; x=1758901882;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQyUfF40H1BfACBXs1bM9Z16j+bX3eztAVI7x8T9QyY=;
        b=B4RBwGnHuI2Fn/rQJ16B5lns2yuVg0q1OGhLjbxh0JPXtrP2x0VQc9umwxC/4AW/uL
         nZvEKMrxb5IjvSMayWucG6bKGvFKoz3/zfM97YXQrqWhxLKWqpy9fLDrsHqjt09bsQVD
         FNdCDiRwkLB7+Mw7mpGK73HppHVOn4Od9O5aNuy8g8gVKvQyLliQfRi/1dwqvzhysB3k
         +nRMwFSmP4h0zcSqUnmCwuyINnRBnmNsw5ySiohc4v5nGy7/ESkk7iDjemyn84sxAyVB
         SQrtMlXgn7Jl/S8Jrg4DNctl54j/0pDoC51h3T9evouisYFfyoVKPIkowCErjD5do+/b
         XJJQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+lE9AQVMiKyY1Pidl3Z+LBUnvbUTFHp+JRCbdQdm756adFzky46A7gW5JTMkP1mlJFpZtA/Cl3LW23cVk@vger.kernel.org
X-Gm-Message-State: AOJu0YxxasTVrxvwSoOLB24MI+jipRU5K7i1Un12u9Bi5+/D4o5Eef/O
	GmSB+Q/XNQuiJ8VofmVaopC8g7bEv0SIYb1kVCeV+Hq4dGtllKyWRu4Df4PkrlPl8h4ALlHraIS
	cOt5wStHyzVSfjzmWt03+eYdE9Z1r2nU=
X-Gm-Gg: ASbGncvTdg3WjXSY+ky0JV1kWQ87JKcsPHf6YkSnO8QKyFObNAITexnSGYAnlQI8RHl
	lIfKh/3ENA/0xo0y89/TcRfSQWqwa+J5bNkf4prxoas3X6fab13oAuLzF3ep6jOPAZvET5LOvvM
	OzxuoR3hVTTG2X1zckjfhbkGdq6/S07mYszKusDKMTVWDTstg8YqgFlehg7w+HQbclAox7yB8lq
	SkAimuwb3rwiHB7gg9Mptv7bBrxDJS9BNX6Ahy+trGyaEAjrg==
X-Google-Smtp-Source: AGHT+IHMYIIjAX6ewyUslo99+c+F/Z/A6Ra3Vsq5RSMEC2P2mKWDv4Y0XysebCInkszOpKuAszEHVouh8UZ0MItB4g0=
X-Received: by 2002:a05:6402:4396:b0:62f:4610:ddf9 with SMTP id
 4fb4d7f45d1cf-62fc092b59dmr2993257a12.13.1758297082332; Fri, 19 Sep 2025
 08:51:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250916135900.2170346-1-mjguzik@gmail.com> <20250919-unmotiviert-dankt-40775a34d7a7@brauner>
 <CAGudoHFgf3pCAOfp7cXc4Y6pmrVRjG9R79Ak16kcMUq+uQyUfw@mail.gmail.com> <CAGudoHFViBUZ4TPNuLWC7qyK0v8LRwxbpZd9Mx3rHdh5GW9CrQ@mail.gmail.com>
In-Reply-To: <CAGudoHFViBUZ4TPNuLWC7qyK0v8LRwxbpZd9Mx3rHdh5GW9CrQ@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 19 Sep 2025 17:51:09 +0200
X-Gm-Features: AS18NWD5sjprDZ05x1PqO_AbsDi_64hioVxDvXeUQi-rv99l5X0YtG4bwFwHNwA
Message-ID: <CAGudoHH+=m8frJ3vLY=UoDt5aSSyF0XsmKBFKCK7nDfRxTC1VQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/12] hide ->i_state behind accessors
To: Christian Brauner <brauner@kernel.org>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, josef@toxicpanda.com, kernel-team@fb.com, 
	amir73il@gmail.com, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025 at 3:39=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> On Fri, Sep 19, 2025 at 3:09=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com>=
 wrote:
> >
> > On Fri, Sep 19, 2025 at 2:19=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > On Tue, Sep 16, 2025 at 03:58:48PM +0200, Mateusz Guzik wrote:
> > > > This is generated against:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/=
?h=3Dvfs-6.18.inode.refcount.preliminaries
> > >
> > > Given how late in the cycle it is I'm going to push this into the v6.=
19
> > > merge window. You don't need to resend. We might get by with applying
> > > and rebasing given that it's fairly mechanincal overall. Objections
> > > Mateusz?
> >
> > First a nit: if the prelim branch is going in, you may want to adjust
> > the dump_inode commit to use icount_read instead of
> > atomic_read(&inode->i_count));
> >
> > Getting this in *now* is indeed not worth it, so I support the idea.
>
> Now that I wrote this I gave it a little bit of thought.
>
> Note almost all of the churn was generated by coccinelle. Few spots
> got adjusted by hand.
>
> Regressions are possible in 3 ways:
> - wrong routine usage (_raw/_once vs plain) leading to lockdep splats
> - incorrect manual adjustment between _raw/_once and plain variants,
> again leading to lockdep splats
> - incorrect manually added usage (e.g., some of the _set stuff and the
> xfs changes were done that way)
>
> The first two become instant non-problems if lockdep gets elided for
> the merge right now.
>
> The last one may be a real concern, to which I have a
> counter-proposal: extended coccinelle to also cover that, leading to
> *no* manual intervention.
>
> Something like that should be perfectly safe to merge, hopefully
> avoiding some churn headache in the next cycle. Worst case the
> _raw/_once usage would be "wrong" and only come out after lockdep is
> restored.
>
> Another option is to make the patchset into a nop by only providing
> the helpers without _raw/_once variants, again fully generated with
> coccinelle. Again should make it easier to shuffle changes in the next
> cycle.
>
> I can prep this today if it sounds like a plan, but I'm not going to
> strongly argue one way or the other.

So I posted v5 with the no _raw/_once variants approach.

It is more manual conversion than I thought, but it is all pretty
straightforward and contained to a dedicated diff.

If you still want to postpone this work that's fine with me.
