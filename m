From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 9/9] overlayfs: Append MAY_READ when diluting write checks
Date: Wed, 13 Jul 2016 10:44:55 -0400
Message-ID: <1468421095-22322-10-git-send-email-vgoyal@redhat.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu, sds@tycho.nsa.gov, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Right now we remove MAY_WRITE/MAY_APPEND bits from mask if realfile is
on lower/. This is done as files on lower will never be written and will
be copied up. But to copy up a file, mounter should have MAY_READ permission
otherwise copy up will fail. So set MAY_READ in mask when MAY_WRITE is
reset.

Dan Walsh noticed this when he did access(lowerfile, W_OK) and it returned
True (context mounts) but when he tried to actually write to file, it failed
as mounter did not have permission on lower file.

Reported-by: Dan Walsh <dwalsh@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6d9d86e..83b2422 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -140,8 +140,13 @@ int ovl_permission(struct inode *inode, int mask)
 		return err;
 
 	old_cred = ovl_override_creds(inode->i_sb);
-	if (!is_upper && !special_file(realinode->i_mode))
-		mask &= ~(MAY_WRITE | MAY_APPEND);
+	if (!is_upper && !special_file(realinode->i_mode)) {
+		if (mask & MAY_WRITE || mask & MAY_APPEND) {
+			mask &= ~(MAY_WRITE | MAY_APPEND);
+			/* Make sure mounter can read file for copy up later */
+			mask |= MAY_READ;
+		}
+	}
 	err = inode_permission(realinode, mask);
 	revert_creds(old_cred);
 
-- 
2.7.4
