From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Problem with two overlayed 9p filesystems
Date: Mon, 27 Jun 2016 20:54:31 +0200
Message-ID: <20160627185431.GA2388@veci.piliscsaba.szeredi.hu>
References: <CAPk1OjHwxm_=+rBNXMLXbJvyNGVaGKV0sd_-0RThY-FnTTBALA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36557 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcF0Syl (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 27 Jun 2016 14:54:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id c82so27155687wme.3
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Jun 2016 11:54:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAPk1OjHwxm_=+rBNXMLXbJvyNGVaGKV0sd_-0RThY-FnTTBALA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alessio Igor Bogani <alessioigorbogani@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, linux-unionfs@vger.kernel.org, LFSDEV <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>

On Mon, Jun 27, 2016 at 04:30:59PM +0200, Alessio Igor Bogani wrote:
> Hi,
> 
> Using v4.0 I used to put two 9p or two ext4 filesystems in overlay.
> Now with v4.7-rc5 I can still put two ext4 filesystems in overlay but
> not two 9p filesystems anymore. In the later I obtain the following
> error executing a simple "cat overlay/test.txt".
> 
> Bisecting results in the first offending commit
> 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 which though contains only

Please try the following patch.

Thanks,
Miklos

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index b84c291ba1eb..d7b78d531e63 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -74,7 +74,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 					v9fs_proto_dotu(v9ses));
 	fid = file->private_data;
 	if (!fid) {
-		fid = v9fs_fid_clone(file->f_path.dentry);
+		fid = v9fs_fid_clone(file_dentry(file));
 		if (IS_ERR(fid))
 			return PTR_ERR(fid);
 
@@ -100,7 +100,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 		 * because we want write after unlink usecase
 		 * to work.
 		 */
-		fid = v9fs_writeback_fid(file->f_path.dentry);
+		fid = v9fs_writeback_fid(file_dentry(file));
 		if (IS_ERR(fid)) {
 			err = PTR_ERR(fid);
 			mutex_unlock(&v9inode->v_mutex);
@@ -516,7 +516,7 @@ v9fs_mmap_file_mmap(struct file *filp, struct vm_area_struct *vma)
 		 * because we want write after unlink usecase
 		 * to work.
 		 */
-		fid = v9fs_writeback_fid(filp->f_path.dentry);
+		fid = v9fs_writeback_fid(file_dentry(filp));
 		if (IS_ERR(fid)) {
 			retval = PTR_ERR(fid);
 			mutex_unlock(&v9inode->v_mutex);
