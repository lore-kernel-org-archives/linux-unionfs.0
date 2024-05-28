Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A44F1F2
	for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 09:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716886984; cv=none; b=Odk0gmd4OfCNSL7xtl5RPLnyaV72mXCX3wxnnLUQvDwB0deugD7jgnzMhaf9SPCzBxRqYOuDYzGEsdKSpvlrhr/DITukqfsDeLwAcHZAno2QRrQcV+kaNIW/PUVqqqmuUM8LrIr5FYh6rmWSZeN+LWmwMZlSCnqYyX2AtMs3pu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716886984; c=relaxed/simple;
	bh=uboriDCKWeJMPTjPITy2yzoiM+nx4vV167P9uIGhE10=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QocCVa9QitMUfUQvidhkQeFg9djeX1tbJNiuTvE7mPn/tdkYB8NuyPJIYMv+CdroXZN4rdFNmVhQs0uoTkFHXSRGRvZps3CHEfXuVuHphSD2FwsvM+fIrUO+IaQ5c/LA+GtuLQRNqGeHHVNNmzFPL5L1V2AgAheE5oyaxBBlgKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HrpVSVEl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrpVSVEl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716886981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XxpobPu2s04aDHCSU8HoaN1HgFuJlZN8yBuvL8SN10g=;
	b=HrpVSVElfIZAXod+8u935cv7/gVxQyLPusZbJ4CyjuAJP3So5YsX7kUHfVA9ajUaRadytR
	DpyNnQssjFc2Iao9vRgRUqkxFesaVfwfmt0ynA8yIblpgk+F7IJArl9vQZ5fo7rX+8UOrb
	fE34zSePikAombCV5JVRQO9avN3yuhA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-ygkePBnmN8ikKIOJ-VLwQQ-1; Tue, 28 May 2024 05:03:00 -0400
X-MC-Unique: ygkePBnmN8ikKIOJ-VLwQQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2e984fac768so4227771fa.1
        for <linux-unionfs@vger.kernel.org>; Tue, 28 May 2024 02:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716886978; x=1717491778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XxpobPu2s04aDHCSU8HoaN1HgFuJlZN8yBuvL8SN10g=;
        b=I7NxdMu7BQV0T8k8jnPfNin5+3u3MKYXQP5KpkeRvN4bMV9SRf3jehBOwBfSbH9l9v
         Flb3o3XgtTZR6nTMwhb3PbUcO682+haZicG1lPFV4CBAWWl4MGbkKzwen1B/4zU06ONN
         gGeSmXYIZLeoTGenbemf5Q6riQmO61bpbYyYbXU1wsxF8aEYEd2IDjQuW8XWfFDL8qIR
         uU6ewkHlID1JxQ+5qAMDTa6mpLtG6arxFK1adm/YiT6qACYWxkCv4FPG7+2nWXKd2Em3
         +8uPmclexEtctodizyly228V7WBlp75Roh/YAQcsJOQtEleF9iBdoToNIPB84Uh0g2wJ
         1IqA==
X-Gm-Message-State: AOJu0YwyejtRE9FC3jxiPhwiLnEYvk5pI9w7Eow9UiiqIA84qjpOO2zL
	BiVFEd54RpF4jVx2V9TBwXFiAEkKb2xLSMVEVaSRyZfpHg2FTgD53UKkFp60Y8Uuy9DrXEhP9n3
	c0/1m1Oshfudbx6FYdBcSnHEy3RgO7TKisTFqUZQFC128x/ecvQJNCU0sJo2aL5CdnmO3AUj5XF
	wg+yfLs/vCKclaTcKi2IJywaMSyl+Vy/sp597QQJFuGDnHew==
X-Received: by 2002:a2e:a695:0:b0:2e9:85cd:a8b3 with SMTP id 38308e7fff4ca-2e985cdac72mr12031261fa.7.1716886978594;
        Tue, 28 May 2024 02:02:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkZpuxCf2TVJfINSNEqhmE2p4hgsQIYE/R+0c6+U2AbobsK5d7qu1h3PAfmQ+tXABzqxg2iQ==
X-Received: by 2002:a2e:a695:0:b0:2e9:85cd:a8b3 with SMTP id 38308e7fff4ca-2e985cdac72mr12030911fa.7.1716886977958;
        Tue, 28 May 2024 02:02:57 -0700 (PDT)
Received: from p1.Home ([2001:8a0:672b:c00:2848:324e:c3d8:68df])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3557a1c93c6sm11112638f8f.85.2024.05.28.02.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 02:02:57 -0700 (PDT)
From: Eric Curtin <ecurtin@redhat.com>
To: linux-unionfs@vger.kernel.org (open list:OVERLAY FILESYSTEM)
Cc: Alexander Larsson <alexl@redhat.com>,
	Eric Curtin <ecurtin@redhat.com>,
	Wei Wang <weiwang@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org (open list:OVERLAY FILESYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ovl: change error message to info for empty lowerdir
Date: Tue, 28 May 2024 10:02:40 +0100
Message-ID: <20240528090244.6746-1-ecurtin@redhat.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In some deployments, an empty lowerdir is not considered an error.
The current implementation logs this scenario as an error during boot,
which can be misleading and cause unnecessary concern for users. This
commit changes the log level from pr_err to pr_info to reflect the
non-error nature of an empty lowerdir in these cases.

Reported-by: Wei Wang <weiwang@redhat.com>
Signed-off-by: Eric Curtin <ecurtin@redhat.com>
---
 fs/overlayfs/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 4860fcc4611bb..53170d73bb79c 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -231,7 +231,7 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
 	int err = -EINVAL;
 
 	if (!*name) {
-		pr_err("empty lowerdir\n");
+		pr_info("empty lowerdir\n");
 		goto out;
 	}
 	err = kern_path(name, LOOKUP_FOLLOW, path);
-- 
2.45.0

