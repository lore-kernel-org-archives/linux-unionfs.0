Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794070378;
	b=OdkXsik3ojX1kpKVpgoI3yogtBUcgKNsuG768WlPRfyWSWfIZjx1K01AgtTi9HLYJnme
	 v9qnzJUVHVN1LsllNUiRXHtUqcBOuyhrCQPabF9kB3yHflCvIB3pJaJNruuO6J2kW8Pzn
	 64hLPxhskp3Jbv/vy7+54UPviSM8gHvreNendDKOrGan1mIwn6w8aP7BOxQVQmWWbCRv8
	 dFN3abnkVyyDgDW4ZrzNc2zVH/MrRs7raFiyZw6jo0aLePkjh02FMyuMkhTt2cieSxniR
	 ZEv0YrDRpFGNKlYaGYCN2k0GtQ+jyoKf4CtYKA1cY2BweXSlm9aGTP8jiO9jACKSz3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cPWF++YSBdHbkvl7nrr/KFPVgdn7Cxr+5lc/XMN2idE=;
	b=sEhGx3d9c5tC/loj35jPyJ+kTySY/JF+/X32/Genq8LN9SL2VBGuu5S0NqpyPCIttQpc
	 uX4UdvWhEyBowTFklDf8PBAIRff6rPs4mb9QpD/hF1tCUccd5co4SbQuGQjL5j1H3k8Hd
	 y0w78j4ElQIdTx8GTxf8Obc6Nw127Rd2bOt2FR1w4zd9m/BCR3s7LOzH419ySETxTBLTY
	 5CiNOBQ3+aUXC7ivU0aSHu4m0yDwxhew2s5P9zKUCpSf4z+DPCJ4q0YlLrp4RpjfMle/h
	 ZS7bsqfTXWnB8ILMrWEdFdkCigV/TThfcbb6vwxqM1sv1k7Uh0Aks/kkU61pDfiCD7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BPFQp9tV;
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63587606A32E
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 16:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63587606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BPFQp9tV
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so2178937a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 08:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794070376; x=1794675176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cPWF++YSBdHbkvl7nrr/KFPVgdn7Cxr+5lc/XMN2idE=;
        b=BPFQp9tVatt9VZ2zoXqToEMmnO6yRi01IO7NvRug4oqSzFEVfRUAG9iucJEX71sN9A
         DtVtim/pBUXO0dangQ7pLm420S99RJ2pY+i3JwbA+aNmMfi8dQD7nYzSYr2HaYkXw36O
         RMbfmEGfTthcI1n5BUjNH/QjxedwFIViHsw8fcjJme1HqZOysAxXhfJ7SJ0fsCNhzKiZ
         aPAGaGAtpQtlza9dLYDmTAR3EcepvQIJympjGggki+xUypV07LkNYR+evVB1iZNQlk9a
         nRRIx9esqnoqwlDzbYu0F1E+OdqdA1beytm7L3bblo/cs0/zTsN9Kiecq0u1iIGFWv4K
         GXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794070376; x=1794675176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cPWF++YSBdHbkvl7nrr/KFPVgdn7Cxr+5lc/XMN2idE=;
        b=Aasxc/Ot1eE92MOApRP7nyeF+ewM1/18d7togYJvyYR3StHRMWn8rtWZEEtfXFl2SC
         fMrNcHGhtF3bWDzvVg8+mlMJNNmnnss6g+EjrappR19LKrGUjabzit3ClyixfOsDgdM3
         3/p3LN5kYGhdI+u+Nu9FpM1m2PpaP7XP2LuIlbhs08q7cZ6M8O3f5Ywzg1Yzk4p2S7IO
         y6kmb5K6jXQ28Dcq8sgplXHGrW7YK4Rj37wRGcpZHpFS5k14CZ94U2vCu9l26k/pvhqa
         K4hFjbJqoTW4ucBJL97/GjcnkgVxXgtf4IN/MCtRrtsgR9zij1EQRokpIBMa0THq/E/W
         pXEA==
