From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 1/2] ovl: don't traverse automount points
Date: Thu,  4 Jun 2015 15:29:45 +0200
Message-ID: <1433424586-7771-2-git-send-email-miklos@szeredi.hu>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sa-dev@rainbow.by, andre.roth@roche.com
List-Id: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

NFS and other distributed filesystems may place automount points in the
tree.  Previoulsy overlayfs refused to mount such filesystems types (based
on the existence of the .d_automount callback), even if the actual export
didn't have any automount points.

It cannot be determined in advance whether the filesystem has automount
points or not.  The solution is to allow fs with .d_automount but refuse to
traverse any automount points encountered.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bf8537c7f455..de9d2ee68ccf 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -303,6 +303,10 @@ static inline struct dentry *ovl_lookup_real(struct dentry *dir,
 	} else if (!dentry->d_inode) {
 		dput(dentry);
 		dentry = NULL;
+	} else if (dentry->d_flags & DCACHE_MANAGED_DENTRY) {
+		dput(dentry);
+		/* Don't support traversing automounts */
+		dentry = ERR_PTR(-EREMOTE);
 	}
 	return dentry;
 }
@@ -700,12 +704,12 @@ static bool ovl_is_allowed_fs_type(struct dentry *root)
 
 	/*
 	 * We don't support:
-	 *  - automount filesystems
+	 *  - autofs
 	 *  - filesystems with revalidate (FIXME for lower layer)
 	 *  - filesystems with case insensitive names
 	 */
 	if (dop &&
-	    (dop->d_manage || dop->d_automount ||
+	    (dop->d_manage ||
 	     dop->d_revalidate || dop->d_weak_revalidate ||
 	     dop->d_compare || dop->d_hash)) {
 		return false;
-- 
2.1.4

