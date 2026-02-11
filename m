Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3A632A3FF
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Feb 2026 09:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770800410; cv=pass; b=uR82J9w1Scn4SBiaGL0kHllAlzpM/H93v13hmWftmh5/78IehvKEz8kDWA49oLWnKpG9yjXjxT7CG3N5T/YVMR8V9AhlBmS8pu29DDUnOBtSIG0rhz8vmmGxzhnGdnwXa5IaEZD2fMnTFWiaCcHfQPsFnFoyiHyrQ6dSw9vGguE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770800410; c=relaxed/simple;
	bh=m2nz6ncdF2meEOITLhi4JFJdXS9mrQvEIw4eheOENy8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uoDZWI2D72znTQE4V5gKI6ZLGGn9GAnzhYqyvfdEgy0fTMaosBtTa3C15Rl2Ccca5i0QXe1QG8Al8ZVCT8GrxlFPaQH0F/s1+Gj+HXkpjTTCaUegL0SmOmtk38W8Hz4gD1vVQzIiv1D0L8gb0+18vqkDXIk4YS5LnviqB3WIISs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpXrA3EX; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpXrA3EX"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65a196a735eso2530439a12.2
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Feb 2026 01:00:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770800407; cv=none;
        d=google.com; s=arc-20240605;
        b=MDxMkWSXq/wR5DXdduCg+eRJTZ0JFqJcv24y4JXXXSufoVQ6+8qA8BhaYVI7+h9/kF
         /GeIdNQ3s7EWks/AAx1VdtbM17fsPiMynfS3I4sPfaSAKgh93CMiXEQ1SoCnm9G00fhC
         pNXq6ChUlXY2vmhAlkr+3PmU+Rz/vFxnHavcIGLehKxnQyydeg5qEI4MCIBkdB/lBy8T
         gZZbso1iKZAC9q+CYt9ix/hsYtddQoA8sBTfpq+DDb4unRAd4FNps/6NMwOVenJuUo9Y
         HlaFUanxoQpu+LIHlgb3khydcwJKvfg3rVM0lJZc3uT4oTIvjvwwL/F8CMgNtyz/883U
         pGeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9scYw8VscnWcHCpztelMBr6ylitQ2zhvFfYW2i8dex0=;
        fh=0vZbwFXpPpTdPwYODdP/fVA7ALJllOUWPgCP+BQAEDI=;
        b=kyPEJOjQuVqxrXc5QAESQQeMkdsfx/wAIFrzo4hCLmNijbhBB5wuWPaEWguJ+k5Hcq
         kxBshvLu2xWWZ5GtjGA7x21p7+YvxRq/dvYiYk4dlt5acPBVTzboi2gAW3hEINKUOW9A
         YgyAwBxX57O7vgML+xhGLI2Ta/QS8jQzxnnmve4/Csuxnorzl/klTH6xRJoTfS3a6B/5
         Uk2uts7uwrtNUHa1qKcK/r0Cya/3/iejuqw5V/+2ALSRpI3B+dpYl7TDBj2ouBlnd9kD
         xDFAQqlYe8lQTdbRkicDMHuxtv6XI6RcJaUTzKXD+EdAdPKosgC2SIQQBJfKz0U0QozQ
         9V2g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770800407; x=1771405207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9scYw8VscnWcHCpztelMBr6ylitQ2zhvFfYW2i8dex0=;
        b=mpXrA3EX/HUzhrD76KZdpSd1gvVghmydVgNmljOhObdejSiuuhsWPkCsJi2iL+qCBZ
         t7bh87yvgqLd0WwjfWfWBOQjESnKQ0i6WZlE3URho/wTZtZQAke8AUeoDq1I4oysR9BC
         6+nD0zsfRS6SAh6BMTluAAswrc4InCg8YQMhHtz6vnkS9u0/kxXbYMhjNg074TntH4MT
         oWuK/ehyPjA7J4/g1D82npjX/SK052TyUz3dnSUP8DIMXJKtciN0vOxFfnazgWwUd8Cf
         oxeunbaNqtuhgFeHgAveG33DGJPFRMC8CT0j02gd8uzdrrSgQpsxZBGM/uofAiYTotJY
         w99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770800407; x=1771405207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9scYw8VscnWcHCpztelMBr6ylitQ2zhvFfYW2i8dex0=;
        b=BHtPduJNAzWwhdGRbU+ceLQ2l/3RkiL89jab4qTSAfZ9hLpDcdi/bQubBvL/F0mx4o
         KSNFvmDGa4WFgQbh2pUcUQX82OCK0C3QTr1MWAR3Ghzuf2pY4SGaLg7SMjMYPdNKx6zR
         HFHExu7lfW0R1Y9AGs07tjIiPZEE5kVzebKisCNIl/WeykB1ldlGo2SXhoPQUrPJC8Vg
         bdVYXKNYT8W7B+82pvVPwXynDRh/yTmxYYeiE/KKQo95eeIk8OPZ3Snc8JAcDGKhEifG
         IE/DKxx/fppzsbLcayxARUf2X73CS8JZ9cZT8SLZV/JGRV7pGuKhe6wAGJ2WdTbhENG5
         LYUw==
