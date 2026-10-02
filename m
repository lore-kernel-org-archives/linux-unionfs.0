Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AE44756C3
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 22:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980932; cv=none; b=G+RZMzBk3h/MhF+LWDXjraiAZjG8APRBj8BRArJrz0uQgTIgqdBL1VNouNrxyVVjrlOrhOOtfSpOhswb3sPl4zlFO3i9QUZMipgm386Cu8sspCDz5lJp8+eUu+IVA6QlkPEg4tlnYxhrXeobRGD6kJ2kQ4HrA3afC95VW4joAjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980932; c=relaxed/simple;
	bh=0TK3dTMPUNsFabEz5ay5O5ashd6OS3vO0eGcx6Ndtf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhD2W4rEAnjFop57oyw3WV+Bz+EMcBmB800n1pBUaNf4bHAV9ZqXag6T0h9OCEVf2d2LV9wtU1RO91C6th9nn0U3hi667tlbPW5wd2zA5SothYkJ4LapjnfGW3L/fNYkfG/pjuOBtB5fOiaOh5a4B6aEfJvWLmCPSrRXvHGPUOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=i4/n1/qe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=qVqBzOWa; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="i4/n1/qe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qVqBzOWa"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id C2AF31D0012C
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 18:42:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 02 Oct 2026 18:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790980929;
	 x=1791067329; bh=PX17ScPEtmbkLoqVOMVHQYu0inWG9h/yVostq3hDmWE=; b=
	i4/n1/qeDLQgVsie0JmPpmIC9nDeHwGWDFKJ6MH2BVCeBnqWhvEucc888czg1a6K
	y2Gy3s/XQMCNwhxgfq0MYDEtFMyDXNM/oSIImFkA4PBWk79NG6IeQCJrVJlQ9YMp
	nlf4PM5i0W2XAasNRwlM1E7Vq286IsqVEN5FCgiOCGWCTT/zMrAN4ZFAk0GBH+pH
	SarRvFX9PhfHoguNsfHG9l63J7nnzzhm5p0T8VwfSfgTz9LOx1SM2AHBe21Wcjvv
	AppNgzTDASuk3mmttiKzeaTOKXfbS/P4hYCcbEYMGO4e7nBdcQzbwRZN+EtwhZFY
	pXSu/fyMc9lFjg3a7thbfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790980929; x=1791067329; bh=P
	X17ScPEtmbkLoqVOMVHQYu0inWG9h/yVostq3hDmWE=; b=qVqBzOWa7B/m+OAYF
	aFSxxAAa7F/mRHIDrhov2dF12akjnqkD/hmjy/wqQGRJANDRosRQ7yZrPBMY0xjT
	ZUjbiI5w/+BNHib6v7AkWz7991YRFCEedHNJw1H3PJ09Sd3Kis+I1DibyXHLpwdU
	K3Oew2U+lA1T39B/HNpv41irWWxMjYMjEngRJQnpxzXtI6mb8k3y+nefJrvkC+8A
	YgWeB1Q6cezliLheqixwScYfjhbTMTDJ/I6PaL/6q3oRw6eqic74DTNAWj8tXg4Q
	ZNAy4UbV5+JbGLVHAls3+oXR3qVu00+eG2hRS1HC2uYBqRUjY6oxLGenRkSZU98k
	hMLdw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790980929; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm1:rsa-sha256:N/cp5Sd2LMkA1P/D+y7S9JT7QslN9ID3Fo+v1reCXT1FqFI
	/QTrXZ5G5zpbNAq0TfbuAUcu8aYFlUOEbQbhX1jWgi9/23pOK+Cs5Y0nmPOYH+FJ
	MtxUf2eFv+pNF6RjuI4KytzxBe4ZteU+IZNRWTQ5FSkSLIkqf8x6q7GvB/HporEK
	NG5sTcskyyto3FeasVWJDPUJ9CQ5Brd9rkQssBlXD5jC6Nt+NDmMsWo1uC5ydpi3
	D3Yccdtwv/CkOQfKRDdj3lSRrRjGxQJt+yIdNoIM3/8TXWO+IZimfoh0FUq7vE2b
	u0Ww3LPEyiceIPQdWsitag8ChAuFJlLB+/FcIzw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:OksWc8xxSwPpVPF9jcDPOg+GZiUbFUfafOtdBaI4T3E=:0TK3dTMPUNsFabEz5ay5O5ashd6OS3vO0eGcx6Ndtf8=;
X-ME-Sender: <xms:QTPAanh0oHlVVBTRmfRo5Ubwchta-_4Kv_a5CWbW-VKlaWODID7tgA>
    <xme:QTPAaiTtDcPxrqPji9I3Rz0aYp5z6ob_FK5-KS4ljTeDBVF3fGRM0h1Dz20YpNnQ_
    htPdaBDYqB-HWROQIBCR3scojEfR2QMx2znDFIUznEthqwCeYo>
