Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BC742315E
	for <linux-unionfs@vger.kernel.org>; Tue, 20 Jan 2026 12:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768912889; cv=pass; b=edDVHo6ENYptorIKOvctp+WkboHAMDSt3TKDJTRjXPJEWnkPYrCr5LE9ZyqOvdUDobo51u9GYQ9Ai/N3oyeNRal08n4NEKORD0EQCXxN5difsRZD0WnyGyek/NCVO5N5dbw5d6CxJUaSNL6203sQhzNL7wZV3TjvpyLOGh8muVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768912889; c=relaxed/simple;
	bh=6jhGkEEsrw4gfY5LJgJbLI65AYfgrqqebdGZ8tVqwvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zs0AgH9c8zawXq0RP6QrZ3Q5suGSOcjAum1BfYOvuK7S8MuTxovMNavuGIIyAXcGNNxpEf+CY8HCoNOY4Usa3Ozxi+e+vSnQwUWFSek9Z3caN9QrEHCqzcBFaB9ab3VYD+1PKITd/UdpCdQf9u+4sUyd0Nx9n6ybpIm2vCpDklw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TK4SZDMu; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TK4SZDMu"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65807a2012fso532129a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jan 2026 04:41:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768912886; cv=none;
        d=google.com; s=arc-20240605;
        b=hCm8/cgCHARYS8ESc3sB2oD0lSqRqt8DqXPPetAptNhJ8SPq5TQWF7HBroFsjy6s5J
         cNcKo1LOvjlducjekIG/PvlUHYwZSL1/tuDDw3qhDypYAlTzyWCJqQsBzRnXISTEU6je
         enpkXtU9LzpnZXC/ALYY929FB2CKqm/UHY0QqBytjERUYUuHMP63dzwip/xPQt2/9nNX
         gZN/WoRxrzOoU8DbzDo4q1heh5BSbF7b/+7eJBL91FovhkdDCa9AZF97AY3EgsO6ECiD
         YQ8nWIuulModlRfAtRUy8O7rzd+zuGVTLoBkpDtI7Sh+J+K7iAIZU/YqEYubp8acjihZ
         WS0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UOk4kIktv0FY55T6tXdAUhxf/MAZxGZm0hzUAjOE9/8=;
        fh=dpsRaBw0JfbXsLHtsNHI0xaCd47B/vXyic/bWW8RVPU=;
        b=augZ+vA8Xwx/VRSOsmzr6AklZf5d5Ue9fXBiNN46zbzo/dD/EOxXhK1TbGtyeoc251
         miuMxHxwGmJh4wwXR/dc+Q3eviGdJE8OcYO0QVx5LRcel2iCgaw0G1sWeUh9009Wck9S
         x93PmwWsm9sC9gNao/UsfTvD2o1r1OrmrOSWwz21Hd/6gr66OcF19gq6Kha3nmTfuB+S
         6BieJe7X3jvE5wFvo+43cyvtQQoignWggJv8f6TCouecu0R0EpQUQnij40jw2zo5xqDn
         f6QSHnepz/3arCxnNtbt+P86hwcC5vsvja12IiWo9rKO6EFgdrbM+6mc6/ylc77YwTL7
         R+Xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768912886; x=1769517686; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOk4kIktv0FY55T6tXdAUhxf/MAZxGZm0hzUAjOE9/8=;
        b=TK4SZDMuhgXuIztVp6jwvGn4NYCiVZGg3RLHEFstEzrL1TvL4/ow1Zs0BL3eVn1AZk
         KRQlqAcEC5MWmcslNb6BLFRzV815br71vf3ivHEjt/2OCRr8tOUbRc7q06ALjtGZeoVv
         BvmHcEQkV5YTbKbx4D7mNpEYdeF23nQ/A1YFekLZukhdY8bKLpbUX38ycmFw96D5C6JN
         l8asd8anFBx+k6EsnC5sdi7yNRm4APdwYcFctBH5IjqctzbzWfQftCl7NoCEFxcu8pIn
         TMJA8pi3ibjWwmXbO/wsGAPdfpQgH1ozrUVqLEaUHNVEEhX7cYggZvltM0n8RXW+dvrN
         i36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768912886; x=1769517686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UOk4kIktv0FY55T6tXdAUhxf/MAZxGZm0hzUAjOE9/8=;
        b=et3xWBs6LggTV7zwn+S28j+jy+NMgcSdi6JxqeZuZniS7BSAW+eqGpJmR/FIuuITcN
         Fhdy12nYOd0VKgqzbRFg46iXeimulRz5to2dV53inql8YNhlafZxM0pcYV0qlwjL2o1j
         /PZn3cjjLX8xP9zKC0sqRCqPCGowTYGvcRPFfxdbWReOD/ZEPQ+TUY8uNb5BiqFSt1jf
         kwaX+Eq11vFWDE7vwbMhkyZnpCjoF78vOSR17LlN7A7uwXRDYRSJwWIVvhTlaINGYuUv
         3lNhGNrN7pNMUsMKUcsFfjJPcuxgNI5OMus4hGjuR7rhzPHW6Bzk3e4OQHkqu3tQRoqB
         HzVA==
