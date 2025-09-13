Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11662DC796
	for <linux-unionfs@vger.kernel.org>; Sat, 13 Sep 2025 04:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737322; cv=none; b=bTD7lR6ahLZp+Smw8vwesI9yjLGpytpJq/WTW5yohhTVQOaTZ1EO4L32tNPKr/qj7paxoA4oMlGEEzUKHXAyabxvAsBg44wkGiBreXlgzHNJoFQVzMYjDYfzB+wyWzG6mcCi8+gtFSwOdFej/TEbs60alNQGQA2c4xh0n8coLdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737322; c=relaxed/simple;
	bh=uRhPeUlqyAStsXwoFa9GR0+NRKe2mAQp2rqLkRRGLS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CZ6kFx5FdEvY7z4aeld9KFQ15Bvvk+dOeF+SngGxWwVXHGsxa8he1tcRGtVTqSG+wrshvuiarwcen7m6D6PnqodbIQdBbU1qDp2ZbNgVsZU2KeQ8R5SFrrC+vkUiD9a4j+e06W9lJlFHKW9Xt2OcKUWXI4dbKCFzPa6cRvK8R1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bKLYFGqO; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKLYFGqO"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61cc281171cso4584540a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Sep 2025 21:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757737319; x=1758342119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCzrcIcSARHxmGL/M4lqmRXldDtZV569bzzYZk5Ve0s=;
        b=bKLYFGqOhAK36EE2Mo+5JBP+TtjEO2gEwou7nmzHeWAEfoI2z8OIUtxiN54LpCQxA+
         jhr2MpNQtwBI5Pba60ZmOIJxqk/aavywzwnMKb1ZF8LIGbsbMoX8yDqCkGNsfpd2LTPo
         R1d4/1SIyYemS2ed0oTzvtNG+Pxfo//Yjtne1cKMra+MsFMZQBv8KkT4n6SRLYTXNUrN
         yJfhVsC2cqGqnCmhdVXgV/tjzivXEWRrAYrMUquPIDS31skvNLD/+B8c4CiiXZU8p/KR
         0739Tzge4Ad4lnzmbbSmdH+VAVNpOKfUWshAUfCaZM/ya8L4KwtWR5Z44XtLQIsUnRyk
         1zJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757737319; x=1758342119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCzrcIcSARHxmGL/M4lqmRXldDtZV569bzzYZk5Ve0s=;
        b=tGlpGPtJUGHxqx0tG3vLRt6VQgf3pYnbVGSvycGUDN/64apedZQhr1qT0+vOFkqe9V
         jNICoXoFTBe+iMYl3u781GM7a9/tR6Ois6dEzbUKm2ye0ZslHRlZmkgh8CBX+l0fD0Gj
         tqb7up46geQuBSQ83Onx2V1LrmuZyGx7j0l5z1aJFoIMsNliybkFTYmoS7/8TmysjEtT
         zMQfBxY6qp6iWBmMATy9PbUuxY2F766IqiROH62VEgO12F7Np0KQWqlqUb+CKWMDH79h
         yBTQVifIfC/jAeqNkIzMGD5+iLD7iuNMjkLAA4xhPAvW0MNMQIA1XyKCL1D6xrmI2JvN
         Y00A==
X-Gm-Message-State: AOJu0YxzEfjZSIKLjvlQE1aVib5vASM9zuwkuWUnQ9ZKrq4M4nZWNZL0
	cmdbXlcm4EvaWCY/CUFKKHe6achBOnk0NRHVDtlmXZtZ/5umP0vPL8XsDxKoWEVk7XY3uReZK4B
	C1Yn8qSr/W2qOCiQdmaWxE+eR5A/u5fM=
X-Gm-Gg: ASbGncsazjxG+Q891ErBZZ0JM8SilZGJAmoGsircdILowUa2P994EsLZkz200+GBfiD
	IJlkOaMGD9pRLuH6NGZEyN/I4+cBbXg3IRHYSiDyUzegOkCGQepIbnRJaF7OKp1stQSRbEhYGZn
	jPr+27+kNbgJbzhU6SZuBIvsIx0rVbFGyygom0Bfx+B7TWkz1Bi6n5v812bZgvEY79KzbqSVhMG
	GIZkWc=
