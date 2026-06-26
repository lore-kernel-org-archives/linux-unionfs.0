Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCE939FCCD
	for <linux-unionfs@vger.kernel.org>; Fri, 26 Jun 2026 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487127; cv=pass; b=TP1HMB/a50lucEMHNQ+SVCKYeRlwuaIxHwyae7lkoDpc0sdep8shp2yZKJwB3Gnzqohn/xH0kT/MZnPOF2Tah3YmkcS9x0p/bK59UGAxVIWjiXAfNUAlDi/RyCaJcAk5MV4Gr21WySmcGZrkJEwUa22Hw8vkCb6Jhdqyf4ZR7Yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487127; c=relaxed/simple;
	bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ATo6GtInrLhlN8g4eIU4ATzAIRitXwAayVM6d+tuoNw52RzMRBi2OCD0rgiHjsOV82GavDwZirC39aO5y+GFtA8RRtgZR76zlFshTQu8767iZ4eVFOIycHD0U6ivxrGoPK/oqNeGhEYbZeV50BvfFetJIWytpCICTOM+IwDvCgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fmCqssLN; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmCqssLN"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-68852b58d87so2426905a12.3
        for <linux-unionfs@vger.kernel.org>; Fri, 26 Jun 2026 08:18:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782487122; cv=none;
        d=google.com; s=arc-20260327;
        b=p80dcpbUWw7PHCyRahVKea3g5w8wRp0a439RU7w8B8JqtnG2F+PGL7VPukg8hjKkr7
         CPGKtYxwRlZ9kP1DPe0jk7Jx8BzI70D7u/Zcdq5rlmcJVXhQi84AMv6mp0jLogSzH0Vg
         7/C/btBbHSLbSla5wyJe0iRrDlp6KAoPu1ddsPVpeK6vEiW2ncSyaGUlRkROYy2Nhj0D
         /9pcFZbe01Ht41H/lN8tI8XHRdNoKYUAd4idSmBGCX6c0iKK730iKp+HBbGlrbykHICl
         T2VjWb0Fj07hoSpqtQqAvwpc7Xkg4Hw9dX0z7aaO0ich+W9/b2yDGiRG385nXzaiiPs0
         z9MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
        fh=1h40G1hRlbtcZTgaxF0uWiPOL08ht6fsWBZVFgFATq4=;
        b=Y+O3au/iBxQ6dV3Hyd3+mZl04DR1p9KNSFFRv8T1t1lOTb1doEOmRnhVioUv1SRBN4
         YzbbK6E0cn/YLr9nQsR+D6LXT3cyfowduhrxpkV9zpOuSl99x8YNMjiH0KnHwHa9TGEU
         v4oRqtUOqXsc/mvw2YAi5kFI86zT9RCMBus9Xg0497LEP0+yemK9r0vpF6+awR1W8jYM
         0A+4VkqLGMg6144aFJv+bZ1vaWJGAUcymadyTTOIrVYuS6S5zZzgnGciE6K10gmEmXp2
         add+qlaSkS58XGaW73yb+iBQL2L4SLSfK87PCWoJEbSIJYBK3acpPDd4TGNkRABmsRTY
         Gb9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782487122; x=1783091922; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
        b=fmCqssLNpl3dvJXUEdnuL6lGRzjspPiOg3xyAqpxVOrGRLmsGHPA+31ztFKyEaQ/Hb
         IZa1LGFcsYdAcvpRdhphz0zZuFxPQpJ27Pkc+R4Td2csCiGE9tNRMzxcpQBHBu6Mu21M
         2ek6yrcfdvzzygl5pZ7NAw+rSzZoGGcN5UW7gRof+nYf5bvpyigLVMV+yTqOsM5TjICX
         KFhiPOxo9Ziv//E+pEVWPM75LCuupJPUjbJ4+/Cvs7GCFd7xm8ld1X9yJW/FD9bIEqLQ
         eakiPIyd0CE7qu1kTqREy7qMixGuYdari40Kp8/wjuriTX7GyW9BYeoMQ5hYLVDkogPt
         2NVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782487122; x=1783091922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mVP2TUHCeB/LjDfIFLuoRmoPYS8ySiFWCJ8p8DKBKuk=;
        b=jcadJZf9vi6UCIY31BXqFR+N8ZBxza/n1fZei++F6fOxYbg2QUhZAKWCMynCyu08jr
         XdseZ+MzeRKtxEnV5xgz+A7kUnj74lI5jGReQfAkvInyuJiQpk9k7y0X6hpedz386pIU
         oPKVky6Fw0ALmP48er7wIBEyzxht+176iUUxAePccqRso224qQ+rmN0u9y9sY6Gp4SjK
         XdhVLFMjzlC0l0yzVcq2FVnJ846u0qnQ6350xi1pQV6Kl637zrvW8MKfNqHzrCMTtPZc
         xl2pg1n0noWSCCdLso8XScP10/8jUT7yRKnMZML2dceIvAq8sJWMziCGVOU9hmNpDOs5
         zoJg==
