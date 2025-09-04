Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727DA21B905
	for <linux-unionfs@vger.kernel.org>; Thu,  4 Sep 2025 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757007458; cv=none; b=I8dYGH4n7wn5pAySDN5wtveV3bzjaio3BY9+jTg7NbxDiX8fP8DkOP7oYrp5xJE5wzCKxCr2xhPfQOjMghB2VYTMNKZA2Ahy9A9fbpLW7zqQZX2JANDEIQEa1gAH9JeIMpmSyJGxl+cNHU7N/Mo62glKw8iVWllOZohhRud4Cxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757007458; c=relaxed/simple;
	bh=c8phXDRGuP4RFa7Su71+pPic2BRm7F2K5LDn849SkVo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hA1muRYQQvfaTOEs5ftmSjXBOuXAdly5MFfAYQ3xdBlK9GyEMTAYaqG5ISA8XeU6p5ynWEnuWdyA3IivwM7JkUoLBvtb49NhTboFLsWgYoqJpMlvtDnnCCTwM5nugYAMFh5Vpw+zNe1iCOgWawHFivfM9On189seJawHfsqvJM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-886ff73eacbso285926139f.1
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Sep 2025 10:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757007455; x=1757612255;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B67CoAyT9lN//NfjL3cGNHLF/6eSj2ViSPf13hmW4/0=;
        b=FExul+mBJD76QE3ZAQ2lWJGVmvJqnu0V0swgOCo1v4Bv8W0WKeBR0NxfwR11uagBQu
         A+GF+9y8oSDE/rb2o0OixlY3Rd/GAUnYqDx22oAG+VTpf+wYJNvSnlfkFi/+miSwAvkl
         y7ens16lTUT1z1BNvrqcjjfc5FDvqIjOTCd6xzBQn5rpHPVaMQbBcgQKZya8nqKcPS53
         8AuLFZpJdLTTVfnXRNGAObwOnAYYUlRVLh6to/n2WjisPGizrmU9i22gb7IgmD1U/A7F
         IZTbBdFttZOndcpRtwzGBRe+vrrxROX4JaPvtsrkH92wurKss1NnNk7FTABHsghFAnsr
         3NhA==
X-Forwarded-Encrypted: i=1; AJvYcCVU4EmfUpoBoG/K5BZGwtxa74lT0Nw6xIDhBC3k5DcRfM4JWC/sAeRVTjmdzSh9w4D0TKeQz7ZoySYIcbrX@vger.kernel.org
X-Gm-Message-State: AOJu0YyeZsJGc9UPeKrYAiOnvhNFs4CQSQpLsGLj4Ds+QZm9F1fzcFz2
	MvM7mrnN8i6oO+vkJm4fPH0NY+7aRXEKrZjB4siWiDrbuIAKrYkc0IVgyyQqxJdsmf7oUTEFPcJ
	Mn7uA4W9Amppqm048Fj6YnWgcjqqajkcgt/Sc6QqWZ7pbMjqwVRWMHYqR05k=
X-Google-Smtp-Source: AGHT+IFt4xK3p3rLl3WMO2liZqs/UMct1Y/1ktxLI2LvbhXFgj5ojyLmRMLlzpgt3IYMve6t+HMmDEtO6S4dIY45Ef1NBMsoVfOI
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2302:b0:3f1:88bc:d4b7 with SMTP id
 e9e14a558f8ab-3f401be283emr322063305ab.17.1757007455631; Thu, 04 Sep 2025
 10:37:35 -0700 (PDT)
Date: Thu, 04 Sep 2025 10:37:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b9ce5f.a00a0220.eb3d.0007.GAE@google.com>
Subject: [syzbot] [overlayfs?] [bcachefs?] possible deadlock in vfs_link
From: syzbot <syzbot+1090a418b58c19e9a57b@syzkaller.appspotmail.com>
To: amir73il@gmail.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15322e62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=1090a418b58c19e9a57b
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121cea42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15589e62580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/cf46540aa8ee/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1090a418b58c19e9a57b@syzkaller.appspotmail.com

bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
============================================
WARNING: possible recursive locking detected
6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 Not tainted
--------------------------------------------
syz.0.19/6755 is trying to acquire lock:
ffff0000ec7c5c68 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
ffff0000ec7c5c68 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: vfs_link+0x2f0/0x590 fs/namei.c:4845

but task is already holding lock:
ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_create_temp fs/overlayfs/dir.c:228 [inline]
ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_create_over_whiteout fs/overlayfs/dir.c:473 [inline]
ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_create_or_link+0x608/0x11b8 fs/overlayfs/dir.c:629

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_mutex_key#21);
  lock(&sb->s_type->i_mutex_key#21);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by syz.0.19/6755:
 #0: ffff0000dcc7e428 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:557
 #1: ffff0000ec7b1e50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:914 [inline]
 #1: ffff0000ec7b1e50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: filename_create+0x1ac/0x32c fs/namei.c:4139
 #2: ffff0000ec7b2418 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #2: ffff0000ec7b2418 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: vfs_link+0x2f0/0x590 fs/namei.c:4845
 #3: ffff0000ec7b27d0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:672 [inline]
 #3: ffff0000ec7b27d0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: ovl_nlink_start+0x2fc/0x6e0 fs/overlayfs/util.c:1176
 #4: ffff0000d2034428 (sb_writers#11){.+.+}-{0:0}, at: mnt_want_write+0x44/0x9c fs/namespace.c:557
 #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_create_temp fs/overlayfs/dir.c:228 [inline]
 #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_create_over_whiteout fs/overlayfs/dir.c:473 [inline]
 #5: ffff0000ec7c54d0 (&sb->s_type->i_mutex_key#21){++++}-{4:4}, at: ovl_create_or_link+0x608/0x11b8 fs/overlayfs/dir.c:629

stack backtrace:
CPU: 0 UID: 0 PID: 6755 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_deadlock_bug+0x2e8/0x2f0 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x2940/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
 down_write+0x50/0xc0 kernel/locking/rwsem.c:1590
 inode_lock include/linux/fs.h:869 [inline]
 vfs_link+0x2f0/0x590 fs/namei.c:4845
 ovl_do_link fs/overlayfs/overlayfs.h:227 [inline]
 ovl_create_real+0x11c/0x3fc fs/overlayfs/dir.c:179
 ovl_create_temp fs/overlayfs/dir.c:229 [inline]
 ovl_create_over_whiteout fs/overlayfs/dir.c:473 [inline]
 ovl_create_or_link+0x62c/0x11b8 fs/overlayfs/dir.c:629
 ovl_link+0x1d8/0x258 fs/overlayfs/dir.c:746
 vfs_link+0x3e0/0x590 fs/namei.c:4854
 do_linkat+0x224/0x48c fs/namei.c:4924
 __do_sys_linkat fs/namei.c:4952 [inline]
 __se_sys_linkat fs/namei.c:4949 [inline]
 __arm64_sys_linkat+0xdc/0xf8 fs/namei.c:4949
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
