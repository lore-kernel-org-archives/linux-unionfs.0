Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794751366;
	b=axZuX7QLvOQVXee1nmy4ICdU2Y9seHINCZgdMDzqtbmt3f6n1aJI2L5weWUNkl26VuyX
	 Zc205O019MHhVk9kasx199ahGG5E1Pal7WuVGPwnps0qbXPnp2RNUANAl3zaLZfILbHvU
	 filu5+F/vdZBH52adhmjA61FgK2YPEuyBxDzfg1dGrzGyuQlo/tTadv+HTKeFF7U8sC4w
	 9gK3TU9sf4ImElVyU71wT163Juv7JudeXPM2NLBya4WSBIHkdMacscTZXDH9dg1h/hDgO
	 TE+oe/ntmPSZ8pUvk9lCbGPQXzU2xN8Svup6uTU357Xy2ggOI6ULhjulzykYdk4I2sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794751366;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=i08ApOXti7ASPBt661SD3n+Ftge8M76WHHcwNG2IWGM=;
	b=OcPI27HcBRAmn/8xUVPqm6vQhUxF4bh3CtoYvAFY4Jw4BnPuwqGFeFMko93dc4XJFzje
	 /sg7ZM4yQD0nFHefCx7YyRCq8fgMjPlfH1j/4geFhRAr8QS98TC0b4dQUckzgI+WCpB5Y
	 +TkkcJ+N45x+TSUy3/uE4e4xUkFLaY3nEAqm35uuUvKm8V21xGAGYGWCS58z9bMPUCuaI
	 imcJxr8xvy5b78dm98cQOPIOfvP5IxOum9dBCMaDkGT+XtE24erdknBCeSTG+oYGh0deV
	 MteIeQCJqhjokDLRGVXG7fv7K/X/3SwzZpMzyL5S0zA3Asji+qN4+TsnySVMiNOrFPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JerxBD4p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6B8606A329;
	Sun, 15 Nov 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JerxBD4p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830E81F000C4;
	Sun, 15 Nov 2026 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751366;
	bh=i08ApOXti7ASPBt661SD3n+Ftge8M76WHHcwNG2IWGM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JerxBD4pM157aPDvBZHjgj0/PdbSmnKHj12oQwJ1pDtPlQIndm0OzuljJhGdN/skn
	 AbbE2kVSl2pnNBFFgBybWb91GC4AYp+a1yOhc4duqP44zOM9Z/mnygw1kr9AVHGsrj
	 C1y4ZD5T+B/CkoXS3M3wJ6NaJQ1nvPXULuDo4JvtZHg89keN12gLYINskUv6pg6qR3
	 igR8IsdaD8ILX3LcHsx0wBlQ58ZrcOiGLszGsBlWijVD9DA+hmOYQmDT9IHLHOP205
	 nUgxLMIeACAE05+2G3aO7AtqkLLsAjMVMeAUx9p4IaOKINKW6JuV5S7iRWW33SjlwY
	 NkonebJTyykHQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:41 +0100
Subject: [PATCH 11/13] fs: remove d_real_inode()
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
Message-Id: <20261115-work-ovl-d_real-v1-11-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2296; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bY/hKVIBtIsVVaCC+49NkZNtKSbERRV6fGevFpDq4/Y=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B1j5bw+l9O6J0zuaL9GRw2D9jGdZzf2fZEQ2/Ba8
 ZBYxwftjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIm8WcTIsHziAZe2NfYaBhWL
 5v3Sk1kQ0LtqsroTp2exV8zFuKhwCYZ/2n2BZUn+uTte7465LP3+SFz//1Kn1OJABf177DY83ze
 zAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

All callers have been converted to d_real_data_inode() or
d_real_metadata_inode(). Remove d_real_inode() so that any user we
missed, or one that gets added in another tree, fails to build instead
of passing an ERR_PTR() from d_real() to d_inode().

Add a porting.rst entry.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/porting.rst | 10 ++++++++++
 include/linux/dcache.h                | 13 -------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c38f5df755bb5..28a24b702f2a6 100644
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
+the inode hosting the metadata. That one never fails.
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 5b3b34d271bd0..2b15179e9baf9 100644
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

