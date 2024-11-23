Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E7B381AA
	for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732382355; cv=none; b=oui4OR1Bm8u+GrsCpucNiLvj4yf5r1Y5s/T2aj4lpd0sM5Yj/S/JK53mf7ZSPMWdhFzq0YvuCcO+bw76nNNKp1JDeUq6WHWt519Q9SAbdW8jh2329tCwmNp6OJaSF4QRz1X43z1n+V/gTw7j4v99OtGqaLlsI0jceIOLiTdwd9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732382355; c=relaxed/simple;
	bh=QNIZtU4UrRNcRlunJNgMSCglLrYx5rpbKWGGR17NwJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rMaexwX/cJ7d9Ahd8Z80F7kMCR3YuOX+pQ+5zn4+ItiL2egPk3n7LXpReOOZrBSQ/9aixlNLzQHGTpe/EB2F5OG23QvrnuY2Hp7fOpWMHi3KjurHE5BfqQlT8vaFuM4cueT8Ih3q4/+TIxydok4U2cUyMU1MDYKSIrcyVHcWXJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Souf28uB; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Souf28uB"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5cfc035649bso4227953a12.2
        for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 09:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1732382352; x=1732987152; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d5ChkXbScmteXOdHtNzIaXrYK9u5mdbWBULNnkBZeec=;
        b=Souf28uBXjFKQeHCzGFeiXbSlmEtDnOAq+NR2Viii9FjcRI2D0z6fT4I61g1hyJBd7
         qmi3EUGlkDyghQVTExM8CaMKGqGiNjripw+8tk0IubGM7vXE/NLpBO3hsTnPE21X54zi
         OUTYj7fWG2UEhLzeq2T5yLMmYmgYcUueQrT+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732382352; x=1732987152;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d5ChkXbScmteXOdHtNzIaXrYK9u5mdbWBULNnkBZeec=;
        b=mTE+OrKKshDEACzt/9ZTrFAktLG2EalVsomm6ewSmRcOvuEpvhswTbOiHowYuZxti9
         5bfWVIP02ZttGm5UuWGYapF8pnWT2DWpvbAerX5oigS5vPIUXDq3+myjallqp5uzxrWz
         MkNAi0XBzV67bHGZ1DZ9f9Cg6MGoPsUecYJPMK7BLSfNB/dJ8iJyn+dciy+bizbRKw+e
         3w/QQZmVsiO7DJuOLrwkbfgPSURmLlqJkj63iF3Olk3r6fxf+a1I0B+rjyIEzy12xdHU
         OagXZ7y1nKwC88PSvSPQi3om2ei9UwYOz1jgdaI6377FBdohTja9sNgs//3l6IcYU2MM
         S07Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjzZUtHK6yzP1cBAiy4HqB1q0/0fp88PC1RgeBj5Hy839qfoddl6Mj86m8SmS1O0Rk81TRccdnMepQlhAd@vger.kernel.org
X-Gm-Message-State: AOJu0YwRBYZnrlAfbmQBNPldTLJ9uCsbM8TI5Gddb5cti/Z0qSg5T7cB
	7SArS9rifM/R/FaI1HGWT2HnZpjf5ei20d3Vua6R/RU11DN5vtZD1nztrnQcN0Kv6EhfWLs02/B
	zr+XunQ==
X-Gm-Gg: ASbGncvRGrMIyLs1pdPhy/EytBHXbbJE3vbxF0LBnvJvT/nLjk3PvlLs1s9WeoirPW4
	baDusyepvt+TsD3wcuXkKxIzr7QJcXgHeJvz3bl5cw5jNC8asFKDCRyzwTWgA+eKNBJNRlwK+7v
	AJeUOCHuEnTqkI3QpurHQVLMB20Pezjylm4V/EbV/xbjSL25gWtozxCotEPzaHVOo5cXRS9q1S1
	ODS9Q/B/bLtbtU4sDZrzsos4/LDSwqJL8kNeaxSurTJYwRyYZK4qrdXiFCiSlF2zvRn0Ah0jVeE
	+xAhGgySNXom1yo0pz81v65t
X-Google-Smtp-Source: AGHT+IEh55KMHUwb0bblLukrvJB40cbEHqPc1QyazwklWwXDRj6iC34/TY8AJ5t9K8galMTwxOCrSw==
X-Received: by 2002:a17:907:9703:b0:a9a:4e7d:b0a1 with SMTP id a640c23a62f3a-aa509bff744mr636705566b.49.1732382351866;
        Sat, 23 Nov 2024 09:19:11 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5372002aasm87254466b.66.2024.11.23.09.19.10
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2024 09:19:11 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5cfcd99846fso4099601a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 23 Nov 2024 09:19:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXlOul/bUuTGwIO/KIAi/SrRN6gAIXcPIrz9z4VmW4LI74KsJm6QZVUtTApgnHPmF9NUZ6/dpr4SpdQoZJB@vger.kernel.org
X-Received: by 2002:a17:906:2191:b0:aa5:cad:eb08 with SMTP id
 a640c23a62f3a-aa50cadec25mr539778766b.39.1732382350257; Sat, 23 Nov 2024
 09:19:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122095746.198762-1-amir73il@gmail.com> <CAHk-=wg_Hbtk1oeghodpDMc5Pq24x=aaihBHedfubyCXbntEMw@mail.gmail.com>
 <CAHk-=wgLSHFvUhf7J5aJuuWpkW7vayoHjmtbnY1HZZvT361uxA@mail.gmail.com> <20241123061407.GR3387508@ZenIV>
In-Reply-To: <20241123061407.GR3387508@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 23 Nov 2024 09:18:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiWYnr+V1-RbgvxkuD6uSQUJWGuounVMXThyH8jJ49c2w@mail.gmail.com>
Message-ID: <CAHk-=wiWYnr+V1-RbgvxkuD6uSQUJWGuounVMXThyH8jJ49c2w@mail.gmail.com>
Subject: Re: [GIT PULL] overlayfs updates for 6.13
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Nov 2024 at 22:14, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Nov 22, 2024 at 10:09:04PM -0800, Linus Torvalds wrote:
>
> >  (a) add a new "dup_cred()" helper
> >
> >     /* Get the cred without clearing the 'non_rcu' flag */
> >     const struct cred *dup_cred(const struct cred *cred)
> >     { get_new_cred((struct cred *)cred); return cred; }
>
> Umm...  Something like hold_cred() might be better - dup usually
> implies copying an object...

Ack. "dup" is clearly a horrible name, and I'm ashamed and properly chastised.

               Linus
