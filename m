Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818296;
	b=oksgkypfRXjzDdwYouixjfqN6fI9ppAUe2tGPQPUx1ULfkF2VxlwKn/8Djv1eQ1cvpgp
	 6IYHItvbm8oIe01dqsWzSOXkmKh8cPeofnEkBhyfjANnWttrjCgjf4/zUZsSWwj4kSB65
	 jolfVsAJr4/itj14yH2c4AIxJytnXlUBkiXVcBN6S/KJV1m3hJkWhayY1wOuGlkWJ44ep
	 P54KiEr1XgNOqCXclnrObFseJcVqRHurpBmrDgkTOW0QGTTBod2tTeqFsxEfeKYJ4KVO1
	 jrpOGoccLOadq7XXm7vPaO+BhsVuYMBvH5tAzYj6VdwpAE9emjwzFCHvuY+1jTJqMhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818296;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Mrr2SsBpmVWLOIEOT48PyurnC8zgreuJ7g0fGQKuitk=;
	b=jZHGUx6bQSnoLpjsqFlgeIvaK4wy6i1ETvvE6X2O3MnrFxBk9XFf3aQjE1kTc4DF6c5V
	 a/3YU3FJ1twXmjFXwZoUeFI3G98/XPk559IFW7Wlp8/8HbUaROjsu2Eo7eabkeo1By/Y8
	 rjPbkokF3ipUjB5uZ0TaosOdhj4v9wYCptypKOwUJy2bDkJVQHR4pHv5P366hY4N4Bdso
	 INlFp3Sa1XNvXHAtmY7ZeX9Iv71Xq7OZ5WNPkF6pTkgmtijEN1aJYIQK2lTsPf6A1nd8Z
	 Qtprbz0+qURxHbjGQDeYiBtLipjKiREDOJ8tWxKNQRiVyrXUpASvXUA8hldCz0zj2eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ADtGWJte;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F32D606A31B
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F32D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ADtGWJte
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e00eee27dso604404f8f.0
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818295; x=1794423095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mrr2SsBpmVWLOIEOT48PyurnC8zgreuJ7g0fGQKuitk=;
        b=ADtGWJteQDh2VteElVOy14wb2gFHPj3Mm9n8h3zsZWRf8CWRjkRjONjOovYUtYFXD3
         Z7TebCe5RyRIrUY5mkugRCGMAU4o+hgmtIarAHORPJUfdOtJIz2r1A9qkzqO/VqIrYw2
         eGprSue4r7uiNBOk4oPBP9+pzVJGEyRit4WvLdC0/Hs/a72YVrXtjBPUCAb1Rmg3mTFr
         CPV84Vg9KbwgUm90m6uGSLVXCTMuyjLZGT+fFRHNMH/FvX1eMnQ0SoH9+z6gquOVBUMS
         CVVdFOc0poBJc5iyGZHgBkoFvlvckdoo1cD7ai0GNyg/FKycjvVZJQDiSx6LgdF+7sN2
         zm2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818295; x=1794423095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mrr2SsBpmVWLOIEOT48PyurnC8zgreuJ7g0fGQKuitk=;
        b=pyK65jpCRTV0a9E0L2zDdTDC3g2PXPV10AUWpr9OIz3/jTJrSHFMhpvbcsoYoC8GMA
         w7TeOmaLKlse4E1Vt5uFghLKecz2mDDxd3OPDxLaRxNP2HsY6QfsoZKUyvwYAo5kxmDY
         U7Wd/ww0PmHnFPJvojjJ6SRtPl2rqCnWRpYzugDmYGyhhAz9/sVNxZ6vy2z5CmK3Kzpn
         aqXxosdTPgvhsjZjtO5dz7FmXrc/Wj/UiB3FXUL2p2OCLwfgsMgG3VOWfYbJI36iQ00Y
         5AQAKH2rrWsOMTsJLttKR1syhvYsflmNUX7pi30P2iDy9cU5pI+LbYbFtYdgpuxKBER6
         bfZw==
