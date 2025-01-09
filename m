Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8318A215764
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Jan 2025 11:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736422395; cv=none; b=Yx42yXYTrGk2xD4+FLoxHOAltQ6rKU0+dyQjXJN6+6+LRO4BsO1IWjEJbQ12y8Kl41qbjSoJtaAJTP/zNqA6hzirAFWPqEzBbD3cCuCGucPa4q/HHH54h4wrORkybdcVKUKFhObSFcAr5t4Cu0Z19f0mj43D/wxDSshLUee2c/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736422395; c=relaxed/simple;
	bh=4DhZ7h+hC/wW/6sKaxaXfjhYlhEkQwNVKexSkchilg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g0qbqQLN2lCSKi9pid/2l2MQ4hYqX6f/vVTIOShc9rOeOLu5CmtYqWu24UNWYVY+h/UDyGI9zVKWgNcInJMLVZ/8dduVd2BnLRCix+yFR/lE47hibuoWdzZL/mjMmLC/Bk5/LjAjxo9lvG2cL5aXrnIi82h5efIgAgGcfircxiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=m1C9ZDLM; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="m1C9ZDLM"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-467a17055e6so7721371cf.3
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Jan 2025 03:33:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1736422391; x=1737027191; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WNvfIFwlqP4QKBZDPopcva26qRyXQCS+MMSSoxP4bMA=;
        b=m1C9ZDLMUIb8thLAPVkZpyIIzUkGpIRedwqoAbL8gy+YNpsIiZ6HZuZsf5n1cHVk2/
         QT2egSaB6+TjEKoTyW2ufCYR0iPRt78Tk4eVkWNx6P56ph2mBRyRzQrYexxZrdeQ+JYj
         67/7b+TtJGy/RjU80eRSPayNDA275vukivfUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736422391; x=1737027191;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WNvfIFwlqP4QKBZDPopcva26qRyXQCS+MMSSoxP4bMA=;
        b=dvSu3MxxnlZYuTYEuFKRhlulbklKAR4Yo5XXhYZEydPHk0UIrAw8XUHCNopaAUFrcA
         FIeii2/HaOKOHCj+TOPr8yEOWgtxve3Pzm2guu17qiQuXAICXABExvBJwAqJd+VlRwmA
         EJUaUSQqZqoe4rjvSEcwcDWc6IPwqlCiL9tYKCtc406jFzsCPQj1tB1QhvVBb5jWBmoq
         MltiqaAyI/FMmwEjIYHhiHjd3okRRa2gWrjTeijdcwyFf8BPETqScZNA2ftOGnPc4sP+
         WuKpsYmakvNqaidyqcZNuRKU12gfsaClc99OZ/FsxePixG8Q/mA+nCFyTwzgssTFAkFK
         Pt9g==
X-Forwarded-Encrypted: i=1; AJvYcCU7jP6vIfDhRY1VfxiFeg+0OsrWiHRNnprQCyLQpr2SBLeeIXrRvmooOov8gQj38APMlKvVfMEY3DFuiQJi@vger.kernel.org
X-Gm-Message-State: AOJu0YxLSkrXcrg0Y/GchNTz4GWzm64UHUMMCgHdKvmpPXSletFt0+si
	+DZfDulPo66E8ML3PQ37QHo0omud2fIdnZQ443Mk02cQZjR5gUnBqGCAT3YijcYIaJua0oI04Ad
	IJHnh7Q/9h44F2wdV54P+hvJtpb856UIkOr+GPQ==
X-Gm-Gg: ASbGncuH2F0yzijiliuvm+QBbdo5DpXn8TYhQqj0Pac98gTCfYuA7xyUCyrh5JX/j/R
	XAimDCF7D5G6oxKotEkxKjb8g/0RRsxakIhUfSQ==
X-Google-Smtp-Source: AGHT+IFwF+BHLu4NVU2ZonM0UoppSCIW2Fzyjm5SsBV4QT8oZYr6lhlTVclwDivrwtcyfckItJp3sye8V8YUGJ57Tio=
X-Received: by 2002:ac8:584e:0:b0:467:7295:b75f with SMTP id
 d75a77b69052e-46c71083e8amr105665531cf.38.1736422391181; Thu, 09 Jan 2025
 03:33:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000003d5bc30617238b6d@google.com> <677ee31c.050a0220.25a300.01a2.GAE@google.com>
In-Reply-To: <677ee31c.050a0220.25a300.01a2.GAE@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 9 Jan 2025 12:33:00 +0100
X-Gm-Features: AbW1kvZzJ5lz6Eb3KKrjH-1AAR6UFCjTUY-4txNP5rEFXavvONhHexqYFfIR2Cw
Message-ID: <CAJfpeguhqz7dGeEc7H_xT6aCXR6e5ZPsTwWwe-oxamLaNkW6=g@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] BUG: unable to handle kernel NULL pointer
 dereference in __lookup_slow (3)
To: syzbot <syzbot+94891a5155abdf6821b7@syzkaller.appspotmail.com>
Cc: aivazian.tigran@gmail.com, amir73il@gmail.com, andrew.kanner@gmail.com, 
	kovalev@altlinux.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syz dup: BUG: unable to handle kernel NULL pointer dereference in
lookup_one_unlocked

On Wed, 8 Jan 2025 at 21:42, syzbot
<syzbot+94891a5155abdf6821b7@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit c8b359dddb418c60df1a69beea01d1b3322bfe83
> Author: Vasiliy Kovalev <kovalev@altlinux.org>
> Date:   Tue Nov 19 15:58:17 2024 +0000
>
>     ovl: Filter invalid inodes with missing lookup function
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ef4dc4580000
> start commit:   20371ba12063 Merge tag 'drm-fixes-2024-08-30' of https://g..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d806687521800cad
> dashboard link: https://syzkaller.appspot.com/bug?extid=94891a5155abdf6821b7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1673fcb7980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15223467980000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: ovl: Filter invalid inodes with missing lookup function
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