X-Google-Smtp-Source: AGHT+IFepm1FbWcP+64RKyihgwcpbWxnOUU+/c2gMUIZRhSEOrX4dBwblM9Q9Ccja2smHCVu7RRfgMLCNcfIzhRlUms=
X-Received: by 2002:a05:6402:4548:b0:62d:bfd:b3af with SMTP id
 4fb4d7f45d1cf-62ed8301f7emr4732078a12.27.1757737318699; Fri, 12 Sep 2025
 21:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <87plbvadpw.fsf@slackpad.slackpad.domain>
In-Reply-To: <87plbvadpw.fsf@slackpad.slackpad.domain>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 13 Sep 2025 06:21:47 +0200
X-Gm-Features: Ac12FXw3QROKXvTkPTrtypnOmA0T8Ycg59W6gzc0DO-rNPnsnMxQSw2zB8IieCE
Message-ID: <CAOQ4uxiXXz6rev8KESgeBamy-EJAm2-Yan-721SPp2PMtb6ttw@mail.gmail.com>
Subject: Re: Support for including nested mountpoints in overlay?
To: Nicholas Hubbard <nicholashubbard@posteo.net>
Cc: linux-unionfs@vger.kernel.org, Antonio SJ Musumeci <trapexit@spawn.link>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 5:55=E2=80=AFPM Nicholas Hubbard
<nicholashubbard@posteo.net> wrote:
>
> Hello everybody,
>
> I have just started working with overlayfs, and ran into a problem. Speci=
fically
> I wanted to overlay the root of my filesystem with a command like the fol=
lowing:
>
> # mount -t overlay overlay -o lowerdir=3D/,upperdir=3D./tmp-upper,workdir=
=3D./tmp-work ./merged
>
> However, I noticed that my nested btrfs subvolumes and boot partition wer=
e not
> included in ./merged. I quickly learned though that you could have multip=
le
> lowerdirs. So next I tried the following command (I have a nested btrfs s=
ubvolume
> at /home, and my boot partition mounted at /boot):
>
> # mount -t overlay overlay -o lowerdir=3D/:/home:/boot,upperdir=3D./tmp-u=
pper,workdir=3D./tmp-work ./merged
>
> I was expecting that now I would have (for example) the following directo=
ries:
>
> ./merged/home/$USER
> ./merged/boot/grub
>
> However I instead had:
>
> ./merged/$USER
> ./merged/grub
>
> Which shows that all the lowerdirs are placed right at the root of the me=
rgedir.
>
> So I have two questions.
>
> 1. Is there a (easy) way say "I want to include all nested mountpoints in=
to the
>    overlay in their same directories"?

No. not in general. but maybe specifically for btrfs subvolumes
you can do it because they are all accessible via the btrfs root mount.

If all your lower dirs are on the same btrfs filesystem
and the subvolumes are also accessible via some path is root mount
(e.g. /subvols), then something like may work for you:

mount -t overlay overlay -o
lowerdir=3D/,upperdir=3D./tmp-upper,workdir=3D./tmp-work ./merged

rmdir ./merged/home
rmdir ./merged/boot
mv ./merged/subvols/home ./merged/home
mv ./merged/subvols/boot ./merged/boot

Never tried it with btrfs subvols, so it may not work.

> 2. If there is not a (easy) way to do this, do you think it would be both=
 feasible
>    and useful to add such a feature?

The general case of "include all nested mountpoints" is just way too far of=
f
from the current overlayfs design. Too hard to explain why.

I suggest that you look at FUSE alternatives like
https://github.com/trapexit/mergerfs

Not sure if mergerfs supports this use case, but I think a userspace
union fs is in a better position to add support to this if desired.

Thanks,
Amir.
