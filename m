Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB47322C60
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Jan 2026 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769854953; cv=pass; b=UOUtGdKqNzD5lfvztCb29vi3OwfNdpLtgBk4Hy+IG6zvn2J9leqAdI8UllZ/Sav0XL2qX7TsXGRZf4U5AnsxkfKDVgnHniwkg4fCKYKCUU8IfedP82FCZsZpRHzl4V2kSe5eF2PszpD1bnh6uD0Ko/6VmPuMRue/9Cx/yc/tIVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769854953; c=relaxed/simple;
	bh=YPQiVbTLDX2QySl8NWtf+H/tt2k8PPdv1MYIXxNFllE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bOyKnTFt5QNed8VXQw3yTkfivn+At/w8Cz2OCGxUV05JsZpF9u8ReOTLsBw9vodLqqkM+hUTHyC4VsmZ+NQG9j1bh/KubFfvZ1LPvKRrmEJnxEhEQ+gxuq9x+DyEzzxKZyQe0aLdA5mn4dA61JG0K9I/mprg2BkidboyiiRdz24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iGfIBMRn; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGfIBMRn"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-658d3d3ac37so4802017a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Jan 2026 02:22:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769854950; cv=none;
        d=google.com; s=arc-20240605;
        b=FfaAltLBHxy2tgBq/Pyv+0yKarxRzS+JisSnDf7D9obyYFep/UfTirKizH8jWfyb4a
         xfknf7KzOpeFYpfMdIPk0n1WpV/IWMmwpC6Apg5EECw/Xt1qTVBRWhok40TN6oX4ybSA
         cR4Ji6OxtvcnK2472d7ziD/V1cED4pPD7klp6bJ0fkIXJPAkVg/9Fr1mCNKyQkxMN547
         Nc+U/nx4jpzvEDNSgczVlBwRkjWvIRVQ5xqrPJfR/4tF6/eec4qVBRFZzindOzr7VJZ5
         iMbkr+MOkCF1Me/oReMyQopJF1CyYD9aWeH1ai5ai7KFUmNoLqZqwWBobI6pthw20lNh
         CayA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YPQiVbTLDX2QySl8NWtf+H/tt2k8PPdv1MYIXxNFllE=;
        fh=/D9VFW074n302K7g+3lyGa1dWbuOgSxkACM2c7JSJFk=;
        b=QuqNesbzDJ82TA020bezwNEKyQB8rf3JivAhCXVYMZX+99AnlYDETJK967XL/Ysefu
         KP/38kQtkZUPpDK47NqaQU8tb3yDuwOuXLZ0h07IOXDCzlT++Ic625Nx2MbbZfAf25s8
         HKOxF0hbfM21U8B+T+jz1YRE3Kps6kAEtt6EwfqGUb84Q0XuuQ5AL8xqYBxss1qMEQsU
         ejKUW8c64sy4HjCnuwl1kE+DzC7DedWKYAPLIAHI/dgQllTl9rgSEO0ZZWI6qTsBZUh6
         vrcpigye0PsrJ3VcivT+zHIVl4U7cCKeCnJ6BBMGDGlWwOqLxw0lhZfNa64GsGSwaHLN
         VjYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769854950; x=1770459750; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YPQiVbTLDX2QySl8NWtf+H/tt2k8PPdv1MYIXxNFllE=;
        b=iGfIBMRnH7Gv9C7JGDzZjOlHDgMv60hNIFmw0+QIXRVzM7SKUTps1f560iBkOWzFat
         H5w+wl7KDxwD0tG322MUxCsclAiTZP2uA8lIi3quR9Zi/En7F8/MMhFaG8HQWXSbpVJn
         wa6P2GwmCAtUmwH0W6D0u0Kj8Tert+BP1Plv55xmvT6b5/9hvyVRoSzSRjE+HqInNn7u
         Eg+9zFCNKM08fKBnV56xXR6rqqy0ijG5M/Z2FeIS358PE5AP3c3xE0JwwJMVCGYcBYel
         Jxs4oDIFzxfHplRXxSUAyJm7/II/SrX0xEum3A5D4NWoD+iXcyVU+Ex5OUEAAOrF5hZy
         dLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769854950; x=1770459750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YPQiVbTLDX2QySl8NWtf+H/tt2k8PPdv1MYIXxNFllE=;
        b=qAN4A21d2BOkflHOx4yelAQU7ebaRKmpwFkNJiKYXk0snWELsv8K/ZrD5c/C7qhKN4
         g/p1heDTLoZ5CUgkw1hXx83erDDnjL4KYU7a8eg6/FfNu+jSciDAwKzjPQGRsEBggm5V
         nNufjYLZaxtrmY/AmtjdHgCm4anYIhLp5CBOfYUuFcJObY4NtpTm6mUAQLvjxeT7Y/Xp
         I+fR/LhXGCQduAfgrT2NBY+uOhuBIFM107FvVbLOC/BdgNmhOd2n4ibQQqw/nEX24fXC
         9Xi2oGomCh27kEfwzO10DRD89Ko8ZQvTGRJADaLTGDy2L/W9vZV44t8C3wD24FHnYQ40
         ln4w==
