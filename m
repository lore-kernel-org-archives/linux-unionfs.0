Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794225057;
	b=44yAsJJFdXjQPEESB3BftJT04uoHI1nDuK0NMR2g71t2+4wKn8pwz/ZD/2Ge+HaGXciA
	 W7xczjajJgYymwxZVP3TB3dIGISaIoiUBDX9PdbjJYz24f66qFIksIPS1+ztqeVJ27c/C
	 LnzdUg9FqQxfSI4moVr6iRcR84O0n+N3eh4RvDDocCVzPVMEJDcrd2kcxc9VOxXJyPSfz
	 82Pp5/FZsibpuhZH8X7PrpSbiAcswZa3yW2CsUzNuctpmqiY8OSZWyJdoWtm4bRCj+maQ
	 BR/gLbaKUOBNw/XaJDHHtMWFyvvaiImibmvS25eQ7iH+r7W5x+RjFAEa9A1+VR/vOiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794225057;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Z6bscx+xVoDHG6nk05Y2GvjGVXrUF0HJS/uHEwq9jUk=;
	b=4PYoIKqmsGtpOO22QDO96M3AhSkEKQbHRfgfgr0q9xB1L4crngQtlh3I30KHAXBXJcZd
	 4UcqMOtqlR0jJT3O8SZ62N9ywJQ9jeHAPOHVMD2VQwK3Tdb5GbTJw9eecpRvUzip+uF7x
	 BOEXo08+QZBJvDogw2nDb9t9+Y92jnYLxfAKkMon35p45a6KIlKyMSzQFLuG8qPhhdV1z
	 rYwSlKCkzKnvYXLaNdChqv8lzie6l2HKgRB6F9F47B26vC/FKeiHc8Us7rs4fZ8sO8Obd
	 acUsfOrCgtfqebt5tFxdhqkm662JA3IaQy8J3Zq1yq2UKk6+jkqRi+c3+mG4qI2OjTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S87JFWNJ;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A40606A322
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2026 11:50:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05A40606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S87JFWNJ
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4d21051042so110172966b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2026 03:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794225055; x=1794829855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z6bscx+xVoDHG6nk05Y2GvjGVXrUF0HJS/uHEwq9jUk=;
        b=S87JFWNJydoMxIV7mKMHe7x/pGXcmHCujJzMCyS8AHDCJy2Wp88bNO75387DA8g0j0
         jo07ecG0bZ7l17c1PgxWnOXUU9299sIPuQxkA2eCs2vE50tulaL+Y53DllCL7hvP0QSW
         LvrmjST5KtjYrh6qk5wXNwnSSO5REcGgKauM49JhCcrJC8i2XPnPtIucLBTv4HfKvLxG
         lPUx5SQB3KolAP2gsHDHAQm4SVcx20ceEsECKfrQ+826XTCuGQTFrog2nYR53V31w1Dc
         nPQlAw5hLesIB6RBmyp5rP1oN0269RlmSx5+RqokZvZ2vtL6l1SMMkQ1Z2X2wDlDxkHQ
         g/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794225055; x=1794829855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z6bscx+xVoDHG6nk05Y2GvjGVXrUF0HJS/uHEwq9jUk=;
        b=Al6JYwTr4hAH+TYLY5wbZE4IBcXSEbgXMf0KpFtCZjwh4yfObw3tHn4SB0G6tHDhrO
         2EvphXdEJOqLLL2ldsFr4UflNuSqNDLk8QXgV3dx1eYX0YjaarLO1RUB7g7dobymAUv0
         M0EVnbqWCqNg5fHjzp7wUktQgZ6wLS9JnPSheYiE7Jv2hhYzEbumMLF4vh0N93PVepjt
         Ki7FTxoU7vRxLYyW/P6wPTPT5lO87692nL9eWGw+PPy/TvCIoisbARI2eyE3WFXMJBko
         4vAMsGb0ulL4mC87VZllWXCPj9oHqlRgTx8JJv6zO4qQa4YRaLVcPkJDWtMgJmiNoGPL
         aazQ==
