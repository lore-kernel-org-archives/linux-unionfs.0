Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794297791;
	b=0cpaRkbAW1CYIQUabRwtlVQpNu07sGBOIwmam2mRDJOPevXAscDTzuaoqAzwB/4Mr2Sv
	 8OhPxPl/jmvw3PkCuez1m5cHyMRCNmNEE28rXJz9wssLxGC99U0MugoyBPsaHbTAFaNti
	 kXTaeBhrKC9plz6/CR0GcyX53HF9nBnirBYVxud3Qsh9tuAqFsBZKehEUfu+cpIQuEsf0
	 iPIxN7ANL+1NuBQrjMEFx4ZTzkBjqWfZgQ7Yyad7XJmB6+WJ31u7uLqKjg5TLCnxWOvZZ
	 dQ8KWbPFWaIQyBouimSUqtlj03n5Xo7GcHaiCxZUQe7/UI42zntwzAmZnS29barWN0w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794297791;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mX5/i1injlnaTPMAPhWRnzexRcofY5IQOLhosh/JZOI=;
	b=fAFvDtrGB52X13aW3tow7yOkxkZDf6rLKQqAQ9GXpbeaMSM1AhZuHBz4sD1LCex/+/mZ
	 VMka0So+hdY4SG18c4LQLrTTNwsvdFOapoyofe35ByruCkPWLH8VsK9zML4pe1WPK9nag
	 zeI2M7wgmiHE4sW41ow7I9oSafFHbBiH1A1NBGRW85gxnjfzyeol3WLX9BLj6w9xtrFiK
	 9bc4sa7vD3BHtyHpFveNc+D9DEgz4TB27xfTkbDygmDbF1X44SLMmx4r6K1Gw3zxHSiR7
	 lNBU97sB9cOfFtxxwctOQfh+98DRY9FZ/hYvQZATrcX70ptZw6r+l+de+HgX/hY7H7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2jtCqGa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2470606A31C;
	Tue, 10 Nov 2026 08:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n2jtCqGa
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794297790;
	b=fywA3eQrVdsIB3sSdlzxie+Z3hnlhn7z/QJ2f5rYmJGzLqaUyfsrt1QN8S90JM93o30h
	 QShxxW/IT2R7tlPuVbuCAzmqHyCk7lbl7Erj6HjgQNCa+koR7Jc7NzV7xaz96RRxVk07J
	 p1DHT6yKc2KvY7xyBBqb/ibbSPZyblO3s9oCkFW18pB8n1u1oGGui9AAf5vEu8plpYNYr
	 UhAVtJzmFgJOZ1seSyR894qCqhfQl3m2gS1cP1Y/fd3d09VQ8gxJlkWEXHEcivp9sTZ7D
	 QsYHAem0iLL9TbI8EboAQChYU0cV32XvbEi7ZOWCFNeX7peoMgGHy+K5iXSOL/FAp2g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794297790;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=mX5/i1injlnaTPMAPhWRnzexRcofY5IQOLhosh/JZOI=;
	b=OYB5q0hap+whf4p9eEHTAy4PViEaS5ykaX5vvkKS/YGCqmVyUd23xb8HG0HWcB7mNZ4p
	 3HHe8rWVU0MjU3omkjLy1SDFQdsyaXmUHcXyVDrKB+inIPWukCLcwWiaPi6nBsdnhFOtL
	 8j9jBIsbHFZdu43ykrneGKeE0CFWzPxeNzpzSSkJj5ZqdTup5Y0PeOlaIlHkD1WgFOsmF
	 HbfhlRbhI2OW0JFFLcgoWlWluoBeRiLDi1gRU+lPP6EZk1NykoWE/mgILmM/6TRTZjrVb
	 rj/mWp4gy5q14zKSe7NtJ0JrdAtiwB1GoX7H55a50krV/FQ560mN4qko1eNl8MM7BRw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 93CE71F0089F;
	Tue, 10 Nov 2026 08:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794297790;
	bh=mX5/i1injlnaTPMAPhWRnzexRcofY5IQOLhosh/JZOI=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=n2jtCqGa8E67eSQf1i1PRYRQtcamgYApWFeuw/i2s4czOfA3ZUW1xyC3jSfU2yjPh
	 ENbckQZMCy4seouZBU7oVKUAyD1UGhWLLxGcQgoJhyotZauiDJjZRAKTaFFdH0Fccz
	 yhcx4CIkya12SCrtQXX3DR9jkYma23FvKshcqWdJnsOQslUbB4oG2mbJCsZWp6KAQw
	 i+rIml/QOXfYJ+jec1LG8lBbnveJGVmsSw48QfR8V8ynVpG4Ty2BJaU2djoPiYKaiI
	 F3r91n8doIwKaYsureUX2zfMwnOJ8JBiNH3/Bk5dMisyT7genX3dvBjTjckvmIFEju
	 Cq023tvClHviw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0B29D48A12;
	Tue, 10 Nov 2026 08:03:09 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 10 Nov 2026 17:03:09 +0900
