Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8945DEC4
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 10:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742899603; cv=none; b=eklZdQkjeAz6GWWkT/GhCWHBjWvDw+HTCtgY9Yx2pMEe0FTN1KgrFEiwEyl6kQVHLkU55GlkFJvK9SP1xUFK4KUXZB32R2NDNYv/05fHsALiu5E+SAewNKrRXp7A8/WVaEz917Z2rTRrmQqWfrruWOq7qH165vsQVz0GH4iTy+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742899603; c=relaxed/simple;
	bh=vkbpeFmqD668MPanvRonoQwCZ0BQK81IhaRcc7RnYTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhJkkWVUTk7mmNFc22MGTcIMdcQqLyXzycy3keGYswfTiCbg9n45+vMxt2aS46aNBrxfntAU3zJOQLEdyXGG+0MrJ3HbgXNlF7/ZxdterL6fHPEOWBrZzg3rLyZTAqxk2kmppnXEqImX3qBEiF3hqs8ijLy6gRsT1LMexfzB/rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdAuEhfM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdAuEhfM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742899600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IL/6aR5DxlrxjOnL/vY3X0cqTZslpUhOi/XOXuXLhhE=;
	b=BdAuEhfMfQEehbJjjvBbU7Ve4u6pCdIsoND/YqcigEQuuPbJPrbuz07YQbtSgvKzUL25xv
	XcM3xwVUKMuryOa2cgym1ud5Jj9p1pqbkp7mzLJtyrjzIr8lZtkIAeWYzBxcljPEnPt8KJ
	AcvG8z79YmlNCaiKL0owTvPlWX/GnMk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-dwIgnfh6N_CXjvchkf1kAw-1; Tue, 25 Mar 2025 06:46:38 -0400
X-MC-Unique: dwIgnfh6N_CXjvchkf1kAw-1
X-Mimecast-MFC-AGG-ID: dwIgnfh6N_CXjvchkf1kAw_1742899598
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3912a0439afso1941025f8f.3
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 03:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742899597; x=1743504397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IL/6aR5DxlrxjOnL/vY3X0cqTZslpUhOi/XOXuXLhhE=;
        b=p/mXLrbANyrwlsyS6fnIrYX0ldILJMUzJrI0i3EW3x5duXBGF7i9mf01Fl1hPo7z0d
         qKoQQPcBHDFJUxf+GKC1b2rbxoQUAK8xAzd2mfQgHLBUtJzwCiZZumVdZlS210vn9IYE
         coDGCKNBcqGjPXtJjwhe0ju711g6A+MlzU9QmQFUscaUvg8AJFufhj7GtM0/ZY4gyCA7
         N53bkUdO2YHbO3J33q9yHtFDfa4F04hlWFr/7nPP7VlGT/MxrQgUZlFWMRY8oMPo5eiz
         b9Smoiii8NwDs7I2ie7Il0BAMKH/lWMtcfJfaUYbJrz4QkoHytNLHow1qe3MBcUU9VbS
         Y0PA==
X-Gm-Message-State: AOJu0YwiMAo0Vu8Kl0/hCMNp9TJHYDWRCELDcOOeEiLsZkUZZtbYQpe4
	Y/CAH0TltMk57tSzSl5CWBoXFMoDfZKYw+rFswF76CF4PLtODCD3qwRfmp8jax2CkhLK13KY5Me
	qEvwU6VyVpZJrkY7bM6bgHkNvm6tX7OYv5PCnSpbrTDAwKe1D3qBRJBJz7+OcWOF9Jt2WZhIAZZ
	LQHSUOu16cthCQrD3dmvYWe5uGd/5s7Zu7YPfJdvCkr8J1iOo=
X-Gm-Gg: ASbGncsexjC2ahU+y9nXOW7U/8uHOSTG0lmqSBAAqKy1OAzqtNF8K7577SEtU7xW+v8
	an9nM7uAGUX0iyq9tylacoFK4ymhJ4z7SJn2pq2U1Lwlns1bRs2VQOv6piyQJ0RotzXRAoyO58i
	w05Uyjubd0GsSXuYYwnSYSacVzY8EL5gp4x8RmEfel1DPyDqaGakhk0spV5thdZEWg3bpHGXPBy
	3P44vPZ+/zp0G4jUhJVUr25qjlNGG6wffAqxlREActPWEfDod12kWyRp+I2WNcaIKK0yNujMMvc
	HoI/nY3eNvJQJaB6JjWQYoq/rBCSG/HcvD+t2OYzz1rMAC4McIXfCSnFm0cAfv0TMmw=
X-Received: by 2002:a05:6000:2cd:b0:391:2f2f:818 with SMTP id ffacd0b85a97d-3997f8edc1dmr15905518f8f.9.1742899597498;
        Tue, 25 Mar 2025 03:46:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw5sCn6O0eZPQdrxPvOONhB4Ut43Nqsv6iiLVmfKeBePtnVQmM3EmzBo2MGDhKqQ2BMNL+cw==
X-Received: by 2002:a05:6000:2cd:b0:391:2f2f:818 with SMTP id ffacd0b85a97d-3997f8edc1dmr15905478f8f.9.1742899597091;
        Tue, 25 Mar 2025 03:46:37 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (87-97-53-119.pool.digikabel.hu. [87.97.53.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a50c1sm13572203f8f.38.2025.03.25.03.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 03:46:36 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Alexander Larsson <alexl@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] ovl: don't allow datadir only
Date: Tue, 25 Mar 2025 11:46:29 +0100
Message-ID: <20250325104634.162496-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325104634.162496-1-mszeredi@redhat.com>
References: <20250325104634.162496-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In theory overlayfs could support upper layer directly referring to a data
layer, but there's no current use case for this.

Originally, when data-only layers were introduced, this wasn't allowed,
only introduced by the "datadir+" feature, but without actually handling
this case, resulting in an Oops.

Fix by disallowing datadir without lowerdir.

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 24e16e385f22 ("ovl: add support for appending lowerdirs one by one")
Cc: <stable@vger.kernel.org> # v6.7
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 86ae6f6da36b..b11094acdd8f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1137,6 +1137,11 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (ctx->nr == ctx->nr_data) {
+		pr_err("at least one non-data lowerdir is required\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	err = -EINVAL;
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];
-- 
2.49.0

