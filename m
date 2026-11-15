Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751339;
	b=qIscvzXPXE4AS0GCJC7OaZzqBXvyiaW9PR15eEzCZAZ44UAc8kSnZGp0gfNf9Ayogynk
	 NWk6eF63sGwWH96M2r3s+jBiUk8V4JqpefnHa5Lwz0MAC9RSZ0uG29lqzI7BHOx0+pHpb
	 UkrPopQblBvtM4rgOyqLE3uRdh6Fu9TfuknOtTLBt2dtzNns6ArtHZDYBxWyNMaDtCVV0
	 Xvrp6qn2DjBombfLWDbLbrfDcTzwGyQZHiyHFyXJOIlNY0fycOAEdF7ustMu2WwxO2PMN
	 c8FtWX8uNpCoUut/jt7tEXndLR32LNbMM9qZ/qACsCDJXSKM0VGe17rra+IbaGkhkvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751339;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=8DcJPqoTIqU3DThjLnJPMhCVprJHt+RxP4LV+bwrcWc=;
	b=dsxCjxL60MMSPw+h20PKdAJrnIqLWApPCiSTMuxWnrEl2CHVlvwnJtxVz+PqDpS/NqnB
	 upN7C/EfhxheblMN0RV5vUbGSlBvCv5w34wTaH2wgNqOHKxR7ceQA3Pdvn2InWoBOy1jj
	 d0hWstLmJ8fAwmz9Z9ciwAREg1iKUBW+zsrlNwUkePBIa01vbAH2Q0muy8k4SqANEEh3S
	 hJP8MPXp98sG4psnptO3eVjlGWQvSTN/RduDEGQwbJofzr0hbxRK16OF0XEL3wnAGaSit
	 HySgKyKZq5Uw2W3tUwvlytSSbjifJJVbZq1bWSejhVQdFBJCgpavV8SSzkEMYnpWVsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kITTNKSS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F71606A33A;
	Sun, 15 Nov 2026 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kITTNKSS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E034F1F000C5;
	Sun, 15 Nov 2026 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751339;
	bh=8DcJPqoTIqU3DThjLnJPMhCVprJHt+RxP4LV+bwrcWc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kITTNKSS9mm8yBndEG/cxjD+IPNbPBXi5J53OOrpv/ZSyKWGdV8UfaHuw8+tT2t3q
	 Q5uHn8efX7ZIMM8zCgpu71OJqOhqbxm39EPsvAXO499fhnwtqZKkAzQdRKdRsoK6kh
	 pm3o0Xh41WktXxJfHv1Px/dBD3GjnIYxofN7MGKAc76WBxjCDgHx995pgCM2fev6fL
	 ZpsYJyN6zuc6RL6yMqWseAT4Luzp0uoxMCVihyh0Sx0k4YyPjgWGDEUDrVdRnlZWKw
	 0TrNAAbao/NNdtt3tp+4xRr9Is+n5+i4p51bd4Rhua/+4xcbmWu8iow9ARgqwF9O9Z
	 DTjUXXO5WBBsA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:32 +0100
Subject: [PATCH 02/13] fs: add d_real_data_inode() and
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
Message-Id: <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3553; i=brauner@kernel.org;
 h=from:subject:message-id; bh=r/TK4S9fdHcWiH8C2c6UfK7xalJuGV7ntU2PLLcgpwQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3o9HiBWLhyQ+/PoPIpPCVP/896/Ozi+6QtqevnH
 lmT5jhbuqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi72cwMqy96J9hur2P34HX
 ertSgf4lxQKnCRN6UjWW/T+//Z+rqTnDP31Rjs7Xat8CmoU+ndGxNJjzfUnNwa0JS2X3/dmu1vA
 pgwMA
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

- d_real_metadata_inode() returns the inode hosting the metadata. It
  never has to look anything up and so never fails (but no promises for
  the future).

d_real() can't fail yet so this is a pure preparation. d_real_inode()
stays around until all callers are converted.

No functional changes.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/dcache.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 84b0cfe4ed0e7..674bc50b81827 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -3,6 +3,7 @@
 #define __LINUX_DCACHE_H
 
 #include <linux/atomic.h>
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/math.h>
 #include <linux/rculist.h>
@@ -660,6 +661,49 @@ static inline struct inode *d_real_inode(const struct dentry *dentry)
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
+static inline struct inode *d_real_data_inode(const struct dentry *dentry)
+{
+	struct dentry *real;
+
+	/* This usage of d_real() results in const dentry */
+	real = d_real((struct dentry *)dentry, D_REAL_DATA);
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
+ * Unlike d_real_data_inode() this never has to look anything up and so it
+ * never fails.
+ *
+ * Return: The real inode hosting the metadata of @dentry.
+ */
+static inline struct inode *d_real_metadata_inode(const struct dentry *dentry)
+{
+	/* This usage of d_real() results in const dentry */
+	return d_inode(d_real((struct dentry *)dentry, D_REAL_METADATA));
+}
+
 struct name_snapshot {
 	struct qstr name;
 	union shortname_store inline_name;

-- 
2.53.0