X-Forwarded-Encrypted: i=1; AJvYcCUxNJPprs1k28Pl+bwgNuUz1Wytd8v8GMzFxXARkovZ5oOf662tNtAo6euRaiwv8PbNVagoip6noiQdLeZ9@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk4wVxPlM6NEH+s6satfsDzTSJKSeieIc2hwv2CfFpF8bhqSKr
	fO4rnISgpRUlipmBJZs53+JpUw30GA9k/zk/zhf+MQFx8DWLDrn5kUMyhJ1T1LPnlnv/bpiMn6C
	Q8euqHDqBB00D+kE6SXM/uI1Da4GTch8=
X-Gm-Gg: AZuq6aJ4lOwY7fXUc62imYu9f6890A/Z0rW67RLpFnYYbD5oneSZiMSEPBjr5m0JdCD
	pPUTTpMA6hW7AMPp06pm2wC3uGlnmq/mHJpM82gNNpJnZz/ZmyV9MkNX7ERtAHm7Cu25r8bEdHB
	ayAGVomnwx92qI4hEztBV5KHA7jksqZ5MSBKS2ucNUUHzEC8QVG7iftuonvi3mEkxIsHnjdL7Z5
	DotAUA8HHldNiXMaIzEZBJz4EqkP3EvEu9x/PKMvSfXQt3x/d9oyvHSspuH8H/6h3f18F+jhoMV
	lwSOJBTPKHCDEHiEqo8xB2GFwgX1x5cIJI1vrKqo0w==
X-Received: by 2002:a05:6402:1e89:b0:659:3d7d:e38 with SMTP id
 4fb4d7f45d1cf-65a39d80b40mr957025a12.32.1770800407158; Wed, 11 Feb 2026
 01:00:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <698ad8b7.050a0220.3b3015.008b.GAE@google.com>
In-Reply-To: <698ad8b7.050a0220.3b3015.008b.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Feb 2026 09:59:56 +0100
X-Gm-Features: AZwV_QgIzXrdZivr1LLUKl9Imv44KSCXg01_kZba_XWamJF2YrJKXdW-esFtk5E
Message-ID: <CAOQ4uxh1Qc66R8N57SOb5_Lp28AyOiMCVfoGZXd-bCtM9-Da6w@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] KMSAN: uninit-value in ovl_fileattr_get
To: syzbot <syzbot+fa79520cb6cf363d660d@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, 
	Andrey Albershteyn <aalbersh@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Edward Adam Davis <eadavis@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2026 at 8:05=E2=80=AFAM syzbot
<syzbot+fa79520cb6cf363d660d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    8fdb05de0e2d Merge tag 'net-6.19-rc9' of git://git.kernel=
...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D13d888aa58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9682a42d8ec8b=
05c
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dfa79520cb6cf363=
d660d
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25=
a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1233cb22580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1035878a58000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/25d060d68c51/dis=
k-8fdb05de.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f033f4d0ec73/vmlinu=
x-8fdb05de.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/942ea5e5d5f5/b=
zImage-8fdb05de.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+fa79520cb6cf363d660d@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in ovl_security_fileattr fs/overlayfs/inode.c:61=
7 [inline]
> BUG: KMSAN: uninit-value in ovl_real_fileattr_get fs/overlayfs/inode.c:70=
1 [inline]
> BUG: KMSAN: uninit-value in ovl_fileattr_get+0x5cd/0x650 fs/overlayfs/ino=
de.c:720
>  ovl_security_fileattr fs/overlayfs/inode.c:617 [inline]
>  ovl_real_fileattr_get fs/overlayfs/inode.c:701 [inline]
>  ovl_fileattr_get+0x5cd/0x650 fs/overlayfs/inode.c:720
>  vfs_fileattr_get fs/file_attr.c:94 [inline]
>  __do_sys_file_getattr fs/file_attr.c:416 [inline]
>  __se_sys_file_getattr+0x6cb/0xbd0 fs/file_attr.c:372
>  __x64_sys_file_getattr+0xe4/0x150 fs/file_attr.c:372
>  x64_sys_call+0x17cd/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:=
469
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Uninit was stored to memory at:
>  ovl_security_fileattr fs/overlayfs/inode.c:612 [inline]
>  ovl_real_fileattr_get fs/overlayfs/inode.c:701 [inline]
>  ovl_fileattr_get+0x5c6/0x650 fs/overlayfs/inode.c:720
>  vfs_fileattr_get fs/file_attr.c:94 [inline]
>  __do_sys_file_getattr fs/file_attr.c:416 [inline]
>  __se_sys_file_getattr+0x6cb/0xbd0 fs/file_attr.c:372
>  __x64_sys_file_getattr+0xe4/0x150 fs/file_attr.c:372
>  x64_sys_call+0x17cd/0x3e70 arch/x86/include/generated/asm/syscalls_64.h:=
469
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xc9/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Local variable fa.i created at:
>  __do_sys_file_getattr fs/file_attr.c:380 [inline]
>  __se_sys_file_getattr+0x8c/0xbd0 fs/file_attr.c:372
>  __x64_sys_file_getattr+0xe4/0x150 fs/file_attr.c:372
>
> CPU: 0 UID: 0 PID: 6044 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(v=
oluntary)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/24/2026
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
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
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>

#syz dup: KMSAN: uninit-value in fuse_fileattr_get

Thanks,
Amir.
