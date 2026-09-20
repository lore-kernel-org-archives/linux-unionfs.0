Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC00230E0F8
	for <linux-unionfs@vger.kernel.org>; Sun, 20 Sep 2026 02:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789870055; cv=none; b=c0HhrIkJkv7Z7L6BVyX3blozMdvl2dAhbVONB6j2wifcJlA1Q55QAy0CQB1YnzsrFOIiH7n6KVqU7sliGCuESHNi6zUQ7ozz5pPRjwLICZBTD4mRHj2FP1qBk1LUnd+jwHrJntn1ZjU/O6tNJeC9hghLt2YgypZq5TwARBuwX1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789870055; c=relaxed/simple;
	bh=0bXEI+7xiR8ilrELAcPYOOnXvB3PpIyDN247cHezXG8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SwA5viNLqAqn4qBEzbTp/j3HAPciZ4qfWAEtyJEpHncGXX2K3EOVOZwGvi2aPdOFsSlr3sle454znj72ItQ9+HaPCC+atDoEN0vH3wS//HI4GABL3Y54Ih1Lf2XY9pmoKwMbXuFo504ury8/J/zO/pFYEipEzZMH1F8JjgtFUnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f9.google.com with SMTP id 46e09a7af769-7f4e9ec63a7so493582a34.1
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Sep 2026 19:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789870053; x=1790474853;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wy6an1eEYCYD2xmcZ5WHO0C/0bzHxsVdancvouZbW+A=;
        b=vQg0HkprzqL475b1vZ/Dtl2iOEAoTE6YS7G4H8Rq4xUfuIDjm919fD0AU11KUzL+U9
         iLsDyrieqPNnYy9y1Bk2U2BlYseUOaaJ7K0gp1OigDcUuPTY0ZJgS82wrXHU9ZijngZg
         2y+kVnNBoMDHckoJvUDZTfYB6ysWWGSxQrK0Xga+U9AVMzM7+eSsd6EPkQwe86P3eU2j
         kMnjDLYb42IvhN29m80KNeM77+gxoa+d95Ek7Su6BG51WMIs80bwxztZ7wZivyE7wKNQ
         JTZr4G8Q85/jAqRlM7RYC3ESu/44Ec3oupPEMGIxqKxrhAYy4pYdgYTXWd8JmEuTl93k
         qNHw==
X-Forwarded-Encrypted: i=1; AKwUvBwcUCN5BG4uZvi2cuYqr56+yc9cr1r935FX7GlV2pGKNJxt3ENT+YVD3gs0InD9OBxaHuOF8kWmcLCTL6H+@vger.kernel.org
X-Gm-Message-State: AFuF++lEfyoYKTNcssc4Rdd3sNJ4BTP53jWS6k+3dBuaeX/bQqy+wNHP
	CTgunkamAWswNliigpBP8oWu9dvdMYi5LnDCq6TXE7ROGRPk2IZdZdg8lECJQDsfT7I3+TE9jN1
	ge0cuPYDUgIbgwNRW+I5qRya9N1vHlcbI7g/kgpnwA0FaxozPe+G1U99jU/8=
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d05:b0:6b9:4557:2722 with SMTP id
 006d021491bc7-6ca9a22ae52mr5847087eaf.3.1789870052698; Sat, 19 Sep 2026
 19:07:32 -0700 (PDT)
Date: Sat, 19 Sep 2026 19:07:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaf3fe4.71f81b7d.15fa6d.0012.GAE@google.com>
Subject: [syzbot] [overlayfs?] KASAN: slab-use-after-free Read in dentry_name
From: syzbot <syzbot+ced26b784bf977d223dd@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    587858367581 Merge tag 'nfsd-7.3-1' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10346115580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=ced26b784bf977d223dd
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d88c04c59b33/disk-58785836.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/72c83a98da52/vmlinux-58785836.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f0ed551a82ec/bzImage-58785836.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ced26b784bf977d223dd@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in dentry_name+0x328/0xb90 lib/vsprintf.c:926
Read of size 8 at addr ffff88804090c3c0 by task syz.9.246/8095

CPU: 0 UID: 0 PID: 8095 Comm: syz.9.246 Tainted: G             L      syzkaller #0 PREEMPT_{RT,(full)} 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/08/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 dentry_name+0x328/0xb90 lib/vsprintf.c:926
 pointer+0x31a/0x1120 lib/vsprintf.c:2587
 vsnprintf+0x626/0xef0 lib/vsprintf.c:2953
 va_format lib/vsprintf.c:1725 [inline]
 pointer+0xa12/0x1120 lib/vsprintf.c:2577
 vsnprintf+0x626/0xef0 lib/vsprintf.c:2953
 vprintk_store+0x3d9/0xdc0 kernel/printk/printk.c:2307
 vprintk_emit+0x192/0x560 kernel/printk/printk.c:2455
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 __dynamic_pr_debug+0x1a2/0x260 lib/dynamic_debug.c:879
 ovl_do_mkdir fs/overlayfs/overlayfs.h:258 [inline]
 ovl_workdir_create+0x86f/0x8b0 fs/overlayfs/super.c:345
 ovl_make_workdir fs/overlayfs/super.c:678 [inline]
 ovl_get_workdir+0x339/0x1980 fs/overlayfs/super.c:836
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
 vfs_get_super fs/super.c:1391 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1410
 vfs_get_tree+0x92/0x2a0 fs/super.c:1933
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efca640e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007efca4666028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007efca6695fa0 RCX: 00007efca640e159
RDX: 00002000000001c0 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007efca64a503b R08: 0000200000000280 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efca6696038 R14: 00007efca6695fa0 R15: 00007ffe1c4c4c78
 </TASK>

