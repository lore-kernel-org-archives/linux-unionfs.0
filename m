Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751354;
	b=D2LhtoLybFlbMMWb07Y3kKcSlNIcQ6GAR3NShU1owSjgklJ5KS/OLbttjAU7xBVqXMqA
	 QieHXz8nRnQFlYeNPLpqrfB9X9mKxf4pfL+fuvd+8/M3HF6VVyDMZ7PHshUCpb2Eqqucu
	 THj4zSAF6RJkotnN7A64CG5F/0f2HD/T/I0JDF8Hj3vanEgOdYUFU8aA2OgAw1zYgKipU
	 8Rn9hlOvBNmSMrci2XHTg1vt4JlEExb6o50szN8VdxV7ySFXrd5z6NxMyEE0tiLa78YUw
	 LwLLrLu7yw6Zm4qaFKcJ4tgm3wAzExJ+aO9rijCwn/XQ2dmHTRMFAZ3Qrc692n5IoGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751354;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=jfCScPvxBu5oZg9xpGXlkIMcGAYL0ttu2zAfyVzw/Yc=;
	b=MLCFp9Wg2PrwEtCMEeu5pgW3ikyW4RQDkK8mDYkhrYUdmit3ds6hDBSc8yZt1O7lFo1L
	 sFtM5bwRFZDr9jEi86JKtBOI9RzXezHfSg24APQ+AEQfCfUPpnrH+P647NOLYTEVeZ8g/
	 6Tq2rdAiOHsvqt7nW+LCI2QTBtIDCAtT4gMr+wX6JKppYhIEuUBbMHdVYVVCH0xubja7U
	 RgxcBmgMvBegESx1mV6GUNCHj9Xohds1QTTGM8Nr6Ar2oeYi/4DWKazc1OfkxxUgt5c6j
	 BgZkn0ugksYgjKhgDfK45w/LV6THX/MylPqIdqSbNPb9LlMr9mcAsmhR0F4ELZ1KkqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFTzAogi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1A760A261F;
	Sun, 15 Nov 2026 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFTzAogi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB64E1F000C8;
	Sun, 15 Nov 2026 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751354;
	bh=jfCScPvxBu5oZg9xpGXlkIMcGAYL0ttu2zAfyVzw/Yc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QFTzAogiTbCfihWO3f4nfNW3u7SKK3MVvEZ1oFb/D9/jZbtrkEEjAcikJXz03GUAz
	 O+2MFT3ENDSo/8Fg6o13JEku1L6BgiAzQ8Nq0WqTyIkY/nA8tmH69yukq+OF7MwiUd
	 JkUuMOqSUSArsSWU1DfeX/2NtfKyKu/iexpt7zOpbU1jCs9eXja0iAD+1qPMDN3o5R
	 V5pBYxrkSY73qql/ErRY24RvAj/QK8+AnaIp5e4hmGxtOnsMqJ7U/8NNWhTiwplXOd
	 C3lxpeORF5lcZx1/eX+hRwAr8Pa71Cyb0kWkh3Nu6IW3DZKDinbqwp1NWda5XrEAWr
	 1ZO0qRF79vemA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:37 +0100
Subject: [PATCH 07/13] ima,evm: use d_real_metadata_inode()
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
Message-Id: <20261115-work-ovl-d_real-v1-7-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1773; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DlAMm46RiTZx7jjK5X0U0ynYF8/+mqpchcvWazipVxw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B2+79T833xcF/k+Hq08UiOWl9a77eEKzgixvGulA
 kJ7+S5/7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIYjgjw9Glp43MuUNVLy0T
 zFpy/n6F2zHeCMOt/bvVZzkIFVnd3sXIMNFm+wHTAGVt1xhDkTPJqz9e3/vxoartpDUBeeF6e45
 eYwYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. D_REAL_METADATA
never has to look anything up and can't fail. Make that explicit and
switch the open-coded d_inode(d_real(..., D_REAL_METADATA)) in
process_measurement() and evm_calc_hmac_or_hash() over to
d_real_metadata_inode().

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 2 +-
 security/integrity/ima/ima_main.c   | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 1c41af2f91a60..1b50cb4913d0b 100644
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
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e463cfc1e3f43..9df7fbe3523e8 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -359,8 +359,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		/*
 		 * Reset the EVM status when metadata changed.
 		 */
-		metadata_inode = d_inode(d_real(file_dentry(file),
-					 D_REAL_METADATA));
+		metadata_inode = d_real_metadata_inode(file_dentry(file));
 		if (evm_metadata_changed(inode, metadata_inode))
 			iint->flags &= ~(IMA_APPRAISED |
 					 IMA_APPRAISED_SUBMASK);

-- 
2.53.0

