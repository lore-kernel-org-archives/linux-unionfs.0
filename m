From: Quorum Laval <quorum.laval@gmail.com>
Subject: [PATCH v2] ovl: fix issue with nftw(3) with FTW_MOUNT flag set
Date: Mon, 14 Nov 2016 15:22:54 +0100
Message-ID: <1479133374-9292-1-git-send-email-quorum.laval@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: vmlinuz386@gmail.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, quorum.laval@gmail.com
List-Id: linux-unionfs@vger.kernel.org

>From glibc2-24/io/ftw.c:

<snippet>

if (result == 0
      && (flag == FTW_NS
          || !(data->flags & FTW_MOUNT) || st.st_dev == data->dev))

<snippet>

st.st_dev == data->dev is false in the cases of non-directory objects,
since st_dev is reported from upper/lower filesystem and ->dev is
reported from overlayfs [0]. So when flag is not equal to FTW_NS and FTW_MOUNT is
positionned, non-directory objects will not be reported by nftw(3) [1]. The patch
fixes this.

[0] Documentation/filesystems/overlayfs.txt
[1] https://bugzilla.kernel.org/show_bug.cgi?id=114951

Signed-off-by: Quorum Laval <quorum.laval@gmail.com>
Reported-by: Gerardo Exequiel Pozzi <vmlinuz386@gmail.com>
---
 fs/overlayfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7fb53d0..565a7a9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -116,6 +116,10 @@ static int ovl_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = vfs_getattr(&realpath, stat);
 	revert_creds(old_cred);
+
+	stat->dev = dentry->d_sb->s_dev;
+	stat->ino = dentry->d_inode->i_ino;
+
 	return err;
 }
 
-- 
2.7.4
