Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752786AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 27/31] ovl: Issue fsync on upper metacopy inode as well
Date: Thu, 26 Apr 2018 15:10:09 -0400
Message-Id: <20180426191013.13219-28-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

When a fsync happens, it calls fsync on real underlying file. If a file
has been metadata only copied up on upper, then file containing data
is the real file and fsync will be called on lower data file.

We should be issuing fsync on upper metacopy inode as well to make sure
upper inode has been made persistent on disk.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/file.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 08387639ba6e..be531b79d2e5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -259,18 +259,31 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct fd real;
+	struct fd real, metareal = {0};
 	const struct cred *old_cred;
 	int ret;
+	struct inode *upperinode = NULL;
 
 	ret = ovl_real_file(file, &real);
 	if (ret)
 		return ret;
 
+	/* If we have upper metacopy, issue additional fsync on it */
+	upperinode = ovl_inode_upper(file_inode(file));
+	if (!datasync && upperinode && (file_inode(real.file) != upperinode)) {
+		ret = ovl_real_meta_file(file, &metareal);
+		if (ret)
+			goto put_real;
+	}
+
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = vfs_fsync_range(real.file, start, end, datasync);
+	if (!ret && metareal.file)
+		ret = vfs_fsync(metareal.file, datasync);
 	revert_creds(old_cred);
 
+	fdput(metareal);
+put_real:
 	fdput(real);
 
 	return ret;
-- 
2.13.6

