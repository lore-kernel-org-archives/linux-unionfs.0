Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751363;
	b=chY/Asb2T1aLOAMbXDeE8DxNfKrhpmxFHTkK2P6luJ67ctsPI316D8A/nOwz19xFEUdu
	 s6PiYFDw62p5CcZUh2hJL8hXWALVB5BjoVBDqDKVgFbwqjwTDHc7rWr0XB9l5AOunaWCa
	 MfWEi/fijKmlWPyV2GwtXpQKBFl7/OtDPyKdOInWefltu8ACRu2Da9utYl3CcC1gPq5ea
	 mAKsEH999ZuDHphRYTcYJZVqMvfVF0gxdjifg6xjoWvlRF3tYCpn1gk859OGxzfxoMEoG
	 4z7KBYJSEJO4y7Co81d00DMUScBRSH+79OnRJTpRGDqAZvkfirBCgAVi6jWbA4fBcig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751363;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=nk9KOAvwXnmUxfWBIIVXeG4Hr+jJ2sLSpduyD0Qh4lo=;
	b=v9Lybqf9mNfzDaOp5zk/JEvPJgO3CrEKqCorbKoOR/DsMo87ZnH9C2pE19yu0P+evPiI
	 IpO9s1YaWXfVTuUFphzXzO4h3vTBfi6g3BHS2oBy8Ovp5kMYgVc5aKFhuLakL9H7P7a7P
	 9nWcfNHA33/OPsQlH81LvLw5YMv7+SCgqMFfbuKh/9F2vsf/YlSjwmHSXMA/y7KUqPukB
	 F0MFqGHN/w8Rd3+DxSo0QAPDpWm3M9Iczfd/S8xdsa6AaQio89xvwW5sUXWGauWaT2K85
	 A6jv+fM7wSyRX1E39di9r88nB7NcEBdNYr70VA5seVMtj1qDgjalQuxEXblqOpcnyMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=okWrLewm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E52606A8B0;
	Sun, 15 Nov 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=okWrLewm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8D51F000C8;
	Sun, 15 Nov 2026 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751363;
	bh=nk9KOAvwXnmUxfWBIIVXeG4Hr+jJ2sLSpduyD0Qh4lo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=okWrLewm0tjpkTulDAIAQQtjyW3tTDs1ZX9uqvV6m/BiotBM76BKIenGj1sCYzElw
	 CprhIONz1nVfNaoZFbC/WdEGeIb3oSzPUyI+99cZlTyRTOa4U0tN7gDc+HCOiLq7Qp
	 KGZ6ged4PJ2zgSxi8GzNBM6M2dps41Y4wPaebp4RrUTijYPl4Mkr6Sc3Edyhmf/XtJ
	 rLjzVOVhsZhuug57jVu5g5EPlx8i3gTF0uwUHtpfo18GjGq3r+/95TSmwrj09iIAgB
	 Z3RKbW/2dtWGUki0KxtO1pUW9HRFP+hXargeMtrZhe9AggvQTjAgciMRsFt7wp7I10
	 poMeBkro+HyYQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:40 +0100
Subject: [PATCH 10/13] ovl: return the error from the lazy lowerdata lookup
 in ovl_d_real()
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
Message-Id: <20261115-work-ovl-d_real-v1-10-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JLedksX0Um5gAap23O86BJDyzWsAqlXP7yJwjFzO2Sw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B2d3Ne4ZNLeCckTdnictDIIXVBb4zdjrzrLHYuCh
 Sm2+porO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyZiYjwy6X9weZipiPlacK
 hC2QD6sLWzR72uKM1/UZqxbGX9w56Sgjw/fps7v/LG9Vt6pTfGFwQHi3o2y58e83c0sPN/LsmbJ
 cnwsA
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
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/vfs.rst |  6 ++++++
 fs/overlayfs/super.c              | 17 +++++++++--------
 include/linux/dcache.h            |  6 ++++++
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a43711..6953f399672f3 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1374,6 +1374,12 @@ defined:
 	for returning the real underlying dentry that refers to the inode
 	hosting the file's data or metadata respectively.
 
+	For D_REAL_DATA the filesystem may have to look up the data first,
+	e.g., for a file that was never opened.  If that fails an ERR_PTR()
+	is returned and callers must handle it.  D_REAL_METADATA must not
+	fail.  Most callers should use d_real_data_inode() or
+	d_real_metadata_inode() instead of calling d_real() directly.
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
index 674bc50b81827..5b3b34d271bd0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -638,7 +638,13 @@ static inline struct inode *d_backing_inode(const struct dentry *upper)
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
  *
+ * For D_REAL_DATA the union/overlay may have to look up the data first. This
+ * can sleep and it can fail. D_REAL_METADATA never fails.
+ *
  * See also: Documentation/filesystems/vfs.rst
+ *
+ * Return: The real dentry, or an ERR_PTR() for D_REAL_DATA if the data can't
+ * be resolved.
  */
 static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type)
 {

-- 
2.53.0

