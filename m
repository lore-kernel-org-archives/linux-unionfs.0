Received: from mail3-167.sinamail.sina.com.cn (mail3-167.sinamail.sina.com.cn [202.108.3.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FF4313534
	for <linux-unionfs@vger.kernel.org>; Thu, 27 Nov 2025 23:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.108.3.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764287053; cv=none; b=j+f+Qrs00VkaiTxQNGlRUBB4uvz+BrYJoTuT0Us7gBeRfNsLSmLCymzSy6hu6F+oYRFjiqAN83xATSiQAQm5kDs8adNLA/g2TNPFNjIUmNP2HfVGXI7yZ+qD9tLxnIBhAz17msIf/MllWia0PMC4J6UTIQ8wNyDjoC21kZ/6r0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764287053; c=relaxed/simple;
	bh=kCVmmYKVmIi5En9RS5IxsG4p1Qa9PuNzMwDHHNpdXM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9GLFOjwRie86TVDhazcsd9MdkeH0MItgYZeqoU7PVRs76MMShqXLot95f43ZrwGPHqAkqdkmdz9DTc4nZlPHv1lmE7+fOgfULfJk+cWYTV4I/OUF5mONEqqogvHuiZ3GC19oPYR7rHGy4dwPtjyk+uC26b4qb+U/+AWlYHUILw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b=ta0+7EAi; arc=none smtp.client-ip=202.108.3.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.com header.i=@sina.com header.b="ta0+7EAi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1764287048;
	bh=4aAXIYkDxIkJ3aPgEDwSD4tq5Ea4ccdEgdw8wjr6gDo=;
	h=From:Subject:Date:Message-ID;
	b=ta0+7EAiAaGCqwwV6v4uoa52GEUBRxvAOLVK3nWEF3YwLN8PEVsJENnSUU8Fmw0IT
	 NdSSuot+6h5V6Gc9fSwsEHj3EkEZsJ7ID0XFzZWeTVCDzNjXrkgZztNyqEcFtBzvy6
	 4l9GvWRqm/fvzVzktirNbqWaALqxCkQFM889/rak=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.57.85])
	by sina.com (10.54.253.33) with ESMTP
	id 6928E1B1000047A3; Thu, 28 Nov 2025 07:41:38 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 9417026685189
X-SMAIL-UIID: BE772AB418A64FBEAC460DF06E8C8317-20251128-074138-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>
Cc: NeilBrown <neilb@ownmail.net>,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink (2)
Date: Fri, 28 Nov 2025 07:41:27 +0800
Message-ID: <20251127234129.9487-1-hdanton@sina.com>
In-Reply-To: <176427972855.634289.8097806579329413784@noble.neil.brown.name>
References: 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 28 Nov 2025 08:42:08 +1100 NeilBrown wrote:
> On Fri, 28 Nov 2025, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    30f09200cc4a Merge tag 'arm64-fixes' of git://git.kernel.o..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1047ee92580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=38a0c4cddc846161
> > dashboard link: https://syzkaller.appspot.com/bug?extid=bfc9a0ccf0de47d04e8c
> > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1626ae12580000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1126ae12580000
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/a5630d1ab1eb/disk-30f09200.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/584408ed3fcf/vmlinux-30f09200.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/69749e493b1e/bzImage-30f09200.xz
> > 
> > The issue was bisected to:
> > 
> > commit d2c995581c7c5d0ff623b2700e76bf22499c66df
> > Author: NeilBrown <neil@brown.name>
> > Date:   Wed Jul 16 00:44:14 2025 +0000
> > 
> >     ovl: Call ovl_create_temp() without lock held.
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13db1e92580000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=103b1e92580000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17db1e92580000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
> > Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
> 
> I think this was probably fixed by 
> Commit 1f480a181137 ("Add start_renaming_two_dentries()")
> 
> That patch replaced the call to ovl_lock_rename_workdir()
> with start_renaming_two_dentries()
> The new function checks that the two dentries are still hashed.
> 
> ovl_lock_rename_workdir() should have been changed to check
> that the dentries were still hashed before that patch that
> the bisect found which changed the locking in ovl_cleanup_and_whiteout.
> 
> Can you please confirm the bug no longer exists after that patch?
>
#syz test upstream master
