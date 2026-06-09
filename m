Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444C6221FCD
	for <linux-unionfs@vger.kernel.org>; Tue,  9 Jun 2026 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781013809; cv=pass; b=ruUqZrVWmaKy9vObidFQ9AoUwYEFCRm3zPcLle5nEYQ5WwLpIdsPQfLEO9lyWmXH8a34HQAVFmdZW37Wr+XUoY91R9Hi8Al6Z03solE8jF7aHue8ciGEDF0pQ0qJC/zNpUOJfQMzTcg2KIqHMoNQ9cXxgr5HbihMl6pylC1KU1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781013809; c=relaxed/simple;
	bh=cuuuWEfGzs88fFkquVOrnCQYKSP8RGnIEF9r8hEp2jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p0NI0yihHzjuFgEqpbSu8WWRa7iyGiQ/+7TNxvThK6Y+/KqGguRPXl6mQOfDfu5UGKiEcrptlaToZCaqLfvjdSC2vVoXo5m8WgvC0bMYtJg9MXX44lYfr8lycdM6J1QmYdVhSJlM2U/TvNa18YC924hMziSg3J/Y66Nvmbnn/4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWR8xhXW; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWR8xhXW"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bec2ddee9bbso1115496866b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jun 2026 07:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781013806; cv=none;
        d=google.com; s=arc-20240605;
        b=cPclEA4ZNIpeW7QSiqvBJHTes/OVsJgDRfHRJoDf6HnIkpVLykEjwdKc7H3uaKPaey
         4fuO0BeqKXwKXSwx0kxc4HqXkeYTcwf8c+mudC09K1TRvniMnB2sMJ5OoPTAEXFhhq57
         BI2mBcZWncSCEdo/G49D4vs2IuVMWNkefyYmPlTj2GLu9t9pkkEj8SFrHAKXEcJFa6EH
         UcDaBGLo2HC+0dmuhhtKGSbO8F5QRdJgyc5cDygtWvaOiofulRxAukCHM+Cm+Hc+kWwa
         zk1siHKoBHh/EjM2PzO5Fhpg3siGR8tizKVuHq4eu/bp4fPxAB17q7sYQ73/2FEL0RV0
         m6Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zna9EW1pgkdskV0n1Gl57sSI7Im3X2Y5ovPSJSGvOq4=;
        fh=lcLspUKdVlg8K/YB2neRGckXr7xx9amExGj/43HXQFQ=;
        b=SfChJpKgskXtBqYTn3IuF3XhxiJoDUcELcsVhFq9m4oF9xpmTGaa67aFkDOMkwABZn
         j/XM0iK3rOLKghCv03guDh3s00maSbAcmspISSw+4tdomPDN9DIEpT3uLu35/3Zw1gTu
         AjoLZHHror6HYFsw9A8v4N+e7nxMyOzUWltuCGVc24OagqABOnILWKHdf5mcWY0skxHl
         h+m/PDWWwn+OLTiwxQ4wQpnb52EUVmF4UGkhHATKy7zLqJKt4hc8wZIhf8SBapjNiZeQ
         QjQC1/+dU1m4ZiW2vmS0tGOg/QK+she9EPtidcaTr4KUIXYLY5dN63Qe7XkDf16pbj83
         tqog==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781013806; x=1781618606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zna9EW1pgkdskV0n1Gl57sSI7Im3X2Y5ovPSJSGvOq4=;
        b=HWR8xhXWVUEpmLvJjIP7cXGVaY3ofXzc0Da8IAojMeJoq63DDe14d4jfYYg3vn0UUD
         Nvj3g2HIFUD63PaK2B/qzQNV8OlvCGoywgBOvYtQ/3rDOYg0QGLzBXfIHk03OjL9kvRR
         qYl4siwjmSUccM9qTt0qRIN41CAbJOBvCV1VMQbXVE/d9kkY2P667uG3T/+mJvU0Q6Fw
         j10JCcfKJeyQzR8fBGHlMk7xjm/Nq2guizIDORZ2xH6hcvmTlwCdg9/tP1Vl7t/IleEJ
         IRJ1OkcoLwXwUbl61oV7vY3DuT/XLDcfqPaCqI5J7afcKHxTLQSOXBRjnDwoRSNUTNlT
         Ea9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781013806; x=1781618606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zna9EW1pgkdskV0n1Gl57sSI7Im3X2Y5ovPSJSGvOq4=;
        b=ikJQzKOx3KyKuSYkdhdAB/f7hiN5qbyFl6dM3sDGwwvnIO30ZCSLmTsaJtIMc2tBPD
         b+pCL9iHYM65Mfuf7xwtha0nb1TnV3O14iWze90IxyMfKdKIo6mFvDIa8HSM45ouondE
         XnUtj1C15BkTbhbnMIj/Yua1DFJ+45mGl9g0zr3TGTJTkgTZm8qcKm3GC2btKGHjz/ZU
         W5btqO8S1aSg870CuAfLIcAQQ80V5u7+sSGqPaPHXinX9MdkI0uWCFUopF1RAdwHbyeW
         /pJRjLc1qNXdkYpuM0JCOq+PK9UER4+G/hq0IXmimRufuA5L6mG0eLshlukGfP+xm43e
         OqXA==