X-Forwarded-Encrypted: i=1; AHgh+Rqb1QplUoGzqaTMfriEDBgDfyVAnUX+Vzda/wax7OR3Bq5eWEqPuWzBHAgjb4A6IIQ7A5jGzqG94+3wtpbX@vger.kernel.org
X-Gm-Message-State: AOJu0YyBGV428wpKJH9P4QSn86GjYxD69troff7n9o9wMkPa47h9gatT
	elqZz869lm8AyFgI0Zj1BM8cXBwgp+dnnSIkKivYafEGQi4yF2his4m9rHaTNzjYrg0IsIr7ibD
	EMVjUzirYfCArXd1yaOrwF5qOxi/m55w=
X-Gm-Gg: AfdE7cmeqCdK2WIpP5KheGGmKtx8VcLvlxBKEo14ViBYyaLKRd1Shgl1Yo/XXpx1VT6
	IsUAJ+bH9rTNbA8gXfBiwL73u7Apn34nAfRhPi0G17eHHjPeQjHaIAeDmOv1OAgFnJn5ylp5Eqm
	ddTwmtQdms77I1EM6QqhqNS8FnANY5gqwyiaY9Tt1l7d8+6A1KCwmn36/5UfTAemkN++Hr5cb3E
	W0XG/J20h64IajwjY9OkEyuNJGd+uaQc3TajVJkvf6mLpRCUc1hQvIzWzZCwpPSAGlPa115q0AN
	i0CrvMbzTRccPNb2BM6d8BFVN5+SP+g=
X-Received: by 2002:a05:6402:2551:b0:697:833b:845e with SMTP id
 4fb4d7f45d1cf-69810aefba7mr2419788a12.18.1782487122292; Fri, 26 Jun 2026
 08:18:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com> <ajqOyIA8tPQsxfz6@cmpxchg.org>
 <3f6392aa-c1f6-4263-8892-978dacbbd8ca@virtuozzo.com> <CAOQ4uxhras5YAr8_HBpuHSDwvfiEF8vAr0NDB0R_PXtGDhnqjQ@mail.gmail.com>
 <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
In-Reply-To: <20260625-lehrbuch-gehalt-wichen-1b2f3533efbe@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 26 Jun 2026 17:18:30 +0200
X-Gm-Features: AVVi8Cc5EZwXlZ5GECvSYG7NzrqtiA5br21iMjGhuCiWGLWSPhjsckXvxs-eoOw
Message-ID: <CAOQ4uxiNrEZ8rsRc11mdjkMWe3dfThE0DJ2vXuO0yiNemnpR6A@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Christian Brauner <brauner@kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 12:36=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On 2026-06-23 17:34:47+02:00, Amir Goldstein wrote:
> > On Tue, Jun 23, 2026 at 4:55=E2=80=AFPM Pavel Tikhomirov
> > <ptikhomirov@virtuozzo.com> wrote:
> >
> > > On 6/23/26 15:48, Johannes Weiner wrote:
> > >
> > > Yes, AFAIU in overlay when we use realfile we should always use it
> > > with_ovl_creds(), even though I don't think there is anything cred re=
lated
> > > in filemap_cachestat(), I still think we should follow the common pat=
tern
> > > other overlay helpers use (similar to ovl_fadvise() and ovl_flush()).
> > >
> > > note: Actually some places get ovl_real_file() and use it without
> > > with_ovl_creds(), e.g.: ovl_read_iter, ovl_write_iter, ovl_splice_rea=
d,
> > > ovl_splice_write. But those look more of an exception than the genera=
l
> > > rule. All other instances use with_ovl_creds().
> >
> > Use with_ovl_creds() is a good practice to keep the mental security mod=
el,
> > but it is useless if the security check (can_do_cachestat) is not in th=
e
> > vfs helper (vfs_cachestat), so please move it there.
> >
> > Also it kind of makes more sense to check (flags !=3D 0) in sys_cachest=
ats
> > before checking permissions.
> >
> > > Also there are simingly no other file_operations which return "realfi=
le"
> > > for further processing, mostly the operation from fsops simply replac=
es
> > > general operation with its own logic completely.
> > >
> > > Thanks for your review!
> > >
> > > ps: Hope overlay maintainers will correctly if I'm getting this wrong=
.
> >
> > I don't think this is wrong per-se, except for can_do_cachestat().
> >
> > Just be aware that the real file could change from one cachestat
> > call to the next (i.e. due to copy up).
>
> I'm really grump about adding a new file operation just for a
> special-sauce system call which is under a CONFIG_* option even. We're
> not going to set the precedent of piling on custom file operations for a
> single filesystem everytime someone adds a new system call unless
> absolutely necessary.

I had a similar reaction.

> This looks like it could just use a new helper in
> fs/backing_file.c that the cachestat thing can call to use the correct
> file.
>

I was considering suggesting this as well.
Having f_real_file() complement

but technically, can_do_cachestat() should be checked against
the overlayfs file/inode AND also against the real file/inode with
ovl_creds.

I'd love to be able to provide a backing_file "template" for
operations, but I don't have a good idea how to do that.
Do you?

Thanks,
Amir.
