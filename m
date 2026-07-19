Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB483AB496
	for <linux-unionfs@vger.kernel.org>; Sun, 19 Jul 2026 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784486584; cv=pass; b=fD7xrziWqOuTfAq3iK4+7Tfykrn750QeKD1ehpoBAXaVUnn4QpJkYOgw9i/TJtPk7reU9E8ZcFI8yDWtgiVyHWwVmdpKMFMMkk2N0ukrZP64Bc7v6H7ugLqOi1Jo/2HYXN5G8ma3u2b80TfhNhiC8HCr1Xo6oxOVkNUiTIZUqDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784486584; c=relaxed/simple;
	bh=mFFppR+tgzYK6/5HpSQcE1hem+w1X/QeYlu4aLPPxXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FRuoyCDO3iUalKwXEDD8My8Wbs2Qi72iVU6B+oPZOXYacAMZB84OOxLbRXdw/R5u2AWe1uHo7RMOWKGxfKVvf8kXDNDnn7mvioG9pPkZtc7yMW3A9h26/cMM0I5Of8Gl6OqO174X59vcBwLe+RPRkCaLtcYg0C+g1sIxZc8izY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=LLMEnHWd; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LLMEnHWd"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c0cea8883so38007261cf.1
        for <linux-unionfs@vger.kernel.org>; Sun, 19 Jul 2026 11:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784486581; cv=none;
        d=google.com; s=arc-20260327;
        b=LQh5/SWbhNzAijROv8ALMKVGx4mBUlas6m1RtwX6XrStnDnxXht+U2+6FdHtwKmO22
         sxSYxtP+r5fZWqA9fdzeA5KfQiAm01FOyVu9g8qI8gELyyT/ELtkUDkAnc3lI3Y2W61n
         U+XV/1hxqEDBkj+0WKIMX/udbLN9aS5bLgeeCL8bZCcYInBBzik6OCRc0+6ZHeyNmF3o
         elr5ncJ4m7fRiZ2ayQ0zuOYcg6lOH5ltVp6C62ne2kISYMOLUaZ9+uODM5uDgwv/ABvc
         uD34qe1b7S7ajTGvFtXjqHCS2cQd+rMSKjNBjxkhplM5vTrkqJO/KDEOkRL0oxPoThfg
         owyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        fh=ChVGraHwEcU9e69gU7e+wn4KitRiWA4dQ3olNDnmFqk=;
        b=jHePvRaBWR+eBtYU/t4Dm0Nwo6DgkRq3Ki8Har4kGsq6emkFsGktoXL7+2L/XwYElB
         OC4ER24EU/38v0KTeh1d/2gCL0N2FwSukwQ5IgK0UnVXhKX3pINAh98Ei8dskQAcFKlW
         Fmj75lHVLJsiFmBLUEhiwwJQTOaoeosUFjXu9wePvM8BOK4f3ryXvIEuzzs2VY6ooQp7
         xNXB1Wn2h16oaojPYDKxXE5hQLjEc5cuShgHjFinanlbSBHsYz9aEZF7fo7qVoXF+r/O
         P8iTuuu2RjqSMzGcOhQyMLQ3Px8qLarYAvkZc3aWX5uS1OIkyVQk5vN19o2UJ9eFB6iX
         WuhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784486581; x=1785091381; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        b=LLMEnHWd0Fxl7f2PLtvb9/12JUtvOORfOPtaRf4g8nmg3HU91XEiQcSqS4b/qj1hus
         hzqXl1M50X1ZH1s3V0S/v1waL37a/zxRsdJsGbb9yoO+aT3WorFerOjvp9C2QgkXS82x
         jdyc2Areri+08q2M00uVesZs3htcPey6XALT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784486581; x=1785091381;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QIWNHNNm4n4NbEoASWprWeRfxUra6wPCmbbue/4Snck=;
        b=fZTHoa5eqHgBXVoLYeb4Lgxk4Y9RBANbJfBS9LMMyR5+B7O50VIsjqv0IJbBYfwDO9
         sVMF8DfwhVNWNKokF226Xa79cHTYrEwOEsQrzXgCadQ1dGrbMi+GcIQN9wb4pKAEUYcQ
         iKvty6IXhbJZL3E90LtAtkaHa4nScNFLMsH8WLpqh1xroKOeaoGfCP2tCKGCZZGKJQ8j
         ReiZB4O7KTw9ZRPpwUjXTb2fiv8AAl3jGTRcgsZY2uNGFEOFZ//lK4be36fbUiZb7NDS
         UlAk1HvkmHdaiU5oQ3Cn1RROzdrZsy0ukjzW9i+sQTXoFlkAlx1BOEFn3OAICjs9c/aD
         HRKg==
