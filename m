Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795224213;
	b=TRJp35emlJKOkP+FSIMe6Ag8L6hByc+WH1Ipnwg1JI+1HdCa3gEBn2vDFmEn7L60CsDJ
	 uwZwfTG6g5gzXeJ5RJIPpowdRNYbCjvqsDB/3aiW64g9RzuSJjPhUKygcqNk7Shn7Yvx2
	 oqql1LAQFCPhf542t8mdN2YMt5nwwSsRaEWQXrNdNzXER3U9KWNOhBQG+Z3OYk28hyIxq
	 9SNGs2V5q9TQRBJuK5Io1LHFLBIHwkXlOGuuj8LdoY9yqjGRsZreZMddxQO2yps+cwsoy
	 D3phVlfY8YX1NkgDn7fOwwOVnXFrrfr0sT3WxixWCpfXYfMAOi+PfBEufg9QO9r1i4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795224213;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:From:To:Cc:Subject:References:In-Reply-To;
	bh=C/s9wcJ+8gC3Nb5xrepSAAC9C96LJN04eXTPT7Jkc7c=;
	b=N5udtVoXXjQPVwz4a8p7XfrLVYQ2niP1Pd5dRMYAG1dj0bKVSMABe9M/gSSFvqzf0EQx
	 YZUcbFjKAc0RrLmlGfeYKaYNFC6+bws6Lxi3JP1kZAj4i4dW6es77u2IMC68ocOOGOjHE
	 kyU04NIltMO8OtdDio/pjCR034sWGKI6crGNuF5r2HYAKY8a3Be5Zr+q3+5JzO1R9V1Q2
	 eOVWnIRlrKmGzqze89AofRsij5jGIG6j9k1z1VlUGePNu82DPblujU6ybjOP8tvrOvboZ
	 juGugoTfIihdxmFNVaw6bDmjqumgiJ989Y7e3VhLsBdr3KZ0iRbU8lHcrexLv5pEMNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=paul-moore.com;
	spf=pass smtp.mailfrom=paul-moore.com;
	dkim=pass header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=TjfjEOc0;
	arc=none smtp.remote-ip=209.85.219.41
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97466606A6AC
	for <linux-unionfs@vger.kernel.org>; Sat, 21 Nov 2026 01:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97466606A6AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=TjfjEOc0
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-921342fae7eso16354176d6.3
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Nov 2026 17:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1795224209; x=1795829009; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C/s9wcJ+8gC3Nb5xrepSAAC9C96LJN04eXTPT7Jkc7c=;
        b=TjfjEOc0aofEpvFrY7KXYL11LNUhWl2DuCcRBIpqPGojBhPT7K/iBi8R6H+e+xS5+U
         57JpMW+1HxZDQx9vcDxyE0znqBVsyOswu+Nra4t6TUITj3wR6bWHE/jeo2co37BZxlIP
         1BXoCxCjAMAHG25xHYIYt6r0mV97y3xmE+8jHSGQZtj2vGWciLZvIh/5WYMSV6DlC8XO
         fom8Ib+tTQ6nUOrPGhtqzAebhHP0ViJt/NmIUhcveERdwSJJ8JDC3m4qDyCsJLHJs0lD
         N6kNDNnWFpe/3P5/pieXrSxcxTjb/5fVQg+xguXEo8mdMDKIymt3Fz9bW7rmvNR2Zh8X
         7x5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795224209; x=1795829009;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-type:mime-version:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C/s9wcJ+8gC3Nb5xrepSAAC9C96LJN04eXTPT7Jkc7c=;
        b=iygF7TNRC75E6fVQ5O4AhE5bWlpNZYYcTA8K41hQVIe8BPTj460e3ogF6ql+sP5rHg
         sbuRJwJsUXZuvEZZIaVZp0/kCaRNOyshm0AW7Uo9H+FV08SHa90jcMzbjnAReRa+NdED
         UwYYTHMY8vyyxM2HaVKz/awATxqJsiYec1Ih6fdO+JJDKhfEID3cTGm72kMfLTRz+Skk
         A0Z0t6zX+gfspDaB6KsxIZ2In8DPkPwBzgw5LRwva6F0pCAxXcJCmZAte6g5kF+k2lbx
         4+TLXSCuA3+RrCDAUke4X3OIw5hXUuQhikuPvmPPJGQmUY49HwSLXt+CIt0Ss5nNESbA
         DrtQ==
X-Forwarded-Encrypted: i=1; AL+hErE5vDlUAa8BhdF56XeN/ouyAblbIb1hwZ0SLCRBNyhiRnlaN+ooEJ0rtbReiQgF669WEvzJM0SNb0uJMpZn@vger.kernel.org
X-Gm-Message-State: APuU4Z975yYH/3RxzrFkZTrz24oTleI7XeJjdQwUl01ZSzHRKKedhoHJ
	VNE2Cp43gy6sYc9mPi13YrvIarSmHCRMSNw4VqJhHHBScwyes4qI0cyIJG4kmZOJqJaXUKUl5zo
	PA9s=
