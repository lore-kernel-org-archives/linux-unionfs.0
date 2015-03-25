From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/15] configfs: Fix inconsistent use of file_inode() vs
 file->f_path.dentry->d_inode
Date: Wed, 25 Mar 2015 14:43:40 +0000
Message-ID: <20150325144340.17670.37538.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197AbbCYOof (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 Mar 2015 10:44:35 -0400
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu

Fix inconsistent use of file_inode() vs file->f_path.dentry->d_inode.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/configfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index cf0db005d2f5..acb3d63bc9dc 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1598,7 +1598,7 @@ static loff_t configfs_dir_lseek(struct file *file, loff_t offset, int whence)
 			if (offset >= 0)
 				break;
 		default:
-			mutex_unlock(&file_inode(file)->i_mutex);
+			mutex_unlock(&dentry->d_inode->i_mutex);
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {

