Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793524219;
	b=LYgA5mU5ZdsXKvNEvPneYuzSGsJUcNSK71UYIISA+2KKXjdtCdGUYJT0Cfq4TrDFmQwm
	 92hFZJNxwbn/Xzzs8jX8UVzElQSqf4Qkf5cs6WlQh85LBAOLjz9J32gXuPwxfPgB2bW1h
	 1NbYcWuQCEIcDEH+7Pa4yGioGZ7Gs+N3XCUpFU345XNNjVqPPu6jqvMGp43CM86o97tQd
	 2TC0L7/Uhii2iKq16UrMKAgxnDJOCkHi0G5/5+vB+niNMIfbkh8D3dVLbt4du+D831mCb
	 F/2yFTFEatiDrjjDquKDZk0T2rd346u8omury7KBUCEOU/b6oWpcCtTAb4B+mfN4FrA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793524219;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=gTTKto2VYMGcWkyKED75nk6cPku1k/MvJQT0NXCO8iY=;
	b=ungC4wsgtH9YMUOTA0l0b5nZdNPizxMfg23noMxv13Kvo3Bjb20NAsCTHiqHOk2GtAlo
	 dnLdwHP1ZKDIWqpaV7VDcagMOmmxiok+ircgN9mDQPS0m2llP68Zx8e3OpubNNc4jn2FQ
	 /5IzIcPC3ZTlqJfhSPMhvrx41Uxj8P7tyb+UHN5xSFWjaGlDWUaUMutUlEXrcH3Fo/zHw
	 sLoDtKYm/7MWvBKUAW1lvpXFP/W/DO8CbCPW798aIAvW8+ISL8eBCceniowEfhQe2K3LQ
	 2mUGypHZq0qnaHT3vkApAJ9FVDyYNAq/3WEGZ69PdCIyJtjUaUnOsMWxfd1OVwoaUPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W1xE5kE1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94751606A325
	for <linux-unionfs@vger.kernel.org>; Sun,  1 Nov 2026 09:10:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94751606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W1xE5kE1
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b47c1a3c74so2695941a12.3
        for <linux-unionfs@vger.kernel.org>; Sun, 01 Nov 2026 01:10:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793524218; cv=none;
        d=google.com; s=arc-20260327;
        b=HdGP2/HzKJLPWRIEjhosKF8xyBsdBHBKGHp0PigJsiEWCfCFmF5BoGgu70ywpVFVH1
         F2a7SB7woMHTuePXeXtgZk4ghxw95JSd7ONBn8voB3VU3fn2+pQdoPbyWpaT99lHQuCX
         Dhbs1S0SLIlZysNtktZhRFYQA8lURRaPI5cS0tQc1QhWf0oQMwx41CDxvaqCxVTbwVLO
         0fJIxVcZzG9t0yLyLxnv2CYc5b+NwRMySXtrtHFxSlcpaZR26Pfvaf93zb3Jk/P6EHVX
         pUsUZtWYbGSYvgo8779bleeNEHGrbilZ1jiQOkYryTItnt7Qkbf3GYAXp0NElqA+4BY3
         /VQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gTTKto2VYMGcWkyKED75nk6cPku1k/MvJQT0NXCO8iY=;
        fh=moIrCiLk2QKTxkBISUZEHWgJ6Qji07W+5kTuJl5nrzA=;
        b=cKVAQ4JGOAWqYgLTAAOu5aQp9v6ApRioA6z9B33Wt9L3AeNl4y6WBDezCJJBLqxAWF
         ErQZHuvWHPC5pYOU0ffmci6w/bKr65Cu+er4wdNXCPBZuizOj12qbfuWF5Ay3jxi3yaT
         szvcqaspmK7nvwEZRDxO7LbK+qNF8GSuiihNqPMoUEgozo+PNAMdEHarc/F8kkuKjsTH
         AnPOGx/jHRffqi30qj//I8deUNjflra3FgSQD+atHFkjd2MGhPMys+8mnpY4BsTTt+hg
         iZyzfWLMLXWoyO4XwMvD+CCI/ti1GCYG/Cqfkeprm2TCGrPIrNB6Xu87O1Hk41olxfY+
         l1gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793524218; x=1794129018; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gTTKto2VYMGcWkyKED75nk6cPku1k/MvJQT0NXCO8iY=;
        b=W1xE5kE1yvTxtrGtxbF284NwqGriHRpG6uq/6xGfMIbok8mvKGWzLK2cTyK/Gyl46O
         LRGHg0mYqn8Q8NAyCebF5ZsEZHcytP2q2oawhhHnlW/FmDhFfilqSCHyV9TO8QjdJFTY
         HgdA412d1v13iCBQEzjbwXMl+jUGf3yTYrFQWqh9raOGrQEXJ8Td8JxPdeMMfdC9KPha
         MEXw+0UuWm8X3lSUUsqZpO8gYTuoUSA6MRkocH4PsmB4QApJZNl6hUgAMmvHGPKrv943
         e5gWNcY398BSvwYLFhBzsmnK6oxUyj0+H7mA3fu130aPPTvn7HsvtQH7vB/NInh4wkry
         IPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793524218; x=1794129018;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gTTKto2VYMGcWkyKED75nk6cPku1k/MvJQT0NXCO8iY=;
        b=cyV0HRyZqS8mrUAs2bVvkgv7arQ8yTZkWOjNHtqxxU12ZG7IOZ4W4g/lpkkzQQ0FII
         t1IXEWvs3N3/Zga2KDC2YfPR29oA+kJa79Msfry0uTXPoaH5YX6JNaegG8JUx+x5OqOP
         RaPFgBBCAxib/iAVDVsIE0TM3jkTsF6jr76WZBbbyTnkBS545oPbCu0i7qUDczqRpS6n
         C/rCGR3qquqqAERVBP5kcFhhR4qKxpglia1tXWnGkbNpZLNb8Vfp/LuKJf4yOFoX3GRQ
         bUYHpeG3IwyHgKb+DPJnSjhUyFF5XlEkqk7AtGQoOcez/fAASS104cBcjUMHkTEvjlYK
         tL6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxS2muVFm/9cSzBqzsDuQQhX/+tZV/3xMnrR2lhvb/upwHaLae2HOI+WifHWGo1gZfktPgmf0LKFvhAPUag@vger.kernel.org
