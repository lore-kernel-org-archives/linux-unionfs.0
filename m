Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57774 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbeK0Dd2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Nov 2018 22:33:28 -0500
Date: Mon, 26 Nov 2018 10:38:47 -0600
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] IMA: Mask O_RDWR if FMODE_READ is set
Message-ID: <20181126163847.xy3acvltyeb75nb4@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, syzkaller-bugs@googlegroups.com, linux-integrity@vger.kernel.org, linux-unionfs@vger.kernel.org, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

A file can be opened with open(O_WRONLY | O_RDWR), so a FMORE_READ
will not be set, and overlayfs will consider another copy_up() on the same
file leading to a deadlock on mnt_want_write(). Fix it by masking
O_RDWR while opening the file in read-only mode.


Reported-by: syzbot+ae82084b07d0297e566b@syzkaller.appspotmail.com
Fixes: a408e4a86b36 ("ima: open a new file instance if no read permissions")
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index d9e7728027c6..2efa04e47ff0 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -422,7 +422,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	/* Open a new file instance in O_RDONLY if we cannot read */
 	if (!(file->f_mode & FMODE_READ)) {
 		int flags = file->f_flags & ~(O_WRONLY | O_APPEND |
-				O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
+				O_RDWR | O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
 		flags |= O_RDONLY;
 		f = dentry_open(&file->f_path, flags, file->f_cred);
 		if (IS_ERR(f)) {

-- 
Goldwyn
