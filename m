Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E4D289804;
	Thu, 12 Jun 2025 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749740993; cv=none; b=KtJWZE0nOTHCWI3DcvFWsYZUuvYmuMPxjqIkY9vUr/J8c+VORWXuMwf3Wc7IbtFLcycet7rDMW2Um7/BQHhXDK1AmPedNdb64EWPJXQC6lwMYLspdkftxyDdCY6YXHMPR/m1EA0qPonQmjdm5ofJbQkapZ9ympVdeAvAOmyKxgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749740993; c=relaxed/simple;
	bh=MoojmeoRF4o0D1mo63kTveZ/tYQdb3lhmx3lmiIHecU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UV/VrktrukkJZ2pLRK3XaCtuOfz5t2HrGMV3RrfGTsEzJ75ADsqyKV4CCouGBxzMJhP+iEkoriQOYcMR5mGAokqNa60ATqIwD5Y39qSmTjjKRjgpFuQdytp1hn7AO/bw+0yMzlaSu1UG7jMcrECbqa8SWn/fa8wPFUIBCb1S5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LZIhZgzh; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LZIhZgzh"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3137c2021a0so947385a91.3;
        Thu, 12 Jun 2025 08:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749740991; x=1750345791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yUuhnoKELMuM+rze0VXW6hHnp/ZBtRvDccMUHcPOHQ4=;
        b=LZIhZgzh/DEpFo7bVDu2+l0VypWAG4jN96YS/UrwocmhZ22j/mBqqIIXC4KI2YADfS
         hc4NrkiLWd875LYYF/PdCaQwtnOAEUtal+lpSyBcTj/zSubqfxGqJFiLKmim6uIvXvmg
         tq0ofCJGAGsRvOwQRqxB2JPiqiaWE7lNU8TtY4ZQpnXF2ndE8Bl7SkxdhN/xagikF1NX
         IvCgQ+jo/D8ddA1pOxNbAdrmvTC3XGC3VguzcxpuC4nRbPVzFKGg/B3TDq0g5fddoO+O
         DlEnBvK+diCCj0CS8YNEc490g6Uf2t/iDwlszyVeu4KH+MqP1S/hzYJIT1UsV/ZQ4Rfl
         i/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749740991; x=1750345791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yUuhnoKELMuM+rze0VXW6hHnp/ZBtRvDccMUHcPOHQ4=;
        b=Iht3JXc0XE9rl/B9WaZYOw9z8k5EGj83Rx23pm9fOZKhSGSw1LXs/DEdEd1nG/lVU9
         ZADuHnPzi9EAUqc83ceVlf1vPIetvI6lneSQ4MlfcPVxw3WpGIQPH61y2mdTKlLaz5p9
         KH2vZQp1P8gkAmOilusZO5bz97Xj1B6LAyKnMcTIG/QmX+IxaJp0DUetZtt8Eg2a2G/2
         LQFq53po9Pf0ISOkH1ic8lP7uKtLbug6k7ooukxbJjNVqmirMBkhMLfP1H/5QQk6TESX
         lJPGwIrSeb6B8u0QmsExJrsmSwd9O4vHuNtJlwdzmIEiWJrRwszAcigESPUar0/Ycj0R
         +PCA==
X-Forwarded-Encrypted: i=1; AJvYcCV90Yc2lIvs8we13XxOUG8gwWtjAzh9cKlRQ6ImYs0mfGz55yhqOXxaeJ4sgxxM8f2XcSUZtJo9Bgb+dQs=@vger.kernel.org, AJvYcCX5XcqsN3vzXb+ysT7uGv9FJRoH1b7Fylic7DyKnrxs1SXgp6koin7hqRnCRtp6qYmyxLG5stsKa8UuNxSeAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSnZmBbxbH3kHRB1CW9vYtee2vvHGqjCmd3co4phr9VjTl+9yI
	h2UwR2dboijOLiK8UbT5L6ZY+JTwFpw/o0v8Ctu047L9YaDk4KbPYoQi9oCLMRJZevM+GZ0iNbt
	aT9K38qawKD6EaMsLNqpRxq5+P6hMIqY=
X-Gm-Gg: ASbGncuOga+rr70BVFAKISMfcY1mAr50DrevIDxdwsPdj8yY3vzvRnUdUKNKy+AXn8s
	5i76SucNq10V+ChyKm5qf562/ludQno+XkZ/XGZ1+uLpJuy//Wuu++GItvmwORo7qKg5CLrQwBy
	LTaE4uoLbKj/ju1GZuRHJMn8SUgna/thdV3YHmHSwBYgY=
X-Google-Smtp-Source: AGHT+IGpCu/ny+HlAgnFhT+7qJZLmizvXxbjXDA0wRsEoawbaUXHksVEjxlmPIQOaKo8SUI2IttvsJ2Jab7iAef/vpw=
X-Received: by 2002:a17:90b:4d07:b0:311:c970:c9bc with SMTP id
 98e67ed59e1d1-313af21d9bfmr11247530a91.30.1749740990703; Thu, 12 Jun 2025
 08:09:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6828591c.a00a0220.398d88.0248.GAE@google.com> <tencent_AB76B566A43C5B37A4961637CC4ABC745909@qq.com>
In-Reply-To: <tencent_AB76B566A43C5B37A4961637CC4ABC745909@qq.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 12 Jun 2025 11:09:39 -0400
X-Gm-Features: AX0GCFsH-yo5JUhyWyBqrHBwq4KIAN-CHYAesU4gaI6S4jpDyCqdWzVGFPlCL_I
Message-ID: <CAEjxPJ40rFsoXNYpMhZSNCuRrnWXP3GUavA3=1q7DkhcPLZ-+w@mail.gmail.com>
Subject: Re: [PATCH] fs/xattr: reset err to 0 after get security.* xattrs
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com, amir73il@gmail.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 11:01=E2=80=AFAM Edward Adam Davis <eadavis@qq.com>=
 wrote:
>
> After successfully getting "security.SMACK64", err is not reset to 0, whi=
ch
> causes simple_xattr_list() to return 17, which is much smaller than the
> actual buffer size..
>
> After updating err to remaining_size, reset err to 0 to avoid returning a=
n
> inappropriate buffer size.
>
> Fixes: 8b0ba61df5a1 ("fs/xattr.c: fix simple_xattr_list to always include=
 security.* xattrs")
> Reported-by: syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D4125590f2a9f5b3cdf43
> Tested-by: syzbot+4125590f2a9f5b3cdf43@syzkaller.appspotmail.com
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>

Already fixed on vfs/vfs.fixes, see:
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=3Dvfs=
.fixes&id=3D800d0b9b6a8b1b354637b4194cc167ad1ce2bdd3

> ---
>  fs/xattr.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 8ec5b0204bfd..600ae97969cf 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -1479,6 +1479,7 @@ ssize_t simple_xattr_list(struct inode *inode, stru=
ct simple_xattrs *xattrs,
>                 buffer +=3D err;
>         }
>         remaining_size -=3D err;
> +       err =3D 0;
>
>         read_lock(&xattrs->lock);
>         for (rbp =3D rb_first(&xattrs->rb_root); rbp; rbp =3D rb_next(rbp=
)) {
> --
> 2.43.0
>
