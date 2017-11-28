From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH V3] ovl: Pass ovl_get_nlink() parameters in right order
Date: Tue, 28 Nov 2017 09:20:59 -0500
Message-ID: <20171128142059.GB4101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, vgoyal@redhat.com, stable@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Right now we seem to be passing index as "lowerdentry" and origin.dentry
as "upperdentry". IIUC, we should pass these parameters in reversed order
and this looks like a bug.

Fixes: caf70cb2ba5d ("ovl: cleanup orphan index entries")
Cc: <stable@vger.kernel.org> #4.13
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 625ed8066570..5ef69bc09e0c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -435,7 +435,7 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 
 	/* Check if index is orphan and don't warn before cleaning it */
 	if (d_inode(index)->i_nlink == 1 &&
-	    ovl_get_nlink(index, origin.dentry, 0) == 0)
+	    ovl_get_nlink(origin.dentry, index, 0) == 0)
 		err = -ENOENT;
 
 	dput(origin.dentry);
