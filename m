Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734542FE041
	for <linux-unionfs@vger.kernel.org>; Mon,  1 Dec 2025 08:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579495; cv=none; b=ZcDqOaFk72qoN5rKsaVhX+dEuZcRwmxtUl8ikYkY2FvR86Cc66FUfvRYsRX60XMZeZqp3zLLiM8t5Nnus7uG/SM3G4hlpkYBDMxh4CLa/mNabbnLSQjn3lmR73XXsM6FQYN178/h/D2c8/n1PB4Dlelbw+yvZAl0LGbFSame45E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579495; c=relaxed/simple;
	bh=D/fSpjNNbcjD3VdHMpRppy4+sIJaXLw3cEgeibvO4M8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qr5aK2IXqgCb1TBiBlure7eFy/Uldzm8COgM4szD88f7I1ABVcv/i9Lqp6vqADu3G2y3gkEnRGV88bd1nVC2K/iNgoqP8DcOtBlXynce4YEC53IVeZbrJrLTMFq0n/NpVXueaOLTWz8Vja2m++hUq+jCcRTdJfk1OHnkaTi21v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNDncpY8; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNDncpY8"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so6020414a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Dec 2025 00:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764579492; x=1765184292; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qhb/n+mPHnKUo7pZ6mmy+walMfHotCfbloMHCIoAAJs=;
        b=CNDncpY82+GMF1KKbbbaVhmV+22rZ2BnV9S9Sq/GxjMcduAngJ7w6MudcVMmO/3WY6
         KiUXUXP2Sp2srgMkp3y/Jc1aE6ALjM5aLWBTgcmfdA8/85+ZtMPcpxDEzf/MlRqOUkuA
         zTpEB6ZrQTcu5Ybk81HoLZsuzzUlgG7Nvk2Y9HIEmTj42/HUdLxWHrWtgi+JoOvnUs58
         BKqJyKiIK6Jjwb7H1cnHyPvzvnNrnWkknHIJI2n+AQT3wi+LSRxvsNy7J14KKcjr/E38
         NSbxTW56i0/1uvak7+IiZQDf+Y8RlyJpTSQvBF6tHvOKcnx5Rzb9BX8rAf4MBI+UzklP
         suyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764579492; x=1765184292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qhb/n+mPHnKUo7pZ6mmy+walMfHotCfbloMHCIoAAJs=;
        b=IKMIp5TukTNznvL/Dsekhmci3ylNRy3U19dTpr3nqQOwIfrdE9EntfcmkAQwLMS6Qr
         OmW8jpOI9e0NbKKRFFlBF4MiavlE3/eLz32QHJJRiwPYbQak4Ybr/uPp2X21v6Rki2Hj
         HRjOdmGkYXYPKcq/JKSADmrM6sCwPloMDz+Qqb4bqEh7kYcrAtYTb5LUE8glcUMsxJ0/
         iG6O4MohmHQ3YRGEzHOo+iqyb+S90oV5rPE7RKHh/SFZavZmJXsrTQIJeuMy4Zay6U5H
         cKuIWIrjokcImB1RDvugAM5UY/D6Fnvi9dvgnkcydt1P+/tA9jg9XfjjbKZ0oAhptvLS
         ZO/w==
X-Forwarded-Encrypted: i=1; AJvYcCXJqXaVeNTN2M+fwq52Op5aKEZJj9FsDEd4xnaMg26cbYFeTYyqDxlVkrLGLrl0ovFlHtIWZhpLhd8z6oHu@vger.kernel.org
X-Gm-Message-State: AOJu0YzsjoQbatNBMqTWJ3nJtMPFedQMuGBfvmR2DCAv154z6sz58vga
	4wp+bFXJn3sn+h4TcMsVVzJqmSOLngJ/RAI21B8l02I6rApSL/aDSrqmpDWKgPWoAinmQr6Qyo2
	7ky8yqlr6qq/oI/gXAu9/xcLGl5bNEUc=
