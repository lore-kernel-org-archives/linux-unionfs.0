Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FDF382F08
	for <linux-unionfs@vger.kernel.org>; Fri,  8 May 2026 20:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778271692; cv=pass; b=u/F2YufVNNw5/1TGj4B953kc6kHuWl7bYXxpB5RNsC5ZQSUPaTj8tBHLJKXah31ZVyoSVUSeTy1YYpcWWhpGLWBZPm2OjzHyTgkzVPCKOpGrO/Dkqd7jwG1pFTMJOq+mZ4WfQeD9lbqYJkkP0HE/A6C7bKKSUdm1WrXSOUGyaBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778271692; c=relaxed/simple;
	bh=mcOKP1P7xh/0iX/zeTZ0XMWGH+ftWHm6jFInDAsgaug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SwwwY1YF3zW0ygVvW1rL/+5W3ZP09iRcZRJbs+YCXj+2sIsYbMNCNJfK5rCSGflUW87wqcpkmGL6B4VAPjgmlUT1efQWXicOZSAgnBfMWW2Cdv+qAPJSPKWPe86NyWOlmu6gfubl7LV6xjg9wsac4ZsTCbyyjeCruwNZ1zz1PP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/xLSfkg; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/xLSfkg"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67b8d9c26bbso4182889a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 08 May 2026 13:21:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778271690; cv=none;
        d=google.com; s=arc-20240605;
        b=AbhE2wV/O+3laY7DABVPO3mU6OoIBzzhzOYOTDnC5DZVFQ/50ChPWiUBudXSX306ZP
         AqRdJQTLjJuZ8Jc7wyXx+DpD2xEt/hUwhgOSYv+AZAEVs6uXNzwz/t0u/NRTeeHQxUk6
         xm3obLq5ESdTJGdT/D8p7AQNtHKhWGbV0Wrwvl2oN7RpsaYheJWqG3FjGbemg2CY812V
         6tPCuifOncMe9Uepv6oy5tvA5ZdayH6wNokdJWpI/13TtLkJV5P+ch5jpMVOFOELoOFF
         zf5vKPTYqyUaZ7UiwVAvRXt7W/cJe3iK1gpckU24G/EoXAf0ld6Q6oS9B9GhO8xz8K3S
         KNxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2hfEezhJrxyO5Y6C69MmAR5VxY70zy4iUa/wxq1qIl4=;
        fh=VoAcOcpyXmJ1IEykmAIVslmxCkZJNcfFV+Wv9wba3Uk=;
        b=VH5hBrxhhhvH+AB+RuUYTR91puvD20DiDjWq0TtOBNp25Lv5ekUe8Fx0QA5+NfQBjq
         KyEb2YU9T0MXtIV6oAWZPjf+YsjET16zl4NUzAVIdFa6cfTa1QkgxfrbmEEHindE0JwC
         lIHrpDzB/qKSGS0e8FkXayGKEAbCDf4LmxMhR3eaWD9oZen9QEKSPoIUm8Q2Fh45+1nb
         IhrNdzJl0mfguNdDLLcfj5q7k054v+JGzutl7KzpYFi5nT2VauGXzRpUHH/CkqiellC1
         KyC1I3R9BM9rTmCQ5OQrZzCf5JHKAcZ+7JlF3GEh0jREqdt1FVX7RrolJErJJYBBlbow
         vM/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778271690; x=1778876490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hfEezhJrxyO5Y6C69MmAR5VxY70zy4iUa/wxq1qIl4=;
        b=V/xLSfkgoqbD/x6xX1af8nk7ItQ8GNlzEi6CmnKuSq262ZkVMP3FDiPg8Z0bsNKsMF
         S56Ke5Ft6euPNWD+aKVlJaCGpLr6IypZEB6Xp1+kFg+5EZ1ZexZfrFPWFfl9EuragFi5
         La/fBhvx0jSiK5LEcb99ywSHAZrd97sZJUkBs2tkaGwepPbdVMkiM/4tG2GkDQvfVJJI
         pdXsWCOT14Cs/k0BEl7QWV8f5yW/WUamGH9p6uVQdsRVKlH3VtRtTuwFIfJMVqlc/SyT
         YpiwlIGwgOtCyFYMbOc1vcDYwEQgCwn9jFjwhy5IL4Vv8f8JT7KjcHsIiPvmn+5/kTo8
         CjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778271690; x=1778876490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2hfEezhJrxyO5Y6C69MmAR5VxY70zy4iUa/wxq1qIl4=;
        b=o5GnYfaBXqAKPiDtAilg5VWdRH1d/MHQYA9SZj2j7eoqEq7viUnOwV36twfrqbhnb0
         7mOP1uGRPYIZgAi7OftKP2JegTVl6MCGaDLqch9h3Xuxa9Yzr2Hs5isu330nkRENpPDI
         Go8T7NN3F4kL5Klg2Pi+fUx9qjDg/FlaxfJJFdPI7smTq7ca6VmAac7kp5wyUtG36smB
         diP1T4a+WUoLdQT53MLB1dtzlQs3zS3tdCYcHwnJkn6HVZjHZoWSwrb89gRgCI3s+8H7
         Ti5hPFlXa0DYnHR3/yWGL+0lrx32LOqaTVTPzvppK5Kd0tvhUYvxcsjeBsqUCtN3545f
         bbOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Qjmex0c2R3GNGhNI0/6QPjzz4ZsEIcapCiGk+DOawfuh6Xp1iXzXSnvwExvQpFFAiuyrn6LxXLQMkrHRc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+Mo8WY45to6bP/Jfyt8I+VORP1F1YXs01el4lLZu2BRGgO0UW
	NZuq7GKeei/jVh9BoyQOj/i6v6ICewO/22GqpJC7ilK5HYIA+UgoQemAqI4AlmJTuz956iaCFLO
	FwS14yGpJyvbl8PXdI/YQYrjOJAH6J/g=
