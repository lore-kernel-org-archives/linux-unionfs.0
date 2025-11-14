Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28763302142
	for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 09:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111848; cv=none; b=Ss+F/zJ+Vk5EoOtCMrWUhRnqOn528B56KRXBFX0Q0n+aq+s9lgCnUsN1JTNy7CBvtLqtn7Y6SDMDpyvy67cNcUDUO2dXgkQY8JeySBV2T8cOBIM6T28d5DYOJH82H3VXCmqQLAGG9MBdc5nzvN/T0jvfSIybxiw8XQC+romEzOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111848; c=relaxed/simple;
	bh=yVjn14hRc0zLgUPyS7tqsP2wnw/220J2C1mbkzIbF/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNsKD2U//jXyMimfgK4t2DjglXXpG0ri+v6OqjDHtTiC8IPUEkQGHRZgiSCt0W54iRA+dayftZEYIFoXuP4CnqAqNKNIcaYf311y1UOr4xuqNCrEB0E9yQiSeKY5Zuuifd9iwi6ARWeqhkwdTbYu9GCuMuUk3gwXr0BrHpl2Br0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=AucJZ9d2; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="AucJZ9d2"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-880439c5704so15228176d6.1
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Nov 2025 01:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1763111846; x=1763716646; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lIvYmA/du4PJt7TXtL9a+/UDS2TXYnXG/gcmvhqmkuw=;
        b=AucJZ9d2J/zMBf1tUB030PI7YBPsczcQ451pNyDbG/vGUBCI3lNcsTTvNMQHNKR2xv
         qWAHupRe5m5YznmOyum3aDzjFKa84iW5SrYbp7ibSv/YMLT50McFNSkM8uwiZtd3pZum
         VK54Z8A8m5RI72qsBgSNEFxGnYURgPh9XlA4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763111846; x=1763716646;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIvYmA/du4PJt7TXtL9a+/UDS2TXYnXG/gcmvhqmkuw=;
        b=qQEbnV2Y55+VaylpyHjmJ4Sfkmvzb7KeUec68RAFHtX7LgjYPABpiKD/pWhJ7B7PgX
         kD53GfOUOJqUBNx/TDHbe11oh3MvFqEKxHWw7c9bvAI28W0ErZkJXyZZe0yqdCHtc1Ap
         e2U6eRT58NmRu3qwnty4HYv2DPK70UB8DikQwgQHGNMdd1xzAyxjI8pRr8p9cTWSl57J
         C/nCfiJemwBrmYsCdnUQjSPbjJULdyCDPTJt+7D4+qDi8d4/30FwD9vDiQFoS+mf6JTi
         bz4GZc5TPTOmj2Wd1Aj1xvD8VnDnUxyFTumsitWVXzITvL2+BNFe55OvPyWfWzdp2+j0
         IuxQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUWVPuj9FM+nCXhuLXYErLLxvML9dTml4Jh12gt3dBcISwoZHc0iztWCtfxkkysFJCL/MzUc56jUSmSxQ5@vger.kernel.org
X-Gm-Message-State: AOJu0YwOhZKlfaZGAEvCaPKWOmg+2kJW0NNHbu39mPsGKglJTfgFpcxG
	jPariPqdgPkX12qzMaq0zxzLHgla51xSoD01f72Z9xoR3XdNwuwCRLz7UN2+YxH4EdVanS3Q+xN
	pdMpSpCFrb03hPnFW5GVpQWlObe5PeVHcc+njq+HDAw==
X-Gm-Gg: ASbGnctFsy4GTpVrJ9EKXd++fjGLt8dp5/0jF2IXj8Y3Hr3j+Pu2ZFnWotQa0d26t0Z
	jb2pBd1mZNavJ+t13I4gYw7P8AbVcDQ45wnx1ck8/mwvmcs7GPjTBkCCNYGjvpr0iRVK8BZ4aEF
	KhPCGc3BYPRAnh3pk0acJIrJeR3Q4h+l9btwjFAl4mrL7qAisd+9ZpfOyDcyMUDE0qo9CM02N3y
	zegV5e87Uke/CoHglHCaPeebe1cqRm7ocBpU5piJkCUJKLm8a395fdctMBXMXujiC48z5T1oDdx
	UDcl72+TGQO4+4stAg==
X-Google-Smtp-Source: AGHT+IF35lQc6cvZYyTFqaULQPRQPCggm7Fe1u0lX/Pdbrb+qT6IM4P5svjEZIkD3i4lt7DqKsZWBRm6WSfKmIjTII4=
X-Received: by 2002:a05:6214:1bc6:b0:87c:2c76:62a1 with SMTP id
 6a1803df08f44-882926ea561mr26613826d6.67.1763111846113; Fri, 14 Nov 2025
 01:17:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v3-0-b35ec983efc1@kernel.org> <20251113-work-ovl-cred-guard-v3-34-b35ec983efc1@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v3-34-b35ec983efc1@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Nov 2025 10:17:14 +0100
X-Gm-Features: AWmQ_bmTpzJ1seBmeJtiIFjACoOLyUexdpxjEOTaM71cwGlCVS6u5IP90qgqsi8
Message-ID: <CAJfpegsdtHgiGFi5EEjaN9but0A7VTZA4M2hSg=Q7ynAozhqAQ@mail.gmail.com>
Subject: Re: [PATCH v3 34/42] ovl: extract do_ovl_rename() helper function
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Nov 2025 at 22:33, Christian Brauner <brauner@kernel.org> wrote:
>
> Extract the code that runs under overridden credentials into a separate
> do_ovl_rename() helper function. Error handling is simplified. The

Hmm, it's getting confusing between ovl_do_rename() and
do_ovl_rename().   Also I'd prefer not to lose ovl_ as /the/ prefix
unless absolutely necessary.