X-Forwarded-Encrypted: i=1; AFNElJ/UZY1CUV6MRIxK2JKZu/OVIWaAF83dC6y5q4cqiCXOBDPI3detb1WdISfPzPGT9pCDkSh7udjL+tUmcAHl@vger.kernel.org
X-Gm-Message-State: AOJu0YxjOlOe0jAxhLDL3nf4iuA2IBJG0WeWvoaeaAxULZ91+fk31Oxz
	zIIpYi9rpLIg1Dm2uGuzTo0uYuy0aQJEWW69iZ21R8pn2S1M1uo+icjGuO++MBo0sGF+AkmWvwg
	A0MKW8M61rUXk/EH60D19AGfGsObVCtI=
X-Gm-Gg: Acq92OHWRL/6iqm9Xa1YSIO46Fu+ezu5H9eZBHgw5XTfX5oIMxtfNnSQ8Beq+shCTe6
	CoS1cmarjSHOgR6eewoXnUrjX2tGh3lSWpeZDq1yRA2FzWw4t6IKTnBfWN7yC9h7wcLX9O+9DEZ
	dIWQ0pFqsvx85BS2fztHXkdRBgIdJRKeoS8uGxtZBvZHvV5PJqhxlaZRjXvcMegeGxkHDnUpOkR
	oS9kU3eu5XgSr5FelZ43E5B2/c+6zHQr/JeEORMyrsLTD9Y60TrA+7wrH0+b+6D/LKQXTOmkL+G
	QswtOaoWA89qHV2/YYMT+hilUD+FvtydKuoNMEKBNSxyRO9mFgdlZtSCsw5jApA=
X-Received: by 2002:a17:907:a44:b0:bd3:cb24:ae61 with SMTP id
 a640c23a62f3a-bf37037d2eemr1073355466b.6.1781013805082; Tue, 09 Jun 2026
 07:03:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6a274d14.c25708ab.1b19ef.0016.GAE@google.com>
