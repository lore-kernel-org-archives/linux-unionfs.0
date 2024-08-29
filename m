Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45875149C5B
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Aug 2024 06:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724913652; cv=none; b=auZwlYareQzS+JcgLyBFgvag8yCes4Mub6kxdEBKeCFTRNFuG2Tz0wmFfGf2uTGv74B4Kngd2tR73bYmaToazo0YRs6cEKckXJD63U9Ktjg5bm7C+ZGXTonDhn1LSkwCDlfJSYBS+lJMh0JJeEyQ3eoJwEOp32efZYbE4F/Jjk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724913652; c=relaxed/simple;
	bh=rodF86ggmRdjhgulXg/WNNqk8Uul0wI1qAFsf3jmxHM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c6cVVoB85Sj5UDxzlCKL0Pqh6i8wmxXU5GyK2kwQUyJEfgCgqIlGsgjrbqj2azsRglbRrPNNMdB5pWFr8u7GJwBjTqP8aewoO+6B2Heilo+Qlt7ag4LJ9SfAfxbqKIa+WPOO3hBS0v6RCRk5Q5NdYUo+NnOa9XT608IK39msmeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JpgKoibj; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpgKoibj"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a35eff1d06so20918785a.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Aug 2024 23:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724913650; x=1725518450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rodF86ggmRdjhgulXg/WNNqk8Uul0wI1qAFsf3jmxHM=;
        b=JpgKoibjLiqfQ/Od+FSB3JirzghR7/XsTSks5/KasV+gShk9ynKOg1nAPhJdBMbrR6
         RXOSix4GTka1mGdrpbPLtxHzjJF6Z9HTvgoKZuDecHExzE+h+YjZ1/UezdffRv5s2iLI
         HCGyX9OAfMkXR/Cu95M8idEOxu//8Q64Unu+pSW0dF4i9CJXp8c72QauthreQyuLnh03
         J0tP/2t8+1tPe9xB0sWKf/lDK/P9jSpm+SRaiBOjWbwg563p5MPYUicb5bBrbJYT+AZc
         LvlYuUQqGz7o/X0+0GDu0iOqUDsjxJ8zVi8h5JKaXL2SxtiE6eZxcQme3tJHBvdQmVV9
         qB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724913650; x=1725518450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rodF86ggmRdjhgulXg/WNNqk8Uul0wI1qAFsf3jmxHM=;
        b=rCdf5tHlZE5XRD0IOXK7pLtOzJ31zXTVtc5C13zwjpDa2l/RU0ViN01cMnNPPcFmX2
         dbAGZ38zegABOA4/v1OquzyYowteYww6Nr0ZFEbxnfZ0r29uhxEZJdBBeJ/0YUHt4/jF
         0IFHJjm4pbfpqAyAAGcuNPGODrJh6xtiHQDBwagzAvMozy0F+ekJuJ6qDtie9dU9p1sN
         KyJXRuIsHASnJOAaO8DyEbbh0g0cEAOybHBtb94RezRTiaIjmsppLaW9E/g2sKN/rCi8
         B2zrQvYCDhxdoJR0liXxEUDk1GncFvpAOs+ME2XRoE5dbAnytggVa3CLsiJg8cV+k5IB
         fN5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUd76vkHL+UquD5ddBDIPOWO5QJDfPPxnYT+ZSGu/gmOrHeZ7i2lFJMnxhN3okhzKzrhwK6E8cFz41FMRw6@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe/WaJ0+ttWkttZZUcxwGjReuIw00K27wWsrrQ+hE1Yjo2Oy6X
	m7IbHMKXr/1XnbOQEBiuyks7K4QNW6qJhnne15AGM6DejBEtjGb1BMxTIqB0PY4fG6h3zSJ8Ei9
	JlaHvUyPIMbU5SfpcnLm5QRFA1vc=
X-Google-Smtp-Source: AGHT+IGg7sib78ymV+JzIf1LS3+5XkugLAXale6/vXXrfhk4bozcSzXBKEZRWBBtnPnJ7L4AAkgu8lNTGyupIy/JH00=
X-Received: by 2002:a05:620a:404e:b0:79f:947:8915 with SMTP id
 af79cd13be357-7a8041ce426mr207011185a.29.1724913650073; Wed, 28 Aug 2024
 23:40:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828120514.3695742-1-lihongbo22@huawei.com>
 <CAOQ4uxiBsGpEb3FUmp1Bn_9ch1Xa1aAqfpJa0qwVnN=23Mcfag@mail.gmail.com> <9bdc3c6b-095a-4cae-bb21-69d1c7706c0b@huawei.com>
In-Reply-To: <9bdc3c6b-095a-4cae-bb21-69d1c7706c0b@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Aug 2024 08:40:37 +0200
Message-ID: <CAOQ4uxhyqU2LMxf=SN7Jo97MUXE+CZ7K7+cvy6QjQiKfXwQOzg@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: obtain fs magic from superblock
To: Hongbo Li <lihongbo22@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 3:25=E2=80=AFAM Hongbo Li <lihongbo22@huawei.com> w=
rote:
>
>
>
> On 2024/8/28 23:17, Amir Goldstein wrote:
> > On Wed, Aug 28, 2024 at 1:57=E2=80=AFPM Hongbo Li <lihongbo22@huawei.co=
m> wrote:
> >>
> >> The sb->s_magic holds the file system magic, we can use
> >> this to avoid use file system magic macro directly.
> >
> > That we can do something, does not mean that we need to do it.
> > I don't see any benefit in this patch.
> > Please explain.
> Just avoid using the macro directly.
>
> This kind of macro definition is like a magic number; once it changes,
> it will affect a large amount of code.
>

As long as sb->s_magic is initialized in exactly the same way,
this argument is moot IMO.

If there comes a time where sb->s_magic would be filled from
persistent storage then this code would make sense.

Thanks,
Amir.
