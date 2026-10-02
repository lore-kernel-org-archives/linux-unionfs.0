Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D40B469826
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 22:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980925; cv=none; b=YTJbymv0LCRz5kqdCOTVvJhP4naY4zZJvJcsiscOyLrnxEbnoaAehPv3Ehp1CfxD11mcFB/wMe2kzCDAqeGgh7j4fZzQbu0MnT90D81xusLeBN36VAhh8y9XaNaEf4TtDZw6513UVyCflgFCHp9M7Epsr4xa67wLtaRJzP67nHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980925; c=relaxed/simple;
	bh=mDxQiQ0SpS6T4+uN8YHFeBFD3Y5KhPQr9YdSSOWkPBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i//Y9VJs1Y2SMyqw0gF04XKUsxLLFv87rSkaiRc0UbqQ1ENJBEH/VqfCp/CW2hxsx9G7Uy0CsB9Ra5tnGrBURTixIx2sQEq7RqCyGYkW4YLo+6tCN+ha8YvOOi3gWqcrfMQdBOvVQ4JAiDd3oqcq5cZ7ZrMrcj4Hy7md3q5bwOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=VpEJ2jZd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bcz9XOsM; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="VpEJ2jZd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bcz9XOsM"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id D1E871D00123
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 18:42:02 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 02 Oct 2026 18:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790980922;
	 x=1791067322; bh=Og9lzW2h3ae0a/IsdQHkqa+cJTxeh5pu4duD+ukSenM=; b=
	VpEJ2jZd+9m9xP1kZA29m3j5BZdxTbumO0dVIhoVnH9wDFp5rJn+DAsYtBgXAX3K
	DJJHQU/zcCgkeq0yP5uPeD9EbnpKLnxKJ2OvbyU9zpoUMSJAHQWxABlf0LEgMoPE
	lDx/zW7c06tXAho0i0HatwjuIYtVcu4tQjL1sar3dk62T3zSxmRDnFfwRvzXkLob
	Z+Etczp1CLsDMZW0wEms0YjoQjkUJWKwgJH5kXVIXKdowMrgtrtZgNl6Znb7iU32
	TCnFq4WNURVq5gg/zeegEqWt4UB/PJwdPjGY2p8mn6A/M+uqCQtOpzS1b3PgXXLa
	wWKsdnG8B8e0iTUcD27L6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790980922; x=1791067322; bh=O
	g9lzW2h3ae0a/IsdQHkqa+cJTxeh5pu4duD+ukSenM=; b=bcz9XOsMZ3omvpvB0
	Z+X91w1on7IRux7eTlxziJJbJKH5Nwg4/ilJIEIAUfi+tgDSlUxD7WF+mFwJGDBM
	BoQKZFJ5uU89jIoy7anHNm1gYEiiJMbTVbtS4PLWEWEwaTVcrtI0htWXCXCBgacx
	12kdw1ST1qpPfhTvP4HCoSXZijs/AnWOkrzF68+TE6zmrX/BkML+StVP+d2SGKc/
	/fx9LrglgfxaGyxKP1GlBOzRYSVyYSSTHWYRNu27W/sV2r4rhCB+7eW5iPtH2qD5
	8VtF00nNU1LarR0FTgT91u9t3fn2Fca0Tx/WGcUnz9jXVrZjaeNjwIQrjdtl7gRZ
	wK0GQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790980922; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm1:rsa-sha256:LTGXFo6ajX6dQnEAwa5icNpARb05lQ1YzXbM0JHpav1trcW
	zPVJ4D1ZHaYxvfMjppxZRWnSAiszwWj/1fgSnTBwqlQ7dRG1QzqY73rzslKBu4VX
	tqbKzxbiHHX1E4njjcw70yQKkEtHI5vxfAOfeXFAPL2aUDTovrBbFRHqkTSDDv5g
	wH+xJiepVGpw7Z6hicEkO42AgkPks7ZQMqVxSQ80PexzITXRHiOP4geIw5nWlUD5
	AIQxbcy4fj6o2Ty1+94OmFi5B7tLmFZqKC+LUhgTNV2zlEsInm/49Fu+5qGaMXVU
	a3/Hg6GBv9Oo9cohsNFLhF3HlPUfSPiNd5wJdgg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:gnMSa2oJ5Th1pS6GQFpXvKNVo5/1LTVuXFgg76SlY24=:mDxQiQ0SpS6T4+uN8YHFeBFD3Y5KhPQr9YdSSOWkPBc=;