In-Reply-To: <6a274d14.c25708ab.1b19ef.0016.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 9 Jun 2026 16:03:13 +0200
X-Gm-Features: AVVi8CfIWzuh1vU9VKzkQSdILi0NS0uY5oHB9qa99RCqXfqTuG_QqjBiUDzItSE
Message-ID: <CAOQ4uxijzsZOuJ-8vpvQAcwm7bi+0VMJ4WqBfBrvQUHYqfNL6A@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] possible deadlock in mnt_want_write (8)
To: syzbot <syzbot+1e5626d6fd59853cbfaa@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 1:15=E2=80=AFAM syzbot
<syzbot+1e5626d6fd59853cbfaa@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ec7ef10b77a6 Merge branch 'for-next/core' into for-kernel=
ci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux=
.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17a17dd258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D522222e78af9b=
9d2
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D1e5626d6fd59853=
cbfaa
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25=
a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> userspace arch: arm64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/22c81873d970/dis=
k-ec7ef10b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ba2c817c4ea9/vmlinu=
x-ec7ef10b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/04c4e1c1bb56/I=
mage-ec7ef10b.gz.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+1e5626d6fd59853cbfaa@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Tainted: G             L
> ------------------------------------------------------
> syz.5.673/7842 is trying to acquire lock:
> ffff0000d814a410 (sb_writers#3){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c=
 fs/namespace.c:493
>
> but task is already holding lock:
> ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock=
_interruptible fs/overlayfs/overlayfs.h:705 [inline]
> ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_nlink_star=
t+0xc8/0x350 fs/overlayfs/util.c:1173
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&ovl_i_lock_key[depth]){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x160/0xef8 kernel/locking/mutex.c:820
>        mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:8=
98
>        ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
>        ovl_copy_up_start+0x58/0x264 fs/overlayfs/util.c:735
>        ovl_copy_up_one fs/overlayfs/copy_up.c:1182 [inline]
>        ovl_copy_up_flags+0x768/0x28a4 fs/overlayfs/copy_up.c:1243
>        ovl_copy_up+0x24/0x34 fs/overlayfs/copy_up.c:1282
>        ovl_link+0x8c/0x26c fs/overlayfs/dir.c:774
>        vfs_link+0x40c/0x580 fs/namei.c:5774
>        filename_linkat+0x224/0x478 fs/namei.c:5842
>        __do_sys_linkat fs/namei.c:5868 [inline]
>        __se_sys_linkat fs/namei.c:5863 [inline]
>        __arm64_sys_linkat+0xe8/0x118 fs/namei.c:5863
>        __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>        invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
>        el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:121
>        do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:140
>        el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:736
>        el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:7=
55
>        el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:594
>
> -> #1 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}:
>        down_write+0x50/0xc0 kernel/locking/rwsem.c:1625
>        inode_lock include/linux/fs.h:1029 [inline]
>        lock_two_nondirectories+0xc4/0x148 fs/inode.c:1254
>        ext4_move_extents+0x194/0x3580 fs/ext4/move_extent.c:589
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
> -> #0 (sb_writers#3){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x1780/0x2f44 kernel/locking/lockdep.c:5237
>        lock_acquire+0x140/0x368 kernel/locking/lockdep.c:5868
>        percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>        percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline=
]
>        __sb_start_write include/linux/fs/super.h:19 [inline]
>        sb_start_write+0x5c/0x294 include/linux/fs/super.h:125
>        mnt_want_write+0x44/0x9c fs/namespace.c:493
>        ovl_want_write fs/overlayfs/util.c:38 [inline]
>        ovl_nlink_start+0x154/0x350 fs/overlayfs/util.c:1177
>        ovl_do_remove+0x1c0/0xa04 fs/overlayfs/dir.c:954
>        ovl_rmdir+0x24/0x34 fs/overlayfs/dir.c:993
>        vfs_rmdir+0x34c/0x5a0 fs/namei.c:5366
>        filename_rmdir+0x208/0x3dc fs/namei.c:5421
>        __do_sys_unlinkat fs/namei.c:5596 [inline]
>        __se_sys_unlinkat fs/namei.c:5589 [inline]
>        __arm64_sys_unlinkat+0xc8/0x104 fs/namei.c:5589
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
>   sb_writers#3 --> &ovl_i_mutex_key[depth] --> &ovl_i_lock_key[depth]
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ovl_i_lock_key[depth]);
>                                lock(&ovl_i_mutex_key[depth]);
>                                lock(&ovl_i_lock_key[depth]);
>   rlock(sb_writers#3);
>
>  *** DEADLOCK ***
>
> 4 locks held by syz.5.673/7842:
>  #0: ffff0000d924c410 (sb_writers#17){.+.+}-{0:0}, at: mnt_want_write+0x4=
4/0x9c fs/namespace.c:493
>  #1: ffff0000dc944300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: in=
ode_lock_nested include/linux/fs.h:1074 [inline]
>  #1: ffff0000dc944300 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: __=
start_dirop+0xa0/0xf4 fs/namei.c:2914
>  #2: ffff0000dc946ec0 (&ovl_i_mutex_dir_key[depth]){++++}-{4:4}, at: inod=
e_lock include/linux/fs.h:1029 [inline]
>  #2: ffff0000dc946ec0 (&ovl_i_mutex_dir_key[depth]){++++}-{4:4}, at: vfs_=
rmdir+0x110/0x5a0 fs/namei.c:5351
>  #3: ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode=
_lock_interruptible fs/overlayfs/overlayfs.h:705 [inline]
>  #3: ffff0000dc947230 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_nlink=
_start+0xc8/0x350 fs/overlayfs/util.c:1173
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 7842 Comm: syz.5.673 Tainted: G             L      syz=
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
>  percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
>  percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
>  __sb_start_write include/linux/fs/super.h:19 [inline]
>  sb_start_write+0x5c/0x294 include/linux/fs/super.h:125
>  mnt_want_write+0x44/0x9c fs/namespace.c:493
>  ovl_want_write fs/overlayfs/util.c:38 [inline]
>  ovl_nlink_start+0x154/0x350 fs/overlayfs/util.c:1177
>  ovl_do_remove+0x1c0/0xa04 fs/overlayfs/dir.c:954
>  ovl_rmdir+0x24/0x34 fs/overlayfs/dir.c:993
>  vfs_rmdir+0x34c/0x5a0 fs/namei.c:5366
>  filename_rmdir+0x208/0x3dc fs/namei.c:5421
>  __do_sys_unlinkat fs/namei.c:5596 [inline]
>  __se_sys_unlinkat fs/namei.c:5589 [inline]
>  __arm64_sys_unlinkat+0xc8/0x104 fs/namei.c:5589
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

Thanks,
Amir.
