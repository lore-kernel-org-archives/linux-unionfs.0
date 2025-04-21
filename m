Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4911AC2ED;
	Mon, 21 Apr 2025 23:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745277328; cv=none; b=PU1h3J7vFqnLeAOhqOnTUOrw5DCxUII2TjHVXIQx4lFOvTp8O+fn6WjGCJfnTs6V8xCehhu8jBoUCcUNIzdtrmnCuQBo1rK7NX2J0Dnp9ZxWY8QQMC+rlhj8yWjXDU7xl3bO1uM0+6nSn66YHSZw3wTqriOSWu3RNaNI0TFcm1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745277328; c=relaxed/simple;
	bh=UZ41G4ylpY5ShMVGCSb2rFeV054LTjtX2MVIBAknHw8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qifNZzu1UJf45mLeXNc6M4iNRQPJi1Y01y8b90Tj5NfawznMS0aI2nZZZGzF35dZVx+fPNVCZubNSwgrJWMUYNvpqNYtLxtuU/RSlScpRlnN6C+MMlEsYKl/V58RdCFlTM3BBnUoC4cq1N8JX227ET73nGq0cU1yjKz48opwr5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ez+/JrKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ez+/JrKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A90C4CEE4;
	Mon, 21 Apr 2025 23:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745277327;
	bh=UZ41G4ylpY5ShMVGCSb2rFeV054LTjtX2MVIBAknHw8=;
	h=From:To:Cc:Subject:Date:From;
	b=ez+/JrKxyHpRtFC5L35wmvfkTto5w+y8Z9/xD7HTu4RTLCiulhYdgH2WFNRVb2AxB
	 0vb7/DhDNXR+Hf4h8sWIaIsukpWxcDxhG26qv+3EwP9rJDQmkbFI58H2pEIDkempJA
	 yfAo54jlLtxQdO/bLmA1mHlYL/5x9kXkprtQyouQhJ7PZd4WUbTPcVneFbtqYgW+15
	 ht662xWFf2vvWiO1En8Gt+EPD6AwRhjNPpp5PARCnYaH/Ewgb2iIJX0KRej1yRg8C2
	 wA0zoJ5rChij0RJLjWFd9bB3pDwRTVT+jlZAcQnZZLf7veMtCDssGMow9sQx1IKJ7g
	 8D2mBT81jEp7g==
From: Kees Cook <kees@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Kees Cook <kees@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] ovl: Check for NULL d_inode() in ovl_dentry_upper()
Date: Mon, 21 Apr 2025 16:15:19 -0700
Message-Id: <20250421231515.work.676-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2842; i=kees@kernel.org; h=from:subject:message-id; bh=UZ41G4ylpY5ShMVGCSb2rFeV054LTjtX2MVIBAknHw8=; b=owGbwMvMwCVmps19z/KJym7G02pJDBlsF9u9v7/eqibJqLEgZvK2vJ4jvj4njn+9NM3SmWHTm f+nO/497ihlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZjI6heMDH2XNprG1716UDLx zZ4NzQxh1lzOTwT3ru4VK1rRfVnpQxMjwxWPQ/Fvp57VPyL5dN0i8yTF2PoPU+ZvXu4UlHm/ZZ/ MFVYA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In ovl_path_type() and ovl_is_metacopy_dentry() GCC notices that it is
possible for OVL_E() to return NULL (which implies that d_inode(dentry)
may be NULL). This would result in out of bounds reads via container_of(),
seen with GCC 15's -Warray-bounds -fdiagnostics-details. For example:

In file included from arch/x86/include/generated/asm/rwonce.h:1,
                 from include/linux/compiler.h:339,
                 from include/linux/export.h:5,
                 from include/linux/linkage.h:7,
                 from include/linux/fs.h:5,
                 from fs/overlayfs/util.c:7:
In function 'ovl_upperdentry_dereference',
    inlined from 'ovl_dentry_upper' at ../fs/overlayfs/util.c:305:9,
    inlined from 'ovl_path_type' at ../fs/overlayfs/util.c:216:6:
include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outside array bounds of 'struct inode[7486503276667837]' [-Werror=array-bounds=]
   44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
      |                         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
   50 |         __READ_ONCE(x);                                                 \
      |         ^~~~~~~~~~~
fs/overlayfs/ovl_entry.h:195:16: note: in expansion of macro 'READ_ONCE'
  195 |         return READ_ONCE(oi->__upperdentry);
      |                ^~~~~~~~~
  'ovl_path_type': event 1
  185 |         return inode ? OVL_I(inode)->oe : NULL;
  'ovl_path_type': event 2

Avoid this by allowing ovl_dentry_upper() to return NULL if d_inode() is
NULL, as that means the problematic dereferencing can never be reached.
Note that this fixes the over-eager compiler warning in an effort to
being able to enable -Warray-bounds globally. There is no known
behavioral bug here.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
This is the spirital v2 of https://lore.kernel.org/lkml/20241117044612.work.304-kees@kernel.org/
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org
---
 fs/overlayfs/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0819c739cc2f..5d6b60d56c27 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -305,7 +305,9 @@ enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path)
 
 struct dentry *ovl_dentry_upper(struct dentry *dentry)
 {
-	return ovl_upperdentry_dereference(OVL_I(d_inode(dentry)));
+	struct inode *inode = d_inode(dentry);
+
+	return inode ? ovl_upperdentry_dereference(OVL_I(inode)) : NULL;
 }
 
 struct dentry *ovl_dentry_lower(struct dentry *dentry)
-- 
2.34.1

