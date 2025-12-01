Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A7512C544
	for <linux-unionfs@vger.kernel.org>; Mon,  1 Dec 2025 11:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764587153; cv=none; b=gu5Te/jwwgbKdDZvbbpHCs8rnhM947UYFdJIxePvVKlXYKIuw2jzlcfAIdMPXAwmz+EkbjaxEu6ZoECsC7BC3dcR7M7VqigaDnq9d+6Cj8F+cKpKSIkK0Yz/wIe1Etj04xaSbLjgRdthSSwu+Me+g8nVskGf42q4wj4P9ADu6Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764587153; c=relaxed/simple;
	bh=ct1mKLRaHDvtqi8DD+VuJjaZMOGe8z6NdO532Os1Wdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cFoLtx+ngrzZ/Hlue6xu+sZN+sF+uj2JsS3ygZWx8UzFcY2gFI+cGIM04LlRM/kVVn9HT2zeFiaZv/f3pzkM06XCxvzk9D+rgzDpRxmuBBey+nersBJLhQ7gpsri4esQICyBUkR405yCiYlVNy4//n3geMr9Ea6A0iOn1G9aB90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+jygXpg; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+jygXpg"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so7758849a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Dec 2025 03:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764587150; x=1765191950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=le708YHcULmR8ho7Avun2TaiCPtrC5P/TlGgxItdh0Y=;
        b=a+jygXpgQFAkJVEGi14ma/wsjHOk8Bf4o3hguwWjlVjO6xNLUfh2hHdMt2crbIQ3QD
         JqtIGANKX8dgUFnoZ8PkMrzjjlD6mnCHm9KAJEg8WuoT5l3LU3/kFbNB2WxUQ17C6UBH
         ZjZOSauctf7fT4qlar4RzRv9Ffvpe3izEIiKyE++RUzFZcYXrKmbU//19EGnja+ayKkb
         ajdkB4m76ONIyDP8QkpK4Qj2wF3MBcDA8fp74J11mvZXy9dAhUcajwtK+d5Bq7BEZMhT
         MMytiP0BXWh+71tOhte8E+2+eoZOKotOz8lx4O8cX5X3IjCOIl3+KQ6iofticfJbPa8n
         Cy4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764587150; x=1765191950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=le708YHcULmR8ho7Avun2TaiCPtrC5P/TlGgxItdh0Y=;
        b=sy5zIJ5EAKmlQPwcglwXUpYCU4j9Ygx7zCjjma1Vcyqwx4We0qyS3WBR35fL+y90A8
         DN3M11sMVcumK9jBrNNwkVWU1RwriyD2OHI4RBd8G+8KjjDe8FoexnduV30LXKudUxuI
         lrO0KhOk+xwD3tfkbstVkH3zwH8lufdSOTeNGSwsyr88KnWa9mc5zcsC/8mc87qieZSN
         8QA0HmyxRpFmmczSpHbFFO/98b38FHwi70MqIka1ks1+WwVhcIN3tKNDr+6GnIm0fmOz
         bz0gmJnHB6MvnYR31Ub2LWRZN6WueOreLDl5Es0t9UjrPVp0BdjdV6Oiy6tzI2wKsd+h
         npBw==
X-Forwarded-Encrypted: i=1; AJvYcCW4SFSZKeN92c6fjvPQEkjWXY7S5CdDW4YkbBeCz7gsPSIdJquXn2yAmPoaQ7A9ovpEDp9NIcm0Z8GyUqms@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ2hSk6EOfJ02MZeldJI7J5N02qBBJt/QZyfGWH6KyOUQNA7KE
	Mgt2EvxqIdCXTwsfFB+lvNvKErjSqLh+sHfX8t47E5wTbOBJ1kl1AKJs5M9CvHS8bQdkM39hLvN
	/ieteSbXL7YjJ862DfFvgkk32OKGl8Gk=
X-Gm-Gg: ASbGncueu6Aawe9p08DWWxD1HejBjYPBGOWFJyZTuy+12FxM9gMvzrdWO2X93MmMXos
	3Z2nV0P6Kn6rNC7kfXkswBS38b+KXvzgbF8DpnmylHKfyEVI8vAP5lOWzP27rLB91eVzbD/p+7l
	oRZTGgGVq0yQvRP5KBLPS9MQVyWErH0IO2iAwFby6C0nYeaO8kcKNMyOvYBT7R39ctiprxjfMR/
	BB+qxjfy6VOzJ1ZmzshqcMqRAzo2yog8Zcp3y5F0cstKKImBmpuXXkuri9KCT/7YPx59/Y7OiaC
	1Llr1EhaK415X/Aq5bMGM0asds+CByZOtTI9JKw=
