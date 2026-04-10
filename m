Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CC63B7774
	for <linux-unionfs@vger.kernel.org>; Fri, 10 Apr 2026 11:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775819130; cv=none; b=i+SLcwCu9pufuGdum98+3PESnTaeFx4naVMTahT3VX6CkBE7ZLXQzzKi5EibYckmc4j32IOVftv9nxMvErhBc+h8zN/v3rbVcF4di9JsF/2iuquTDqdqbgJo4/qB5QYNJn9x7o08R4zJGhpUjZ3FOp0LUaEq1pIo45LIF3l+UeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775819130; c=relaxed/simple;
	bh=NnyZTSa0mRKmg2gXT4o5MdM931VBkVXR/XvSN8vi0JQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Md1gEj6vz5BHdnV6sHOZFNOworNkTCqgJwQGN8+gS8UMQWiqrbePWMSa2SW0BmUVVChO3T4oJvryWhnuwkey3DRqqW1glbfrP5MNv8VGOwyQEdkrlj0wv+TqnnrsXLKf7+bgHZZMG7JpyW3DUUgJX+kr/cxP/UrEs2yrjdhgcyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bxm/nqsh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=e/NvIukL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bxm/nqsh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="e/NvIukL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775819125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=uOhHxAHNNh0XwhUXEewBqP0ul0lFamQw50yPTFBpWlY=;
	b=Bxm/nqshS4mfZkGqZE8qo2QTIUJe7Wd2fz4zlTwDOzdAnEmWgqTpNb/4UDN2lCdQ1D28TN
	8lBITstKhCTho+HrGBkQtnKXyXLBQ/Zh9GdmsT7WdVm+m740JQQiteC80lCN8NlznbVdsE
	u8hvJyorJL5Sb+zBEZKP/lOg/xhL9F8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-179-K1ILZSDHOIWnZxK5aVWx6w-1; Fri, 10 Apr 2026 07:05:24 -0400
X-MC-Unique: K1ILZSDHOIWnZxK5aVWx6w-1
X-Mimecast-MFC-AGG-ID: K1ILZSDHOIWnZxK5aVWx6w_1775819123
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d06133455so1236340f8f.3
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Apr 2026 04:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775819123; x=1776423923; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uOhHxAHNNh0XwhUXEewBqP0ul0lFamQw50yPTFBpWlY=;
        b=e/NvIukLkvggWPUzYxEHdEGEziVMyOkMmv2C5HVBCyE2p2BjHAQizIf3lsseToU55T
         7MvTmicdhKm9bpclMUpVSZtGsHmXhbOfSu6zy49HnlWvBAnfQAZrEiR4kTvTGvNuk/p0
         j14AK2Wuswp7McxWbuTXJDnveXY3AYF6Hhs3N29MrmrAL3kZaJIuhGp6rGR+Sih2sz/U
         7rSa0vFTvDaCR7uMXFuIZjn9tz22gb3MMycA/rt58IC/mPKp0I+lr5JU9cV5LPEoK/5u
         g5uKNapnJVQb1CmpdO1gNVgdyFg8SI1HoWPX38/DviQ87KbScjHzDvuBNs4yoTfD+3Ii
         b8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775819123; x=1776423923;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOhHxAHNNh0XwhUXEewBqP0ul0lFamQw50yPTFBpWlY=;
        b=funphq5I0+fJdWxo/HKcFKfxsS1v8bOJTtteBP/SXiCtdox8slurWiiSjCCYahvHlQ
         bsiSALfIzvZmt5OASV3L4Kr7MZdnvoAzqRXsqXZG9nvI2lzNJgfXdws+BtnZvdVZX/Gh
         KqIf1nsRJtU7GvmH5itRYCD6HM0fciTymmgJ3mt/foKS+qMq+ncSZ8dNbMJO7AL0ulFb
         LCUFR4chDVBM/k/bakjgic0m4u4X0MOxOcViKrpJhDCSafzIRf7aJVr+zuLod8coi3t1
         mGyll7tloCV3SzsfYyx1eEMC+RPzMEehOV4B5vCjTnpig0FP9GEPnJ688mFhA0pYvU05
         YsXQ==
X-Gm-Message-State: AOJu0Yzk4MX7ELJfWSRfL911n/5Zo5tkOYfc5OWIX8iIBUr7Elo9lJwc
	Z2KU/lx7PgdfYzZQxK/EpOLIsDAsw+BtFQIjnXEDffcSE+lQ7kgh1tnTJuN2ypoojdBK3zlU1tR
	xH1v4azVT9sUQfRBmE0FD/V2HhMvfm6Epzp8gBB/spO6YwhtkQHGFMWf8r293yCYe9ZdeA0Lo4E
	Xi8slRiOlpdbeg8dF8xoRj+IzuiYLamptNCd4eeQZqfgvYfM+UaQ==
