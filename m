Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F0D15FA96
	for <linux-unionfs@vger.kernel.org>; Thu,  2 May 2024 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714685218; cv=none; b=J1uT+8haalL/zPELSY+unT13ub8qGcydZ7k8vaa19Yyvl4WOl6RDFyPgpk2J+9X56fBsIhDfVXPn6QeYziIcsrP7qgvnD1XrFqDRcqBRiwJ6MAZsCKzsIESPtBxR38lBWiPXWQTiB5Fw9YxaHY7SkfrpXaxdqjjPvKGFGles8/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714685218; c=relaxed/simple;
	bh=tVWXNCzdMWLdqo6Ilri79iJRAhyTbQmQeAhLhhvAFyA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sb89HdoSE/bcpI/vPAtF5fvgiejqinKpKfPfzCes40ZCum7kHP8ZYlgswjnkUCPwTR8jDlxl+rLFCXZZk7ycUii92BckdVyCIITfKvmSTdCYcoZyR1bpNrgbdZtlK0+uttGHvoaDLUgM8jb2dqssdVfzUfmCM228HK2sAaZ4+rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=o9OoYScd; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="o9OoYScd"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51f0f6b613dso1705735e87.1
        for <linux-unionfs@vger.kernel.org>; Thu, 02 May 2024 14:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1714685215; x=1715290015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wU/XAKZMmUOs49TIIxrQWM7SSMi6Vt7hgebFMdmZZhA=;
        b=o9OoYScdHYuuenDc9CZlLY0tcO3eE4/qY+YyFolo9ynupcjYg5OyyaT2EOyyjV9jwD
         7kM9zFW19qAphPxyyl1kIJ6IVg2n4XBuR72MnhzhHGy5OCp6wP4ytOxPMGLXotIZY6+4
         BK7m/oHubHYiuEvwsXz25i31yabAPIMoI1bhOKihuJruGQ/FH83chFz/OSfKOXxlbUHj
         w35MF6vQFHzgdGyqILv6WxhgkS5tkIUr8wO1ZMXB+aeeJtqYKHjFvxhLo8V4dCKskzLD
         v8y57s+lrQgcUGBUcNMDf4lJEVaZIK0v6xUuF2DR12X6816mKotial+odtuoACnrDGgX
         p+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714685215; x=1715290015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wU/XAKZMmUOs49TIIxrQWM7SSMi6Vt7hgebFMdmZZhA=;
        b=sBtm7QC0++uyGbf2RsjWRbq42gJH7bS0NhPXz59lX+Ip76wr8Za51qcxNWjCr+y+bu
         3JkBZN8pkVTXdlfI9ynM/c9d7V7bgr5vg0uwUV9btbcx551J3aE38/84FYCjxASSgCkP
         Bat402QASThz5AF3o6FMnvIH8Ymawgy9GCsgylxfc+xux0zi+RHmCC0g9QQ9QovzQoB4
         XCm9FH32XuOV/YZPQPILtXu3ZNe/WGuJV3ibFoCYfgCqAhuxCcoaoWvlPNP3l3IyMB0C
         Qrm3m8isks9NV9gPkqWmO6oScDMY2C5Ywdt/UeIoHSbBxjMBB0cGEZtR/xsVQEXhOkof
         0rEA==
X-Forwarded-Encrypted: i=1; AJvYcCV+gN5+aixBJ4PoTMu7DrqEriFDAUUXIdVlxJAg9lsO8CdL9/pBo5CrmGYgv898rxzoib90iKDpFo2h5GBnMKMxDOY7Fm2vi2ixGQI3og==
X-Gm-Message-State: AOJu0YxO6AaQeiP5Le22WdeZyfbuHmW6FFydzOe8GgYoL+vlTOk3oBvj
	98wzWq7JS5QCtXv69wltTtvcaWSs4kHHIr8X3Rvq7BuvkULQ5JCbLK1PJL64LAc=
X-Google-Smtp-Source: AGHT+IFdU+CNhHsbaoct4Qy+KcY+OUDNYVYuy7Zm5gtsIUrtGa9LNDfgRLHazZskYH9L85fevDVJpg==
X-Received: by 2002:a05:6512:3144:b0:51b:e42c:2ec4 with SMTP id s4-20020a056512314400b0051be42c2ec4mr584685lfi.24.1714685214745;
        Thu, 02 May 2024 14:26:54 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-100.dynamic.mnet-online.de. [62.216.208.100])
        by smtp.gmail.com with ESMTPSA id my37-20020a1709065a6500b00a5981fbcb31sm354886ejc.6.2024.05.02.14.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 14:26:54 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	kexec@lists.infradead.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH 1/4] btrfs: Remove duplicate included header
Date: Thu,  2 May 2024 23:26:28 +0200
Message-ID: <20240502212631.110175-1-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove duplicate included header file linux/blkdev.h

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/btrfs/fs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 93f5c57ea4e3..5f7ad90fd682 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -9,7 +9,6 @@
 #include <linux/compiler.h>
 #include <linux/math.h>
 #include <linux/atomic.h>
-#include <linux/blkdev.h>
 #include <linux/percpu_counter.h>
 #include <linux/completion.h>
 #include <linux/lockdep.h>
-- 
2.44.0

