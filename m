Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822300;
	b=nYKVpSp1ZWbMHoJbE78FuRLDlf7m1u70AFqHbGSEvY63C1aDsA/wYOMkr1cz+/zMkV6A
	 BgbWW31BtVzdWCBXAdvW2XFs24TY6y7KBOWQl0NLFN8OS6AMiuA3iszLhUZTwnjkxmeiu
	 H13/wCuqXxBGhcRJ6fICpnQpnqyQQ98DiBsfSaGUWMYVv0Our21uoxp1ktaKd2EmF5TZH
	 yzvOE69UZY5/3Db66lqOU9QRP6Uq8l+hK3riUso5xNqkbGY16fpLwhpUQFzETPL+88WJh
	 i+wgNHZOxiGaJTT/1QZ2K+8Hf4biN1AyZfE4D8h6+s79ZZwxZwK81oWdTSsH1inX27Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822300;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=eRdg9HeWYxK8nNNdp54EXfNgXm8ZdA21oo0OWAWt0Yc=;
	b=GA4RK32nqUNHxRtNbFpYLnOoEFBujq2mE5LoDDl90pwSA/DnBQUJbDn5ByDZPbYyzcug
	 evjNmfzI8RSmoTj2QlrvNRq3QyNXce0osXRQkQqDB6TjjHb8244+6pRR9wSS2xJooOZkt
	 STF4/0w6OWLe3q39yB+J2Bqf454Ctd6Sfy9EXxJ8vvA9GkLHFwAT/8AT5GqB8WANgkMKV
	 6BV9YbMa1jl2CuA4NqOoYBjYpbf2DC649uh4+0zumx7x//LbNP0gHL/vOmNIWTyr7pw6d
	 zRVVgHlI4kd8hAalOymk9f6K5yztKS257VYZAbNqFu4mgJJ+DHOcQN78vRQHZPGQhig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hV6+oygS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14094606A338;
	Mon, 16 Nov 2026 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hV6+oygS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27011F000C7;
	Mon, 16 Nov 2026 09:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822299;
	bh=eRdg9HeWYxK8nNNdp54EXfNgXm8ZdA21oo0OWAWt0Yc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hV6+oygSuLM7mo2IAC2neqmAEwNr2wmgk3IsHnHwJYmLo9/4Evwf0XZ+KeDO3NAZi
	 wfQ1nENiCbl5daVGHl6kw6gL8mEuI5TGlN8Lkd6Sw+fmbSIHnqT7/K8xHsMZG1Er3k
	 U3ytQvFZRiwT24bmSDaz4fOld7poaqGCANDF9YkmvuO63A55t51KgZ3Pa9XR8lKyBP
	 e17AHIskq7aB6QoBN59yIf3oTZdEZpfgD5S79QIWSoee/dW2CQKAKj6Wg43w6qIdC0
	 dKVLLLWiZjzIi/7lMyeL8Kw9KKLuScV/7NUJvDs+rdqxA7HdpFGRXr1vRFHOh8lMcY
	 uTY4LaLu3cd/Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:04 +0100
Subject: [PATCH v2 07/13] ima,evm: use d_real_metadata_inode()
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
Message-Id: <20261116-work-ovl-d_real-v2-7-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4060; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cGRzxBqY++Wn5nl5/qGAoLXdWcB+rZ3GJOCpw8/hvZI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulBmqd1lwebvqHsuxPPzqit9hzczca1b5PhNmn2Pq
 VcAYxhLRwkLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESyjBgZFqv39t1aPcXpe0TR
 ROH56nzbW+U1pRUTRb33RTCpFuxgZvhxYFLG1oOXd7Caq/BOqJF13XI7O/xu0WmlIwskb1+N2cA
 AAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail. D_REAL_METADATA never has to look
anything up but we don't want to promise that it never fails. So switch
the open-coded d_inode(d_real(..., D_REAL_METADATA)) in
process_measurement() and evm_calc_hmac_or_hash() over to
d_real_metadata_inode() and deal with errors.

evm_calc_hmac_or_hash() returns the error so EVM fails to verify the
metadata. process_measurement() passes the error on to
evm_metadata_changed() which treats it like changed metadata and resets
the EVM status. That is needed as evm_verify_hmac() would otherwise hand
out a cached INTEGRITY_PASS without looking at the metadata again.

This is a no-op as long as overlayfs can't fail D_REAL_METADATA.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 5 ++++-
 security/integrity/evm/evm_main.c   | 9 +++++----
 security/integrity/ima/ima_main.c   | 6 +++---
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 1c41af2f91a60..17d528771d8fe 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -231,7 +231,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 				 uint8_t type, struct evm_digest *data,
 				 struct evm_iint_cache *iint)
 {
-	struct inode *inode = d_inode(d_real(dentry, D_REAL_METADATA));
+	struct inode *inode = d_real_metadata_inode(dentry);
 	struct xattr_list *xattr;
 	struct shash_desc *desc;
 	size_t xattr_size = 0;
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
index e463cfc1e3f43..016de5a66eced 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -357,10 +357,10 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		}
 
 		/*
-		 * Reset the EVM status when metadata changed.
+		 * Reset the EVM status when metadata changed or the inode
+		 * hosting it can't be resolved.
 		 */
-		metadata_inode = d_inode(d_real(file_dentry(file),
-					 D_REAL_METADATA));
+		metadata_inode = d_real_metadata_inode(file_dentry(file));
 		if (evm_metadata_changed(inode, metadata_inode))
 			iint->flags &= ~(IMA_APPRAISED |
 					 IMA_APPRAISED_SUBMASK);

-- 
2.53.0