X-Gm-Gg: AeBDieu/tRosKMrZUMMGmNjGrXw5YXySXKFwqBITcpLNVgrbaMo1OZ0He2wgA5/OTgF
	K3RyBAoaHBUj2XH4/e7NdSAhTReleKVbcBPZY8p+w6IWFHprkyQjs8JiCUT5CaRQB4w6DvZ97Ej
	JJbDQYmyd22+KZ6OrEAxg8TfHr9qVtYGowdswgQJkColPqLO/r0BElCQjlWDt2od4U7hWKB5XMx
	2YXPcfFn6MTK8Zg37TlRV5Wo1Ek/mTEBlq9GEiYnv7zu3RSMYAAUjGSj2ziLdFGfxeGaUwFvjv9
	v/GAMwAFK9Ss+ugBriUMmh1tOmSqj23NdVl5SCUazb8ggMbPQDwjXSBh0cQkG6V3FgvycseE2cz
	hTB27QUgh39pRow==
X-Received: by 2002:a05:600c:5306:b0:487:59c:2bb8 with SMTP id 5b1f17b1804b1-488d68c3385mr34126725e9.27.1775819122546;
        Fri, 10 Apr 2026 04:05:22 -0700 (PDT)
X-Received: by 2002:a05:600c:5306:b0:487:59c:2bb8 with SMTP id 5b1f17b1804b1-488d68c3385mr34125595e9.27.1775819121835;
        Fri, 10 Apr 2026 04:05:21 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d53808b2sm72056355e9.11.2026.04.10.04.05.21
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 04:05:21 -0700 (PDT)
Date: Fri, 10 Apr 2026 13:05:20 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-unionfs@vger.kernel.org
Subject: [aalbersh@kernel.org: [PATCH v7 03/22] ovl: use core fsverity ensure
 info interface]
Message-ID: <wtbfe3tb3uk6oeitkqodcal63p7pj6xjqwujzlzglina7o7imr@4sv25le6djgg>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Forgot to add overlayfs as a receiver, this is overlayfs relevant
patch in the patchset adding fsverity support for XFS [1].

The patchset exposes fsverity_ensure_verity_info() [2] which could be
used instead.

1: https://lore.kernel.org/linux-fsdevel/20260409131404.1545834-1-aalbersh@kernel.org/T/#t
2: https://lore.kernel.org/linux-fsdevel/20260409131404.1545834-1-aalbersh@kernel.org/T/#m6baa3210a16a2f54ce977353da7532a93f1aef65

----- Forwarded message from Andrey Albershteyn <aalbersh@kernel.org> -----

Subject: [PATCH v7 03/22] ovl: use core fsverity ensure info interface
From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Thu,  9 Apr 2026 15:13:35 +0200
To: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
  linux-fsdevel@vger.kernel.org, ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>, hch@lst.de,
  linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
  linux-btrfs@vger.kernel.org, djwong@kernel.org
Message-ID: <20260409131404.1545834-4-aalbersh@kernel.org>
In-Reply-To: <20260409131404.1545834-1-aalbersh@kernel.org>

fsverity now exposes fsverity_ensure_verity_info() which could be used
instead of opening file to ensure that fsverity info is loaded and
attached to inode.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/overlayfs/util.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 2ea769f311c3..8bde5dc31d7d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -16,6 +16,7 @@
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
 #include <linux/overflow.h>
+#include <linux/fsverity.h>
 #include "overlayfs.h"
 
 /* Get write access to upper mnt - may fail if upper sb was remounted ro */
@@ -1377,18 +1378,9 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int pa
 int ovl_ensure_verity_loaded(const struct path *datapath)
 {
 	struct inode *inode = d_inode(datapath->dentry);
-	struct file *filp;
 
-	if (!fsverity_active(inode) && IS_VERITY(inode)) {
-		/*
-		 * If this inode was not yet opened, the verity info hasn't been
-		 * loaded yet, so we need to do that here to force it into memory.
-		 */
-		filp = kernel_file_open(datapath, O_RDONLY, current_cred());
-		if (IS_ERR(filp))
-			return PTR_ERR(filp);
-		fput(filp);
-	}
+	if (fsverity_active(inode))
+		fsverity_ensure_verity_info(inode);
 
 	return 0;
 }
-- 
2.51.2



----- End forwarded message -----

-- 
- Andrey

