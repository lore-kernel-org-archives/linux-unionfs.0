Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D91B30E821
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Aug 2026 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671419; cv=none; b=OYsVXjxfJMSiHTlUMORJlmsOkcl8fT97LytR3uZBvKJXrYiAa+CVDHejEgcZLTBTh2HGaSAKns2pLo7lv2waC9tsAhdPnj0ckuBBNz0vgC/ZVGLH79regRb6rQLTD1SXclGY4mCGq62UmkxZSoJ4iQII+lgIxbMcc0FAJaF6UcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671419; c=relaxed/simple;
	bh=RRB9+xt83DUqREi6NudZ/zfZx/ACZyT5r1XvbAUR8bA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jsg7hWVmfaCEyQxKPftb5vzbxgVenFOCgzT4DUm1VxCRVtHDGiDQuFGaPsDQm2ZEFWS7UUIuV9+qP2WoT24hInnYsNuD/C16gtxzAV3UijCIqN/c+clO2jMv8a4YeLC4K/ff0+73/hGKNjWiTWJe9pc2Biile83+rxTtT9Io04E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yt09sITB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KV3FqGYo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yt09sITB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KV3FqGYo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787671417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GtBlMs0QGeEPa3B8TADh34RXLPFC6ehCuUGyBmMOgfI=;
	b=Yt09sITBjYJnSuI3ReDw0ykWmaQ/8ohcNR4ywYcTGlLwRXZilCaAW4FAMtxYz1IDWI2ZId
	C0s1+1d3B1Dr1LPDrqsICGPTAogPp/gTZ/MHZ++7DDhC7UASag1B7fcXCME8bpuItzLBdS
	AMD+PlQGnFWZF+VzCg5y4A7jx1cMBFg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-ByN5HeNRO4e0JEG4aVKgrA-1; Tue, 25 Aug 2026 11:23:35 -0400
X-MC-Unique: ByN5HeNRO4e0JEG4aVKgrA-1
X-Mimecast-MFC-AGG-ID: ByN5HeNRO4e0JEG4aVKgrA_1787671414
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1f472eaafbso99836166b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Aug 2026 08:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787671414; x=1788276214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GtBlMs0QGeEPa3B8TADh34RXLPFC6ehCuUGyBmMOgfI=;
        b=KV3FqGYoNFO/vbOU5NdeHnw58UbfSJxsy1QJQMfis0GSzFBarWmUsDAmpcqQKUt0O2
         tKQls7O7bSbBXay4SxlPs3TpAZPm632/9Cv1kyLBSRthiXyLzETO8JvL68mtOGnezWZS
         oJKzzUeZa0vvEu0QniLIcMTjPF4ok3rXfXFVcx6sdSY+BLM4ltknjThJ/6L6gj6Fv72X
         u4PVkt9PNEYNe7QxtD/MF8IUqrNsMu1LoVbozHit7+SOWfEY+4SzSSTlwc1sc3HA3RUi
         j135P5U6/mSm39cU9HAu5JIkXTqmQJTUGhNyCr4/lr0MQd/o5TJ3fMNtw8fa+ubqQkoR
         WTPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671414; x=1788276214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GtBlMs0QGeEPa3B8TADh34RXLPFC6ehCuUGyBmMOgfI=;
        b=HrB/pQQ5kISlgdndPUTxz7p00z8kMlfhXBSaJLMnX9XJa3YWMqZO4Ej9lXGOP+TYAq
         mVIQlodE8o2VX24Q2GYqIOfSFGlPL38FV0jkHPBqxqVdvsNKpUDISEwM8fXCdcc5yD3c
         uj8JjxWJyLq2nJRawWEy1KkE7iJAURVAXl3NYRPbf0iKgaGjOv//7NBXJ4z8y7gwjA3p
         RXt3zwdZViODK996VWMd5fzgqwRlQbywTXqd6RS9MjcVWDlma309MBGBoe3O4xh4eIoS
         Xg/8iNoO8bih+df5m6gBsSWhRjDs4Hy1VLtQTQlhinjeHILCVfV6f3XMusIVPzio+/td
         cYHw==
X-Gm-Message-State: AFuF++l1yEOWL4BVqMi2Wp/sTL+UeWFA+EFJgMrBzrdNzesPdk1e6asO
	KLrlaBIXRQZAM0StbGkd4S2q2PeSXXrLaZyKmOvwIu4MRQUnSNgC8fMyW0haRH4KiQW94txTj/b
	06PzkHi3/R/9jNDPTxhAWBlb5f6Zp5t6It9waFCYPI7Ygw9BZIMvv/9h4aNgt3KlVK0+tzj7BHU
	q13YuZP5xwp1MBGLMx+SLTUQEb4izgu/FfcgW0J301xRIJ62Ep/9Q=
X-Gm-Gg: AR+sD11scSjEbqS9yoAheX3La1rGGhCLVZAx15hseVRQV7f2b3h1SMnIRR4ucAXFIA5
	4Yq/lYppufKN8a/XdpH46Inx/KT6HQTcvqwN8Oc6iR89hwxDeyDGfSpbQuFJ9XUPtnyhKOpks+C
	Q583wElxOthXz8n4wcMGhLn/TmZJzd5uxHkDEnEy7xjwftrin/6k2Zk5KCCahKlMHhqrA9mIdeA
	ZDmtBZuTcAgxHyujE1lNIRrMhGARJ+QhkfhS+ae7uwUKEqAEJRJON0lTanwEGAFcm6piHbr2k8K
	TrumGe9B4R2gn3NTNIAzz0y3knlvcbpkTkimBKyEbMHLYjjQ7G9cEuJC3mcGJ2cQy0yF71UcO9k
	pFrLDZBQsV62005iqmnyHse/Q8ns6dDI8d5kV9agaznT4etJZdVigaOAvggc=
X-Received: by 2002:a17:906:5147:20b0:c25:58e:8d64 with SMTP id a640c23a62f3a-c25058e9f37mr200044966b.12.1787671413967;
        Tue, 25 Aug 2026 08:23:33 -0700 (PDT)
X-Received: by 2002:a17:906:5147:20b0:c25:58e:8d64 with SMTP id a640c23a62f3a-c25058e9f37mr200038466b.12.1787671413394;
        Tue, 25 Aug 2026 08:23:33 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-213-226.pool.digikabel.hu. [193.226.213.226])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9b28basm484066b.46.2026.08.25.08.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:23:32 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Christian Brauner <christian@brauner.io>
Subject: [PATCH] ovl: return EINVAL instead of EIO in case of mismatched user_ns
Date: Tue, 25 Aug 2026 17:23:29 +0200
Message-ID: <20260825152330.850645-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The EIO was used to signal an internal error (commit 9efb069de4ba ("ovl:
add warning on user_ns mismatch")), which is no longer the case.

Fixes: 63981fc786da ("ovl: don't warn when the mount is completed from another user namespace")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e487597337e8..bd0a3f9039d2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1543,7 +1543,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct ovl_fs *ofs = sb->s_fs_info;
 	int err;
 
-	err = -EIO;
+	err = -EINVAL;
 	/* The fscontext fd may have been passed to another user namespace. */
 	if (fc->user_ns != current_user_ns())
 		goto out_err;
-- 
2.54.0

