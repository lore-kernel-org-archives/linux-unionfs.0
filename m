Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563172C21C8;
	Fri, 15 Aug 2025 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755274172; cv=none; b=TI5FqFIKeZwd5oDce6/0PGoE+jVnUOnH31bUuVyR7ohRF5U21lIsNGvWk3XrL/ujMCfb8qls8zFgYQrcRd6vo3jQc9aa6k35pZoJFnsSb5Hx1ugd/V4LTBQhoy67LnipQ31swSFysaHpfqWjGXqE7CyhjYcdZ0+CM96POHdrqqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755274172; c=relaxed/simple;
	bh=P73dwaUBDaWkgGolkWG/hwKrYZgILKIIkbZZErL7kdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lEdvoeWMSm2ngM+2q2QvpXE8jC4xnMUMRnWuuuVaH0r3JkfUmo+TMKTRVQqHnaMt4u1UBNiiHIrMRpPVn/LG5wklaGWozMSNQZ0eJtjyjbv1Cl2yPNerwqEqbw3vJvnH98caeigY8uQ2gPdqopldWNNxAo8roO5RWSZ8MYitR80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PrC+Lcm1; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PrC+Lcm1"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188b690517so3204171a12.1;
        Fri, 15 Aug 2025 09:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755274169; x=1755878969; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zoMc0hor3cZgN8KXVf3DVLG/Aog0YVhAQ8E/o1jap8=;
        b=PrC+Lcm1Nhz0IYe3XrGLPeulzc97Fa1GhXDteTEOgYB+w9VER+a8znHgsuH7x17c3/
         jAr3oQmIZHkMnxTGCTDow2s7l91HPhKuo2frXLmzVrD30/nJ2/g/+Hw9oN6p1fXzsUE7
         fF7dPtsvaOgxutFciCDKXS7GH5Kk1MWRgJfiw6QO/XuQa+FJLvc53kxFkIYRG5S16Cci
         eZV6vikFJ+1UY1y6+Sa0GyzmyLYp2Jj1pMpsetqgupAcIWzCQV4IaT/EDQuxROdtEE8S
         jcWxQlPNw30/r5hLeXOqvvj6SX0iPvMSU4ZTn2B/5n6X834x5k7/ggLJQ0ND0Dz0Wfmf
         u6eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755274169; x=1755878969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zoMc0hor3cZgN8KXVf3DVLG/Aog0YVhAQ8E/o1jap8=;
        b=M1lkk91u7FCCyphooiCL9793hl+lbNR6ha4diBFkxW3zQ54fM9jxw+Cz6J72wkfI59
         K7BiShOfcmkgvESIrespgxTA8P+H4E2ksCpEKgw24YhwHvo7bxTycRnV4BV3BGs+Um6k
         m2q56quF7ES2z+fxvnyKg5yD2f40hUWD/24GadVhnot9jwr4rY1No4NG2UHYneLjCkaQ
         BUgbosiA15NGZzjUra53Twiq0GhlmcIPrVI40PZQGBH2T29EHIMYgG1rGovIc445xcZA
         PrjectiuRj6VoAOaD00O/KDdy9V4XEWZQt8JcB0brhp14+QYkQyiu5Fzh82pUidUFJLO
         Jypw==
X-Forwarded-Encrypted: i=1; AJvYcCVsOqQ7Q/hpQ+sRhQ5QKHB0S7oQm2D8BvewV17+dw7u62Up2Lh0MnCMENm425MVZNWYOUxmDdr6@vger.kernel.org, AJvYcCXSX3CRrNNzjB9kHgIw8m/U5xey4tG34GPWFAa9PZUuAl+a6BKwCJCpBY385DhjYwjGF+Jt+11fq/OwdjWnhQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOrNhXm+exvU9s/XcxFjuU0tZAcTFsvo3MQY8d5n8rQOqC3WIN
	O0+H0MeHg9WzBCauATiqN/jYzarzR+HWPSx89xcXRBJpX11tgoTEfsnYA4VYYJg59byPmI9MVKx
	JjBp/MWS69dV7W+VEHLJXiGOGisgrS5k=
