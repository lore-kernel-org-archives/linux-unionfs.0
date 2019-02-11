Return-Path: <iforster@suse.com>
From: Ignaz Forster <iforster@suse.com>
Subject: [PATCH 4/5] Ignore IMA / EVM xattrs during copy_up
Date: Mon, 11 Feb 2019 17:53:22 +0100
Message-Id: <20190211165323.9369-5-iforster@suse.com>
In-Reply-To: <20190211165323.9369-1-iforster@suse.com>
References: <20190211165323.9369-1-iforster@suse.com>
To: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: Fabian Vogt <fvogt@suse.com>, Ignaz Forster <iforster@suse.de>, Fabian Vogt <fvogt@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

From: Ignaz Forster <iforster@suse.de>

EVM tries to protect these attributes during copy_up, resulting in
the failure of the copy_up operation.

This patch will skip the attributes (similar to selinux) to allow
for later recalculation. This, however, introduces another problem:
As overlayfs does not check the file integrity on copy_up, files with
an invalid hash will suddenly become valid again after the copy_up
operation.

Co-developed-by: Fabian Vogt <fvogt@suse.de>
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Signed-off-by: Ignaz Forster <iforster@suse.de>
---
 security/integrity/evm/evm_main.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index 5ecaa3d6fe0b..e7667f1159c9 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -23,6 +23,7 @@
 #include <linux/integrity.h>
 #include <linux/evm.h>
 #include <linux/magic.h>
+#include <linux/lsm_hooks.h>
 
 #include <crypto/hash.h>
 #include <crypto/hash_info.h>
@@ -548,6 +549,22 @@ int evm_inode_init_security(struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(evm_inode_init_security);
 
+static int evm_inode_copy_up_xattr(const char *name)
+{
+	/* The copy_up hook above sets the initial context on an inode, but we
+	 * don't then want to overwrite it by blindly copying all the lower
+	 * xattrs up.  Instead, we have to filter out SELinux-related xattrs.
+	 */
+	if (strcmp(name, XATTR_NAME_EVM) == 0 ||
+			strcmp(name, XATTR_NAME_IMA) == 0)
+		return 1; /* Discard */
+	/*
+	 * Any other attribute apart from SELINUX is not claimed, supported
+	 * by selinux.
+	 */
+	return -EOPNOTSUPP;
+}
+
 #ifdef CONFIG_EVM_LOAD_X509
 void __init evm_load_x509(void)
 {
@@ -559,6 +576,10 @@ void __init evm_load_x509(void)
 }
 #endif
 
+static struct security_hook_list evm_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(inode_copy_up_xattr, evm_inode_copy_up_xattr)
+};
+
 static int __init init_evm(void)
 {
 	int error;
@@ -567,6 +588,8 @@ static int __init init_evm(void)
 
 	evm_init_config();
 
+	security_add_hooks(evm_hooks, ARRAY_SIZE(evm_hooks), "evm");
+
 	error = integrity_init_keyring(INTEGRITY_KEYRING_EVM);
 	if (error)
 		goto error;
-- 
2.20.1
