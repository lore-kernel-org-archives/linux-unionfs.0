Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7E03515CD
	for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2026 09:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.117.225.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787563617; cv=none; b=dX9mLmSjYNvurHPKBBu9qOkqHPZj2JN23TX3nwXsQfnnruvhNZfAPOjUEKRzTK18aMJSu51xPcbNQSc1medua/3w/Zj6Ajk+rmTlf4LbuWd7szA1/Bp94NnDc1OcDvGwwar7SzBhZ80WQ71nqdX7pdxzXeQWZWoswwXPWHBW5WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787563617; c=relaxed/simple;
	bh=rR/T8Nzv482I/B6OijVU6luYLxZpuwpgUsmgsVjFGqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KrqxLpWj+TISUrns51jof1JJqEy6cErJsBv1JZ7VHsWx4jpNCpIv0FhOiFpK5tDVyrehFxiDCNP+IsjgnVZq4EupROJqn3gbMLj5D1QCiNfcfhQWngKgHD2AMPi4KbwL/Kj7uDyb4+G0q2qUopKzs35ZWWhCWCimP4AFKksRfqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=rIayUPeI; arc=none smtp.client-ip=130.117.225.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="rIayUPeI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=br9j+PnJyP4tQ0/uAIU1nFlhWBf2F9j+eZWrDJdCe54=; b=rIayUPeIyAQG
	L8RI9NVeOisPastxoU8rxkAMFoUsoAlhkmgYXgSO14ras6dVT0mNpadZK0KbHkLSA1k6ph3tRhhli
	VHgUYctbFFFak6CrslZXfY12tx/pm457oy3E27m1F6WhBjFNfSp3fxmAeyoEEhy4WidiU637zoHGg
	P44fHahJJoGhKx7xbyxWELkg0j15TTS5gtXM8ctNC+Qi8r3t2/tGA0TPWxJn+GYdXaofsRaNDwSto
	gq38tYDh+XXl3shTkVctS14CZBxhY3rFiJpqopyLw8gF3slwKslGARBUHqXhfvWYddSRJh481996l
	y6SjEZNnaQ5X0SueZIPrYw==;
Received: from [130.117.225.5] (helo=dev012.aci.vzint.dev)
	by relay.virtuozzo.com with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <vladimir.riabchun@virtuozzo.com>)
	id 1wyQfa-00Cbo7-1X;
	Mon, 24 Aug 2026 11:10:49 +0200
From: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
To: miklos@szeredi.hu,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org
Cc: vladimir.riabchun@virtuozzo.com
Subject: [PATCH] ovl: Fix NULL dereference in ovl_get_index_name_fh
Date: Mon, 24 Aug 2026 09:10:40 +0000
Message-ID: <20260824091040.155481-1-vladimir.riabchun@virtuozzo.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We observed several crashes in overlayfs with the following trace:
[ 2300.870181] BUG: kernel NULL pointer dereference, address: 0000000000000005
[ 2300.871537] #PF: supervisor read access in kernel mode
[ 2300.872577] #PF: error_code(0x0000) - not-present page
[ 2300.873595] PGD 800000010a18f067 P4D 800000010a18f067 PUD 10730c067 PMD 0
[ 2300.874900] Oops: Oops: 0000 [#1] SMP PTI
[ 2300.875742] CPU: 1 UID: 0 PID: 5419 Comm: criu ve: 0 Kdump: loaded Not tainted 6.12.0-211.39.1.16.6.vz10.x86_64 #1 16.6 PREEMPT(voluntary)
[ 2300.878057] Hardware name: Acronis OpenStack Compute/Virtuozzo, BIOS 1.16.1-1.vz9.2 04/01/2014
[ 2300.879684] RIP: 0010:ovl_get_index_name_fh+0x18/0x70 [overlay]
[ 2300.880859] Code: 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 0f 1f 44 00 00 41 54 49 89 f4 be c0 0d 00 00 55 53 48 89 fb <0f> b6 7f 05 48 01 ff e8 bc 42 2f ea 48 85 c0 74 33 0f b6 53 05 48
[ 2300.884128] RSP: 0018:ffffd32582e0f7c0 EFLAGS: 00010246
[ 2300.885153] RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff8ba4497480a8
[ 2300.886480] RDX: ffff8ba45535dc00 RSI: 0000000000000dc0 RDI: 0000000000000000
[ 2300.887824] RBP: ffff8ba68f9daa80 R08: ffff8ba4497480a8 R09: 000000000000030e
[ 2300.889139] R10: 0000000000000000 R11: ffff8ba44862d6d0 R12: ffffd32582e0f800
[ 2300.890498] R13: 0000000000000000 R14: ffff8ba497cb0110 R15: ffff8ba517548cc0
[ 2300.891838] FS:  00007f5a2f492880(0000) GS:ffff8bab9fc80000(0000) knlGS:0000000000000000
[ 2300.893376] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2300.894476] CR2: 0000000000000005 CR3: 000000033403a005 CR4: 00000000003726f0
[ 2300.895807] Call Trace:
[ 2300.896397]  <TASK>
[ 2300.896938]  ? show_trace_log_lvl+0x1b0/0x2f0
[ 2300.897854]  ? show_trace_log_lvl+0x1b0/0x2f0
[ 2300.898748]  ? ovl_create_index+0x82/0x260 [overlay]
[ 2300.899766]  ? __die_body.cold+0x8/0x12
[ 2300.900582]  ? page_fault_oops+0x148/0x160
[ 2300.901562]  ? exc_page_fault+0x7f/0x150
[ 2300.902406]  ? asm_exc_page_fault+0x26/0x30
[ 2300.903298]  ? ovl_get_index_name_fh+0x18/0x70 [overlay]
[ 2300.904435]  ovl_create_index+0x82/0x260 [overlay]
[ 2300.905406]  ovl_copy_up_workdir+0x30a/0x330 [overlay]
[ 2300.906427]  ovl_do_copy_up+0x10d/0x2e0 [overlay]
[ 2300.907387]  ovl_copy_up_one+0x456/0x720 [overlay]
[ 2300.908376]  ? xa_load+0x7b/0xb0
[ 2300.909090]  ? _raw_spin_unlock+0xe/0x30
[ 2300.909913]  ? list_lru_add+0x11b/0x160
[ 2300.910736]  ovl_copy_up_flags+0x81/0x110 [overlay]
[ 2300.911740]  ovl_create_object+0x51/0x130 [overlay]
[ 2300.912719]  vfs_mkdir+0x194/0x250
[ 2300.913470]  do_mkdirat+0x14c/0x180
[ 2300.914223]  __x64_sys_mkdir+0x46/0x70
[ 2300.915019]  do_syscall_64+0x7d/0x160
[ 2300.915798]  ? do_sys_openat2+0x9c/0xe0
[ 2300.916672]  ? syscall_exit_work+0xf3/0x120
[ 2300.917540]  ? syscall_exit_to_user_mode+0x32/0x190
[ 2300.918518]  ? do_syscall_64+0x89/0x160
[ 2300.919316]  ? syscall_exit_work+0xf3/0x120
[ 2300.920181]  ? syscall_exit_to_user_mode+0x32/0x190
[ 2300.921173]  ? do_syscall_64+0x89/0x160
[ 2300.921991]  ? exc_page_fault+0x7f/0x150
[ 2300.922814]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 2300.923823] RIP: 0033:0x7f5a2f8de3eb

