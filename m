Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492D3D5643
	for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2026 10:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781779660; cv=pass; b=hST+ch5LQGBYLR/vfXwmI2gTcm3hwbFClHGYsr63vOap4bJ7BE81KnlwLGZ5Zod8KTMcRAzKoLCwNndwzfnX8jdEbptroG5weQE14QA6mJKmnspf18lzgBRt4c8oVmaP7hQfJVNnEa1C5GdRR8xzCYnWtNMR+jD5tmAg6aFUFoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781779660; c=relaxed/simple;
	bh=1czG6UERSum6ILjKJ0uBQBfSMJ9CGRzPdJjX6sMVZAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eAZxbVSpCyaVF30h7Ojbm/8W2f3pEbqT6j2BBn/NheoJWNdnVh7HU8Gw2M1nczTlBHlNpyuj20krYmLx0/QJC3oCa4AudXmPKs2bc+G+x7NgTQr6+5wNh6AYjuWGgRqFYjXTN/AH/2Yl+dPtW82BPrhl/l8Ke49bAKQGEqSI1B8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLhTP6AL; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLhTP6AL"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-68c19f1f3ceso1164422a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2026 03:47:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781779657; cv=none;
        d=google.com; s=arc-20240605;
        b=CbTCfBYfLhkUwWEQj+opE3ovHlX41WFnHk7mcKW/DGuVuFY/05XYpA/UmXWFRr3qyI
         WxXkSFYsj4FxH3i9llatgM8GGBLwEhOL+LqbBRrVRF3nWoICl8sUUiboc0siWZJD7uuU
         NAKfTiAVN60XpSrHMs8O6+ArAN8f4pmXeIEJ/5Dk58umWhHRvwscdEff7X7YHOuMsu8G
         sqsuhzIOkM18xyLM483nav1G2pePiPsOAO4HaOhCBpbOlYYQzUlAaoQUIYmlZdU3VYsV
         SLI/1KH8fNqCHtcZEzYiK9sV8TVR2ImnFOGDEj1mMP3h+E4F7NX6cLpCB+J4x/f+Zj83
         2YYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yZRwIvgUqdUIe9ItNfE1bXhjp4FcCLgHeqcj0YM6e/0=;
        fh=fmuQ/Zu1sFWzJbVEUuyuguTlJMSUJ+L9JrwwzxH8rVM=;
        b=k9jHQmr7vKhYsOhAD5tjubMAO+yc3Qt+InfWPe/LHdQL20GcDqpBTFk5W25wuf3GwV
         nvnvni457qCQp75rGJSB0YxP0glgUHr2Exo1ws6ihK3OTt858FF4BJoY01AaT2BQFBqs
         5uZq9XL6gR8pyVHOzcM2+jwesspEiCbSEyL8sQiQjgrx+9m5CZudeRKlGFZMv9TdOAQU
         Xq+cKjMRz2pjpiE7JsAWNzolTUbMCGrlkGwWF/HCwRo3iSqoAjZV5D+dps+vCyfLYWTl
         1rL77A+pUvY3KZ23fzrRdnh5i0C8Qcx7sem7m4lZG6Eiv6Sv2+KfLRwRot5x31cqOv9u
         wqvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781779657; x=1782384457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZRwIvgUqdUIe9ItNfE1bXhjp4FcCLgHeqcj0YM6e/0=;
        b=KLhTP6AL4VBbQZKQmzINY4tfLQ4pVSoNOQQ7DZT+1xc6V1N7dZLxDhaLUcLFqjiIoF
         em6LgGNGPmD+FTG0cTXpLsg5tiNkSXzJs1ztLdWN8SvFmYkF9GSpcKw53DhcZcgPXg00
         Y/l2QILO+H0VTXeZy9apxjkzGBnPn5/SdTSAGCkHSM+y9DWgb/TfTteM68TtML/RaGFc
         ZCGQTIQjwwrprNAOX+iYvkp91bAvWGXQiNNCIzro+gMa0HUVWFEEoV0qNftiHcrBpIyI
         EWMNLrLMm8fxN7IS5yqzXFdHZr6VEIJNkQxbfpSo91Rf/pFz0R2EiJBeZFlz+c5s7PIc
         cx2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781779657; x=1782384457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yZRwIvgUqdUIe9ItNfE1bXhjp4FcCLgHeqcj0YM6e/0=;
        b=GBjxMa4cGb3bLFF9NtjRODXZjQhboWUrC8wbzgWjEHrGfeqYEffTqzS1Yc+3Y5/T0b
         cknYGqyJXtukA3Urh8B2a2lsx7pC5+oU0582vbhEWGHlAeqS/UHhWTIwknmeTjVi/ahq
         4NujANdMxfpdj9Iq8hb5f0dJs7bH9/IEfQfXZtO/Up5P6dkrBzhQbUiCOnbopGXxqmBk
         J+Yl+o9cPw8Bf76WDtOXUtdqe6DuAUDSa8P5w6nNe585J37hnbgQHb7DY0/zzJtAFK7f
         872piLzP/sX8c0srfmjFCgNYBET/TyrTPKJ6771cRox3zX3iejmPjqcdMJzxao23B9fL
         bvzQ==
