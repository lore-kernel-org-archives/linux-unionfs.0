Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817965;
	b=e2tTgeiTfmDWz2DMFM33CxvvAa7K/cW4FQaICKkJfqMlS8UUlXtJMVjzfD5g0MVFbnHp
	 f6XQLLTHs6xL4PA6nyIZpDBx2NLgNiLRan6uFEsIgC6pg8uHXU8g3/IPcjerU8IAVFfqG
	 HcuXwBLtippdf9ZVpUSPszWGHmqg8fpqZcYVDajz1ZtBxmsRLF37K1MVuPbJ3zuT2hOnT
	 hgDOYZZUS75mghk3Nl3OaIqmEuYwOEl9hxWyhvpt0agvREMGNNY8e+voBNVnAQw3iQubp
	 6EyakbD2oIDQL210v1rqy+qZjw6WywgBL21ab073b3xBn6wMiu7+111nQ34WnKtzoIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817965;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38Qizys+jXdkmlwnr7b3/HVrcBj+lb1Na9/a8RmfPTs=;
	b=W5JhRnhmy5zj8BqVjg3D6haaDWOd+lSVLgggosrnXdTrsG8Cb5DojR2PDthr31r60m5t
	 fKWJZQpX8wTXHmGwST+PbzcmFs2q1duF5FYz95SdK3VSI0Dbt1/iorC2v9f/jLTGx9pnd
	 mioFSdCW2ACqZODz5W+e1fV6kqx0BM3jPPjIhBcAp0xBqpXAd5yWsFvVon9RJX/S+nEo4
	 nL4M5e4C4HdHaDWt7zdtAKnr9wCPF8nGFYEHMPTo+NZu0OBGkCXXQuBfkRzsq1XIwF2Us
	 WiAlBusFozXyexilwu/MzDnI89+Ua+3AootNyugaUfcxEdMSmkqbGF06QBMogbwBgEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EKuWKdv0;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33365606A334
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:46:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33365606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EKuWKdv0
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so9525925e9.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817964; x=1794422764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=38Qizys+jXdkmlwnr7b3/HVrcBj+lb1Na9/a8RmfPTs=;
        b=EKuWKdv0bzUv04O6RZn2v1q9rQZ+7ENTfUyypFcqPGCy9/xggXi4QLOeu8aUvwrtkN
         Nqg6lh6RgAzWHc2B6F3XCr2hY5LcJyuSf3r2QoR9vmuUVMtlOSkazWsPFZpnrM3UWF1p
         Dv+rlGdqXk4ZK1coTJhLwVcuoZGnBL1rEPFyPGsafC2poMzJogX5Qg+WolLesruHExWd
         yp+JUvjwv7watN1afuDuE7fO7WzJAFfJ00zIho1Ln8XG53VYIAL37q019+ilmko63iKf
         b51EXup6Oyig3kzNMQ2WAXrfUFP1yQh5a2na+wBJnIdGMWG9Wp8KEr2zSDMGkjVi204+
         /TIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817964; x=1794422764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=38Qizys+jXdkmlwnr7b3/HVrcBj+lb1Na9/a8RmfPTs=;
        b=v2btKlB37ruPjEX3v2Uj7ecoelXpcK791itCvN49ozB8Vj6ySCSYoX3262DVXLdUba
         UZ2BQ3nrlrvNnu9TjKNc5vViWEkM/hKZ0HqHKdp4SmloDN3+8vsUGoOiM0Pf+xHmpQV8
         GPOnyeEd2MQwPsjZrr14/FDxNAiUXcOzGQTXOAqmfg+3gSJ85pGseNvE/0xJVzZfsF56
         UPzgRwu1cg99M2rRQezyVzCJRXLVtKro9qRJp2QVqk4I8G9GP9T7WGu2yjSAZJXEboL+
         0ELw2qurU9N2MOMNs9NE8KoGEg+PzdHvIL2IfbfOgZnVAHWl9/FVor2ZP9Gd5P8zkR+K
         dlGA==
X-Forwarded-Encrypted: i=1; AKwUvBylHsqJ44AeBM0ME27aJ915PlPTYEMnKqy3XeEr5PbtdS9T0MV4sL380Xbt3ALjkqXNzvz6SSPGYAAXY3C6@vger.kernel.org
X-Gm-Message-State: APuU4Z8U0/qrnTG9AeWwH4Jgq/pllC6V7F0+mr+H6G9JLCql6EtvNEvm
	aBY2jFv2txW+CLHmgmYlyIKfFkSC8JzjyYsFxOBv/8ayLeiZxWI2jTI56m3Y5FoN
