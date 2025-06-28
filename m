Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EE9223302;
	Sat, 28 Jun 2025 11:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751109561; cv=none; b=dkw3jz/K4UYyE2xTz+VP+t+GyofmB/ID6m3xLudWt1d5jWqurU+B8Im86uRbMhbs2JkssQuxZiqA3ea6PTXDXonZIRvavGh82t0XH8dk8JBAP112OwMFmvANs5979d6Y37oWvs4DbCOPVUbYH1qSwn9Ho/A3njTC9AGohRaAP4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751109561; c=relaxed/simple;
	bh=pxw3nDUKAGeQcIco9JIBBISlTONF1A8sJx3AG2Rsj+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kh8zCB/bzs0yFMMHWr06jSQMRGigWyZVxarlBGmNStnuHkd/gJJG5j+tvBw+ocKv85yxpCAA3LHiD+S023aqkUJPI4MPjUg0WN6YLy6B8caqLI1alfI5MnYtgzAz9liTd5Vk0rRU9gR0gBLdj++0mUYxpjrDXemfjcnGQeBESHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=epc4afNB; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epc4afNB"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ae36dc91dc7so87729666b.2;
        Sat, 28 Jun 2025 04:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751109557; x=1751714357; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAYlI6JY2Yw3h8d72zKOjYTOygIe2dp0d/3LC01Hhpg=;
        b=epc4afNBoZ6qvDXDSyC8Aaa1zwBCX5ayoc+5dQi+rin/OsqqL93hkdEGUX9EHEyIKV
         6VHxDPl7lCcOGbDDiKa5OMFywcWjhiBlP3XlqX/2sGjfgs4KdFJDa2zeJmaaVh6x0g/r
         0KCdv32vQcUW5WKWe5gpgI8CHDFattI3kj1eFgfA+Lj7fv2GDwjBjKAc1botfRmQ6g3l
         beGjxun7ntNhk/xiPdv/PnrV3c9gRS+wxnS/O1dazBntb5BGyxTLzlJN3zk7k7KEnxBY
         cxvTqMla7w5lTNeVqf0F/Y4vrVIBvQrKwI1nYZFFAiJHinaSCAKTjg8AyeE9w+oRNYGZ
         PANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751109557; x=1751714357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YAYlI6JY2Yw3h8d72zKOjYTOygIe2dp0d/3LC01Hhpg=;
        b=J4faWxeSNqwNc3foqFV4J48LG4RNCsoKMFb/4oNxS/B+8NY/xHMMpCtmU5D4lleWjf
         MTe5aIAKKshy7f+OgAKwVx6hXVJVmmQHlRATPfaVcB6vuyZ/JJge/VOgitNWSRmAX8hZ
         PpIr797K6g7VB3Dw5n/Q4esudzV7uqmB92VrChO7CLwQz0/iEafE0/pBr1HJuFPH0F3Y
         lIJoQjC0GHCr6M38VzZdJDeq2Ed1UTgcMZ5THb94N8oGA9g8j6dAeE3wEVhGb6b2jmnN
         kQ09lQ9I0+/0OXjx0nXtaC9pIj5zTBgtGv0dhFll76Yi5Zrb+CgCtKKf7xTef5JxsyEc
         Tdlg==
X-Forwarded-Encrypted: i=1; AJvYcCUcg4jrF1HXnLMtOWMpPt6haeQ5ERqXjBWWJEKTVVYuWCldKD7lrnXpGRF0bpXA7lZgn2IBbNRq2yiTW3CMFw==@vger.kernel.org, AJvYcCVJxIJlFsVZ6GPozXRvO+FgErnVm0BdtOU9eR93aD9NB7duXO2jW7OBG93vHFCLk/E+Sq5L2ymD1mA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhC4+QHvfmnL5G6inBKjEqvXNcyLv8fLuzaYYo3TQwwdl/QggD
	PEFzUAIVjVS3MiyVDZccEc3/eznoPuuBqHiFLRCFpjV5pGxwT8qnCFTrxCjkkvPbqyks1obl4Uh
	lSY3EfF386A+QNOWEPL8EIo/ws20pNSMj53JQK18=
X-Gm-Gg: ASbGnctes7GYX/zV3VbiykB1VL+vSgvZGEJCM+vp/+ivDW+wDW9IYyfpE0PjvA18RhF
	1MHR+doFrE9KHtJX3A7S4WKyqF4CggMElI3lKI9+BW/VrokuR7K4dBaIVBvgt29FpINjoJbwwFa
	ytYrjWyp6IZeQ55omFJJyzNIHnH6z/F4C71upIii296+4=
X-Google-Smtp-Source: AGHT+IGBGM0JgepjxQO8SJ3xhL0Qg/5RfAF8UJbZiixxUsfuCppqtXEbq9vFKXwBE92q6DX9ElTj1I9u/f/oIeaJf98=
X-Received: by 2002:a17:906:f593:b0:ad8:a935:b8e8 with SMTP id
 a640c23a62f3a-ae34fcf546fmr580884266b.5.1751109556273; Sat, 28 Jun 2025
 04:19:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250628083205.1066472-1-richard@nod.at>
In-Reply-To: <20250628083205.1066472-1-richard@nod.at>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Jun 2025 13:19:04 +0200
X-Gm-Features: Ac12FXy_5jfBfyyYAfYyxsOrZLWLgv6hOd-huSLbpULPyujfRQBW56tkhKVQ2T0
Message-ID: <CAOQ4uxg=CUmr+6EBPG0MSwDezx3jTxtWaGVLazA3krp7PUU13w@mail.gmail.com>
Subject: Re: [PATCH] overlayfs.rst: Fix inode table
To: Richard Weinberger <richard@nod.at>, corbet@lwn.net
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 28, 2025 at 10:32=E2=80=AFAM Richard Weinberger <richard@nod.at=
> wrote:
>
> The HTML output seems to be correct, but when reading the raw rst file
> it's annoying.
> So use "|" for table the border.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Amir Goldstein <amir73il@gmail.com>

John,

Would you mind picking this patch to your tree?

Thanks,
Amir.

> ---
>  Documentation/filesystems/overlayfs.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/file=
systems/overlayfs.rst
> index 4133a336486d5..40c127a52eedd 100644
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -61,7 +61,7 @@ Inode properties
>  |Configuration | Persistent | Uniform    | st_ino =3D=3D d_ino | d_ino =
=3D=3D i_ino |
>  |              | st_ino     | st_dev     |                 | [*]        =
    |
>  +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D+=3D=3D=3D=3D=
=3D=3D+=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D+
> -|              | dir | !dir | dir | !dir |  dir   +  !dir  |  dir   | !d=
ir  |
> +|              | dir | !dir | dir | !dir |  dir   |  !dir  |  dir   | !d=
ir  |
>  +--------------+-----+------+-----+------+--------+--------+--------+---=
----+
>  | All layers   |  Y  |  Y   |  Y  |  Y   |  Y     |   Y    |  Y     |  Y=
    |
>  | on same fs   |     |      |     |      |        |        |        |   =
    |
> --
> 2.49.0
>
