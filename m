Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF53400986
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 22:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980917; cv=none; b=V0k6Z8YoR6gzDkWqOfXNYpm8Okj9PaYANn0/kHFfzxLQUZtV9gtHva3z1AM/odUBM67SFT2yWjTTZ95VZCrUbKadm3fF+mIpSp+H1Zk9GcDliynyo/EFxUPtCp8YYtZ1uhQ+GDWcLAZr4Zg+3HEAQNs7dYHeQNGI25u18XZBacM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980917; c=relaxed/simple;
	bh=MUu9VIF5fmGHaA07YblY3g2FK626VpzV4bIlfoDEQVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chOyt8lYl46g6cqGd3oagXinWw3vCgp33stIfWEW8nywr9Ng0+Ru6Wd4sezqSwdlPNLje3/abD3IGAeEh/2WdnX+8MCysbcIuxXHtKBCMxqGKvIBwnAX0quO0RnsE9EmG2fm0g79IhOlVh6nHlGtaagJxQZOqUTmfJ0pHYna/MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=IB5O3pnb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=KcVgtzTi; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="IB5O3pnb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="KcVgtzTi"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfout.stl.internal (Postfix) with ESMTP id 8F4AF1D00127
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 18:41:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 02 Oct 2026 18:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790980915;
	 x=1791067315; bh=Vcqmb058OqzhAsRHRCIYnpQcETG6bqTvN1mN8HHc5TM=; b=
	IB5O3pnbe0mSDaIPwPQPent//atbpKv6VmHQoT8ISYd48dBYtx59CKK/Kig3QGWs
	WZeO9QHzQsKXfwhXQfWOotTk6BHTB4preqgaJX9IZ4OrE+tDDPOgTMJlCSLE/CZs
	+EShhAKOM5SU/fXQyUAJz2KptBxWilTcNHnwU6vZohZaRw5n+c99kSASqYBLv/Te
	9TQvFMgFXG70TQDQwkOdwkYYsZrL7zB3kgzZ4WmYOopnYnWijHqZyg1ZVhBrPOmy
	d5wddzgywu6QTHVrdf+oVih8L3wnb9Yf2wBU2n7ECKMXdJLxnp5xmcauyWLSfPnJ
	H1HmBjIwVv0PRlOqZvQopQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790980915; x=1791067315; bh=V
	cqmb058OqzhAsRHRCIYnpQcETG6bqTvN1mN8HHc5TM=; b=KcVgtzTisReFjQWdt
	33Rug7kRrah+N9dG7uZimi1qP1JcyKRfBCpeX5+bUGIU8SnIbf5z3IIXNlnwc8RQ
	TB1ogLB1BvgXiNri1ErDlqQ12NIlZVKIHpt//7MRpIFUgMii1RaVSTQ3V2hw46WS
	XbVa+lsnug/ZVk242cbeqd2DkDAfA3YF3GG+n9Jgk587hIkF2rxY+FIveiC7M0HI
	6vGxPZXZytHIpjNxMPJr2AbhwWjBd76nyANfgd9fgxoDA8vsLZmHm1pk8myUKbo8
	T0HQVCFuwekb15FGWi9BoiOxzUBn2brSczn6ixe9ulprv0L+y7ublbKgEP5C3vQx
	V/OrQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790980915; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm1:rsa-sha256:N8X3Z5+n1q4W6dGHpgjLWS+JZxCMfb43e5nIzgeImxIG8hU
	G5PWnpdlvpk4YTM6Z8T0EmmRahAws7quVzxJvWua2n+pghAYV0TkLUUcY+wJ+pue
	K0RNVPaHlplKslodKzbPQLfECdJA0m077ZeqnQvZTuL8TCKXHM0OYAGrIRB60eXW
	hgbI1aSKOVFu16HqfoVtyxn/8e5aIb5yxQZP1rv1MxrksqRnqfBK+3SQkmebIskW
	8Plml4mGrnk8BsYkdPKAqmJAC//7aUHgUCtAyGsFEMss7ohV+jcgs3kgKltfjxp+
	y0VwlVHQ3aghaGANqowHWn3oux8PGPfzT5qEPKw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:oiIKp6jJMTCqRIpUkD6HFhqS7isWijDZ4y+VLBHSGdk=:MUu9VIF5fmGHaA07YblY3g2FK626VpzV4bIlfoDEQVE=;
X-ME-Sender: <xms:MzPAau40c_IlYlvghXE0Vb87gkYyeWvzb22kIhmhBzO9eC2EQEVY-Q>
    <xme:MzPAamLje0567nIh-NGRjfPFc25Rqt_98MX0mECBoTj6kUKUatXBToXhJ5WYzAllv
    fOtjAVrbxFyxjSbl0CriXJvK9IJFK5mt5iicG6B8tvt3Bx2Pq0>
