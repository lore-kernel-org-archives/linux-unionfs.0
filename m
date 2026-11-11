Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437006;
	b=ViVZuagAaaCisuaiIE1niCybSFCy0TPOx5ytzIFvZO61/YoyKjDqUoN8ukxCV33Rb6OU
	 cl8PnZthHwm51c/Zi6P7wtxatbCLJBwgGCw6UmcJLV1NYBBFI+XYsBreCa9Z1VcwUsXCy
	 ZGaekAGhWjzX3+ZbQ91P8C1JGXjTkRFJIiuUlzarjTyUlBdbR947uYZ7xETV9/ToxJeQW
	 nfei0hrjmX7DAD8UB21rmpVdZyB1htuTyhqeBHWEPPezjC4N+9KmZ1eH9MUVmU3JVadLi
	 7/B84qTdoXVS5ftvxHFF/N+Y4u1X2oQdGlaSVRuo2GQDMTFN1Sm5AMc/KLsepzAjJBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437006;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=KSlkRHCvVN87gHfPBsPdwNuXt7XhE32A2hZbO5QdPtQ=;
	b=0/URuMC4pX9TuiM1QxvtKI4PNjAwMx4wXKAIBiMs9bOqO77CZpJY4aWW8iiFNp2NXPrN
	 axoJZJJbvPF2Xf9cvHYIWLScTZmBLgGhuNKDiGPkDW6lgXd38t19AtkjWn/aHC9TUmDpP
	 Av1MLJFc4coaccMw+6vm3V2c1+cfMxLHydpkBmft/EpNiAQUVNfRzPYd4v4bYc8lYrDNE
	 xvtialc5MGCRhcFwYVZTEbvx/vOxuGkgOak0L66L9fgnR32aF9e+PIu7A5XpbUpyzdl3v
	 XM0CWr0Nim9fJOKZMU66R1lEdiFfp8Cj7B19YbEDkBvtAREmKgHvW9Nh2L4bsLBMO0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=pdUwxfmm;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB50360A6F70;
	Wed, 11 Nov 2026 22:43:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB50360A6F70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=pdUwxfmm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Sender:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References;
	bh=KSlkRHCvVN87gHfPBsPdwNuXt7XhE32A2hZbO5QdPtQ=; b=pdUwxfmmoHuTw/duCN+n5zT5E7
	fSIUfPsmh5g7TlZV3+11krvHsGCl/Qx9iLEjtGRocERGp2OgTUSpfn8Kh0rU+OBZwlBCY7n1NSqfV
	bc+fLP5h9xWbT6eGhNSndt+/VaealT+chIWRQv7Ggi2oIUfBhaLLUucpnhKFljBdrqVXRj2EYv2zD
	o0zxEXHv/XzNjK2fDRcnhr4M0r2hghl5j7BSVsT0vC+hat2+u5Knn/HdEqTjYoS6GWGgvFOngiu3n
	dC6sqK5fLVMvh5Zdcz+qy3xNDjfUcBN7CnlkAubiq3s03QnDrQqiFH3unrdVy/KhGIqN89dqMYeUO
	Oy7N/kuQ==;
Received: from [151.115.150.205] (port=36454 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xRH2F-0000000DOpX-06ZU;
	Wed, 11 Nov 2026 23:43:18 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v3 0/2] ovl: reject different lower idmaps on same fs
Date: Wed, 11 Nov 2026 22:42:25 +0000
Message-ID: <20261111224227.2496049-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
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

Lower file handles identify a lower fs, but not the mount whose idmap
was used to decode them. Remember the first lower idmap seen for each
fs and fail the mount if another one appears.

Changes since v2:
- On a request by Christian Brauner, fail the mount instead of
  disabling lower file handle decoding.
- Check the idmap on the private lower clone.
- Replace the old regression tests with one mount setup test.

Jérémy Jean (2):
  ovl: reject different lower idmaps on the same fs
  selftests: overlayfs: reject different lower idmaps on same fs

 fs/overlayfs/ovl_entry.h                      |  2 +
 fs/overlayfs/super.c                          | 15 +++++++
 .../filesystems/overlayfs/idmapped_mounts.c   | 43 +++++++++++++++++++
 3 files changed, 60 insertions(+)
-- 
2.47.3

