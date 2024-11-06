Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F17C142E86;
	Wed,  6 Nov 2024 11:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730890822; cv=none; b=BzLCG9dIR0uHZUBZsRfpyMNLQgLtK/p3WWZgz4QDMgXl8PUiUXzrHZ6d4iLXEhTSe2IVQgXDmoTZsLTm8mfSRbeAHJEIwZovjZKLx2zdYNZ8paeJx6v4zO1vLU9CSaqjIInRl2oY1HyooWHcN9icHYCvm1B0tj+2zBxlbRfBt5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730890822; c=relaxed/simple;
	bh=vuBjUAG4of3IMkztyA2vDfBAbLYce7Bwx42yfMGiEQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RLuZ4hOBjtvYV/goOBO/YXzlDxjS8NIBEfCaQQDoTbMTJHrlRJh3WO7zkKSSWHJ6di4hIJt3XoMbcCSzMg4v4qOhT15laEd1Vt2B45MLiEoD+BWqF7JW66mgZFHt9KrjXidilEa9bazpNq/doT5eB/imcwnwtRA+CzeqwqnUU+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T6JFf3Qy; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T6JFf3Qy"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7b14077ec5aso64981885a.1;
        Wed, 06 Nov 2024 03:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730890818; x=1731495618; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vuBjUAG4of3IMkztyA2vDfBAbLYce7Bwx42yfMGiEQQ=;
        b=T6JFf3Qyul05Ge72AZjl2KFP8h3KtyjIVdtJgOH0syT0xK5MW7CWKAjkrXEh8LcvF3
         k5KRiMGvzNqg6eyPFf2bfmixhiIUkO+9QaQIbgOsJAigw6d7v1PrRphO7MP5qGhY2aQL
         Vdi3qLrEsw73k1bd6mJa/Q3okdHr0lcGfoPwz/5+d/Xu3AnVa2g1e/hos7ypBxZSNAqj
         iMFFxxs5/CotgSkNqRnuR7bpPGVO/onMawW4fNPm//b1jmj+iXop89GekRMZeeClqwkD
         DEVlQvKRpUXi3C9Y+N023z7la606SZcrdybqg9D5a5jXH4ZFL6mivV4UznS3gQY73mW6
         vCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730890818; x=1731495618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuBjUAG4of3IMkztyA2vDfBAbLYce7Bwx42yfMGiEQQ=;
        b=BRC8133ph2sOfUUMYZA7XCi5Q4sAikxTZYYVfmLRAatQgG1ql2q3zqAOgld8dKYPa+
         bjXyWiuaPiTU8CLo9tBowDCPf3jysrTGjcWwkHCqmG7xsxBD2P23n2Oi/7xQ8+X6VVUc
         bg7r0UcovzGKaHGvcHDyiZ1BT3C11Ab2I9D6WD8M1+iFx8jmInnR8JBO5j8b6m7/sM/W
         OZzCKFNLuHX9kkarD5QRrJNzNd9lWm6fu0M8hgYZjOY8/2C+uvXUdxZGafbuVhFpzO1q
         5UWZ01Hby8x+KbRueWzYqGOzTkMGw9yzMpyzJigjck8CnXOjUG4glM61g0xA7n/oQaKE
         uy+g==
X-Forwarded-Encrypted: i=1; AJvYcCVSCEFcNJY91X8Q7HwzMNsTUef4mSlmTY8tWqcaKKJUxXjNl0SMVlwmuKR9Ov9WD/VoxuF4h+YcfhiA6aHE@vger.kernel.org, AJvYcCWiBthabtHdikiHGiYwVNMsyoOmU5wyXs9MwWBfKgYc8T3yJo2IOmJzZabsDSi+HKIK9ieutA4Low==@vger.kernel.org, AJvYcCXN8hy5ZuBQ/m/f4OSmXfHS5nP7N9krLZXxJguBDIKEFfy1DubfzCmDowamD1EBPEBh22r8N6450P77xPeOkA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbazq175N8COuEz+3nr+iz5aVHNu1LWpI0aYMItxQzZmuW7w8D
	soivZaE7ikkCWHf9pX87LTCrQLWgKem9FXh5aUcUVtNrfoP3klXR3YtxMuMYav5uXZ0XqpiELwT
	pL+DVJ1oSyG+5td55LAobgbMF1D8=
X-Google-Smtp-Source: AGHT+IGDQs3w2IhFZMBdFgltaWbiHO1oZQbH+OPxiNQfs+uts2rlZXy1unuWCu0Jv8a0wzA6Opjm+/x4F4o5IEVUdV0=
X-Received: by 2002:a05:6214:3b88:b0:6cb:c661:49ce with SMTP id
 6a1803df08f44-6d38b22de8bmr31721206d6.23.1730890817791; Wed, 06 Nov 2024
 03:00:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106-overlayfs-fsopen-log-v1-1-9d883be7e56e@cyphar.com> <20241106-mehrzahl-bezaubern-109237c971e3@brauner>
In-Reply-To: <20241106-mehrzahl-bezaubern-109237c971e3@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 6 Nov 2024 12:00:06 +0100
Message-ID: <CAOQ4uxirsNEK24=u3K-X5A-EX80ofEx5ycjoqU4gocBoPVxbYw@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: port all superblock creation logging to fsopen logs
To: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org, 
	linux-fs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 6, 2024 at 10:59=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Wed, Nov 06, 2024 at 02:09:58PM +1100, Aleksa Sarai wrote:
> > overlayfs helpfully provides a lot of of information when setting up a
> > mount, but unfortunately when using the fsopen(2) API, a lot of this
> > information is mixed in with the general kernel log.
> >
> > In addition, some of the logs can become a source of spam if programs
> > are creating many internal overlayfs mounts (in runc we use an internal
> > overlayfs mount to protect the runc binary against container breakout
> > attacks like CVE-2019-5736, and xino_auto=3Don caused a lot of spam in
> > dmesg because we didn't explicitly disable xino[1]).
> >
> > By logging to the fs_context, userspace can get more accurate
> > information when using fsopen(2) and there is less dmesg spam for
> > systems where a lot of programs are using fsopen("overlay"). Legacy
> > mount(2) users will still see the same errors in dmesg as they did
> > before (though the prefix of the log messages will now be "overlay"
> > rather than "overlayfs").

I am not sure about the level of risk in this format change.
Miklos, WDYT?

> >
> > [1]: https://bbs.archlinux.org/viewtopic.php?pid=3D2206551
> >
> > Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
> > ---
>
> To me this sounds inherently useful! So I'm all for it.
>

[CC: Karel]

I am quite concerned about this.
I have a memory that Christian suggested to make this change back in the
original conversion to new mount API, but back then mount tool
did not print out the errors to users properly and even if it does
print out errors,
some script could very well be ignoring them.

My strong feeling is that suppressing legacy errors to kmsg should be opt-i=
n
via the new mount API and that it should not be the default for libmount.
IMO, it is certainly NOT enough that new mount API is used by userspace
as an indication for the kernel to suppress errors to kmsg.
I have no problem with reporting errors to both userspace and kmsg
without opt-in from usersapce.

Furthermore, looking at the existing invalfc() calls in overlayfs, I see th=
at
a few legacy pr_err() were converted to invalfc() with this commit
(signed off by myself):
819829f0319a ovl: refactor layer parsing helpers

I am not really sure if the discussion about suppressing the kmsg errors wa=
s
resolved or dismissed or maybe it only happened in my head??

Thanks,
Amir.
