Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822283;
	b=Y9eyw6i8eTec5ulhZNNKs04qpSlAeKybwvOV2c8iDzEriHznkc555gN6F76Qc1x9X+jj
	 Vg7YWs1IQ74v/V6GmbAzEza4ifjqxd/SguPRROcxhogreF/MD5J65Ep9gnnz2leVKUKdC
	 9U020MHad3sM9Cr0+Ed1Q+whVuzCffmupgAbgo1aegJj1BVOh345cCDUL7cKJc0vvbbwc
	 on6K4MPynx13AKAqM0LCZV4guo7qQPFXnHpYydQqMXgsK7cePFb2kNJayQ0Xrdl+5aN/z
	 ds/GoRoES/YuiSSSfyQi3b8fP2SHtsnZ9/fjwlmj9iZNFm+X3o2Adm5Eh83hlSV2miQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822283;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=auE26+fOLI72rgX+Hj3RdbPQehwMyY/pCwgCN9rlOHg=;
	b=yIWCtL5lgVEHjkRBpvtRzjkCJf/YP3l9B7Uvs76ul4HTkq7iDwyWhR3SYAuAQVgTjXSi
	 7b7fGgLMGIejndKG2NaKob3t6QUCoMygK5rgIT5ooixVX+0KgZRnje6uILkoWQ5HC7moM
	 WBWrtcV/exlG2D74CqE8Wdxor46Y1aOsvj9xMEzJ6eJl4EFuc/COEVwdbByo/KSfdYlxM
	 OXC+Qiw0CefflfQbJN06/2cuTk+aysVPXhTSTpnmxNTaPf0X8KpYEJnQbsWPC8eURt6Vh
	 p9sVOyDhF1eQDXVhI62q+eD1hnVhbKl56BAYQnBzRFi8NT7JT+2U+SyDgEss+MGZ32g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlnLCU6H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CE1606A32C;
	Mon, 16 Nov 2026 09:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlnLCU6H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8331F000C9;
	Mon, 16 Nov 2026 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822282;
	bh=auE26+fOLI72rgX+Hj3RdbPQehwMyY/pCwgCN9rlOHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hlnLCU6HKZ58GbvSDsseEbKhi0l5T/Jjd5dSM7eShUzehTKeI5KqY64Wu/trHe8Om
	 /oKhB7uyn0oRPF0mEyQ756tqq/4mNA20yLfHjcBaOva9NWGybNAxxrNxKABU8UKeFw
	 pUbJNBBEV4PIB+NTL2kVqfIDfNfpwPejOMzkI5FWFUjB8BoCjJLRQbceNWCcR7Ag/e
	 jO+eyvPV50FzUsER3uxy4a1ZL9KzDXuYrMhrcoqlVO8IOfXkbrppIe8qCSG6UVafAl
	 mAtwRavfw66ahhqexpZG6v7mW9TvPe/3d0CA9vfMMYNIDpUiDUtNjQPGyzN/fDgWBh
	 5v71KFl+4Kddw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:43:59 +0100
Subject: [PATCH v2 02/13] fs: add d_real_data_inode() and
 d_real_metadata_inode()
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
Message-Id: <20261116-work-ovl-d_real-v2-2-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3564; i=brauner@kernel.org;
 h=from:subject:message-id; bh=kOb9sDYc20xfRrHenkOZFrOaejChiG9k92klh14UwNE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulCwxkSKK9vcXG0dU0xarnFD/RLJ1csWLS9353WoV
 9soHfGso5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLLuhj+Ctn0Cpl/bJhb9WXB
 hoACjXvdu4/oCx4/KeaYYiZ6jP30F4b/sfktk7z3LrkdeMehiknaR1zBtdr1+Sevw7riS6d90Vz
 LAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Currently, d_real() can't fail. When overlayfs fails to look up the data
of a metacopy file in a data-only layer it hands back the overlayfs
dentry and callers silently work with the overlayfs inode. That's more
problematic than current callers realize.

For trace_uprobe and bpf's uprobe_multi it means uprobe_register() fails
with an -EIO that has nothing to do with the actual problem. For IMA it
means the stacked change detection is skipped and for IPE the file is
evaluated against an inode that has none of the properties of the real
file.

Teach d_real() to fail and teach all callers to handle errors. This adds
two helpers for the callers to switch over to:

- d_real_data_inode() returns the inode hosting the data or an ERR_PTR()
  if that can't be resolved.

- d_real_metadata_inode() returns the inode hosting the metadata or an
  ERR_PTR(). overlayfs never has to look anything up for the metadata
  but we don't want to promise that it never fails. So callers handle
  errors for it as well.

d_real() can't fail yet so this is a pure preparation. d_real_inode()
stays around until all callers are converted.

No functional changes.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/dcache.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 84b0cfe4ed0e7..a75016a713d4a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -3,6 +3,7 @@
 #define __LINUX_DCACHE_H
 
 #include <linux/atomic.h>
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/math.h>
 #include <linux/rculist.h>
@@ -660,6 +661,50 @@ static inline struct inode *d_real_inode(const struct dentry *dentry)
 	return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
 }
 
+/**
+ * d_real_data_inode - Return the real inode hosting the data
+ * @dentry: The dentry to query
+ *
+ * If @dentry is a regular file on a union/overlay, then return the
+ * underlying, real inode that hosts its data. Otherwise return d_inode().
+ *
+ * The union/overlay may have to look up the data first. This can sleep and it
+ * can fail, e.g., because the data is missing or because its verity digest
+ * doesn't match.
+ *
+ * Return: The real inode hosting the data of @dentry, or an ERR_PTR() if it
+ * can't be resolved.
+ */
+static inline struct inode *d_real_data_inode(struct dentry *dentry)
+{
+	struct dentry *real;
+
+	real = d_real(dentry, D_REAL_DATA);
+	if (IS_ERR(real))
+		return ERR_CAST(real);
+	return d_inode(real);
+}
+
+/**
+ * d_real_metadata_inode - Return the real inode hosting the metadata
+ * @dentry: The dentry to query
+ *
+ * If @dentry is a regular file on a union/overlay, then return the
+ * underlying, real inode that hosts its metadata. Otherwise return d_inode().
+ *
+ * Return: The real inode hosting the metadata of @dentry, or an ERR_PTR() if
+ * it can't be resolved.
+ */
+static inline struct inode *d_real_metadata_inode(struct dentry *dentry)
+{
+	struct dentry *real;
+
+	real = d_real(dentry, D_REAL_METADATA);
+	if (IS_ERR(real))
+		return ERR_CAST(real);
+	return d_inode(real);
+}
+
 struct name_snapshot {
 	struct qstr name;
 	union shortname_store inline_name;

-- 
2.53.0

