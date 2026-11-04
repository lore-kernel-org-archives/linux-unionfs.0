Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817924;
	b=FETk5xgbqcCJw7LlAYH9nWgaiEp30MCD1Z/VRWKVkG0Bvcic3z7iP1uuA/LfR32nDuAm
	 9QcLFIveSHxlUOt0D/XDN/29dkMtPfM5K1V0dzujWSh1SRenqR0cqa4IXBwtar9UodVw4
	 pYBl9OH5BiA6QYVPr741y1mMpNeJOiFnw4FtxcZNv7jhbGKy4kBdKJFRFuxeS1nKlQ3wa
	 rS7zKNGK9PuUtr8SUX7zDrNMhxD5Pr6RoYUaZ+N6RsSwVzy16KLUNxVJA2Zoyfdh3Sd6N
	 TDEXrSq1GadnX/gxRZqqhrudc64bBKf55432RPrUQlZPU4dzRLBSigkYSH8jAKHvZ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817924;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wxCuP/mVVd3/tUFeKBS42VApE63zISWYoolf3I3TANY=;
	b=FSqmQpa6itJ7Y1bCP27cXlSUXn1/8ftxehg3+chXVkPMuqezBj8seik3F4qUmI8RhdRR
	 uelQXhXZVfOvllndWs1dzOD53DOql+hd8hdiIX0BK4pedxcJnpVc8CmxG/1iUZqEIbtRz
	 PPZ83nLa/cw6ySj/AbjVjGp7D3WcUtk1KgKC8JzhFrk8VL9Xo51c0EvqGkBWDy1OKb7vk
	 Co2tPW+ay6L9Tx7Oc+pE84z3v1509MHQg8fp6HwLaCcLN7EMBZ8H16JAu2yH0dtmxRXhG
	 J6rTtLEfUGhtAEg1oZAJYYpz66qsO/ox4t5yqHFx8/XxqqrdcUuUMl1/meIUSeVl9gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="m/1zcr2I";
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24062606A328
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:45:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24062606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m/1zcr2I
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so9652055e9.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817922; x=1794422722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wxCuP/mVVd3/tUFeKBS42VApE63zISWYoolf3I3TANY=;
        b=m/1zcr2IWs467uG8vqx5CkIonSgiCX9rqWz14Hokoikyly0/X5UtzpVipUGD6QaMzS
         hPtP5v6PNW5WL5rqiK8GhRBZxBnILTY0NzqiAQKv1CWbJ8CBlhxzfjS/3g1u2h3nPdtb
         dqtrn0EYDet1bBEpTv/sP2bFHGcrD4mC8ZARBJbRaGKwJudeolbhzUoe98cznPBb2LRn
         dax7Ipof/m0FEViRZsdMKWFs4XocXbmfhPp97BYMnlTkxk7iRkTnnp+VznG+6axFmNRO
         c+OyB/RHjukcTkqer957GlOzjbufzSaj/53QOqMdJF25wm9BIYMBV/Axp84xPryoJDEI
         lhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817922; x=1794422722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wxCuP/mVVd3/tUFeKBS42VApE63zISWYoolf3I3TANY=;
        b=Iu8qtkOO+s5G6fTDMvIsHILTcfKhdNL8o8TzjEVyrDHQu5IjgpuB1g5hkfUf78liqu
         H7agYHodjwwVVxhFBd90r2Jmxgtq5mXTKjwXs27Yl0OZjddUFPJebJ0Qs7+dB6zD2ePw
         qyzSx4WRQOCUv6OQhXhPrNJmNyJlkV5HEgtNmu2zQGZax0Q8w8vGCrJ+Gv12nJlA2jCV
         adJAjlyKZXU00DU8W93KSRluvLsS6UjV8Wf7XctJ3MZwBSEADM+IDBbkhqmdY8sN800Q
         VpslZmdOVuLtRqHwQUweioCfzPH6wBPJihyTvFem8euhov8RYQd6pCP/fXTA5WwwwUB/
         SjaA==
X-Forwarded-Encrypted: i=1; AKwUvBwQSknYKXplLWdZGzZ26MulDu8vHHcp4N7+FC+QiyNXouElTuM/yeM8b0Nff1FeeVKwqsPpDf6aEmNrPWT3@vger.kernel.org
X-Gm-Message-State: APuU4Z9asSWWCnFQPb6rRHRp2qdJKsYaLk9PlXYBLHU1eo0Aoxnca74W
	I07wjNJdIo4OXKKRJl2j2qugg471ep9Hm5D85oyyOjUY7ggq3uS9guiI
X-Gm-Gg: AYBFou1JUQh+sVvpUZX89tJvl7cgY5ihdzYV47xQkPa9HklGYrNaQtUmPUdM6Iocnu3
	BGoSWfxGqwtPXJnFrow1zYXw9p0h6C9U1ksxwFBOxTKsAKKT0DfXKZ5+xWVMWkiVezVsxWVH0Um
	UmzXP8FuKKb6Ln5iWvxs63zZu4RjDXeo4mEL6SXg7DmRD8PtBeMMfq8vw0A6Uwhp5XSfeuO3j9+
	TXm19I8y+ENPlY52SLP8x6B+n2P1Usgth5929hWVvMxzqpJDRJZegiKYPpve4OEY31MoH6b4DdR
	JbWTaxEY6GBXGrDqtrrUv+5/6Gu5wTCzMiWxjJnygT5HoVmlV7MgN0vOUspuJrgFonZ+jasHDGk
	leSbsIbeyOFkrI2CNbjHFX23/9f8YSb5GKH9TRIIxFt3FrsjFVB9nXmZKoTwrKJUEh78dE5DtsT
	4/N2rqhTU8uPF0XThsjZqWR94f2zhlUzfuiQ2aTfSFJAtLXCRl57xhf+75sEYbwJOyd1v/nfN23
	bu44Op24aDjXZ2iB1I31HnqU28Pc2e2AbIDxeXnJjfJ4i7n1L7Jx+BjMyo/ZuIHCiXW8NTPw8kf
	10+CeAMhEYrvwLdle7S9TVufKQDuCWtxegoc++sU+o7RJm5Y+6LlZWZtQMWESHSSwgQZkcqmH2a
	KJXqFkhyXT/Li
X-Received: by 2002:a05:600c:6095:b0:4a3:7344:13b5 with SMTP id 5b1f17b1804b1-4ac182dcb98mr337976365e9.16.1793817922428;
        Wed, 04 Nov 2026 10:45:22 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56ef2e968sm4420255e9.8.2026.11.04.10.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:45:21 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 2/3] ovl: hold a reference on the parent in readdir
Date: Wed,  4 Nov 2026 19:45:15 +0100
Message-ID: <20261104184517.3630089-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104184517.3630089-1-amir73il@gmail.com>
References: <20261104184517.3630089-1-amir73il@gmail.com>
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
@@ -572,8 +572,8 @@ static int ovl_cache_update(const struct path *path, struct ovl_cache_entry *p,
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
@@ -802,6 +802,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	struct dentry *dir = file->f_path.dentry;
 	struct ovl_fs *ofs = OVL_FS(dir->d_sb);
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.ctx.count = ctx->count,
@@ -813,18 +814,26 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
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
@@ -852,16 +861,19 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
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
