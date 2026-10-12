Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996CE46AF2D
	for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2026 09:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791798473; cv=pass; b=aiJ+tshGSvxvSdC7CkxmVcLF53vKm45iyXgj75Z9TIejqhwA2PvqI6yTjMDdZTJnea82sMOJiMjXtTVcg8xyHAMpX6F0A7BAlfhLXRnLu4kzRhYKJOaHrfNAdPZldYHULp9pw8Gbx7KoHN3NKSm/ncJ3WnMGYtAAa3O7pEK4OnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791798473; c=relaxed/simple;
	bh=SsZNCGRw3F7uVhp6Wx0pDGhtzKaaM9O6Ixab44d94cs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=slUNEc4dX3jfBGbmjLQME84HM2ATZadRJzlAMGMKLk2cwgopMsQGpNiixNdfNY5iuo41PI/Tu+vGK65lwVt7wKo2CBpHFT5vakDlC+SM2xreSWSKQMs5m+RIX6pX89CUCsqqwaK4sLl6wkAPy8xJ12gW45/6GMILmLrEE9zVWI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cJpDWweA; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cJpDWweA"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2e5f8fe879so272150766b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2026 02:47:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791798470; cv=none;
        d=google.com; s=arc-20260327;
        b=CO/9QtlH8/S6uGikyckX5bWO3MhnUD000tFiGhG23Om9i0QUJvQyxf8jpTfCWK064W
         d5Gf2xxAJ7tYl4shu7AiPz/Yp9bwWpFPc3LHTLl5zjTfvTY1JFbNY6zZHp9PTTgyFBPV
         jQmwGYoI8N6eUHW+TtU9xnGZ1un6aOw2fRTBrIdm8ifuxgVdu7SUWNH+auFhC1cuOgUb
         4HY5J8AR59pFA6iyw0gP/TdH8yWQgpQ7QlBMtK7k57ZQRqaE5KlIR8srMUb/VW/E5+5J
         Uo6DLEAb2CNQCxKkHnlhVnX+J9TNdaCw/2wy3MWPWz6xySgzMWK9Udguw1mAtKtdDHRX
         pQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3VGDcycFylt1dIW2Zqg85s1x16i6rd6gN/8M5j2Yg3s=;
        fh=gZG0s51VvrWL65+97m1rQDS+F1HS9Jrmkwqvf4l5y4c=;
        b=Si2jzOnoQlpzyFuJAygLezU6BO2IIXASE5iScV1m8/v8+n0bQvdfBXYGkfVEpUC56r
         rtjGRP/Phn5cD9o7ts6/MmwnGKBFW5ppytl6OHWJAz79yVlpnbqcZdymFQzXJS0YHngp
         q3lKLuZpf9W/nHlO6DyqsBslQuxvtAFLfPfJYD4niqaPINWrvIf1yCu38Kx2EsohvokN
         UxXsBbvuGTshZDXf56d9O8xkThx5hRbsiG03HxNJ+ZnKjdDsom+q3JwwAtbxwiPMfpz9
         MEPxI8uXKCb0Ja4JQelmIyq4tFS76K9gaGv0XRJphIs8B7dJK9SwEIvWCwk8ni5K2NWX
         ahzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791798470; x=1792403270; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3VGDcycFylt1dIW2Zqg85s1x16i6rd6gN/8M5j2Yg3s=;
        b=cJpDWweACXRacSVT4LUgxxf87aK5w5wilcvKFuOZ4hSHUv5GdYrXHzgXdhievRis6X
         jl0xIjapAt5p2r46+E5dgtJAncP1DPY2+3KKRCM/pTHQfR5Xh7OqlViBA2MIEHFsYYbA
         ODWNCCd9592F/T5dnNuSQcEm7W9P2ALQ8GVuij7HKAiqH8e6oDrQy/jhHggcQyZgnRqy
         PzefJWFJBiPMbCuG0wwkbVzASTcrry/A2qyVzZPTaXujt3z0qLr6IqNDeJDNYLasWtT0
         SV9OFsORZCWpFw8i3AhN9i11Dzne7ksZSITjc5EJsGK9qG/54L93LZM53XWDIq7VFLx5
         MXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791798470; x=1792403270;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3VGDcycFylt1dIW2Zqg85s1x16i6rd6gN/8M5j2Yg3s=;
        b=lPh9DFd0bDkQyVuXuP7ZnPDuLYifBlBfeuJKeLyyGQTOnNrxmki/qjTSnYowKn+CmY
         N8piBZfZ/EadxxAW+mUoJr3B/FVUcUneOTJlHT6/7rXnKQc2Dp8dkOnCAOjHz/ZESmoX
         M1toGOs5cl+b1BTG5xelQbBxIE5d6AYGql0UWSqGmCquYv3l8rPpu2aqWrPVidYJKaRx
         OeVOHgth6FSlLGj5ucfSUUcx6nwLve6wGBHyQ4YSZzGQQKY7SDaDL5/qU3LKAbPmpPLg
         zzdTzTb2APazc0WtJqVVKkFaSGQxIMET6OQxu0DZZWhkw5GvyL6ZDp7C9jBZg1qg+aUf
         WNow==
