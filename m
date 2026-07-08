Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837F140BCDE
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519749; cv=pass; b=Hf2eiXttblIPG1t7LOEhprWHYzmtZc7Xx33r6oViIFjsM2EujFIpozMD+7OWIvsmu+iqtFkfadQF7WHFom78W/fzIWIDQOi8Os7DzcXetgDVr9Ib314299xrPbbavrXZyUh5c5QQ0QNa41CtpbEtIfwMtZ6zsovHwdk207TbYeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519749; c=relaxed/simple;
	bh=GiebgX43JHl1XQjvBe1+RPmR9h/Aa96mgIB3IChL5tA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ofxVHAZRZWjZVFGKxoedRtUPXZUxsdQHeXHhMBqMBfhF1Zr9BhHIgZytPLH/CUpjLStatZTQPYTMh4kqk1C1o0pddjzzuP9o3bT0nO4vNnLGv21iDl8KFtOAkgzlZl4x3jfdljSTPvBehyRI7ugf1maNZIQcSnJzV/V2mYjLqOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ZwbGkLuY; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ZwbGkLuY"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c0a81d286so10524631cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 07:09:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783519747; cv=none;
        d=google.com; s=arc-20260327;
        b=N8uMn+Q1U1wrgyCLKszk5nCZbfb7YhUtftU4XnX/pnAQHcPr9dab3AFSpFdpqhrlkk
         WkXMGxvhoxPHHmL/VrPOC58JDACE/EY/n/l3d+uvweGGlUNx3gRGnfGr6U2wHAJbbpNC
         cSlYzDsaLpKMqPjhcPmBCYqngDyxLmQOMBIEsZbSBt9f0Prh8DFlLMP8LOl33Sq9dAHg
         NrzEj4ygyIq64QL+94kSbZRfks1tr2nx8/bAmYCxX32nkEbEZB6unf5wWBgX+boGH0hN
         nId3M/fmQI4B5pw8rl5uCpZS6xBqQMaaFTVYTMSqDpkgLTZGIi7s2oSf49iuV9HlxtFx
         lY/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=z+GhnGa9iy5ZTH9B//oC3EDENHUg5DrCxZ+5xNsaoQU=;
        fh=NgwawyGSilGBm3xv9/QJv/TvgbuuCqS7kaE5Yh61Lr8=;
        b=bN+aCbMPg8ZSks65dsj189E+woZP4b3T/y0VGS0qZOGsjQAUGZjsM8o9DYtSWN1VuM
         B6WbJQd3Ompvhku05LcbWwCIccoOaCWjX0nnACTKDGoA8qzASrSiS/EqID0KcsTptmrk
         xsj5LVlcm3F/i9RlG589UFUV6VsVes+Mz0+aZyxlryC4rDVO+ljCL6x9I7G4wUhc9goc
         IqID8NQYUz4kGHxRlZi089RrNt410xrOoQ4tTmGXOKrT2bvw2cLkJ5J+yUCS/iDVsIpZ
         prosJpXGRm0LY5Z51e1xG6ZuyxTG36JnB17pMtTKGyGQ+StxBzIA/309vceeS6G3CIRs
         6Kkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1783519747; x=1784124547; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z+GhnGa9iy5ZTH9B//oC3EDENHUg5DrCxZ+5xNsaoQU=;
        b=ZwbGkLuYcoqnD7Vi14+foIn881NX4ewXtmq3IX9BBdVmbdn6EbI8uPwZfNFd4PN94n
         VqzBx8c9iheU9EwBLmbGMe4VN36UI8UWjaoh8XRP6qa2kzOE6daEQmsQZh5LqdwU7NUT
         B5e4pOrqGAZR9SLHpUnBW2aIkg+4GMFPh0MIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783519747; x=1784124547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+GhnGa9iy5ZTH9B//oC3EDENHUg5DrCxZ+5xNsaoQU=;
        b=Td/KUreY3Z93/IKqgE501tH5x7vawHLv2M8/nMJ74qakQs917QKP3LQsV54V/JJtMW
         UKEOiE3i1nVuKXi0mJZybKYzyLifJYMtjLFsoLwBWX3mF+haSgA2n3w6yAu30xbYDwMg
         na7RF/aYJkLkUGLbghpUCUeg9XUU38kOJRAYwWAEmIaLgQMxQBM5SNOnJZzYaegPxWKX
         LqhrjkllDDli5y8Vott/3ok1+DXEahCUg0S22hKZdgtzUvd0ZHtFVnF7ahuF6WgeQL4S
         YQATrxMX+4UaMnIpiGao3Ide/NvWYbaldf2Uk1yhmDSY/3gYwH+XsUHRZHAxXnnriSXP
         wILg==
X-Gm-Message-State: AOJu0YyjDHCvFWICTnUYZb8BIewMC6nMrqLWE9WdSrg8ck1GxlQNdvBM
	29ji+WUnNR5Oz3drauAyyYHXGryCao/6UIXhGEhCJceZSY6z+wHnLnwxacrTTWJl5XUjw1zE7Al
	TNhGtpF6MNy/AKV69/ms1LvWu5I0yMFBsydUf8waQxwEFdPcxnGOf
X-Gm-Gg: AfdE7clSAxw8M2a0hxPR1rwkBJTY9nHKTfFbEhghv4Unpi0RoHS9Zvc/CAeeiZDX3bv
	yONb6YR9NkELOQnsw5WtTC45D7BqHZBY6QUu7Vi5Hf+Wa7c/HK2TOkx+mUt4YptOHLhlfdTY/yW
	JpTSpt1mxA3qyT5ubTKV+wz/FmR/thNq4Aln1idvyECq4niyYlzAVftGjdINJZg+0ArcZLV+rfB
	omwqIQFKSCElHTTI67F2WopDGCoM8lRD/Rrhcjle1fHHzxnxChnqOnx1NEc2e76vpLj77BaQuDr
	vyLJCQ+Cv6uN12cHwMiQNDp6h09YZSm15JVBwQ==
X-Received: by 2002:a05:622a:3c9:b0:51c:f8f:13b with SMTP id
 d75a77b69052e-51c7a7516b0mr72139411cf.23.1783519747404; Wed, 08 Jul 2026
 07:09:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708095831.3381978-1-gscrivan@redhat.com> <CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
 <878q7l8y4y.fsf@redhat.com>
In-Reply-To: <878q7l8y4y.fsf@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 8 Jul 2026 16:08:56 +0200
X-Gm-Features: AVVi8Cct3OYBryqlcikbWlWdxAzz_Gr4yKGpmk-iVfq-KrBGvr4PWPMuDYrvjcY
Message-ID: <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
To: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Jul 2026 at 14:27, Giuseppe Scrivano <gscrivan@redhat.com> wrote:

> is there any existing user of such a mechanism?  I don't see any mount
> specific info under /proc or /sys.

Not yet, but I think it would be good to have one.  It's definitely a
bigger bite than adding an ioctl(), though.

> >> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
> >>                         with numlower, numlowerdata, and has_upper.
> >
> > Isn't this info obtainable via statmount(2) already?  If not, it
> > should be there, instead of a specialized ioctl.
>

> no that is not exposed by statmount

I mean, you should be able to get that info by counting the lowerdir+,
datadir+ and upperdir options, no?

Thanks,
Miklos
