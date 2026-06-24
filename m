Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624003C063E
	for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782310602; cv=pass; b=pGr4a8YE1wd325obKUdd7Tbej9tYg6Hwo3H3OFbAsC72ELoqsm6sTvYUJoqIxDR8lLn+ujVUZiubrYRUx2rkWM0xezzxg5/quifIwD5ONH6tIiZeHDomah8e2z+6c+PDZctAHrDX98RadihT34MJGy/FLh8aRBwGwJdSXMK0mZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782310602; c=relaxed/simple;
	bh=C+gNPHz4KywkYN7bRW5o/LIam8QAzcc06RneqyLy4Ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D6vWqXs40oYhTbi1rK5qFjAi40jqyPhi2TO1KrWTnH4jwWPDhXbJ1zgQe1yOjuyHbkVdxim23174DV9pkVGx6zA0YtAaELftsmNX5H9KwCPkhAt/xHzvlDKeLAFnzCCcwSBFl/+Y/HaZtqmrl+P4RH84cWgECD5SSm/RIKo8OQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mp7WPDsx; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mp7WPDsx"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c0efc7ef797so173557866b.2
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2026 07:16:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782310595; cv=none;
        d=google.com; s=arc-20240605;
        b=Q83FQMP3Vs9rCHQPhohTHpxSOL8xRp/PxzFSy2iNPm3PaeB87kzx3+QTIotnNnSzuM
         qrPHL+c6HfIE1IzGizeFqwS2DYRmf/Tsj5uRELw7TQ5JHXUQ6LrYEmru0WUJnZP/IKfc
         Wk9J0XyvmXC/fX7Uhgl2RN+o0ixtIsAmnue+UtwtZXKlfSiuRto37hnvmiZkiIHui5jB
         0ecWAZB4OkE4RkxkJx9IAT5roVuXlPH46J4dtv7TVGAFhSV2DzMORTgBMkL/Fkj+QjH1
         m7vglUTfdNYOFzttfCAg/SK2DIRoXPOVhFOfAz64dsbnb3kZGs5dhuJS19Suctb2mL7f
         xegw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ofp3hEpmgBuA2Xl9gZnye4TILLUrjr4efPci3kviMPY=;
        fh=PLvMUOeOwu0mbgkwykD3aXMmCVz1wFmT2JUzlwVFLo8=;
        b=OasaEGHWh8Y33wcJjqPK6dtoCMDsTMPI5stcyBuVcAq36Zw+T/52T3ZrQvpw//rbWu
         Nyh+oiFahQ7wbMuEBNSl9pNgibRT8Xu88385Rk61IWsIDc73uNcZFTWrVvLoyUImXeUH
         DaB2w2sJWf6IrNXDabGRnyjxLJqyZ1u8rU5hasKGlfmf1uKmIFHdI5d5zgZ1avWmvL4g
         zgzHNJgA7EG+7eWBlKWVLjROMNXpQjZODGYgOqbmXj4TaFMx87N5z7uS8Cbsu9eQ2LxR
         RMSTWFFf9kxfvxGZ3lM+vK4Fxy95PfBg5YRbVHe8ddUFBUhcNB75N8eO4D3dBQ8J82kk
         XjzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782310595; x=1782915395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofp3hEpmgBuA2Xl9gZnye4TILLUrjr4efPci3kviMPY=;
        b=Mp7WPDsx9tx7+TGBJpV5bdT+0V6Bvluay+GgAv/yVjk4WJxpnu7uJ1O9gE2AVhNjNt
         /SRvJRBDTtePlHTO1CYBZ80lkuvdeLV8Ik5ZzxmQ6cXXcRN1JyEUV4KwYar2q26ZS7QN
         6IgAjj4SdBRTGQYZCYkVhdVXBBRD2gkZ3NpeF/JCjVn9927EP1XdbtwG/gjWy3OiLYzN
         2yJ9kJqbNff012wpaNVw8CBiwu6fNfbof3rkMFvXb8yO6qIsM39l5d8x9uA+PbybiA2L
         Gjxt1Gz/7d+SfdOzfkIjoQX+NQCeyfFUYNSlqeNxdGTiOvH5/tBtOSv9KMgdepqMHz7+
         R4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782310595; x=1782915395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ofp3hEpmgBuA2Xl9gZnye4TILLUrjr4efPci3kviMPY=;
        b=iaV/M3jT/AhPeKZSFC1lE34Sa9cOfjQnAHJpj6tp5VXBR0+tzIkije1rdeMkl3kBMc
         T0QmA3/Y+3atgOyvmucprpEXL2E7GRp3KJBpFm1xndiWPjI2TKK3SC3U44/q1TWdDPCs
         UXkIryCZY6hnLZl2tHJd/rsllJFNmQzK76qzNwvbf8i/90wMkFlA0suFE6bbw74FMZhh
         KEIr1W0qrIX42hDtvB7nusJxnnPiqm0B+yvOwoPWyHLJJocWBCs07pn+X0rx4hzNDKZL
         tlWhJ5lrUk/KQ68Gj3/5f/rTY7Ey0z3o+6pIrbdMi/EeoFXhygGBVvqLoCre0/erTGVg
         yU4w==
