Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9219430E0E5
	for <linux-unionfs@vger.kernel.org>; Thu, 22 Jan 2026 13:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769087371; cv=none; b=fzAJsPltHnx2NANm68/qjxAgXiE1j1ymDMwBtra5eMhMEBSVpRsg7ryw8ZXs+/QGfeplnnTyIw4IBtgc6ndA3H94wy34R+6d9TeQIB2vpCcqLHIoPI9dmbqpyyouKjy7oXqUnaim3m79eWsBukG0rNYDu6WWjnYau2LsR3enP7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769087371; c=relaxed/simple;
	bh=PGg+eVgvY4bIeoyfwGdyWg4lzRNl/eeKxEsy7xdmrYs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n/tNgP7zI6SMMpVyjef5G5pJ26lFAZ+ZW/soIplCM+wiB6U1e8SKsKDklsOT0zStZ4j84vV3QiggJLYFldoQ5Zk9ZZ2+bOmbeWoBZnN53ipucJTa5RHHNCmOrS2WKwSDPUXPR+sqvQSTKw8c4DxeS0XwjZYSTpDsH3Vefegfyto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-662c90deacbso430505eaf.0
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Jan 2026 05:09:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769087368; x=1769692168;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LdT7TRCYtut8tIIXI6jhdytlJPt71OASFO+tS0ZYiO8=;
        b=AU5nqidMmNq5zPm7ch4XoU1TIKtmdUgTDKMcWUdqQpAnnRv0VgJMzFwcCSobKn1Tmi
         TKFe3e4J9h3HA2VDULNVBEdart8OPYk+yMcI445wBal3GimrOHlDtGm0JQ7OLtYQl+RZ
         wHvCc3O6XlZc6vG0RE+Wcvr60JkmwqRKnZ6ctyNXSN8PdCPQnGoRSge29wEt+TzmRauC
         i0YMV7ra5RLgmDDytdIHU8OZsVZL6OIzmUN370HjI/DKLdM8HnZ/8072DNBE1T10Ez4T
         cGh3qK/nZzmVJ6AVcW4cODjJi69/CRVuYRUvbtjP48x4Nk8ewDOBIKf8LbsofbtlTVGH
         hzlw==
X-Forwarded-Encrypted: i=1; AJvYcCWkQRIe1dpLlnVwGtq/+4ZcXrthVbBcf9hl7LYy+n/x/6HBDKohxBDS7fdR1fwP230WYicjof/iDi0D3wSX@vger.kernel.org
X-Gm-Message-State: AOJu0YxbIXMwqPnWyv6kIuYet9yRHocMCo+OQ0gOrl2DT28ET4nLqK6M
	rKIVUM0O+s0NwekdbrJ8137uAvM2QOHOVUJIL2BcS43MLhejMaOkbKiXgzcsVqpUpsphxookgiT
	0pRYIZXbHg1tJrXI1Ow+7rDqpk2UE+Yx3NOrUsp41NlbAuxJeJlWPzKxkXDU=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2902:b0:662:c6a0:b3b0 with SMTP id
 006d021491bc7-662c6a0bf35mr722526eaf.57.1769087368511; Thu, 22 Jan 2026
 05:09:28 -0800 (PST)
Date: Thu, 22 Jan 2026 05:09:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69722188.a70a0220.111c58.0043.GAE@google.com>
Subject: [syzbot] [overlayfs?] KMSAN: uninit-value in ovl_fill_real
From: syzbot <syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d12453c7e281 Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ca6b9a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46b5f80a6e7aaa5c
dashboard link: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/72a742184eaf/disk-d12453c7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/27a786c1192a/vmlinux-d12453c7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3c272ecc6877/bzImage-d12453c7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com

EXT4-fs: Quota format mount options ignored when QUOTA feature is enabled
EXT4-fs (loop1): Test dummy encryption mode enabled
EXT4-fs (loop1): mounted filesystem 00000000-0000-0000-0000-000000000000 r/w without journal. Quota mode: writeback.
=====================================================
BUG: KMSAN: uninit-value in ovl_fill_real+0x1df/0x920 fs/overlayfs/readdir.c:758
 ovl_fill_real+0x1df/0x920 fs/overlayfs/readdir.c:758
 dir_emit include/linux/fs.h:3527 [inline]
 ext4_readdir+0x320e/0x6f30 fs/ext4/dir.c:304
 iterate_dir+0x452/0x620 fs/readdir.c:108
 ovl_iterate_real fs/overlayfs/readdir.c:829 [inline]
 ovl_iterate+0x1e84/0x47d0 fs/overlayfs/readdir.c:909
 wrap_directory_iterator+0xda/0x180 fs/readdir.c:65
 shared_ovl_iterate+0x3d/0x50 fs/overlayfs/readdir.c:1065
 iterate_dir+0x452/0x620 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64+0x17e/0x550 fs/readdir.c:396
 __ia32_sys_getdents64+0x96/0xe0 fs/readdir.c:396
 ia32_sys_call+0x353e/0x4340 arch/x86/include/generated/asm/syscalls_32.h:221
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0x154/0x320 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:332
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:370
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4960 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_noprof+0xaf2/0x1c20 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 fscrypt_fname_alloc_buffer+0x52/0x110 fs/crypto/fname.c:223
 ext4_readdir+0xaf6/0x6f30 fs/ext4/dir.c:169
 iterate_dir+0x452/0x620 fs/readdir.c:108
 ovl_iterate_real fs/overlayfs/readdir.c:829 [inline]
 ovl_iterate+0x1e84/0x47d0 fs/overlayfs/readdir.c:909
 wrap_directory_iterator+0xda/0x180 fs/readdir.c:65
 shared_ovl_iterate+0x3d/0x50 fs/overlayfs/readdir.c:1065
 iterate_dir+0x452/0x620 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64+0x17e/0x550 fs/readdir.c:396
 __ia32_sys_getdents64+0x96/0xe0 fs/readdir.c:396
 ia32_sys_call+0x353e/0x4340 arch/x86/include/generated/asm/syscalls_32.h:221
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0x154/0x320 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/syscall_32.c:332
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/syscall_32.c:370
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 1 UID: 0 PID: 30053 Comm: syz.1.3910 Tainted: G             L      syzkaller #0 PREEMPT(none) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
