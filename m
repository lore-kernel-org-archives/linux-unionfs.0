Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E493398E;
	Tue, 26 Nov 2024 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732630835; cv=none; b=S8bYsKEiLUR9lSsMpmepbldk1ToCMxBbLMk6sCauyD7l9hSSQCZ1V+wfh/g5qSIeuiTIxlw6n9Un3gJEqw/6Y8HCHzpNZUmtW0vZ86Y3HO/1IFFE7K83XhuOK3ZD6exgZA3ONFpMgjZARRqnnqQhwB02MdoqWku7w5fpWwoNmxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732630835; c=relaxed/simple;
	bh=GnkMNDsp75aQER4IAg4W8CLlKh5NI42fXOlImOfYZRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YzCSGGhSpUlh1xR13HsUKmHYbjrbCDIdspnatlz35AtbZU2jhciFEx3FNwv1ha3bVPQLSEw5eXc0B7y9YCH1/50x4skRA3rLnN3Ms2H3rXwERU5tEfC1yu3MNJYniwKxVERdC+IJNhQiPjtoIoY8/q+bo/EppRGnQHjiM5E16cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lwTyoVqi; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lwTyoVqi"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa549d9dffdso376862266b.2;
        Tue, 26 Nov 2024 06:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732630831; x=1733235631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dIuz28KcMEguH3lwJAWKjbBcYxl9WpTIyypDwn3NopY=;
        b=lwTyoVqi9mfCss3XS4G7Ynqn8RK6nPktFLvjaHCXoiVWf1scKpR82K1xZe2ZnOYmBF
         XBp9SbDuuY3IWPhppWIF+2uFO/TMc18H945t8UO5btSTpgSQwWCLV5HgwnaotwDjDJRb
         2XSulmtb/86e6SQShZjbaFxfXVx1ymPta6LAX60DimyhEcOz5sUC83Zmve/jh9YXn4bR
         yOILCEtbZ5cZr0wBIFbnlE0z1GXPG+fj31pUrFBAsj1ccUQjI0GYZOvQoXzA6z/0Lr/d
         xAAKn/sz+aqphgP2qushTA7KVdAxIDl4pDqt6/815tfKgpuLTDq59M4iox0jeTnN21+K
         3CxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732630831; x=1733235631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dIuz28KcMEguH3lwJAWKjbBcYxl9WpTIyypDwn3NopY=;
        b=cuYtNb7Wit7c7Xo44qcEyQc/QP5ASa69eg2sBMGsnBxkb+OL26k74bTUvLcROyGi8R
         DshUQVFUKnvPYitJWP4mPbPqCrSzb41amW7GP5KrNorhrVwjHu54A2ZzAsoHFslKoemV
         wFTYVh2nKH4+kTYsoTQag0LeF45//8eE3NFZ3d1rbC1rAflTlIipV/PLsVSMp/7oActN
         GPaQE8uYkxj3+ZhT8jItWg6hK1dsa4UR2XrWNXPopoqno44zBPk0YHwF8fVDwR2WA9zy
         cq84p9zE5YGWWq3P1teBaX2jtET0S5Mrwu3mpNi4T8eDkIYweasw42m7CcT9fOTB8kT2
         v3IA==
X-Forwarded-Encrypted: i=1; AJvYcCVOsoa9z4b1YxJp57qylNeaOir8gpEWtdVJEV5+P/vVfV1VPgTfvo+mYHThOoNLsqCYr3KlLUrQo3UXoOPP@vger.kernel.org
X-Gm-Message-State: AOJu0YzNbAoBhkjzQuDjP0HBwVLqSkG83Da+0/pbA/r6aWySZeZ0BBYN
	UNFHvP9ihRPFfKrQSNelBrBOJW3XeQR77lBpYS6JIUjrYVR4y9OGHLpKDmUeWkuRnVLE/6zydh1
	liynljVXWIiF3yLotq5VCSLvNcUeJbAsLn1I=
X-Gm-Gg: ASbGncs99vINURkOTPRvQIXG0lfLYoxrDHLqEryT5n6+mUaiT7gDUXPdy96sTVg9N5D
	p9t28y7tL5cRpLIrzRikCWtf6hZKyDLs=
