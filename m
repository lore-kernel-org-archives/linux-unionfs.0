Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794482492;
	b=PsfCg9KDodkk5j2aTe1BclIPN/Pxkyn0KNf7fsLa8/FCeAlUx7dm9DmQl4ISNS29N+Jl
	 oghxduu7LbcRijgqtNNMdYWVjHz4JDO8TdkvSiu0YvA/GDnMwHpu3MjKQHRiMwxhUbKT8
	 puWNsqM3A4P9vKNGNJDcZtfcS6WnfuFYq6/GbivhKhbkHCpUm/llhpMGfjsI8u1zRVEVy
	 5W30KAbWj/6Y4PatkE03NNDSCdMVhdgqog4Gr48ZLLSZbEWFiLA0cH2BT9MVnV7b1hpx4
	 6gnMRrykfSj9tr/c2rsT2R0xJ/mGZNEVUgp/tg/yiimXM2srZP5dvND09ScuCoSoY9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794482492;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xVzJ+69NlJ0dFEV/ZAMaiMuV0Wc51oFEXKky6ggcO9w=;
	b=BTab8qjcsiigCKQsF12vYxkYLvEYx+k2HynQZSvXNLUsgO6fO6OdwVLv0EDoobBziLoC
	 HVAx6b2zTJyWENodgeyXWi+pgXIekXxR9uooMxMwLqdVovjFHZHSl4nUojhhWMQHvSatr
	 /BUC9I/8TpwlSKVyMv+LGso3fvHB2WYIDVjGgCGNs/jQrvzPPRaEt7JOM9SBhMqthYChr
	 dd3PUmVveWIt3HXMd3/h+FfP4MWk0L9pc/g7D0fkj974ZvxnivwiyMmVPQRHdFeKyEjk4
	 fMEO2OmLNdVkBxhxZqP1smSOOidE6Sghz7LtOKCoyZsl4P1v9XW3xPg6rWIJLhauT0A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tLgcIv3K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5B560A3838
	for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 11:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA5B560A3838
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tLgcIv3K
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b167ffd132so1190631a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Nov 2026 03:21:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794482489; cv=none;
        d=google.com; s=arc-20260327;
        b=Z+B5EznoFeUQvTsL09V6R01x7xCq8wzgUz1VKvRcpCa9GCXynBhIfpxLZ0x+nqHsmd
         Bmdu28p3X5dMC3Ciz3rnEyjtjGgdwkBpCZn+qHmvp5P0ghhQLzD72DAm7KAcx45ULk+A
         NPFPQnkanx+GU8lNDmvpUlL4fmCCeZzlLIItJ7YecEBMgsQ5CNUv0+kpIgdjQUZZ4nD1
         i6qaFFGeGwcxLtKqrgWr7suD8ogpJZuqHfK0HnT02zrZrF8HhDbfHFfOK0w92BkIWDTC
         +RCOwMLNtrtGYfllDS9MC5nvmSlseVng3XY4PU6jKlLCAj5ftQEi83+4XzcaHYUn+7o6
         /61g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xVzJ+69NlJ0dFEV/ZAMaiMuV0Wc51oFEXKky6ggcO9w=;
        fh=oiQHXvI74nuVAqsbrpGjY3xIHuAdVCnkuIzUX0NQGRI=;
        b=CbVDd6BrtwwCkS1cmVDaedDXPAD3rwI7SzHG6VUDAtkrd+ZBsb90fQhnD2bAlsZvIZ
         NhBYVN9Je2mP6iotr+kswau0qijXohmXIPWhR/VhdP3FnIGDeHxSB10N70sQJrriN4mg
         tjthoL38bgem7EJb7Exs8HOgMxCyYAvjJtRTYwev/ewxCitrpv3nBjgfwUjUyF/TZpKT
         7g2sNX/2haSAqnmCfxgJWofgOd6dVQxZZ0zh1WPKig0hJfClg0TWuslo0fygBj7x4itZ
         M3B90+zuHOOtzO+VkRFGLYtmynm6HXXBgwTCqWxdWlh9XOslEhMljx4dJkDqNsgRYpUb
         y4Cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794482489; x=1795087289; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xVzJ+69NlJ0dFEV/ZAMaiMuV0Wc51oFEXKky6ggcO9w=;
        b=tLgcIv3KH49q5tDfuo0N/f91QbozTfalhC7HnR0ffDEcs9PG3mWFT9A/pN3iTxV/0+
         lwZLc0G6AdAAVFxnMEUQRYpXNjwfbi5nHzD0RVqILjr75+CtHRHaSmQmzpNE2FieZDi/
         9DYxBNLexlW041BcppV9UWax9nzZL9krgnjbaehW4shRRZ+w74vuSN7A+C6J1pEaah70
         4ddylQayEXMF5xGsKyODVmBkYodghzKqb5o80wY5k4ophY7zcmgg2z1T7cG1fkA3GRdE
         4QYjW7g6Ew/AejuUm3vkQVFXyuB9D1p9VL/uz7Kq5peJUaeRZ88ViqfkPc/An3nDe6o4
         kqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794482489; x=1795087289;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xVzJ+69NlJ0dFEV/ZAMaiMuV0Wc51oFEXKky6ggcO9w=;
        b=0sotk7nQUTHQnvaD2cj/co0k5+85qWqXce3dXKYqv2sj63a+yXXxaBqOUC3TMgn3LZ
         WHfRUbkL9dKQCddrqEhfjZU7dfPiuZQ/uE9U8WMsrFpg/TLrCVSCp9O+pqQMhw7izSfo
         dctlU+wPvxF8PsgDJyecx6x4HzfMd4zlFcw513A+dNVlEx/ZSh44CNE8PI0J4bKQkHYd
         j05g3/Ay+sd2lw7kkHWdCK1ugf9YaVS2O+MVEJ2Bor5NlPcBNX5GQDw5FtCVgf3aAwBP
         nyGbjPdzZ5K3cpuz1NQWtz8oqaxoJhGiifb+Ce/00u3pW2fc6gq3vd5m0WIP4CyVSK4G
         ZuOg==
