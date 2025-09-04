Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16CC3126D2;
	Thu,  4 Sep 2025 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009314; cv=none; b=rsqKUDo7whIsTsfHqoZLPDUUmsmYyYpNwExucWC3e9xsA7/TncV4Neu/EYBAXfpoCNCNPTLGekvJaq36aOGnuGXuEnFhZMHtHXORorr77EW5c4wWOBQCA05wBUMsoXQcQb2u+hXAk8VDKS4qKIMnPKSpmiLkQPgeV7m55PYjIUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009314; c=relaxed/simple;
	bh=Y8zszUTD6Q+0nHzkXbk9YHv5/SuaOxVE40Lm5XG9w10=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YS7dHo9BPW9zClO8crKpx5K7vi49R6l5hL4/YRuEIhLvd+dKN0urfMit/KFxljQ2DLxLf8QaCsz/p9kxYnmElu2BYN2TD6oFZIdyGhzscttnnEklmjASxsV235/WuNYOPV2E6VY79e81xSCwMdjPwmKEr37qLe6uVZxOXCtespc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eG5mvjz5; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eG5mvjz5"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61ebe5204c2so1791099a12.3;
        Thu, 04 Sep 2025 11:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757009310; x=1757614110; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqf110ErddRhIKnbXk8LxIuS0H97WkUon5OD/15QmZc=;
        b=eG5mvjz5zrnQw7U15+2F8RDxL6Mz5xi2hV7H3Mg/7RbiU/snOrnlnxKFQ04YMsVzbP
         p54LD3cCneriMglpzxELdDE/UD1KhN7yU/JoxuU4cG/z7XVlr82+kS104IwJFgw+voYd
         MqpONnE+SkpblIqpPBT6fS0Inon5xN5l4J8paqH90u0nEtH3m6Rvw+m+akAxfmcA7t2L
         u2X5sBg+1XnQD+7mtRefJQ8vJd0ggaPNfa2ecoT8Kts5Q0STn2YD7czo/df3CiLTsYdI
         3mzHT79OjH3NeHcfLAWsUiNC9Wft4jldIgQHUg3TLpOZCoehicvYh1X4P1/VbrMrlJ9k
         UUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757009310; x=1757614110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqf110ErddRhIKnbXk8LxIuS0H97WkUon5OD/15QmZc=;
        b=Zo8KvuGqDxLepHXgw681wtSquypIvhV7PWyNWRc1zOSdSoiDSwbt0vb52YnDzvkyHC
         Ta5JqnV3yCOtYe1SJAEigtQ1svkaM+NYtCX/lDvfSRS0pUsUBOHG6D0DWkP7h5eiQbEV
         xpa5Ozit1ZXxNKcU/RcxUiOPfJ9Lb+tKG+AQ0M0PmS464mZJFTJRHbklxID0g2vmhsn3
         LTc0b+eWGUu236hnfmHK2Ok1z87KiI3+Rm8SIRMHKFoQaPKbqi9S650cRskfx+U0aFP1
         MdKMxS5GSUv4ag+8oCAyp7j4QBAwgJ21gmwn/hmSW4piGFWy0aHbVzyMXHpNMGjHuAVD
         YtPg==
X-Forwarded-Encrypted: i=1; AJvYcCV7cNinaMkrINkXa+38YZQ8M5tuiQ1JIzudOjag2jzA38yb9zxx+FIzbyYCEgGx5jJJDidaIZebZV6LTmsB/Q==@vger.kernel.org, AJvYcCVX4XH78ol1D3kW/AlTkCzlc9FyB2vlx01GOFdjHoT4tD7tUh0uLzdL98bZlODBMs/AXKrBNe3eUXQFkS9Wnw==@vger.kernel.org, AJvYcCXhRm+9ifeGqCkrv8DT6feKO3aCYFXKiNGC/9WRDhIhIDZNgxM1Zx3lJ5w49ZGpqwoqoqYrV2YcvioGc73s@vger.kernel.org
X-Gm-Message-State: AOJu0YzG7RyWRkrdYJWmnI2AJvr1zNCfJivnRmqUvCvEJzq7RddYEHhG
	DPJHGCeh8YefMKJZMDSkO509eDsB6fHG7psyl4xDYm/xzFB82BGpbDUWT48xJXF8TGM9A3Ba0/O
	q/a+vqF2ZX5lJNdFhTzgyX1dMcwAcgsc=
X-Gm-Gg: ASbGncv+2t1qAD+kj1iczKp8mi5/xbKpPWmmzLu3NRLQaLgx58kJI4b+qn/C/Rgk45Q
	v7dyq52ctaKhah7dQkD/vuPx4PsEZmFuBMxawxS5ydmI02FDsRMWu5Y5msyxf7x0mztnrfC/eKr
	XcQ8h9DSb5p5AOMAkZa3g2Bal5+cm/lnBnGB7e3u7ealkeJyXRm0xvldBopUVs57HvI+x8Atsu5
	dwJ6+w=
