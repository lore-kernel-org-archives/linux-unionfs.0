Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012F83AEB27
	for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2026 10:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791799892; cv=pass; b=pZW3gRr69o625IU9PgcepqNjkqBKAtehorFCM3xTKqjxZ0qnWEQDAeOqeqTNYDFx/RIkFIv9CJjpszyAYYfXUZDRmjp6BDQPJvS6EUA6/CFgFj7WMwc8uqUqtBvyUzn8Cm9a9XiFai2c6KXafztksIu0ipWDWdzzEl9tMVl99g0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791799892; c=relaxed/simple;
	bh=hD0XUYpmFbkzwLbEs6hxZkv+4L8VPUED/C4DSZiJEJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L8F8EAx2OEvtU5IPVbD47CsNHClPQbG7jHb8Yl771hRNrMRHmJjrqiFIBZJOiK4u5fPHny3HHEjjfkZEi0N9ZLwUQOAyIHXMaln0/yPRBLo1jz6Xr5S9ebDkhzREha5MDm7DxOnrdvQ2Szyi0Qy3bjoEhQ0nBv5KU/RmsKMmsYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YXHNMIba; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YXHNMIba"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2dcbcc546fso196912166b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2026 03:11:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791799882; cv=none;
        d=google.com; s=arc-20260327;
        b=XkotgPI9YiZUOduvU68oGWQJLkkRg68LzX37ZvpjPxgwx4nAuM2QwKAiAF035R39HE
         jxEXjtBJ9b3+xwVSuPYRniRP2BpskTnoUgzimWuN98usA1XNO5ZGJVJ30Z6YrUkG+Z3A
         qF6SVAZiifBc+uccbR+YjIRwDHxnNmJVfeK0eLX+pQEAiAObo9J8i7xX5YioE/VgRxQm
         3NF876djDhbUtJfarHkoxbOWq4AmxfTBwpZZ2i3GEjVOXKzVqvy0F2SfvUQ33mucu0AF
         fWsDUS+s9CQyXM/YVhBETUgARa6DB18fmzQHFWbhQAtHw5Rjx8UwvdATiJQQPw6OF1UJ
         XDnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IH/H5Rnu3KGQfAu4tL3ijSF/1VrM6iJeJ912BB/EjuA=;
        fh=z1MdD19xunSC8M8cGR4h80HsV6Ba405z31dwwyR7HHQ=;
        b=HLwyq+bkZNQXmDWS0K/T3fYjpbs25iBVH1Qu12qVcL11R3yOxaUgzgYDVvZ+l7ckP3
         ilL9SCtUm22eAAjmXToahmfIwD3Wj5iHs+Z6nskO8ixeUdPPvEn4ycy+m6ogk737L2Pg
         Z+UzUp6rMTb0o+wNk/Q1QSRm8W0SfUniSPoWo0xT6us26mpCY9filTs3PoLFA53vALSJ
         WBbvQYSaF9fAW1RraeLUZEtdJdDWq9AFKISBin8RniD4SeqOR8heLLaC9IL2ghMMBwxN
         LMLuGprDgr80teaQBLYmy5aC8x/3dhC9L5lkxS8FR94vxKZe1zxOrPsbg8JZ5mHELjVI
         ajWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791799882; x=1792404682; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IH/H5Rnu3KGQfAu4tL3ijSF/1VrM6iJeJ912BB/EjuA=;
        b=YXHNMIbatKmqpRMhla9Q+v0No9Rhy8kGGt0tEgaKy+WczfjkqJKIMm6DJCd3jHSUlg
         wvp+FNfxoMkqFcfYnvHfQ0iRMId2i9p44nbcelwD2oCY0099ZBa91/Cb+vw8uiaeGmZI
         DUTog/2mRqc3sX7IOC4UkKP+W1EEf4Ls7ehW3sQaE8EOrCrt0v03in4aQLgJM/QHSszV
         QanATi4GA0fGmgMAYCCdE46D27HdiZAwU/5Enr4bSouUigzl1XdpYdCmIURcQ0YYykKt
         YEFpsZ5UzejtnI8/NFR+a2Oy0c0qAJR2EL/978Ne1lcqanA02AR0qzmShsloes9sxefU
         p1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791799882; x=1792404682;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IH/H5Rnu3KGQfAu4tL3ijSF/1VrM6iJeJ912BB/EjuA=;
        b=DGbmFQ6hKK0Tn1jc+2nSmXNnFHkoa0JjWT/LMx/oaDzOO5smVbMINz2i+ecIKdGpW7
         dhceQwBTnKRddbx8Nt22ARR9g4IfHlXVpJm8vT8ikOTrpIs57eOwfaqKZEYY7j8biElR
         Wj/ZXPeMgziGogCmLxzNUo3M0CBB1QZzQSZ81i7m0YrnLd9vNhE5cp1Jdli6tVXXBvSp
         csINP32DLy6869aO1pdJsOkZXaEbVBOltQPY8W6dh0Sy+MS4W7Upj3s9wfT+LSueazEW
         kLrnvJ8KN3grKsPXbfLN3lVWr/lj4T1NeO8VogK/w6fdAHoh7mfGSd0Af4X8maHiQD6M
         Rpiw==
