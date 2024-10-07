Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6145318A6C3
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Oct 2024 10:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728297485; cv=none; b=OsJVzoSSwRCMEWZX8xjPmZd2gSEKK//fbw4pysgqLSJXyhxCHF2kr7eS++nMSQc2FvOPDmsgYclomERVk0h015ZwjT6ETxAqDqp4oz0MHYUSh07wG1HPqZMlAXZb5OWuo7ANZmzdSmruHB3dhLpziRvzzTFc7gcG71zwpW/qr8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728297485; c=relaxed/simple;
	bh=KcBXz/uybt/pMRpBba6VfSlLw6yHjpbs/Xqzmttq3To=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FYz1RHwNXzyGeX5v10oz2l/kornSUUhy3nn+ozPwtj15EyNWoCsCCBXVv7Aw3kyFxEIkWlD7W2Z/2DsF1tXn4ToMJsfaC4ei2qeVh/e8RT/jLBJu9krQrw4BN2iW1eEeJSQMsvDbxy6UBN5eFOsyk4rbJ/cg9wQ/AYx+3D14gOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=EOy9DKHT; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="EOy9DKHT"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8d6d0fe021so736885766b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Oct 2024 03:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1728297483; x=1728902283; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KcBXz/uybt/pMRpBba6VfSlLw6yHjpbs/Xqzmttq3To=;
        b=EOy9DKHTxwnf4N3MAUqJH7OWBYtjjVi9VgV+eAqTkjRY7AiyREDxuAcg5C2Wf5z6h4
         duBEjooGLAiRp7F9dRin+u0KgCnGJ/TeMm3sTDWm6mvbtPyp2OTUsIEPnZRjYJU/T4G3
         qjqykztqUS2iZXsVPkTrO+hKd6va5MlUi0ZqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728297483; x=1728902283;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KcBXz/uybt/pMRpBba6VfSlLw6yHjpbs/Xqzmttq3To=;
        b=Z5b6chA9stdDHWCxdvr0GxDtX8pjA31/bb42gJD9dcq3rwVAdwQZsbo0VGIJGmASe2
         UMDnJtkoinxIxPojb46XYAV7wQYxe0DHZnaTwKNuoeypmH5oQBI/7XM9VlpZtKuguqcY
         XDtLzWg2ZQ4CGgSm6EGKjPi3IOrFB0F+wJyN3FXP9ZGA6a2nLqPByQd7NWpFTL4s6D/m
         8jqGjlqWzDAhLDcOqruk6feqjVIC+htVKXIcqyncnGi1IcIjakSx5QUTEzEazO42Jsi1
         3byCCsl794jZ28U63ORUoa7btoQvpxhWj72WUgcItmnh2nsA7IkfGubBleHfjnxWCemf
         6ARQ==
X-Forwarded-Encrypted: i=1; AJvYcCXoLwe2aqKndhYSmNwDWo1hPUt3om9DptZF5aZiB9/4zJ3/Ksv7OQRZcDAqHO8T0IAaN4cVq8Tx13h6I+yr@vger.kernel.org
X-Gm-Message-State: AOJu0YxZjyYr01nJda1HAa0TPZ3/XXshDU8u3998j1o5nNFYKz3va88G
	978XtHvYR1pXm9huaTs3RV5SMFr0rYoZo+sqD5URhUjbBCmDbBM6pc75d9u9nZtWFr6qCKC15gQ
	CdzrfUBa+OTHADEyeuORS9Vn9fFHtGIiDhlBPcw==
X-Google-Smtp-Source: AGHT+IGpyxoLXtigYDI7xrLRQKKXT426ZiVy9y7DfppHasg9YE7THH+uCYZsoPmIVI7wzdg224iFIcDIVEtyX2QLWQ0=
X-Received: by 2002:a17:907:8694:b0:a99:3802:1c37 with SMTP id
 a640c23a62f3a-a99380220f6mr785842366b.20.1728297482810; Mon, 07 Oct 2024
 03:38:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006082359.263755-1-amir73il@gmail.com> <CAJfpegsrwq8GCACdqCG3jx5zBVWC4DRp4+uvQjYAsttr5SuqQw@mail.gmail.com>
 <CAOQ4uxjxLRuVEXhY1z_7x-u=Yui4sC8m0NU83e0dLggRLSXHRA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjxLRuVEXhY1z_7x-u=Yui4sC8m0NU83e0dLggRLSXHRA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 7 Oct 2024 12:37:51 +0200
Message-ID: <CAJfpegvbAsRu-ncwZcr-FTpst4Qq_ygrp3L7T5X4a2YiODZ4yg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Stash overlay real upper file in backing_file
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Oct 2024 at 12:22, Amir Goldstein <amir73il@gmail.com> wrote:

> Maybe it is more straightforward, I can go with that, but it
> feels like a waste not to use the space in backing_file,
> so let me first try to convince you otherwise.

Is it not a much bigger waste to allocate backing_file with kmalloc()
instead of kmem_cache_alloc()?

> IMO, this is not a layer violation at all.
> The way I perceive struct backing_file is as an inheritance from struct file,
> similar to the way that ovl_inode is an inheritance from vfs_inode.

That sounds about right.

> You can say that backing_file_user_path() is the layer violation, having
> the vfs peek into the ovl layer above it, but backing_file_private_ptr()
> is the opposite - it is used only by the layer that allocated backing_file,
> so it is just like saying that a struct file has a single private_data, while
> the inherited generic backing_file can store two private_data pointers.
>
> What's wrong with that?

It feels wrong to me, because lowerfile's backing_file is just a
convenient place to stash a completely unrelated pointer into.

Furthermore private_data pointers lack type safety with all the
problems that entails.

Thanks,
Miklos
