Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2773382EC;
	Sun, 20 Sep 2026 20:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789936393; cv=none; b=PvFun7RPOuwmELyQIeJD6zFsTANnYoo+oJZ1wFp+2qbgkYAC4MFR3swae7PvmYltaEaMpMRasivFbC/InA4efMRK3C4K4QvJTOF9Dv7VbtoddNuc7kgz0/hodSZLBuA82eop/PeDqMfgaWQ02ce7RV+TBwD7BXR9SXxBsAg5/Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789936393; c=relaxed/simple;
	bh=ebhJFbKx1unDYOFpjbKKtxUc7IIXtXV9PyIZU5jGCDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZbUXSvN1Kmldb0k4JLkIYuKp+mG/ONWpY+4i1fTDvWFYekhGyMdOEfYHO26U20G8gHV+vRMQp+jjUh3qEnbwK1I4+7U2cae2Ww0p92okyRaNTkiOhX0tgsNDBLjzI8zgZqjSupNEY/bGUI4PbGdRPxp7Vs4HDF8vBiw+dNydi6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=F7ZBnqN4; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="F7ZBnqN4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kY2O4V1lxKtETQT9i1ksfRwO/ZoGnpfYnF6PRl7/hDk=; b=F7ZBnqN4vtcEHzKbLjLWhoZ0JQ
	GOKWU+E2WQg8qFEtCYrD3+ZyVpe6nzS90t7HwHhB1lV3F49w7Sn478f92b8xQrNTnOR2D7cpri0lz
	Gs5G4pAHsLZiKkZE+P9qD80fFv+LFrNB4poJ/AvWjPbxUCLl8ddX7Nw5wAG02S8PS72FLn91cNB/c
	6oDjjbGcAcUfHr6FwSId4WbSf/zul9a5qbU2u0tw7jABpmSjmyfTlUUd3vq9hmT9GCkUlGK4PCjpq
	2rdKizHbrr6EWScwivrzPp0V+gkf5NzeRDo49CZouefyflFLlUSVhQkAj9M6iqNl/JVCVAcsQNFsi
	XH7chPAA==;
Received: from [151.115.150.205] (port=50122 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x8ODl-0000000BX7T-1qBD;
	Sun, 20 Sep 2026 22:33:09 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v2 0/3] ovl: disable nfs_export for mixed-idmap same-sb lower layers
Date: Sun, 20 Sep 2026 20:32:37 +0000
Message-ID: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
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

Amir, this v2 addresses your comments on v1.

I have split the v2 into 3 commits:

* 1/3 is the actual fix, where only nfs_export is disabled. It caches the
  first lower idmap in each ovl_sb to avoid rescanning all lower layers
  for every repeated superblock.

* 2/3 checks that the targeted layout indeed forces nfs_export=off
  and that decodable handle requests fail with EOPNOTSUPP.

* 3/3 keeps index=on,nfs_export=off and verifies copy up still preserves
  hardlinks and mapped ownership.

I have made this split so that you may decide to include 1 or 2 selftests.

I have reproduced the bug through nfsd with the help of AI. The reproducer
exports an overlay containing a mode 0600 uid 0 file, obtains a real NFSv3
handle, drops a client to uid/gid 1000, then replays the saved handle after
unmount, reclaim, and remount. On an unpatched kernel, the replay
initializes the overlay inode with uid 1000 and the client can read and
overwrite the file. TBH, I don't know whether this layout may actually
happen in production, but it looks like a weird feature.

Changes since v1:
- disable only nfs_export (keep index enabled),
- cache the first lower idmap in struct ovl_sb instead of rescanning,
- add separate selftests for handle rejection and index copy up.

v1: https://lore.kernel.org/all/20260911194201.1334086-2-Jeremy.Jean@oss.cyber.gouv.fr/ 

Jérémy Jean (3):
  ovl: disable nfs_export for same-sb lower layers with different idmaps
  selftests: overlayfs: reject handles for mixed lower idmaps
  selftests: overlayfs: keep index copy up with mixed lower idmaps

 fs/overlayfs/ovl_entry.h                      |   2 +
 fs/overlayfs/super.c                          |  28 ++-
 .../filesystems/overlayfs/idmapped_mounts.c   | 201 +++++++++++++++++-
 3 files changed, 226 insertions(+), 5 deletions(-)

-- 
2.47.3
