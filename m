From: David Howells <dhowells@redhat.com>
Subject: Locking problem in overlayfs
Date: Mon, 27 Oct 2014 14:05:18 +0000
Message-ID: <5394.1414418718@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaJ0OFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 27 Oct 2014 10:05:32 -0400
Content-ID: <5393.1414418718.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

Using my testsuite, I see the attached moan from lockdep.  Unfortunately, it
doesn't cause the testsuite to actually fail, so I'm going to have to manually
try and isolate the failing test.

David

=============================================
[ INFO: possible recursive locking detected ]
3.18.0-rc2-fsdevel+ #910 Tainted: G        W     
---------------------------------------------
run/2642 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#10/1){+.+.+.}, at: [<ffffffff81203d81>] ovl_cleanup_whiteouts+0x29/0xb4

but task is already holding lock:
 (&sb->s_type->i_mutex_key#10/1){+.+.+.}, at: [<ffffffff8113abff>] lock_rename+0xb7/0xd7

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_mutex_key#10/1);
  lock(&sb->s_type->i_mutex_key#10/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

7 locks held by run/2642:
 #0:  (sb_writers#15){.+.+.+}, at: [<ffffffff8114a1e2>] mnt_want_write+0x1f/0x46
 #1:  (&sb->s_type->i_mutex_key#17/1){+.+.+.}, at: [<ffffffff8113c737>] do_rmdir+0xa9/0x165
 #2:  (&sb->s_type->i_mutex_key#17){+.+.+.}, at: [<ffffffff8113c0ad>] vfs_rmdir+0x5a/0x115
 #3:  (sb_writers#8){.+.+.+}, at: [<ffffffff8114a1e2>] mnt_want_write+0x1f/0x46
 #4:  (&type->s_vfs_rename_key){+.+.+.}, at: [<ffffffff8113ab88>] lock_rename+0x40/0xd7
 #5:  (&sb->s_type->i_mutex_key#10/1){+.+.+.}, at: [<ffffffff8113abff>] lock_rename+0xb7/0xd7
 #6:  (&sb->s_type->i_mutex_key#10/2){+.+.+.}, at: [<ffffffff8113ac15>] lock_rename+0xcd/0xd7

stack backtrace:
CPU: 0 PID: 2642 Comm: run Tainted: G        W      3.18.0-rc2-fsdevel+ #910
Hardware name:                  /DG965RY, BIOS MQ96510J.86A.0816.2006.0716.2308 07/16/2006
 ffffffff823989e0 ffff880038d8fa68 ffffffff815222f2 0000000000000006
 ffffffff823989e0 ffff880038d8fb38 ffffffff810738f4 000000000000000b
 ffff880037ebc710 ffff880038d8fb00 ffff880037ebcf58 0000000000000005
Call Trace:
 [<ffffffff815222f2>] dump_stack+0x4e/0x68
 [<ffffffff810738f4>] __lock_acquire+0x7b5/0x1a17
 [<ffffffff8107522d>] lock_acquire+0xa3/0x11d
 [<ffffffff81203d81>] ? ovl_cleanup_whiteouts+0x29/0xb4
 [<ffffffff8111ff14>] ? kfree+0x17e/0x1ca
 [<ffffffff8152580a>] mutex_lock_nested+0x5a/0x304
 [<ffffffff81203d81>] ? ovl_cleanup_whiteouts+0x29/0xb4
 [<ffffffff81139123>] ? vfs_rename+0x602/0x689
 [<ffffffff81203d81>] ovl_cleanup_whiteouts+0x29/0xb4
 [<ffffffff81202252>] ovl_clear_empty+0x195/0x216
 [<ffffffff81202315>] ovl_check_empty_and_clear+0x42/0x5d
 [<ffffffff81056944>] ? creds_are_invalid+0x17/0x4a
 [<ffffffff81202a19>] ovl_do_remove+0x189/0x36a
 [<ffffffff81202c0b>] ovl_rmdir+0x11/0x13
 [<ffffffff8113c0f2>] vfs_rmdir+0x9f/0x115
 [<ffffffff8113c784>] do_rmdir+0xf6/0x165
 [<ffffffff8100d224>] ? do_audit_syscall_entry+0x4a/0x4c
 [<ffffffff8100e43f>] ? syscall_trace_enter_phase2+0x178/0x1c1
 [<ffffffff810e5aae>] ? context_tracking_user_exit+0x54/0xce
 [<ffffffff8113d007>] SyS_rmdir+0x11/0x13
 [<ffffffff81528a09>] tracesys_phase2+0xd4/0xd9
