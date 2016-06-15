From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] ovl: fix uid/gid when creating over whiteout
Date: Wed, 15 Jun 2016 15:30:02 +0200
Message-ID: <20160615133002.GA11993@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Vivek,

I've tested this to fix the regresion that Stephen reported.  I think this
also is a good base for the selinux fix.

Pushed to overlayfs-linus and overlayfs-next branches of

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git

Please let me know if you see any problem with this.

Thanks,
Miklos

---
From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: fix uid/gid when creating over whiteout

Fix a regression when creating a file over a whiteout.  The new
file/directory needs to use the current fsuid/fsgid, not the ones from the
mounter's credentials.

The refcounting is a bit tricky: prepare_creds() sets an original refcount,
override_creds() gets one more, which revert_cred() drops.  So

  1) we need to expicitly put the mounter's credentials when overriding
     with the updated one

  2) we need to put the original ref to the updated creds (and this can
     safely be done before revert_creds(), since we'll still have the ref
     from override_creds()).

Reported-by: Stephen Smalley <sds@tycho.nsa.gov>
Fixes: 3fe6e52f0626 ("ovl: override creds with the ones from the superblock mounter")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -405,12 +405,21 @@ static int ovl_create_or_link(struct den
 		err = ovl_create_upper(dentry, inode, &stat, link, hardlink);
 	} else {
 		const struct cred *old_cred;
+		struct cred *override_cred;
 
 		old_cred = ovl_override_creds(dentry->d_sb);
 
-		err = ovl_create_over_whiteout(dentry, inode, &stat, link,
-					       hardlink);
+		err = -ENOMEM;
+		override_cred = prepare_creds();
+		if (override_cred) {
+			override_cred->fsuid = old_cred->fsuid;
+			override_cred->fsgid = old_cred->fsgid;
+			put_cred(override_creds(override_cred));
+			put_cred(override_cred);
 
+			err = ovl_create_over_whiteout(dentry, inode, &stat,
+						       link, hardlink);
+		}
 		revert_creds(old_cred);
 	}
 