X-Forwarded-Encrypted: i=1; AL+hErE/GdHqMqeyrWOpUDItXNgY+0/WKo4nD7L/O5KLs1XXi+Gwxqni955d2lMygABK3ztk4CE/5HboVJh2gWEk@vger.kernel.org
X-Gm-Message-State: APuU4Z/rdDBvQJqqgHI+42rQw5mdCNodC3uJfR9PZ5hoRkQ5qfrvX5aM
	bXrCTGEGdjs28ZBtMXPGt1jBlf5Et2asvKnwLOKs5XTyHv4ZKKjQArMtRORcRShL0fRPLKOiBVr
	L/ryOldeblWa30tD+p5SzUQDrhR/T1f4=
X-Gm-Gg: AYBFou0f+gOQST6agGg2wvzL+WmZg9hrMTfs5bjzA5DTcaSQKFvET/018vuRA/5Gd7a
	v6S5jJ7kFmF6ZKq38MD9uH3Bsv8dPNBfDaKgqtolKgJ+4/q1X3pHQIV/BNN3h91ispie+WPIDYp
	RFo4p9uG7nnvZ0fpCKUGF9fC52VJS8660YZANrqXLwWxURPLFKM593iq1/o6g6SYQTHN8rfeRFE
	KhfAUIY7kbdZKKktogiycJUb0JnRIhwze127MspHzpBX35rCxZ4rXJlXSpKPiPJR6erygOW0HPX
	EFTpGaCXYsrlcDVZ2Ad0BGZveu8ByXR4S03WnTDZ34RwCY4PcsZ7sWbmVRvk6XScqvWXmFZaYqO
	v4IvG7iA/BUOJ2mvMpf83mqyf1Pw8R1vbUdpmPO41HcXcruJWSLIyYSHnuv+4m3unqJwUuw==
X-Received: by 2002:a05:6402:22ca:b0:6b4:21f6:ff48 with SMTP id
 4fb4d7f45d1cf-6b7773418b6mr3086397a12.3.1794482489207; Thu, 12 Nov 2026
 03:21:29 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112-ovl013-hlink-v1-1-4bf8f44050e9@samsung.com>
