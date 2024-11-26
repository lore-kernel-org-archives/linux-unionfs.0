Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938283EA69
	for <linux-unionfs@vger.kernel.org>; Tue, 26 Nov 2024 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732637073; cv=none; b=lipJNBiT077WvKODPAuc+8EMJKqKRnteaqDMwjT9lbwTubxmBpJ5bb4x5iJt6t/85HuIH0vkCvTJBf7qMLBsVOnaKGxFrtxe5yfZWwJKYGNay5xFo7Ofo6B2E9R9NkZDyZBe+H3+4eadMQMJsaVyQqwvhbbR24JRZ13nQKMzeyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732637073; c=relaxed/simple;
	bh=AKSDaqx/4etPljZDMYK33mkBXajknuN6+uRkb/9oKtE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m7T13LEX1oA8wBtofvAd6MoSlSuSdv0ILBpB/PGnkpPgO61gRetj6WVUFBEDRLu2EBbthQoKTB2crpvEZjWRQr96ebv7nGALoguf9LSZ/9X/347tGJULdSGUDEjtkXm1fDUOr2ubwH7Kqa967yN40VNqfnN5mpahk8WM6IlAas8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=DjLmNYfg; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DjLmNYfg"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4668978858aso19712941cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Nov 2024 08:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1732637069; x=1733241869; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AKSDaqx/4etPljZDMYK33mkBXajknuN6+uRkb/9oKtE=;
        b=DjLmNYfgBp9eXmZ0IpkPAwPJbOrm0VOoPfMEPjZgEOYaXq9qmkSErebO0i6jtgXLiz
         4X1FYOrv2TFPxLAxjJygJ5DdCAW8pDDWl8Or6SzJEO5gdVedCu3ppxHEl9EDTVIFnqM9
         Ii2bnliA74K09rkY33kDh1KStXTvp6mz2X7LA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732637069; x=1733241869;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AKSDaqx/4etPljZDMYK33mkBXajknuN6+uRkb/9oKtE=;
        b=K1Qjwa35QXzlKhL53UXkFrc+arC5mWAQ7lk1XwlMug9MWISmEIvoQeK2reF5h24pUh
         Y35XaA6Ry/HtVQte1etSnOhkyoOewg8UpdqNIVA1TLJ3WVgXqBIy6c94vnWoV0GdGSFu
         1Tduq+vgJab6KaJqn9xgejq0h4ccwdbTSej2blR5eliQku/GvoQjwWuimq/TUE8dxy6n
         qP7Fzz+htPc6EtXcul67SPAVleDBL5qUKeotrQlUimaSz+SEabVE98rTs9Au5A0tkiUo
         YKVfcNYDxEeHjJeidW8+KonK+Sk5mSagH7ecUvsjYmnVWwauVCQcokqi3XZlJ/iTovxW
         4KHg==
X-Forwarded-Encrypted: i=1; AJvYcCUzTU0KzUjIvWPRhCL//44ogezmI7VxODoyijz6vUILNP0YtaXo0uJVcSGvCnqCNvu8fL9m+1dntRwDI1MR@vger.kernel.org
X-Gm-Message-State: AOJu0YxO+cQWPcOqLWe8oIaEPAmRevZRCy5cLMpB1IPMx53ImkmhEgtF
	qmhttm5c82IDDNV7TW7i24NsYB/4zG9tuxe12C03hr8cesAMdlRNW165SuDI0i0G3XUtfdoo/i0
	jjXSOPskGaA/mUXMHW2OfDLzC+xWkTplcaZxjkbsH3qS8PSb6OmU=
X-Gm-Gg: ASbGncsTaFSPu3OEstUul15TZSWFsP6s7GFN2h4RCfh35491sQt0imagiIFEkK89SOi
	SiZb0DhFbjFE7dOw36g4P36jdRQ/+6xHICw==
X-Google-Smtp-Source: AGHT+IHZjgV4CkWJV0BjmzxHkmZyvhwVqQFY/zZXrMjjUEuaIMDUaghocl8+HGtVr63vyHCOCtQZlVnlXZB5NV2JqBo=
X-Received: by 2002:ac8:5746:0:b0:460:ad52:ab0d with SMTP id
 d75a77b69052e-4653d5687ccmr242641021cf.16.1732637069116; Tue, 26 Nov 2024
 08:04:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241126145342.364869-1-amir73il@gmail.com>
In-Reply-To: <20241126145342.364869-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 Nov 2024 17:04:18 +0100
Message-ID: <CAJfpegszebgkN+vGJrzPTbdmkebQmAa0_921KSxa2QOTkbaSsg@mail.gmail.com>
Subject: Re: [PATCH] fs/backing_file: fix wrong argument in callback
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, 
	syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Nov 2024 at 15:53, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Commit 48b50624aec4 ("backing-file: clean up the API") unintentionally
> changed the argument in the ->accessed() callback from the user file to
> the backing file.
>
> Fixes: 48b50624aec4 ("backing-file: clean up the API")
> Reported-by: syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-unionfs/67447b3c.050a0220.1cc393.0085.GAE@google.com/
> Tested-by: syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks for fixing.

Miklos
