Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938300;
	b=P0mprMLxj69/XJ8OGTRvouN3owETO9lFnVqrOVAsrLKB2NRfv5wdebH6mB7K2SF4dMJz
	 3H4OQVUfkJuEqUWuXJNNKBoWsxmTz2n61zhFmusS5+p/Z4/OU2F8tUHhn8zomO9OFWPGm
	 wsRJrL6+Z9LrpjDhL7JzgRMwNsvPQeLYLsu1HCIN50RaP0Aj9rgUY533/jz/UXELLkL0n
	 1XXKcHxEN1W/wJFVa8iETWytt6njucT9WxHnuEzfiILuU7zB5nTPesAS13PiPBPGQqRCu
	 UpPP0Qb3irEyoN9NbHf3ePJSKoBu9gj6KnlSbdfgfdulMS9c9WfOcB0g6SuidD99hPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938300;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsuAOTTGNJHDRL/PET92ckqJsEMuhhPzW2kJOu8dSxw=;
	b=IJJC9drlAI849jZQAqcWvfSc8DCsY4NxhScmPDog3g66hsqIwKWHMeYqibyZRTQdXtPe
	 Y+Zsi83CEVvQP9CmuR7Ao2RSwfuA2SScF8uKVsaJQVhEzsyQ1u2tbkYjic2l2VGQRbhO+
	 ffzTxUBfGc9cLZdWdLwx7ERLGsFfEG8gIymrdxexjA6Ad/NM0Yw6P/cppXOIrJDSBR9fl
	 FLckSDJDiRFTt6hX4e6vaI9rhVLqLs7ifPKEpwMqbXwreDzCcVo0mWLGApM6FGjMuhhkS
	 ywgnA8VB+9E/niDGpA9xUhDpnE8MuI5+XL4xrNYwk+m+OdOhJNrIaWmvLgSbgIPjSFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FrVFZuqb;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DAC606D803
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57DAC606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FrVFZuqb
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c169ae1cb26so222006766b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938299; x=1794543099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UsuAOTTGNJHDRL/PET92ckqJsEMuhhPzW2kJOu8dSxw=;
        b=FrVFZuqbBD/ATcdf4MdbMrP3gUVyAdYdZiWwLfNTL2aumzbXalq3iWt3vgYvsup99P
         Aayvfa8SKmbmqihkkuwk/l8kxpPMJ1pvBj7pozWAIwkI3lg79bXt4Etrc1DjIB2Lc2TI
         pKi18ur6w1Sk4CgiWOqFMcSOi297dqArhbJg/qmHdCoGd9I7nW9U07qSF1woC3Xegl7/
         nyRwfCM0tlO5x9RwbU2wiOdKhixhbUDR5veMUpt9N4t7uQurZLi1stGtkCwnPhg7YMcX
         D0do49aDfwGFy0YobkW1oybPaPSO47+EPZMlAoI8pQDG98bkhyH+zxVuwg2NDrBuALZf
         VhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938299; x=1794543099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UsuAOTTGNJHDRL/PET92ckqJsEMuhhPzW2kJOu8dSxw=;
        b=tqhYYLKzPuIFYdhdeexe97tEA0Rd7huckF8bd/+Ka/t10pmlrO39aHdOpIwUhmb7BG
         B/WYHX6Mfyv3K9cqlyMQubVbI6+VPgeSQbKHHrc4SqIZmiuBy3XM/ym6MzDlaiqRO+84
         BRs8DTQbLDsXCPQdx1sspQPiPWYbeFzyQBf0GgU4GT1jqWucBL8m1xEGJn2JICiRvNut
         updKkrdnP9fBZmqg+r13WQpMKyVWDtZaEK33J2UCoix2pW2WwI/MAvpq+iUxj/O5sKVJ
         JoyIcspis2zQf6HAV47vhCFebesb1o0bGZTEUz5TGP+pXc4N3zLuU5jpOHxguSeCCeJr
         4HeA==
X-Forwarded-Encrypted: i=1; AKwUvBx9xAmutJTX80+UTEnBPNTPe8rZIiy34FUX0H4QbdQmR6IWYtrjr+SzPcep/1CiRpjWm41pIEO2KOzfB17P@vger.kernel.org
X-Gm-Message-State: APuU4Z9bV9VmLnrbetQ+s4MfhD8TlbZSvFB00aPcPmO4HhoqvjB+FSpK
	JfLW8sTa51kc196imTt+O5VB8TpQP1QLJj+gnVDSMXuDx9m6aJSOO/sY