Subject: [PATCH] ovl: skip stale entries in impure dir iteration
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
Message-Id: <20261110-ovl-impure-stale-v1-1-1a4c2039e89d@samsung.com>
X-B4-Tracking: v=1; b=H4sIALzP8moC/x3MTQqAIBBA4avIrBtwNIq6SrSQmmqgH9GSILp70
 vJbvPdA5CAcoVUPBE4S5dgzqFAwLG6fGWXMBqNNRUQaj7SibP4KjPF0K6ObrC0NOd3UNeTMB57
 k/pdd/74faBG7j2IAAAA=
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: Hungyu Lin <dennylin0707@gmail.com>, linux-unionfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794297788; l=7510;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=2dnXtw2T+i/5B0PuW3RuxH9Poq9RI1r3zJVp+DkMk24=;
 b=NGXtsXteya3Zz5brWtYnnCqOGTGXgSZeMZ7fnIhrN/QbpFWKu6Bb2kZzx5Lfe/C5iU24e7kEh
 ZBxVFkXgefuCGdQl1XEu4CP2rF4xMc6iObyVSzCKakjwdtXDF14nhqF
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

ext4 returns the entry that did not fit in the previous getdents buffer
first in the next call, even after it was unlinked. The rebuilt impure
cache no longer has it. ovl_fill_real() then reports its upper inode
number. overlay/077 hits this.

