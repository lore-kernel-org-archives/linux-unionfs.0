Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B0F331ECF
	for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 19:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782328029; cv=pass; b=hdz3xW56DOnTxH5MYNYReF8pfgpqESR2+4HJklo5klYGmMqSDqfd7qOYI0bNmSHEc75NFbYs7keYXXGATbTNT/eOGBzTvGfkoBbwtgjPYiczFVFEg0bIf3ZEJLmIUHNZKmrsLckjbg9HQrq1WsbRog0pbrx3lHNsdZAuhvDlx3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782328029; c=relaxed/simple;
	bh=dTdPVfrtLsMlTfHUl6+zlBoUHaF6Mspj1nijccsc8Cg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LU3UXbnf2mcmFh5ETw3mhmz8Zbd8JI312Uz7N++zLltCESa4EcWZSyQotkiG7BpSMu8zMG+d9n9Um+w0ZYrug7W5fx8oT9w2kL0SS9RSURF+Fb6OLcIXkq/ViywlgLM6lhWb2FCq4EDELKDPiHMUZvQ0WQP5eXPplpbcp/yBGSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gVhCoB3l; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gVhCoB3l"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4924e6fda5dso7412965e9.0
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 12:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782328026; cv=none;
        d=google.com; s=arc-20240605;
        b=M0Vu32FJ/onDS3Bhz6OgFh8uEMi4xrdkjnioQ8j8K79XOLg3gMzccV1nKtuHWybQnq
         hsq3YpF90X/zGl/pBu4i8bpquzwlK1B3SA6kyXmg3UHTMC6WKc6Y2r0JYe1/WGIvCnjh
         1sVkGD4Nqgp2cI+xrAol+gXzJdrb7H0LUR2cCdscgHN87mQdv3uRAPcqFmG10k+IYO6p
         KtxcMtiqO8N9BBvf+BqwbkX9qj859LyqAs+2AZ0VYlxAn8TVVYKvoRz9ruYms3G3yJli
         K3MoPIdyRiasbcnZVPZ/ihmGoHqvf/z2Kc54iK+FC+e867lXB0yy7VSc8BQ/Z2Kyqhmu
         Gu/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=62RtAAMdOG7011x74VLOvyQrp7SFTtUxM8XkYksByVQ=;
        fh=sC6RVr3RncEn15xK6aRpJ69WbAeiKtDEbeCRz/cXwIU=;
        b=F7ODMAplgIr94gpq7U4ARDkQue2n4WfI0cE/BplRNzAQbPFqifkPWyU7vGMgJbzUWc
         a7OFHW8Jlu44n2oc31TsPTpSwImVQIWtQkwNYXU2DiecoOGMSd6twrZn0BW7kcPYyTMl
         d4/OxN1otc40sWU00XHcYRmD7hISVc2CcvwlBvfbI5j2NnYTv4+g5cMxFK66dmgKyhiv
         HF7ocDvh4k2cvIVTDkpwpUGHVNZ+PXJKOTi1rkL9aoHojDhyr/bPkrssB/j7+smnbayM
         vq17VOG4xWbelnlsiXASTmDuVEqJvAZ5C6w5D6czKlgQQoyYEeA067ZZHmU2tkHuBb7h
         mQQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782328026; x=1782932826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62RtAAMdOG7011x74VLOvyQrp7SFTtUxM8XkYksByVQ=;
        b=gVhCoB3lm1MXPO9T55GjGx0+DaVj/lztLpmUk96iRIeTyOxyNlRu2tJETAv7R13wSk
         r+j3Dw7Omo3mMf9A8MDADHQei3+hgkzIhpwYsvgk48YSz2L6dKgHdDsrQ6IfCJx4bZiH
         mMmPztehOn1YQOIMOcw70qOjm/bIbTZqTCPkVar5laaV7DVoNFJurlcm9yos0lnMeSZ7
         rEz6ZohElOLpqEc88Dw/E7nXetz66Q24Mau9jFa6JteFAGFVWqpc7eFNy7ipzxGQFiAr
         PEuZAxv2qDZtb2oB6NVt8iAmtNO9oZuxlxrCwln9/dbP9tA9yDuUvbUgTgWYLX71U8Ad
         rC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782328026; x=1782932826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=62RtAAMdOG7011x74VLOvyQrp7SFTtUxM8XkYksByVQ=;
        b=fh6xl2MPEb/G4EykXrMDE/NDA6qjcBqPOxr3tWaArLq10cwpTmCog1vhcR8yvdDxCw
         nqi3JvgMKMvkUCP3qIj/a9q4VyWTwcex4qZEHjbveMEjjYJ/KW+9Oxui9obFyE+lEKyb
         IsZlX76mT5iq1xTqNZGvhO5dSBKHL8Y3Z0wx3Spn3+ITuhNRvbR05EDcCZNeIzQ6Uvxb
         tNt00iFQPGVsZ9zb0FJt5z8WIPOT3JsBuWmLRQeapQCc4S/p1XW/3DNbhlfygrMBqEtQ
         2txxqkBExH9kQ5eDmXw8/2pKH1cG3qAwmILzLCbLgFkF9fTM8Sc/yec3mQefvX8FtLrj
         DUwA==
