Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] kernel/acct.c: fix locking order when switching acct files
Date: Thu, 27 Sep 2018 09:49:55 +0300
Message-Id: <20180927064955.13614-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This looks like an old bug, pre-dating the "Fixes" commit, but the
"Fixes" commit did not handle it properly.

The bug recently surfaced as a lockdep possible deadlock warning
with commit d1d04ef8572b ("ovl: stack file ops").

When acct_on() replaces one acct file with another, it takes sb_writers
lock on new file sb and calls acct_pin_kill(old) before releasing the
sb_writers lock.

If new file is on the same fs as old file, acct_pin_kill(old) fail to
file_start_write_trylock() and skip writing the old file, because
sb_writers (of new) is already taken by acct_on().

If new file is not on same fs as old file, this ordering violation
creates an unneeded dependency between new sb_writers and old sb_writers,
which may later be reported as possible deadlock.

This could result in an actual deadlock if acct file is replaced from
an old file in overlayfs over "real fs" to a new file in "real fs".
acct_on() takes freeze protection on "real fs" and tries to write to
overlayfs file. overlayfs is not freeze protected so do_acct_process()
can carry on with __kernel_write() to overlayfs file, which would
try to take freeze protection on "real fs" and deadlock.

Reproducer of lockdep possible deadlock warning:

  ./run --ov -s # unionmount-testsuite
  touch /mnt/x /upper/y
  accton /mnt/x
  accton /upper/y

 ======================================================
 WARNING: possible circular locking dependency detected
 4.19.0-rc1-xfstests #3424 Not tainted
 ------------------------------------------------------
 accton/1390 is trying to acquire lock:
 00000000e0585aa5 (&acct->lock#2){+.+.}, at: acct_pin_kill+0x1b/0x76

 but task is already holding lock:
 000000003692505a (sb_writers#6){.+.+}, at: mnt_want_write+0x1d/0x42

Reported-by: syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com
Fixes: 59eda0e07f43 ("new fs_pin killing logics")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 kernel/acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index addf7732fb56..c09355a7ae46 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -251,8 +251,8 @@ static int acct_on(struct filename *pathname)
 	rcu_read_lock();
 	old = xchg(&ns->bacct, &acct->pin);
 	mutex_unlock(&acct->lock);
-	pin_kill(old);
 	mnt_drop_write(mnt);
+	pin_kill(old);
 	mntput(mnt);
 	return 0;
 }
-- 
2.17.1
