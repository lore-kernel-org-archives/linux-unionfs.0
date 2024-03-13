Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411C34409
	for <linux-unionfs@vger.kernel.org>; Wed, 13 Mar 2024 14:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710341253; cv=none; b=KynjJbGgheUeqlO71qDJhujKe37LVpih8S3EsFO6UbWQJmx++e6fuvAd66AhrZWrss/lcqHfvQ5OS4idGywkMh3NX8mQ2S+MZ/iVAxzS2dQxKs/Q4mLlgBIZk6vRxpDBItb8P/93O6qMCIjEn+SuWM7iGisZ75yz6s5rnpEAw2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710341253; c=relaxed/simple;
	bh=YzkqaXpaFRM8RtDzrlCxHkAAJsnVwNrP+emQe7yxPRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YD3hXIm4ARAJDDWxbms1mo2Pwsg24+9X84qPvmZNk9ui/kzrKRYydB+etnYDUrTAKBVWpg6Qk6wyy02xRUE34b0N0xAWHP50UZdmhBpuLNLuWVJmj1iDEOyLCa+e8Ec/MKDNqpNUPD+sCEqnfOXnxLizPf3v7iqF9g1InQglUPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=KyTny1Qe; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="KyTny1Qe"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-55a179f5fa1so9044708a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Mar 2024 07:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1710341249; x=1710946049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YzkqaXpaFRM8RtDzrlCxHkAAJsnVwNrP+emQe7yxPRQ=;
        b=KyTny1Qetg1Ps+MEj02fDBNNLtgHg08VT7H6QptZkO9h/WejNlfrmCU6tEjUe7hTcL
         YK2uk7DLv16Whtgmb/qCm9aCmQPcNjw7J/wd+NuHoxGoWNde/Mt8wzLhnYWZu+wyvPYD
         o3Kz8s9OZAx9rVycrjTucbMP1g9Dt9L4DsEno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710341249; x=1710946049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YzkqaXpaFRM8RtDzrlCxHkAAJsnVwNrP+emQe7yxPRQ=;
        b=bW6uAO+zrtNwNUH9cMHxlfgT5K2jBeZfzRS4sTo7XuF+HYjGGKe4D5auMGGnI/6ycj
         qO/XBDshCT2u+WCSTNJYxyEC7VzECNc0yahKN8NgU39nypWtsf10X45cF5eEiuabCOyp
         FAMTs/xXY93EIdgQT4DMfPUXvjSjkUUewKw6+QOQeJZGkcnSN8atbe66YMOba/LpXo74
         N6SdBPi3mhIW2N1AliyqrZ5qfuqBOIDkNsvMoJAUUFZdstWgKUw9G1OtVqGG0/YQZfgZ
         GnArCJNyHWKvOxiZ3E1jkhxb42Z9LRvOersaXJvnK13gbqrWrCRCTuTqIJjkadM/hTkP
         ynIA==
X-Forwarded-Encrypted: i=1; AJvYcCW0LVztZlfY0fR0TVZhlECtbOwgcmqUhdhM+ImqgxCwhB6pZ60shaIbp/wjozBYRZtm9lcdyAH7O/JlMpWtJPE075D4rkAvBWyR5gpmBQ==
X-Gm-Message-State: AOJu0Yw27it4P8xn0rgOTfL6xW4F6Bamp1w+U7y6Ajy0jUe0UIStJdb2
	d/dG+1r4FcXZKnyEJYOGavo9LrpPR0RrbHQB2OjMkbQ9EIT2VBGJ9TRQzq2OY22w/mfyHr0/ohY
	lkt3HWB97fWdEGCAandyM7i7ZlF+Rkc8X9Sq88w==
X-Google-Smtp-Source: AGHT+IGySR5X6+YUZKH2Phuq/Y7qs8aoKb13avqzeIMqppT7+EeSbdOV2V89Z2OfDgsEw2J1JOH6R/o6+3Vdsa68KFA=
X-Received: by 2002:a17:907:972a:b0:a45:f4c2:38d7 with SMTP id
 jg42-20020a170907972a00b00a45f4c238d7mr9051453ejc.18.1710341249573; Wed, 13
 Mar 2024 07:47:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <03d7a29c7e1a8c5741680ea9bc83b4fb40358a25.camel@elektrobit.com> <CAOQ4uxg+RveBHjgui_HjCasYGor3JNeuv-UroR=5j4n6TgRd7w@mail.gmail.com>
In-Reply-To: <CAOQ4uxg+RveBHjgui_HjCasYGor3JNeuv-UroR=5j4n6TgRd7w@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 13 Mar 2024 15:47:17 +0100
Message-ID: <CAJfpeguBfKB4MGEUkJ=+ZFT9uYJ1DXtCTW9oLrEE0af7XTi=VA@mail.gmail.com>
Subject: Re: possible deadlock in ovl_llseek 27c1936af506
To: Amir Goldstein <amir73il@gmail.com>
Cc: =?UTF-8?Q?Wei=C3=9F=2C_Simone?= <Simone.Weiss@elektrobit.com>, 
	"linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Mar 2024 at 14:14, Amir Goldstein <amir73il@gmail.com> wrote:

> The reason for this report is calling llseek() on lower ovl from
> ovl_copy_up_data() when ovl_copy_up_data() is called with upper
> inode lock and the lower ovl uses the same upper fs.
>
> It looks to me like the possible deadlock should have been solved by commit
> c63e56a4a652 ovl: do not open/llseek lower file with upper sb_writers held
> that moved ovl_copy_up_data() out of the inode_lock() scope.

That commit is in v6.7, so something different must be happening on v6.8-rc1.

Simone, please send a new report for v6.8-rc1 if a lockdep splat can
be reproduced on that kernel.

Thanks,
Miklos
