Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822310;
	b=4ngSxkdqarjBUhEY69nrVfb0dmOzMOH+hmHfR0WzGU5lGsC434/2obg06f3ySsvE2trH
	 EGUbnF/YHedYOD5FUVvINGdkZ/8KaJiWlMbmmFlajm7nn65VED4HuEl7XJv96Uj2LgFaH
	 6jzjVoMIOCsJ7c6eTa9uXNk2nXsDs/AfatrNbJ5WnFhy4WWhSPUNaUyMU4cSQbmNRQfwQ
	 XOY+SKSgG67WTUYk8PbxNE+Q9I6eWlkXmCaoqhmHZJBJ8+nNrmfsLyrhkTH6UyH6IVn8C
	 dvBJ5GCI+FiUpAQhbcLFjzvFp8SBvUtnvfAfRfZ17z0BLgXPtkDveEPqowtHMjKiYcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822310;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=7T9ynTkV4YsO/iVdJcFIbPQ2DiH/ucpb0T4B/QE4bOs=;
	b=B2uQ5+fw40PiBjaI/Xc9ts+dzND5yOOvNJfaVH3bOxMt+07AGrzijCcNdg3PMdf87YSN
	 UWVvCm+3MUpWdYhadWWBOhPr4/zAvLgX/hZFlnEOfTpdwr7B2BfsukuMRm2ULoL65yDFs
	 zFjRVY7zeilEBrDDdZN4olJs7UlcgMj4ZHke848Gsfeh1cQGGWbO7LUWwuBj2Pip6NV00
	 bssJlmOJ7M7ftS6fFIUSLslgSncuPqRIDNapO9hki0FyuXvtIATaLAjgjyaSCLD/FCfEb
	 iEBUASiBoF/NLmUBsLYNSXMJLyRk6j4zUp8QEYSDbVYBWuPVuPNB2NIE2bCOS4JTyaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ft01kBTQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54915606A323;
	Mon, 16 Nov 2026 09:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ft01kBTQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF9C1F00925;
	Mon, 16 Nov 2026 09:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822310;
	bh=7T9ynTkV4YsO/iVdJcFIbPQ2DiH/ucpb0T4B/QE4bOs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ft01kBTQjtb3tTFugCBjTwuW6pw6jQihhhRFYxyr6NHo1/5TUNuslgS38WZ/Y2bvf
	 M6iYKB+yooVBjT4N1uQ4GKP23TCNj8qA9TMSA2L78LtCv/p+hH2jOeML9EJErrvMnt
	 4XDb8ED13Oem2tDu1VBeMZb1fddJ4/zYSGTov12PR2CxcRRKBGTcBJTI6FzKdoAoIQ
	 mHnSiZOcCY4i9HoncVw25osu68F7pWDzyOkVy2sO6WHZXF7anfSm1nmsMbax1qh6df
	 H8fqLOSgeSolbGyAJWHSXEmJT3aUtLGUkMeylTpYWfwCZjnMEEP709pYIjpJ/zg44P
	 i11CeNNXJ8ILw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:07 +0100
Subject: [PATCH v2 10/13] ovl: return the error from the lazy lowerdata
 lookup in ovl_d_real()
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-10-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4078; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mh3e0v2O9oO1OzXvLpc53qgpoN0+L7fgpfypazM4mWQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulDlca9adXZ7csyqIIaGjPx7re7H5j698fyI0A/DO
 /6FzN9OdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyk+BHDH45FpfsXbGw/O8Xm
 e/jXvkxGfuawjMhwtusfUl26GCKen2Zk2PCsdAazz5Zni+2jH+XxvddgvSMcq/9PsDVYXPjgSXN
 1JgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

All callers have been converted to d_real_data_inode() and handle an
error now. So return the error from ovl_verify_lowerdata() just like
ovl_open() does. The lowerdata dentry missing after a successful
ovl_verify_lowerdata() would be an overlayfs bug, so keep warning about
that but return -EIO like ovl_open() does when it has no real path.
D_REAL_METADATA never looks anything up and still can't fail.

Update the comment in ovl_d_real() and the documentation of d_real() in
dcache.h and vfs.rst accordingly.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/vfs.rst |  7 +++++++
 fs/overlayfs/super.c              | 17 +++++++++--------
 include/linux/dcache.h            |  6 ++++++
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a43711..ff7ea00a42ad7 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1374,6 +1374,13 @@ defined:
 	for returning the real underlying dentry that refers to the inode
 	hosting the file's data or metadata respectively.
 
+	For D_REAL_DATA the filesystem may have to look up the data first,
+	e.g., for a file that was never opened.  If that fails an ERR_PTR()
+	is returned and callers must handle it.  Callers must handle an
+	ERR_PTR() for D_REAL_METADATA as well.  Most callers should use
+	d_real_data_inode() or d_real_metadata_inode() instead of calling
+	d_real() directly.
+
 	For non-regular files, the 'dentry' argument is returned.
 
 ``d_unalias_trylock``
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1985b553a47b7..39d4d57dec230 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -42,7 +42,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry, enum d_real_type type)
 	}
 
 	if (!d_is_reg(dentry)) {
-		/* d_real_inode() is only relevant for regular files */
+		/* d_real() is only relevant for regular files */
 		return dentry;
 	}
 
@@ -57,17 +57,18 @@ static struct dentry *ovl_d_real(struct dentry *dentry, enum d_real_type type)
 	}
 
 	/*
-	 * Best effort lazy lookup of lowerdata for D_REAL_DATA case to return
-	 * the real lowerdata dentry. Callers may ask for files that were never
-	 * opened, e.g. for uprobes or O_PATH files, so the lookup can fail
-	 * here. Return the overlayfs dentry then.
+	 * Lazy lookup of lowerdata for the D_REAL_DATA case to return the real
+	 * lowerdata dentry. Callers may ask for files that were never opened,
+	 * e.g., for uprobes or O_PATH files, and the lookup or the verity
+	 * validation can fail. Return the error then, just like ovl_open()
+	 * would. Callers of d_real() have to deal with that.
 	 */
 	err = ovl_verify_lowerdata(dentry);
 	if (err)
-		return dentry;
+		return ERR_PTR(err);
 	lower = ovl_dentry_lowerdata(dentry);
-	if (!lower)
-		goto bug;
+	if (WARN_ON_ONCE(!lower))
+		return ERR_PTR(-EIO);
 
 real_lower:
 	/* Handle recursion into stacked lower fs */
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index a75016a713d4a..fd8853622f250 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -638,7 +638,13 @@ static inline struct inode *d_backing_inode(const struct dentry *upper)
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
  *
+ * For D_REAL_DATA the union/overlay may have to look up the data first. This
+ * can sleep and it can fail. Callers must handle errors for D_REAL_METADATA
+ * as well.
+ *
  * See also: Documentation/filesystems/vfs.rst
+ *
+ * Return: The real dentry, or an ERR_PTR() if it can't be resolved.
  */
 static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type)
 {

-- 
2.53.0