X-Forwarded-Encrypted: i=1; AL+hErEh3yiwY2vi6mBnMfUWYbD+CTAvlaVigHuwQ0OrYUlpFmGHyXfEH0mxUMXC/f2/npnaUXEyyQc9cW0G+gfx@vger.kernel.org
X-Gm-Message-State: APuU4Z9VN9L7dH1azNBAzxrqrFN8xh06DPtYEiUE+daVzGfiBl7RqYuJ
	OpM0JOI+e+U2MfbPElW9arjGI0YkXgsJjCdXHMvHLHecr/3JvkLXTqEA7lIO/nk2
X-Gm-Gg: AYBFou3G0aIz3Cdv7IFYK8UHYYLQTvZVXe0qpqS1pKBus9wIP7yhN4ikDPScUZEXW8W
	B3D8nOpM7OEL6ATsUQJbm+r7YrkG79sj7qI9AairTz4lBSGUlmTDwmeKa3CEWZEl14xp6O8gv8H
	KXDFpT7qLw3wwByLRIOccQ318FHCHf4kIeBUM61pe4zyoTtzBoMKM4qdP59S1OPiqwriZ6XoTv0
	EGNzGovrCfedlWfaAkuMP3GG73RjAUoUoruGxCFxU+Jf5IwX3arjglQCxBv9l+JHkjNgCy9GTZB
	wlIrj0hn3tbU/nNoiNvcNR2aK/T5r92MpRxNzjE+Q7PNbezQAXQL7Rxuk5h6Uyd4Kh3527zQlCE
	sZMc4uLdH0yXxr8KiBTy/OcANcgw8nUbY1MNsJbkp2p8KlpxP1/+oRJM94ql9cQKPcOSEXnuEVg
	Qk7IV51s5n8baChUBRo+rD62WUazMxVJlv9qX0d91dnNS3GMI+0gBpXgl48HVIJedxXscD8Lehb
	lXOi3vmldBGerK/mViUK6xLGXQn/gHDKPGhXRBUnD8+BBBR7FVy2fZmZha4ufA2c8ly6My1jFIR
	YQTBc4ji4zRKGi3LHs5pfJROmS9QAv+1Pux1kFNbZxUB74HsJWOY7MMojSOj+TyT163vyVk4paB
	NnI43RZ8cVbXZkWl9o1rcRaGxzR8VuBrq
X-Received: by 2002:a17:907:c5ce:b0:c2e:856:2a08 with SMTP id a640c23a62f3a-c4d6d15a580mr277220066b.1.1794225055037;
        Mon, 09 Nov 2026 03:50:55 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d68d52cf9sm153627266b.2.2026.11.09.03.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:50:54 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>,
	linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ovl: do not allow nfs_export with data-only layers
Date: Mon,  9 Nov 2026 12:50:54 +0100
Message-ID: <20261109115054.4031784-1-amir73il@gmail.com>
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

Since data-only layers no longer require metacopy=on, which conflicts
with nfs_export=on, an overlay with data-only layers can be mounted
with nfs_export=on.

Decoding a file handle of a lower metacopy file whose data is in a
data-only layer builds the inode only from the decoded lower dentry,
without the lazy lowerdata redirect, so the data of the file would be
read from the metacopy file in the lower layer.

Fail the mount with explicit nfs_export=on and data-only layers and
otherwise disable nfs_export with data-only layers.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index ad7f30177ef4c..7a4e1be5225fa 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -931,6 +931,16 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		}
 	}
 
+	/* Resolve nfs_export -> !data-only layers dependency */
+	if (config->nfs_export && ctx->nr_data) {
+		if (set.nfs_export) {
+			pr_err("NFS export is not supported with data-only layers\n");
+			return -EINVAL;
+		}
+		pr_info("disabling nfs_export due to data-only layers\n");
+		config->nfs_export = false;
+	}
+
 	/* Resolve nfs_export -> index dependency */
 	if (config->nfs_export && !config->index) {
 		if (!config->upperdir &&
-- 
2.56.0