X-Forwarded-Encrypted: i=1; AKwUvBzeqJDXzT7C+oJ/3uXAXRlsAgDyoRKcmOwvC1RGqbktCWPqRd3oU+1CSwGBA6zP5UScqMvrMAIa2ftPAwrI@vger.kernel.org
X-Gm-Message-State: AFq9FYJD+ZGgGeVbRK+WnqJfIVDzhjOCBa74GxyHGmU74MjYDYhOYv95
	w7/78inSWMio+JlbVM0ikop5DQfq0itUM1Ul6g7+kTBn2P8auF6+XrXquPbARuXkJp3SbiPtxWK
	ELz5j2FAOxGlrEoWlAY8LUoS+vTjlrmM=
X-Gm-Gg: AYBFou3d57ULzFatPAXXZ3kmKq81MCleh+hTIfAbzGohBlWWowHyWSDc/4l9JyocAkN
	kXYT6WJMdcHeMwTH4EPHOi3e73C9gEh5g9fLByhPqGyV6i48gG1147VofZ9V6ojErga7IcX5/az
	mUJS2fBBmuLtiHL1c0NSi6QeEx07Atebg0fiAC/31TcPzmAmgnf2RgmPYUoSjHOd0f41OZTuX0s
	evFCiixZmDhGULjC3jqhmO5qo5jO9DODC9Cig4znhDyqqUtq7gUWp5R5ZnXpsjeZyn+CROB+fh1
	mnmPrnqq2iuLNYLNPtN8bwfBQQ7PmYyWmy0nOfcFWZGKIv78+kVguh3b
X-Received: by 2002:a17:906:c105:b0:c31:5bb8:4b3b with SMTP id
 a640c23a62f3a-c31a9a335femr914440066b.2.1791798469497; Mon, 12 Oct 2026
 02:47:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012060847.836027-1-zhugl3@xiaopeng.com>
In-Reply-To: <20261012060847.836027-1-zhugl3@xiaopeng.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 12 Oct 2026 11:47:37 +0200
X-Gm-Features: AclHuK_9ajsePmXQfH6j4Ek8BMjJ530fzizo6S3nLvq8SngFf7HNK5QSGn2kkRs
Message-ID: <CAOQ4uxhMUfrBmD-cad+hTP64uvf5KXby7c0u+RCU2Ya4C3KK-Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: reject lowerdir ending with unescaped backslash
To: Guanglei Zhu <zhugl3@xiaopeng.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liuc63@xiaopeng.com, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 8:08=E2=80=AFAM Guanglei Zhu <zhugl3@xiaopeng.com> =
wrote:
>
> In ovl_parse_param_split_lowerdirs() the escape handling consumes
> the backslash and the character after it.  When the backslash is the
> last character of the lowerdir value, the loop increment moves the
> cursor past the NUL terminator, so the loop scans heap memory beyond
> the kstrdup'd string until it happens to hit a zero byte; a colon
> found there is written over as well.
>
> A trailing unescaped backslash escapes nothing, so reject it with
> EINVAL.
>
> Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
> ---
> Found by code inspection.  Behavior check in a QEMU guest:
> fsconfig(lowerdir=3D"...\") on an unpatched kernel returns -ENOENT
> after the loop scanned past the allocation; with this patch it
> returns -EINVAL.
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

Hi Guanglei Zhu,

The fix looks correct, but the commit message is inaccurately making
wrong claims about heap memory and scanning past the allocation,
which makes this sound more severe than it actually is.

See Sashiko review comment:
https://sashiko.dev/#/patchset/20261012060847.836027-1-zhugl3%40xiaopeng.co=
m

Thanks,
Amir.
