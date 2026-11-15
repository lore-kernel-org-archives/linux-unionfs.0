Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751360;
	b=4VTHpmo0dypQzqdJxjv2Z4IO5ZXch4MZBSlzJ9LBZWvhiWQy94vTpFvoHFm5eRmIPjXy
	 Edgn9qtMCj6CehTHUu8pewVxS5fP6HL2b+h4AbKDr1WE+ylDFQf4Jk8soWY4z66b5jvRs
	 Zy9sg8aNWOZg+wvx3F1F5jZMuvgBQqFOoyTdqpku/q9eZ3CGUYLgY+H/v4aI+zLDLVTc0
	 begzJordT1tIobK4stLvxfBJSXNv+FHCBY7UD60ai5f5wofNx5x47Qkc+Ge7Oz2cWCecD
	 d9QT4j2WB+veG3P9S05zj8qTtEVdCTXEWPsWrlD/uH8Tcc4CvaRSBoUzCtZ3bJLwa2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751360;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=RmUmQueFUIkDd/JCHFltiMkrv2GuUOEp0YdDZHToRTk=;
	b=niPboxK3ifSwoMDR0oJBGufhgAyNiy0yxXKy5FdV5BK7KyhVx0BNioeHWoDTVlvNZS+5
	 VaIi5Tl8Cm6EWJVdYoBFLsN/lrVFJ+GwetvMcZ7algbXm4fAqBln2udMcJJGAkw6Soaxc
	 aNHQ0pZvfLVrOfQ4zZKway/hO74ulC1rUVvvSrpadZ4UQKiZ7pL/ij3cFzJ9p39+7kEjF
	 u6OTgdkmVrsSjsRuOO0Tk6vu9rYInoJ0K6XcI8JDpTKhcvfmkBfM1PwwVLW/lcOP9W9hu
	 PQuLQ2eXuDbWAU/t6d3Z0Fd2j0x8x5aD0PFP43jaUeHQhWLLupcgfNiNt1TgCRVmqbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1ckdNyE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B52606A334;
	Sun, 15 Nov 2026 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1ckdNyE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30A41F000C7;
	Sun, 15 Nov 2026 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751360;
	bh=RmUmQueFUIkDd/JCHFltiMkrv2GuUOEp0YdDZHToRTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T1ckdNyEfHH/g0T9kKl/6vuBCVZ0Hyl6ls82GnvffEHiRaoYRbZHyVoprfjynxKPI
	 WVI5kZ47lN1ZhnMGADcpO6O21WTP8DSajO1y2R2mbSBOqGqjHxxodT9DITHZDBzgAI
	 ncEVlTXUGTAKGwHxFZqNfKNWyNBFVBMrUM+Vlfr3xnA8i+J1KdyUzE27IpdudkNsmA
	 w6Fu4v08wyDVHNfpJ8M0mVZSBFZGTVy42caJdvtAKDez6YzzapbGQhKTdmZ6ivFAJY
	 jSzUFNzsEixLIL3JyO7hUf6FoYTkjf4XJCj1E3pdVzYV4bRpKzPlGge+KFGMaSToGi
	 RR3SADGdIz8bQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:39 +0100
Subject: [PATCH 09/13] bpf: return NULL from bpf_real_data_inode() on
 errors
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
Message-Id: <20261115-work-ovl-d_real-v1-9-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1815; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Sife0/X+A5GvD2c7C2xqh/28wXOwqcHzMdpkKeO2AZA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B310pr/0Lf0HRMmn5jweuoV++Uvpz6uKvW6c9l0z
 xNbN4msaR2lLAxiXAyyYoosDu0m4XLLeSo2G2VqwMxhZQIZwsDFKQATOeLKyHC8ZLX6+plr4n/N
 VtoUNaVp1YmlB/WKC2JKbVi4fnbt43jJ8D/7svaGGTXiBV7hh+4ff+NlpiC+btvN2ts8fL96Jf+
 xr+IAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

d_real() is about to be able to fail for D_REAL_DATA. So switch
bpf_real_data_inode() from d_real_inode() to d_real_data_inode() and
return NULL if the data can't be resolved.

The kfunc is already KF_SLEEPABLE | KF_RET_NULL and its documentation
says it may return NULL. So programs already have to deal with NULL and
the verifier enforces that. Note that this is the caller that most
easily ends up with a file whose data was never looked up.
lsm.s/file_open runs before ovl_open() and lsm.s/file_receive sees
O_PATH files passed via SCM_RIGHTS.

Spell that out in the documentation.

This is a no-op until d_real() can actually fail.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/bpf_fs_kfuncs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index 35ccd98a4de64..ab24e6bcd64c4 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -491,11 +491,20 @@ __bpf_kfunc int bpf_sock_read_xattr(struct socket *sock, const char *name__str,
  * inode itself is returned; for any file on a non-union filesystem the inode
  * attached to @file is returned.
  *
- * Return: The inode hosting @file's data, or NULL.
+ * The union/overlay may have to look up the data first, e.g., when @file was
+ * opened with O_PATH or the program runs before the file is opened. If that
+ * fails NULL is returned.
+ *
+ * Return: The inode hosting @file's data, or NULL if it can't be resolved.
  */
 __bpf_kfunc struct inode *bpf_real_data_inode(struct file *file)
 {
-	return d_real_inode(file_dentry(file));
+	struct inode *inode;
+
+	inode = d_real_data_inode(file_dentry(file));
+	if (IS_ERR(inode))
+		return NULL;
+	return inode;
 }
 
 __bpf_kfunc_end_defs();

-- 
2.53.0

