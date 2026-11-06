Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938292;
	b=mBMr7QK2hu2Si7sLsaR+/iNMBtFXO7irkTAlOKyJFK8fKBculjRMAx3kbG6zGA4hs+YY
	 5Q6VO1BI/nn3npIs0gDllwtiNg6P3ZGe2TouF5GSW+Z3t+ey24Egr0/uUjCiURMZv12e8
	 VM9v44BOfl2Ik5k6yghicNRUgjLRy+shnAot3oQh3CQ082lv+QYWl4KkOYlKqeFUC1k9U
	 psg0KqSkdNbq0oVlcSdb1lTGwor56tbeT5wRd0nmHkEHiYlA1n8MUFluRFcVGiUHvOes4
	 UqwQXun6sQyoK8msOreT+bwiHks3dGdkS/0j5E6tyg9eOELg0D5YPvjjMcSvHTgfGCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938292;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Z92dFtGsD7f/QDD5XfJXZq8nkBYV8QMmfDZuVo5drRg=;
	b=kvH71/zJ3Ja/nk2XGf0GSpl1ca9N3yQuCWIXpc4WmscCaUog/YpDm2bs2i/uJdlySbjx
	 Dvok/j/PRfjAMq96fIvEDpAlANZIGC31ZOtS16TjjZduJcWm9EnHUnBZO9jzmW356jelA
	 3EI4cOT7iBMFZQ53Sfnm9v+4zIFedBE3P+QFp0yFHRdyw64gH+ufDaNMl5xPSR8YbbhsC
	 yAANd/Rc74ozs0UaoORgnYmblnrf9x81rZfyZNBH1+nsysArOk1sd1ohOKT/beQiaKjI5
	 Gn5X/A/kAgl1vQwJWhV661KjYZlWI45AmdwGZUd+Bj0goqGKq0tDnP92Iamw/3xoMDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H2gKWQjv;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DCF606A31B
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 04:11:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3DCF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H2gKWQjv
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b47c1a3c74so213170a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Nov 2026 20:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793938290; x=1794543090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z92dFtGsD7f/QDD5XfJXZq8nkBYV8QMmfDZuVo5drRg=;
        b=H2gKWQjvKa0FHrPs7frV8FiyVDSOYWusKMVgtbEnOYuAIDxQZlFxdeWRvtfDUp+mHQ
         iVnIpElA/XQDTsllJFBiuA5Y8qc6Xv7pK8Px8T3vzmsavqY2VrQGfrAzGzpOL9ntsBaG
         wRcwzwKL7A38PqQ0zKwVUYPv0qnQNsfoFQi3whiKZ2It4Cm5S+ZakPMilzHHZUqqgCuM
         QC4gHGwADFYhVTJGZqS6t87321lCFnFJklGhh0vfxHs5H6LJrlN/mQekMwzpIrrSWKBN
         WKvucCASwiyhKTqAvQnpdr3UeQ3TUsMd/C8nbHSjUTG6T+P689SnmZTK8nglqa71DdVQ
         xvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793938290; x=1794543090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z92dFtGsD7f/QDD5XfJXZq8nkBYV8QMmfDZuVo5drRg=;
        b=ZcuS6WbdV3r3CjyC+e1M5ZEcBNL7xzsCMyrSF5WArwIEeveiM1F4Tws9h6vymOx1Q5
         K02pjhbXZ5TPH/CoCwKoCE+iwEMOBg+HhQaNw3e1bHSDJFrxGVxbrPhRaMQGYcN32U/G
         a6ZFc74ycsMJWdlJNanmoJfZi1BdDCBsUtVYT3QaIUGsj/n7V/z1Gsvzz5/rWPOgEB22
         LjzDz7rrOFLHi3HbVkJFAoic9icTngJA48u1hJY03hF5INpFnTYXXkUsceqnOq757zkb
         RF0G8DvQOV+KT+t35p/iqOTJLaKIPOhlsZSUsNMKb8jSttjSfGpRG0EH45agCODIMRML
         CsGQ==
X-Forwarded-Encrypted: i=1; AKwUvByMU92mv5sTKi/BGG3z14FiG3Xh4o0gfEKioCQ/8BcPAFqfXV2NZMhMX6BxcDTMN06jbLE08EutL1jXk2Xg@vger.kernel.org
X-Gm-Message-State: APuU4Z8LaYgnJjLn7HKSTPCyy4g6Z02RccRri6GoiJxLH0DqTyAQfZYy
	uSqV41x3R9awqHS8ERYA6Ex6JxCKtUzSpd17KqZ8pdFdGktE2DIltoCLpr+5LF4N
