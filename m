Return-Path: <iforster@suse.com>
From: Ignaz Forster <iforster@suse.com>
Subject: [PATCH 1/5] evm: instead of using the overlayfs i_ino, use the real i_ino
Date: Mon, 11 Feb 2019 17:53:19 +0100
Message-Id: <20190211165323.9369-2-iforster@suse.com>
In-Reply-To: <20190211165323.9369-1-iforster@suse.com>
References: <20190211165323.9369-1-iforster@suse.com>
To: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: Fabian Vogt <fvogt@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Mimi Zohar <zohar@linux.ibm.com>

Using the overlayfs i_ino value in the HMAC calculation results in not
being able to validate the EVM HMAC.  This patch calculates the HMAC
using the real i_ino.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/evm/evm_crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 43e2dc3a60d0..baddbbce6ac7 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -241,6 +241,9 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 		if (is_ima)
 			ima_present = true;
 	}
+
+	/* Use the real i_ino to calculate the HMAC */
+	inode = d_real_inode(dentry);
 	hmac_add_misc(desc, inode, type, data->digest);
 
 	/* Portable EVM signatures must include an IMA hash */
-- 
2.20.1
