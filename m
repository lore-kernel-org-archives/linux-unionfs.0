From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [overlayfs] lockdep splat after mounting overlayfs over overlayfs
Date: Wed, 24 Jun 2015 18:55:45 +0300
Message-ID: <558AD301.4070302@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:59548 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169AbbFXPzu (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 24 Jun 2015 11:55:50 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

I've accidentally mounted one overlayfs over another and got obvious 
warning from lockdep: i_mutex lockdep classes are per-fs-type.

# mount -t overlay overlay 1 -o 
upperdir=1_upper,workdir=1_work,lowerdir=1_lower
# mount -t overlay overlay 2 -o upperdir=2_upper,workdir=2_work,lowerdir=1
# ls 2

[  305.098705] =============================================
[  305.099011] [ INFO: possible recursive locking detected ]
[  305.099011] 4.1.0+ #76 Not tainted
[  305.099011] ---------------------------------------------
[  305.099011] ls/3070 is trying to acquire lock:
[  305.099011]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: 
[<ffffffff811b9ac0>] iterate_dir+0x70/0x130
[  305.099011]
[  305.099011] but task is already holding lock:
[  305.099011]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: 
[<ffffffff811b9ac0>] iterate_dir+0x70/0x130
[  305.099011]
[  305.099011] other info that might help us debug this:
[  305.099011]  Possible unsafe locking scenario:
[  305.099011]
[  305.099011]        CPU0
[  305.099011]        ----
[  305.099011]   lock(&sb->s_type->i_mutex_key#13);
[  305.099011]   lock(&sb->s_type->i_mutex_key#13);
[  305.099011]
[  305.099011]  *** DEADLOCK ***
[  305.099011]
[  305.099011]  May be due to missing lock nesting notation
[  305.099011]
[  305.099011] 1 lock held by ls/3070:
[  305.099011]  #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: 
[<ffffffff811b9ac0>] iterate_dir+0x70/0x130
[  305.099011]
[  305.099011] stack backtrace:
[  305.099011] CPU: 2 PID: 3070 Comm: ls Not tainted 4.1.0+ #76
[  305.099011] Hardware name: OpenStack Foundation OpenStack Nova, BIOS 
Bochs 01/01/2011
[  305.099011]  ffff880037f40000 ffff880037fa3b48 ffffffff81991179 
0000000000000007
[  305.099011]  ffffffff825ac1a0 ffff880037fa3c38 ffffffff810a92ea 
0000000000000000
[  305.099011]  0000000000000000 ffff8802110eaea0 ffff88021118c720 
ffff880214576710
[  305.099011] Call Trace:
[  305.099011]  [<ffffffff81991179>] dump_stack+0x4c/0x65
[  305.099011]  [<ffffffff810a92ea>] __lock_acquire+0x91a/0x1f60
[  305.099011]  [<ffffffff811d0a1b>] ? inode_to_bdi+0x2b/0x60
[  305.099011]  [<ffffffff810ab0d1>] lock_acquire+0xd1/0x290
[  305.099011]  [<ffffffff811b9ac0>] ? iterate_dir+0x70/0x130
[  305.099011]  [<ffffffff8199b2c8>] mutex_lock_killable_nested+0x68/0x440
[  305.099011]  [<ffffffff811b9ac0>] ? iterate_dir+0x70/0x130
[  305.099011]  [<ffffffff811b9ac0>] ? iterate_dir+0x70/0x130
[  305.099011]  [<ffffffff811b9ac0>] iterate_dir+0x70/0x130
[  305.099011]  [<ffffffff812fcf05>] ovl_dir_read_merged+0x125/0x160
[  305.099011]  [<ffffffff812fcc10>] ? ovl_cache_entry_new+0x110/0x110
[  305.099011]  [<ffffffff812fd45d>] ovl_iterate+0x14d/0x1e0
[  305.099011]  [<ffffffff811b9afc>] iterate_dir+0xac/0x130
[  305.099011]  [<ffffffff811c4d64>] ? __fget_light+0x74/0xa0
[  305.099011]  [<ffffffff811b9c87>] SyS_getdents+0x87/0x100
[  305.099011]  [<ffffffff811b9920>] ? filldir64+0x140/0x140
[  305.099011]  [<ffffffff8199e5ae>] entry_SYSCALL_64_fastpath+0x12/0x76

-- 
Konstantin