X-Gm-Gg: AYBFou1ydJR1UgKOsEQDwQ+UmxMqSEhmsGM52eBulmmS38/4CyQF+tVa3XADL1tz0R1
	3RkG8ZcP76OJiZ7sd7i9uqFjjSFwVHt9oVvPCgq1ShP9b66+XO1pxCCs/fHOtvyDxoE8b7Tq6nb
	1Tbk4XFbgyZfFxrNHfPze/5VpUFhI6Juav151IXKIfIB4+fQosQeb8KIUjbSx79/tqvCkc8pfiT
	MkpEZq336Wp/XFzrkEEpUrKNp/f/OpzFXHFym6cJk7ANv8805kVqUJu/JvPvp2nAUc9vTZL4Uvd
	8OWTqpXRnepjSXGSsom0OUVmgmKuyhB4GDXmeY0yRrjXDqXf3GJ8KdHSbLXJLfuapYbmWlei5FB
	g2z2vXH2h2zv2/T4Xo9OZH903AIVIpIc/hvt8DW2LXeV+rsby4P4B0NsBHtoath1GNpslAFTBq2
	pr9xm1yi4bAZ/AqnCHCVY7p+5PgU3d/1kXvvgoIOC7t4kGmmNuNw4JUxDtF4cOyMJ2+0KJhgTH3
	ZOZQs5CWeYnfU22D3Rvpa56C3s3TRtKmnTs8w9zSMGgROp1f46VednTfTeZL3EAGlRnkYP3IWRt
	JujIuplNE2ma0+5xcMiRfQxV0mdL0J+Woi5uYWmNIDvZHBnsEAeAWj0qwLSAz5kh+YM5engwQdP
	nCsDkfzFaJgZp
X-Received: by 2002:a05:6402:3808:b0:6b4:5d8c:95e2 with SMTP id 4fb4d7f45d1cf-6b597553644mr863309a12.4.1793938289842;
        Thu, 05 Nov 2026 20:11:29 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b664ae54edsm251088a12.15.2026.11.05.20.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 20:11:29 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.1 1/3] ovl: check that the parents of volatile/dirty are dirs
Date: Fri,  6 Nov 2026 05:11:20 +0100
Message-ID: <20261106041128.3797453-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
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

commit e34d2ef818e4c7676d8d8e1bf43e6a1ed39efb2a upstream.

An unprivileged user crashes the kernel by mounting overlayfs with the
volatile option.

A dentry that serves as the parent of a lookup must be a directory.
ovl_create_volatile_dirty() walks work/incompat/volatile/dirty by name,
and ovl_lookup_or_create() returns an existing entry whatever its type.
A file or a symlink that another task creates during the mount becomes
the parent of the next lookup, which calls a NULL ->lookup.

An unprivileged user mounted overlayfs with "volatile" in a user
namespace while a second process created a symlink named work/incompat,
and the mount task oopsed on a NULL ->lookup call.

Fix this by returning -ENOTDIR from ovl_lookup_or_create() when the
caller asked for a directory and the existing entry is a non-dir.

Fixes: c86243b090bc ("ovl: provide a mount option "volatile"")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: no ovl_start_creating_upper(), check the child of
 ovl_lookup_upper() in ovl_lookup_or_create() instead]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1331,18 +1331,25 @@
 	return err;
 }
 
 static struct dentry *ovl_lookup_or_create(struct ovl_fs *ofs,
 					   struct dentry *parent,
-					   const char *name, umode_t mode)
+					   const char *name, bool is_dir)
 {
 	size_t len = strlen(name);
 	struct dentry *child;
 
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
 	child = ovl_lookup_upper(ofs, name, parent, len);
-	if (!IS_ERR(child) && !child->d_inode)
-		child = ovl_create_real(ofs, parent->d_inode, child,
-					OVL_CATTR(mode));
+	if (!IS_ERR(child)) {
+		if (!child->d_inode) {
+			child = ovl_create_real(ofs, parent->d_inode, child,
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			dput(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
+	}
 	inode_unlock(parent->d_inode);
 	dput(parent);
 
@@ -1363,7 +1370,7 @@
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
backport