X-Forwarded-Encrypted: i=1; AKwUvBxjvL7T/Rubc0f8/KCuNccHeROKCfvTCz9BzxjBV0SnsKKWKz/hz4MZYnuq85waOdTKml2YBF9R2v2gnQjU@vger.kernel.org
X-Gm-Message-State: APuU4Z85HdXH2OiBcFYNlU5/oSx5aAjL1Sf+n4Q3tuWfyOR8kCwD8opJ
	zGtmLBVn1UJhNsfPDW0syafYPAN41fRYeYNJaX+5jgN1Hx/97CMuC7Xg/eeJFd7r
X-Gm-Gg: AYBFou3kz5nAF/07hl3L+JVtaalJV2PHcPSALZzhio54mbZZi7MZ3X4hRDBPqoP3MUV
	UnYRIc5+zyCqL6LTb8sdiKiHPUFfowz/eQzyfwiHSKNbk+lNkTnVhY081FKmYwzqeW4qiJ/kbb0
	iPg8BTLa01t0G+zuGeOhiaNVshZcedR3tP52MBRDo9k5fm6sKlf4IijPSHPFiNi17we95b6Ybm/
	DBdBFQheZxssBcIeW3IEnDj1I8HZw6nJnzkHQiIX6Qi+IKTPrCn/mIDLuDCGh2WM+jVjL5RX3FH
	xPdIcplip/ZTd4QRMLTNMrFrAz4KrcZDnApsZzipNyHMo8xsZwSEpoUY163gtlqzTx4BCatV4t7
	Mc7eBmg2oonPJt5UmB38v2XTmhv5LJ/Zdrgku21nzSyP4i7JnuN8AxNTcK4ODW+h/2rLeyYUUAC
	n5C6veDCoEJSzrNwQIJbVEvC/qXVUD0v4RPLZoXePWSR/HT4bXtx8ZCU/MucqbzriGGxNQq1ci8
	0wyiTsoGQkgGl05tyF+zO8gXFthb2DeyLOE+VkTJe06Q9la45nM/2n+qbfKL5czkSbLKf872sQ7
	FIuDR5OtB4h/XjaY+b/UgWNurl0LrI+W/zF55DbD3EFwTPqMXoiA1pMEg7heCzGIvFKhMfoCxFO
	ua11i28ozva4x
X-Received: by 2002:a05:6000:4a07:b0:48e:68d5:81a6 with SMTP id ffacd0b85a97d-48e6e4f53fbmr42068564f8f.34.1793818294901;
        Wed, 04 Nov 2026 10:51:34 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fea180e7csm5380394f8f.5.2026.11.04.10.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:51:34 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.1] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed,  4 Nov 2026 19:51:31 +0100
Message-ID: <20261104185133.3630642-1-amir73il@gmail.com>
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

commit cbec8610ec5aaf35df50094ff639febc23f20773 upstream.

Listing a directory while it is copied up causes a use-after-free of
the readdir cache.

A merge directory must never be iterated as a real upper directory:
that mode frees the cache in OVL_I(inode)->cache without looking at
its refcount, while files opened in merged mode still use it.
ovl_copy_up_workdir() publishes the upper dentry before it sets
OVL_WHITEOUTS, and ovl_dir_open() samples both without a lock, so an
open between the two stores finds the upper directory and takes it
for a real one.

With a delay between the two stores, an unprivileged process that
listed a directory during its copy-up saw only "." and "..", and its
next getdents freed the readdir cache of another descriptor.

Fix this by setting OVL_WHITEOUTS before ovl_inode_update(), so that
ovl_dir_reset() agrees with ovl_dir_open(), and by testing
OVL_TYPE_MERGE() of the path type in ovl_dir_open(), so that an open
that observes the upper dentry never iterates a merge dir as a real
dir, regardless of the order in which it observes the flag.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: test OVL_TYPE_MERGE() instead of smp_rmb() in ovl_dir_open()]
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
[ backport: context: the store is followed by the unlock: label, and the
  replaced line calls ovl_dir_is_real(file->f_path.dentry) ]

 fs/overlayfs/copy_up.c | 2 +-
 fs/overlayfs/readdir.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -717,8 +717,8 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (!c->metacopy)
 		ovl_set_upperdata(d_inode(c->dentry));
 	inode = d_inode(c->dentry);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -942,7 +942,8 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(file->f_path.dentry);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
backport
