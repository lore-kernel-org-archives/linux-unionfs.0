Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437007;
	b=Wel6nTF98WC5SFKO4x9XnOTi77anKqcQKcAsgvE4fhjVl8fle6TXAet/t+nZUB57g5yO
	 lQbPzv29jf9L2haKvOg3lFiuEYOByDSosCbHocQulWj6QWrjH0vBfPoVAi8k+JctwIcgM
	 +2mbIUFR2tqT5Ex3pn1xNQjjV3TXcuKJKlhiIljV/AhNc8pszAX712RV9Vv7LO2ZMRQCr
	 CyU8vmuW0P66nq6IXG+P4KGjJh6L0O49A0PMGV1htWWaI6/g2GRLbBxv2vmWQx/bLcpWA
	 tBJh9oviz8LfoOvgTbmwHPDWVlmej2mB99jANJIAJKAtUJM8gaMVQvhhbuYsyK5JI6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437007;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=dgBET2RSaOCToLo8RlWIwCQekDtOOAs/qg6zrwxRE/g=;
	b=WDKt3Wa2dTCbaNNG0zSZxAXR3JCCjJhoY9TEIifakI9Qebnxdjb+s8u2kmTunG2utIub
	 tTkWmoh+XkrP8GcFf4Goc6CeS19go+WijSOoyH9RckUQ3x9fMSIwFwJxMuVetYygnwW4O
	 s9I6gOiBEao2ZQtVy7yRiqUQ5Dt46CnzaLZQrWCoi8dmZvbayPLNP0XdyW+o/reK5C1Tg
	 bQKuAcT0ARxLccUC3jxtke7slfc/rXHgjgyo3ccX+Snfbjv0Ro17uQNPzupDsUXkT7dXC
	 sz6VDXtfufnjtl+J51MCPF3mCXAmJ+oP/L7g9Ie5xULS/1ddFWr/mI1hZ1H+STg4W7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=J5VR5RVm;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F220E606AED7;
	Wed, 11 Nov 2026 22:43:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F220E606AED7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=J5VR5RVm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=dgBET2RSaOCToLo8RlWIwCQekDtOOAs/qg6zrwxRE/g=; b=J5VR5RVmq2+ilOpj/wkcyab75v
	KJlNT/QN/vNP1Sskyh84hU+lGFhJzKLDLW8Cwd+UrK+8dfvKKqdB4s/OSmLl+7Y+SpxKzauV5FREX
	eRPGlCMaasKpkkBCcAhv7GBP8SiprbmMxBwmOUleOJafj+4X2gjBCuUg2vck+pFLINY+sv7R1Qp2k
	FRoxUih9SIYeCGbv+Cw/EdGcHjvhQl0n1Rn+WMhR9zGPTA00XhQ74eGQlZp5Gl13nLnxR7SocPgkj
	2AwUtv7q0sqzmIx4ojE4yDbcJyrONWJ8iL9Us+wdlfviw4voX+vn6Xs9x6TwJD6DbRVVeizWWlCHV
	rGXn/QIg==;
Received: from [151.115.150.205] (port=36454 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xRH2G-0000000DOpX-32cG;
	Wed, 11 Nov 2026 23:43:19 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/2] ovl: reject different lower idmaps on the same fs
Date: Wed, 11 Nov 2026 22:42:26 +0000
Message-ID: <20261111224227.2496049-3-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111224227.2496049-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261111224227.2496049-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
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
different idmaps, a handle can decode through the wrong layer.

Record the first idmap on a private lower clone for each backing
filesystem. Fail if another clone has a different idmap. Comparing
the private clones prevents mount_setattr() from changing the checked
state. Distinct idmap objects are treated as ambiguous.

Fixes: bc70682a497c ("ovl: support idmapped layers")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ac07e8769f9b..5b2f1b930daa 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -24,6 +24,8 @@ struct ovl_config {
 struct ovl_sb {
 	struct super_block *sb;
 	dev_t pseudo_dev;
+	/* Idmap of the first lower layer on this fs */
+	const struct mnt_idmap *lower_idmap;
 	/* Unusable (conflicting) uuid */
 	bool bad_uuid;
 	/* Used as a lower layer (but maybe also as upper) */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 8bc970748b96..40eb8428a718 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1141,6 +1141,21 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 			return err;
 		}
 
+		if (i < nr_merged_lower) {
+			const struct mnt_idmap *idmap = mnt_idmap(mnt);
+			struct ovl_sb *fs = &ofs->fs[fsid];
+
+			if (!fs->lower_idmap)
+				fs->lower_idmap = idmap;
+			if (fs->lower_idmap != idmap) {
+				pr_err("lower layer '%pd2' conflicts with idmap of another layer on the same fs\n",
+				       l->path.dentry);
+				iput(trap);
+				kern_unmount(mnt);
+				return -EINVAL;
+			}
+		}
+
 		/*
 		 * Make lower layers R/O.  That way fchmod/fchown on lower file
 		 * will fail instead of modifying lower fs.
-- 
2.47.3

