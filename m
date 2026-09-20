Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8C4371899;
	Sun, 20 Sep 2026 20:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789936394; cv=none; b=LFr/AH/hInymGX7fAbCPTr0d330S2i0rrT7XKfqn8JjI1zUv6hVtJdtBNAIrRSWmJ6I0dJjgRNgf+XbalEGpl3aOGV3Xfr3imzwbAykqE0xxnAB8o4MvHrezRxvOBhUkxGDajbuZTYZKasQdnNcZqD2NoZHjmV+1l6BIxtu6R5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789936394; c=relaxed/simple;
	bh=2HcUXrPWcY2MRUwFNoiyScoj6Z70eSofDPKZKwh5VAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=baNhn23uDjESc7lXh1Io8A/D0HVUqkDP+LnW/ONw9QlCQd4bszZpma7Qj8oKeHzZ2tGzM5VJS6qZM6TbqWr+KQRif/5/G6Ip/KWGvhnzIZO7mkGzCU0OSuAr+Zq218mG5JLBbXzXMNPSdF60z3AZdy9pqtOzi0PW6d1Vp7DuSMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=K7HGFt82; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="K7HGFt82"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=9nvjs5kid5o66sq+VhpnI+9MVB4yoXW2FEr6PNvo6lg=; b=K7HGFt82e38J
	SpjuqMkQJnAbAhCHIfbHmrcPorSOgM8fV61RHffBM8v/jTMYkCo85B0Xvf8ONqzXGYigNcid/+BwQ
	YFayXbjJB3jzF6FuRjpqA+Gu90MJ0ZGSvcl+ZGCMDukHXx4o9PK/bFu/mRg1WFwl4c8XL1NFQ3RDg
	JODEunchaGMCNeTJ1mUJnln8OypHr35EybAIT9x+1OaPKnAL07u7ltFk6HBijp7PCJ+5ZG95xnEYJ
	I+PL6QHUjS2bbo6EG3375ZmDmt959Kfza8Yolpoa2M7B2eNBgPOLN8Z7GuW+OvO8Sx6u1lz7RHBHX
	FEisu/dcA+PJr//h5OZawA==;
Received: from [151.115.150.205] (port=50122 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x8ODm-0000000BX7T-29hV;
	Sun, 20 Sep 2026 22:33:10 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2 1/3] ovl: disable nfs_export for same-sb lower layers with different idmaps
Date: Sun, 20 Sep 2026 20:32:38 +0000
Message-ID: <20260920203239.2876221-3-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Overlay file handles identify a backing filesystem, but not the lower
mount used to decode it. If lower layers share a superblock and use
different idmaps, a file handle can decode through the wrong layer and
initialize the overlay inode with the wrong owner.

Track the first lower idmap seen for each ovl_sb and disable nfs_export
when another lower layer on the same backing superblock uses a different
idmap. Keep index enabled: copy up starts from the overlay dentry selected
by lookup and does not need to decode a lower file handle through another
layer.

Fixes: bc70682a497c ("ovl: support idmapped layers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 28 +++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 80cad4ea96a3..2a6e12a0d4dd 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -24,6 +24,8 @@ struct ovl_config {
 struct ovl_sb {
 	struct super_block *sb;
 	dev_t pseudo_dev;
+	/* Idmap of the first lower layer on this fs */
+	struct mnt_idmap *lower_idmap;
 	/* Unusable (conflicting) uuid */
 	bool bad_uuid;
 	/* Used as a lower layer (but maybe also as upper) */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bd0a3f9039d2..8e78da420b75 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -944,6 +944,24 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	return true;
 }
 
+/*
+ * Lower file handles identify a lower fs, but not the mount whose idmap was
+ * used to decode them.  Remember the first lower idmap seen for each fs so
+ * decodable export handles can be disabled if another one appears.
+ */
+static bool ovl_lower_mnt_idmap_mismatch(struct ovl_sb *fs,
+					 const struct path *path)
+{
+	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
+
+	if (!fs->lower_idmap) {
+		fs->lower_idmap = idmap;
+		return false;
+	}
+
+	return fs->lower_idmap != idmap;
+}
+
 /* Get a unique fsid for the layer */
 static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 {
@@ -956,8 +974,15 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	bool warn = false;
 
 	for (i = 0; i < ofs->numfs; i++) {
-		if (ofs->fs[i].sb == sb)
+		if (ofs->fs[i].sb == sb) {
+			if (ofs->config.nfs_export &&
+			    ovl_lower_mnt_idmap_mismatch(&ofs->fs[i], path)) {
+				ofs->config.nfs_export = false;
+				pr_warn("different idmaps in same lower fs '%pd2', falling back to nfs_export=off.\n",
+					path->dentry);
+			}
 			return i;
+		}
 	}
 
 	if (!ovl_lower_uuid_ok(ofs, uuid)) {
@@ -987,6 +1012,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	ofs->fs[ofs->numfs].sb = sb;
 	ofs->fs[ofs->numfs].pseudo_dev = dev;
 	ofs->fs[ofs->numfs].bad_uuid = bad_uuid;
+	ovl_lower_mnt_idmap_mismatch(&ofs->fs[ofs->numfs], path);
 
 	return ofs->numfs++;
 }
-- 
2.47.3

