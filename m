Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005AE3E866C
	for <linux-unionfs@vger.kernel.org>; Thu, 25 Jun 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403969; cv=pass; b=AMtzJHUKwxtAAbsuHlQjLP0TrYDyr0LhIMobx4i4oocYZFuzc+7RcY6pt0AxTwN/hBxBIOXVBdVmunxJnl0Hv41h2rYs6qbOsiM3ftDezHE4JmJ7gnvo+VKgsG3ImXC2AIAxo/w9gdRk5Giljr/145FzniM8v0mr02/07sinVaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403969; c=relaxed/simple;
	bh=eXt9ABDO783EWacDInE1oNiBLyj1Dhw+23oyO0+eAgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rcOzsTuvTN4Bcqn6atvN10Xf/dp/9TthVxjxWzljW9J/b1ph0DuuVIO3uNMQKT1UUCcjfK4aSbf1bmtJB8rP01y0C1K3dWoZvAK73sy17w0ct4omZxpbq8aM2HCV5dgZrkef6mGcd5UiOVD1JgiXrph/U7PqNw9Etln+ikP5b7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f4DMGztG; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f4DMGztG"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-46e22950091so524359f8f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jun 2026 09:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782403964; cv=none;
        d=google.com; s=arc-20260327;
        b=PLVgAaGq7zLFNWrzeJclzzukGKfIXLWRO0pZa5h9zMYuvbphpT+v5/ZWgLwexxdoLj
         SRKYyy2Ce2yJ3j7XMafJll+pqaOy0xGvfXj+K8WoqsUgl5OyXcmOFotJCNZXZsv60qwn
         u6axFKeJ6OanWCn6ilJI91UJZxiqTiEXJuKGcY/y4hB7iAhL3IPxyRCdzL0uf+G8HRj9
         97yWu0yc8PMUIr1gsXOcWYA5KyPRLqYZu6+W2fZ0hzFnx6cx+c66fjPoe3NPbk0vr3aw
         nM4NKnUKH42a3btThechY3a3zFe433P36AAx3R274antUGpVWl0w04WvaVxIAaOs4d23
         cW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CUBIaAU4SjeKQvA50OYn7Uvq2LX5djfRwg5zsqpr3iA=;
        fh=gscJmgl5Jza/KyJJgRF9Df/xHROvFZTvy6R3n2bpfmA=;
        b=Dmo7Wl1+L1g88uzqgpDJFW6eiXNEgrHsCORk5gg23ybjW2x6+6PjnaVkcIHIRVx1lc
         UFycX67jWz/mldU27B5XxVT7znGidicLbz/6+OjSElKSeIaM9NUkh3kSpkE2PHIm9S7U
         sCjz6fAs/POgKrqU6JTRxPMyVOekxEXaaNEIZBxu+J3ibn2H45YVsEySvukuX4fIcXbx
         KFQtDSn8lP7nZEcMPgrSVf+L3tNmLos1yKyHopxN+2U3txkn1MMEPrAbskNfktlmnWIg
         iAHP1kluw3n4c8rKMgng5yidFY8P+fMCsjAHPt3DEOwwm4AU7CP2WHNrLtrbHIsLkOG0
         uU1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782403964; x=1783008764; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUBIaAU4SjeKQvA50OYn7Uvq2LX5djfRwg5zsqpr3iA=;
        b=f4DMGztGMthA12Y49u2OIH/xR/gEfBSbRh+LVXv1O/l1HruR+NNt0r3m71HxstJwGX
         qkZ+sgvkP2zGpb6G7Uy7eHYVBvui3N5iq9K24cViZ8d6NJ0M797yjVtpYS7aZSHAsOLj
         xJZ5CPW8spTde0D2ScucCtwhC1MICHJwHpDD9wzxCajZcTJW49XaR0N4LL9tLJr9d5/g
         Idlll1HHleiIdznevqRuJT8bGq41lG0twhJAgG70D7yo9DSfi/TCvpHb0Dx2O19GlrSJ
         rE1266ycoNTUBlvzDfeqNHgGvtz3zsYFTPf/n4NnaUaFeF8haaUm1EKB7buGJ/nHb2AE
         xy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782403964; x=1783008764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CUBIaAU4SjeKQvA50OYn7Uvq2LX5djfRwg5zsqpr3iA=;
        b=oZ88qK04w5SVuaW7bynas4Hh3swOO+J/bnVpJEOqCb2DZJp7PRMjZXs5VLA1DEoyLZ
         VuDuRJX2Vdli1V34rxr6BVCjuin2JGARXTKWBHBQjabzFL1259k2IQWbInFWyzqbRrBR
         W4/S/2/MYUnuX7j7J1MXeh0fz0M/y9loIW1jHEsiXNTuno51zYJ08ASkMKTbr6EAKmk0
         sWqBN39ElEQP4HFB7i51lHGj3v75Ft5MgnNHLDnZCZSQvF7G8L28gCsSGsbJiJU+NUfv
         DaAq1+o0DJ3xBXPUglVeuxfznVpghTOdby5psgjxrhwREFap3Tx1JhaRWzcOxx6of3E3
         6+rw==
