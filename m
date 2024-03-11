Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5A734CD7
	for <linux-unionfs@vger.kernel.org>; Mon, 11 Mar 2024 10:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710154398; cv=none; b=LJYfHxINkSIOpcFkc7xjLq3/lvYvB0uax1m29ltG1RP6qIU3MPypkcSRR14v02egys/+IxtaRnjkHuvmvn3JKyXest8GByygMZa1oQlyT3aUXTzouByxbhOQc7cyURHbChRBv4oaoULje2mvCIv+e20l1wcM2axO08wjpoDsnxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710154398; c=relaxed/simple;
	bh=eipSaXQDNaHiMVilLLD9++N49oSdVIn+KRPI2kRYNhA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RTTiTup53i3xlFKkpTMi4oGXpQtCC+iEgk2hvt2sznxRb7+ayi527xvXGz+jM00xxgXmjAzPnemqCkFHGkA5sTZyqREAFdaSUcvpzZifXw3dyEWyAGJElPrOTFSi7P4O/Eq/rUqCSdrrcIhfc/BiSgy36wMa3VkOOAsOi/5YlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=nb3iegMu; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="nb3iegMu"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a45b6fcd5e8so500514366b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 11 Mar 2024 03:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1710154395; x=1710759195; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i2dfslh5QDNZ/Ge1JZNCE0iFX9bHyhSCqEH3cMk4dhA=;
        b=nb3iegMuKAyOwVme6oxxWajgKvOOX7Dy4rdx8xeqY9DWXjDr1J+h6b2Qnb2mqyvCOo
         NuiEOjPF7+BvpihJYalva3/mW8NLyYoKSRjIukhz9KUVjU6r6aBGTJVZT9T31LVEw+Np
         AjuSdRl6kdsDdOIWG3RtL0lMMUbi597WFtYnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710154395; x=1710759195;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i2dfslh5QDNZ/Ge1JZNCE0iFX9bHyhSCqEH3cMk4dhA=;
        b=EonhfF5hDTdUo9DbB05yHEulcIRn5B3FRqNS9hek3MbOINRANXAwRB/kdRzIw18GpF
         AjPWmNNXsFxEHda74POC/97e1tXWPcdsVNuQN3tQkbkIu0WBblyAfIBacfismxMLKHoM
         udT08O4G8zOpIB/v4SrMnP1vQDy11CjhmTwkZNrgMkGiDwGpvlHH5DAqUI6NJWy0awRi
         TEkAuld29IMElXVVS9ruvXxBW9qAJcEAamxd1BZgq1jFdhqe9BwbPl6qO+aq556e/hHW
         T9Khxf6yHmgGfXIs4BFBgZgg80y0TZ/sLGkd+50oMiFM/hxAaLHAQa52jR0zWV7Xbks3
         Mr9w==
X-Forwarded-Encrypted: i=1; AJvYcCWKFAhhP3dbsA7W2R3uiYNdI8WF9QegANDmvudXS7Yugny298haTaouwkFpPdupUUZG4m1OSkLhveUD3MMpw6V3h6VhX8jY5/fDYhrRdw==
X-Gm-Message-State: AOJu0Yyh36EObUqSiPlZe5WuRzkLKjXMHu3rl3a2WumdS1mdyPeiqmQO
	zK9WQdIvKxNUlqoHPfclIYfrk7vE4myXUWy0AbCHi+EmkTGcQF9qx4vpUC10oCGRFRn3UTzaB+q
	2yYLfwtTvMsZFwkLvAZNdqRKY3oMBfwq4XRDsQA==
X-Google-Smtp-Source: AGHT+IGrhueAiqHAAsjZ28RgNBvcuE2K3dRDxlPYHttuy9/oDJvWikA5V55Q0CYuFb4STx3zWkEYO199sE/YQ7Tm9lA=
X-Received: by 2002:a17:906:f209:b0:a42:615:1395 with SMTP id
 gt9-20020a170906f20900b00a4206151395mr3478723ejb.11.1710154394689; Mon, 11
 Mar 2024 03:53:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307160225.23841-1-lhenriques@suse.de> <20240307160225.23841-4-lhenriques@suse.de>
 <CAJfpegtQSi0GFzUEDqdeOAq7BN2KvDV8i3oBFvPOCKfJJOBd2g@mail.gmail.com> <87le6p6oqe.fsf@suse.de>
In-Reply-To: <87le6p6oqe.fsf@suse.de>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 11 Mar 2024 11:53:03 +0100
Message-ID: <CAJfpeguN9nMJGJzx8sgwP=P9rJFVkYF5rVZOi_wNu7mj_jfBsA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: fix the parsing of empty string mount parameters
To: Luis Henriques <lhenriques@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 11 Mar 2024 at 11:34, Luis Henriques <lhenriques@suse.de> wrote:
>
> Miklos Szeredi <miklos@szeredi.hu> writes:
>
> > On Thu, 7 Mar 2024 at 19:17, Luis Henriques <lhenriques@suse.de> wrote:
> >>
> >> This patch fixes the usage of mount parameters that are defined as strings
> >> but which can be empty.  Currently, only 'lowerdir' parameter is in this
> >> situation for overlayfs.  But since userspace can pass it in as 'flag'
> >> type (when it doesn't have a value), the parsing will fail because a
> >> 'string' type is assumed.
> >
> > I don't really get why allowing a flag value instead of an empty
> > string value is fixing anything.
> >
> > It just makes the API more liberal, but for what gain?
>
> The point is that userspace may be passing this parameter as a flag and
> not as a string.  I came across this issue with ext4, by doing something
> as simple as:
>
>     mount -t ext4 -o usrjquota= /dev/sda1 /mnt/
>
> (actually, the trigger was fstest ext4/053)
>
> The above mount should succeed.  But it fails because 'usrjquota' is set
> to a 'flag' type, not 'string'.

The above looks like a misparsing, since the equals sign clearly
indicates that this is not a flag.

> Note that I couldn't find a way to reproduce the same issue in overlayfs
> with this 'lowerdir' parameter.  But looking at the code the issue is
> similar.

In overlayfs the empty lowerdir parameter has a special meaning when
lowerdirs are appended instead of parsed in one go.   As such it won't
be used from /etc/fstab for example, as that would just result in a
failed mount.

I don't see a reason to allow it as a flag for overlayfs, since that
just add ambiguity to the API.

Thanks,
Miklos
