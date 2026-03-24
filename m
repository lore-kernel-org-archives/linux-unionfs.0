Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4416937A48B
	for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 15:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774367840; cv=pass; b=OmOqYhcROx7Fn0z3F3zPh0AUWmffLFHYi/5P+xngJq720xRp0LPPpi0xaRNW0t02sI6HO+X/koKcfMB+BC+8LIkMyZh9DPd+qnVOPLssYtGAa0QjWbunkhIcRgt/bcfZXfPOrLl8LSsf9l51OtsJcs9hcqN6D9q1+Ucj5eblfrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774367840; c=relaxed/simple;
	bh=9DWC/vfXqs338085CPXMd7zgnZlJCsKQugvNz+oO+5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s1bEqhBwZdQOfXbBbeNgPGCcrrIa6kH09QuE4HLgryWFaCDzAuv0ZCXm9ReGYei0zUPLE1296cFo0RvpfXFLeiucp0yw/cXTjmzSJHrOyK6DNkWiD/3Cbhk2be7p8ckzEwQA4lct0KQ8aIZU5wH0IlQaIv5rhfkwI78cuQpXGfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=BAg+KLwb; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="BAg+KLwb"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-506a7bbe9d0so41301031cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2026 08:57:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774367836; cv=none;
        d=google.com; s=arc-20240605;
        b=DxtGXr1UNEmfdWK7p3G8Efrov7/4eHkcV4sOODx55YvRlvM81VMxZ70N8gCbWz9f6w
         mqtYatU8udt8478Sn02/n8GAh3SiazhcZ2Zm54bYJb9l9PBUjvhG3/oNEN9DP2SfwCo0
         LDvhQ2rexI8kyCcIQuvA2kPlev+PdhnIKQqcDarvu2o22JjXIeTi4Eex6X5au+Ey+gLe
         ex3V621tUzq6msSJnODZKmd6Q1su+6ECyvJn+CByHPmD0ftCK+YtZXJvmbMB59NXirqT
         h6wqmMX6jfSSk/iOf502P0RdfjmxuubKX/g8qYRgDIdWQTzw+3imMwm9RlhtPDw4UrxG
         vybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3zCAzoW2GC6nZkAoqIbb9lMGmfhoc5bqKvLxG5ho4hQ=;
        fh=SUFpPxWjJ/4kypGarOExI1an1zeE6V1AtcQNLfcrmSE=;
        b=ZmZ99rKcAPw9M2OK+3BXw5APXM7Zvju+XFCAHZXARgR2bceUpyyuwyRH8NgDY2JR6Y
         4zYUa/g9MKqxTNSkrCJSm6SD6yKhmTLj/EwXoiTjOTJqNACEBXXOAJMLHHMlFbc6kXPK
         ZGgy0tVgCLhvoeuv8LSFgZmaEPMxZEzmQOpkrOhqjc5PXX1FEQrTEu5G7BqY2BB230Mx
         hyzP7QSQLdOw3IeqDYq4m2Phoxi790kFhgTkx9X7wv52GA0B+XmkkTF4pk7L9FpWcd+N
         XoMn8KvoSI+LjyNlZBu2xBE79tmV/TrvMUswN+32C96bUL+u/XMGW+Z13bgNN+1y6GWL
         n3xg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1774367836; x=1774972636; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3zCAzoW2GC6nZkAoqIbb9lMGmfhoc5bqKvLxG5ho4hQ=;
        b=BAg+KLwb5k/X5M6uv39u60APSUNLrQ60paxh53y0DYfI3ZbPxHVTJqRGZ6WEnMDNad
         AvjHjB+TRWcokz+7/HxqTI+jj96230lS1v285zzCubYdwPSyruF3BYfxD8WgbyZ+N33C
         3F1T0YM6etCYC4Nt7Sklmx/BeG/UgtW77GMI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774367836; x=1774972636;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3zCAzoW2GC6nZkAoqIbb9lMGmfhoc5bqKvLxG5ho4hQ=;
        b=slrMK3Fv9865CNGTqzTMbNTlfid8eBoezVB6Qxhh9SMadw1Ruq7zqQiJdT8ZbbJ5kD
         nZWZtEpnxh4TKx8e/4tuF8zqnYhlhXKFeaOhpd5Dg7Ijd6G4VNFhDMMOQ0WXd9eJBHGk
         pUZiD7gDxPcTbHnzFZ3RD98p6+tlPA9u68E+5TRZYT1EynYHDAmJeKHRRL1yVIep+skd
         hfgrmk3R0WQsHCiQAFMD1NF/SKeiCSRWp+UmuyTj1e9NWfs97NVZcoYBZNmeF4wYJ2mf
         mTXP6MsyxZBkoaaiZwpX+OmEzRoomTYBJOyAF3X3aC838tVHpeKGG+NvmdVBkppW6BBC
         AuVA==
