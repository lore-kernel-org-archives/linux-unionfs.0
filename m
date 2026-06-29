Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29803349CE4
	for <linux-unionfs@vger.kernel.org>; Mon, 29 Jun 2026 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782754283; cv=pass; b=RUQ2sfEsZjcgEDjLAIbJK5po1QouHZ0PEslFC9NYLlzEFuZNZOaSGxCw95ZXb03b5hqujQzueYNR6wx0fjTu4uoBiGUqAFxU06fzxSWUiGCYlW+wGfaj9YH1pBvjj0u8rf7MDWl9H98dWSh7pIT7P7pe+1xkRbKJdl7NXK7DnlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782754283; c=relaxed/simple;
	bh=eOClBfv6lfdCI5t+K8NOrbjIYwBgmecurDoITjBEbHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lRfUegwvW/USS2VWOwqlTkbVx7mmOEzDY9k7CTLGpZC4f4NJWae6KchMvsVHuxRpPC8FCzG5N8Ug6DXF5hRyMlw3YQnA0ItLaerHpD8xbrq11kW/mUjvYhltGL6oUdrchlJi8m+JIXnJUEJmmUwwT7ZjXmARCSUEXUv3LRM/Q+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOB0tbQz; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOB0tbQz"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69857dc1d5eso2962013a12.3
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Jun 2026 10:31:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782754281; cv=none;
        d=google.com; s=arc-20260327;
        b=VSXWT0gM7nwQGHDnHwRBMnZ5UABtEsgUYbAn6mCJBnamJtCKrH85XBVtk/BuVfyfko
         q9+BqYC20jVmX6ajrb/5KmRQBoFfZ8BCWhYC+ow1fgF5eP0kCZwum0P1bmlcyGTIikTf
         7g9GwE0TBP2MSii111jafY7bJa18NcnyYtNAJZ19WOJdMq2ozlqAyPNxBeZ7tEZRiHrJ
         vas21hTbZh1gQ3sE9fjAVHTVln+qnDowd4+J+PraUGajtJtnwJ28TZTEb36UO15a6Pun
         6rq3Wmfpju4cUFTFbtAflZezrSlJZLRioeCyQgQiTUv/789sIRicKxEZswc4qM351VoC
         uoCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eOClBfv6lfdCI5t+K8NOrbjIYwBgmecurDoITjBEbHY=;
        fh=xuGsRfiSYl7dEoeIuSV8GajeiAXFjeqyuFeO1aJIVkA=;
        b=k01ySXMLZAROHITjjDZuJQuKVAq17bodU7P56A8IArSXSGsAHFJ2mLAeUkhEhAu2Lz
         s9NYs0H27dRLlBD2lK+tZE6RtKEAaK/vRh6+Bz3anjfCZmqDKbZTpGMJ1cVN4iMlM+UO
         6G9J/F6+8tl5GeribcJ/KEFSeRUT5Gj/HuK7wltLwNGY5NjlGceVp+k7RR+1Vg/NaaHn
         P3+ufMO/1ZnxLd+mSrjpdSFxkLP/j9Mj1fJgkXFjDjh+5CfMxO3oyizd17dRVq7P5PEu
         s6moMYxgXQWrH60pD4ibKSAA5Gf3PmoyH3TfNVTP7p7syv/npDUY52yX/vl+qWm27daE
         ntlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782754281; x=1783359081; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eOClBfv6lfdCI5t+K8NOrbjIYwBgmecurDoITjBEbHY=;
        b=VOB0tbQzXHx225/eBRLGEzWz6vX02N24U92aDSCNpfdq7DZv9iI6NGkOHF5VJSXBf0
         iZEHeZ0V5mC0F3hIMX5sla7sCwE6QUNe99CfMZz+3kF02NmreX29GtPeIhhn9/tvERdq
         6rIHJEfwGNs7g3Qtc2MU325nY7nvEWm2h/9qTqpSpa6S67zweReqCilX7ZHuwu06Afw2
         Tp0haJ2b/3LKr4BGQqiyRCz5NDX62Jd6SCIPaTHgyHwtVcs9J/8SW3WLPHp/mOLeDDnB
         HbauBnc7gNry89jY+RZ4nsQ9ECd+RxPZvUBef39i/RgCTiFo8PTy4LyUjrjbVd51dDKN
         dcww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782754281; x=1783359081;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eOClBfv6lfdCI5t+K8NOrbjIYwBgmecurDoITjBEbHY=;
        b=rKC+KArxFCse7acgsaneYiKA+T1wZpMdG0LRSzV8UHH2STYtW9CYMt3cnYyli0D+ty
         9dU1J/q6OyXkKj5NaI9E8AHtDVLGiTBZ6ngOqiPmOR95fCuu3rol45jdzNmPJZ5xW8RS
         IMW/E4WUIVA9/R9+G+WcqmCsa5U4/cq1k+yYSm4s+33bsiZ0q6tSS+862mDvpY0g2DgI
         xYI6Fb6OdaipLrzUBaw5UD7Qa4NRZiY8vPEAZLlNJfF9Uryjx/OjTeRkJPXnFFOk/tva
         RBtbOekUbYxo/ycHMwpdyhPc+EyAC74f36VA6AWA3deTiH/8ugHKRddGcg3ZcHLt5rtW
         y34A==
