Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892E812F58D
	for <linux-unionfs@vger.kernel.org>; Fri, 17 May 2024 15:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715960462; cv=none; b=QlBZMRec+JEZprV3uM2NwIj2SlJflQXBFN66KEIg51rqQMnktQhUf3tW3i64iud9Y2vwA4WJOGzUksvojuBsTx2JrG9YzyLiTSSrUk8r2+EPt0xwAaGejflL+zPBfZLACdL9G2OQ7GMIIA6PCFoH0jCaPS2rAymmMS2ADcH3Lsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715960462; c=relaxed/simple;
	bh=kbohzPnLDgM7IQeXd/1NEXoC927SZZmUiT2bGewMcxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oMa5sZ0AVKrbuw8qrQSpacrtgRGUSHh5dNXlxlkBk7F5SMhMl/vs2n5OMeLYEPK5JSnZfq+37kQM9bN2+6xuNLv0TttegG4xq8OxXLJKLk8VBZ9Jc0B3elqNhLinjtdzjWNJ3q+5PlRqq17leyDAIkq0DGjsVb34FAV7coA+LzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=oCzD0Rda; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="oCzD0Rda"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2e1fa1f1d9bso13840771fa.0
        for <linux-unionfs@vger.kernel.org>; Fri, 17 May 2024 08:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1715960458; x=1716565258; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g3uvQyOXC6DzeBtn7J3OOKoxKJZ1WzPonWgDGOVCz4o=;
        b=oCzD0Rda1SfrLYY31uuo5837EUhU6svEFFk/AHonTFSyLOHE/AmTA2L3S6Eu7V6Lxy
         bNBd/Hf21+V+sx7LMrpwnyeM8bPy4aTQWvQsRg3ZNhmJbFBOwdi0f3y8HLrxafGcDRb9
         q7JGTolMM9Iow49uIoXknaQhSesfe8+vagEes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715960458; x=1716565258;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g3uvQyOXC6DzeBtn7J3OOKoxKJZ1WzPonWgDGOVCz4o=;
        b=EvFWXrXFLJMRVas873hpFsmKFHNX9OuvEYdrqyux1wiYYfdsC2c5K48y6LItvoD0q0
         IIDNZ1TE/V/hRPD8nDvc4Uy7RHLKDRbEmdKvdShwf7UUjPl6llelX5fj0tmQSYKJ38AW
         XFERaFU/9g0Pjc5NcITzlui1nDxADRAOrWl9XkTBR4YiISWs6v6QJEwf8V4Vm1zcH0dQ
         wixdN64Z7E5ksHKn7ISPRAZZXY7oSfHQULjnqJCwXQj+fl4g7V31AG5QNFcHmBUiSmyI
         JK5mIMZ++Fy1SY1N5jGIlBtwgGEOjRm87YdZHHkWvR8BPBnZtp+nSWLt4iMRW4vjnAR1
         YGlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv1me4sEtx8nKxRAxwQq9pzJjrkJ9702jbRGkz3m1W6UlfjSKhpoosh3pH+IGXGjnd4lNctqX74tWo67HlqniBcNqtzaCkxrWYwQp9Lw==
X-Gm-Message-State: AOJu0Yz52Nx251XYC5AIgTvmgVhRtCSqUgvTXKWGaS5VdmvQx/MEQYNr
	qaeh21/ujeoj5Gdv6bh+RXQAMDGlD8xxu7YT4wSPe3LllseTRvcZNKkSEJNz6ZhiXuBCr5j0z41
	CwEhSi40zKFgaBKHeyqIiOB8+WdxJd4PwwtqzGg==
X-Google-Smtp-Source: AGHT+IHIxRZ5GfZcmKjumiPucJds6t+FhJ8wB4Mamt8S570wQWI0fT8nNgPZioDyP96HF/02QrdoeGI3bfESt/M+OG0=
X-Received: by 2002:a2e:d09:0:b0:2e5:2eaf:b09c with SMTP id
 38308e7fff4ca-2e52eafb202mr168442591fa.37.1715960458664; Fri, 17 May 2024
 08:40:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000141e8306185a0daa@google.com>
In-Reply-To: <000000000000141e8306185a0daa@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 17 May 2024 17:40:47 +0200
Message-ID: <CAJfpegtwuOgundfkCdh4c4-scJjBEgHjNzJ8Vq2VUxjxWWQPHQ@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_workdir_create (3)
To: syzbot <syzbot+8aa3f99a6acb9f8fd429@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 May 2024 at 20:28, syzbot
<syzbot+8aa3f99a6acb9f8fd429@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    45db3ab70092 Merge tag '6.9-rc7-ksmbd-fixes' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=169b934c980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2f7a2b43b9e58995
> dashboard link: https://syzkaller.appspot.com/bug?extid=8aa3f99a6acb9f8fd429
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/0c2a8034002c/disk-45db3ab7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/807e35e2b3a9/vmlinux-45db3ab7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4868b2eab91a/bzImage-45db3ab7.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8aa3f99a6acb9f8fd429@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff888077f311f0, owner = 0x0, curr 0xffff8880787ebc00, list empty

This is lock corruption on the upper filesystem, definitely not an
overlayfs issue.

#syz unset subsystems

Thanks,
Miklos
