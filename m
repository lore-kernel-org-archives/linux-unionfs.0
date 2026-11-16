Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822296;
	b=V18BDRCj2VEIBO/rGkmI/tQeYz73Mc0warFCd37Y9hMUQoitYUoHmC1roNoNekZEacbU
	 i/96qpIAbKiaFkbQ4gMa+7l5Mdt41iJcFD3D3UG/eYcWT5qm2jsMOWodfKX/zkmR5maRH
	 vSUqLCjWzkuvBzHcePPZjqOxH/1lsUzH0Lf7BRjdJykzKSgajloTbWKlP4t3o2dvVKj0T
	 Aob6a1WLeeNR1OvCjXOTDhNkJQUSQkjzDUpT8jd2JC3EmMRQD7BGGKx89Labs2M3a0Mmt
	 64DjmsNd66UmCT29LqNFDJni7sU7cEMDCUu3aqycs3rV++ks8Et1I/f47cRuZUeLsGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822296;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=5WQF/2nGODv0RRGHLUgReoktqpsZiCbfLp8w8v9L+bo=;
	b=DLdS2a/Zm36P8gtdbC9xotKMNVHjgn9/bZWQ9/x8ZyMCnStgJUkDSMiKsVWcMFeu9wVX
	 +xyUPAsGa+EP6PibJacnlGCdJ9w3Ozkxaz70Sox0ZuZKk8rF3yl9x54qdQ8MSct6qup6Y
	 sKfUiuiOjVrvkBRgy7xl7tD5NNf7TdQLVLOXhDEKS4csDGkuwOkHsY0kMHXcqo/6Yxxvo
	 tjlBq0g4eYxNnOhuugjJk+9+v+MOnIg86WKMnolLZBrR0xX4XEdJ+Z9YMeLP0S1AUqjTA
	 hv5rDMJSx9jskdpZC5IHHHtiqX/NZM5xsetyfZod3BWeUIkOsGRmfUOvtsf0DPpWM9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GQEYXCeI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EF3606A889;
	Mon, 16 Nov 2026 09:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GQEYXCeI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D381F000CC;
	Mon, 16 Nov 2026 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822296;
	bh=5WQF/2nGODv0RRGHLUgReoktqpsZiCbfLp8w8v9L+bo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GQEYXCeInNJNAeSXEXFEaAtWT2pWKfXmT0uj5OKSMGSwAZpGDUl37UqyhzlDm5GEG
	 BJUy2JglWLls31L/8g5AWG7c4DdKsHzXa3oSV1q8edhD/T1G7ufA9Fo7XYm39kwMlH
	 KefHuyXMwSbcRY+eFQ9fyIqpEvAAHcD5qW/9rfiPozawtenYPH+c0KvyKkjoe1E5kO
	 GOa+n43b8NPEOrOc1pdtKWHzCCvn7pS1DS7I4tj7dynE33KUafW7bIU8XXI/iBQFmV
	 NOnCcfQYEelSkfTZfBgtpRZumhwflU+10AIdufOzVTUORUd8EXwNOudR16x4cPwpAa
	 msGqOmtJHy4aw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:03 +0100
Subject: [PATCH v2 06/13] ima: handle errors from resolving the real inode
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
Message-Id: <20261116-work-ovl-d_real-v2-6-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4587; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LT4oKx89iCAnb882W//c+yjvL+VroCgoISJRbee7R7o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulDasUJ4a7H1JOlnMzLdimdH5T+JcPi6Wbphd6P07
 EXnfnRkdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk1mlGhlOVX5wfnwu4t9pX
 UDw5g/frTp1r8uz6936wGe7UKNlxq5Dhn+Unm0Ovfh7aIq375aFK1lcuRQXtf1MDP1xfV/hoOqd
 wEjMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. So switch IMA
from d_real_inode() to d_real_data_inode() and deal with the error.