X-Gm-Gg: AYBFou3/BOmUhVZ2LFkmI7ZmdDsWz+vjrGndw9IKrbRYHqvLVxLc7vRSzi5AcaX7FCS
	6A+TrKVcT4oTQaxqmsB8js5szgQvlMaZwSEDePS3UR5TmtPEYNiRgkUxK5BgCvu3dvntXm0+isp
	Byk3+FRV2t3hEHXLe3KBx6P3+rVkg1mS7aKBcQG7oHkFfO9PAeZLjXAsNNgzJuk5GRAuivGQov4
	nsWiceT7bzPzwq+uV8MRRzyafFonG5BzBmAsTGkqrB56+Dy5sWHE4XzUa980sHdaU5EFLcQSuSu
	8vT+tA2El3L1lPEd+XiK4EtWWmqk3pi8biI7W+vXWQNuXdNtS3ji7oRnK5tsEy3UIs+EBcM81Ne
	TG8+8oWiut3G3n70gmjm/qAOXbwZ75+yYiMEefHBoDz4GIYlfW8bI362oL2u/qnp5uq8kpR3N3Y
	UIGkY0np8BgqK3Fe2uXlRgq/Is2ocz6z+EC/Sz/QlQgi7Env2Yzdg5cKfdlA+7En3hBIvRaZ6Gu
	ogsH15fodZdJOT5iahiCZ8pWXXIrs2DUrTA24e8X9GSGyVXTH6jhpVA+uMDbAsJxPU2SgnHFPx1
	P4dK90gAcRMlV/vgFGio++xdz2aX3SjNZXsvQgG7/a2SEXUQP9vUhimO+S0eHkR1ZeTKQHwyJs0
	3G7tKD89fGVH3
X-Received: by 2002:a05:600c:3d8d:b0:4a2:cbe:beac with SMTP id 5b1f17b1804b1-4ac18a89393mr360447985e9.23.1793817963616;
        Wed, 04 Nov 2026 10:46:03 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fee968763sm5328119f8f.56.2026.11.04.10.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:46:02 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.6 2/2] ovl: use the pinned upper dir in ovl_fix_origin()
Date: Wed,  4 Nov 2026 19:45:59 +0100
Message-ID: <20261104184559.3630145-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104184559.3630145-1-amir73il@gmail.com>
References: <20261104184559.3630145-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mason <mason@kernel.org>

commit 4f61ff2ebfb3d2967b83b6a4d456242244d5a61f upstream.

Renames made directly on the upper filesystem during a lookup crash the
kernel.

A dentry that is passed to vfs_setxattr() must be pinned.
ovl_fix_origin() passes upper->d_parent to ovl_set_impure() without a
reference, and the lookup holds no lock of the upper directory. A
rename on the upper filesystem changes d_parent, and only the child
pins the new parent, so a second rename and an rmdir free it.

With delays in ovl_fix_origin() and ovl_set_impure(), renaming the upper
directory twice and removing the intermediate parent during the lookup
of a merge directory without an origin xattr gave a KASAN
use-after-free in vfs_setxattr().

Fix this by passing the upper dentry that the overlay parent holds.

Fixes: 9678e6303057 ("ovl: fix inconsistent d_ino for legacy merge dir")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: add helper ovl_set_impure_dir()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
[ backport: context: ovl_fix_origin() calls ovl_set_origin() ]

 fs/overlayfs/namei.c     | 6 ++++--
 fs/overlayfs/overlayfs.h | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -883,8 +883,10 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 		return err;
 
 	err = ovl_set_origin(ofs, lower, upper);
-	if (!err)
-		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
+	if (!err) {
+		/* upper->d_parent is not stable, use the overlay parent */
+		err = ovl_set_impure_dir(dentry->d_parent);
+	}
 
 	ovl_drop_write(dentry);
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -492,6 +492,12 @@ int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
+
+static inline int ovl_set_impure_dir(struct dentry *dentry)
+{
+	return ovl_set_impure(dentry, ovl_dentry_upper(dentry));
+}
+
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_is_inuse(struct dentry *dentry);
-- 
backport
