Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9791A727D
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Feb 2025 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740511608; cv=none; b=jTedrMeOqRuHb7JcZ3+ZZScg37V+1RmClR5rATo42+ZNsk+XGtmW8i2tfdGGBf8mlamgCpdyKbnKDVEwYQ92tyi/oLEfisENCri52BxNDoNJTvkNShRCPNt8Jc3Cjdqmc8+f0vVGRlCXlA+JcmWQCOP9Ikps7UQr8zrrXJ5ryQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740511608; c=relaxed/simple;
	bh=DJlfk6b3RJau9l+w6GknKKnQt/3tbE8gdqZES9yqU5o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cfw3TA820SYA5Mr/daTMZMCoqiVOvLby7lW6bBcm8LkRAMMbuL/p7DYw7rKpZ3/KtsC5jeZIpNZNea4eaCu98mTv0lS2eA/9VT0PUEcJxfBqtFYz8fNSQqnWzy3DdbEze11g6Zn6iwP/tEWKM/+f5QArGbx3com3j/lff8CUDWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--paullawrence.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H4hcWf0Q; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--paullawrence.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H4hcWf0Q"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7272acb753bso5721339a34.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Feb 2025 11:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740511606; x=1741116406; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DJlfk6b3RJau9l+w6GknKKnQt/3tbE8gdqZES9yqU5o=;
        b=H4hcWf0Q+oQQQ3tVXB9N28PRzDtT7eVVDRv1gHV3DZQ7xe6LumpB9/MqchQ0yASsxK
         ly0Hb9Q/SuYmBYIv/YLCE3y9p6G2QUKInZU/RiPPfDLa5f7lHrD6EidAR907TuhHOOBj
         1DuUMpna10vkjNvGgnJCfGwtkodhzlA00SgxvCpN/JJr/ePRn7LbnO1/bg3rYpLnq560
         D86JRVZcCmFBBsZ1ZUlV8Uapo9+4uegNmYLNK36Q0GO0D5ZXSPV/O0svVml6lK0ieMb9
         dZ1fhrCVp8r1VfjjFGIJInlcSD0q70rCkzu8SJShv4FrFXioXz3nV9Xhii2iqZIJMSSW
         dtmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740511606; x=1741116406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DJlfk6b3RJau9l+w6GknKKnQt/3tbE8gdqZES9yqU5o=;
        b=bia2B9xP99ZAn6nQuR5Bj+tUThh8k+WJEiCHd0dSnx+IClo65MPH/FsDxbrWSHMpOX
         aZNGrw1uFODjQZTbS+JQyiK4Xmfx90C1ZRisregULPSjnHpDcRcmZg176lgGvXzv8qLX
         JHb8ztc6fJngKHz5ss8eLPNnqDKDYNIrAuglD8F6LTP8k0iFkO16jckj7aksl8vu0rJf
         pLGkzg08iR7rWdJs3Ti1Ui4OboAcx4ShNgUfuupw8mg+J54tXFBaH/I/JNfjTce8UO2B
         3M9iTRQZapoQXGbI5cn9aVy8rM0DdH25o1H8D1wCDDYnJrUr11d1tmGelIbKcTS2cI1T
         ikiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbKtPBxAwjD6Vf4OFmbhBjzJgBMaRuwp3ORfd+gGfEnJsjnP6ab2jFE2brjAS5sQ5q/AdjLcPicfcJ66qI@vger.kernel.org
X-Gm-Message-State: AOJu0YzSQhhF59XvP4xWJUZjTN/RJh7mosR8sHeAoqdxKbQvnKSv7it1
	FLo2qEYky0BkM79r36oA3TptFWDPcFwSNOHbtDlLU4pSXIefcMpwTTQaPYQcGwA3G1CCV2OHDNe
	6r7xkdKi8j9xhJK7aqGQOFNDiUQ==
X-Google-Smtp-Source: AGHT+IH42rZCjQxhtGaX41R/FygdO39bmt4VMVb9EHOMyqJQj1A1hd9V5S6V3ciDnhUFtYvqHYTc4Cmq0ZkSclZIm6Q=
X-Received: from oabxl3.prod.google.com ([2002:a05:6870:9f03:b0:2bc:6c19:c219])
 (user=paullawrence job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:2701:b0:727:26ca:bd2d with SMTP id 46e09a7af769-7274c184410mr11658399a34.3.1740511606242;
 Tue, 25 Feb 2025 11:26:46 -0800 (PST)
Date: Tue, 25 Feb 2025 11:26:44 -0800
In-Reply-To: <CAOQ4uxhxQfFfrpmRS6tOv5ANVug6d8dGx6Hsc7MYYe63sUOpcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAOQ4uxhxQfFfrpmRS6tOv5ANVug6d8dGx6Hsc7MYYe63sUOpcg@mail.gmail.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250225192644.1410948-1-paullawrence@google.com>
Subject: Re: [PATCH v19 0/4] overlayfs override_creds=off & nested get xattr fix
From: Paul Lawrence <paullawrence@google.com>
To: amir73il@gmail.com
Cc: corbet@lwn.net, dvander@google.com, ebiederm@xmission.com, 
	john.stultz@linaro.org, kernel-team@android.com, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	luca.boccassi@microsoft.com, miklos@szeredi.hu, paulmoore@microsoft.com, 
	rdunlap@infradead.org, salyzyn@android.com, sds@tycho.nsa.gov, 
	selinux@vger.kernel.org, vgoyal@redhat.com
Content-Type: text/plain; charset="UTF-8"

> As I wrote, this is one specific problem that I identified.
> If you propose a different behavior base on mount flag you should
> be able to argue that is cannot be exploited to circumvent security
> access policies, by peaking into cached copies of objects that the user
> has no access to, or by any other way.

> I have no idea how to implement what you want and prove that
> it is safe.
> Maybe if you explained the use case in greater details with some
> examples someone could help you reach a possible solution.

I'm going to wake up this thread one last time to lay it to rest permanently.
We have now reimplemented our use of overlayfs to no longer need these patches.
We will no longer be attempting to get this patch set accepted.

One issue - remount does not update the mounter credentials, either by default
or via a flag. I was able to work around this, but it would have been much
easier had I simply been able to remount with new credentials. (The specific
use case is that we load sepolicy from a potentially overlaid partition, so the
original mounter will always have the default kernel domain, which will not be
suitable once sepolicy is enforced.)

Is this a design decision? Would a patch to set credentials during remount be
of interest?

Thanks,
Paul
