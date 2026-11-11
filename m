Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794399830;
	b=jjojCaOV0+q5UbYHJYw3H5gyiKdPWMS84z5dxDIB4IWwAeAulYopLPl8NVr67GxeMeDU
	 le5d32dZCDVEcB9tH+UMnL9mXQPWemExOaaQI3FBKAFhMWUlSycnDRZOcLRqDrHcNrXY3
	 AK9RFCrPs1UKLKlRlqCutJDmiQ3gEqU3vqTN+m8MNwmU84oj2T8jjsJn9ml+4uMQ/GOg7
	 32I4/riMC3YpDopHNFszLdZ88huiIDgIUAGcPsgXn5eUdad693qUYmPOiURDvAFeN3qi9
	 0RMdLvjJkpvVMIKZ1Vh8J1tsVfU9+6lbfmK/5tF/ms/HPmJF3mMT7qzgDadBKcJEPfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794399830;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Lj2hsQY9NelORwuAQ6PLYEHixhgvK2SCXJZ3a7guJ28=;
	b=Pmr37Pyg4uqIfoDphoPxdbwgcCDNVKl+NlRVr4p1/Y7tkZzDz5KN1v1pA8GK7z5jjt1j
	 4U63fMXRGHiDRaG/7K37SGSM0Zn217jOgu+gmKDs4anghetLk7VWN/Ls13mB463+499uc
	 ww/rIx92CXSYAOGgnt5rbsSjok5F44UA5JGqyw1ovhjxCfwBdzZAVW8mpYP144ROqebPH
	 7kTPXQYxsPEa+uCVSq09tz1KP/wY7xSZVFPYXTn7AxbPHiAW0iLHY4CRQ6mNPonWtAQTr
	 2YntjXU2iy8gSrkPJ76rBRqxvVKelvu8hisQNBIFnfuEXhh8FGM8KHha1WhJALNfSDA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="OXH/eMGE";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4364B606A327
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 12:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4364B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OXH/eMGE
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so2071904f8f.2
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 04:23:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794399829; cv=none;
        d=google.com; s=arc-20260327;
        b=XY4VmQtkmkJuhwH6LOkRdTEs3+NxW0JGabMBFPNrfIUfAPEaExftVMNx6rAZNVZx9F
         tN8ERSCRQxHOvbeZI3uTm2N6zwq427xLZk8HwV4jMs90lPwCjvekRzPKo+8kTYUo/Pr7
         69PXVl4NQhJY/SOI8qGaUb9dK8Su22t+uGvtI7WBJFeDAQBnpbKxdM1y19gI26cOwc+x
         XV8LN7oll103vQ+DQR1W+kw4kFdUoUeik4fQZac0GbW9A7tYSeUqGe8FCBov3LYomFeD
         UcPcFMbQOyZ0ZFgEU9BP//Cw5e5Qi9K7l0iNI2ZJyLUlBNRaFOsPFZAmF7AIRGX6/ao3
         jExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lj2hsQY9NelORwuAQ6PLYEHixhgvK2SCXJZ3a7guJ28=;
        fh=MFGww5WWwMbVBAGzYlobFNpyX4w0AV158eWpczIR550=;
        b=XSKx+nP77AinY/aSujqez2mCdac/hidfFGFD8xYLO36/44kLGzPNQQD2pIqA4aYWEk
         fDM1l2mO/ONk3iJvynero7TcihN1C8B17zggSn1uIsFVXZBzDfDoTPLebfUG2VjkfUud
         +19Xu8xz4Qg0kYWyF/5TzrzEmfn8AM+Oix38XMWQiR3RARw6jSu+mMyeDUCJe3v/fmeY
         aStXKvxAj2yp7ZMoSWgZVgnUhOy2roqgQjM6TSEYYGBde8vY272/tP7QYjkRagmzkqAR
         FavhdDxbH1/4wjxOJO6c0EpTZtCfTKVFzFWHCl+50XLkB5YbmqtML0M+aqYrg0f/e+0V
         9m7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794399829; x=1795004629; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lj2hsQY9NelORwuAQ6PLYEHixhgvK2SCXJZ3a7guJ28=;
        b=OXH/eMGEPoHtfePwEzVFgM1KC/hNmORW99uHdmXeRMXkU8M20uHSpRXOcImTCgtGk9
         ru98YvQpxTCdmNGCbS+ds4sqVYUs7uajXl73RB4xiX0mfkfZg+ZCVHWYy/2MbpioQYig
         P6XY6qYIJhw2cieJ5FUE6RBEykm+Rs5mgVo9v9OJUM2nUQqEQ3RzGoEdyRPUiFzAZ9Ea
         RESizSk1R1T8c9j79ZNY2U8z5zvQEBUPG/rbh4rYj7sI8Q/p3UB+pvmC3Sk25WwuActa
         Rr8Fr1scJTyiGK34teInnbdi4K4zQwC5mh69wqTwhOLoHhUmAUKtr667padIW/WBZzMA
         K1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794399829; x=1795004629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lj2hsQY9NelORwuAQ6PLYEHixhgvK2SCXJZ3a7guJ28=;
        b=OHLjmFXmeBilHlkqkd69lzP5bFgkRnZYXPSjMGDwNyNFtFtUqqnHnvDLFbn+dCvw58
         RJP4Dx4AAJHcFX2Wx9xA5Y16avyV7sdOCqyKHiDiPoUPNcv5U2jyKdxJxYn4a/+MMbje
         3uoaRCYSFCe+9SHZyshTwQlPNGUitf+3+x66yxQvkE0uxUeiPb2LTpwyNHUXMt5Qj6er
         PgeHo9bC1H6DqQ3wmtChRJbbrexz0qZuzFxtE3c+SONfUNUgeqQcx6ExpsGtBGFK7A2D
         iIs5MxGtp8Ono93si+yD0SLZ9rCqCmhKmHHCDFTLC7U81yM+lPHhL23CjpicpD6nSX60
         IeLg==
