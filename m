Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794775151;
	b=aCpa0jPrFNVbFv94BvZ7bI9ZSwPFE19h/BAvJfhbCnmAsbDkl6Ni7XK54ei3az7YUzzZ
	 2N8ZOAK8FIZz3MfbpvU0ItISOAxUrkSV8+EYeKHvj4trZ9MEPkVzEr72luD78KjdSuawY
	 57yU33AT7EdWpSimGooCc9WG8HsZXe8lgmAh2G7kFvF1zpDP06vFUqVXKeXsmPYQNTmYP
	 +veCRENp6cZz4TsqLEo/hR5Ti3Qvm2QfExrol4OvlCu++9YWEKweJSDchAli5sJWnX+23
	 K0ksRvWNhzpcgqzJRcXE3isORu+wF70q7ieR9uuXAvZ7Qew95/s2/esfnZk2rHIT4qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794775151;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SYnKw1raUAzd3oGbNwevOMeKUBQWz4Y8HJx8/Ua61PM=;
	b=PXaU+RxUvFBZAaixYgt+AspDv08hbgqZXBJTVbbu630Ymu61T0yP674k+lCzQEAdDs9V
	 ETAPmsVPnA6bHPuyEDUumzhChLWqMJxNc2Lr0cj/xsHnR8u4PRzQGTaGqr6f1g7E9M5CZ
	 v7me6bhnRbylq2leX9Bi4IXWYzguwWG06zB2xgUX2lZsa7/E3qWk/KJo45V+co58P7xHG
	 b7Rdu1wWl9yHDZ20n9VnzyEQ9WiCO/FivPkAqoVl0g/EJGWOyHIQHSKvugrX9cS4i1zQi
	 OzAKasnwoUd1R2GLvXtB24D7rGctDwRRwIDUoJI0eI+Hrt5N0dgolftmRT9L0v9ZX2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AFRuDvhf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2425E606A31F;
	Sun, 15 Nov 2026 20:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AFRuDvhf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1A41F000C5;
	Sun, 15 Nov 2026 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794775151;
	bh=SYnKw1raUAzd3oGbNwevOMeKUBQWz4Y8HJx8/Ua61PM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AFRuDvhfAj0dgAanXIbk2qYSf/iBx5gTWt01dxkdS7Ht9GMgM6t9ds/0xcLpOsA86
	 XpNToIlHpVr3wZAuq+NCnLcv3HzoZW2Ncbzb2BTY4mFOykzZPZUCy7dOSMRk7oO3uC
	 QGkr+sGP/8jnXCYf0x8Cq7z+kbMmAz5NqDOOpbIU8A2QpvIz4ehLg1VWOspSCBqbcc
	 ikHcY2yewpv+tjvuFGTn77EH3h6zZj9QE5GWHkw/r57vserNyUhaWtLX+uhwTa+YCA
	 W4q7EGecCUnX/PmrhqRIaRl/43xXm0He7t1KCUdtpKTCEewe1kUEFSIkzfCk3FtK+h
	 1WOk0xcs5zBaA==
Date: Sun, 15 Nov 2026 21:39:06 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 02/13] fs: add d_real_data_inode() and
 d_real_metadata_inode()
Message-ID: <20261115-fechten-goldfisch-worum-5c478291ebf5@brauner>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
 <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
 <CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com>

On Sun, Nov 15, 2026 at 04:00:36PM +0100, Amir Goldstein wrote:
> Wondering out loud - since you needed to change IMA anyway and need
> IMA patches reviews, do you think it is hard to also gracefully deal with errors
> from d_real_metadata_inode() and not have to promise that it never fails?

No, that's easy enough:

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 2b15179e9baf9..477f0d29f3cbe 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -639,12 +639,12 @@ static inline struct inode *d_backing_inode(const struct dentry *upper)
  * Otherwise return the dentry itself.
  *
  * For D_REAL_DATA the union/overlay may have to look up the data first. This
- * can sleep and it can fail. D_REAL_METADATA never fails.
+ * can sleep and it can fail. Callers must handle errors for D_REAL_METADATA
+ * as well.
  *
  * See also: Documentation/filesystems/vfs.rst
  *