It seems that after commit 5b02bfc1e7e3 ("ovl: do not encode lower fh
with upper sb_writers held") fh may be NULL and it is dereferenced
without check in ovl_get_index_name_fh.
In our case NULL value came from !capable(CAP_DAC_READ_SEARCH)
in ovl_can_decode_fh.

Fix this by checking fh before using its fields,
if fh is NULL - use buf = NULL and len = 0.
For ovl_get_index_name_fh use empty string with length 1 so
the following bin2hex and kfree(name.name) are fine.

Fixes: 5b02bfc1e7e3 ("ovl: do not encode lower fh with upper sb_writers held")
Signed-off-by: Vladimir Riabchun <vladimir.riabchun@virtuozzo.com>
---
There is one more place where I can see the possibility of this problem:
ovl_get_indexdir calls ovl_get_origin_fh which can return NULL, fh is
then passed to ovl_verify_origin_fh -> ovl_verify_set_fh -> ovl_verify_fh,
which doesn't check fh for NULL and dereferences it.

I'm not very familiar with the code, so I'd like to hear what should be
returned there in !fh case (my guess - return 0 if ofh is NULL as well
and -SOME_ERROR otherwise).

 fs/overlayfs/copy_up.c | 5 +++--
 fs/overlayfs/namei.c   | 6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4388004a319d..63a783473b60 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -492,7 +492,7 @@ int ovl_set_origin_fh(struct ovl_fs *ofs, const struct ovl_fh *fh,
 	/*
 	 * Do not fail when upper doesn't support xattrs.
 	 */
-	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
+	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh ? fh->buf : NULL,
 				 fh ? fh->fb.len : 0, 0);
 
 	/* Ignore -EPERM from setting "user.*" on symlink/special */
@@ -510,7 +510,8 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
-	err = ovl_setxattr(ofs, index, OVL_XATTR_UPPER, fh->buf, fh->fb.len);
+	err = ovl_setxattr(ofs, index, OVL_XATTR_UPPER,
+		fh ? fh->buf : NULL, fh ? fh->fb.len : 0);
 
 	kfree(fh);
 	return err;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index efa2a072aa69..81607a24589f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -721,12 +721,14 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 int ovl_get_index_name_fh(const struct ovl_fh *fh, struct qstr *name)
 {
 	char *n, *s;
+	size_t len = fh ? fh->fb.len : 1;
+	const char *buf = fh ? fh->buf : (const u8 *)"";
 
-	n = kcalloc(fh->fb.len, 2, GFP_KERNEL);
+	n = kcalloc(len, 2, GFP_KERNEL);
 	if (!n)
 		return -ENOMEM;
 
-	s  = bin2hex(n, fh->buf, fh->fb.len);
+	s  = bin2hex(n, buf, len);
 	*name = (struct qstr) QSTR_INIT(n, s - n);
 
 	return 0;
-- 
2.47.1

