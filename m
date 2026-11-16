Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822306;
	b=S6sN+3WT6tvqJ2pxVXMpxiAUP69b6JnMiKUu+ZQBxaWI587HQZ3hXbCUaW4t1dsAeFO9
	 p6cNckZaKn7kPGyJtCoPSj7asCXZqfVeXFmSsmFJ0q63pC+Qc5kP3wfi12Z2PV1dqt5Yv
	 +rZgnKTWOtUwCiJ+CgE5V8XYFPil8aU3+awlJn+0DIpcD8ZtyMmPdY2LKKZ+PuOkZdG9f
	 sas/0VdrfAcnjlzU3CJdKwy2XB15iMbXiwBzY/RVnVUQjJQAK8CKCQByc8Loi5dxwLGx6
	 gcOv/KslLGKlGdDxpTzmbaDghQDKNY6D0ro8f7uopbKDfFoVXT+KgNblGeBQbfZpdzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822306;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=7tEmxx2uSoc83gcz1fGmTgu7ng9Xmju5bdiTJa5lEnw=;
	b=a6Isq+Dzenvm/9gkAgMKedJJGHnZJaOEIC2mQVe4Yp1un9ZUXe7jggSSjM6aB2gAJ/cp
	 LTQebwTsdz+3EspGJejDbbguJ4G/w+J1FfOExcUdai/9WQdnw8yad206ULA+l57HN54Qk
	 tvwypzX501Wbw7/XeK6APRcT/A2HrHTyN3zOZTzf78Pz1iUwhtTkGnlmXWWNJRmLKz4W5
	 OILyX2sPWvrmc5VTkg3orJT88GUNvxWShmVJ1fBaPTP6t7nbcn+xc6K2FdRoGgNjnrU/R
	 F7nTaWN9mP4o4lRm4u5a2/G0TMMyyZJzPp0tB915pUpJ+qxo960edT4bO2stsKoDqTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oj+s5Paq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C21606A88B;
	Mon, 16 Nov 2026 09:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oj+s5Paq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89141F000C6;
	Mon, 16 Nov 2026 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822306;
	bh=7tEmxx2uSoc83gcz1fGmTgu7ng9Xmju5bdiTJa5lEnw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oj+s5PaqBt9/DbiWrY22jRs4+Mvji90JmsS6W1OCZBrH6HBD7jp0sGKwdPz2SOnFN
	 SVE89Qpp8K+XwVSwHW9MeJPGLER2NpRNrmmBWHHGCOoDWnJyQHxZbJCnaDV8mzdqzH
	 QHWGBe8BBHz/iYDy7cT95p+fnynZ/5LWKioN3whoujaZutdTNezQ5bd5aodsrF5KUX
	 gR2Az2OgzTO2RUOqA5eZzys5G096xAQwpMqj6zQPGvgB4zIma2NjXapKthcekvwH9u
	 gOJ21eUzBZefYAqjgQPl6wAj6Hq7CSepBtTkqhR9knPU31mDc92j+AEYafgpcCZw9H
	 swjYl5SyHWGpA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:06 +0100
Subject: [PATCH v2 09/13] bpf: return NULL from bpf_real_data_inode() on
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
Message-Id: <20261116-work-ovl-d_real-v2-9-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1862; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mYuPWfGXzyPhmBavnKn8qYRaH0QvgFc+AD0P8F1FbFg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulBRcordIOBXhFTJay2ho2f2H1u/yaOawSLezHbex
 LN9hjMndJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkejcjQ2vpA7OVL63fhMl6
 yUR2RO03/VTiv9Bnh71We1rT9XyTZYwMa7fePri5u+DW+vUH9by5VwSe0mo2nm/1VpZjf7vb99V
 aPAA=
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

Acked-by: Alexei Starovoitov <ast@kernel.org>
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

