Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CE638C;
	Sun, 17 Nov 2024 04:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731818781; cv=none; b=NxURU2j/gQspGTkr2KpRfSSh7HvzoPU1Q/DUfF+eVRFaYvgPTN5WHB+/bOjZcTPvU/EOvR0CfbgooEpM9vOn3We+3e+/YLoq6vw+YSJzsY9m27yd1//DyGvRYLfYbcR+ta5+uRNPU64cod5STy9SxLtulNKAuQi9+16pF3Wtkvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731818781; c=relaxed/simple;
	bh=OHcXoXPq450uatNuLe4GGpyGOzfLynl4qxHfnoHNk10=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=erVI01W1sshgj9rQOvJAS7SNQDmAVj0sXgWJPdBX+h4FkwmLhtUHv9MYj8x+LPdMmxUTL1ESIv+qj2IRCVizwCoSeX07X7zLbyu3Fp3j273zH3pONmY0vdllE7RNsevNbrfTpqvQizlZIuUsFty4ZEaKiX/4MUcTxUYw/00HA7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/P5ol3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/P5ol3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A95AC4CECD;
	Sun, 17 Nov 2024 04:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731818780;
	bh=OHcXoXPq450uatNuLe4GGpyGOzfLynl4qxHfnoHNk10=;
	h=From:To:Cc:Subject:Date:From;
	b=R/P5ol3k4/ZXyLPsPNAJGVZYM5hCf30Yyct3LQD9kzxSc/we9uoncvd+E5FUQHvfe
	 tI9m6uBzTW25v72RTMY8//P8thbDwpNpjwJEqoxtldhCtEPC+p0ZFq2sQP9e0J1mAf
	 ZwxocJROlUdJCJvPwsLUYXsQpqMztWof2PFXtjnuHiLAi/fzPrt7CxWelrf6OL1jD0
	 B3ptFSFVPD5G53SkB4h6KaDdatL9NmLiL1a6TFSspQgPZgjnwqNVvcE35dd3vkM0BA
	 9oCJx0PPw1VUOErw2G/G04Cuqe57UaQ1pv+daFBczzSqgjocdN6fFlWU6SVudtO5j4
	 KWOqzjdW6HaRA==
From: Kees Cook <kees@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Kees Cook <kees@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] ovl: Check for NULL OVL_E() results
Date: Sat, 16 Nov 2024 20:46:16 -0800
Message-Id: <20241117044612.work.304-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2560; i=kees@kernel.org; h=from:subject:message-id; bh=OHcXoXPq450uatNuLe4GGpyGOzfLynl4qxHfnoHNk10=; b=owGbwMvMwCVmps19z/KJym7G02pJDOmWpeItjH37/iasu/l3luicC53x/BudnKt1X4i71OQe+ Ol7ZfHrjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIkEnGdk+LlL54REftsDjcDk Tw8uWpe8VwlcZtd7/LRC59cE/sMP7Rn+cG21jF1cohhhy6ewv6Zo75/e7p5bd7efl3P07bio7vW DCwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

GCC notices that it is possible for OVL_E() to return NULL (which
implies that d_inode(dentry) may be NULL). This would result in out
of bounds reads via container_of(), seen with GCC 15's -Warray-bounds
-fdiagnostics-details. For example:

In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
                 from ../include/linux/compiler.h:339,
                 from ../include/linux/export.h:5,
                 from ../include/linux/linkage.h:7,
                 from ../include/linux/fs.h:5,
                 from ../fs/overlayfs/util.c:7:
In function 'ovl_upperdentry_dereference',
    inlined from 'ovl_dentry_upper' at ../fs/overlayfs/util.c:305:9,
    inlined from 'ovl_path_type' at ../fs/overlayfs/util.c:216:6:
../include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outside array bounds of 'struct inode[7486503276667837]' [-Werror=array-bounds=]
   44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))                       |                         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                 ../include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
   50 |         __READ_ONCE(x);                                                 \
      |         ^~~~~~~~~~~
../fs/overlayfs/ovl_entry.h:195:16: note: in expansion of macro 'READ_ONCE'                           195 |         return READ_ONCE(oi->__upperdentry);
      |                ^~~~~~~~~
  'ovl_path_type': event 1
  185 |         return inode ? OVL_I(inode)->oe : NULL;
  'ovl_path_type': event 2

Explicitly check the result of OVL_E() and return accordingly.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
---
 fs/overlayfs/util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3bb107471fb4..32ec5eec32fa 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -213,6 +213,9 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 	struct ovl_entry *oe = OVL_E(dentry);
 	enum ovl_path_type type = 0;
 
+	if (WARN_ON_ONCE(oe == NULL))
+		return 0;
+
 	if (ovl_dentry_upper(dentry)) {
 		type = __OVL_PATH_UPPER;
 
@@ -1312,6 +1315,9 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 
+	if (WARN_ON_ONCE(oe == NULL))
+		return false;
+
 	if (!d_is_reg(dentry))
 		return false;
 
-- 
2.34.1

