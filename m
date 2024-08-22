Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8133E1547EA
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315493; cv=none; b=AJyfuLuxmCVQcCOx1bLtEtrHS38LHCCow7nsmsN8deJsQsxqQ1q6rwsXqmgnYs3yGpFGqfC+VskFmMUSXU8CiKd5e20z8VhBp9IdtLhXkGnYxdK5XRhEDI49BxSYIfp+laIR2jMTCrYaLW877oxjK/DdPqnm9Vj2nSwTo/3DZ4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315493; c=relaxed/simple;
	bh=qfO68ABr8YmkVT3Xwko9ThKTkCQPRAKkOQzFlC/guPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rSQFC2YJOmZM2iMk+2Sd2urdK37Zbt+HUMIfBULnTcaEVFtY4EwF30clKnoz1SCKVe4J3bAF1P3fJaMsiHvMcJScLCBGXlKehuakZlvCr/gG1iHxPNSCROFeyopd6SB1iFyxq5p+N0fxN8hDRyII1ncj0CWtfoZA3FSjYnL8ryg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=d6UcsoVa; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="d6UcsoVa"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e1161ee54f7so631681276.2
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Aug 2024 01:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1724315490; x=1724920290; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qfO68ABr8YmkVT3Xwko9ThKTkCQPRAKkOQzFlC/guPA=;
        b=d6UcsoVagWmOg4gMtyyrnX4ashxi+QonesqW/lWQrZQaJ3U/jyzdz1puaNu0MvuPao
         AyPTazPWZRwDP+l2FDG/+7q9R1SOHQRb2cwfvKTvBjKOM6QpK96ZK3Ac6UDuBNc8lPMo
         AM66VnB3EjJu02kpOv5CHM0TZ594YJAD8O/XA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724315490; x=1724920290;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qfO68ABr8YmkVT3Xwko9ThKTkCQPRAKkOQzFlC/guPA=;
        b=iixaVC1nQHCrlclyUn6MQbHrBWtq8N/NtKz7TulvGpf6AiOVm46Te8kTwj6C5gT/Mu
         tj41Xe0Lan5xjz2XWa/ahY75B3b817y4+dZ2PLLicWegWKGXB8QEKeDeBJtIVu44fL49
         NbKtxSWN2yvsOib/mitJVgND2cs1ceyDUN/fkqwCoOtvW9UvcAcMSfnpcwALfAPT59vv
         C/6yDQ644LvkU7EkZX46+W2hoqMt4zdX32sp8ty5vac7MOR3hbwO9CchG++tu3hWkMR2
         BYM6VklEVacbJ15LEyw9kLRx0IjqUi40bkp3Mvy/YT7QhJfoW5ZVJotNSCqOv7mKVebS
         RSPA==
X-Forwarded-Encrypted: i=1; AJvYcCUVr3w3C4HN8e7aEPi3LXKItZ11E2/VhO6OIwS7Ufe9EZmZbGq9dhXoCTQhPGPVp2ZLVAiPTrXcuMazUeT0@vger.kernel.org
X-Gm-Message-State: AOJu0YyXgtkQ6vg3fxlze4bolFvJkOZogXtm4MXL+gAViMM8Vr180dXg
	s5RzHuD3WD9IX6iY5/h7fzmr8PG/LXDTXln1ytz5ESb/GdvMK7Vdf1E6a+y9oLUfO3152lTTor+
	QPSjgwSTMEroizss/CLt919ZqC9/OYxxzJ3oWKA==
X-Google-Smtp-Source: AGHT+IFF9x0kcV4O4K6ZspVN57UUPh5M6n3DoRW/LKTTDP4y3eH/KtTeC1NTvVIbWLwiW99ntfIxagBPmHeZAstrCBQ=
X-Received: by 2002:a05:6902:250f:b0:e13:c8e7:5bd4 with SMTP id
 3f1490d57ef6-e166640f1famr6031982276.22.1724315490296; Thu, 22 Aug 2024
 01:31:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822012523.141846-1-vinicius.gomes@intel.com> <20240822012523.141846-8-vinicius.gomes@intel.com>
In-Reply-To: <20240822012523.141846-8-vinicius.gomes@intel.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Aug 2024 10:31:18 +0200
Message-ID: <CAJfpegs5+2DadbB6tfwLD+DAFzqfOTi7bZMxJCoj_r5Tu7jcfw@mail.gmail.com>
Subject: Re: [PATCH v2 07/16] fs/backing-file: Convert to cred_guard()
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: brauner@kernel.org, amir73il@gmail.com, hu1.chen@intel.com, 
	malini.bhandaru@intel.com, tim.c.chen@intel.com, mikko.ylinen@intel.com, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 22 Aug 2024 at 03:25, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Replace the override_creds_light()/revert_creds_light() pairs of
> operations to cred_guard().

I'd note here, that in some cases the revert will happen later than
previously, but (hopefully) you have verified that in these cases it
won't make a difference.

Thanks,
Miklos
