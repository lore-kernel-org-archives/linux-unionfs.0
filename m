From: Mark Salyzyn <salyzyn@android.com>
Subject: [PATCH] ovl: filter of trusted xattr results in audit
Date: Mon,  7 Oct 2019 09:09:16 -0700
Message-ID: <20191007160918.29504-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>, linux-security-module@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

When filtering xattr list for reading, presence of trusted xattr
results in a security audit log.  However, if there is other content
no errno will be set, and if there isn't, the errno will be -ENODATA
and not -EPERM as is usually associated with a lack of capability.
The check does not block the request to list the xattrs present.

Switch to has_capability_noaudit to reflect a more appropriate check.

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: linux-security-module@vger.kernel.org
Cc: kernel-team@android.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # v3.18
Fixes: upstream a082c6f680da ("ovl: filter trusted xattr for non-admin")
Fixes: 3.18 4bcc9b4b3a0a ("ovl: filter trusted xattr for non-admin")
---
Replaced ns_capable_noaudit with 3.18.y tree specific
has_capability_noaudit present in original submission to kernel.org
commit 5c2e9f346b815841f9bed6029ebcb06415caf640
("ovl: filter of trusted xattr results in audit")

 fs/overlayfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a01ec1836a72..1175efa5e956 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -265,7 +265,8 @@ static bool ovl_can_list(const char *s)
 		return true;
 
 	/* Never list trusted.overlay, list other trusted for superuser only */
-	return !ovl_is_private_xattr(s) && capable(CAP_SYS_ADMIN);
+	return !ovl_is_private_xattr(s) &&
+	       has_capability_noaudit(current, CAP_SYS_ADMIN);
 }
 
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
-- 
2.23.0.581.g78d2f28ef7-goog
