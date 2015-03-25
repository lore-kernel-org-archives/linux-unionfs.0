From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/15] NFS: Don't use d_inode as a variable name
Date: Wed, 25 Mar 2015 14:45:15 +0000
Message-ID: <20150325144514.17670.26643.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbbCYOpT (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 Mar 2015 10:45:19 -0400
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu

Don't use d_inode as a variable name as it now masks a function name.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/nfs/read.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index 568ecf0a880f..b8f5c63f77b2 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -117,15 +117,15 @@ int nfs_readpage_async(struct nfs_open_context *ctx, struct inode *inode,
 
 static void nfs_readpage_release(struct nfs_page *req)
 {
-	struct inode *d_inode = req->wb_context->dentry->d_inode;
+	struct inode *inode = req->wb_context->dentry->d_inode;
 
-	dprintk("NFS: read done (%s/%llu %d@%lld)\n", d_inode->i_sb->s_id,
-		(unsigned long long)NFS_FILEID(d_inode), req->wb_bytes,
+	dprintk("NFS: read done (%s/%llu %d@%lld)\n", inode->i_sb->s_id,
+		(unsigned long long)NFS_FILEID(inode), req->wb_bytes,
 		(long long)req_offset(req));
 
 	if (nfs_page_group_sync_on_bit(req, PG_UNLOCKPAGE)) {
 		if (PageUptodate(req->wb_page))
-			nfs_readpage_to_fscache(d_inode, req->wb_page, 0);
+			nfs_readpage_to_fscache(inode, req->wb_page, 0);
 
 		unlock_page(req->wb_page);
 	}

