From: David Howells <dhowells@redhat.com>
Subject: [PATCH] overlayfs: Pass O_LARGEFILE unconditionally in
 ovl_copy_up_data()
Date: Mon, 28 Sep 2015 15:18:06 +0100
Message-ID: <20150928141806.21007.8412.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576AbbI1OSQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 28 Sep 2015 10:18:16 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, viro@ZenIV.linux.org.uk

Pass O_LARGEFILE unconditionally in ovl_copy_up_data() as it's purely for
catching 32-bit userspace dealing with a file large enough that it'll be
mishandled if the application isn't aware that there might be an integer
overflow.  Inside the kernel, there shouldn't be any problems.

Reported-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/copy_up.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d3a5990fd2b9..871fcb67be97 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -76,19 +76,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	struct file *new_file;
 	loff_t old_pos = 0;
 	loff_t new_pos = 0;
-	int error = 0, o_flag = 0;
+	int error = 0;
 
 	if (len == 0)
 		return 0;
 
-	if (i_size_read(d_inode(old->dentry)) > MAX_NON_LFS)
-		o_flag |= O_LARGEFILE;
-	
-	old_file = ovl_path_open(old, o_flag | O_RDONLY);
+	old_file = ovl_path_open(old, O_LARGEFILE | O_RDONLY);
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
 
-	new_file = ovl_path_open(new, o_flag | O_WRONLY);
+	new_file = ovl_path_open(new, O_LARGEFILE | O_WRONLY);
 	if (IS_ERR(new_file)) {
 		error = PTR_ERR(new_file);
 		goto out_fput;
