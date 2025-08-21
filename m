Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C592EC546;
	Thu, 21 Aug 2025 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755784052; cv=none; b=bZdIaCo4YnoPt2P1whELtkqdJUZDLB4BISyfKl+t5WJbFwPtxmMWJw+kZvNmorEUXf7RM56wWZz3KK37+0LHpuvLudlA+QZmFQZ1ow9rnH7UC/fv9JhH4KFwjconYXgQ0yF7jAzpB9UY76SFTNjm7Z6ibafYfEwbj//nZcUzTQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755784052; c=relaxed/simple;
	bh=Gy42XOghx1B89ihA/gs1j63gTfGb5r6GdFhYLHk8EFY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DY0UvhpoV0HcVGjCE44NK3j1lpLPPXYfXa4fVwbBygUl2cBc4utc2HJEeynnqIDwxTmzGzCnaqltLarlhOfRU/d/Tn8VNk3q98cCTSsrkoR4P+us7R5/14kpZHvLyGG8OmOHwYefhQKdO7ti93q/mCcgMDBH0lvIF1gghoJRZ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K52y5zuA; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K52y5zuA"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7ae31caso193164066b.3;
        Thu, 21 Aug 2025 06:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755784049; x=1756388849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cia8JarTa2Lrro8Snn+cGrHrWL7oRmM4YyjSOxIV6rM=;
        b=K52y5zuAw+poAGsy6yHvGZHqZSshwplbyJK47kto8CqDOUYWbDgGxRwNFOP9rgMiq1
         o/WDUwd6KKT0Zao9x36QJqOBOnrriWGVsQCcg996G0HdUqeL4xHo2dedzfijxEHToqPS
         lO077Rgey8pXaAmiAFb7rkV3TugeiCmaeyL5pO2N+j5VTsOwSMS9cTzDsClGKo19nhKF
         jN0ZsqANCjRyuCILFvrgzRbbk/DMkSTFVWyZ4ZsfvzJrZ8XM5NYTZrNas3DZv91rxzja
         demCOJuindTBRj2v6+gYh4XhsmakAOAIqLiF1d2lKPl+PTzLTTkYN+wBP7LaqI6uLax1
         88ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755784049; x=1756388849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cia8JarTa2Lrro8Snn+cGrHrWL7oRmM4YyjSOxIV6rM=;
        b=OP2ke+1zmAkps4M0boorXMzpizIX37m+YOj9hgpHqYMNwAfc8PxZvubvqYxjZfzmLr
         QeQG05QI+NC36rlXbEWNPPT5WphtOAIBIeV7o/qVQIZ0syx7C8T5kiQIOgNr65zMAV7M
         GKiB6ZOgQ3KWa1fHJIMz5gJgwyCS84oJlFUP6JriomFU+pN8xR7fhOEzTwqqyhxP74f7
         ylAwLq+SY9pFIs7vwjKwkuRR8PIzTVSqW0QgNMXP8rBeifskDn+2tYZYkjkdo1t2+F1g
         05bonOlrWoDkAijHYndDjtVJGR6nfdwE6MVjlFhMfpUNVNyT4BgLpL4NPOYbLrC/HYQ+
         Ma4w==
X-Forwarded-Encrypted: i=1; AJvYcCV3N0lGGpO7WZupn1lRYaj/xVWHhNzBpC+KgO3JXMEkAkwYtYQrwvKud3P5WpWAf84dI7eLjRkMwsAH7zhn@vger.kernel.org, AJvYcCXWyUqPzG8Y5iI/yLX5mtL45K6slFvwy48tsYWl0dW66l/WtzE0NNfWO04tM9H3VIpiXxLVvJPh@vger.kernel.org
X-Gm-Message-State: AOJu0YwiuLAYFcRDZ0WgkkrtGHMwpbvmgELlU3qD1rnqXdX83pzc/wyS
	KGMDtbYZCmCJwN3S+n+f45oMaEMKaupI1otxS5ZwSOLrXGs82037eX76dlBDQbrCpkbKOawoy2l
	yDVLq6ETt5z05ZpSbhw0FId0lwrfadG0=
X-Gm-Gg: ASbGncu4oyBxc+Mh+c86OKSfmtQ0hyWngcGOBHLCxRp3TIRZo4tIXa+DwX2lb9vIJAN
	JxV7gRRsjl5QoOyb4Hz0WjJ9kSq21Vr0bpgubXbT4f3PI0JrQupN1AWfsnmGhoR+Hls6oQ5SMiC
	wgwN57NxKvDhcDHPHOXJV5IBMWQeXnmVCF3pnosLIE9v+ATrdjSr7eJTsavW6Na02thJlKBs/uZ
	r1jMZo=
X-Google-Smtp-Source: AGHT+IHj3dDTVDBhF5LSgUdYzfrB5th8PfWnKPK381L9wa3a7ZpPgxa/FTzTYbzsIUeRypVlLZoZ8QmHsQ29UnJRXiw=
X-Received: by 2002:a17:906:f581:b0:ad8:a329:b490 with SMTP id
 a640c23a62f3a-afe079ed9bcmr239871866b.23.1755784048731; Thu, 21 Aug 2025
 06:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821134244.846376-1-amir73il@gmail.com>
In-Reply-To: <20250821134244.846376-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 21 Aug 2025 15:47:15 +0200
X-Gm-Features: Ac12FXwdyj9hqIjjMrXDKIxb7H9apwUQO54d1ytu6udiQ3YJKVghbzV07tIhJ94
Message-ID: <CAOQ4uxiTFjVLTmPkVvLCH+H6rF0Ui53EOjHPSB8Z-yzVR4uBLg@mail.gmail.com>
Subject: Re: [PATCH] ovl: use I_MUTEX_PARENT when locking parent in ovl_create_temp()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, NeilBrown <neil@brown.name>, 
	syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 3:43=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> From: NeilBrown <neil@brown.name>
>
> commit 5f1c8965e748c150d580a2ea8fbee1bd80d07a24 upstream.
>
> ovl_create_temp() treats "workdir" as a parent in which it creates an
> object so it should use I_MUTEX_PARENT.
>
> Prior to the commit identified below the lock was taken by the caller
> which sometimes used I_MUTEX_PARENT and sometimes used I_MUTEX_NORMAL.
> The use of I_MUTEX_NORMAL was incorrect but unfortunately copied into
> ovl_create_temp().
>
> Note to backporters: This patch only applies after the last Fixes given
> below (post v6.16).  To fix the bug in v6.7 and later the
> inode_lock() call in ovl_copy_up_workdir() needs to nest using
> I_MUTEX_PARENT.
>
> [Amir: backport to v6.16 when lock was taken by the callers]

Greg,

Forgot to mention stable version in subject line.
This should apply cleanly to 6.16.y and 6.12.y.

Thanks,
Amir.

>
> Link: https://lore.kernel.org/all/67a72070.050a0220.3d72c.0022.GAE@google=
.com/
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
> Tested-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
> Fixes: c63e56a4a652 ("ovl: do not open/llseek lower file with upper sb_wr=
iters held")
> Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
> Signed-off-by: NeilBrown <neil@brown.name>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index d7310fcf38881..c2263148ff20a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -779,7 +779,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx=
 *c)
>                 return err;
>
>         ovl_start_write(c->dentry);
> -       inode_lock(wdir);
> +       inode_lock_nested(wdir, I_MUTEX_PARENT);
>         temp =3D ovl_create_temp(ofs, c->workdir, &cattr);
>         inode_unlock(wdir);
>         ovl_end_write(c->dentry);
> --
> 2.50.1
>