X-Forwarded-Encrypted: i=1; AKwUvBz4tvWJLoLXY7HV1RRQTpRjCitwKRpWhXO8W2gL1LPXHc1cNUO6Wmw2lbUKyXhc0Dn6qXhO4mfxbg17+bYZ@vger.kernel.org
X-Gm-Message-State: AFq9FYLt+CR1vrle0SbAHHIIfRcKuGAQBasJ8j0vr0zBJAxEJi6d3tsY
	MIiGCGCp2M/+hw9MOXQ3+oqnBcVwukERv/FMj5WQUd4zxQ2WlRghrdBuJSURF41piayc/SkG7U/
	R/0atcIYZZnZkxtJR5aYTLjAHYnNxEdU=
X-Gm-Gg: AYBFou2oDV56M/Lcd8Rn4p1plXEYhWaXxBytcUuWOMvhkVY656igr/8DMinp6YzWwOW
	6bZjhQDvgiTNx/M8PLmVByzL/UkE15n5sEAxh6uK2sJD0Qkgdl7Rzn2gU9efMTXAPwTT4ELCXgJ
	3Ihjhr6l8x1oFHEF3vceCueO3jwAvPcqdaCY5r6Bkkr+SDTE39KCisjnX9UDLLShXE86lscoQw6
	NPKXTcJDHXIvyxHh3keiGnUzxMz6PEAPAjnnXazy//+tSa6p2/YqHVG1HmOfwfnj4LlY+B1ZB6M
	FXYdLlaw1NzM4fkif0kbLzPzs0a30eC92OKELUc9eF199gMeICpFRb2e
X-Received: by 2002:a17:907:9625:b0:c2e:4c59:a3ab with SMTP id
 a640c23a62f3a-c31aa0d3c1emr865310166b.48.1791799881902; Mon, 12 Oct 2026
 03:11:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012060847.836027-1-zhugl3@xiaopeng.com> <20261012095538.938789-1-zhugl3@xiaopeng.com>
In-Reply-To: <20261012095538.938789-1-zhugl3@xiaopeng.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 12 Oct 2026 12:11:10 +0200
X-Gm-Features: AclHuK-zcdTy-mDP_rHpw_c-n4lrMxyUGTOyZXWU629AVGJdU872TFQ1QoVGClc
Message-ID: <CAOQ4uxgLZWGFhSHfHWiGFau7ZOXmNWsd8M5iVTOf+4_hO2KgGA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: reject lowerdir ending with unescaped backslash
To: Guanglei Zhu <zhugl3@xiaopeng.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liuwb@xiaopeng.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 11:55=E2=80=AFAM Guanglei Zhu <zhugl3@xiaopeng.com>=
 wrote:
>
> In ovl_parse_param_split_lowerdirs() a backslash consumes the
> character that follows it.  When the backslash is the last character
> of the lowerdir value, it consumes the NUL terminator: the loop exits
> normally and the backslash is kept in the output, so the lowerdir is
> passed downstream with a trailing backslash and the mount fails later
> with a confusing ENOENT from path lookup.
>
> A trailing unescaped backslash escapes nothing, so reject it with
> EINVAL.
>
> Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
> ---
> v2: fix the commit message.  v1 wrongly claimed that the loop
> scans heap memory past the allocation; there is no out-of-bounds
> access, the backslash merely consumes the NUL terminator.  Thanks
> to Amir Goldstein and Sashiko for catching this.
>
> Verified with an ASAN build of a user-space replica of the loop:
> no out-of-bounds access, the output retains the trailing backslash.
> With this patch fsconfig(lowerdir=3D"...\") returns -EINVAL instead
> of -ENOENT.
>
>  fs/overlayfs/params.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index c93fcaa45..5a15e5478 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -216,6 +216,9 @@ static ssize_t ovl_parse_param_split_lowerdirs(char *=
str)
>                 if (*s =3D=3D '\\') {
>                         /* keep esc chars in split lowerdir */
>                         *d++ =3D *s++;
> +                       /* A trailing backslash escapes nothing. */
> +                       if (!*s)
> +                               return -EINVAL;
>                 } else if (*s =3D=3D ':') {
>                         bool next_colon =3D (*(s + 1) =3D=3D ':');
>
> --
> 2.43.0
>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Christian,

Could you pick this up via vfs.fixes?

Thanks,
Amir.