X-Gm-Gg: ASbGncufOapTmWGzmNbKMDsPosfj8cVXSwdpxjkvsai/qUQ3/4OBV6A2KP6oNwAtmf/
	mPaPglHFZJpHaTgYE8sr7AB5uGzDJL3Sl58hxJX4/qO9KrGz6r+sVBz/yw/g17rHNu0foYsRGuK
	H3KJUyw1oMcSDA4DDK/85wgifIvfkclSqCZa7wVu7o2Cm/KEqalSYkdjQSbKFLnC1PuzdfLuAGU
	bRzy4JBXh0sFugbSXpWBmJITC1heanLj8HGjum2/HJRIvHmc+ZJvtv1Tek4R6rMSAsHkGHXUukV
	3ghPWlBHK9jVwVSGNybNimUdBAr7
X-Google-Smtp-Source: AGHT+IE6Rrlix2x66COJ91RqWy35UbbAD7/xYgFOkShtPwT264SlY8llAYocBCxhUmjKYAkE93gU0xBOww1G6umfNHk=
X-Received: by 2002:a05:6402:20c7:10b0:647:54bf:727c with SMTP id
 4fb4d7f45d1cf-64754bf729emr10470532a12.5.1764579491656; Mon, 01 Dec 2025
 00:58:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <692aef93.a70a0220.d98e3.015b.GAE@google.com>
In-Reply-To: <692aef93.a70a0220.d98e3.015b.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 1 Dec 2025 09:58:00 +0100
X-Gm-Features: AWmQ_bm_NyCXL8HxSGSCU4cpGc16Zt5YJ6qjw70BRU678xd6w5H1WPVrDJ1Voo8
Message-ID: <CAOQ4uxhPEt76ij9zBtdKf0qYwSjeXquGGkLHeArO5t1LhdTHOg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in fast_dput
To: syzbot <syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com>, 
	NeilBrown <neil@brown.name>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 2:05=E2=80=AFPM syzbot
<syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    7d31f578f323 Add linux-next specific files for 20251128
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14db5f4258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6336d8e94a7c5=
17d
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Db74150fd2ef40e7=
16ca2
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1780a112580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10f6be9258000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6b49d8ad90de/dis=
k-7d31f578.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/dbe2d4988ca7/vmlinu=
x-7d31f578.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/fc0448ab2411/b=
zImage-7d31f578.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+b74150fd2ef40e716ca2@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: fs/dcache.c:829 at fast_dput+0x334/0x430 fs/dcache.c:829, CPU#1:=
 syz.0.17/6053
> Modules linked in:
> CPU: 1 UID: 0 PID: 6053 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 10/25/2025
> RIP: 0010:fast_dput+0x334/0x430 fs/dcache.c:829
> Code: e3 81 ff 48 b8 00 00 00 00 00 fc ff df 41 0f b6 44 05 00 84 c0 0f 8=
5 e2 00 00 00 41 80 0e 40 e9 fd fe ff ff e8 4d e3 81 ff 90 <0f> 0b 90 e9 ef=
 fe ff ff 44 89 e6 81 e6 00 00 04 00 31 ff e8 74 e7
> RSP: 0018:ffffc90003407cd8 EFLAGS: 00010293
> RAX: ffffffff823fcfe3 RBX: ffff88806c44ac78 RCX: ffff88802e41bd00
> RDX: 0000000000000000 RSI: 00000000ffffff80 RDI: 0000000000000001
> RBP: 00000000ffffff80 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000680f8c R12: dffffc0000000000
> R13: 1ffff1100d889597 R14: ffff88806c44abc0 R15: ffff88806c44acb8
> FS:  00005555820e4500(0000) GS:ffff888125f4f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31b63fff CR3: 0000000072c78000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  dput+0xe8/0x1a0 fs/dcache.c:924
>  __fput+0x68e/0xa70 fs/file_table.c:476
>  task_work_run+0x1d4/0x260 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
>  exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4966f8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc01c51258 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 000000000001a7a1 RCX: 00007f4966f8f749
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000201c5154f
> R10: 0000001b30f20000 R11: 0000000000000246 R12: 00007f49671e5fac
> R13: 00007f49671e5fa0 R14: ffffffffffffffff R15: 0000000000000004
>  </TASK>
>

Any idea why this was tagged as overlayfs?
I do not see overlayfs anywhere in the repro, logs, or stack trace.

Neil thinks this might be already fixed upstream, but
given the recency of this report, I doubt it.

#syz test upstream master

Thanks,
Amir.
