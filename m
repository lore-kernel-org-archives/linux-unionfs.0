Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E354146D7E
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Jun 2024 06:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718348054; cv=none; b=s99pmJGqt6zwDJ0EPaTheMGtYMaiG1vPWDkwlDLkgzxYfepQUJ7O6UENumzcxSNqeSvku+6+OzbzKYgHa6Gqv3pgL7Xc30RceBcRV/YcmhzN+UjOU8QF08VUiJ42R+OS67ItgB9ejq875mKeUeYsfjVoYt6ZB480YuMosAUN47I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718348054; c=relaxed/simple;
	bh=Jl63cl122kli1IlKKr3jwcVyICkX4UhQtyR+h3iEowQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FZatIBG7SCfv/KYkyLPQOB3+bL10msG/Ctd+WTfj9qlSIlXjV4SaZY1izsxOjEcTFB+T9Zb2CpKwGQu8nJMG9tLEU08BuIJ/T9L74WU539zPkGugrUqDVWlWMCi8KLH9qJfcVMd3Dof4fS3T9IYqGWXK122Weh9CZ6/ciClnSYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Xd4GfH13; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Xd4GfH13"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a6265d3ba8fso204291466b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jun 2024 23:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1718348049; x=1718952849; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jl63cl122kli1IlKKr3jwcVyICkX4UhQtyR+h3iEowQ=;
        b=Xd4GfH13WBFKKWUWOsUJupp8teugCLQgQo/vLyIjw08Gmheq/5SqBgBKePJRWvgV2L
         LJdXUHKmSwPUxl/TBTIRMWsN+waAyBFW7pBPr/CbyGv/pWlVjdjOACmSsqfUyJGotZsh
         7s/3cC1UwD7KrEgW3ionPelWEoRSzuDKZZ02g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718348049; x=1718952849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jl63cl122kli1IlKKr3jwcVyICkX4UhQtyR+h3iEowQ=;
        b=hn9mZy38ArxE/kcZII5lpoz+2SonTdCqJ+sAT/E2kkP3i1RU3lyDRsZ7psm7PBWoMP
         luy5/J8hx/syIZ+0Z9zEs8mmFbliFWGGPhue14952seyjchqMkods9ZiH6OGu91cEv8V
         lILgIORPbMbjA0brgwbxS4MfHIawiu2rzWwFqFhQO/fEGniud0ItvQ1OMOJTKjdbXaM4
         ClomcMehKuuGw3VHZTomtcQX2K6C7JztCDkgRH3fpfrtgKQxFAzKoUDycdJl3BM09zO0
         A6jENwH/Xilu0gTQpAOyXlT0i/EUsUUe878DvmZFPXmmElgMM9kBhCrQ5R9tGZHj5w3X
         o8Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXrK0xXsK640pJnJqULY8fogPJoalF/muX9cMMD19/npg4j9skJwpqoYqsKCo3+xFdariVapTGRDb9gbl2yk1gm7g8JM2RTXSELguApzA==
X-Gm-Message-State: AOJu0Yya/p2jqNcWIVb5oqcgC2KQDiYOoNhjOKz6jzpRULgC42KFLo5Q
	wr+B5anXM6HXcEjlW4vySp6pjIAWPpSNoqqgzePDs44M2772ToplSc5eKxGroDI2tRpxX3E7SP5
	xP6rNUYDLDJI8MsFTXjurIGI0tStty7waEmBhLA==
X-Google-Smtp-Source: AGHT+IFvea/cW4emLRNHFxJN0gw0MbDpL6G+wrsVPjsnfO+GhFJHv8i/1XtY537FV7KEcm2aGQvRbVb+q4y4gSNZzqw=
X-Received: by 2002:a17:906:b0d4:b0:a6f:510b:5c88 with SMTP id
 a640c23a62f3a-a6f60de343fmr108502566b.75.1718348048635; Thu, 13 Jun 2024
 23:54:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000871190061acd8fed@google.com> <20240614010522.2261016-1-lizhi.xu@windriver.com>
In-Reply-To: <20240614010522.2261016-1-lizhi.xu@windriver.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Jun 2024 08:53:57 +0200
Message-ID: <CAJfpegtiqWwr93_rtXU3YyJLmtHOtP8TAKQN0FLKVN5Yaz1EZw@mail.gmail.com>
Subject: Re: [PATCH] ovl: avoid deadlock in ovl_create_tmpfile
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: syzbot+b778ac10fe2a0cd72517@syzkaller.appspotmail.com, amir73il@gmail.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Jun 2024 at 03:05, Lizhi Xu <lizhi.xu@windriver.com> wrote:
>
> ovl_copy_up() will retrieve sb_writers, and ovl_want_write will also retrieve
> sb_writers, adjusting the order of their execution to avoid deadlocks.
>
> Reported-by: syzbot+b778ac10fe2a0cd72517@syzkaller.appspotmail.com
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>

Thank you.

This is already fixed in:

git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git #overlayfs-next

Will send a pull request to Linus in the following weeks.

Thanks,
Miklos