X-ME-Sender: <xms:OjPAav5fFIywhw-IGiHqsZ97sCTqFJcM6rPdIjXLYHLNvLwCIt516w>
    <xme:OjPAajKZixd4ldd7BrNmaZErBzb7tOxA49COMtJA4rBAMCNprBl46qk-AibgDF9ut
    cXGL6XLGW8nomPp9i3-dzb6FpNpyvlWxsl2Dws2l0nFVdDWDBU>
X-ME-Received: <xmr:OjPAavxpef_ONa7fr3QflFNFDrBnJ1mgOxoh04bQVO7fJ9j5RaJ7WODKzH27WVRRPy74qyCTSg5FOR36Q-eMCZ4D0pCo7cA>
X-ME-Proxy-Cause: dmFkZTFUOGBXKVssU6I16o6r5Z2JKHrVlv7zLZWuuQJYnDexZJVXXOL346pAM2J9f0pZgJ
    QZezgqJIlik/eCVlrIBn/eUj7tDjS57XcJYCSPPR4hS9Q0E2ewkmtwMrM7u7OKOVm2zES7
    hJdSYU8nPQ1lpSAoqXxKiAjiTlqR90BaN2I8l7pgy5obp4I5zjshCp+zJ4blaG3xX6LYzl
    Oo5w70Capbrm+JI3HQm2kfJfNvGm6KrdsWmjWr6QFoeXNeqBIgNmhthUah1T1eWSiuG8KW
    w0MSLWlQT4nOAN1cxgvKsS6xrHSeSblN5Ds+gbZIKFjWoGbXGKbKDW1P+hI2zmOIdJHfru
    J8/Obnbso392JdKQtLUK0JThn4nRs2f9U+50om/Q8PygHb52IYcaiKOMAKsRNfyz9O+zRU
    Etrd0bXHUmbtF9mHayNW6wpwx7eynni4pJgVwbFzykq5e+pTxZcXVLVZR3hJXVuLVdjk0y
    o48fpoXIHIjqq9Gub928bb1ZAQFPBZOf7ojB3x7Kpkk6y1dcq3gGVTSpDtI/Kp1vki0+KM
    mbnvmkadbz4ri7937FvuIYav5XXG16pQOyPmBHRRzu5vxasqcn1g7rGvYXYYS4hdGx/5QO
    qCiKL14U65AhOKjj2fbMCeigY8Ts/+M7MxMA/mfV5k5o1LMzZNz7I7fAtI4g
X-ME-Proxy: <xmx:OjPAajJbHw9LutMudLEawYshcq1_tmfVwdKshvUP4WNTogPclP3nCg>
    <xmx:OjPAamXbK9qq3Bt5uWyuNhXrUTMrmR25fx9ynJy_hG2HsAVc9oVuUA>
    <xmx:OjPAauaSFuCDm_t5jJQyQVrBXG9hQg5Jr-s56bZ6irlw6kmPtQ675w>
    <xmx:OjPAalxp8FmYjwcTaG-eSLkVu06qgDNqteS1VmFCzq1dJjrk-jzDuA>
    <xmx:OjPAamsXNO7kcWuPS6sNVfVNw5mCN2yJeDzMHrZgIs6Vfxv74W69siAY>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 18:41:59 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 2/3] VFS: rename lookup_map to dep_map
Date: Sat,  3 Oct 2026 08:35:43 +1000
Message-ID: <20261002223746.3248726-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20261002223746.3248726-1-neilb@ownmail.net>
References: <20261002223746.3248726-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

lockdep has a number of macros which assume the lockdep_map is in a
field called "dep_map".  If dentry.lookup_map is renamed to dep_map
these macros can be used.

In this patch we can now use might_lock().  In future
lockdep_set_class() will be used.