Allocated by task 8095:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:340 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 kmem_cache_alloc_lru_noprof+0x35d/0x680 mm/slub.c:5029
 __d_alloc+0x37/0x6f0 fs/dcache.c:1907
 d_alloc+0x4b/0x190 fs/dcache.c:1986
 lookup_one_qstr_excl+0xd8/0x360 fs/namei.c:1806
 __start_dirop fs/namei.c:2920 [inline]
 start_dirop fs/namei.c:2942 [inline]
 start_creating+0xce/0x100 fs/namei.c:3406
 ovl_start_creating_upper fs/overlayfs/overlayfs.h:429 [inline]
 ovl_workdir_create+0x1a1/0x8b0 fs/overlayfs/super.c:321
 ovl_make_workdir fs/overlayfs/super.c:678 [inline]
 ovl_get_workdir+0x339/0x1980 fs/overlayfs/super.c:836
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
 vfs_get_super fs/super.c:1391 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1410
 vfs_get_tree+0x92/0x2a0 fs/super.c:1933
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 20:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6508 [inline]
 kmem_cache_free+0x187/0x6d0 mm/slub.c:6635
 rcu_do_batch kernel/rcu/tree.c:2650 [inline]
 rcu_core kernel/rcu/tree.c:2919 [inline]
 rcu_cpu_kthread+0xb2c/0x1740 kernel/rcu/tree.c:3007
 smpboot_thread_fn+0x565/0xa70 kernel/smpboot.c:160
 kthread+0x38b/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3181 [inline]
 call_rcu+0xee/0x8b0 kernel/rcu/tree.c:3301
 dentry_kill+0x4d3/0x880 fs/dcache.c:845
 finish_dput+0x1a/0x260 fs/dcache.c:1001
 end_dirop fs/namei.c:2956 [inline]
 end_creating include/linux/namei.h:120 [inline]
 vfs_mkdir+0x11c/0x620 fs/namei.c:5422
 ovl_do_mkdir fs/overlayfs/overlayfs.h:257 [inline]
 ovl_workdir_create+0x45f/0x8b0 fs/overlayfs/super.c:345
 ovl_make_workdir fs/overlayfs/super.c:678 [inline]
 ovl_get_workdir+0x339/0x1980 fs/overlayfs/super.c:836
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
 vfs_get_super fs/super.c:1391 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1410
 vfs_get_tree+0x92/0x2a0 fs/super.c:1933
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88804090c370
 which belongs to the cache dentry of size 376
The buggy address is located 80 bytes inside of
 freed 376-byte region [ffff88804090c370, ffff88804090c4e8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4090c
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88802a5fe701
flags: 0x80000000000040(head|node=0|zone=1)
page_type: f5(slab)
raw: 0080000000000040 ffff8881404153c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000200120012 00000000f5000000 ffff88802a5fe701
head: 0080000000000040 ffff8881404153c0 dead000000000100 dead000000000122
head: 0000000000000000 0000000200120012 00000000f5000000 ffff88802a5fe701
head: 0080000000000001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Reclaimable, gfp_mask 0xd20d0(__GFP_RECLAIMABLE|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4953, tgid 4953 (udevd), ts 60620923678
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2591/0x2600 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x230/0x5c0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d8/0x350 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x339/0x690 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 kmem_cache_alloc_lru_noprof+0x455/0x680 mm/slub.c:5029
 __d_alloc+0x37/0x6f0 fs/dcache.c:1907
 d_alloc_parallel+0xde/0x16c0 fs/dcache.c:2766
 lookup_open+0x2cd/0x1a60 fs/namei.c:4471
 open_last_lookups fs/namei.c:4767 [inline]
 path_openat+0x67c/0x1d60 fs/namei.c:4997
 do_file_open+0x23e/0x4a0 fs/namei.c:5029
 do_sys_openat2+0x115/0x200 fs/open.c:1417
 do_sys_open fs/open.c:1423 [inline]
 __do_sys_openat fs/open.c:1439 [inline]
 __se_sys_openat fs/open.c:1434 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88804090c280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88804090c300: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fa fb
>ffff88804090c380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88804090c400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804090c480: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
==================================================================


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
