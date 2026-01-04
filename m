Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A96322E3E9
	for <linux-unionfs@vger.kernel.org>; Sun,  4 Jan 2026 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767520884; cv=none; b=p0ZmNv10Ua9eH3Sq5WzqjZiKBK5hybHvaKTYB0LKO5piBkMir7K1U8ylhWr3o3GAyhXs4YB8m9/86JjqpNCGYOVvt1k+cNQlsqvXkT1X3X+R7LQXw49V02kc6rifMrxbS8353mXGT5+LMwAEC/reIxHpYBB3Rui96ZbsvDm0oao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767520884; c=relaxed/simple;
	bh=srPYygv6pShd1PwqaIDI5OBvLMzsuc08eRCmSxh/tyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pk8zxybdpfu/ZXxmHt+8058QPb/8X4ugmuh6z96nRD7E/N1TxFukUTeAaaPy34yZWt5+m8S8jjA3ZbltaNsKscBCo4tHy8dw4jWToexpCGTIue4+ooCwXpT594r+cBFuFKmQOo4U2iWv/9H+OfSOikDyILf6fpt3hA5rPFeBHJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LH7HadnX; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LH7HadnX"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b61f82b5fso17861350a12.0
        for <linux-unionfs@vger.kernel.org>; Sun, 04 Jan 2026 02:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767520881; x=1768125681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOvoKfWmBFL59R8CXOTlXu+UFWImyFk8EogIGG4S0X4=;
        b=LH7HadnXZfZMq2Jc19FsQ1MPOtcvFEQmJn1Lo6W0Xn/LSBrUsdKLIsgJ/Fae8wzABe
         TZlixyuRNMAmV/6gZ4drwxOWWT2ZOF+biLQ3Z6vwBxfJCXedVDSm09W3FDAlezxhaAoP
         CKx9pBHSq3Pkllf1ZqRuz+DHNoYfIWJFOVmfSeFkVcQw8Lf5mDkpdsSFdUuZkru7KcFk
         GmtHYWfcRl1DBYifj5/j9NtDdeLQr62Rt1ExVjGM1kjsgiRGjJScFRPgzRSYZys25jz1
         2anjMSjE7gK/0izspwXTIhO4uSLGP40SHNx7HA/5Gdh0RYVuKUPyT5d83mAyCkQEzwXv
         wLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767520881; x=1768125681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KOvoKfWmBFL59R8CXOTlXu+UFWImyFk8EogIGG4S0X4=;
        b=HhdymlbFliTBN0wSMgosLxbZT3Z1RJ4i9+ajMQ6ePphexX100759vhLLsO45FX/+Sl
         0qhbuJhve1J0waGY+yJnSlO9gvrBKNe/fKPnLQUnT8iviV3Z3Tq+gNude7CtDqEhf0UU
         JIwT5G1AHfycUs09Y9ht3pgJrcBLPnMWWHGZFS8z1hgATeUQSSs8opYBxXzXbObFNJhp
         2snGirl2R/8G1OCBLQcaSKq7gAyzuXDay4PEneSuTfkPVH2/gyinm0Bbg3U89eriAFoj
         L6OYey0qcTx6CwYqkZPiYUgTAO3voeVn+X8O6wU83pX78Kbt5KvnF+Ek9kXQ8QrleD4C
         HykA==
X-Forwarded-Encrypted: i=1; AJvYcCVXGO4XrljoziK/0fOs35N1Fb9CyJ7W3oylVnHHu4v7cGPuQpY76CNli+UuphLTXqmu1DRMvZZO418AJPRc@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlr0XGSMbu46ffMH/NB0h/GG6u4Ed6Lci17/QNVnpyCjrtwuY4
	t7dX4tb6ZwwGwY13mqFcFUJgigjZ6LgfxggJo/rY+pShR/xW7XYpAYnP8CrxELuBpKMSJe9IhcC
	h4QrnU73KjBKaTh4raH9th5oTiikJn4k=
X-Gm-Gg: AY/fxX5Rv/NuNWkV3oMIB4qBwLeYP+y7ag/61siVPX6L1/M1mV89ZuvhrnT1Bv8R1n3
	QqFzXZnldW5R1VPpjy5vvhsV41EMR040zoNCIayx4JlcLe3v6GVJk162aCf18O19B3BYuOtOaSW
	qBTG/AC5vNSPb4bKmMI9RTmWD6RoEDjOympcDfQOMkRsJObqqTerY+PtZtg6P60tjX8AkKIEuLU
	wc7kOKbXQriyjGVxEP6Uj92621WWVuaG7b9kajxaaL3eDvDFhrSXd/9MtmbfgcWP9HJNL1QbKqQ
	q3R5tQEZk2Th3tA07ZRisylDAFHpgw==
X-Google-Smtp-Source: AGHT+IFgzXIgEP98g9kvRhY6kXLma4/bUa9Q+r4FG55GLzemFHDS/EdI/AClCQ33focw/wX7ISuTbQaMbEjGAaPrPoA=
X-Received: by 2002:a05:6402:34cf:b0:64b:5562:c8f7 with SMTP id
 4fb4d7f45d1cf-64b8e944d82mr44615592a12.5.1767520881147; Sun, 04 Jan 2026
 02:01:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231204225.2752893-1-hsiangkao@linux.alibaba.com>
 <CAOQ4uxjjxUHr3Tkxo9PkrBUPcYG1C309cYA9EEvk1-oVGcV_Og@mail.gmail.com> <18246672-2c4f-415e-8667-2f826eb4fe19@linux.alibaba.com>