X-Forwarded-Encrypted: i=1; AJvYcCVQ5E5IyqB+LoMw9ZMx6J2pjwVd1LGMKZxMMYZBYnQl/X5Qwhq7Jn3ekIoBc0HwscCtp9pjgM8NUg3v7g5L@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8U67SqTDQfj08WhidLCiBphJPTQ4r4VJ22B4SEZ7g+1H5hPzd
	S1q2gkRdDMEhslJyov2rEw6chwjpsSawsANPQApXgRdO8YgtQUWGtrpkFbJMKIbhqBn/lK2aNYv
	JQLEFMq9zg4du30Y5v/pFoFhRh0q4904=
X-Gm-Gg: AZuq6aLvL5Ldo6hDige5muF2BRfWR99W8glQXZD/IN3o9Vbz+49P6nhaG3j1/A6h3NB
	mbvsdWXGa7qvANpssFnCdotnAU71hr09fiswNgK8DjeWKEciItFNcPJvM30zBfDfAyLU24juVC7
	QIlJEFYengZLpaEwD8HGbh2E/WUwItzxiN8BblWs2fkhlwC5G6oVpfLLeYeLS6e3bmMuXdUdX8w
	S9vIucX+UD8h4IrCo07gjQGjkK3hZSRYULm7vh5AbB+F+dD3GrWsarmy7Pj5NuSPY459ebS5XKX
	I9u0j94lrZo6E0gCjy+clL9SSnex
X-Received: by 2002:a05:6402:3483:b0:64b:8d7a:71cf with SMTP id
 4fb4d7f45d1cf-658de5a0ce3mr3157686a12.26.1769854949593; Sat, 31 Jan 2026
 02:22:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130001418.18414-1-wufan@kernel.org> <CAOQ4uxhf6EQKcoN055xzmi-RW2GPxRzz_ExsQawGQBSmoX2WYg@mail.gmail.com>
 <CAKtyLkG1_evj7=yrB6nH-8fJuP3DsWyxwrhv7O_Mk=Fy8FOvVw@mail.gmail.com>
In-Reply-To: <CAKtyLkG1_evj7=yrB6nH-8fJuP3DsWyxwrhv7O_Mk=Fy8FOvVw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 31 Jan 2026 11:22:18 +0100
X-Gm-Features: AZwV_QhOhPDOYt2J1lFISrx3c1dHs0q3o3EvwGFAflm_-U4v5NyUzpUKw-giy8A
Message-ID: <CAOQ4uxjndETYhGayZH_opeMxH1zadW5G0DUHfdiGt=i+pM26ow@mail.gmail.com>
Subject: Re: [PATCH] ipe: document AT_EXECVE_CHECK TOCTOU issue on OverlayFS
To: Fan Wu <wufan@kernel.org>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, mic@digikod.net, 
	miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[+CC fsdevel]