X-Forwarded-Encrypted: i=1; AFNElJ9+oR4lIlupjC9TefBT3bjaQDj7ysWyhKLjngHQI3ZUkU+TvDP7aGL7iGaxR4/fl89juIVLxhoS7jCtj17J@vger.kernel.org
X-Gm-Message-State: AOJu0YzIFGxqkEGwYHmvAQQKArDJ/tVa/JkdwB3DInAJ9OTcSieNTq2n
	HWQGuRVnJMRjHvUG4LStggVlO0RoFcXPS++CytsRzpqeph2BT195B03zaIj448uOckJGcv9nh0i
	8XzDiqCXgWiN8L+W19PeBcjJl0p04bO8=
X-Gm-Gg: AfdE7cnqR2bSHdZGn4D4Sg//13ZQQhbt4ekBpMB7ZOAM0gnbcWJgeyMDobBFqxYdp7W
	BuzeD5Nlegg1D/ZL4lUVPY/ejBgstCt5J2LamiCtlyhix27gkUFQc/+/CDXugSZ2qZBtUd3kOxO
	eBp9As7MmsSMaOI7fI0rGEc2RqHSrF73Cstl18rHlkSWq9ulVZkisctvTyiM6a/+G0l/GNEOKqV
	n+9Zyuquy1LHPpryrlLpLC04ixzqFzSAE4TxTCOKtb2xpE5Jvocli9avK4T+cjNDdKxzgPILleC
	5A6zvb1XgxF/1V9PEgEKMiYbJu0cnopNVfo0zpXIgA==
X-Received: by 2002:a17:907:6092:b0:c08:93fa:2a62 with SMTP id
 a640c23a62f3a-c119ce79d5bmr206413566b.2.1782310594693; Wed, 24 Jun 2026
 07:16:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com> <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com>
In-Reply-To: <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 24 Jun 2026 16:16:22 +0200
X-Gm-Features: AVVi8Cf8pFFkEx_V7HqzrhdruZGs8cQ3Zufmxz4l6Wlncf8175EfLgSWMtHkhw4
Message-ID: <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 24, 2026 at 1:45=E2=80=AFPM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
>
>
> On 6/23/26 19:12, Nhat Pham wrote:
> > On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
> > <ptikhomirov@virtuozzo.com> wrote:
> >>
> >> Overlayfs forwards data I/O to the real (upper/lower) file, so the pag=
e
> >> cache lives in the real inode's mapping and cachestat() on an overlay
> >> fd returned all zeroes.
> >>
> >> Implement the ->cachestat() file operation by forwarding to the real
> >> file via vfs_cachestat(), the same way ovl_fadvise() forwards
> >> for fadvise.
> >>
> >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> >> ---
> >>  fs/overlayfs/file.c | 18 ++++++++++++++++++
> >>  1 file changed, 18 insertions(+)
> >>
> >> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> >> index 27cc07738f33b..a7e252a91ea43 100644
> >> --- a/fs/overlayfs/file.c
> >> +++ b/fs/overlayfs/file.c
> >> @@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_t =
offset, loff_t len, int advice)
> >>                 return vfs_fadvise(realfile, offset, len, advice);
> >>  }
> >>
> >> +#ifdef CONFIG_CACHESTAT_SYSCALL
> >> +static int ovl_cachestat(struct file *file, struct cachestat_range *c=
sr,
> >> +                        struct cachestat *cs)
> >> +{
> >> +       struct file *realfile;
> >> +
> >> +       realfile =3D ovl_real_file(file);
> >> +       if (IS_ERR(realfile))
> >> +               return PTR_ERR(realfile);
> >
> > We're propagating the error of ovl_real_file() all the way to
> > userspace right? I think we need to handle this.
> >
> > For example, we might get -EIO here, which is unexpected and
> > undocumented from cachestat's POV.
> >
> > Maybe handle it and just return -EBADF or sth like that (with some
> > updated documentations, etc.)
> >
> > The rest LGTM, but I'll let overlayfs maintainers check the
> > overlayfs-specific bits :)
>
> Yeh, we probably can use EBADF here instead of propagating:
>
> Man cachestat(2) says:
>
>   EBADF  Invalid file descriptor.
>
> not really a bad fd here, but probably close enough not to rewrite man.

Please don't do that.

Re-read what you just wrote - it is ridiculous
Because of being lazy to update man page,
we are going to send a confusing error to user which tells them
that their fd is wrong, which it is not.

>
> I'm a bit hesitant though, since in other overlayfs operations we already
> propagate, maybe that was by design?
>

Exactly, plenty of overlayfs operations return EIO for unexpected
conditions, often accompanied with some assertion as is the case
with ovl_real_file().

Even though many man pages don't document an explicit EIO error
code, it is obvious to any experienced sys admin that if EIO is observed
they should look at the kernel logs, because an underlying subsystem
may have reported critical errors.

But in general, man pages follow development, not the other way around.

Thanks,
Amir.
