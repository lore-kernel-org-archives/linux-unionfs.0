From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] overlayfs: Conditionally use O_LARGEFILE in
 ovl_copy_up()
Date: Fri, 18 Sep 2015 11:45:12 +0100
Message-ID: <20150918104512.7696.55992.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, viro@ZenIV.linux.org.uk
List-Id: linux-unionfs@vger.kernel.org

Open the lower file with O_LARGEFILE in ovl_copy_up() if the lower file is
>= 4GiB in size.

Reported-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/copy_up.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 84d693d37428..89b4cb3773d7 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -76,16 +76,19 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	struct file *new_file;
 	loff_t old_pos = 0;
 	loff_t new_pos = 0;
-	int error = 0;
+	int error = 0, o_flag = 0;
 
 	if (len == 0)
 		return 0;
 
-	old_file = ovl_path_open(old, O_RDONLY);
+	if (i_size_read(d_inode(old->dentry)) > MAX_NON_LFS)
+		o_flag |= O_LARGEFILE;
+	
+	old_file = ovl_path_open(old, o_flag | O_RDONLY);
 	if (IS_ERR(old_file))
 		return PTR_ERR(old_file);
 
-	new_file = ovl_path_open(new, O_WRONLY);
+	new_file = ovl_path_open(new, o_flag | O_WRONLY);
 	if (IS_ERR(new_file)) {
 		error = PTR_ERR(new_file);
 		goto out_fput;