X-ME-Received: <xmr:MzPAamwgsEptBmvYGJP3Z0pIOdlx1OzdJmW_20Rp0YKaMa3mXWxQganV5cx-8j5g72XjH5kr32_gBt5qxM4hziM5qKP50CY>
X-ME-Proxy-Cause: dmFkZTFUOGBXKVssU6I16o6r5Z2JKHrVlv7zLZWuuQJYnDexZJVXXOL346pAM2J9f0pZgJ
    QZezgqJIlik/eCVlrIBn/eUj7tDjS57XcJYCSPPR4hS9Q0E2ewkmtwMrM7u7OKOVm2zES7
    hJdSYU8nPQ1lpSAoqXxKiAjiTlqR90BaN2I8l7pgy5obp4I5zjshCp+zJ4blaG3xX6LYzl
    Oo5w70Capbrm+JI3HQm2kfJfNvGm6KrdsWmjWr6QFoeXNeqBIgNmhthUah1T1eWSiuG8KW
    w0MSLWlQT4nOAN1cxgvKsS6xrHSeSblN5Ds+gbZIKFjWoGbXGKbKDW1P+hI2zmOIdJHfep
    9I2GkkiTgw3PhC70Y6z6vepVnw1iPp9HKpS6V7jv6oMEmJtKTfbpZqon/igHnpYMhkA51P
    PsRQQRvpy28rZrmk63pgV3eJWLegKVSkBFGGm3W7+k+4RukyNINEN4wBUmRG7PboRkONHJ
    PtqqNB3rqZN1F6jESJT6NrD6gPhqmFkdR66mW1digsrb2h665c2hnCkTWCi8TewXGmsg7M
    ckstITq2NqIh1dwxQ3UXVIFlK/pTpaKneLsrJjJ8k+bKiaJqfVFwLC9oErj8SYbOuHdXQn
    W5wN0W2IDsOA5ett3vE3VPnLoQ8uCtbutQnB9ONXAcuiKJjzNA5BdTxxjOwA
X-ME-Proxy: <xmx:MzPAauKok4xQY0uER2ZQuechzCuD6Rv3sodjpSsFyLV_o6eOwGbrHQ>
    <xmx:MzPAalUPvQCu2zYRxTa2cKQe3d8wnbIruFN2PG_6ll5m8FJv_UVxoA>
    <xmx:MzPAahZQ08GlbkiGnBg1-g5VxKnBDSGvrVGBq09Ac0NXfjJY_hN1Ow>
    <xmx:MzPAaswWhhFUi_2dC3pPMDeOgOYYOyEGYQ79H5e0bpDMvFFKbQjE-w>
    <xmx:MzPAapy1KIxI_h6Za1QjzXv0zo-Ho3xxtWe4_6L2n083KrKWzB9fpH_w>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 18:41:52 -0400 (EDT)
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
Subject: [PATCH 1/3] VFS: per-fs-type lockdep key for dentry in-lookup locking
Date: Sat,  3 Oct 2026 08:35:42 +1000
Message-ID: <20261002223746.3248726-2-neilb@ownmail.net>
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

Stacked file-systems might call d_alloc_parallel() in another
file-system while holding an in-lookup dentry is this filesystem.  In
order for lockdep not to report that, we give each file-system-type a
different lockdep key for in-lookup locking.

This matches what is already done for lockdep tracking of i_rwsem.

Fixes: 59492f9991dc ("VFS: add lockdep monitoring of DCACHE_PAR_LOOKUP lock.")
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/dcache.c        | 4 ++--
 include/linux/fs.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 83790c7a4dee..7581ee2981d1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1901,7 +1901,6 @@ EXPORT_SYMBOL(d_invalidate);
  
 static struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 {
-	static struct lock_class_key __lookup_key;
 	struct dentry *dentry;
 	char *dname;
 	int err;
@@ -1959,7 +1958,8 @@ static struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	dentry->waiters = NULL;
 	INIT_HLIST_NODE(&dentry->d_sib);
 
-	lockdep_init_map(&dentry->lookup_map, "DCACHE_PAR_LOOKUP", &__lookup_key, 0);
+	lockdep_init_map(&dentry->lookup_map, "DCACHE_PAR_LOOKUP",
+			 &sb->s_type->d_lookup_key, 0);
 
 	if (dentry->d_op && dentry->d_op->d_init) {
 		err = dentry->d_op->d_init(dentry);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d1e05e8ae6..0a5bdc71a4a4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2313,6 +2313,8 @@ struct file_system_type {
 	struct lock_class_key i_mutex_key;
 	struct lock_class_key invalidate_lock_key;
 	struct lock_class_key i_mutex_dir_key;
+
+	struct lock_class_key d_lookup_key;
 };
 
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)

base-commit: 3879f51857325da9bf3cfb073280257cd16ae067
-- 
2.50.0.107.gf914562f5916.dirty

