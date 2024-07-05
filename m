Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59B71CD02
	for <linux-unionfs@vger.kernel.org>; Fri,  5 Jul 2024 04:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720153556; cv=none; b=bRnUPObGrTlOlHz9j0FJNVXNLY5SSU6OHgnHYfnEZps0qiHdznWLVWucq8AkIs4jVms1IQE4O13s39xAaybRluCQiFVm7bDwT72k/7dcjy6phiKhgvVcFFhHuxrUrTpjxVwwRRaNNgv3IvjsANvZvdKNLs9SU8b00iUoNLU/f0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720153556; c=relaxed/simple;
	bh=/3A/xr3HDWg9ScMXjacOI5vet9iZ51r8iYrAw0urznU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uPw/6CbBY2IOWVnNRHYnhxN9S6UsyoZ5YUKRiMtTN3bpo20KaBb/33fBDR2D9Bb6S5xVkOhRXZH23jhfMlNRMVtK7JNb0apQFs3MMoKCpM4V2z2w07TsuXxg1XyQEpKCUKP9nehtyvtizdTEW6WWk0c+6iDwpDNfybKQvVzDWdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com; spf=none smtp.mailfrom=mbaynton.com; dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b=jfc2EAIC; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mbaynton.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mbaynton-com.20230601.gappssmtp.com header.i=@mbaynton-com.20230601.gappssmtp.com header.b="jfc2EAIC"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7f3d884e70bso61378239f.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jul 2024 21:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mbaynton-com.20230601.gappssmtp.com; s=20230601; t=1720153553; x=1720758353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Upgfs7RxQhcl7BSiGR3loal7vDWdAlabKhTtzvWxtdg=;
        b=jfc2EAICB7AWpuRs5DPOatOPgUgG5LF7lXi7EvYGrebMrYC2DZS5KnsDYeDZtFT+50
         iKNFDGLZrZ7ypXtIRHahoUn19iclKbxZ1/Hhaz8P3N1KKlLsQgGTcU3gGJiTSCOAMmRd
         MR6L7EA1/vixqyKIH2HUvjp+Jg7TY9EL6FVUcjCxrMVBRpucPfBcW3H8qU9tRlKYa4k5
         2aophvzNPAU916HxxMYz24qV/c8zmRJE9KFNDDqklxHpJkBAuvxIusl+9gbM7dhw/ESD
         f0gjcnnlMFUPLXTi7wk2xtGzfl9d8bXEYIbjLU2PtDJnAeIxJkhf5Q9VQR4oKZRhFUDN
         zojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720153553; x=1720758353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Upgfs7RxQhcl7BSiGR3loal7vDWdAlabKhTtzvWxtdg=;
        b=vBJHq/ferTgFszNHB2cilUcQXzZRGSGFOAz34lfTZHTylVB6FaElh1wV+235EPyUqA
         GZLIWh60zZBoqR1LAVO52EaQ4x8tnOatQVqJH50dwkHbqKx8CEtWvnT5IxandBQ083Gu
         FHg3g0nMNzfeZyETUS17vW5RjFx5lWultw+sYCPzouHPM5jisUaITluc/ATgaaY1QQ1I
         i49Ncwl++Pziv4fPUCoXJvGsoLoI5kZR962tN03b5l4wZl31G5ADWd/UksK5Z9GXEJLG
         9fYDX1C9ySgn3tT1XwusbpBKKlzFggn7Xf/Ph/ikeStRoRDf9FLP9A75IQ2LVqft2nFy
         K3Mg==
X-Gm-Message-State: AOJu0Yxq735BdFVf9ofX5YeSY1+xyePyiyMvUGHj0lQ7u0EmCQUwtVNS
	wRKzwPzUHsy9kygk0qmFSr+bKr2TwSaZf7f67arTFXmwJMgzzLMQrhfHzqMXce+Ogw180s9QOiD
	m
X-Google-Smtp-Source: AGHT+IGA8SbcX5CnYiTpgzOY2zeXbVlMCSxQpCLp0sBOzGvsvQFrSG7BhbqZs71tu+NYiHT5kjKT/Q==
X-Received: by 2002:a05:6602:600b:b0:7eb:f3c8:c59b with SMTP id ca18e2360f4ac-7f66de60174mr528356039f.2.1720153553404;
        Thu, 04 Jul 2024 21:25:53 -0700 (PDT)
Received: from mike-laptop.lan.mbaynton.com ([2601:444:600:440:d443:7d67:4db4:213b])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4bb742c2551sm4298298173.149.2024.07.04.21.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 21:25:52 -0700 (PDT)
From: Mike Baynton <mike@mbaynton.com>
To: linux-unionfs@vger.kernel.org
Cc: Mike Baynton <mike@mbaynton.com>
Subject: [PATCH] Data-only layer mount time validations
Date: Thu,  4 Jul 2024 23:25:42 -0500
Message-Id: <20240705042542.2003917-1-mike@mbaynton.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There seem to be a few scenarios where it is possible to successfully
mount up an overlay filesystem including data-only layer(s), but in
configurations where it will never be possible to read data successfully
from the data-only layers. I think this should result in a mount-time
error instead of the current behavior of being unable to read data from
the files that should normally return data from a data-only layer.

Both cases were found by attempting to use data-only lower layers from a
user namespace, a proposition that appears to be guaranteed to not end
well since data-only lower layers requires use of trusted xattrs, but
trusted xattrs can only be accessed in the initial user namespace.

Case 1: upper dirs in use but xattrs cannot be written to the filesystem
containing workdir (for any reason, user namespace-related or not.) This
triggers a fallback behavior of disabling metacopy after an existing
validation in ovl_fs_params_verify ensured metacopy is on when
data-only layers are present. This is now rechecked after possibly
disabling metacopy.

Case 2: upper dirs are not in use, data-only layer(s) in use, mount
initiated from a user namespace other than the initial one.

When the filesystem consists of only lower layers, the test of xattrs
is not performed and so metacopy remains on, satisfying Case 1.
Therefore it is also neceessary to explicitly check for data-only layers
in a mount whose initiator lacks CAP_SYS_ADMIN in the initial user
namespace.

Signed-off-by: Mike Baynton <mike@mbaynton.com>
---
 fs/overlayfs/super.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 06a231970cb5..4382f21c36a0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1394,6 +1394,19 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (IS_ERR(oe))
 		goto out_err;
 
+	if (ofs->numdatalayer) {
+		if (!ofs->config.metacopy) {
+			pr_err("lower data-only dirs require metacopy support.\n");
+			err = -EINVAL;
+			goto out_err;
+		}
+		if (!capable(CAP_SYS_ADMIN)) {
+			pr_err("lower data-only dirs require CAP_SYS_ADMIN in the initial user namespace.\n");
+			err = -EPERM;
+			goto out_err;
+		}
+	}
+
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
 	if (!ovl_upper_mnt(ofs))
 		sb->s_flags |= SB_RDONLY;
-- 
2.34.1