On Fri, Jan 30, 2026 at 8:21=E2=80=AFPM Fan Wu <wufan@kernel.org> wrote:
>
> On Fri, Jan 30, 2026 at 3:06=E2=80=AFAM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Fri, Jan 30, 2026 at 1:14=E2=80=AFAM <wufan@kernel.org> wrote:
> > >
> > > From: Fan Wu <wufan@kernel.org>
> > >
> > > Document a known TOCTOU (time-of-check to time-of-use) issue when usi=
ng
> > > AT_EXECVE_CHECK with read() on OverlayFS.
> >
> > Hi Fan Wu,
> >
> > TBH, I don't like the way that this problem is being framed.
> > IIUC, the problem is using IPE on a non-read-only fs.
> > Is that correct?
> >
> > That fact that IPE metadata is usually coupled with read-only fs
> > is interesting for the understanding of the use case, but unless
> > IPE feature mandates read-only fs, this is a generic problem.
> >
> > OverlayFS is just one private case, which happens to be common
> > in Android or containers? IDK, you did not mention this.
> >
> > Please describe the problem as a generic problem and give
> > overlayfs as an example, preferable with references to the
> > real world use cases.
> >
> > If I misunderstood, please explain why this problem is exclusive
> > to overlayfs.
> >
> > Thanks,
> > Amir.
> >
>
> Hi Amir,
>
> Thanks for the review. That's exactly why we CC'd you and the
> overlayfs folks, we wanted to get your perspective before documenting
> this.
>
> Let me give some background. IPE enforces execution policy based on
> file integrity properties, primarily dm-verity and fs-verity. These
> are the trust anchors, and files without these protections won't be
> trusted by IPE. Since dm-verity and fs-verity are inherently
> read-only, in typical deployments the TOCTOU issue doesn't exist. To
> support overlayfs, IPE uses d_real_inode() to look through the overlay
> and get the real inode from the lower layer.
>
> Recently a new feature AT_EXECVE_CHECK was introduced to allow script
> interpreters to request LSM checks on script files before execution.
> The idea is: interpreter opens the script, calls execveat() with
> AT_EXECVE_CHECK to verify the file passes security policy, then reads
> and executes the content.
>
> What we found is that on overlayfs with a dm-verity lower layer and
> writable upper layer, when a script file only exists in the lower
> layer, AT_EXECVE_CHECK passes because IPE sees it's dm-verity
> protected. But if another process writes to the same path after
> execveat() returns, copy-up happens and subsequent read() from the
> original fd returns content from the upper layer. We verified this
> through testing.

I don't understand how this is different from any AT_EXECVE_CHECK
TOCTOU race on a writable filesystem, regardless of IPE.
It seems to me that it is the user calling AT_EXECVE_CHECK who
is responsible for verifying after reading that file has not changed and if
it has changed, then the AT_EXECVE_CHECK could be invalidated
(depending on policy).

Maybe multi-grain ctime could provide a safe cache invalidating check?
As long as the filesystem is trusted to report true MG ctime.
See below regarding overlayfs...

>
> Overlayfs is popular in container environments, so we want to document
> this for IPE users.
>
> We noticed the overlayfs documentation
> (https://docs.kernel.org/filesystems/overlayfs.html#non-standard-behavior=
)
> states that if a lower layer file is opened and memory mapped,
> subsequent changes are not reflected in the memory mapping. We also
> verified this: mmap keeps the original lower layer content after
> copy-up. One reason we CC'd you is to ask: is relying on mmap to keep
> the original lower file reference a reasonable choice? Or would you
> recommend against depending on this behavior?

I recommend against depending on this behavior.
Please do not document this as a solution.

It sounds like you are documenting a recipe for how to write a safe
interpreter?

The advice to mount overlayfs read only seems impractical to 90%
of the container users which use overlayfs specifically to add writability
over a read only image.

If the generic ctime check is not considered reliable enough for checking
if a file was modified and copied up, what about checking the
STATX_ATTR_VERITY flag of the file?

ovl_getattr() reports the STATX_ flags from the "upper most" inode
and then merges some specific fields from lower layers.

I think that would mean that in the use case to describe, a copy up
would result in STATX_ATTR_VERITY going away when doing
fstat() after a copy up.

If this works, better document it as a good solution.

>
> The narrative in the patch can definitely be adjusted. Would something
> like this work better:
>
> "When using AT_EXECVE_CHECK on overlayfs, if the lower layer is
> integrity-protected but the upper layer is writable, a copy-up between
> the check and read() may cause the interpreter to read unverified
> content."

Sounds fine to me, as long as it is clear that overlayfs is just
a private case of the AT_EXECVE_CHECK TOCOU race.

Thanks,
Amir.
