From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 8/9] overlayfs: Dilute permission checks on lower only if not special file
Date: Wed, 13 Jul 2016 10:44:54 -0400
Message-ID: <1468421095-22322-9-git-send-email-vgoyal@redhat.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbcGMOpr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 Jul 2016 10:45:47 -0400
In-Reply-To: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, sds@tycho.nsa.gov, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org

Right now if file is on lower/, we remove MAY_WRITE/MAY_APPEND bits from
mask as lower/ will never be written and file will be copied up. But this
is not true for special files. These files are not copied up and are
opened in place. So don't dilute the checks for these types of files.

Reported-by: Dan Walsh <dwalsh@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 66f42f5..6d9d86e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -140,7 +140,7 @@ int ovl_permission(struct inode *inode, int mask)
 		return err;
 
 	old_cred = ovl_override_creds(inode->i_sb);
-	if (!is_upper)
+	if (!is_upper && !special_file(realinode->i_mode))
 		mask &= ~(MAY_WRITE | MAY_APPEND);
 	err = inode_permission(realinode, mask);
 	revert_creds(old_cred);
-- 
2.7.4
