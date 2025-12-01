Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67C41F463E
	for <linux-unionfs@vger.kernel.org>; Mon,  1 Dec 2025 09:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764580083; cv=none; b=fFBrWtqSznnR113qmJKZh/o2GTrEzG+CrXIBPq2pMXx4RHA5w1nfu0N6Zaaxn1RrbRcUttbVF8Vbz1KSpLWiVw4sQ8VbaQLzfsmum7IbsketjqJOSkrqwpf+sR4Agmtc+e5cqosK+6SSfhsEfRRMGtfOxwaGMDGzbADS81dSyds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764580083; c=relaxed/simple;
	bh=Y6GOM8G6io/qMLpfb/2rZHf41gtqUZIUDGHEpGqyOYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jV2LFXIVFvOreGKlnvGZWmQuXXEVfGJ0IHSsdipweQ9GobKt1O8rYCAfe3iGU3u0yQ4ug7w1Gas3lG5jJplqWMN9xhLNeeBTI2v8Xmt+5vKa50CzVi/nq8UxiQwLJfcS0h4+5RCDtRgEFQxWl/6k7bpA0EKq9bzvGQA+7ozfscE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yml9SHAV; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yml9SHAV"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3ec4d494383so2539656fac.3
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Dec 2025 01:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764580081; x=1765184881; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JgAQMgRvkVQ/+m/A0lpA3u98ZlbrxFkDFPfRMW+KhY=;
        b=yml9SHAVh5RehX4APK5Z58vTtJfKDiUFwKITawYYfa4vfK+7kIwLafoTZhOETQVQ1p
         HjDLeEfu1EBNJzgyc9I49kdrcHLdKHvyd+jLvKaU4qjYksxfLBgGVtW2hJykpbx1Ta39
         TbJiftMM1XkqAxoh+EpX1brVErnRUX9wjnjkHHQzO8s+wTb7meqGpiThXcV8mokrjKfU
         BOZ74h5TJQI5O5jOpM5qp1zJJygEljK55ExgnZqCDlbK/WPnXSrS5tCkH72XIyfpSoxY
         eW+d+k+MaAJiw0TWYGNj7Q+Q1h9uxK3A0NNBqx2iFl0nO6rE8KsdBXNsSdyit0FDf1xp
         LJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764580081; x=1765184881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9JgAQMgRvkVQ/+m/A0lpA3u98ZlbrxFkDFPfRMW+KhY=;
        b=RoeQY/X4vDSjWJOg+VeV7PTxUsTIV1UNHCqVzoWkKk0+VbVjz7TJIvVpn7o07WmZt4
         TT0Q1fiVaHiQ5hiCmQtbXUDxdjBFnZfWpGt7aYEGgj+DmyxHiZeMnMizCh9OH7546kuS
         WM6T0JryWC6yCpMvvcpacMFX1GhxQuYbB1rQ3mItE2X42VW4Yl3gqJHE7BCuZZjGYgxE
         LUay51zpmPoal6j2W7Pcn2ydBJI/E7wRsrv3Z2z7/ujB96SL438LABvOHg+/D3G+sxBx
         qmA3V7jDC0dmCUpci/0g1TJlJTyAnDoAP0TNL5I9o2KsY1v3o1qyi8yzi+9i1hMEm8Vb
         vq4g==
X-Forwarded-Encrypted: i=1; AJvYcCUnWi/NeQz981NGGAez9R+/MjlgzI84iEFSKJ42qujael+pZVtb9QCP61PBDTu5bNoxpMFTagrFE29PIqz6@vger.kernel.org
X-Gm-Message-State: AOJu0YwtbnlS6aShpReYbJlr6fbCjm+H/bYb8zebvLttIEJhPzwEjJCD
	IoaKDOEokPLNoUUB6/axBLIiBDSaBsbebsTQgad2PuS7WD8Xcx2iW6nZKuTtRUREju01Kv4k3Ww
	abaQXSFMdagLmOm4EsNpSuYpGXj2qJvYBRVmRgdJY
X-Gm-Gg: ASbGncvUk6yxsXcjdEtOcA+p2hc6gZPCQ0CBrZnVZ4gCKGOfmAJCGgGCuQNepqWOaN7
	mSIjDXtSnJ4IlshY8zCAL1ByHnsabHU6jm51jcT7hqz0G5hbayO3/sWwoowAPui+LP1nIftQHbG
	vd6SUpjUxmguRE/FsGRySy7QndGfBJTDbuScsVNwZj/Mi9jcl4ENmBdq+AQzDVzi1J8nGCJNSDp
	ya9JqvNCa/BQwYrbfKnvfbAwTnjaFOkwBsEv3hucbdei7TgW1gLQSkyqa5Cqa+3cy7owB/3nMqE
	ISxrcvedDxZv/vaPJz4yZojFjJoFUUK5Job4l/TWuazoyQETFxzI3xVN6tQEmfSt0oipYuo=