Remember the entry that did not fit and look it up before the next
call. Skip it if it is gone, as commit 9011c2791e63 ("ovl: skip stale
entries in merge dir cache iteration") does for merge dirs.

Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Reported-by: Hungyu Lin <dennylin0707@gmail.com>
Closes: https://lore.kernel.org/linux-unionfs/CAGEkeHcg06kHshHQ=9U6Yrs_wm8W9H28o9bcC2Qh3fw3tANbWA@mail.gmail.com/
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
With the fstests change "overlay/077: check a stale entry in an impure
dir on any hash seed", overlay/077 fails on 3 of 3 random ext4 hash
seeds before and passes after, also with index=on,nfs_export=on. The
test checks both a removed and a recreated next entry. overlay/quick on
xfs passes.

Not covered: names on the same hash collision chain as the entry that
did not fit also come from the cached tree. A removed entry with origin
there is still listed with its upper inode number, as before this patch.
---
 fs/overlayfs/readdir.c | 120 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 117 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 4cd4af097e5c..0ebc4fe477b7 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -58,10 +58,25 @@ struct ovl_readdir_data {
 	bool in_xwhiteouts_dir;
 };
 
+/*
+ * An impure dir entry with origin that the caller of the previous getdents
+ * did not take. The real dir may return it first in the next call, even
+ * after it was removed or replaced.
+ */
+struct ovl_dir_next {
+	u64 version;		/* dir version when it was refused */
+	u64 real_ino;
+	u64 ino;		/* d_ino to report */
+	bool gone;		/* removed since, skip it */
+	int len;
+	char name[];
+};
+
 struct ovl_dir_file {
 	bool is_real;
 	bool is_upper;
 	struct ovl_dir_cache *cache;
+	struct ovl_dir_next *next;
 	struct list_head *cursor;
 	struct file *realfile;
 	struct file *upperfile;
@@ -413,6 +428,8 @@ static void ovl_dir_reset(struct file *file)
 		od->cache = NULL;
 		od->cursor = NULL;
 	}
+	kfree(od->next);
+	od->next = NULL;
 	is_real = ovl_dir_is_real(inode);
 	if (od->is_real != is_real) {
 		/* is_real can only become false when dir is copied up */
@@ -767,6 +784,10 @@ static struct ovl_dir_cache *ovl_cache_get_impure(struct file *file)
 struct ovl_readdir_translate {
 	struct dir_context *orig_ctx;
 	struct ovl_dir_cache *cache;
+	struct ovl_dir_next *next;		/* refused before */
+	struct ovl_cache_entry *refused;	/* refused in this call */
+	u64 refused_ino;			/* its d_ino from the real dir */
+	bool next_refused;
 	struct dir_context ctx;
 	u64 parent_ino;
 	int fsid;
@@ -781,13 +802,24 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct ovl_readdir_translate *rdt =
 		container_of(ctx, struct ovl_readdir_translate, ctx);
 	struct dir_context *orig_ctx = rdt->orig_ctx;
+	struct ovl_dir_next *next = rdt->next;
+	struct ovl_cache_entry *p = NULL;
+	u64 real_ino = ino;
+	bool is_next = false;
 	bool res;
 
-	if (rdt->parent_ino && name_is_dotdot(name, namelen)) {
+	if (next && next->real_ino == ino && next->len == namelen &&
+	    !memcmp(next->name, name, namelen)) {
+		/* Looked up before this call if the dir changed */
+		if (next->gone) {
+			rdt->next = NULL;
+			return true;
+		}
+		ino = next->ino;
+		is_next = true;
+	} else if (rdt->parent_ino && name_is_dotdot(name, namelen)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
-		struct ovl_cache_entry *p;
-
 		p = ovl_cache_entry_find(&rdt->cache->root, name, namelen);
 		if (p)
 			ino = p->ino;
@@ -798,10 +830,63 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 
 	res = orig_ctx->actor(orig_ctx, name, namelen, offset, ino, d_type);
 	ctx->count = orig_ctx->count;
+	if (!res) {
+		if (is_next) {
+			rdt->next_refused = true;
+		} else {
+			rdt->refused = p;
+			rdt->refused_ino = real_ino;
+		}
+	}
 
 	return res;
 }
 
+/*
+ * The dir changed since the previous call refused this entry. Look the name
+ * up as ovl_cache_update() does, and report what stat() would return now.
+ */
+static int ovl_dir_next_update(const struct path *path,
+			       struct ovl_dir_next *next)
+{
+	struct path statpath = *path;
+	struct dentry *this;
+	struct kstat stat;
+	int err = 0;
+
+	this = lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(next->name, next->len),
+			  path->dentry);
+	if (IS_ERR(this))
+		return PTR_ERR(this);
+	if (!this->d_inode) {
+		next->gone = true;
+	} else {
+		statpath.dentry = this;
+		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
+		if (!err)
+			next->ino = stat.ino;
+	}
+	dput(this);
+	return err;
+}
+
+static struct ovl_dir_next *ovl_dir_next_new(struct ovl_cache_entry *p,
+					     u64 real_ino, u64 version)
+{
+	struct ovl_dir_next *next;
+
+	next = kmalloc_flex(*next, name, p->len);
+	if (!next)
+		return NULL;
+	next->version = version;
+	next->real_ino = real_ino;
+	next->ino = p->ino;
+	next->gone = false;
+	next->len = p->len;
+	memcpy(next->name, p->name, p->len);
+	return next;
+}
+
 static bool ovl_is_impure_dir(struct file *file)
 {
 	struct ovl_dir_file *od = file->private_data;
@@ -863,9 +948,32 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 			return PTR_ERR(rdt.cache);
 	}
 
+	/* Even if no longer impure: od->next was its last origin entry */
+	if (od->next) {
+		u64 version = ovl_inode_version_get(d_inode(dir));
+
+		if (od->next->version != version) {
+			err = ovl_dir_next_update(&file->f_path, od->next);
+			if (err)
+				return err;
+			od->next->version = version;
+		}
+		rdt.next = od->next;
+	}
+
 	err = iterate_dir(od->realfile, &rdt.ctx);
 	ctx->pos = rdt.ctx.pos;
 
+	if (!rdt.next_refused) {
+		u64 version = ovl_inode_version_get(d_inode(dir));
+
+		kfree(od->next);
+		od->next = NULL;
+		if (rdt.refused)
+			od->next = ovl_dir_next_new(rdt.refused,
+						    rdt.refused_ino, version);
+	}
+
 	return err;
 }
 
@@ -908,6 +1016,7 @@ static int ovl_iterate_merged(struct file *file, struct dir_context *ctx)
 
 static bool ovl_need_adjust_d_ino(struct file *file)
 {
+	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *parent;
@@ -925,6 +1034,10 @@ static bool ovl_need_adjust_d_ino(struct file *file)
 	if (ovl_is_impure_dir(file))
 		return true;
 
+	/* An entry the previous call refused may still need adjusting */
+	if (od->next)
+		return true;
+
 	/* If parent is merge, then need to adjust d_ino for '..' */
 	parent = dget_parent(dentry);
 	type = ovl_path_type(parent);
@@ -1073,6 +1186,7 @@ static int ovl_dir_release(struct inode *inode, struct file *file)
 		ovl_cache_put(od, inode);
 		inode_unlock(inode);
 	}
+	kfree(od->next);
 	fput(od->realfile);
 	if (od->upperfile)
 		fput(od->upperfile);

---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20261110-ovl-impure-stale-af33421a0977

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