In-Reply-To: <20261112-ovl013-hlink-v1-1-4bf8f44050e9@samsung.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 12 Nov 2026 12:21:17 +0100
X-Gm-Features: AclHuK-odbIHNo7lj8WqJ9qO3D9MVEnGnT5G78LAnEyvlajdzz8WjRKJksmbCQQ
Message-ID: <CAOQ4uxiX9wiHXcyvUfi15PDHoucEiBGVqMjtvB=a-b3k7-hyUw@mail.gmail.com>
Subject: Re: [PATCH] overlay: test d_ino of hard links in an impure dir
To: daejun7.park@samsung.com
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 4:58=E2=80=AFAM Daejun Park via B4 Relay
<devnull+daejun7.park.samsung.com@kernel.org> wrote:
>
> From: Daejun Park <daejun7.park@samsung.com>
>
> Linking a file with copy up origin into a non-merge impure dir does
> not bump the dir version. readdir then reuses the impure dir cache
> built before the link. The new link is not in that cache. readdir
> reports its upper inode number as d_ino instead of st_ino.
>
> The test builds the cache, then links two files with origin into the
> dir: one from the dir itself and one from the overlay root. It checks
> that readdir finds each new link by its st_ino.
>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Thanks for the test!

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
> On the overlayfs ovl-fixes branch (0d5e729c515f) with default overlay
> mount options, the test fails in 3 of 3 runs on ext4 and on xfs. With
> the kernel patch "ovl: bump the impure dir version when linking a file
> with origin", it passes in 3 of 3 runs on each.
> ---
>  tests/overlay/013     | 58 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/overlay/013.out |  2 ++
>  2 files changed, 60 insertions(+)
>
> diff --git a/tests/overlay/013 b/tests/overlay/013
> new file mode 100755
> index 00000000..bc65076c
> --- /dev/null
> +++ b/tests/overlay/013
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Samsung Electronics. All Rights Reserved.
> +#
> +# FS QA Test 013
> +#
> +# Test consistent d_ino of hard links in an impure dir.
> +#
> +# Overlayfs caches the d_ino of the entries with a copy up origin in a
> +# non-merge impure dir. Linking a file with copy up origin into the dir
> +# must invalidate that cache, so that readdir reports the new link with
> +# the same inode number as stat.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick copyup hardlink
> +
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +       "ovl: bump the impure dir version when linking a file with origin=
"
> +
> +_require_scratch
> +_require_test_program "t_dir_type"
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +mkdir -p $lowerdir
> +touch $lowerdir/foo $lowerdir/bar
> +
> +_scratch_mount
> +
> +impure_dir=3D$SCRATCH_MNT/impure_dir
> +mkdir $impure_dir
> +
> +# Expect readdir of $impure_dir to find <name> by the st_ino of <name>
> +check_d_ino()
> +{
> +       local name=3D$1
> +       local ino=3D$(stat -c '%i' $impure_dir/$name)
> +
> +       $here/src/t_dir_type $impure_dir $ino | grep -q "^$name f$" || \
> +               echo "readdir d_ino of $name does not match st_ino $ino"
> +}
> +
> +# Copy up foo and link it into the pure upper dir, which makes the dir
> +# impure. Then read the dir, so its impure entries get cached.
> +ln $SCRATCH_MNT/foo $impure_dir/foo
> +check_d_ino foo
> +
> +# Link foo again inside the dir
> +ln $impure_dir/foo $impure_dir/foo_link
> +check_d_ino foo_link
> +
> +# Copy up bar and link it into the dir
> +ln $SCRATCH_MNT/bar $impure_dir/bar
> +check_d_ino bar
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/overlay/013.out b/tests/overlay/013.out
> new file mode 100644
> index 00000000..3e66423b
> --- /dev/null
> +++ b/tests/overlay/013.out
> @@ -0,0 +1,2 @@
> +QA output created by 013
> +Silence is golden
>
> ---
> base-commit: 71641219a506ac62bfa231592394265ca812670e
> change-id: 20261112-ovl013-hlink-7cf74a775d23
>
> Best regards,
> --
> Daejun Park <daejun7.park@samsung.com>
>
>
