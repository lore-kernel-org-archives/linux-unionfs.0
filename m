Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0317BB1A
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Oct 2024 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729868524; cv=none; b=iC9zPUznaKlm4f9KKeUief8mA5P/wHtV8zPBBPY03UxAuvdrTv6orgBM2xhYyz6oD3+/fr8OmcacztpkCO/cQPojln/XtI4xalxnHhDS8oKQPIoUHnUTm4hCkcCOvDHXKaijW7q+cCEic44QuGM0FWG/Kgfppcrbdh+Pen83mz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729868524; c=relaxed/simple;
	bh=6DQItpHNmPUlinaFM/3uXjfpJKAJ1LMbiY7pPkgBTbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uP8/TRm7NIWZllIwl86GcbrnWXStIEdv7uCRPof+kv2om9wuA9BPibbT2JWT/KZqH10dXdxRQbPuY6NBQnbnzXIKnseerzCtekhOiq7GrC1jvFNu98wcVykpu+QKHD1h3PNw9nWCtQYs96XfD5gNlqDTbWDKSdQv/SuMVli4OuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQZadnse; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQZadnse"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729868521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NQCVyRwqLq17C0Jl7DZDgiok560sNkHv2+RqbNocmhE=;
	b=VQZadnseEizsOCryVr/XO8T+P8MSIxwOvPTtPK7Kws+lR9vyl2WGGk+foAEaZ0UQ4EQThs
	H1qW3e3E+7yf3kQfXp36NqAXfSyvDTG4xZ364SZSfQWVUa7PimoYwewTRBSIFgS3eL9NJO
	C5+gZZ7kQhNxM7VLqYl0SXJ2CL8WoVU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-RsewYPv3Ms2-Lk318Z0Upw-1; Fri, 25 Oct 2024 11:01:59 -0400
X-MC-Unique: RsewYPv3Ms2-Lk318Z0Upw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4314f1e0f2bso15319515e9.1
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Oct 2024 08:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729868518; x=1730473318;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQCVyRwqLq17C0Jl7DZDgiok560sNkHv2+RqbNocmhE=;
        b=IxQ8fJ6/VblTwawF+kSAtZUxqZr7DMkMPfd7IRm2I20F3SBdOFpxGuiEKuOPjFFBCp
         +AcRx6d9xMjkAlY8TfrNL5QvLd2iYDM+APYwIJXFPLYpG23AOHV8BZB560+j1+igeaog
         tiP0ufQqfrhYjPH1Xq3ML5tIzH0HQ7iVwPdC5t3foibBrsWaVXrxr78KgmGKgmhUcV3Y
         m2cD02pRrflpBqfwdaI+1V91oAjoBGur14Q9uvYZoDCPKlpSAMX09d2UnirVk2xTbpWf
         AgYEWjapi/UU34xq/cGnwngazX3vgc46PPzk61XhAUGE3DcGDIvUL4rpS9pzS8cua4Bw
         CNCQ==
X-Gm-Message-State: AOJu0YzeoERLnxGQ2O8w3EWylZLh4ig3Nnk2IPsAWYFZ5VsV5lfNz6iM
	llfIENiKYaHyA+0PD6+Wboo/aYLZJPchqRjoSbgeoLvWPPBFfYHDPT11c6hoe7duMaPlUdITg1Q
	kOPNbMkzJ1ZdkYjB0ECY6cKX3O0+6/NuTDn5rkyOHAdpx6YNsV9Jd9UUynLiDpBFHS7jHznxCvH
	PuzO7i3j9QlQglENatQ4s9d5MzqwstDZ9BDE6hgu57hQNQXqY=
X-Received: by 2002:a05:600c:34d4:b0:431:5533:8f0b with SMTP id 5b1f17b1804b1-43184246647mr95157165e9.32.1729868517964;
        Fri, 25 Oct 2024 08:01:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZusoAnePpnOR3fg/5cReNvWrXU3jddzdpjthTe0IoyPPx2z5mCJo/FAbfR/pC8GUtBEuFtw==
X-Received: by 2002:a05:600c:34d4:b0:431:5533:8f0b with SMTP id 5b1f17b1804b1-43184246647mr95156495e9.32.1729868517407;
        Fri, 25 Oct 2024 08:01:57 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (91-82-183-6.pool.digikabel.hu. [91.82.183.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b92958sm1717817f8f.106.2024.10.25.08.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 08:01:56 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] ovl: replace dget/dput with d_drop in ovl_cleanup()
Date: Fri, 25 Oct 2024 17:01:50 +0200
Message-ID: <20241025150154.879541-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reason for the dget/dput pair was to force the upperdentry to be
dropped from the cache instead of turning it negative and keeping it
cached.

Simpler and cleaner way to achieve the same effect is to just drop the
dentry after unlink/rmdir if it was turned negative.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
v2:
 - use d_drop()

 fs/overlayfs/dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index ab65e98a1def..c7548c2bbc12 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -28,12 +28,14 @@ int ovl_cleanup(struct ovl_fs *ofs, struct inode *wdir, struct dentry *wdentry)
 {
 	int err;
 
-	dget(wdentry);
 	if (d_is_dir(wdentry))
 		err = ovl_do_rmdir(ofs, wdir, wdentry);
 	else
 		err = ovl_do_unlink(ofs, wdir, wdentry);
-	dput(wdentry);
+
+	/* A cached negative upper dentry is generally not useful, so drop it. */
+	if (d_is_negative(wdentry))
+		d_drop(wdentry);
 
 	if (err) {
 		pr_err("cleanup of '%pd2' failed (%i)\n",
-- 
2.47.0