X-Google-Smtp-Source: AGHT+IESKAxbC6EwVkqt/yUxm0aUELK/HPxRKxQwmePT8Y75f2Eu4Az907BBNj0j34GS6zAT+dulK8EumooxDRxouAo=
X-Received: by 2002:a05:6402:3593:b0:643:e03:daed with SMTP id
 4fb4d7f45d1cf-64554339c26mr31572469a12.1.1764587149850; Mon, 01 Dec 2025
 03:05:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <692aef93.a70a0220.d98e3.015b.GAE@google.com> <CAOQ4uxhPEt76ij9zBtdKf0qYwSjeXquGGkLHeArO5t1LhdTHOg@mail.gmail.com>
 <CANp29Y56-h6SqKMGR5FF=4PNVj2a45nuX9nQAA9f2ZfiVrNSrw@mail.gmail.com>
In-Reply-To: <CANp29Y56-h6SqKMGR5FF=4PNVj2a45nuX9nQAA9f2ZfiVrNSrw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 1 Dec 2025 12:05:37 +0100
X-Gm-Features: AWmQ_bkp1f1FapAoChwt0QpqWTWPTf_AvooGRWQvqniUm8d8DRlE6UrFs3iEWkQ
Message-ID: <CAOQ4uxisEzWmAWE8HfTRSe32ANZ4ov+i43Ts86DEA0sEXCC17A@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in fast_dput
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com>, 
	NeilBrown <neil@brown.name>, brauner@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 10:08=E2=80=AFAM Aleksandr Nogikh <nogikh@google.com=
> wrote:
>
> On Mon, Dec 1, 2025 at 9:58=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
> >
> > On Sat, Nov 29, 2025 at 2:05=E2=80=AFPM syzbot
> > <syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    7d31f578f323 Add linux-next specific files for 202511=
28
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14db5f425=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6336d8e94=
a7c517d
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3Db74150fd2ef=
40e716ca2
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909=
b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1780a11=
2580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10f6be925=
80000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/6b49d8ad90de=
/disk-7d31f578.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/dbe2d4988ca7/vm=
linux-7d31f578.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/fc0448ab24=
11/bzImage-7d31f578.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > WARNING: fs/dcache.c:829 at fast_dput+0x334/0x430 fs/dcache.c:829, CP=
U#1: syz.0.17/6053
> > > Modules linked in:
> > > CPU: 1 UID: 0 PID: 6053 Comm: syz.0.17 Not tainted syzkaller #0 PREEM=
PT(full)
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 10/25/2025
> > > RIP: 0010:fast_dput+0x334/0x430 fs/dcache.c:829
> > > Code: e3 81 ff 48 b8 00 00 00 00 00 fc ff df 41 0f b6 44 05 00 84 c0 =
0f 85 e2 00 00 00 41 80 0e 40 e9 fd fe ff ff e8 4d e3 81 ff 90 <0f> 0b 90 e=
9 ef fe ff ff 44 89 e6 81 e6 00 00 04 00 31 ff e8 74 e7
> > > RSP: 0018:ffffc90003407cd8 EFLAGS: 00010293
> > > RAX: ffffffff823fcfe3 RBX: ffff88806c44ac78 RCX: ffff88802e41bd00
> > > RDX: 0000000000000000 RSI: 00000000ffffff80 RDI: 0000000000000001
> > > RBP: 00000000ffffff80 R08: 0000000000000003 R09: 0000000000000004
> > > R10: dffffc0000000000 R11: fffff52000680f8c R12: dffffc0000000000
> > > R13: 1ffff1100d889597 R14: ffff88806c44abc0 R15: ffff88806c44acb8
> > > FS:  00005555820e4500(0000) GS:ffff888125f4f000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000001b31b63fff CR3: 0000000072c78000 CR4: 00000000003526f0
> > > Call Trace:
> > >  <TASK>
> > >  dput+0xe8/0x1a0 fs/dcache.c:924
> > >  __fput+0x68e/0xa70 fs/file_table.c:476
> > >  task_work_run+0x1d4/0x260 kernel/task_work.c:233
> > >  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
> > >  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
> > >  exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
> > >  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [in=
line]
> > >  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:2=
56 [inline]
> > >  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inl=
ine]
> > >  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
> > >  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7f4966f8f749
> > > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffc01c51258 EFLAGS: 00000246 ORIG_RAX: 00000000000001b=
4
> > > RAX: 0000000000000000 RBX: 000000000001a7a1 RCX: 00007f4966f8f749
> > > RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> > > RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000201c5154f
> > > R10: 0000001b30f20000 R11: 0000000000000246 R12: 00007f49671e5fac
> > > R13: 00007f49671e5fa0 R14: ffffffffffffffff R15: 0000000000000004
> > >  </TASK>
> > >
> >
> > Any idea why this was tagged as overlayfs?
> > I do not see overlayfs anywhere in the repro, logs, or stack trace.
>
> Looks like the crash title is too generic, so we ended up with a
> collection of unrelated crashes here. However, several issues are
> indeed related to overlayfs:
> https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D143464b4580000
> https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D1683a112580000
>

OK but which repo, if any, are those crashes related to?
I am not exactly sure how to process this information.

Thanks,
Amir.