X-Forwarded-Encrypted: i=1; AHgh+RoScFoSBURFmlegicvv0DPgEEIZnBc4PdjFw7Mq1ejaOpUZGViW9JS0fQjvFN6aSGk9u225ja/C946/xZFC@vger.kernel.org
X-Gm-Message-State: AOJu0YxM3LxxFNBt8w/4kP1BS8idUG+v4MUzXBUcszF/M2ZsywqwXrS3
	iGopTL4VFQC4/9yntltKl+EXTs54W0JVWp4SlwJ9lJuPhmwZ4UywtE3zZbK5w4D4VebDUL+N3aE
	DdF6TQCubPzA9cgSQ8EJQYfKD3wQZ+t0=
X-Gm-Gg: AfdE7ckfz5J/ywvcOLuK+P5Ms7tbQbb7HQmP4SX0b/+aQrWvsIuQMb22JhWgXkzel2R
	0iSIgJY12Wq22giktsvlSOtJhNgrorVFViFcpdLPIP5M3VU82h//3uNOGlqHKOppBfFNjR4QgDO
	teZhieVavEvwRZUFg4qFLOtnqWX9WbnsL8HFlO+E/dU3Sv3O2p23+Ga3CuS7kswlvfUBTaGewvN
	5Edka6JSi1wsus7Y2gZjE9TxfBZGHGLwwvebCZzMQhD3mxpxyqi+lUu+h4b//EcsQ6X597H6C++
	JsKPIkbpGJuF9ItqtRio17wBFMCb6c8=
X-Received: by 2002:a05:6402:390a:b0:68f:cc95:8c10 with SMTP id
 4fb4d7f45d1cf-69879e4b974mr46982a12.27.1782754280332; Mon, 29 Jun 2026
 10:31:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629070653.580879-1-caixinchen1@huawei.com>
In-Reply-To: <20260629070653.580879-1-caixinchen1@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Jun 2026 19:31:09 +0200
X-Gm-Features: AVVi8CfvDZzdzYVHdraWAewZEFEyCZ6yZ4zu-tcKsdp7diMSLlszm49WqjY_Vvs
Message-ID: <CAOQ4uxjcD0-PHqqmrpEvkLRgtKJGe8-n+6DQyBngjN2TorwU+g@mail.gmail.com>
Subject: Re: [PATCH stable/linux-5.10.y 0/7] Backport Fix incorrect overlayfs
 mmap() and mprotect() LSM access controls
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	miklos@szeredi.hu, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, 
	stephen.smalley.work@gmail.com, omosnace@redhat.com, 
	gregkh@linuxfoundation.org, sashal@kernel.org, bboscaccy@linux.microsoft.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org, 
	lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2026 at 8:38=E2=80=AFAM Cai Xinchen <caixinchen1@huawei.com=
> wrote:
>
> ackport the patch series
> "Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
> to 5.10 lts

Chai,

First of all, I don't think that stable maintainers are picking backports
to 5.10 that were not backported to 6.1 and 5.15.

Second, backporting backing_file as a dependency to LTS kernels is a pretty
intrusive change, so your description above is very much lacking.

Please do not backport backing_file to any of the LTS kernels without provi=
ding
detailed explanation to try and convince the vfs maintainers that you
verified this
bacport is safe for the LTS kernel, because honestly, this looks a bit
risky for me.

Thanks,
Amir.
