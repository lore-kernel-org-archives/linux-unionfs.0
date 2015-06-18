From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/8] Overlayfs: Use copy-up security hooks
Date: Thu, 18 Jun 2015 14:32:47 +0100
Message-ID: <20150618133247.12722.49795.stgit@warthog.procyon.org.uk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbbFRNcw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 09:32:52 -0400
In-Reply-To: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

Use the copy-up security hooks previously provided to allow an LSM to adjust
the security on a newly created copy and to filter the xattrs copied to that
file copy.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/copy_up.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 24f640441bd9..a350f2314c56 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -58,6 +58,14 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 			error = size;
 			goto out_free_value;
 		}
+		error = security_inode_copy_up_xattr(old, new,
+						     name, value, &size);
+		if (error < 0)
+			goto out_free_value;
+		if (error == 1) {
+			error = 0;
+			continue; /* Discard */
+		}
 		error = vfs_setxattr(new, name, value, size, 0);
 		if (error)
 			goto out_free_value;
@@ -223,6 +231,10 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out2;
 
+	err = security_inode_copy_up(lowerpath->dentry, newdentry);
+	if (err < 0)
+		goto out_cleanup;
+
 	if (S_ISREG(stat->mode)) {
 		struct path upperpath;
 		ovl_path_upper(dentry, &upperpath);
