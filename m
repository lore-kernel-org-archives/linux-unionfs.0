Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794437007;
	b=qb97kRSymDarop9f3SGz+WyIz7z4fH49tAQDTAqgBgekKJUIxJtdRs8YnKG2E3VXIWAS
	 fB4RanxUNa+tuz03w9niZcIjlsQ5eUDvvKcZc15EyiWE0EmuxaxFWv0kpdgVO2UupIYPl
	 DpmzCMuPI+sKjglFkZTrWmewwa46Qgl1IFU/bR/FVA+Ax1d+BtDhEUJUk6EBfSV3OtEsE
	 /C8UR1WsH1xRExkIxGOU9fNpC90xlyjIGl6S4D9FchdVBhIni9jCqWCNzyX0GsJrj/fVF
	 xYFegqJQd9pC4Ik/m6buPnyuF3g6aq/+A/iTQxIk2wWnfZ5OVg280960IUpT1e8AMEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794437007;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-Get-Message-Sender-Via:
	 X-Authenticated-Sender:X-Source:X-Source-Args:X-Source-Dir;
	bh=UXJicnuhcwmyx0ZYJWZpTRYTgCzguUEv8BN06l+oadg=;
	b=jor1VbzORoo/AdqH47MPRVZK2sDal4CUEnhAUjunma7PfYon6TNrWECWK04EIioQFnYj
	 OCwUNFfFeinFZ0CaM0bJ+AccBUry+C41DECTY5k10txD1rQ6MkJhMDYjE4Y7AIZRO/IPY
	 t0vjGnEMB83Lhv8ALrVUyk3n0AHfZl0HwoDoMAogi5MTe6oCsckRu7FBt6QSPI0l44nvB
	 HNhw2c40CmbcHlxXd0pVS4ulIjBb7tFiDPpbtBl1qD53xtZ3gf97eHHvHni9QhZbM0ECE
	 UVAY8zOly5zi0tB6j2y90/gS/6YtXOPEHmHfX9jYMztIdcI15I+z6erFFCaeD8mJgLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.cyber.gouv.fr;
	spf=pass smtp.mailfrom=oss.cyber.gouv.fr;
	dkim=pass header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=IpAAWb2Q;
	arc=none smtp.remote-ip=51.159.188.251
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEB1606AEDE;
	Wed, 11 Nov 2026 22:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DEB1606AEDE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.a=rsa-sha256 header.s=default header.b=IpAAWb2Q
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=UXJicnuhcwmyx0ZYJWZpTRYTgCzguUEv8BN06l+oadg=; b=IpAAWb2QYQq1OQrUQlpz1rnWzL
	aG10MJCkusMI0It1L9PJ0imlAUtAx80PMFNBicd4WeLbQG7ASLUbsVcQ2YEkOUqSHBOYpK4qnXjHW
	XPSFOHdjFPBEG/IOUsUyL/5bkQcWxyxk97Fu/f3VvVQ3M2kGEJIMdFHMvuz+nTrrXgASmukGbxfLh
	9pifajPnWaN5btFRK1om88IzeCPSVMUOiknx8u6NdQqORqrW/M+SrXWpjl8nZeGuLjT66CjdmmoOp
	BSIATXvaEcs+qRI7HIKFVokCcn1JglIZsleo8XtWVNt5bo3KNgeXRxgsnH5YsSsCQM/uL/QGRWFc3
	8QbsahNQ==;
Received: from [151.115.150.205] (port=36454 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1xRH2H-0000000DOpX-0xOk;
	Wed, 11 Nov 2026 23:43:20 +0100
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH v3 2/2] selftests: overlayfs: reject different lower idmaps on same fs
Date: Wed, 11 Nov 2026 22:42:27 +0000
Message-ID: <20261111224227.2496049-4-Jeremy.Jean@oss.cyber.gouv.fr>
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

Add an idmapped overlay test for two lower layers that share a backing
superblock but use different idmaps. Check that mount creation fails
with EINVAL.

Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 .../filesystems/overlayfs/idmapped_mounts.c   | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
index 44a75839f4ed..b496b279ce98 100644
--- a/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
+++ b/tools/testing/selftests/filesystems/overlayfs/idmapped_mounts.c
@@ -498,4 +498,47 @@ TEST_F(idmapped_overlay, nfs_export_handles)
 	EXPECT_EQ(close(ovl), 0);
 }
 
+/* Same-superblock lower layers must not use different idmaps. */
+TEST_F(idmapped_overlay, reject_same_sb_mixed_idmaps)
+{
+	char lower1[PATH_MAX], lower2[PATH_MAX];
+	char upper[PATH_MAX], work[PATH_MAX];
+	int fd_lower1, fd_lower2, fsfd;
+
+	if (!ovl_supported())
+		SKIP(return, "overlayfs not supported");
+
+	snprintf(lower1, sizeof(lower1), "%s/l", self->base);
+	snprintf(lower2, sizeof(lower2), "%s/l2", self->base);
+	snprintf(upper, sizeof(upper), "%s/u", self->base);
+	snprintf(work, sizeof(work), "%s/w", self->base);
+	ASSERT_EQ(mkdir(lower2, 0755), 0);
+	ASSERT_EQ(chown(lower2, ID_HOST, ID_HOST), 0);
+
+	fd_lower1 = idmapped_layer_fd(lower1, ID_HOST, ID_NS, ID_RANGE);
+	ASSERT_GE(fd_lower1, 0);
+	fd_lower2 = sys_open_tree(AT_FDCWD, lower2,
+				  OPEN_TREE_CLONE | OPEN_TREE_CLOEXEC);
+	ASSERT_GE(fd_lower2, 0);
+	fsfd = sys_fsopen("overlay", 0);
+	ASSERT_GE(fsfd, 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING,
+			       "source", "test", 0), 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING,
+			       "upperdir", upper, 0), 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_STRING,
+			       "workdir", work, 0), 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_FD,
+			       "lowerdir+", NULL, fd_lower1), 0);
+	ASSERT_EQ(sys_fsconfig(fsfd, FSCONFIG_SET_FD,
+			       "lowerdir+", NULL, fd_lower2), 0);
+
+	errno = 0;
+	EXPECT_EQ(sys_fsconfig(fsfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0), -1);
+	EXPECT_EQ(errno, EINVAL);
+	EXPECT_EQ(close(fd_lower1), 0);
+	EXPECT_EQ(close(fd_lower2), 0);
+	EXPECT_EQ(close(fsfd), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3