Fixes: 59492f9991dc ("VFS: add lockdep monitoring of DCACHE_PAR_LOOKUP lock.")
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/dcache.c            | 15 +++++++--------
 include/linux/dcache.h |  6 +++---
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7581ee2981d1..c8116c5805c0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1958,7 +1958,7 @@ static struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	dentry->waiters = NULL;
 	INIT_HLIST_NODE(&dentry->d_sib);
 
-	lockdep_init_map(&dentry->lookup_map, "DCACHE_PAR_LOOKUP",
+	lockdep_init_map(&dentry->dep_map, "DCACHE_PAR_LOOKUP",
 			 &sb->s_type->d_lookup_key, 0);
 
 	if (dentry->d_op && dentry->d_op->d_init) {
@@ -2040,7 +2040,7 @@ struct dentry *d_duplicate(struct dentry *dentry)
 		return ERR_PTR(-ENOMEM);
 
 	new->d_flags |= DCACHE_PAR_LOOKUP;
-	lock_map_acquire_try(&new->lookup_map);
+	lock_map_acquire_try(&new->dep_map);
 	spin_lock(&parent->d_lock);
 	new->d_parent = dget_dlock(parent);
 	hlist_add_head(&new->d_sib, &parent->d_children);
@@ -2806,12 +2806,11 @@ static void d_wait_lookup(struct dentry *dentry)
 {
 	if (likely(d_in_lookup(dentry))) {
 		/*
-		 * Tell lockdep we will wait for the lookup lock, after
-		 * dropping ->d_lock, but won't actually take it.
+		 * Tell lockdep we may wait for the lookup lock, after
+		 * dropping ->d_lock.
 		 */
 		spin_release(&dentry->d_lock.dep_map, _THIS_IP_);
-		lock_map_acquire(&dentry->lookup_map);
-		lock_map_release(&dentry->lookup_map);
+		might_lock(dentry);
 		spin_acquire(&dentry->d_lock.dep_map, 0, 1, _THIS_IP_);
 
 		dentry->d_flags |= DCACHE_LOOKUP_WAITERS;
@@ -2936,7 +2935,7 @@ struct dentry *__d_alloc_parallel(struct dentry *parent,
 	}
 	hlist_bl_add_head(&new->d_in_lookup_hash, b);
 	hlist_bl_unlock(b);
-	lock_map_acquire_try(&new->lookup_map);
+	lock_map_acquire_try(&new->dep_map);
 	return new;
 mismatch:
 	spin_unlock(&dentry->d_lock);
@@ -3035,7 +3034,7 @@ static void __d_lookup_unhash(struct dentry *dentry)
 	b = in_lookup_hash(dentry->d_parent, dentry->d_name.hash);
 	hlist_bl_lock(b);
 	dentry->d_flags &= ~DCACHE_PAR_LOOKUP;
-	lock_map_release(&dentry->lookup_map);
+	lock_map_release(&dentry->dep_map);
 	__hlist_bl_del(&dentry->d_in_lookup_hash);
 	hlist_bl_unlock(b);
 	dentry->waiters = NULL;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index adf239f8205f..796282817181 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -117,7 +117,7 @@ struct dentry {
 					 */
 
 	/* lockdep tracking of DCACHE_PAR_LOOKUP locks */
-	struct lockdep_map		lookup_map;
+	struct lockdep_map		dep_map;
 	struct list_head d_lru;		/* LRU list */
 	struct hlist_node d_sib;	/* child of parent list */
 	struct hlist_head d_children;	/* our children */
@@ -571,7 +571,7 @@ unsigned long vfs_pressure_ratio(unsigned long val);
 static inline void d_lookup_release(struct dentry *dentry)
 {
 	if (d_in_lookup(dentry))
-		lock_map_release(&dentry->lookup_map);
+		lock_map_release(&dentry->dep_map);
 }
 
 /**
@@ -585,7 +585,7 @@ static inline void d_lookup_release(struct dentry *dentry)
 static inline void d_lookup_acquire(struct dentry *dentry)
 {
 	if (d_in_lookup(dentry))
-		lock_map_acquire_try(&dentry->lookup_map);
+		lock_map_acquire_try(&dentry->dep_map);
 }
 
 /**
-- 
2.50.0.107.gf914562f5916.dirty