X-Google-Smtp-Source: AGHT+IGeKc0+/AjIUB/CaFgYtWjKMeGglnXUegS65q9Th0FqA+y/VMXoYkpSXqhUbW09cz12+m1cXfEYv7LTzZYh5x8=
X-Received: by 2002:a05:6402:27cb:b0:61c:5b94:c725 with SMTP id
 4fb4d7f45d1cf-61d26873cf1mr18673376a12.8.1757009309734; Thu, 04 Sep 2025
 11:08:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68b9ce5f.a00a0220.eb3d.0007.GAE@google.com>
In-Reply-To: <68b9ce5f.a00a0220.eb3d.0007.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 4 Sep 2025 20:08:18 +0200
X-Gm-Features: Ac12FXyZHmb3fVch1kTS5h1nU9af3xhf2ckZ7wB2ZUaSveQf_M_zMfTdL5gEuVA
Message-ID: <CAOQ4uxiDyyg=FfJrmWXVHuxQXu0Z6fn=6wth42iLcdhie0Qrsw@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] [bcachefs?] possible deadlock in vfs_link
To: syzbot <syzbot+1090a418b58c19e9a57b@syzkaller.appspotmail.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 7:37=E2=80=AFPM syzbot
<syzbot+1090a418b58c19e9a57b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux=
.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D15322e6258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8c5ac3d8b8abf=
cb
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D1090a418b58c19e=
9a57b
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f604=
9-1~exp1~20250616065826.132), Debian LLD 20.1.7
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D121cea42580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15589e6258000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/dis=
k-8f5ae30d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinu=
x-8f5ae30d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/I=
mage-8f5ae30d.gz.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/cf46540aa8=
ee/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+1090a418b58c19e9a57b@syzkaller.appspotmail.com
>
> bcachefs (loop0): resume_logged_ops... done
> bcachefs (loop0): delete_dead_inodes... done
> bcachefs (loop0): done starting filesystem
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 Not tainted
> --------------------------------------------
> syz.0.19/6755 is trying to acquire lock:
> ffff0000ec7c5c68 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: inode_loc=
k include/linux/fs.h:869 [inline]
> ffff0000ec7c5c68 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: vfs_link+=
0x2f0/0x590 fs/namei.c:4845
>
> but task is already holding lock:
> ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: inode_loc=
k include/linux/fs.h:869 [inline]
> ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_creat=
e_temp fs/overlayfs/dir.c:228 [inline]
> ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_creat=
e_over_whiteout fs/overlayfs/dir.c:473 [inline]
> ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_creat=
e_or_link+0x608/0x11b8 fs/overlayfs/dir.c:629
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&sb->s_type->i_mutex_key#21);
>   lock(&sb->s_type->i_mutex_key#21);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 6 locks held by syz.0.19/6755:
>  #0: ffff0000dcc7e428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x4=
4/0x9c fs/namespace.c:557
>  #1: ffff0000ec7b1e50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: in=
ode_lock_nested include/linux/fs.h:914 [inline]
>  #1: ffff0000ec7b1e50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: fi=
lename_create+0x1ac/0x32c fs/namei.c:4139
>  #2: ffff0000ec7b2418 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: inode_lo=
ck include/linux/fs.h:869 [inline]
>  #2: ffff0000ec7b2418 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: vfs_link=
+0x2f0/0x590 fs/namei.c:4845
>  #3: ffff0000ec7b27d0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode=
_lock_interruptible fs/overlayfs/overlayfs.h:672 [inline]
>  #3: ffff0000ec7b27d0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_nlink=
_start+0x2fc/0x6e0 fs/overlayfs/util.c:1176
>  #4: ffff0000d2034428 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x4=
4/0x9c fs/namespace.c:557
>  #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: inod=
e_lock include/linux/fs.h:869 [inline]
>  #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_=
create_temp fs/overlayfs/dir.c:228 [inline]
>  #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_=
create_over_whiteout fs/overlayfs/dir.c:473 [inline]
>  #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_=
create_or_link+0x608/0x11b8 fs/overlayfs/dir.c:629
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6755 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-g=
8f5ae30d69d7 #0 PREEMPT
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 06/30/2025
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  print_deadlock_bug+0x2e8/0x2f0 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x2940/0x30a4 kernel/locking/lockdep.c:5237
>  lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
>  down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
>  inode_lock include/linux/fs.h:869 [inline]
>  vfs_link+0x2f0/0x590 fs/namei.c:4845
>  ovl_do_link fs/overlayfs/overlayfs.h:227 [inline]
>  ovl_create_real+0x11c/0x3fc fs/overlayfs/dir.c:179
>  ovl_create_temp fs/overlayfs/dir.c:229 [inline]
>  ovl_create_over_whiteout fs/overlayfs/dir.c:473 [inline]
>  ovl_create_or_link+0x62c/0x11b8 fs/overlayfs/dir.c:629
>  ovl_link+0x1d8/0x258 fs/overlayfs/dir.c:746
>  vfs_link+0x3e0/0x590 fs/namei.c:4854
>  do_linkat+0x224/0x48c fs/namei.c:4924
>  __do_sys_linkat fs/namei.c:4952 [inline]
>  __se_sys_linkat fs/namei.c:4949 [inline]
>  __arm64_sys_linkat+0xdc/0xf8 fs/namei.c:4949
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>  el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
>  el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
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

#syz dup: WARNING in shmem_unlink

Thanks,
Amir.
