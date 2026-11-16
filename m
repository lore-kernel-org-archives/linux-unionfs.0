Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822313;
	b=XmrAhT8r9mEmzLHj8VIYrJZtpB+gYtIXZXs3j0C1zh0xExUE78WIihEFEOulPLX53rxF
	 +sMXlhjBYJNERJoaeq/pJKih/lk+iCnge73k2kXctSY3yF3+4bcqKxdVC0bXB0xWXKKEi
	 h1ptResCiv5+WlMaN6Vdw5p2MRoWXI47sep88lI+vfkladaKiPJxSCXRkC61VJiVBrn9g
	 YQ1OPj0qT2L9NS/R9zrClnqPvb92YZYq6jMFScZ5k7YHPbp8VcEoAXGYDPGsmGRxJJDye
	 kgyVwPGco0BK9mOF5sQJOCbs19qJoZlryG5bVxv5EhHLw6WCP2T/7q2A53pIIcrp6sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822313;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=l2n7GYm1kafD6KIKhmQCKvKwi/vqwdo3wJ4VdtgD0Qw=;
	b=KGMe1imJJgA6/dUP8qKkIE6TPoaHy0VNVJf2xnDDl7IPe3Zsttr6Fo+N801s/dsE3aqV
	 /XEi9CgB7fxkY7BGt5o1FF8JqPXRwCVVnwY6gzNmXWEjm8ANMRV54XUD3XtVaJv2kFvSK
	 MsVI7Q744KWCy5J7PgnF2HthF1vzdPF/9Lf1Oq6O5t3oM3iA8yerArw/1f2+69mCATUQO
	 1N+VX9lFoAd1MSGvTPud5zUhoD/RWgm/FmVl6WpRyF217l2eDt+PaYLXu29ZXLI6wpc/H
	 sqtP71S3Afu93jcS7MvrqAKf/RmkDAjxoFR17zygP++muJSjiN/Ad95fnRyznuzJuLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RByDbBq0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4FB606A8A1;
	Mon, 16 Nov 2026 09:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RByDbBq0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1C21F000C4;
	Mon, 16 Nov 2026 09:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822313;
	bh=l2n7GYm1kafD6KIKhmQCKvKwi/vqwdo3wJ4VdtgD0Qw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RByDbBq0EnH/k7F/+ia4GduEApm//N0OcqKwmFsf4BT0XxfLJRx9Q/3BNS7AE0kgi
	 YNRe2S8oM7A51RS1GgyMvY4SbBnOHniLnhgMYI5u4d88fXZ/cS6HDImxjd1u70pcfI
	 3qzszv+Jp/IPGLXBaWO/1m5y84RQ0ogUVX4W6it4a6dTT2TtyfOt4rURkjxkrSV+PY
	 iUnyV5fvd++UkXz/kMVXLP2dfExUScApmm2dHIhwMrORjU00/tyJyWVDQkhnW2GwSE
	 XAjNi4jGRdY3TdBl2NgIpH59Vn7mV0hPJBxddVXePy4vAac9joOWIvxWgrhhO8GWbn
	 kP4af+FT2lMWQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:08 +0100
Subject: [PATCH v2 11/13] fs: remove d_real_inode()
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
Message-Id: <20261116-work-ovl-d_real-v2-11-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2354; i=brauner@kernel.org;
 h=from:subject:message-id; bh=N/tFO/f64vva6VIPqr/EXBSXpu7UN9wS9KMKs7QXnPY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulCtee6L+0rW+dorX9aqKs+8VRlQ9yugY9UnblbjU
 yKfzirFdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE9Qojw+LSVZ5KcmcLwvTb
 6m6knWfp4kl2Ydyhf+gu3ysG4cMLPjMyLJOLzHx8+snmSTvUROdP2G/9IGvanwi9+5EXNjzRmnf
 CkhUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

All callers have been converted to d_real_data_inode() or
d_real_metadata_inode(). Remove d_real_inode() so that any user we
missed, or one that gets added in another tree, fails to build instead
of passing an ERR_PTR() from d_real() to d_inode().

Add a porting.rst entry.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/porting.rst | 10 ++++++++++
 include/linux/dcache.h                | 13 -------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c38f5df755bb5..aa0fc43907017 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1422,3 +1422,13 @@ helpers take a const struct mnt_idmap *. mnt_idmap() and file_mnt_idmap()
 return one. The idmapping is immutable so nothing should have modified it
 anyway. References are taken and dropped via mnt_idmap_get() and
 mnt_idmap_put() as before, both accept a const pointer.
+
+---
+
+**mandatory**
+
+d_real_inode() is gone. d_real() can fail for D_REAL_DATA now and returns an
+ERR_PTR() then, e.g., when overlayfs can't look up the data of a metacopy file
+in a data-only layer. Use d_real_data_inode(), which returns the inode hosting
+the data or an ERR_PTR(), and handle the error. Use d_real_metadata_inode() for
+the inode hosting the metadata and handle its errors as well.
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index fd8853622f250..fe1aa8fea0c7a 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -654,19 +654,6 @@ static inline struct dentry *d_real(struct dentry *dentry, enum d_real_type type
 		return dentry;
 }
 
-/**
- * d_real_inode - Return the real inode hosting the data
- * @dentry: The dentry to query
- *
- * If dentry is on a union/overlay, then return the underlying, real inode.
- * Otherwise return d_inode().
- */
-static inline struct inode *d_real_inode(const struct dentry *dentry)
-{
-	/* This usage of d_real() results in const dentry */
-	return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
-}
-
 /**
  * d_real_data_inode - Return the real inode hosting the data
  * @dentry: The dentry to query

-- 
2.53.0