X-ME-Received: <xmr:QTPAagaUelxMSojsJX-McPEbK5zjlJwTDWBhJCMaH0z8bVSYNtO6efN8irioP31yBbPH8WrjhnM09gcCB3XStenioMtjw1w>
X-ME-Proxy-Cause: dmFkZTEFkn2hFVOEVAMRWvKBRQN/Gfd8Plpd3ccH5Epvf9s+smEcZwzgJ58ij5TbXwmjlZ
    6AB9r+1ZMri8+sdzXoSXBDj23bhWHRxmI7Qf1XglenOHgBySsYy6/8B1QvtEOsuAsZgxR3
    cNy3lBVwj9h6AZV6JVc4Dn8bpIpYhuLxOozdnZqoLYN/qLNDMPurn1od2riRAJ0Gc0FkiZ
    gRocdIoAgzs6vlzjJApIqubA1FjvzDe+LOQyMSDsvv1X/ktR+uXBx/FHQ/Y8w7RKwNfpf8
    cZvD8KApK9oAtnNCZEJFh33qtFLiWwqnTTkn+OVtG6+DI7vsD73qB+4J/OmUeFftDZnQf/
    cpCAmUuJKD/FWRCrazOFOoOazuMDeKFBm0kGtSEcGEZA2FrfFFj6Q2iYgoDWet3docboM0
    WktcYYpVX7IszXdozY3oZ9aeCMZAVRktDDDYqrIHVQG4oTo4JM5pOiP3aAOIA/J42zLbzY
    KaqRem55PzSEWhxnhyKag7FtcRCbROWc+e/vvPCSmEyEdaTnE5xqqPztIj6VddoAyBlS5i
    mBJ9yzSsuR+HlXk53EH6/YEBaWMu48qq3mRxHXx4N9zlpfZVT88WJaEiB0/NY/sh3hslig
    tGIgxuFNCgbly++1br1VDbvd/wrU5qcqVVQ+QquatB4ETgcZzwAvLToFTGIw
X-ME-Proxy: <xmx:QTPAanQ9myFvyrXmGiPmEK96Yy0jWLVXgGyqxg9jMXeWTxJI1L2aKg>
    <xmx:QTPAan99Ctfh4QcCBj4_ROT5785mWLOgp21jJX8iEKZ6v8yoWAy7Ew>
    <xmx:QTPAavjzfIx79Ti7ZsZkCrWLxFAQNWnG6i_6CdYfEXPwmXzWyaHU6g>
    <xmx:QTPAagbqVdUhbYKAE1nJQPgqvLTLTdOG4jPnOjk4yMbukdAjVDOdAA>
    <xmx:QTPAalV0XYMUa7Vnl-vVsUhB4gSskymdvuNpejzgAAA_cil9rbWS84BP>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 18:42:06 -0400 (EDT)
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
Subject: [PATCH 3/3] ovl: provide private lockdep class for dentry->dep_map
Date: Sat,  3 Oct 2026 08:35:44 +1000
Message-ID: <20261002223746.3248726-4-neilb@ownmail.net>
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

Now that d_alloc_parallel() locking is tracked by lockdep, ovl needs to
take care that it doesn't trigger on deliberate recursion into
subordinate filesystems.  As ovl can stack over itself, the use
of the per-file_system_type d_lookup_key is not enough.

So provide a .d_init() function to update the map as it already done for
i_rwsem and ovl_inode.lock.

Reported-and-tested-by: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Link: https://lore.kernel.org/all/e3772a51-eabc-4c31-b73d-f3187bf1b3b2@intel.com/
Fixes: 59492f9991dc ("VFS: add lockdep monitoring of DCACHE_PAR_LOOKUP lock.")
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/overlayfs/inode.c     |  1 -
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/super.c     | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 401cb8c75520..bf40198c8b8a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -816,7 +816,6 @@ static const struct address_space_operations ovl_aops = {
  * - OVL_I(inode)->lock			(ovl_inode_lock[1])
  * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
  */
-#define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
 
 static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e0d8c6152e9f..64cbe4c4bd3e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -16,6 +16,8 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "overlayfs: " fmt
 
+#define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
+
 enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
 	__OVL_PATH_MERGE	= (1 << 1),
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e487597337e8..08147799e47c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -163,10 +163,28 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 	return ovl_dentry_revalidate_common(dentry, flags, true);
 }
 
+#ifdef CONFIG_LOCKDEP
+static int ovl_dentry_init(struct dentry *dentry)
+{
+	static struct lock_class_key ovl_d_lock_key[OVL_MAX_NESTING];
+	int depth = dentry->d_sb->s_stack_depth - 1;
+
+	if (WARN_ON_ONCE(depth < 0 || depth >= OVL_MAX_NESTING))
+		depth = 0;
+
+	lockdep_set_class(dentry, &ovl_d_lock_key[depth]);
+
+	return 0;
+}
+#else
+#define ovl_dentry_init NULL
+#endif
+
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_real = ovl_d_real,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
+	.d_init = ovl_dentry_init,
 };
 
 #if IS_ENABLED(CONFIG_UNICODE)
@@ -176,6 +194,7 @@ static const struct dentry_operations ovl_dentry_ci_operations = {
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 	.d_hash = generic_ci_d_hash,
 	.d_compare = generic_ci_d_compare,
+	.d_init = ovl_dentry_init,
 };
 #endif
 
-- 
2.50.0.107.gf914562f5916.dirty