- * Return: The real dentry, or an ERR_PTR() for D_REAL_DATA if the data can't
- * be resolved.
+ * Return: The real dentry, or an ERR_PTR() if it can't be resolved.
  */
 static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type)
 {
@@ -686,15 +686,18 @@ static inline struct inode *d_real_data_inode(const struct dentry *dentry)
  * If @dentry is a regular file on a union/overlay, then return the
  * underlying, real inode that hosts its metadata. Otherwise return d_inode().
  *
- * Unlike d_real_data_inode() this never has to look anything up and so it
- * never fails.
- *
- * Return: The real inode hosting the metadata of @dentry.
+ * Return: The real inode hosting the metadata of @dentry, or an ERR_PTR() if
+ * it can't be resolved.
  */
 static inline struct inode *d_real_metadata_inode(const struct dentry *dentry)
 {
+	struct dentry *real;
+
 	/* This usage of d_real() results in const dentry */
-	return d_inode(d_real((struct dentry *)dentry, D_REAL_METADATA));
+	real = d_real((struct dentry *)dentry, D_REAL_METADATA);
+	if (IS_ERR(real))
+		return ERR_CAST(real);
+	return d_inode(real);
 }
 
 struct name_snapshot {
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 1b50cb4913d0b..17d528771d8fe 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -241,6 +241,9 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 	bool ima_present = false;
 	u64 i_version = 0;
 
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
 	if (!(inode->i_opflags & IOP_XATTR) ||
 	    inode->i_sb->s_user_ns != &init_user_ns)
 		return -EOPNOTSUPP;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index ac8328812e6ef..71faf156f9d6b 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -763,11 +763,11 @@ static void evm_reset_status(struct inode *inode)
 /**
  * evm_metadata_changed: Detect changes to the metadata
  * @inode: a file's inode
- * @metadata_inode: metadata inode
+ * @metadata_inode: metadata inode, or an ERR_PTR() if it can't be resolved
  *
  * On a stacked filesystem detect whether the metadata has changed. If this is
- * the case reset the evm_status associated with the inode that represents the
- * file.
+ * the case, or if the metadata inode can't be resolved, reset the evm_status
+ * associated with the inode that represents the file.
  */
 bool evm_metadata_changed(struct inode *inode, struct inode *metadata_inode)
 {
@@ -775,7 +775,8 @@ bool evm_metadata_changed(struct inode *inode, struct inode *metadata_inode)
 	bool ret = false;
 
 	if (iint) {
-		ret = (!IS_I_VERSION(metadata_inode) ||
+		ret = (IS_ERR(metadata_inode) ||
+		       !IS_I_VERSION(metadata_inode) ||
 		       integrity_inode_attrs_changed(&iint->metadata_inode,
 						     metadata_inode));
 		if (ret)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 9df7fbe3523e8..016de5a66eced 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -357,7 +357,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		}
 
 		/*
-		 * Reset the EVM status when metadata changed.
+		 * Reset the EVM status when metadata changed or the inode
+		 * hosting it can't be resolved.
 		 */
 		metadata_inode = d_real_metadata_inode(file_dentry(file));
 		if (evm_metadata_changed(inode, metadata_inode))
diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 6953f399672f3..ff7ea00a42ad7 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1376,9 +1376,10 @@ defined:
 
 	For D_REAL_DATA the filesystem may have to look up the data first,
 	e.g., for a file that was never opened.  If that fails an ERR_PTR()
-	is returned and callers must handle it.  D_REAL_METADATA must not
-	fail.  Most callers should use d_real_data_inode() or
-	d_real_metadata_inode() instead of calling d_real() directly.
+	is returned and callers must handle it.  Callers must handle an
+	ERR_PTR() for D_REAL_METADATA as well.  Most callers should use
+	d_real_data_inode() or d_real_metadata_inode() instead of calling
+	d_real() directly.
 
 	For non-regular files, the 'dentry' argument is returned.
 
diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 28a24b702f2a6..aa0fc43907017 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1431,4 +1431,4 @@ d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and returns an
 ERR_PTR() then, e.g., when overlayfs can't look up the data of a metacopy file
 in a data-only layer. Use d_real_data_inode(), which returns the inode hosting
 the data or an ERR_PTR(), and handle the error. Use d_real_metadata_inode() for
-the inode hosting the metadata. That one never fails.
+the inode hosting the metadata and handle its errors as well.