X-Forwarded-Encrypted: i=1; AHgh+Rpw+o0ZSMo7s26cisyfYGHcHVdn+cvpsLrjwVc3QS+Xy25ZyJihSqAD8CSvmAdgEHdVQxXkUMUhDHEiW4HX@vger.kernel.org
X-Gm-Message-State: AOJu0YzQflJovchJtGd0XdTwuqzgdnXF5cZFmW6Q8vWXeNFdNuXRWjy0
	D2FWHyMD60ZysMelqnVEzDi6aYwm1s7/XIazkfSr2IRifxe0hVWy/bmg4O8io2Ml7NuXLbqh7hY
	q3ZNzo+y3al6/2oTKCFbhu4nZsAKS3YUXMUYbj8mc8w==
X-Gm-Gg: AfdE7cmPgNxIYjAyXHYbF2+VGt2HSsYUd26R8lGHApsOSjUwL9odLRQnt10SLTlX7E3
	KN/OToc9dUQnJAwBx9xQ4G1VFYh0sl122jk53QWcXK6AT1Zl+kxhLvyUxh8DzdSvz4qmFlwWOKX
	8G61Tat9V44+3Hvs6Z343xn3agEzP/zSBJ1y0z1AJql7hy15qpOCjy1D7JDmIKbUPqJw8cYh1Cv
	t7g7n+HQUKcHjwJ5A/edqfuon220Xe1oCaOQZlR4NZb1fGwnKyS+ATnQwp9VKBSrJuGHQczeLvE
	mj0P8RCHfd85Pv+4Ow==
X-Received: by 2002:a05:622a:1388:b0:51c:7aa7:e0ea with SMTP id
 d75a77b69052e-5212c20f0c9mr108504931cf.39.1784486580491; Sun, 19 Jul 2026
 11:43:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
In-Reply-To: <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 19 Jul 2026 20:42:49 +0200
X-Gm-Features: AUfX_mxZAmDgP1C2hJYyCV36TzCfzCkpkn9ppyiNeH1CkViYcwVDmhXZWL-qKS8
Message-ID: <CAJfpegsS=aZABvwx56tfMtWzSsKWtR-N78q3YQ6JZ-nvQLUrGA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Giuseppe Scrivano <gscrivan@redhat.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 Jul 2026 at 16:13, Andy Lutomirski <luto@amacapital.net> wrote:

> This gives me the willies a bit.  It's very cool, but it has some
> potential security issues that I think we need to watch out for.  As
> sort-of prior art, NTFS supports alternate streams and Reiser4, ahem,
> supported files-as-directories.
>
> Some questions that we would need to consider:
>
> 1. Can you open an fd referring to a "directory" within an O_ALT tree?

Yes.

>  What happens when an unsuspecting process gets such an fd?  Can you
> fchdir to it?  chroot to it?

Yes.   However you cannot escape from that particular base file's O_ALT tree.

>  clone its tree and possibly bind-mount
> it somewhere?

No, it's an "internal" mount, so no cloning.

> 2. Can you bind-mount *onto* something inside O_ALT?

Again, no, because it's an internal mount, not in any mount namespace.

> 3. Whose creds are used for which operations?

The creds of the process doing the operation.

> 4. Can you mmap the things in O_ALT?  Is this determined per object or
> generically?

Per object.

> 5. Would we ever allow FUSE to expose custom things inside O_ALT?
> What contents of O_ALT can a program trust come from the kernel and
> have the expected semantics?

I think adding such a plugin would be similar to adding a mount.  So
I'd suggest allowing it with the same privs (CAP_SYS_ADMIN) and
constraints (limited to the current mount namespace).

Thanks,
Miklos