X-Forwarded-Encrypted: i=1; AHgh+RruAlW6vVIB74VQ2On+r8lPEI/+rafs/5Qd/W+HUdBoh74fYRpSOCZoTaJ3Gp7A9AFUgzp6I1X/hw7g7GP7@vger.kernel.org
X-Gm-Message-State: AOJu0YyEkkLdWttC7iaxxWJLUJx5kpij6F3uhCmgzXY/M6gbadw4dW1S
	j6W/DDeVIY0VDuAJ/9SfTWFQfDJmOvEjxO/hpv0myXhhebEd+hj50jz4ThPTXAcFpb5WcSbLe2z
	Npw7g9EnLo/y5tHAPMa0Aedgq3ReYm0Y=
X-Gm-Gg: AfdE7ckDL3dXnjEK7REO7i2qZfJjGirXuhAzm+2kNo3CdoiIktEu/wiUeG+3rb7ngIy
	ZcY+8Iv544UEduiu61L7/xgyyD6DcXFO3jP/6knlRZVSpTqubqenP4SeLVnSMf9Z6WyzpIOZome
	tvxqSw9iQWNMATzfYjBazjGibgbo8QcL6ReyTEDiRHACF5E07J1QuA4Y7uCWFV140F4fB2QtUev
	sb2YETk3AyoAYZzBlJyfa66iQJV9wRLYpWWumJyhMTXRMfYdwJTpB++9KOt8JaIQvsfqQnLM29M
	3m2SxMQXxVuZG2TjU+fzdlgq2p4Y
X-Received: by 2002:adf:e011:0:20b0:46e:6210:ad4a with SMTP id
 ffacd0b85a97d-46e6210ae29mr1543499f8f.5.1782403963978; Thu, 25 Jun 2026
 09:12:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com> <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com> <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
 <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com> <aj0ku26XNT7Xc8x9@casper.infradead.org>
In-Reply-To: <aj0ku26XNT7Xc8x9@casper.infradead.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 25 Jun 2026 09:12:32 -0700
X-Gm-Features: AVVi8CclkB7MBq3wqVoG0kXa1O_Tzai8KiVnn_7BdwN2N3gQweVrg3KGSb5MSwk
Message-ID: <CAKEwX=OAg4VzZ6UA0BFOhnkz9EYNF2H1FHsEAkfFZObcbc4dFQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Matthew Wilcox <willy@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 5:53=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Jun 24, 2026 at 12:06:54PM -0700, Nhat Pham wrote:
> > I'm more concerned with undocumented/unexpected behavior (error type
> > in this case). -EIO was an example that I saw in ovl_real_file()
> > itself, but I'm not familiar enough with overlayfs to know if that's
> > the extent of it.
> >
> > But I'm OK with just updating the documentation with a simple note
> > that other error maybe propagated from the underlying fs, if no one
> > else thinks it's a problem :)
>
> That's ALWAYS true.  POSIX even says so explicitly in section 2.3:
>
>   Implementations may support additional errors not included in this list=
,
>   may generate errors included in this list under circumstances other
>   than those described here, or may contain extensions or limitations
>   that prevent some errors from occurring.
>
> We don't generally bother to document that pretty much every syscall may
> return -ENOMEM if it can't allocate memory.  That's just ... expected.
> open(2) documents the possibility, but read(2) doesn't.  I think it's
> the same for EIO.  Any operation which accesses storage can return -EIO.

Ah I see! Admittedly, I'm not aware with this POSIX detail. Thanks for
the clarifications and pointers, Matthew!

In that case, I have no further comments on this patch, and defer to
overlayfs and fs folks for FS-specific correctness.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