X-Google-Smtp-Source: AGHT+IHKoYWezXIEtGo0M2k+Kl8BeyJh40JqMIPZFSx2W4VItQrBX17d6CTEv3bpqh8Lvr6V3cKb28Fh6Aqn4CttPsg=
X-Received: by 2002:a05:6808:3385:b0:450:275c:8803 with SMTP id
 5614622812f47-4514e6683bcmr9617530b6e.28.1764580080792; Mon, 01 Dec 2025
 01:08:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <692aef93.a70a0220.d98e3.015b.GAE@google.com> <CAOQ4uxhPEt76ij9zBtdKf0qYwSjeXquGGkLHeArO5t1LhdTHOg@mail.gmail.com>
In-Reply-To: <CAOQ4uxhPEt76ij9zBtdKf0qYwSjeXquGGkLHeArO5t1LhdTHOg@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 1 Dec 2025 10:07:49 +0100
X-Gm-Features: AWmQ_blHveGVrJRHF57vRG7hWTcJtiZcKlbHyn50cS0J_lVq6FCI8gbDscj-InE
Message-ID: <CANp29Y56-h6SqKMGR5FF=4PNVj2a45nuX9nQAA9f2ZfiVrNSrw@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in fast_dput
To: Amir Goldstein <amir73il@gmail.com>
Cc: syzbot <syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com>, 
	NeilBrown <neil@brown.name>, brauner@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 9:58=E2=80=AFAM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Sat, Nov 29, 2025 at 2:05=E2=80=AFPM syzbot
> <syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    7d31f578f323 Add linux-next specific files for 20251128
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14db5f42580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6336d8e94a7=
c517d
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Db74150fd2ef40=
e716ca2
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1780a1125=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10f6be92580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/6b49d8ad90de/d=
isk-7d31f578.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/dbe2d4988ca7/vmli=
nux-7d31f578.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/fc0448ab2411=
/bzImage-7d31f578.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: fs/dcache.c:829 at fast_dput+0x334/0x430 fs/dcache.c:829, CPU#=
1: syz.0.17/6053
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 6053 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/25/2025
> > RIP: 0010:fast_dput+0x334/0x430 fs/dcache.c:829
> > Code: e3 81 ff 48 b8 00 00 00 00 00 fc ff df 41 0f b6 44 05 00 84 c0 0f=
 85 e2 00 00 00 41 80 0e 40 e9 fd fe ff ff e8 4d e3 81 ff 90 <0f> 0b 90 e9 =
ef fe ff ff 44 89 e6 81 e6 00 00 04 00 31 ff e8 74 e7
> > RSP: 0018:ffffc90003407cd8 EFLAGS: 00010293
> > RAX: ffffffff823fcfe3 RBX: ffff88806c44ac78 RCX: ffff88802e41bd00
> > RDX: 0000000000000000 RSI: 00000000ffffff80 RDI: 0000000000000001
> > RBP: 00000000ffffff80 R08: 0000000000000003 R09: 0000000000000004
> > R10: dffffc0000000000 R11: fffff52000680f8c R12: dffffc0000000000
> > R13: 1ffff1100d889597 R14: ffff88806c44abc0 R15: ffff88806c44acb8
> > FS:  00005555820e4500(0000) GS:ffff888125f4f000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b31b63fff CR3: 0000000072c78000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  dput+0xe8/0x1a0 fs/dcache.c:924
> >  __fput+0x68e/0xa70 fs/file_table.c:476
> >  task_work_run+0x1d4/0x260 kernel/task_work.c:233
> >  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
> >  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
> >  exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
> >  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inli=
ne]
> >  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256=
 [inline]
> >  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inlin=
e]
> >  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
> >  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f4966f8f749
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffc01c51258 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> > RAX: 0000000000000000 RBX: 000000000001a7a1 RCX: 00007f4966f8f749
> > RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> > RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000201c5154f
> > R10: 0000001b30f20000 R11: 0000000000000246 R12: 00007f49671e5fac
> > R13: 00007f49671e5fa0 R14: ffffffffffffffff R15: 0000000000000004
> >  </TASK>
> >
>
> Any idea why this was tagged as overlayfs?
> I do not see overlayfs anywhere in the repro, logs, or stack trace.

Looks like the crash title is too generic, so we ended up with a
collection of unrelated crashes here. However, several issues are
indeed related to overlayfs:
https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D143464b4580000
https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D1683a112580000

>
> Neil thinks this might be already fixed upstream, but
> given the recency of this report, I doubt it.
>
> #syz test upstream master
>
> Thanks,
> Amir.
>
