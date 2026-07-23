Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614A43DAAD5
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 09:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798377; cv=pass; b=ZRZuxl5uP+Xpoc/o0vPTrgqRkj9K2MuChFmUbNz8GNmM091hbGzf+Guo/qCgbihR92Hkjn60JxEbxLZ/zhq00LbgrLu3oTuAikzR9pFgB1w+OectfDY1NnPQKO0nK8oJsZdm755X58wSMXYxWTPOqlRBqgpAbURUv8T3fSFPQqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798377; c=relaxed/simple;
	bh=ptb5ZxUirqu3cGwvf8pr6jbj/gODGCQR5YHXZ8pfSO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MnZXOV45P04ep7YXpq2KIvllN7Hq0eZsjfHEMjvf60YkGtHBLvaWhZLryZn0rdXrZEH8G42LRTDbo4KEXQn3iJwRgF1WapqgCh5qpfmITVqcFC1cHteAgi9wuQzjhLOK3WZorlQaj4krbEmRyLY2aXIZDcrMRpZUhL9bGAfd8E4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=keOlB1AH; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="keOlB1AH"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c5382806fso4056191cf.2
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 02:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784798368; cv=none;
        d=google.com; s=arc-20260327;
        b=dU206wXfdkEJe/lR85OIaN0GkSJ97tF1JCiXcXinQUHG6mjQBa+B1j4R3nSQJQXtq0
         ta2T5Dmxa5/HvExvCz+DQkHNE9/Qmp/iTC7eSO3qJqyspcV2xlQahkLOXL5kNRgdlcQj
         bAeTxQttVONjiJ8ncwlc+h2d1kAEXKUA4CkhpXlvCka1jmFJVkB9ZhMtqZVHp1dwAmw9
         zCk+mlk3XBt/AnMsPkuxcorEW+4CE0y5RwBAefRj9yWiB9DY09FetHWCysrArwNYRZzS
         k/YlhRJm9RyMe8WMmS98YlkqtpO+aDimgZA7HbdcQkHxQ6UPofZ6q/sl4PuT9886H9pm
         J2vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        fh=JGeHQZXo1Fp8iMeMbwKxYdhg9AbO2n5oHN/QSBQfHTs=;
        b=N8Pri/xK4+4f/X6q9ovzBbDfNd3kXmWcC9SPhriCbsWuOc4I32Ap9ata54tT4NyVcG
         QRRkaU0q95WLRLUlgHLRp0nUdX30+sy6UWfJpafGrjD1U3CwpwFPizP02ZhHLvK04GBk
         is62U26MX0AZxQC3Sa63Ae2hVKYjYlfT1czeiAN5A0CrtWvg4zzM2a8qRoO2pkf+U5cZ
         liFKMkTLx0TxLjxXlBvv6/hHuANKuZUu3L2gKirlgZJ9VL3IaNDTw35fRr/T1svhgxeV
         +wLD1emU2Is7FnS62oo89pSvX9ONzCMFKDi71l3OLrGNcJK1UB3PxoFbctaRtBkyKTsm
         lU3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784798368; x=1785403168; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        b=keOlB1AHBBO6T/T1hkgCA6EQ0WgybPZ/+m0GoxIu0MtX5Jhz5FRd9RjOkni5HCsGVD
         1io27rV8ikCj2LQfGSvlA7ZcSH8v21LLVgVLTS7dAOFbdz2lZsR+AIFiYb7IJZefSKvo
         w9ODy+WQ2kChww/7p+4YeozuzCm5dAQI+GEfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798368; x=1785403168;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kfYZU6mmSr/3MS4E2nALRlpwiopOrciEufMpSapbBDU=;
        b=Ff4v+GU0BsF7mIfkZdq11yErOlrGGCKXena4LBENgLhYRNQ0oPXHkI/3M2qdL8fwuO
         hkq6l1/WfwsAEEQJM/lZUVuZWRPF9EPq7jl6YCfCw2jA4C7//lNIUnb4pyhaaEpOG6La
         IADLmZd0aTGE77xcQysvRqxIyFuuNoH+bXYf8qi8nkDMRE3PCB4y6adwkdSd5O1pcIas
         ObGLucXTs9cenQp4RdfI1KGjjmji1lvpzJ3l8Q640OrSw3nrPf8hvDsKypFfi3j9TQAH
         DtJvYhmFzhuIh58xIhGmtM/dnK3cSceExrg85ojH6kxHmFgvc0MjyjOfv2QzCPzR1Iti
         5uCA==