X-Gm-Gg: AZFdTZcuz++8xkPEMlO7c+N8sYNzpIF+w+zbiRJletfjRWZ/TJzjlx+G/vgvcjWnQef
	AAcJkRrfvLl73rZ4IvHIj/QXWDtbDcyv38h3Rhegt/8v6XKNaGhMtVCssinBduQv8xXiTR3UaS8
	XqxOnzFU+gMX8Dr2K6xxGSZingHw9VWuxq63Av3121ZXmcsneWM/QmFRKW66fJSR8yhKTO0Rs/s
	DHj7EPeu0HpyUStdAZP/KBgYUvM5bP03C5LChSYfBsAiDziGh+xyOFNoIJb/aycZD/leqaqC0oI
	6MtndorNaynvbJSiJhHPD4abdVLGv/hWPlrSquyrEmssSBUMGYkq2mMB0R/d32gS/sihciSG6Zh
	DuanuSfA02pZ3lgtwTyBLzpbhRT3chDOU9Mn68T2mvBywLfdmZ5nLaJYi10YD+HG/nFh6D62vti
	bvGUMy62kpEqlj+iXBR7EILjKiTXCWLx3rgwhSfaVJ/Jzc27OoVFN+xFJv+kXpbGN4Yw94u8tRW
	Xh8q+sMUAUUQdMwyxu7v9aLcW2x8tMaSVHHvq25/Bsx5DlJOh7Cin21TfSJPH3QDAienjuUuTzu
	3anqX2F0HBasawBMnfYC+mPnLurPtLM5fQT/uXqvP/nESG1t/WgHx/de5iNrdXymVdbnb1XuLwG
	8p9Zqs5iZKK8bDxD9h0hnMa9Nz47kyw==
X-Received: by 2002:a05:6214:29e8:b0:91b:8b2b:5a0 with SMTP id 6a1803df08f44-92134a59f89mr82088546d6.23.1795224209503;
        Fri, 20 Nov 2026 17:23:29 -0800 (PST)
Received: from localhost (pool-71-126-255-178.bstnma.fios.verizon.net. [71.126.255.178])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921347a0b6bsm40207456d6.1.2026.11.20.17.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 17:23:28 -0800 (PST)
Date: Fri, 20 Nov 2026 20:23:28 -0500
Message-ID: <7695c09e696343176f9d1e1c3a3f4105@paul-moore.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20261120_1711/pstg-lib:20261120_1707/pstg-pwork:20261120_1711
From: Paul Moore <paul@paul-moore.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, Stephen Smalley <stephen.smalley.work@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, Christian Brauner <brauner@kernel.org>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] lsm: put the copy up creds when an LSM hook fails
References: <20261120073717.1588080-1-amir73il@gmail.com>
In-Reply-To: <20261120073717.1588080-1-amir73il@gmail.com>

On Nov 20, 2026 sashiko-bot@kernel.org wrote:
> 
> security_inode_copy_up() leaks a struct cred when one LSM allocates new
> creds for an overlayfs copy up and a later LSM then denies the copy up.
> One such pair is SELinux and a BPF LSM program that denies
> inode_copy_up. Enabling both LSMs and loading the program requires
> root. After that, each denied copy up leaks one struct cred, no matter
> which user triggers it.
> 
> The hook calls each enabled LSM in turn. SELinux or Smack allocates the
> creds and returns them through a pointer argument of the hook. A later
> LSM can still return an error, and the hook then returns that error with
> the creds still allocated. Its kernel-doc does not say that the caller
> owns them on error, and the only caller, overlayfs, does not put them.
> 
> Reproduced with SELinux and such a BPF LSM program: 36000 failed opens
> and chmods by an unprivileged user on an overlayfs mount left 36000
> struct cred objects allocated, which kmemleak reported.
> 
> Fix this by putting the creds in security_inode_copy_up() when the hook
> fails, so the caller gets either creds that it owns or none.
> 
> Fixes: d8ad8b496184 ("security, overlayfs: provide copy up security hook for unioned files")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [amir: put the creds in security_inode_copy_up() instead of in overlayfs]
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> Hi Paul,
> 
> Apologies for missed the LSM list and maintainers in first posting [1].
> Resending with proper Cc list.
> 
> I think this LSM hook was introduced with confusing contact for chained
> LSMs and this change makes the hook contract more sane in this case.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/r/20261104082128.3573690-1-amir73il@gmail.com/
> 
>  security/security.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Thanks Amir, Chris - this looks good to me, I'm going to merge this into
lsm/stable-7.4 and I'll send it up to Linus after it has had a few days
in linux-next.

--
paul-moore.com
