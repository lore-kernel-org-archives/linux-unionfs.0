Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49023C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF28422CBB
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Dec 2020 06:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgLUGP6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:15:58 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:33424 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbgLUGP6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Dec 2020 01:15:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=liangyan.peng@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UJDWx70_1608531300;
Received: from LiangyandeMacBook-Pro.local(mailfrom:liangyan.peng@linux.alibaba.com fp:SMTPD_---0UJDWx70_1608531300)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Dec 2020 14:15:11 +0800
Subject: Re: [PATCH v2] ovl: fix dentry leak in ovl_get_redirect
To:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
From:   Liangyan <liangyan.peng@linux.alibaba.com>
Message-ID: <f4191ccc-e436-bd98-1ff9-6e0958304521@linux.alibaba.com>
Date:   Mon, 21 Dec 2020 14:14:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201220120927.115232-1-liangyan.peng@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Guys, any comments on this patch? This issue should exist in latest 
upstream.

On 20/12/20 下午8:09, Liangyan wrote:
> We need to lock d_parent->d_lock before dget_dlock, or this may
> have d_lockref updated parallelly like calltrace below which will
> cause dentry->d_lockref leak and risk a crash.
> 
> npm-20576 [028] .... 5705749.040094:
> [28] ovl_set_redirect+0x11c/0x310 //tmp = dget_dlock(d->d_parent);
> [28]?  ovl_set_redirect+0x5/0x310
> [28] ovl_rename+0x4db/0x790 [overlay]
> [28] vfs_rename+0x6e8/0x920
> [28] do_renameat2+0x4d6/0x560
> [28] __x64_sys_rename+0x1c/0x20
> [28] do_syscall_64+0x55/0x1a0
> [28] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> npm-20574 [036] .... 5705749.040094:
> [36] __d_lookup+0x107/0x140 //dentry->d_lockref.count++;
> [36] lookup_fast+0xe0/0x2d0
> [36] walk_component+0x48/0x350
> [36] link_path_walk+0x1bf/0x650
> [36]?  path_init+0x1f6/0x2f0
> [36] path_lookupat+0x82/0x210
> [36] filename_lookup+0xb8/0x1a0
> [36]?  __audit_getname+0xa2/0xb0
> [36]?  getname_flags+0xb9/0x1e0
> [36]?  vfs_statx+0x73/0xe0
> [36] vfs_statx+0x73/0xe0
> [36] __do_sys_statx+0x3b/0x80
> [36]?  syscall_trace_enter+0x1ae/0x2c0
> [36] do_syscall_64+0x55/0x1a0
> [36] entry_SYSCALL_64_
> 
> [   49.799059] PGD 800000061fed7067 P4D 800000061fed7067 PUD 61fec5067 PMD 0
> [   49.799689] Oops: 0002 [#1] SMP PTI
> [   49.800019] CPU: 2 PID: 2332 Comm: node Not tainted 4.19.24-7.20.al7.x86_64 #1
> [   49.800678] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 8a46cfe 04/01/2014
> [   49.801380] RIP: 0010:_raw_spin_lock+0xc/0x20
> [   49.803470] RSP: 0018:ffffac6fc5417e98 EFLAGS: 00010246
> [   49.803949] RAX: 0000000000000000 RBX: ffff93b8da3446c0 RCX: 0000000a00000000
> [   49.804600] RDX: 0000000000000001 RSI: 000000000000000a RDI: 0000000000000088
> [   49.805252] RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff993cf040
> [   49.805898] R10: ffff93b92292e580 R11: ffffd27f188a4b80 R12: 0000000000000000
> [   49.806548] R13: 00000000ffffff9c R14: 00000000fffffffe R15: ffff93b8da3446c0
> [   49.807200] FS:  00007ffbedffb700(0000) GS:ffff93b927880000(0000) knlGS:0000000000000000
> [   49.807935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   49.808461] CR2: 0000000000000088 CR3: 00000005e3f74006 CR4: 00000000003606a0
> [   49.809113] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   49.809758] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   49.810410] Call Trace:
> [   49.810653]  d_delete+0x2c/0xb0
> [   49.810951]  vfs_rmdir+0xfd/0x120
> [   49.811264]  do_rmdir+0x14f/0x1a0
> [   49.811573]  do_syscall_64+0x5b/0x190
> [   49.811917]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   49.812385] RIP: 0033:0x7ffbf505ffd7
> [   49.814404] RSP: 002b:00007ffbedffada8 EFLAGS: 00000297 ORIG_RAX: 0000000000000054
> [   49.815098] RAX: ffffffffffffffda RBX: 00007ffbedffb640 RCX: 00007ffbf505ffd7
> [   49.815744] RDX: 0000000004449700 RSI: 0000000000000000 RDI: 0000000006c8cd50
> [   49.816394] RBP: 00007ffbedffaea0 R08: 0000000000000000 R09: 0000000000017d0b
> [   49.817038] R10: 0000000000000000 R11: 0000000000000297 R12: 0000000000000012
> [   49.817687] R13: 00000000072823d8 R14: 00007ffbedffb700 R15: 00000000072823d8
> [   49.818338] Modules linked in: pvpanic cirrusfb button qemu_fw_cfg atkbd libps2 i8042
> [   49.819052] CR2: 0000000000000088
> [   49.819368] ---[ end trace 4e652b8aa299aa2d ]---
> [   49.819796] RIP: 0010:_raw_spin_lock+0xc/0x20
> [   49.821880] RSP: 0018:ffffac6fc5417e98 EFLAGS: 00010246
> [   49.822363] RAX: 0000000000000000 RBX: ffff93b8da3446c0 RCX: 0000000a00000000
> [   49.823008] RDX: 0000000000000001 RSI: 000000000000000a RDI: 0000000000000088
> [   49.823658] RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff993cf040
> [   49.825404] R10: ffff93b92292e580 R11: ffffd27f188a4b80 R12: 0000000000000000
> [   49.827147] R13: 00000000ffffff9c R14: 00000000fffffffe R15: ffff93b8da3446c0
> [   49.828890] FS:  00007ffbedffb700(0000) GS:ffff93b927880000(0000) knlGS:0000000000000000
> [   49.830725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   49.832359] CR2: 0000000000000088 CR3: 00000005e3f74006 CR4: 00000000003606a0
> [   49.834085] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   49.835792] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> Fixes: a6c606551141 ("ovl: redirect on rename-dir")
> Signed-off-by: Liangyan <liangyan.peng@linux.alibaba.com>
> Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>   fs/overlayfs/dir.c | 18 +++++++++++++++++-
>   1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 28a075b5f5b2..a78d35017371 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -973,6 +973,7 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>   	for (d = dget(dentry); !IS_ROOT(d);) {
>   		const char *name;
>   		int thislen;
> +		struct dentry *parent = NULL;
>   
>   		spin_lock(&d->d_lock);
>   		name = ovl_dentry_get_redirect(d);
> @@ -992,7 +993,22 @@ static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
>   
>   		buflen -= thislen;
>   		memcpy(&buf[buflen], name, thislen);
> -		tmp = dget_dlock(d->d_parent);
> +		parent = d->d_parent;
> +		if (unlikely(!spin_trylock(&parent->d_lock))) {
> +			rcu_read_lock();
> +			spin_unlock(&d->d_lock);
> +again:
> +			parent = READ_ONCE(d->d_parent);
> +			spin_lock(&parent->d_lock);
> +			if (unlikely(parent != d->d_parent)) {
> +				spin_unlock(&parent->d_lock);
> +				goto again;
> +			}
> +			rcu_read_unlock();
> +			spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
> +		}
> +		tmp = dget_dlock(parent);
> +		spin_unlock(&parent->d_lock);
>   		spin_unlock(&d->d_lock);
>   
>   		dput(d);
> 
