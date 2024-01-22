Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025253D0A0
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 13:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705930532; cv=none; b=WWnuLw4bwolI8uW39FphfC/AcL8TIVtC1cB39rkb2WP+Icr9Uv2Cwo7pUR3rFJcO6NZV9d4IfEyJ4B8WbzCPHWlUgY6VrnkQHibVne1GgxoLoGuHf18qDfe76X6HYB31zaB6JSY8EvQ3B0L9NET40dr0V7QbIrscY3XJeh3Rd+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705930532; c=relaxed/simple;
	bh=yb8SaMdI/Mf9VWK5pGM3bWNCtBdJx3IHI+mKsBSZjq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IpDdL8x4lbIqU7HWT7Ya57GKIF/u9zqioGnUMM299oVoDZU8duIVyBPDQnP0NlvTgbL3iALXlytb/M6AtcIOI8IrTZZSJnAYrnMY2W82lIF2CHgLd0P/3WSmT5/sUUjVzz6F4w1UKt4/fri/Z8Y5F4M02feVZmjyD2cA5oEMzEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=NGBDi4iN; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="NGBDi4iN"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-50e7abe4be4so4123896e87.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 05:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1705930528; x=1706535328; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HL6SeWCbc9YQQ4jFVQkaq2+/aHPegXHLJJskaQ09HNg=;
        b=NGBDi4iNksQuMS3sA8nNJkLHbDnBF7FpAs7JKCD8RB9Be8gQV2VAJLDMOOxj6BK/E0
         wH/f5TGVS9Hphdt5OBS3Ggqzt3gHUuLgosmOf3EmVhuGwY86U/kOvWJtKzArsiWmt1Q3
         K1C7+WdTv1j9oilf4wYeeyCn+cJlRagIirrEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705930528; x=1706535328;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HL6SeWCbc9YQQ4jFVQkaq2+/aHPegXHLJJskaQ09HNg=;
        b=m1nNlAaCfXeDJnbsU/v11rwUbf96iFJhrOcswG8ZhUI80JQtniYm3MGkWgpRTKnvNf
         JojyoYsLtFkArYYKz+lGXZERJj318R/dA0eN40Jd/wZSQ1y/DCE0TXQGFmSg0gQu1tj4
         ELFsFlwiRBsHWrjGaEr54gMRwBepJuHQxFlWxTzahYEaQuISNpQemL3ZVPIRZEnhuxXm
         keF9B/s9H8JPuhPgmQVPUGYnRV7gyM/igHlVR4lk/TS0tKl0N9tij8hN3dktmgpghuH6
         WnMYhJZP7pHJYBme4MSSGTtZCDWRxD1u23Lg7Afvk7XckIIHteRnn2t87keVYMYBf8oM
         dEIw==
X-Gm-Message-State: AOJu0Yze1hrq/+dbAB1esZ4TUO2wC2NEmCx+A7CccLhht04h9Ettx4DG
	HTrL86iNKrxUOEo/2eLS/1C8SNTOu/DMr6mO7zvl75OgIDzCCEShz0g9FJd5H79EoL3UckS2rsj
	E7cLh1Qhb+mr/aoHTyC8dQxnAEX7m/X0DF3N2AQ==
X-Google-Smtp-Source: AGHT+IG+3LSjMOjYJ2I3M/33gE7Y0L0aRLQnUP4zg00F32XBNzye0lD0QjQU6LAl7M2H4wacAwIAnBboijEj8w33GzI=
X-Received: by 2002:a05:6512:3698:b0:50e:68fb:1215 with SMTP id
 d24-20020a056512369800b0050e68fb1215mr1698107lfs.53.1705930527821; Mon, 22
 Jan 2024 05:35:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240121150532.313567-1-amir73il@gmail.com> <CAJfpeguGdxktdFrp4ChW3wpVv-A=3HBSNy5HRdG=41H8h-4_DA@mail.gmail.com>
 <CAOQ4uxjm-Di_R=BZi4eou79kJSMLOKkQ3qqvYjfMyEOYj52WHg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjm-Di_R=BZi4eou79kJSMLOKkQ3qqvYjfMyEOYj52WHg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 22 Jan 2024 14:35:16 +0100
Message-ID: <CAJfpegsQBqjACrnzRcv4TyXdRaWURgBDFXjzmiiKxBSGpZh69g@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 22 Jan 2024 at 14:18, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Something like this looks ok?
>
> --- a/Documentation/filesystems/overlayfs.rst
> +++ b/Documentation/filesystems/overlayfs.rst
> @@ -145,7 +145,9 @@ filesystem, an overlay filesystem needs to record
> in the upper filesystem
>  that files have been removed.  This is done using whiteouts and opaque
>  directories (non-directories are always opaque).
>
> -A whiteout is created as a character device with 0/0 device number.
> +A whiteout is created as a character device with 0/0 device number or
> +as a regular file with the xattr "trusted.overlay.whiteout".

It should also refer to the "whiteouts and opaque directories" section.

> +
>  When a whiteout is found in the upper level of a merged directory, any
>  matching name in the lower level is ignored, and the whiteout itself
>  is also hidden.
> @@ -154,6 +156,11 @@ A directory is made opaque by setting the xattr
> "trusted.overlay.opaque"
>  to "y".  Where the upper filesystem contains an opaque directory, any
>  directory in the lower filesystem with the same name is ignored.
>
> +An opaque directory should not conntain any whiteouts, because they do not
> +serve any purpose.  A merge directory containing regular files with the xattr
> +"trusted.overlay.whiteout", should be additionally marked by setting the xattr
> +"trusted.overlay.opaque" to "x" on the merge directory itself.

I think it's worth noting that this can have a performance impact on
readdir, so people don't think xwhiteouts are a drop in replacement.

> Alex already did that:
>
> https://docs.kernel.org/filesystems/overlayfs.html#nesting-overlayfs-mounts

Indeed, thanks.

> We do not currently have per-directory-per-layer flags in ovl_lowerstack().
>
> Your patch was optimizing only per-layer check_xwhiteout.
> My patch is optimizing only per-directory check_xwhiteout.
>
> The important thing is that for the common case (no xwhiteouts)
> xwhiteout will never be checked.
>
> Are you concerned about optimizing check_xwhiteout in a multi lower
> overlayfs nested over a composefs overlay mount for the case that
> one of the merge dirs in the stack have xwhiteouts and the other do not??
>
> I guess we can use a combination of your patch (v2) and my patch (v3)
> and do something like this:
>
>               if (last_element && !is_upper && val == 'x') {
>                        d->xwhiteouts = d->layer->xwhiteouts = true;
>
> ...
>
> to mark the dentry as OVL_E_XWHITEOUTS
> AND mark the layer as having xwhiteouts
> and then in readdir we check that
> BOTH dentry has xwhiteouts (in some layer)
> AND the layer has xwhiteouts (in some directory).
>
> Is that what you meant?

I didn't think it through, but yeah, this sounds good.

This way we can also remove the checks against layer not being upper
and lowest, right?

Thanks,
Miklos