X-Gm-Message-State: AFq9FYI+c9zbBNfFGHoD3061/xkZqjtNYnC5hVRv7Clgq+LdrMnyF/hH
	PF5NG0s7uDsBHzvBNbjIyHOGUj1AAwcrntMwsmZ9SUP+xm4JbWfpwmkTxq6F0avgvPXLMyVaYC2
	ddBwBqVjCZgjD/wcXAGULZ44EnnK47Xw=
X-Gm-Gg: AYBFou2iQTWyuWIRHT0VbfUWAF9sl9ZxvMOZtRKqsEKw2AKFBcxlHjAcnlsVdvuaqVj
	ZLaIXBFT66DMVlf/Y3vufkpgvpI+OSc4BX657wMtAf+w/3Zjr0Ht/cRbcWvAugBYhawKLsprBpq
	7hYrJU9yXsDQxXkxzXhgVuEJoTJbFjH03gV6QjxI4TZkPKn0gV2EqkAz52TmMvukaTM37BbRZOi
	X2cQx8PxPSSoyavumqJgPaB1tpvaGPdkuk2vzoXggcIlq+k5lVWGNoJS7yHS8doeuZeMb5EjldP
	siALXtHuORbCIZylypWhL+jtCby7G51XWz96JZan2TRJSktCP2VcZst0s3JM5g1FJd7KoNx0ShN
	qyBfcIzoReE7o1+LmCUC8fUV81Jo7DjTZ05q1bfcMd8bxZjWL7iCIB4oGAayMK0tLnnGTGA==
X-Received: by 2002:a05:6402:2159:b0:6ac:bd53:d29a with SMTP id
 4fb4d7f45d1cf-6b4d3376eb5mr3101530a12.3.1793524217756; Sun, 01 Nov 2026
 01:10:17 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030113201.2921633-1-amir73il@gmail.com> <CAGEkeHekpqv5ncd8tFP2v-OAy-ujTf9_RBbed3dgmTTAQrsPzA@mail.gmail.com>
 <CAGEkeHeBcz2Atc7zz6u-Evd40+AOBtx9Ke+REthvTppxw-vpRQ@mail.gmail.com> <CAGEkeHfrqbdHW801cjJLu0-to31SkH0Fc2K+OnnjFcsbjVDAkw@mail.gmail.com>
In-Reply-To: <CAGEkeHfrqbdHW801cjJLu0-to31SkH0Fc2K+OnnjFcsbjVDAkw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 1 Nov 2026 10:10:06 +0100
X-Gm-Features: AclHuK9aXJweUY0FXmVj7ilj_KjKaqclW9Ic0-fv7P-Z1kCumLZn6CfgziHGTKk
Message-ID: <CAOQ4uxgVAxxQwvLhw-2M_A-hPd7ZCqw76_H=2p+3b5q+xQGQTw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Overlayfs casefold fixes
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 1, 2026 at 12:14=E2=80=AFAM Hungyu Lin <dennylin0707@gmail.com>=
 wrote:
>
> > On arm64/QEMU with ext4 and tmpfs, both tests fail on ovl-fixes
> > (1d27da7de3f7) and pass with the series applied.
>
> Based on the two fstests and the fsconfig reproducer reported above:
>
> Tested-by: Hungyu Lin <dennylin0707@gmail.com>
>

Thanks!

I will send them with the next PR.

Amir.