X-Forwarded-Encrypted: i=1; AHgh+RpVdasJbq4qmxHh86+ChOzLzqxhg0gsLzD+CY/tnCHetYOUbi7yH8JBUr2Yf2d5ZIxuAynNbHMt24hxkQx9@vger.kernel.org
X-Gm-Message-State: AOJu0Yws3MqdHYAx0kkY47Q/jqFM+trqYr18ie/iwntGwZ0Y+z+Ys2mX
	WN8diWCu+CxZNt+86X18OXkb5l7r+ShZ7SQPXN0DvauR+PSpURIMYpzik0/g1y6p1bR+jJlh4gL
	4ZyN7Oi9p12tVhEummcwwOXfLR0ypqu8/00g37ca1Fw==
X-Gm-Gg: AR+sD1221fZ6JHdNlC2uSdunpYZghlpHoQq7uO0bBJ3/OhQMrhZPc2aHoBoj1UbHg6X
	tOTQeID6eCR2N2e0kQOCTw/Z46rlVQtEYoEoZN1zTODjW+6/ZIfh6cnS+Fu5TG49mmFiTuWYqde
	dCjg9lll4dJh+On8ZIdW6KID0i6Mzdbu1jAzYRMFeq9RLVpvuGQTeGJqwIv/NRUSlEkj7AorVBj
	JhV4Q0FmKt3ZxvbqqCX6EmD5niaQWjKq5h3NyZ1d7DWJnxEnPLwXbWozmQIc0QGPGhyECiAgQ+q
	YH1wKsI7mIE+ro/fnyaABTFlfqHG
X-Received: by 2002:a05:622a:1829:b0:51c:8439:14d1 with SMTP id
 d75a77b69052e-5283dfcded8mr20528451cf.63.1784798368136; Thu, 23 Jul 2026
 02:19:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJfpegupwNTaVNZtdQTmvtz9x=ehH59hzsRT7D0=VbhOZvaqrQ@mail.gmail.com>
 <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
In-Reply-To: <6C96C8A7-345E-4388-8EDC-D94E9463D214@amacapital.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 11:19:16 +0200
X-Gm-Features: AUfX_mwYbGEjI6yeBtsXmiyva2-bOQkj3_zJ1N3_FyC9B2rBmuR5k88F1rTJxak
Message-ID: <CAJfpegteZbnPkiTSAPWXDqZbf5eALK0E_npBLtLTmJyZaHXdyg@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Xiang Gao <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2026 at 11:01, Andy Lutomirski <luto@amacapital.net> wrote:

> - O_XYZ flags to open() are all kinds of awful, for historical reasons th=
at are not fundamental to the concept.

I'm fine with limiting this to openat2().

> - symlinks. If we have a new API where opening /proc/something/magic/blah=
 can access something that ought to be inaccessible when accessed intention=
ally and with privilege, a symlink pointing at /proc/something/=E2=80=A6 ca=
n cause the API to be used inadvertently.  Admittedly we have this problem =
with basically all symlinks, so this isn=E2=80=99t exactly unique.
>
> - our nasty fs permission model. We gave a sort of gnarly mix of a bit of=
 fd-based permission and mostly mode/ACL-based permissions for path travers=
al and opening, and mapping this nicely only new APIs (as opposed to actual=
 files and directories) can have unpleasant results.

Pseudo filesystems don't usually do mode/acl based permission checks.
 I don't see any issue with that.

> Of course, I=E2=80=99m busy arguing (slowly and without a concrete propos=
al) that we should have proper capability-like fds, and maybe that=E2=80=99=
s kind of an answer to this:
>
> What if we had an API to get an fd to the =E2=80=9Ccontrol filesystem=E2=
=80=9D for a superblock, like your O_ALT but as a real syscall or maybe onl=
y accessible via one of the newer and less janky open variants?  And what i=
f the resulting fd and the filesystem tree it represented had a few propert=
ies that made it very different from normal directory fds:
>
> - You cannot mount anything on it or its subdirectories, nor can you open=
_tree or otherwise mount it anywhere.  But you can open_tree the very speci=
fic things in it that point outside of the special API (e.g. the overlayfs =
layers).

This patch provides exeactly those properties.

> - Privilege is fully captured by the original call that gets you the fd. =
 current->cred is not checked when *using* it except to the extent that you=
 might need privileges over your own namespaces to do operations that might=
 affect them.

This is trivial to add to metafs: just store a ref to current->cred
besides the path.

Not sure how this security model would work, though.

>
> - You can=E2=80=99t fchdir or (hypothetically) fchroot into it.  (Not sur=
e how important this is.)

Not sure if there are internal mounts that have directories?  If not,
we can just add a check to fchdir/chroot against mnt_ns being NULL.

> - Maybe you can=E2=80=99t follow /proc/pid/fd/N links into it either?  Or=
 maybe that would break CRIU too badly.
>
> The basic idea here is to try to treat it like an API that happens to use=
 the open machinery but not as part of the filesystem hierarchy.

I'm not opposed to limiting this in various ways, though I don't
really see the advantage.

One thing I hate vehemently is directory lseek to a non-zero offset.
I'd happily error out on that one.

Thanks,
Miklos