In-Reply-To: <18246672-2c4f-415e-8667-2f826eb4fe19@linux.alibaba.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 4 Jan 2026 12:01:10 +0200
X-Gm-Features: AQt7F2r5xH2GYoQ31_IAWJObXo5CyrRbewfZMWvlJuqUu_D8Hz8DAyXP-xiO8pI
Message-ID: <CAOQ4uxgWc7sVwikg3uV0Ey0rrGG+X_a5JLkK-bBFpQSAEeTSVw@mail.gmail.com>
Subject: Re: [PATCH] erofs: don't bother with s_stack_depth increasing for now
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-erofs@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>, 
	Alexander Larsson <alexl@redhat.com>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[+fsdevel][+overlayfs]

On Sun, Jan 4, 2026 at 4:56=E2=80=AFAM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
> Hi Amir,
>
> On 2026/1/1 23:52, Amir Goldstein wrote:
> > On Wed, Dec 31, 2025 at 9:42=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
> >> Previously, commit d53cd891f0e4 ("erofs: limit the level of fs stackin=
g
> >> for file-backed mounts") bumped `s_stack_depth` by one to avoid kernel
> >> stack overflow, but it breaks composefs mounts, which need erofs+ovl^2
> >> sometimes (and such setups are already used in production for quite lo=
ng
> >> time) since `s_stack_depth` can be 3 (i.e., FILESYSTEM_MAX_STACK_DEPTH
> >> needs to change from 2 to 3).
> >>
> >> After a long discussion on GitHub issues [1] about possible solutions,
> >> it seems there is no need to support nesting file-backed mounts as one
> >> conclusion (especially when increasing FILESYSTEM_MAX_STACK_DEPTH to 3=
).
> >> So let's disallow this right now, since there is always a way to use
> >> loopback devices as a fallback.
> >>
> >> Then, I started to wonder about an alternative EROFS quick fix to
> >> address the composefs mounts directly for this cycle: since EROFS is t=
he
> >> only fs to support file-backed mounts and other stacked fses will just
> >> bump up `FILESYSTEM_MAX_STACK_DEPTH`, just check that `s_stack_depth`
> >> !=3D 0 and the backing inode is not from EROFS instead.
> >>
> >> At least it works for all known file-backed mount use cases (composefs=
,
> >> containerd, and Android APEX for some Android vendors), and the fix is
> >> self-contained.
> >>
> >> Let's defer increasing FILESYSTEM_MAX_STACK_DEPTH for now.
> >>
> >> Fixes: d53cd891f0e4 ("erofs: limit the level of fs stacking for file-b=
acked mounts")
> >> Closes: https://github.com/coreos/fedora-coreos-tracker/issues/2087 [1=
]
> >> Closes: https://lore.kernel.org/r/CAFHtUiYv4+=3D+JP_-JjARWjo6OwcvBj1wt=
YN=3Dz0QXwCpec9sXtg@mail.gmail.com
> >> Cc: Amir Goldstein <amir73il@gmail.com>
> >> Cc: Alexander Larsson <alexl@redhat.com>
> >> Cc: Christian Brauner <brauner@kernel.org>
> >> Cc: Miklos Szeredi <mszeredi@redhat.com>
> >> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> >> ---
> >
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
> >
> > But you forgot to include details of the stack usage analysis you ran
> > with erofs+ovl^2 setup.
> >
> > I am guessing people will want to see this information before relaxing
> > s_stack_depth in this case.
>
> Sorry I didn't check emails these days, I'm not sure if posting
> detailed stack traces are useful, how about adding the following
> words:

Didn't mean detailed stack traces, but you did some tests with the
new possible setup and you reached stack usage < 8K so  I think this is
something worth mentioning.

>
> Note: There are some observations while evaluating the erofs + ovl^2
> setup with an XFS backing fs:
>
>   - Regular RW workloads traverse only one overlayfs layer regardless of
>     the value of FILESYSTEM_MAX_STACK_DEPTH, because `upperdir=3D` cannot
>     point to another overlayfs.  Therefore, for pure RW workloads, the
>     typical stack is always just:
>       overlayfs + upper fs + underlay storage
>
>   - For read-only workloads and the copy-up read part (ovl_splice_read),
>     the difference can lie in how many overlays are nested.
>     The stack just looks like either:
>       ovl + ovl [+ erofs] + backing fs + underlay storage
>     or
>       ovl [+ erofs] + ext4/xfs + underlay storage
>
>   - The fs reclaim path should be entered only once, so the writeback
>     path will not re-enter.
>
> Sorry about my English, and I'm not sure if it's enough (e.g. FUSE
> passthrough part).  I will look for your further inputs (and other
> acks) before sending this patch upstream.
>

I think that most people will have problems understanding this
rationale not because of the English, but because of the tech ;)
this is a bit too hand wavy IMO.

> (Also btw, i'm not sure if it's possible to optimize read_iter and
>   splice_read stack usage even further in overlayfs, e.g. just
>   recursive handling real file/path directly in the top overlayfs
>   since the permission check is already done when opening the file.)

Maybe so, but LSM permission to open hook is not the same hook
as permission to read/write.

Thanks,
Amir.