Currently, if overlayfs fails to resolve the data of a file it hands
back the overlayfs inode. process_measurement() then sees
real_inode == inode, skips the detection of changes in the backing file
and returns the cached verdict. That's the wrong default. With
metacopy and verity this isn't limited to files nobody opened yet
either. A metadata-only copy-up of an open file makes overlayfs validate
the verity digest of the data again on the next D_REAL_DATA lookup and
that can fail.

So if the inode hosting the data can't be resolved in
process_measurement() we can't tell whether the data changed. Treat it
like a change and clear IMA_DONE_MASK and measured_pcrs so the file is
evaluated again. The metadata check for EVM stays independent of that.

This is a no-op until d_real() can actually fail.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/integrity/ima/ima_api.c  | 17 +++++++++++++----
 security/integrity/ima/ima_main.c |  8 +++++---
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 45701f04ba62f..f8c3437559943 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -246,7 +246,7 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 {
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
-	struct inode *real_inode = d_real_inode(file_dentry(file));
+	struct inode *real_inode;
 	struct ima_max_digest_data hash;
 	struct ima_digest_data *hash_hdr = container_of(&hash.hdr,
 						struct ima_digest_data, hdr);
@@ -268,6 +268,13 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 	if (iint->flags & IMA_COLLECTED)
 		goto out;
 
+	/*
+	 * On stacked filesystems the inode hosting the data may have to be
+	 * looked up and that can fail. Treat it like failing to calculate
+	 * the hash.
+	 */
+	real_inode = d_real_data_inode(file_dentry(file));
+
 	/*
 	 * Detect file change based on STATX_CHANGE_COOKIE, when supported,
 	 * and fallback to detecting file change based on i_version.
@@ -280,7 +287,7 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 				   AT_STATX_SYNC_AS_STAT);
 	if (!result && (stat.result_mask & STATX_CHANGE_COOKIE))
 		i_version = stat.change_cookie;
-	else if (IS_I_VERSION(real_inode))
+	else if (!IS_ERR(real_inode) && IS_I_VERSION(real_inode))
 		i_version = inode_peek_iversion(real_inode);
 
 	hash.hdr.algo = algo;
@@ -289,7 +296,9 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 	/* Initialize hash digest to 0's in case of failure */
 	memset(&hash.digest, 0, sizeof(hash.digest));
 
-	if (iint->flags & IMA_VERITY_REQUIRED) {
+	if (IS_ERR(real_inode)) {
+		result = PTR_ERR(real_inode);
+	} else if (iint->flags & IMA_VERITY_REQUIRED) {
 		if (!ima_get_verity_digest(iint, inode, &hash)) {
 			audit_cause = "no-verity-digest";
 			result = -ENODATA;
@@ -314,7 +323,7 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 	memcpy(iint->ima_hash, &hash, length);
 	if (real_inode == inode)
 		iint->real_inode.version = i_version;
-	else
+	else if (!IS_ERR(real_inode))
 		integrity_inode_attrs_store(&iint->real_inode, i_version,
 					    real_inode);
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index fed80da3ee096..e463cfc1e3f43 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -342,12 +342,14 @@ static int process_measurement(struct file *file, const struct cred *cred,
 
 	/*
 	 * On stacked filesystems, detect and re-evaluate file data and
-	 * metadata changes.
+	 * metadata changes. If the inode hosting the data can't be resolved
+	 * we can't tell whether the data changed. Re-evaluate the file then
+	 * and let ima_collect_measurement() fail.
 	 */
-	real_inode = d_real_inode(file_dentry(file));
+	real_inode = d_real_data_inode(file_dentry(file));
 	if (real_inode != inode &&
 	    (action & IMA_DO_MASK) && (iint->flags & IMA_DONE_MASK)) {
-		if (!IS_I_VERSION(real_inode) ||
+		if (IS_ERR(real_inode) || !IS_I_VERSION(real_inode) ||
 		    integrity_inode_attrs_changed(&iint->real_inode,
 						  real_inode)) {
 			iint->flags &= ~IMA_DONE_MASK;

-- 
2.53.0