X-Google-Smtp-Source: AGHT+IEjZbIH1XVCQfzXmYmxxdQtcDyFYLjNKyGBO4er58A2qm76VvOgkaYKdQ8S8ehRduJCrXrDta/bPyC5t7dR/lE=
X-Received: by 2002:a17:906:2182:b0:aa5:391e:cad5 with SMTP id
 a640c23a62f3a-aa5391eccd8mr921386166b.33.1732630831187; Tue, 26 Nov 2024
 06:20:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67447b3c.050a0220.1cc393.0085.GAE@google.com>
In-Reply-To: <67447b3c.050a0220.1cc393.0085.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 Nov 2024 15:20:18 +0100
Message-ID: <CAOQ4uxibdcHmnkn15G1M+8Ay7TK_4uB1tUi06+yuPWAze382Lg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] KASAN: slab-out-of-bounds Read in ovl_inode_upper
To: syzbot <syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2024 at 2:27=E2=80=AFPM syzbot
<syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    85a2dd7d7c81 Add linux-next specific files for 20241125
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D10b5277858000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D45719eec4c74e=
6ba
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D8d1206605b05ca9=
a0e6a
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10b46530580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1578dee858000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/5422dd6ada68/dis=
k-85a2dd7d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3a382ed71d3a/vmlinu=
x-85a2dd7d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/9b4d03eb0da3/b=
zImage-85a2dd7d.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/29b16c7eaa=
78/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+8d1206605b05ca9a0e6a@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in ovl_upperdentry_dereference fs/overlayf=
s/ovl_entry.h:195 [inline]
> BUG: KASAN: slab-out-of-bounds in ovl_i_dentry_upper fs/overlayfs/util.c:=
366 [inline]
> BUG: KASAN: slab-out-of-bounds in ovl_inode_upper+0x36/0x80 fs/overlayfs/=
util.c:386
> Read of size 8 at addr ffff88807df938e0 by task syz-executor150/5827
>
> CPU: 0 UID: 0 PID: 5827 Comm: syz-executor150 Not tainted 6.12.0-next-202=
41125-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0x169/0x550 mm/kasan/report.c:489
>  kasan_report+0x143/0x180 mm/kasan/report.c:602
>  ovl_upperdentry_dereference fs/overlayfs/ovl_entry.h:195 [inline]
>  ovl_i_dentry_upper fs/overlayfs/util.c:366 [inline]
>  ovl_inode_upper+0x36/0x80 fs/overlayfs/util.c:386
>  ovl_file_accessed+0x7e/0x370 fs/overlayfs/file.c:307
>  backing_file_mmap+0x1f8/0x260 fs/backing-file.c:345
>  ovl_mmap+0x1c9/0x220 fs/overlayfs/file.c:487
>  call_mmap include/linux/fs.h:2183 [inline]
>  mmap_file mm/internal.h:124 [inline]
>  __mmap_new_file_vma mm/vma.c:2291 [inline]
>  __mmap_new_vma mm/vma.c:2355 [inline]
>  __mmap_region+0x2204/0x2cd0 mm/vma.c:2456
>  mmap_region+0x1d0/0x2c0 mm/mmap.c:1347
>  do_mmap+0x8f0/0x1000 mm/mmap.c:496
>  vm_mmap_pgoff+0x214/0x430 mm/util.c:580
>  ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:542
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb229019739
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffdd8656a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 00007fb229019739
> RDX: 0000000000000000 RSI: 0000000000004000 RDI: 0000000020ffc000
> RBP: 00007fb22908d610 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000012 R11: 0000000000000246 R12: 0000000000000001
> R13: 00007fffdd865878 R14: 0000000000000001 R15: 0000000000000001
>  </TASK>
>
> Allocated by task 5827:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
>  unpoison_slab_object mm/kasan/common.c:319 [inline]
>  __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:345
>  kasan_slab_alloc include/linux/kasan.h:250 [inline]
>  slab_post_alloc_hook mm/slub.c:4104 [inline]
>  slab_alloc_node mm/slub.c:4153 [inline]
>  kmem_cache_alloc_lru_noprof+0x1dd/0x390 mm/slub.c:4172
>  nilfs_alloc_inode+0x2e/0x110 fs/nilfs2/super.c:158
>  alloc_inode+0x65/0x1a0 fs/inode.c:336
>  iget5_locked+0x4a/0xa0 fs/inode.c:1404
>  nilfs_iget_locked fs/nilfs2/inode.c:535 [inline]
>  nilfs_iget+0x130/0x810 fs/nilfs2/inode.c:544
>  nilfs_lookup+0x198/0x210 fs/nilfs2/namei.c:69
>  __lookup_slow+0x28c/0x3f0 fs/namei.c:1791
>  lookup_slow fs/namei.c:1808 [inline]
>  lookup_one_unlocked+0x1a4/0x290 fs/namei.c:2966
>  ovl_lookup_positive_unlocked fs/overlayfs/namei.c:210 [inline]
>  ovl_lookup_single+0x200/0xbd0 fs/overlayfs/namei.c:240
>  ovl_lookup_layer+0x417/0x510 fs/overlayfs/namei.c:333
>  ovl_lookup+0xcf7/0x2a60 fs/overlayfs/namei.c:1124
>  lookup_open fs/namei.c:3627 [inline]
>  open_last_lookups fs/namei.c:3748 [inline]
>  path_openat+0x11a7/0x3590 fs/namei.c:3984
>  do_filp_open+0x27f/0x4e0 fs/namei.c:4014
>  do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
>  do_sys_open fs/open.c:1417 [inline]
>  __do_sys_open fs/open.c:1425 [inline]
>  __se_sys_open fs/open.c:1421 [inline]
>  __x64_sys_open+0x225/0x270 fs/open.c:1421
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88807df93300
>  which belongs to the cache nilfs2_inode_cache of size 1504
> The buggy address is located 0 bytes to the right of
>  allocated 1504-byte region [ffff88807df93300, ffff88807df938e0)
>
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7df9=
0
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0xfff00000000040(head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000040 ffff88801f711140 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000080140014 00000001f5000000 0000000000000000
> head: 00fff00000000040 ffff88801f711140 dead000000000122 0000000000000000
> head: 0000000000000000 0000000080140014 00000001f5000000 0000000000000000
> head: 00fff00000000003 ffffea0001f7e401 ffffffffffffffff 0000000000000000
> head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Reclaimable, gfp_mask 0xd205=
0(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_REC=
LAIMABLE), pid 5827, tgid 5827 (syz-executor150), ts 58768101635, free_ts 1=
5530782696
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
>  prep_new_page mm/page_alloc.c:1564 [inline]
>  get_page_from_freelist+0x3725/0x3870 mm/page_alloc.c:3510
>  __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4787
>  alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
>  alloc_slab_page+0x6a/0x140 mm/slub.c:2408
>  allocate_slab+0x5a/0x2f0 mm/slub.c:2574
>  new_slab mm/slub.c:2627 [inline]
>  ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3815
>  __slab_alloc+0x58/0xa0 mm/slub.c:3905
>  __slab_alloc_node mm/slub.c:3980 [inline]
>  slab_alloc_node mm/slub.c:4141 [inline]
>  kmem_cache_alloc_lru_noprof+0x26c/0x390 mm/slub.c:4172
>  nilfs_alloc_inode+0x2e/0x110 fs/nilfs2/super.c:158
>  alloc_inode+0x65/0x1a0 fs/inode.c:336
>  iget5_locked+0x4a/0xa0 fs/inode.c:1404
>  nilfs_iget_locked+0x113/0x160 fs/nilfs2/inode.c:535
>  nilfs_dat_read+0xc3/0x320 fs/nilfs2/dat.c:511
>  nilfs_load_super_root fs/nilfs2/the_nilfs.c:118 [inline]
>  load_nilfs+0x579/0x1090 fs/nilfs2/the_nilfs.c:299
>  nilfs_fill_super+0x31e/0x720 fs/nilfs2/super.c:1067
> page last free pid 1 tgid 1 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1127 [inline]
>  free_unref_page+0xdf9/0x1140 mm/page_alloc.c:2693
>  free_contig_range+0x152/0x550 mm/page_alloc.c:6666
>  destroy_args+0x92/0x910 mm/debug_vm_pgtable.c:1017
>  debug_vm_pgtable+0x4be/0x550 mm/debug_vm_pgtable.c:1397
>  do_one_initcall+0x248/0x880 init/main.c:1266
>  do_initcall_level+0x157/0x210 init/main.c:1328
>  do_initcalls+0x3f/0x80 init/main.c:1344
>  kernel_init_freeable+0x435/0x5d0 init/main.c:1577
>  kernel_init+0x1d/0x2b0 init/main.c:1466
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Memory state around the buggy address:
>  ffff88807df93780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88807df93800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88807df93880: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>                                                        ^
>  ffff88807df93900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88807df93980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>

#syz test: https://github.com/amir73il/linux ovl-fixes