X-Forwarded-Encrypted: i=1; AKwUvBzeVaJIaEUkLA+iYU0RnztQjUcJY2d4ybl2rWKERviEHU8bGLAiWEZ+AYit0jhu7apOLAob580orz4EYGvu@vger.kernel.org
X-Gm-Message-State: APuU4Z9+DKrIW5ZDpCSTkq1jLO40U8irx1cpqntLQ/NfUW6+Id7a/lhq
	b2yFRsjOJGZdkkCPBvSrxG183As7aLM47BrfQ2QU/sWLBo7TjjBVBkaG
X-Gm-Gg: AYBFou3F3WFvSZmC23bcDVhVmz9gw0SW+QCvDWocaDw32yp1lxQiqgEmEKk0XRR+eGf
	+zZd38T28ZLL1CSg6gAG4vpyRpsKB4d9xIFIanL3rQEa4jvUdHyEnVtC8uk5yhaW3rYt5HDKTQ8
	CMdKpufT25OYieGcZTKEjbDxked3muUJ2A/4KWaVzKqxWjU9zZub7lxXkbjGM5L+1TJubrKBj78
	bHYc9R0QS8yF+Lwfm+/OqyNOp3t+BWx6zNXvDVGrCluQhQh7HmZ6YvG97gtnfKJcYIS9AzQ7VCC
	BJahi0D6w+6hQTkT2wbxCBm2n+IWh61ZfwFNMvFasoKLS+7MS7x2bQPUeilAyAC0ZK+Q+Fj8Sg8
	RI/ESSopxF9LLSieI4GAcqa2qVhW3TZ5gHcACtadwn5rD6KxhfPaG9SiCTeqXQLCjAs3H5mPPG1
	IlPwCbF4OeL+scProPEPPF30tUvwPTKPeKAGJNfiA9BAI9SJC1ma7z0givbylp1ev31wTd0XmJ6
	g3jn28cpj99pFbManrIDn3F+bnBQR6IEvVcUdff1wXi9WTp2JaYQvyvjXAvI4iTpCioOWrBZbaw
	pyhcLxNB/NG8fK3Htc//TE4/uKTqA8QCm2At9qD+i6NpIGD5jDhS7o6bSmDJRRfmTDiQskGX1wV
	E3C5oz0WLhkQ=
X-Received: by 2002:a17:907:7282:b0:c40:eb1a:4c8b with SMTP id a640c23a62f3a-c4d35485055mr439589266b.29.1794070375728;
        Sat, 07 Nov 2026 08:52:55 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356eae34sm160787966b.85.2026.11.07.08.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:52:55 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ovl: fix leak of lowerdata redirect on ovl_get_inode() failure
Date: Sat,  7 Nov 2026 17:52:53 +0100
Message-ID: <20261107165254.3989119-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ovl_lookup_layers() moves d->redirect into oip.lowerdata_redirect and
clears d->redirect before calling ovl_get_inode().  When ovl_get_inode()
fails, it does not free oip.lowerdata_redirect, and ovl_lookup() frees
the already cleared d->redirect, so the lowerdata redirect string is
leaked.

Clear d->redirect only after ovl_get_inode() has succeeded, like
d->upperredirect, so that ovl_lookup() frees it on failure.

Fixes: 2b21da920866 ("ovl: prepare to store lowerdata redirect for lazy lowerdata lookup")
Closes: https://sashiko.dev/#/bug/linux-dabbd363-9c71-4915-af72-e2b5e75fa58e
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a27479a100275..e25858c8dbcd7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1366,15 +1366,16 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 		};
 
 		/* Store lowerdata redirect for lazy lookup */
-		if (ctx->ctr > 1 && !d->is_dir && !ctx->stack[ctx->ctr - 1].dentry) {
+		if (ctx->ctr > 1 && !d->is_dir && !ctx->stack[ctx->ctr - 1].dentry)
 			oip.lowerdata_redirect = d->redirect;
-			d->redirect = NULL;
-		}
 
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
 
+		if (oip.lowerdata_redirect)
+			d->redirect = NULL;
+
 		ctx->inode = inode;
 		if (ctx->upperdentry && !uppermetacopy)
 			ovl_set_flag(OVL_UPPERDATA, ctx->inode);
-- 
2.56.0