X-Forwarded-Encrypted: i=1; AJvYcCUZGPQwt1DTh9ZbYWXs9EF18Rxze24z5dbNlzf9lBboCmOshjSzhTFnNbB781GyoGiun5Yy1hU9N313VKoq@vger.kernel.org
X-Gm-Message-State: AOJu0YzfbajEM+ae+mMuwVNrEfnDXqo7QqACMY1sL55+2wm1CCOdWVQc
	7a8hG4xEZkFPta280fCtAnJCVsTE5bpwwkMnlBvi+CEINqsGRnE937ZIOtG22yMxkYZSHMmUR/L
	lw/pA5UFh5iHZVljnCXtOS/pSlAbrByY=
X-Gm-Gg: AZuq6aJ+wKS9HJl7I6OptQYmfLoO0g8xIdBsc6TD4o7bgCQ3Fyf4GiqTuUhUh5VtPQT
	IJw88Af3Kepr+jDi3MCuL+RjmPC30sy9UHXAxtZ9PNcriU8U+Y1XxWa/GEgDg3Vy5vM78YhYsfm
	WUQbKeJaKEJ70dnEdWjnP0a3RJiCcUSaIrxHBUrlS0ZLEAeBJetPPNAv9HJo2OBDxOK+WNvPlcz
	AqGDdMfRnoXFLSV8q4+ua999jyfWihtDIZlaFuRhrjekjeLu/LyGfGna7rS07NJN3HIfoX9D7Qr
	7Cu5/lOkMKEKIJHZzWkA9xFiida7cQ==
X-Received: by 2002:a05:6402:1d50:b0:63c:3c63:75ed with SMTP id
 4fb4d7f45d1cf-657ff4d95dfmr1607138a12.22.1768912886101; Tue, 20 Jan 2026
 04:41:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <696ed6b9.a00a0220.203946.0000.GAE@google.com>
