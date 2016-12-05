From: Patrick Plagwitz <Patrick_Plagwitz@web.de>
Subject: [PATCH] overlayfs: ignore empty NFSv4 ACLs in ext4 upperdir
Date: Mon, 5 Dec 2016 01:51:58 +0100
Message-ID: <5a6862bd-924d-25e4-2a8e-ba4f51e66604@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:54678 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbcLEAw7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 4 Dec 2016 19:52:59 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu

Mounting an overlayfs with an NFSv4 lowerdir and an ext4 upperdir causes copy_up operations, specifically the function copy_up.c:ovl_copy_xattr, to fail with EOPNOTSUPP.
For example, having the following folders:

|- nfs <- NFSv4 is mounted here
|--|- folder
|- root <- ext4 is mounted here
|- work <- also ext4
|- merged <- overlay is mounted here with
             lowerdir=nfs,upperdir=root,workdir=work

And calling
# touch merged/folder/file
will print
touch: cannot touch 'merged/folder/file': Operation not supported

This is because NFS returns the xattr system.nfs4_acl with an empty value even if no NFS ACLs are in use in the lower filesystem. Trying to set this xattr in the upperdir
fails because ext4 does not support it.

Fix this by explicitly checking for the name of the xattr and an empty value and ignoring EOPNOTSUPP if both things match.

Signed-off-by: Patrick Plagwitz <patrick_plagwitz@web.de>
---
Maybe NFS could be changed to not return empty system.nfs4_acl values, I don't know. In any case, to support upperdir ext4 + lowerdir NFSv4, returning the error code from
vfs_setxattr with this xattr name must be avoided as long as the value is empty.

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 36795ee..505b86e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -123,6 +123,9 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
                        continue; /* Discard */
                }
                error = vfs_setxattr(new, name, value, size, 0);
+               if (error == -EOPNOTSUPP && *value == '\0' &&
+                               strcmp(name, "system.nfs4_acl") == 0)
+                       error = 0;
                if (error)
                        break;
        }