X-Forwarded-Encrypted: i=1; AFNElJ81VnUK8vmsdp6AxZwFQCkfatZzM7MODzL2fZDVRRYpdCOqMKK/j/r+9oBaqR1WykdKzvHWnL5dm+FSSe5n@vger.kernel.org
X-Gm-Message-State: AOJu0Yz795WIeOy7IbA+uNwgUqzj45O32Jx0dQlRymsOdp0zUUgKNdd4
	VHmHjhq2S4mfjkVYsjQJeBChhUHkqiYDwXVeJ4hsWZ4yMlHnasVd0/nW23clUx3BxjEf/HrUa1F
	VA7H2I2+kRYN1N2rPkrL41rnIc8zCeCk=
X-Gm-Gg: AfdE7cmH29FClCigbbbRITS33BLiA8+5yPSVO/MzRqkQC4fjmduOJdrMf6LkkhRUxOY
	tIaNHEn5dHZL3qD94WC6mAgUSW2tILA+USdbBaaYlzCnfg6LId7WF6TzcjNDcrVyEdoHtSPcS97
	ykutpRSCSMC4ljbbVZZvBA/LbDeQeMTdtac66GX9t8Q0LAHK+ms/YI8I/G31w+KlC4vVxKbwJMj
	WJ50S6/FmBk5vGS/L6VmHlbZWCOkyxVrPwx6DRSLnYpbbG5LjJzQ7eHC+lcYbKDTwlM/GczV85V
	XB671QUw80B+23mKZQ876gX5k+I217k=
X-Received: by 2002:a05:6402:a284:20b0:695:81c5:1e28 with SMTP id
 4fb4d7f45d1cf-69581c52164mr2425564a12.5.1781779656497; Thu, 18 Jun 2026
 03:47:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6a330d0e.6d5abbec.a50f.0020.GAE@google.com>
In-Reply-To: <6a330d0e.6d5abbec.a50f.0020.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 18 Jun 2026 12:47:24 +0200
X-Gm-Features: AVVi8CfFX0lRozUBJ0KuKesk33sKJAbY-Z2-PArxvHgGXFf3ClVBLRDDh2fpFT0
Message-ID: <CAOQ4uxjxeH8NwC3s6RzAhnuKAyn8cL1Vb=+Zh3wie+y6bOff2Q@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in ovl_copy_up_start (5)
To: syzbot <syzbot+d4e3aadc5bd19f7e71ff@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, 
	Ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 11:09=E2=80=AFPM syzbot
