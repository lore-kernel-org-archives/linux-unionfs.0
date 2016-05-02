From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [RFC 4/8] evm: Turn evm_update_evmxattr into void function
Date: Tue,  3 May 2016 00:45:14 +0200
Message-ID: <1462229118-13123-5-git-send-email-agruenba@redhat.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbcEBWp5 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 2 May 2016 18:45:57 -0400
In-Reply-To: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>

The return value of evm_update_evmxattr is never used.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 security/integrity/evm/evm.h        |  7 +++----
 security/integrity/evm/evm_crypto.c | 14 ++++++--------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/security/integrity/evm/evm.h b/security/integrity/evm/evm.h
index f5f1272..8b1cef07 100644
--- a/security/integrity/evm/evm.h
+++ b/security/integrity/evm/evm.h
@@ -39,10 +39,9 @@ extern struct crypto_shash *hash_tfm;
 extern char *evm_config_xattrnames[];
 
 int evm_init_key(void);
-int evm_update_evmxattr(struct dentry *dentry,
-			const char *req_xattr_name,
-			const char *req_xattr_value,
-			size_t req_xattr_value_len);
+void evm_update_evmxattr(struct dentry *dentry, const char *req_xattr_name,
+			 const char *req_xattr_value,
+			 size_t req_xattr_value_len);
 int evm_calc_hmac(struct dentry *dentry, const char *req_xattr_name,
 		  const char *req_xattr_value,
 		  size_t req_xattr_value_len, char *digest);
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 30b6b7d0..3ac6407 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -239,24 +239,22 @@ int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
  *
  * Expects to be called with i_mutex locked.
  */
-int evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
-			const char *xattr_value, size_t xattr_value_len)
+void evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
+			 const char *xattr_value, size_t xattr_value_len)
 {
 	struct inode *inode = d_backing_inode(dentry);
 	struct evm_ima_xattr_data xattr_data;
-	int rc = 0;
+	int rc;
 
 	rc = evm_calc_hmac(dentry, xattr_name, xattr_value,
 			   xattr_value_len, xattr_data.digest);
 	if (rc == 0) {
 		xattr_data.type = EVM_XATTR_HMAC;
-		rc = __vfs_setxattr_noperm(dentry, XATTR_NAME_EVM,
-					   &xattr_data,
-					   sizeof(xattr_data), 0);
+		__vfs_setxattr_noperm(dentry, XATTR_NAME_EVM, &xattr_data,
+				      sizeof(xattr_data), 0);
 	} else if (rc == -ENODATA && inode->i_op->removexattr) {
-		rc = inode->i_op->removexattr(dentry, XATTR_NAME_EVM);
+		inode->i_op->removexattr(dentry, XATTR_NAME_EVM);
 	}
-	return rc;
 }
 
 int evm_init_hmac(struct inode *inode, const struct xattr *lsm_xattr,
-- 
2.5.5