X-Gm-Gg: Acq92OHpu7SO/vaNB92Owx/BiFLEx1g27sHK4KnBrHYEN/iaVrgoxUBPB9inkGsJOHA
	dQ5bMlnsmGA0XOROzrz6mzqftrVtoybexQRnxIrbY1LSchRv9h6KBJTHyosgJI023xO5x+n0URk
	I/a1Wmp9jCv5NitMdI2pfbhL/66dHJB3kCzsJ8SV+PMoXKgLQGAvUKcHxm5jbSesns9dVLeCgTJ
	fUrwI3E7wNgQVlsLGJV0I+1AJtcAu7nkfoAtRqwgZBITHQf7KGQC8ioXYa+4B5EBlXts2fj0MD1
	Xb9zlqtrW4Nrw2yS8fGSQeESSOUPuPy0cu0JN0553Q==
X-Received: by 2002:a05:6402:50cd:b0:672:a1df:9c6e with SMTP id
 4fb4d7f45d1cf-67d6489f992mr7840338a12.25.1778271689295; Fri, 08 May 2026
 13:21:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <97140e8a-541c-4e0a-accd-cf58dd1feae6@app.fastmail.com>
In-Reply-To: <97140e8a-541c-4e0a-accd-cf58dd1feae6@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 8 May 2026 22:21:18 +0200
X-Gm-Features: AVHnY4IHG0KkRMTJIsoJKrIHSnuyNVArSWGlGVzc-pd0q6fKy4YRB6I_agEmCbE
Message-ID: <CAOQ4uxjHXdAyPN+hrMZV175OCgSdLT=-rbdD2+7ygqv8C9F-gQ@mail.gmail.com>
Subject: Re: [PATCH] overlay/080: cycle base fs in prepare_midlayer to
 exercise lazy verity load
To: Colin Walters <walters@verbum.org>
Cc: fstests@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 8, 2026 at 10:08=E2=80=AFPM Colin Walters <walters@verbum.org> =
wrote:
>
> This reproduces the regression reported at:

Make the test closer to real composefs workloads, so it will reproduce
the regression reported at:
> https://github.com/bootc-dev/bootc/issues/2174
>
> Assisted-by: OpenCode (Claude Sonnet 4.6)
> Signed-off-by: Colin Walters <walters@verbum.org>
> ---
>  tests/overlay/080 | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/tests/overlay/080 b/tests/overlay/080
> index ce5c2375..ede04dab 100755
> --- a/tests/overlay/080
> +++ b/tests/overlay/080
> @@ -21,6 +21,8 @@ _require_scratch_nocheck
>  _require_scratch_overlay_features redirect_dir metacopy
>  _require_scratch_overlay_lowerdata_layers
>  _require_scratch_overlay_verity
> +_fixed_by_kernel_commit 0c8c88b8eb82a2a41bec5f17c076d6312dc40316 \

I do not see this commit in the upstream kernel.
I do not think that Eric has already sent the PR.
Please wait until commit is merged upstream and then
use the abbreviated commit id.

When you do that and post v2 patch, you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> +    "ovl: fix verity lazy-load guard broken by fsverity_active() semanti=
c change"
>
>  # remove all files from previous tests
>  _scratch_mkfs
> @@ -222,6 +224,11 @@ prepare_midlayer()
>         echo -n "changed" > $lowerdir/$subdir$wrongverityname
>         _fsv_enable $lowerdir/$subdir$wrongverityname
>         echo "$lowerdata4" > $lowerdir/$subdir$missingverityname
> +
> +       # Cycle the base fs to evict cached inodes, so the overlay mount
> +       # that follows exercises the lazy verity load path from disk.
> +       _overlay_base_unmount "$OVL_BASE_SCRATCH_DEV" "$OVL_BASE_SCRATCH_=
MNT"
> +       _overlay_base_scratch_mount
>  }
>
>  test_common()
> --
> 2.52.0
>
