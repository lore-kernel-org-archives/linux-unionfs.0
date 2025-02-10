Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BD724C663
	for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 19:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739216720; cv=none; b=G6Pbh5sXo/PNJk3tGjRaXxb4HWJgbVXmcq1WsjUdTadA82dEZHHE1Oq2xCBx8E06oEbhmvOfNy1HgvhwXMOpL4kyfelU6gKRdkbZOszjlcxj3ssZwE3JLrltUJJb/0dXo61yHAAaif4ycp3e6WwEmYaCyY6c9IqBWSMBxWQqE9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739216720; c=relaxed/simple;
	bh=dz7LxZV1nfgCzmAuep2NZbFxKl1hjyf7lLkOJCVdldw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=idLHTHN/EyLifUYzKI56KJVcx1Z77XEhqPwvQBhkaZEF5JRrKKLsyBGewLvOGS6F6k8Q6syR3NF9ys+R9XzwHLsGvjJRYfyt+zS8DT1gfCaD/kSiupnrWLNpf4547zJIt+DfHhL9LKNnzzuWZ3lYo3w01wUc5vMWdVLu3o2H1zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XY1IkaGU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XY1IkaGU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739216717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QqCXjtSE10Zs+4B0p2/DvM2wnpUl444vokiGOL6h4dA=;
	b=XY1IkaGUj6rIW+axO+K4aT5D4X2FJayNGMOw3lJkJvY7+IwuhJsM3F3hQSU+K0o4Z9oVF0
	HIPjUl1EHEbtZy0PGm2EvQT97ZY7r9aqopKLPq4nBp+wtyLs6wDySy6UQyMDRm6cS5irFj
	/wRIKUC6I7ZY6CNTyl+CW8Vi0VEtSWs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-bz3Hs34mMrqpBOSvmkgqSA-1; Mon, 10 Feb 2025 14:45:15 -0500
X-MC-Unique: bz3Hs34mMrqpBOSvmkgqSA-1
X-Mimecast-MFC-AGG-ID: bz3Hs34mMrqpBOSvmkgqSA
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5dc5beb5eb0so3719724a12.1
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 11:45:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739216714; x=1739821514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QqCXjtSE10Zs+4B0p2/DvM2wnpUl444vokiGOL6h4dA=;
        b=qPSmBFrh6DZqVuh7hJg9NPbPYEZyJ+dEXn2t/kxP+xygHQwT01C6zMxdrJFZAT0m9S
         m8kdAevBgn0TyVGC84Z2jxfERDF6698196hwAbA/SihwC5M0c24IPkmjKIt3YOon35NE
         xR2oQEPtrQ1UeCLsAFHZv9u8gWfic1hyEXk00c57d6u9ZObw0NZBimmVS5zu3mdOdfii
         qJ3RLYniOgYTeJ05NFLYd9DF7+wTNvUB7k8BgBaer0kfD8RA9XZtZkD8uSO/w4D5/xDz
         Jff3hSPLSy+38ognqqblqjSNjkh1rDSPrwfg+pfO7QMRrjZ2yjj9aJL/rOLc3TvuEIXR
         tt6A==
X-Gm-Message-State: AOJu0YxuH9ldiz65fjOMiaxa+TxqKb/0OlzF92MArVN6ra0nXWOQChBh
	XGeOwkteZEUaz5o8jbUdJzaLgwuH5wi/ZLFfiwp97PJ9sb88jLdPBtuXpUq+xaA+bnNpgazKpWl
	JcNzhjwiaQUaGaifc6zsVQu95beNqLKcMvJ1Lbo1DTt+uraeLLCGToIk8q3RX/2zJXs4lwvYGuN
	ik5DcKT/GH8vUTGsPcgxlKyMSgpIedL1sZfthnkbmC7U7Ut3ipEA==
X-Gm-Gg: ASbGnct3pGbw0OlWoZQ6kYsUBHdkN5VDgXfY1Ip5mBJtgNk5jX6QYLLFCSYNuEae4+M
	FCgCLCVbwCmqWG1lDzZijdYlWDxXQkYiiVYUaYislrzoHwYUvienmqV6WD0jduDXKHl6Qs+409N
	jqnBndm6aolMtBsmtCt9EymjbY1LCuCITw8B0my1z+d967RpbXyxVKDqXC67Hgyf0yvwP/JjepO
	6fjg7aIjD+1s/SABe691gIvxI7LafXmV82zFuO8AjUrb33i2bI5kiSrn3WpdbDKi8vg1LNcY1t3
	qkaDtCQKkwUIUez/OSYwEmcEukmOk0q4XvmF6sd3abm4PAWskejMIg==
X-Received: by 2002:a05:6402:5386:b0:5dc:74fd:abf1 with SMTP id 4fb4d7f45d1cf-5de45017b76mr39887456a12.15.1739216714275;
        Mon, 10 Feb 2025 11:45:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFkVngYg1NEXt/C5/FojOQgVIut41Geeor5s6D+qJmWdODol38eHGIfsFnlwT7mUxGvmQgf7g==
X-Received: by 2002:a05:6402:5386:b0:5dc:74fd:abf1 with SMTP id 4fb4d7f45d1cf-5de45017b76mr39887397a12.15.1739216713837;
        Mon, 10 Feb 2025 11:45:13 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (84-236-3-29.pool.digikabel.hu. [84.236.3.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7922efbb7sm702006666b.2.2025.02.10.11.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 11:45:13 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/5] ovl: don't allow datadir only
Date: Mon, 10 Feb 2025 20:45:05 +0100
Message-ID: <20250210194512.417339-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.48.1
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
only introduced by the "datadir+" feture, but without actually handling
this case, resuting in an Oops.

Fix by disallowing datadir without lowerdir.

Reported-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 24e16e385f22 ("ovl: add support for appending lowerdirs one by one")
Cc: <stable@vger.kernel.org> # v6.7
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
2.48.1