X-Gm-Gg: AYBFou3ZBuwFoe1tEf88rB/tjnColDFoiM4x+LUqyKRmLzkk/arjkTMSnIAg5skxaPO
	CSo7AtPlG+LJdP7aIkZilwONFjdtUjoJVMG0Skl2MxA8aFGYCl9PT9a6uRhRpv3hOfw1YIJGAWJ
	ZsqYbtmhUQYYi6RfTlj/BppY4iDf3oNc6ZcQJSRJZaAQKWve0J0rXoO20caWJ3iKdoObYO58TOc
	o63WlbcP17krUC29Hj4QSNCNMTxFPTULxNNILt5gShfJxz64xc+tG/M2SNWid/HOs7Ja+AocRzZ
	q2ri2H1MURkfMarJwPi/JHEEiQkKVc4xfzE3CIqwCCzJwuLA9h4uVS4GtFlR6jePhSJhRuluWgl
	rb9O3qXBKhnXKxd5ILQ5oagHeTL29ORjGqsh9l5WP+MdrwiabBTOXjdRYDabw+PL+CzML/egu5G
	OD9FdWCerY6ghw2LqIfpvLC2zZagsGm9fvINvtRE8pTRW32MUm75RaC4TA9rQ0g7Ol+DBCoSFxC
	ctIGlOSGKOymTIcgG+xZzLfiIwuJhskfpXo1Zv32mp1T5AHfc0km8hAxzlHY1YQmen4zs0SxnFx
	mPc/6fpAyatNU4hrEJgljdAjUET3AxTmoVgcmiecvFnB3bg9GTxyn9m5K78g2ZQTQ8+zhJNSLW+
	ESmaAdtHW86pAO8GG4JdZZ/C1ujy7uw4f
X-Received: by 2002:a17:907:fdcb:b0:c2e:616b:6763 with SMTP id a640c23a62f3a-c4d3525a3f4mr114291066b.3.1793938298364;
        Thu, 05 Nov 2026 20:11:38 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356c9526sm41729466b.76.2026.11.05.20.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:37 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.6 2/3] ovl: hold a reference on the parent in readdir
Date: Fri,  6 Nov 2026 05:11:27 +0100
Message-ID: <20261106041128.3797453-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261106041128.3797453-1-amir73il@gmail.com>
References: <20261106041128.3797453-1-amir73il@gmail.com>
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

commit 16d319e12328acafeafd3eecdf09c46d7fb43452 upstream.

Listing a directory on an overlay uses a freed dentry and crashes the
kernel when a lookup moves the directory at the same time.

Code that can sleep may only use d_parent without a reference while
something stops a move of the dentry. ovl_iterate_real(),
ovl_need_adjust_d_ino() and ovl_cache_update() use the d_parent of the
listed directory and hold only the lock of that directory. When a
lookup finds the directory under another parent after a change to a
layer, d_splice_alias() moves it without that lock and drops its
reference on the old parent.

With a delay in ovl_iterate_real(), getdents64 on an overlay directory
raced a rename in the lower layer and a lookup that moved its dentry,
and after an rmdir of the old parent KASAN reported a use-after-free in
security_inode_getattr().

Fix this by using dget_parent() in the three functions.

Fixes: b5efccbe0a12 ("ovl: constant d_ino across copy up")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: fix comments in ovl_need_adjust_d_ino()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no ovl_need_adjust_d_ino(), take the parent with dget_parent()
 in ovl_iterate() and test a local flag]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -476,8 +476,8 @@ static int ovl_cache_update(const struct path *path, struct ovl_cache_entry *p,
 			goto get;
 		}
 		if (p->len == 2 && p->name[1] == '.') {
-			/* we shall not be moved */
-			this = dget(dir->d_parent);
+			/* d_splice_alias() can move even a locked dir */
+			this = dget_parent(dir);
 			goto get;
 		}
 	}
@@ -697,6 +697,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	struct dentry *dir = file->f_path.dentry;
 	struct ovl_fs *ofs = OVL_FS(dir->d_sb);
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
@@ -707,18 +708,26 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	if (rdt.xinobits && lower_layer)
 		rdt.fsid = lower_layer->fsid;
 
-	if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
+	/*
+	 * The lock on dir does not stop d_splice_alias() from moving it to
+	 * another parent, which drops the reference dir holds on this one.
+	 */
+	parent = dget_parent(dir);
+	if (OVL_TYPE_MERGE(ovl_path_type(parent))) {
 		struct kstat stat;
 		struct path statpath = file->f_path;
 
-		statpath.dentry = dir->d_parent;
+		statpath.dentry = parent;
 		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
-		if (err)
+		if (err) {
+			dput(parent);
 			return err;
+		}
 
 		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		rdt.parent_ino = stat.ino;
 	}
+	dput(parent);
 
 	if (ovl_is_impure_dir(file)) {
 		rdt.cache = ovl_cache_get_impure(&file->f_path);
@@ -746,16 +755,19 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	if (!ctx->pos)
 		ovl_dir_reset(file);
 
 	if (od->is_real) {
+		struct dentry *parent = dget_parent(dentry);
+		bool parent_merge = OVL_TYPE_MERGE(ovl_path_type(parent));
+
+		dput(parent);
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
 		 * dir is impure then need to adjust d_ino for copied up
 		 * entries.
 		 */
 		if (ovl_xino_bits(ofs) ||
 		    (ovl_same_fs(ofs) &&
-		     (ovl_is_impure_dir(file) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		     (ovl_is_impure_dir(file) || parent_merge))) {
 			err = ovl_iterate_real(file, ctx);
 		} else {
 			err = iterate_dir(od->realfile, ctx);
-- 
backport