X-Forwarded-Encrypted: i=1; AFNElJ99f3LHENTTD6FsLeQK8PAgr6JXh0HBaQfrbGxBBO5Mgfd5Ph0KO3WzZuWY7zNO5TF2o9U+Mbc3X5R/xkj8@vger.kernel.org
X-Gm-Message-State: AOJu0YzyMfbJynBzKurt3jvB5WDIqx/Mz5XAaFW7yqHIl6MROW886Kor
	tvp6uRH+Emx+t9Un9sKrtDKuaXGOh+nolMjyt5HJeuwAMBTX5BK0oljNzlIxNs4pw/UwttYZh4O
	p2zI7of3grb2bwPbUJ7cIKczbdLPv5Ro=
X-Gm-Gg: AfdE7cnV3C4MrYvR1ymPPxculkqQb6qjKx9yKkdBlsa1jwUmLlB4Iy5mK56ZAFungIc
	SxHwYRofzwYLyVhfVmrhNnfnnbRhAUl9o/SFqV02OY5GJxwT8ibsc8CB/256LKAGFxkl2QRaQVU
	cKmomTAidBVBIB9706PKWK+/tKZ5BrD3G9AfIoLikiZ08wQ5OeIsMJNoJXAIbgYkOu4q7GUOLtO
	fZ68Qa8xKkX9j51/EwjbxGU8kIgXN+oEBvCsmjXBHhGSIoSvpxR5/SPMk9TjkIgNfNeB4wU1+d4
	6YMqinWmr9ASuMh+u8qb4uXt7Dfp4JzyGVy02LQ=
X-Received: by 2002:a05:600c:a51:b0:492:379c:32ee with SMTP id
 5b1f17b1804b1-49249083c09mr358068975e9.6.1782328025896; Wed, 24 Jun 2026
 12:07:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com> <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com> <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 12:06:54 -0700
X-Gm-Features: AVVi8Cef9aZmI2zHP0TU9bg-9tvoxUc7Rq0PSUmFsfd-hngauFECj4f6N_uHz4Q
Message-ID: <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Amir Goldstein <amir73il@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 7:16=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Jun 24, 2026 at 1:45=E2=80=AFPM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
> >
> >
> >
> > On 6/23/26 19:12, Nhat Pham wrote:
> > > On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
> > > <ptikhomirov@virtuozzo.com> wrote:
> > >>
> > >> Overlayfs forwards data I/O to the real (upper/lower) file, so the p=
age
> > >> cache lives in the real inode's mapping and cachestat() on an overla=
y
> > >> fd returned all zeroes.
> > >>
> > >> Implement the ->cachestat() file operation by forwarding to the real
> > >> file via vfs_cachestat(), the same way ovl_fadvise() forwards
> > >> for fadvise.
> > >>
> > >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> > >> ---
> > >>  fs/overlayfs/file.c | 18 ++++++++++++++++++
> > >>  1 file changed, 18 insertions(+)
> > >>
> > >> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > >> index 27cc07738f33b..a7e252a91ea43 100644
> > >> --- a/fs/overlayfs/file.c
> > >> +++ b/fs/overlayfs/file.c
> > >> @@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_=
t offset, loff_t len, int advice)
> > >>                 return vfs_fadvise(realfile, offset, len, advice);
> > >>  }
> > >>
> > >> +#ifdef CONFIG_CACHESTAT_SYSCALL
> > >> +static int ovl_cachestat(struct file *file, struct cachestat_range =
*csr,
> > >> +                        struct cachestat *cs)
> > >> +{
> > >> +       struct file *realfile;
> > >> +
> > >> +       realfile =3D ovl_real_file(file);
> > >> +       if (IS_ERR(realfile))
> > >> +               return PTR_ERR(realfile);
> > >
> > > We're propagating the error of ovl_real_file() all the way to
> > > userspace right? I think we need to handle this.
> > >
> > > For example, we might get -EIO here, which is unexpected and
> > > undocumented from cachestat's POV.
> > >
> > > Maybe handle it and just return -EBADF or sth like that (with some
> > > updated documentations, etc.)
> > >
> > > The rest LGTM, but I'll let overlayfs maintainers check the
> > > overlayfs-specific bits :)
> >
> > Yeh, we probably can use EBADF here instead of propagating:
> >
> > Man cachestat(2) says:
> >
> >   EBADF  Invalid file descriptor.
> >
> > not really a bad fd here, but probably close enough not to rewrite man.
>
> Please don't do that.
>
> Re-read what you just wrote - it is ridiculous
> Because of being lazy to update man page,
> we are going to send a confusing error to user which tells them
> that their fd is wrong, which it is not.

I don't think we're being lazy here. It's technically more work to
handle errors and updating documentations :)

I'm more concerned with undocumented/unexpected behavior (error type
in this case). -EIO was an example that I saw in ovl_real_file()
itself, but I'm not familiar enough with overlayfs to know if that's
the extent of it.

But I'm OK with just updating the documentation with a simple note
that other error maybe propagated from the underlying fs, if no one
else thinks it's a problem :)

>
> >
> > I'm a bit hesitant though, since in other overlayfs operations we alrea=
dy
> > propagate, maybe that was by design?
> >
>
> Exactly, plenty of overlayfs operations return EIO for unexpected
> conditions, often accompanied with some assertion as is the case
> with ovl_real_file().
>
> Even though many man pages don't document an explicit EIO error
> code, it is obvious to any experienced sys admin that if EIO is observed
> they should look at the kernel logs, because an underlying subsystem
> may have reported critical errors.
>
> But in general, man pages follow development, not the other way around.

Fair point.

>
> Thanks,
> Amir.