In-Reply-To: <696ed6b9.a00a0220.203946.0000.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 20 Jan 2026 13:41:13 +0100
X-Gm-Features: AZwV_Qh63wUZXemGgjJ8wYC9li5GUlCjmZMXT8ZyNiLetsDmGEM3WzpSSEWis-Y
Message-ID: <CAOQ4uxhMO1kt1aMWcZaUi-AVqWPY=xYEuK_EgmEhvJhG-B9YDQ@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_create_real (4)
To: syzbot <syzbot+2214f6a425ea963a605b@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 2:13=E2=80=AFAM syzbot
<syzbot+2214f6a425ea963a605b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    603c05a1639f Merge tag 'nfs-for-6.19-2' of git://git.linu=
x..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17b8339a58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1859476832863=
c41
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D2214f6a425ea963=
a605b
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binuti=
ls for Debian) 2.40
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d=
900f083ada3/non_bootable_disk-603c05a1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0fd1a1c47d69/vmlinu=
x-603c05a1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/152f657b1f0a/b=
zImage-603c05a1.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+2214f6a425ea963a605b@syzkaller.appspotmail.com
>
> overlayfs: ...falling back to redirect_dir=3Dnofollow.
> overlayfs: ...falling back to index=3Doff.
> overlayfs: ...falling back to uuid=3Dnull.
> ------------[ cut here ]------------
> WARNING: fs/overlayfs/dir.c:214 at ovl_create_real+0x9af/0xbd0 fs/overlay=
fs/dir.c:214, CPU#2: syz.2.9540/3063
> Modules linked in:
> CPU: 2 UID: 0 PID: 3063 Comm: syz.2.9540 Tainted: G             L      sy=
zkaller #0 PREEMPT(full)
> Tainted: [L]=3DSOFTLOCKUP
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2~bpo12+1 04/01/2014
> RIP: 0010:ovl_create_real+0x9af/0xbd0 fs/overlayfs/dir.c:214
> Code: 8b 48 c7 c7 c8 2b 79 90 e8 1e 42 98 01 44 0f b6 3d 41 5a 31 0d e9 d=
c fa ff ff e8 fc 05 e1 fe e9 67 f8 ff ff e8 12 2a 77 fe 90 <0f> 0b 90 49 c7=
 c4 fb ff ff ff e9 ac f8 ff ff 49 c7 c4 fe ff ff ff
> RSP: 0018:ffffc9000518f4b0 EFLAGS: 00010283
> RAX: 000000000001eb61 RBX: ffff88802d846758 RCX: ffffc9002830b000
> RDX: 0000000000080000 RSI: ffffffff8347d1be RDI: 0000000000000005
> RBP: ffff88803bd2f490 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: ffff888033102ff0 R12: 0000000000000000
> R13: ffff888034d2a800 R14: ffff88802d8467c0 R15: ffff888035c6e2e0
> FS:  00007f0d6ec506c0(0000) GS:ffff8880d6af2000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b333dcff8 CR3: 000000005d5af000 CR4: 0000000000352ef0
> DR0: ffffffffffffffff DR1: 00000000000001f8 DR2: 0000000000000083
> DR3: ffffffffefffff15 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  ovl_create_temp+0x54/0xb0 fs/overlayfs/dir.c:253
>  ovl_copy_up_workdir fs/overlayfs/copy_up.c:778 [inline]
>  ovl_do_copy_up fs/overlayfs/copy_up.c:988 [inline]
>  ovl_copy_up_one+0xc4e/0x3c40 fs/overlayfs/copy_up.c:1189
>  ovl_copy_up_flags+0x18f/0x240 fs/overlayfs/copy_up.c:1243
>  ovl_rename_start fs/overlayfs/dir.c:1161 [inline]
>  ovl_rename+0x270/0x6b0 fs/overlayfs/dir.c:1348
>  vfs_rename+0x1021/0x2390 fs/namei.c:5938
>  do_renameat2+0x71c/0x9b0 fs/namei.c:6056
>  __do_sys_rename fs/namei.c:6099 [inline]
>  __se_sys_rename fs/namei.c:6097 [inline]
>  __x64_sys_rename+0x7d/0xa0 fs/namei.c:6097
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0d6dd8f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0d6ec50038 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
> RAX: ffffffffffffffda RBX: 00007f0d6dfe5fa0 RCX: 00007f0d6dd8f7c9
> RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000200000000000
> RBP: 00007f0d6de13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0d6dfe6038 R14: 00007f0d6dfe5fa0 R15: 00007fffee2fe808
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report

#syz dup: WARNING in ovl_create_real (3)

Looks like an upper fs which creates a newdentry with NULL d_inode
I think that overlayfs is just the messenger here.

We could maybe remove this WARN_ON if it is not helpful.

Thanks,
Amir.
