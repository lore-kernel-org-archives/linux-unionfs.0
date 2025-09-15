Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C0B2E6122;
	Mon, 15 Sep 2025 10:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757931332; cv=none; b=EmvZiYD4WQ3W2hxA449i3mCGCQ5o1135pnsm6Fy8F/tMgvdhrz+4rwepiN/Eqpc/cvsmQF/fLAoUz7RqFmoKMP+UqHl7KVIgvMGLyMoVnBu1iaZm7B6L9rh41pe9scxoGCHPIrUhEJoMZrIZunYbZZ3XnIlleArZGcCcOly6A1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757931332; c=relaxed/simple;
	bh=+gcpMbiu9oLbl6QoezcqlIaQLCZv0/EesdUcLulXk/s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bkTf+Opj2PSzBuycoxfop3AzmS92FdSnLJ2k8epQPEMezJNnixWxrbdVeHlUY9D29la1Zg4ygqQxVT/sSB+JSjTT/fD89h1BvFpBpP8E1UYAuhqLnZHUtTkPmPC5J3bkoRxAc17HUg3H7bb/tnLu6Ca0Pn2WgCFDrIMKfH7PA1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=H24x3boB; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="H24x3boB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1757931330; x=1789467330;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZvQ+c1vVkSnOsX9uWa42mm4Y1xQwU137w0177dY9K94=;
  b=H24x3boBcu7v1A3/uJTfnOxp8P981JG2swrZSt9XU7DucuDjV3VyLivX
   4yWT2n2Zj9yQePOQ0ME79SqLNp53SJMacUH3aAwvS1dr7Zg0mJ1/LCMoh
   QtY315muCAZSL2VP36DBtlJ5NNlJsa5UciTDt/eRwuizOxdLBtLYZ+7J5
   aw+BQ+X15D+zKthFF1QKCtnVm9ClZvk/8+Dd6sGitJFcMmfvYjcDz9iN7
   GhqEslj/cYLymWDGCYtu8/jl+z9r2maGO5tIPT3JgEkX8Cwf2SkyM6qWs
   EgZvM1S5oWOlnNaABvGstPVuYTQ8h1HDPJ+j1ov12k2Wg9BgzLBPU6uD5
   g==;
X-CSE-ConnectionGUID: 7V3sTs8+QaOed5oQ3RG/4A==
X-CSE-MsgGUID: nBUeqQLETPOV8up8YAT6gQ==
X-IronPort-AV: E=Sophos;i="6.18,265,1751241600"; 
   d="scan'208";a="2890406"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 10:15:28 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:44557]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.60.76:2525] with esmtp (Farcaster)
 id 0f51da61-bb62-4199-98c0-c13ee554b8ea; Mon, 15 Sep 2025 10:15:28 +0000 (UTC)
X-Farcaster-Flow-ID: 0f51da61-bb62-4199-98c0-c13ee554b8ea
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 15 Sep 2025 10:15:25 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 15 Sep 2025
 10:15:24 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <linux-unionfs@vger.kernel.org>
CC: <acsjakub@amazon.de>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein
	<amir73il@gmail.com>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH] ovl: check before dereferencing s_root field
Date: Mon, 15 Sep 2025 10:15:10 +0000
Message-ID: <20250915101510.7994-1-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Calling intotify_show_fdinfo() on fd watching an overlayfs inode, while
the overlayfs is being unmounted, can lead to dereferencing NULL ptr.

This issue was found by syzkaller.

Race Condition Diagram:

Thread 1                           Thread 2
--------                           --------

generic_shutdown_super()
 shrink_dcache_for_umount
  sb->s_root = NULL

                    |
                    |             vfs_read()
                    |              inotify_fdinfo()
                    |               * inode get from mark *
                    |               show_mark_fhandle(m, inode)
                    |                exportfs_encode_fid(inode, ..)
                    |                 ovl_encode_fh(inode, ..)
                    |                  ovl_check_encode_origin(inode)
                    |                   * deref i_sb->s_root *
                    |
                    |
                    v
 fsnotify_sb_delete(sb)

Which then leads to:

[   32.133461] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
[   32.134438] KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
[   32.135032] CPU: 1 UID: 0 PID: 4468 Comm: systemd-coredum Not tainted 6.17.0-rc6 #22 PREEMPT(none)

<snip registers, unreliable trace>

[   32.143353] Call Trace:
[   32.143732]  ovl_encode_fh+0xd5/0x170
[   32.144031]  exportfs_encode_inode_fh+0x12f/0x300
[   32.144425]  show_mark_fhandle+0xbe/0x1f0
[   32.145805]  inotify_fdinfo+0x226/0x2d0
[   32.146442]  inotify_show_fdinfo+0x1c5/0x350
[   32.147168]  seq_show+0x530/0x6f0
[   32.147449]  seq_read_iter+0x503/0x12a0
[   32.148419]  seq_read+0x31f/0x410
[   32.150714]  vfs_read+0x1f0/0x9e0
[   32.152297]  ksys_read+0x125/0x240

IOW ovl_check_encode_origin derefs inode->i_sb->s_root, after it was set
to NULL in the unmount path.

Minimize the window of opportunity by adding explicit check.

Fixes: c45beebfde34 ("ovl: support encoding fid from inode with no alias")
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
---

I'm happy to take suggestions for a better fix - I looked at taking
s_umount for reading, but it wasn't clear to me for how long would the
fdinfo path need to hold it. Hence the most primitive suggestion in this
v1.

I'm also not sure if ENOENT or EBUSY is better?.. or even something else?

 fs/overlayfs/export.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 83f80fdb1567..424c73188e06 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -195,6 +195,8 @@ static int ovl_check_encode_origin(struct inode *inode)
 	if (!ovl_inode_lower(inode))
 		return 0;
 
+	if (!inode->i_sb->s_root)
+		return -ENOENT;
 	/*
 	 * Root is never indexed, so if there's an upper layer, encode upper for
 	 * root.
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