X-Gm-Message-State: AOJu0YzCjRbX35JwnRgJ5GVHbEgv+WgNtnaliv1ddCugyxrhAa7UL8Xy
	5fw066rUPTyxq8y8hS3HZkP6cIKB1+C1Qio53Y+ehKi8aQVAERtZUGp9lApSGOwjoXYyGviJb0e
	Gk7Tw720JZdLqqdRROLfAnQbE4/n+UO7cMPcmUtWv6g==
X-Gm-Gg: ATEYQzyUHwZR2v9WpPmjiiGaisPjj4p4KkYG/yPxYsYYohGJCWrN1/a7dPuHXNVhx5X
	3YUe+o2hN4JNvhO+a9HkcN+x23+2xcDm6kPeURu/JEKAq8jPQQZoCW5wXDlpR4/GHsPfWFpqxi7
	9+xL0V71uPZbyDcq/JTEYLNxbxzJkOQvUvqNrztmeXc+eXWHVoX1W1HjoiQuHGDqbL5oN0r+NSu
	ibM8YIGs3OIYR0FkUbG/O3lYwP/fOIy5vjEfqxy1nKWCQb0DS8NWMkLVUTeRTzwW8lKytbXwZ9/
	fdOv6tdFNg==
X-Received: by 2002:ac8:5783:0:b0:50b:382e:f09a with SMTP id
 d75a77b69052e-50b80e2ea85mr2025751cf.33.1774367835984; Tue, 24 Mar 2026
 08:57:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324152221.96677-1-amir73il@gmail.com>
In-Reply-To: <20260324152221.96677-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Mar 2026 16:57:05 +0100
X-Gm-Features: AaiRm52oL9hSK_cZrHM-DIg8dnovrChYo_u5d4j1I3-1UApTjM2HEzwX2tu5iYY
Message-ID: <CAJfpegtkvxkMcdoG_tCxMP4FF3FUq-PhXMByWFx01gTWXZ+_QQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix wrong detection of 32bit inode numbers
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Mar 2026 at 16:22, Amir Goldstein <amir73il@gmail.com> wrote:
>
> The implicit FILEID_INO32_GEN encoder was changed to be explicit,
> so we need to fix the detection.
>
> When mounting overlayfs with upperdir and lowerdir on different ext4
> filesystems, the expected kmsg log is:
>
>   overlayfs: "xino" feature enabled using 32 upper inode bits.
>
> But instead, since the regressing commit, the kmsg log was:
>
>   overlayfs: "xino" feature enabled using 2 upper inode bits.
>
> Fixes: e21fc2038c1b9 ("exportfs: make ->encode_fh() a mandatory method for NFS export")
> Cc: stable@vger.kernel.org # v6.7+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> I have queued up this fix.
> The regression has no serious impact on most users, because xino
> works pretty well either way.
>
> A nested overlayfs, where the lower overlayfs is nonsamefs ext4
> would have less xino overflows, but this is a very corner case.

LGTM, thanks.

Miklos