X-Gm-Message-State: APuU4Z+nhIbWEHlaMthmL6tt63EKnb4zRENpj8EjCGpyJ1h2yWPk56EY
	XIa7Pp/wFFk54OsvN4sOei01xnZjVWI60VmoryPG5zFX/Hq3HdEZnBRbcvQTZ9GMiqKsBYLHU/+
	7/JpznWR6uMD6uqvSO7Y5uw7uf8EqMCFLH4CD3S0=
X-Gm-Gg: AYBFou01Q8Vr1bPPPNYXJ/4KMU5R1luXj4GByllsuK4+wkE9n78te3MTbATUNrKTJ1k
	q163gENAHOiBWksKSS43Vyy0Adzx1vYjOqe4LdG/FI98NhA9+NrLUgnDfi9iXhGldWy0RO2e1/o
	jb/Cq4h6CF9qTU5Wv4Fk5NUUt6xea+lc0Y21/6/OI1BggXbMlb1fOP+fBrRknbEPNaRGB44sic/
	n2KW4jt50JbqyjbrG8TlsKLDkClR7A9+9p7ov5Cu9GyC0bWj70l3+gGChzF+lkBSxH+hsyfZeeV
	g8C5ARuWf/H79UyX/yAWud9Z1WBYlH7HdLcQi4/2xP8eRBQU9MJgnijhaa3XWZbxUAj3nO2ri/T
	gjGpBCixVc31H9xsBSxrL3X86ul31C8Pt6bxhxlurnGkcfkggtJGHpyxIyyC+7rMW2STUtg==
X-Received: by 2002:a05:6000:2508:b0:48e:6f84:2e8e with SMTP id
 ffacd0b85a97d-499c6cac68amr4388883f8f.39.1794399828383; Wed, 11 Nov 2026
 04:23:48 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111112655.3454689-1-giuseppe@scrivano.org>
In-Reply-To: <20261111112655.3454689-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Nov 2026 13:23:36 +0100
X-Gm-Features: AclHuK-oYtSKokSaIuu5_7xq0DJE4Z6GsTIOgHTVoZKz8PTpTbWeHxLTCNaFqvY
Message-ID: <CAOQ4uxjZMb43JV61DZdYWQtg0mnpuHyNJj2JxG1S0gPj58ndEA@mail.gmail.com>
Subject: Re: [PATCH] ovl: return EIO if the lowerdata is missing
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 12:27=E2=80=AFPM Giuseppe Scrivano
<giuseppe@scrivano.org> wrote:
>
> The data of a metacopy file that redirects to a data-only layer is
> looked up when the file is opened, and the error of the lookup is
> returned as is.  If the data file is missing, open() fails with ENOENT
> even though the file is there and stat() works.
>
> This can be an integrity problem when using composefs: a data file that
> is changed or has the wrong fs-verity digest is reported with EIO, but
> a missing one is not reported, the file just looks like it does not
> exist, e.g. a configuration file that overrides the defaults.
>
> Return EIO as it is already done in ovl_lookup() when no lower data is
> found for a metacopy file.  ENOMEM is not changed.
>
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> ---
> Hi Amir,
>
> I hope I am still in time to send this last fix for ovl.  Rebased on top =
of ovl-fixes.

Not too late.
Thanks for the fix. applied.

>
>  fs/overlayfs/namei.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index d846c8d15b1c..298adac3a3f6 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1031,8 +1031,19 @@ static int ovl_maybe_lookup_lowerdata(struct dentr=
y *dentry)
>
>         with_ovl_creds(dentry->d_sb)
>                 err =3D ovl_lookup_data_layers(dentry, redirect, &datapat=
h);
> -       if (err)
> -               goto out_err;
> +       if (err) {
> +               pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, =
err=3D%i)\n",
> +                                   dentry, err);
> +               /*
> +                * The data of a metacopy file is missing or is not a reg=
ular
> +                * file in the data-only layers: the layers are corrupted=
.  Do
> +                * not return the error of the lookup (e.g. ENOENT) to th=
e
> +                * caller, it would make the file look like it does not e=
xist.
> +                */
> +               if (err !=3D -ENOMEM)
> +                       err =3D -EIO;

I didn't like the pr_warn duplication so I moved this hunk to after the
warning in the out_err label, because ovl_dentry_set_lowerdata()
shouldn't fail anyway and only with EIO.

> +               goto out;
> +       }
>
>         err =3D ovl_dentry_set_lowerdata(dentry, &datapath);
>         if (err)
> --
> 2.56.0
>

Could you follow up with a fix to fstests that would fail now.

We could have the tests expect only EIO to expedite backporting
but I dont think this is important enough to be worth the pain of the
testers.

So please relax check_no_file_contents() to expect either ENOENT
or EIO so the tests pass on both old and new kernel.

Thanks,
Amir.
