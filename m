Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041B52D2D6;
	Fri, 11 Sep 2026 19:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789155829; cv=none; b=fp7dnJdOZiE5EVHKOKGMJH05XMXQj7BItAjJrJL2DeF6V7t5s6qUYYqyfPvRFiC7kgSky21aYU+ArCCsi7v+NofX0twAjCL5Pb1GBzk4DOoLqKP5tmg9C6NwcixBbpwk0mItTGcK39/oqJ5uJhiIOczvBcKua080dEebin2TWS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789155829; c=relaxed/simple;
	bh=ld++ZouXKmhgLvFKLRlsehvQOuaS/xsHQag5XgW1JFc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RcAeNXpspaxn9DzCReslEu56tOIN+CgTg9IF1ENFvgCnuMIdbHM7+xMPxbPwBAituCdMcNPZUwIyDmn9+setnojfewjAKLCbEEydCKJIvDHYF4d1YvDumf5YhrTSu4AVgrMW1I33WX3hhFvC+Gz6x7rHvPMoLP08j9ti4ZsFAmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=Q3PUqxq2; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="Q3PUqxq2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uCNOvQLgRYo6a+8MnfwQnMT9KvEJViKaPky9AvajdDQ=; b=Q3PUqxq2V2gOyh0tSziynou0HU
	jBtw5OGZa2lqURCEfAPmKjEOGz5aKXZbPsMaAu07/8dob6kuPUO2ec93i72qCbv2KDkUEy8elyTZo
	nU+NKdOpqVHX4toOaQcm0NQWpsy/MEztOC85n22aAT4muo23Kl+HwitEf2Q8p2mP9IcR6Ditp3p9F
	2pb+ZYo0HxFfI3J2e+SM3rMB9P7AgA/I5nxYwisWb1/RtmXwuJBpT8I3AC4JrADKTujeUhL4pQFIq
	SF7PQZmJflcu4NdgciUBoTSEpVWp3R6dHeGmhiSpG1Uoxjs9RLTk2IX47b2ym0zxLV5+CUMXFcFB3
	BT7Jkc5Q==;
Received: from [151.115.150.205] (port=51516 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x579g-00000004JAE-0N4q;
	Fri, 11 Sep 2026 21:43:24 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] ovl: disable index and nfs_export with different lower idmaps
Date: Fri, 11 Sep 2026 19:41:51 +0000
Message-ID: <20260911194201.1334086-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
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

Disable index and nfs_export when this layout is found. Both features
rely on persistent lower file handles, which cannot distinguish
same-superblock layers with different idmaps. Without them, OverlayFS
uses normal path lookup and keeps the layer chosen during lookup.

Fixes: bc70682a497c ("ovl: support idmapped layers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/overlayfs/super.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bd0a3f9039d2..00e1b9fccb4f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -944,6 +944,22 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	return true;
 }
 
+static bool ovl_lower_mnt_idmap_mismatch(struct ovl_fs *ofs,
+					 const struct path *path)
+{
+	unsigned int i;
+
+	for (i = 1; i < ofs->numlayer; i++) {
+		struct vfsmount *mnt = ofs->layers[i].mnt;
+
+		if (mnt->mnt_sb == path->mnt->mnt_sb &&
+		    mnt_idmap(mnt) != mnt_idmap(path->mnt))
+			return true;
+	}
+
+	return false;
+}
+
 /* Get a unique fsid for the layer */
 static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 {
@@ -956,8 +972,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	bool warn = false;
 
 	for (i = 0; i < ofs->numfs; i++) {
-		if (ofs->fs[i].sb == sb)
+		if (ofs->fs[i].sb == sb) {
+			if ((ofs->config.index || ofs->config.nfs_export) &&
+			    ovl_lower_mnt_idmap_mismatch(ofs, path)) {
+				ofs->config.index = false;
+				ofs->config.nfs_export = false;
+				pr_warn("different idmaps in same lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
+					path->dentry);
+			}
 			return i;
+		}
 	}
 
 	if (!ovl_lower_uuid_ok(ofs, uuid)) {
-- 
2.47.3

