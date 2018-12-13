Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 13 Dec 2018 05:57:17 -0600
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] fs: Evaluate O_WRONLY | O_RDWR to O_RDWR
Message-ID: <20181213115717.p7ncktng2ihxw5md@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: amir73il@gmail.com, zohar@linux.ibm.com, syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com, linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org, dvyukov@google.com
List-ID: <linux-unionfs@vger.kernel.org>

A user can open(O_WRONLY | O_RDWR) and the options are valid.
However, OPEN_FMODE() evaluates both FMODE_READ and FMODE_WRITE,
as negative. We also need to protect the lower layers from this
anomaly.

Solve it by dropping O_WRONLY, so O_RDWR takes precedence.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reported-by: syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com
Fixes: a408e4a86b36 ("ima: open a new file instance if no read permissions")
---
 fs/open.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 0285ce7dbd51..3d0a21600fa3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -924,7 +924,12 @@ EXPORT_SYMBOL(open_with_fake_path);
 static inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
 {
 	int lookup_flags = 0;
-	int acc_mode = ACC_MODE(flags);
+	int acc_mode;
+
+	if ((flags & (O_RDWR | O_WRONLY)) == (O_RDWR | O_WRONLY))
+		flags &= ~O_WRONLY;
+
+	acc_mode = ACC_MODE(flags);
 
 	/*
 	 * Clear out all open flags we don't know about so that we don't report
-- 
2.16.4
