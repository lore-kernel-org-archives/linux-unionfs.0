Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038423C062C
	for <linux-unionfs@vger.kernel.org>; Wed,  5 Aug 2026 08:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785917558; cv=none; b=n0H3Xn0zJxKTnTYlT/H/DL/XnF6VdqUJtMdIlAc4mcaB3VmKJFQT7qUnikuEDxTzzahAkICl0YQPd2Fp+tVc4U+ui7HLE8F9O896NSOo+8LRH+tzspymkWunfCDzH1ev+7SaDLyRWOI9Q2chxdrBZHQJZ/mVgnEUg+K1IVOq7rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785917558; c=relaxed/simple;
	bh=bib/NS6a/e77f/ueMxIJ1KHiK5jjD1kMXUeRp9+VseI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nnFjd9FiOACNCK4NugkFthXudDu/7W/RW3q6m9V2ysGAYpQq3Dy4DMRfuB4dlnKO18rKWqBAXRPMurtPYQex/7nSLYqLIqAs+9DpYtc68blXYXc7dhFjamMo/z+HwviKUEXz97YGVqJFCTj4RrZn0m3l4rD9JZeQEnTN7YDx/cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-448bb8bd2efso1236020fac.0
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Aug 2026 01:12:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785917543; x=1786522343;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N3JqnfFDthVpvstPw4UQmXcAA8g78I1d277x90H8XYs=;
        b=cxKeKsQftf4QWKPDOE3zX2EWjWqRyCaYoseOsG16szsmwTwjsGz8A/+d+5Q2jn9BlM
         TfZAwRVWXtL0afNGiFzTZOkYRYXsD/pUUV7UGR1C9dZj1f/j+abn8R87mvj00G2A4JBT
         Pt3uarNX8//bxvc20wIj5IXmdTAJ25D7EY079bM5YgvPPgI9/CtHNI4wtMH3K26MyxTc
         LI7ViUzj2npzgREIet5cCgLubIj4rT8B+i8manbyVWjZU0gxXbV4HtrN3ag3h6Guqi36
         5P7N1f7GM/Ouq3mOe8G6mOrvUsje+yMnWBE1LnvEo2zVrNimqq9gLkyyi4HfhcW5KwXD
         Og0Q==
X-Forwarded-Encrypted: i=1; AHgh+RoUmbnZXtUBYLQg6BOi4Ii5OxJMd8loaa1wpQ1qofxM93JRjW+prITneB+YPaEeoq5P4ISWniEqOTG87Rhx@vger.kernel.org
X-Gm-Message-State: AOJu0YyNBGY5Z61/WrlsSAxB+tiuyLok2/wjqlht5F1iePEnfu4PB6EP
	NQFJWjOyB4j710MjnMwdx6obS8t/a6oYPoyf18Ek9nbDLZ9B+qpUr5CUjpJnPIRK/QVCa4v3ffZ
	OvbzKFPWM1VOliJXpfGSqLep9qg2sF5b7fY/amp2k7ZJjGzhGZFSJj2OL+CA=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ac2:b0:6ae:901e:b312 with SMTP id
 006d021491bc7-6ae97005448mr2698301eaf.29.1785917543338; Wed, 05 Aug 2026
 01:12:23 -0700 (PDT)
Date: Wed, 05 Aug 2026 01:12:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a72f067.13623e66.bdc14.0055.GAE@google.com>
Subject: [syzbot] [overlayfs?] possible deadlock in mnt_want_write (9)
From: syzbot <syzbot+da381387152f0dd8bedf@syzkaller.appspotmail.com>
To: a.hindborg@kernel.org, amir73il@gmail.com, leitao@debian.org, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cc2b5f627e8c Add linux-next specific files for 20260714
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13631e32580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2290ccbf984c524f
dashboard link: https://syzkaller.appspot.com/bug?extid=da381387152f0dd8bedf
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11178db9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16b2f4c6580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6836f8efb1da/disk-cc2b5f62.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0109d3477cc7/vmlinux-cc2b5f62.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c2e49e350bbf/bzImage-cc2b5f62.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+da381387152f0dd8bedf@syzkaller.appspotmail.com

Mass Storage Function, version: 2009/09/11
LUN: removable file: (no medium)
============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz-executor262/5614 is trying to acquire lock:
ffff88801dfd2510 (sb_writers#8){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:494

but task is already holding lock:
ffff88801dfd2510 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2731 [inline]
ffff88801dfd2510 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sb_writers#8);
  lock(sb_writers#8);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

locks held by syz-executor262/5614: 4, last CPU#1:
 #0: ffff88801dfd2510 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2731 [inline]
 #0: ffff88801dfd2510 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0 fs/read_write.c:683
 #1: ffff888028861a78 (&buffer->mutex){+.+.}-{4:4}, at: configfs_write_iter+0x81/0x430 fs/configfs/file.c:226
 #2: ffff888033abd068 (&p->frag_sem){.+.+}-{4:4}, at: flush_write_buffer fs/configfs/file.c:205 [inline]
 #2: ffff888033abd068 (&p->frag_sem){.+.+}-{4:4}, at: configfs_write_iter+0x23b/0x430 fs/configfs/file.c:229
 #3: ffff888038383998 (&common->filesem){+.+.}-{4:4}, at: fsg_store_file+0x163/0x400 drivers/usb/gadget/function/storage_common.c:452

stack backtrace:
CPU: 1 UID: 0 PID: 5614 Comm: syz-executor262 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x27a/0x290 kernel/locking/lockdep.c:3057
 check_deadlock kernel/locking/lockdep.c:3109 [inline]
 validate_chain kernel/locking/lockdep.c:3911 [inline]
 __lock_acquire+0x261c/0x2e40 kernel/locking/lockdep.c:5254
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5906
 percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
 mnt_want_write+0x41/0x90 fs/namespace.c:494
 open_last_lookups fs/namei.c:4591 [inline]
 path_openat+0xa7b/0x3850 fs/namei.c:4854
 do_file_open+0x23e/0x4a0 fs/namei.c:4886
 file_open_name fs/open.c:1326 [inline]
 filp_open+0x16d/0x1d0 fs/open.c:1343
 fsg_lun_open+0x6c/0xe00 drivers/usb/gadget/function/storage_common.c:194
 fsg_store_file+0x19e/0x400 drivers/usb/gadget/function/storage_common.c:455
 flush_write_buffer fs/configfs/file.c:207 [inline]
 configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x17b/0x530 arch/x86/entry/syscall_64.c:85
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f79667de649
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe39c70488 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000200000000100 RCX: 00007f79667de649
RDX: 0000000000000002 RSI: 0000200000000f00 RDI: 0000000000000003
RBP: 69666e6f635f796d R08: 0000000000000006 R09: 0000000000000006
R10: 0000000000000006 R11: 0000000000000246 R12: 00007ffe39c705f8
R13: 0000200000000108 R14: 00007f7966871c40 R15: 0000000000000002
 </TASK>
mass_storage.usb0/lun.0: unable to open backing file: fi


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
