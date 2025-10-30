Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629936CA7C
	for <linux-unionfs@vger.kernel.org>; Thu, 30 Oct 2025 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761846885; cv=none; b=MrBU8AlYsHveSDoU1X93dVZKRYF6K2dFt6+rCwKeC6ugVyI4k9ZeQAwmmMDcz/+WLOU0x9J/51chwjMh7loWPYfW4m6cErL20LSr9LUC3POmzYbuINrIHq5Qtf6yxllH9Dt7qtAYhnffyou+8zf8wKXrw8VOwRjyt4bnxhgbsTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761846885; c=relaxed/simple;
	bh=nXxBkZGVZtzRg1B3Eyts+wCNuzoBAwe/J70dIjGd/gY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sXF17hYt20GVlqHRy7VcisnxzGkTUzPvDeDCIhZ8YFSyYWzKSJ1RuPxba7Sc46qAlTjYxlYiJ7PUw3ZLFNBPsmZq6F5EopranDIEDp5mziT0FLNqcL+zPJbT1fkpkSWOe/kdnYzTQGQzYy/pHA6bIGyikOjamsmAOY02IhMGiJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NSgFjTfs; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSgFjTfs"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4771b03267bso9759555e9.0
        for <linux-unionfs@vger.kernel.org>; Thu, 30 Oct 2025 10:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761846881; x=1762451681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXxBkZGVZtzRg1B3Eyts+wCNuzoBAwe/J70dIjGd/gY=;
        b=NSgFjTfsoRN0LMvsFn2k/r9PljpSswXHafwwZgGr/jgadbj8a6vWdJkOL5spIlwEwt
         CUiAYpQxZtCgG4k5DwtlE2eEmR625KDbCsHJAwUref27rtqau8w9u5g0oV4Tybi0yd1L
         kcWFJbxrQnX6+wJ5XbwNa7w4HjQUr5pQMn4V7Iqg+KsvgKjef9a1vAwszJOQfnwj7GLU
         iBsffQlGr4znAiJXtXcy3YSZlZWPy+8KpleN9l/XG0YEjl/BJ6LJ/AcfCUd7VNCB37h2
         9/qGzwUMZW+ecbVAmun18ZOc/DvpvZfnXEi9j2NS2FEuj8eSnttUmyFHvRgFVNm5HcpY
         A/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761846881; x=1762451681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXxBkZGVZtzRg1B3Eyts+wCNuzoBAwe/J70dIjGd/gY=;
        b=C2FNtA3epdyQfIs7LHLBlDG7dXEYeERmQfjta99hTFZ6XEywwIBEewI0eZVUXKtwi4
         9jTw/dIHT1tG/BRsD0SY8au4bB1RDDPR3OqRk81voWmGkyJnk1pL0jcmbwQDFnTXzV7v
         EklkvaRkpIpx63PlnbE/7/r1F7KY4M1S7hfkxgVZ1wlKBvnoFqnE9GhrwNQrlN2k8nf2
         StgPRdv5sfydNU1He6H5BPm8kV6Z2dhC0nEKAXp0b38oVTIVopWYbCu1w1mktCaEjms+
         PdEhYTqCSLUs7HMoc4UTtEQUyfwhPSlfG0zAyeGWQvYNf+91zvAXaNbPtpkMSCgSorI8
         WFjQ==
X-Gm-Message-State: AOJu0YzHuYOfDy9p+Tab7FUMU0nFSXzz37NBJguL9HEaiydR8RchMQ4I
	30UQGxCOMNpjb7hTah165fAGeORh9y8aZoozPdvwtOwxBSln9ip4ltvLqyrhxR7yLLDa98NARfH
	Xi0w4mfMvCHwLKT1VbU7e0q9Fmp9FX9ENRgBDUk8ulA==
X-Gm-Gg: ASbGnctsWfVpe3NZGzuLkJeNYs2Oq26gNtBaoxQPBNr5lQYOSyTdXOlK7+Iv5S23Tlm
	Hqb26vXC8RGCumwp1s3SMXffn0DD5SMGR3TTzXRpHObvQMdtOtMGTQBvDhHr7QQw83aI8AtEHNJ
	K6kcXxNEy2dcuLQrhrjDaZE5udCfeZvRJtEwRqGdRKh8oywaH2RNx3a5yyuLN5fJFe78bHGbOFG
	TJkD+/fWuZ9bcH+uhmOSNImrewKR4XHA/RXRskuG5zEZj90ix04PFG1B5o+72rgJoOpLtCLerBt
	0k9whGdAUdfcja0BBQ==
X-Google-Smtp-Source: AGHT+IGBm82dcuK1yFNIQ+ie9YO0cYMC1oz/+KVi3j3KwG2G0h5jn16JQSMesGNKvXMjfkuqgYZqlYed8dsIsbXwDbA=
X-Received: by 2002:a05:600c:c172:b0:45d:d8d6:7fcc with SMTP id
 5b1f17b1804b1-4773088ffe3mr4951235e9.27.1761846881260; Thu, 30 Oct 2025
 10:54:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPfD7wmf=ks9WEgAKdLWsn1igWG+v4bYsM=+ATat_0BZ+djaOA@mail.gmail.com>
In-Reply-To: <CAPfD7wmf=ks9WEgAKdLWsn1igWG+v4bYsM=+ATat_0BZ+djaOA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 30 Oct 2025 18:54:29 +0100
X-Gm-Features: AWmQ_bk7Rr_1awBfFlzNSESHO9nSTxcy4KWYTuqLllFu4N0WRBY80Gktid4l_74
Message-ID: <CAOQ4uxhbdE-HE5wX2nJ3oFy++BJqSWctwaoXGnk=-1hTp8VOvg@mail.gmail.com>
Subject: Re: overlayfs - vaild to mount mergedir over lowerdir?
To: Mark Corbin <mcorbin@lunarenergy.com>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 6:26=E2=80=AFPM Mark Corbin <mcorbin@lunarenergy.co=
m> wrote:
>
> Hello
>
> Is it valid/safe to mount an overlayfs mergedir over the lowerdir?
>
> The Yocto/OE mount-copybind script does exactly that:
>
> overlay on /srv type overlay
> (rw,relatime,lowerdir=3D/srv,upperdir=3D/var/volatile/srv,workdir=3D/var/=
vola
> tile/.srv-work)
>
> I wanted to do something similar with a read-only /etc where the
> merged /etc is mounted on /etc, e.g.
> mount -v -t overlay overlay -o
> lowerdir=3D/etc,upperdir=3D/data/etc,workdir=3D/data/etc-work /etc
>
> Any issues or recommendations?

None that I can think of.
Overlayfs has no problem with that.
It gets a reference to the lowerdir object at mount time *before*
attaching itself to the mount point and that's it.

Thanks,
Amir.
