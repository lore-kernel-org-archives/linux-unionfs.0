Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDFE3DB330
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Aug 2026 08:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787646073; cv=pass; b=EFgr89DMlsVUSuokFuUtSMGqTVH6PLw59wlPdEuk2AuNhtF1c2gwiPR2cjejk6V7+KeYU54HiIL6ugNw2AIJRKLnGWPWB5PHruVGTJO5sgktAjQCTPDNIRwjyxdGLlDmeH/eAZEGpic9kBHOSTVXjUFHfy/GMJeMxASuC2RJbk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787646073; c=relaxed/simple;
	bh=hDhVjHWeD+vOQmgC4z58IxWumqKfiwZHj6VETFpThTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vEMgiEaOIGqBh3A9VP7A2yBJIgancO1ZW3nWdJwqibjuPFmySlKFgSuSMo3y8mFwIw0dTHuHdadZTwCb6y1oR+7YTQC7Ed9/i1mgzYhYpElVgjRtQBmSXis9IU1oP+5czsE1ahadJxgsHC+JjaGaKc7xhcLbkGWtH4HSMrXhBzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Q0qVHxL/; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Q0qVHxL/"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-52d8679c149so37201871cf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Aug 2026 01:21:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787646071; cv=none;
        d=google.com; s=arc-20260327;
        b=VjrGleJRv6AJSB8/988jhlglQQEsT+ibOkpz/h4z6upGmdwxUFPdF3FdfsoCzy0Tmk
         wZdXMI/L79ZIcew+yCOvRKyMkcGb7Cuhw9XdoRmBQX0tnE5nuS0OsqKxzvc4fOtAkBIc
         mGUlW1LKfwgm3B8Nyw5fDUj1DREpf67WGVsMiPUv+3tRSW7nNa9Bki18+3OEtUjtWuK3
         p/4XGVrSSfz0iAsV5QzPOGM3uVsciHUcCesDa8xWDYH4i1yeclwWf1dVUDO3Sz0hv4Wt
         c0PXOb10nHyrcK+5urkGIpp3afxFJEE8Udoh5uQzBAlc3UiDj+YgCl+RrWJzic5QlWrk
         aWcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=h/Dfh1yP/dbpR38H0TxYQT1BjjfVbskJsYAFPcy6FdU=;
        fh=vlXzMLCZTuHrnXfu0zIgvkmVgESdZhDw/EmOtg0SIiI=;
        b=dvE7J0NBC5vtCwX4TrJlQrKjqsjSQU+prsSWhwBPmnmzVaonBZEEWk4H9aIqTLxbNz
         d6nuVJu7CG/e403r3xdbqRKCFxEGFQtx4I3gIe+q7Z9xpQ68ApHhriMA6rdUioEPdZu3
         kBq2gsoM/eoo6wYT6praql1ZoiFVfk0YZ9HxrCxQHKNWmd0SBrsWHGhxLSfONQ8iIpCt
         jGAmSyxQ95Be6uzZvBB4uFGKkjHrQ+IaSMVxMulVKdp5t7x0K/zhLPIrHexHFuqRljXy
         cWgObKfNRE6FqRgC0u8zYEdaKyJsIQmXjCn1oZ3obQU7p8+SFmWjsQtbDkpI5ZSmsvEi
         r9LQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787646071; x=1788250871; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/Dfh1yP/dbpR38H0TxYQT1BjjfVbskJsYAFPcy6FdU=;
        b=Q0qVHxL/Xt7oxrcSumONXp5cAU6p1XBpp3s9/r+cqLLvSaHU43XQ4khThcMrCH42/Q
         JzlWWpd1kk9XP/9tBHxKSbHMx2rtOkQoZWKpznulW7wlv426ye21OPwXxLELbUbBHY5M
         IhPcEw1kZI+6AWJneKftoAYo+f3iOU2qhKOjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787646071; x=1788250871;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=h/Dfh1yP/dbpR38H0TxYQT1BjjfVbskJsYAFPcy6FdU=;
        b=EaxAnETCp7CDs6Xn6NQ2dqWt/uc7seiaORZqNNaoHS0SIUI9th/PiARSzYWM76PlWC
         rMaxxhtHA4ccbG5DoqY2a/nULVK0w+IJfnwIFj6lNZ4Sb0c2YIK/trNVhRyr910i2qed
         kqwn2/IhNnm+sIqraQ+iiTaBSZh9PWNVXvOQHcA+Q3BgiCwdZzDWkKGipCxWTtNEyRqq
         /tTMrt6JZ4QvjDeebi9qI4pSXOK7NaoCzvoc/VUrwFX99uMRJZa5WOAbl7Tns8KbZwh9
         D2zAWLN+e9EO/IE4lw8zga0Bpe1LOWnC/6fG05NaT/vnUT8Hln89T95ZAiwBmC8ZVHGm
         dlDQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRwTWDTTCkLXY+SBepyjAQQtLPB5wBkhidfCTdjqZhtEJxnw4pje2J2VwnD2/G6NeuUE/cKS1OXoIg1wXa@vger.kernel.org