<syzbot+d4e3aadc5bd19f7e71ff@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    596d152bc5e3 Merge branch 'for-next/core' into for-kernel=
ci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux=
.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10aba8ae58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Deb40ba923a822=
433
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd4e3aadc5bd19f7=
e71ff
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25=
a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> userspace arch: arm64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/32d15acc8c01/dis=
k-596d152b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/83b3d8d84761/vmlinu=
x-596d152b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8edfcc3bf911/I=
mage-596d152b.gz.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+d4e3aadc5bd19f7e71ff@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Tainted: G             L
> ------------------------------------------------------
> syz.3.611/8517 is trying to acquire lock:
> ffff0000eee140f8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock=
_interruptible fs/overlayfs/overlayfs.h:705 [inline]
> ffff0000eee140f8 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_copy_up_st=
art+0x58/0x264 fs/overlayfs/util.c:735
>
> but task is already holding lock:
> ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: inode_lock_=
nested include/linux/fs.h:1074 [inline]
> ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: lock_two_no=
ndirectories+0xe8/0x148 fs/inode.c:1256
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}:
>        __lock_release kernel/locking/lockdep.c:5574 [inline]
>        lock_release+0x178/0x3b0 kernel/locking/lockdep.c:5889
>        up_write+0x3c/0x5d8 kernel/locking/rwsem.c:1681
>        inode_unlock include/linux/fs.h:1039 [inline]
>        unlock_two_nondirectories+0x60/0x118 fs/inode.c:1269
>        ext4_move_extents+0x468/0x3580 fs/ext4/move_extent.c:656
>        __ext4_ioctl fs/ext4/ioctl.c:1657 [inline]
>        ext4_ioctl+0x2a14/0x4234 fs/ext4/ioctl.c:1922
>        vfs_ioctl fs/ioctl.c:51 [inline]
>        __do_sys_ioctl fs/ioctl.c:597 [inline]
>        __se_sys_ioctl fs/ioctl.c:583 [inline]
>        __arm64_sys_ioctl+0x14c/0x1c4 fs/ioctl.c:583
>        __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>        invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
>        el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
>        do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
>        el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
>        el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:7=
55
>        el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
>
> -> #1 (sb_writers#3){.+.+}-{0:0}:
>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline=
]
>        __sb_start_write include/linux/fs/super.h:19 [inline]
>        sb_start_write include/linux/fs/super.h:125 [inline]
>        ovl_start_write+0xf0/0x324 fs/overlayfs/util.c:32
>        ovl_do_copy_up fs/overlayfs/copy_up.c:977 [inline]
>        ovl_copy_up_one fs/overlayfs/copy_up.c:1189 [inline]
>        ovl_copy_up_flags+0x980/0x28a4 fs/overlayfs/copy_up.c:1243
>        ovl_maybe_copy_up+0x108/0x148 fs/overlayfs/copy_up.c:1272
>        ovl_open+0x12c/0x2c0 fs/overlayfs/file.c:211
>        do_dentry_open+0x5c4/0xfc8 fs/open.c:947
>        vfs_open+0x44/0x2d4 fs/open.c:1079
>        do_open fs/namei.c:4699 [inline]
>        path_openat+0x2234/0x2a6c fs/namei.c:4858
>        do_file_open+0x1c4/0x2e4 fs/namei.c:4887
>        do_sys_openat2+0x114/0x1e8 fs/open.c:1364
>        do_sys_open+0xac/0xdc fs/open.c:1370
>        __do_sys_openat fs/open.c:1386 [inline]
>        __se_sys_openat fs/open.c:1381 [inline]
>        __arm64_sys_openat+0x9c/0xb8 fs/open.c:1381
>        __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>        invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
>        el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
>        do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
>        el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
>        el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:7=
55
>        el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
>
> -> #0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x1780/0x2f44 kernel/locking/lockdep.c:5237
>        lock_acquire+0x140/0x368 kernel/locking/lockdep.c:5868
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x160/0xef8 kernel/locking/mutex.c:820
>        mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:8=
98
>        ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
>        ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735
>        ovl_copy_up_one fs/overlayfs/copy_up.c:1182 [inline]
>        ovl_copy_up_flags+0x768/0x28a4 fs/overlayfs/copy_up.c:1243
>        ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
>        ovl_rename_start fs/overlayfs/dir.c:1176 [inline]
>        ovl_rename+0x2d8/0xfec fs/overlayfs/dir.c:1363
>        vfs_rename+0xa78/0xd48 fs/namei.c:6064
>        filename_renameat2+0x66c/0x730 fs/namei.c:6182
>        __do_sys_renameat2 fs/namei.c:6211 [inline]
>        __se_sys_renameat2 fs/namei.c:6206 [inline]
>        __arm64_sys_renameat2+0xe4/0x114 fs/namei.c:6206
>        __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>        invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
>        el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
>        do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
>        el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
>        el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:7=
55
>        el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
>
> other info that might help us debug this:
>
> Chain exists of:
>   &ovl_i_lock_key[depth] --> sb_writers#3 --> &ovl_i_mutex_key[depth]/4
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ovl_i_mutex_key[depth]/4);
>                                lock(sb_writers#3);
>                                lock(&ovl_i_mutex_key[depth]/4);
>   lock(&ovl_i_lock_key[depth]);
>
>  *** DEADLOCK ***
>
> 5 locks held by syz.3.611/8517:
>  #0: ffff00010bddc410 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write+0x4=
4/0x9c fs/namespace.c:493
>  #1: ffff00010bddc718 (&type->s_vfs_rename_key#3){+.+.}-{4:4}, at: lock_r=
ename fs/namei.c:3791 [inline]
>  #1: ffff00010bddc718 (&type->s_vfs_rename_key#3){+.+.}-{4:4}, at: __star=
t_renaming+0xec/0x33c fs/namei.c:3880
>  #2: ffff0000eee14300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: in=
ode_lock_nested include/linux/fs.h:1074 [inline]
>  #2: ffff0000eee14300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: lo=
ck_two_directories+0x19c/0x214 fs/namei.c:3767
>  #3: ffff0000eee13810 (&ovl_i_mutex_dir_key[depth]/5){+.+.}-{4:4}, at: in=
ode_lock_nested include/linux/fs.h:1074 [inline]
>  #3: ffff0000eee13810 (&ovl_i_mutex_dir_key[depth]/5){+.+.}-{4:4}, at: lo=
ck_two_directories+0x1c4/0x214 fs/namei.c:3768
>  #4: ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: inode_=
lock_nested include/linux/fs.h:1074 [inline]
>  #4: ffff0000eee13d88 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: lock_t=
wo_nondirectories+0xe8/0x148 fs/inode.c:1256
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 8517 Comm: syz.3.611 Tainted: G             L      syz=
kaller #0 PREEMPT
> Tainted: [L]=3DSOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 03/18/2026
> Call trace:
>  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
>  __dump_stack+0x30/0x40 lib/dump_stack.c:94
>  dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
>  dump_stack+0x1c/0x28 lib/dump_stack.c:129
>  print_circular_bug+0x328/0x330 kernel/locking/lockdep.c:2043
>  check_noncircular+0x158/0x174 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x1780/0x2f44 kernel/locking/lockdep.c:5237
>  lock_acquire+0x140/0x368 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>  __mutex_lock+0x160/0xef8 kernel/locking/mutex.c:820
>  mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:898
>  ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
>  ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735
>  ovl_copy_up_one fs/overlayfs/copy_up.c:1182 [inline]
>  ovl_copy_up_flags+0x768/0x28a4 fs/overlayfs/copy_up.c:1243
>  ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
>  ovl_rename_start fs/overlayfs/dir.c:1176 [inline]
>  ovl_rename+0x2d8/0xfec fs/overlayfs/dir.c:1363
>  vfs_rename+0xa78/0xd48 fs/namei.c:6064
>  filename_renameat2+0x66c/0x730 fs/namei.c:6182
>  __do_sys_renameat2 fs/namei.c:6211 [inline]
>  __se_sys_renameat2 fs/namei.c:6206 [inline]
>  __arm64_sys_renameat2+0xe4/0x114 fs/namei.c:6206
>  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>  invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
>  el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
>  el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
>  el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:755
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
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

#syz dup: possible deadlock in lock_two_nondirectories (2)

ext4 bug should be fixed in linux-next I think.

Thanks,
Amir.