X-Gm-Gg: ASbGncvKSthj7lqMVBRqDMDHepQqnwl0E5Jf2K+mz4n9qF0/HROdw4d47i2GAiFGG3b
	dLwVhVpEtGvJ1+h29M6O8GFbVxvQKPhmrbG0v5g+fZKZx04O5AfOQ5RjV7DL47+eO1hF1obkZtz
	ipighGGLu9PubhyAoCMuRkzxZzUqUYYVo3MCKlULdlToZVrKcGrI1apxIxy3vmhvlxk9hY5dXbE
	jL83zDmssaRQ8WYLQ==
X-Google-Smtp-Source: AGHT+IE48M8qHHLJroetAhwyyyMpPeL6uZvH0guSmXJh1D5JLxUelPf8jAVr8FieuSq5De7OHdL6wQMJ/BqmD+sNrS4=
X-Received: by 2002:a05:6402:909:b0:618:273b:4f51 with SMTP id
 4fb4d7f45d1cf-618b0559c09mr1728527a12.23.1755274168168; Fri, 15 Aug 2025
 09:09:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815144555.110780-1-zlang@kernel.org> <CAOQ4uxjVpVPVfiJPokpmu6pLDmjtYbeDr+j5jNHi8k9bK_2feg@mail.gmail.com>
 <20250815153520.xzgxwuwc7slt34li@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250815153520.xzgxwuwc7slt34li@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 18:09:15 +0200
X-Gm-Features: Ac12FXx_niVPpeJuLtzoahLGTpk0AkQvUHw1Zz9TQn_HoFt43eHGCG9XL0EBtXw
Message-ID: <CAOQ4uxhNhs4MPC1ZOTC5_Kzxe9DeFxD75XK6wkSFPjNducVBWg@mail.gmail.com>
Subject: Re: [PATCH] overlay/005: only run for xfs underlying fs
To: Zorro Lang <zlang@redhat.com>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, pdaly@redhat.com, 
	Xiong Zhou <xzhou@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 5:35=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Fri, Aug 15, 2025 at 05:16:51PM +0200, Amir Goldstein wrote:
> > On Fri, Aug 15, 2025 at 4:47=E2=80=AFPM Zorro Lang <zlang@kernel.org> w=
rote:
> > >
> > > When we runs overlay/005 on a system without xfs module, it always
> > > fails as "unknown filesystem type xfs", due to this case require xfs
> > > to be the underlying fs explicitly:
> > >
> > >   $MKFS_XFS_PROG -f -n ftype=3D1 $upper_loop_dev >>$seqres.full 2>&1
> > >
> > > So notrun this case if the underlying fs isn't 'xfs'.
> >
> > It would have been better if instead of mkfs.xfs, we would have
> > used a helper to format $upper_loop_dev as $OVL_BASE_FSTYP
> >
> > But this is easier, so unless anybody wants to take on the better fix
> >
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
>
> Thanks Amir, No matter what kinds of underlying fs are all good?
>

All I know is what I read in the comments and git history.
The documented kernel commit has nothing to do with xfs.

> I saw this case use:
>
>   $MKFS_XFS_PROG -f -n ftype=3D1 $upper_loop_dev
>
> So I thought it need the xfs ftype feature :-D
>

Ha no. Overlayfs needs underlying support for readdir d_type
but ftype is the default for xfs for a long long time.

I think that when Xiong Zhou wrote tests 003,004,0005:

https://lore.kernel.org/fstests/1461241438-24238-1-git-send-email-xzhou@red=
hat.com/

One of the tests was supposed to test the non-default ftype=3D0
config and then 005 used explicit ftype=3D1, but I am pretty sure
that ftype=3D1 was the default long before those tests were written.

IOW, any the loop devices could be formatted with any base fs.
The only thing that matters for the test is the small size of the
formatted loop devices.

Thanks,
Amir.