X-Gm-Message-State: AFuF++kW45eScNZu6tbJvwgBR1b/+p6zzxwhaCsuk+BwReX1Mwkik7dd
	yszoG53N6BWpCD3G7zXpHRX9kEx1uAd2R7sp+gFWAS7GhzEsXR0wjerWtmpEHFCpMLUwxPnyoD8
	S9V8pw6I5RMsEU4wcJCQKzxm4+DG/l7oAK2IsXxUQ1Q==
X-Gm-Gg: AR+sD11oFSYzXqoNMHBNDZQXHrp/4X1ZsnwCjE+HG+D0HK/bXE+RDVclzmINP4bCPLs
	5G9cZWevRJUJEGmLa5XdVu30C+CK4u1eqDd5TXsHFZcy+U99SGicAu0rIj7fvYLnE8frMnARe0E
	RYxVBV+HH92jP4MhPkLDf6m5hoIP72Is2ExopAsSyXjSc2bIvMsneAMOOv6v7DCBNdg6ZRdvOkt
	tQmSxuyJRu45ReyVNCfWMyPYbUrAO6SFBuoK5r8heZv495a8k5b2dn9gyqqGoehHc0hDTeZfQ93
	k63ZI4ayQp10ITvTAfr9eFes77CrVbAeaIA1x/ITNhu/ISt/FCeDtmdZ1Z1eZwJT5J4cTbNpHeV
	LX6bU+NM6pRGLHA==
X-Received: by 2002:a05:622a:5c07:b0:51e:47a4:4851 with SMTP id
 d75a77b69052e-52e2f05e2b5mr58533261cf.8.1787646070711; Tue, 25 Aug 2026
 01:21:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxhX_neohTAjZDOT0oSWC-JNiqNWqnfE5YSa7Ln05QPQ-A@mail.gmail.com>
 <20260824204534.1951414-1-fahad@codepure.com>
In-Reply-To: <20260824204534.1951414-1-fahad@codepure.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 25 Aug 2026 10:20:59 +0200
X-Gm-Features: AcwNN1Wyja_Sfk151tzL1ijvvilYTKKAzggc0scqSPguVOvNoswa8jrEVndIrBY
Message-ID: <CAJfpegvbvmznSSdjZH_XqrGZHWgwb4fGux80h02ncopBC48RqA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fortify ovl_copy_xattr() against underlying layer modifications
To: Fahad Alharbi <fahad@codepure.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Aug 2026 at 22:47, Fahad Alharbi <fahad@codepure.com> wrote:
>
> TL;DR: your patch fixes it.  On v7.2-rc6, FUSE probe LEAK -> NO LEAK, and the
> unprivileged tmpfs racer goes from 78 of 5,000,000 copy-ups leaking (5 of 5
> boots) to 0 of 5,000,000 (0 of 5 boots).  51 of 51 functional xattr checks
> unchanged.  One behaviour change worth a look: under a racing lower fs about
> 6% of copy-ups now fail with EIO.  Tested-by below.

> Tested-by: Fahad Alharbi <fahad@codepure.com>

Thanks for the detailed test and analysis.

Miklos
