Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1397D45DF6C
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 11:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807357; cv=none; b=rcGYGZgmH40I7WwNh2cOXUf2n8n6AgaIngtbkshJWBM0uuOa5CYQPN+YOZUvv2cWw7lOYo/qXO1WIQUPr6p7NQDVSSTBZ4+8dhoVnSUsA1ASRkqBHhVkWMkRPRWnKd6iZQwNsPQr8pz5a+Qin7j1Pl4T7cFFn+UjnRFcWSxkRQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807357; c=relaxed/simple;
	bh=yw8TD+KZcKEy1gNKvBPU8Ftjuxo08mQRXLrdb9CLtPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzOaTjYNzY2UHVVfJpEp4W6aZhIVzeRbmRBlUFVL4AtRe1/z1I9ydqVxOtDuBUtRxGNVhfGh62aDUg6fGpt1tfWQ8UUs0GIBtsqVzsNdoztm0LkVuBTI+78cXZUvPgW1bty4jsAhPfc7jzmDnq2e7LZnDPWJ89ubPSKEhMZ/qVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YsPN0Paf; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsPN0Paf"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-69e28b554ceso946993a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 23 Jul 2026 04:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784807336; x=1785412136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xz/m+fX2i+fUWdXbPZIahRwxObYoI0qXtVZ2x9IsBFs=;
        b=YsPN0Paf6OslhnbtX0x7P368FtTVape1a0mrk8sAl/ubN2izCplTOeYD9e/FHY9Vf+
         Yu78x3IbM4zJguVjVIrBg1TTJlib6XKMyU9n8iSe0Y720MTL0BsdX8ET2vXoBToEremf
         00+d/xn7A2AV49Qktd7XqoUgZ6Bwus3goaBGQ1Pk4EOjPgjYQDoFkvyC2rNDsN2esaNh
         x+hY2C4UlkeSKZ6zypvXS2rfhh3KP0RzWsWP7gtoUgAgys50BufpDOA1ehNXDYRDhQcL
         4YLTlQmWCOQvc9vVtHq1XKGFZTokFCiFdzgWDwF3OilwxpON+DAwLymWrF8pnNMG1DYP
         QWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784807336; x=1785412136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xz/m+fX2i+fUWdXbPZIahRwxObYoI0qXtVZ2x9IsBFs=;
        b=NwPZEp65LTL6njcJYKznOmTXccwvN3atd3QJa3/aCtMb5KQAsJVkQbIbjroAQiaA/z
         NFRU6QRRrDxfIqpwuev7zTs4BKquTarp2MlhpUvoV0LfjFmIrGRSKkmHWs/HxvoNi+pQ
         T5RtsTtZ/Doza8rzLjg8jteR9DKOOGFpkDm6ONxV9RPoP9tVRb9Y4/M+FcWpb7L/mMXc
         Gg94PliSmTPL826PE4um2editQXoYmkzjGg8gGHNob3jT589hPChP3NiUxz/4VeI1Tcb
         +wSpk7JqErAt0ICaSGQJwGSm3cnnzy+4iG8NyeGUOhewDIypr+s/B7IiUM3mmaUWgULg
         A6KA==
X-Forwarded-Encrypted: i=1; AHgh+RrUjuUe4tvKa+MUZ/k1pNEOgmU8sEfTfs7uuPn5nud0r/UTXFZ+c80v8yYlxzs4bSDKfCGSE1ZM7MyRCwg8@vger.kernel.org
X-Gm-Message-State: AOJu0YwRpMMnSCAo8kDjjuNTq+sTndosPYc9tpGZVp0q2IxDgboq1fsj
	BPdw9g5Z4rRQbD4SXL0hgSX8Bzu1Ri8ojeFAuB/AJEn5sPFyZcOvajiI
X-Gm-Gg: AR+sD12cE13Cz0or4bRKPOqNEI8WOibmdXfpYk7wNp7CF6/U90xJoabDaPrhAan4R/o
	BzRm3gwp4iCPATY3dRaPv1/SWeuGUoKFIeaqVA3bw1nDv8kZxKr3tSjHpRWjO7sx9FWbmHh7Jsk
	em8Jboezhiubg7A+5TT9FE7p7AU1QYQj++ehMv2DfPR3TtPAhlAtzEeVsrVp7gWyNy/iGt4zIO0
	rLpCUMJtd5S07mZ5yA28YzgftPN2rTXmqObSfXEaalnsMUd8Z+u5moH8XD34L+IG2vK4Oqs7wmO
	SbZEZHl5hDQSLFAz/yYK+J7tPH/chAix2clu7BqoMu/xnwHR9m8qcMOIc2GIjfSQ8hqfNR86bkd
	AxlTfy+mPE4i9o6GGzpDlS2mGRrF0w4hTqzaYO1h0DUwMxec6xsh6uayJ+LfBTIwPfeKojg9JqO
	fWTjlPHX570rDG+ap8GebdrrRNNQI=
X-Received: by 2002:a17:907:72c6:b0:c12:6c88:bb33 with SMTP id a640c23a62f3a-c1c50d05f13mr144470866b.65.1784807335514;
        Thu, 23 Jul 2026 04:48:55 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32f13cb4sm226388066b.61.2026.07.23.04.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 04:48:54 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 5/5] ovl: add support for copy file range to another fs
Date: Thu, 23 Jul 2026 13:48:48 +0200
Message-ID: <20260723114848.1212429-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723114848.1212429-1-amir73il@gmail.com>
References: <20260723114848.1212429-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is technically possible for overlayfs to copy_file_range() to
the base fs of the real layer.

Implementation of copy to other fs is a bit more subtle, because
we must not take the other fs locks in overlayfs code.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 169a48de565e9..cc52ccc35961f 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -535,10 +535,23 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 
 	/*
 	 * Overlayfs may be able to copy to a non overlayfs dst which is on the
-	 * same sb or same fs type as real file_in fs, but not implemented yet.
+	 * same sb or same fs type as real file_in fs, but we must avoid taking
+	 * the locks on the foreign fs.
 	 */
-	if (WARN_ON_ONCE(!is_ovl_fs(inode_out->i_sb)))
-		return -EXDEV;
+	if (unlikely(!is_ovl_fs(inode_out->i_sb))) {
+		if (WARN_ON_ONCE(op != OVL_COPY) ||
+		    WARN_ON_ONCE(!is_ovl_fs(file_inode(file_in)->i_sb)))
+			return -EXDEV;
+
+		realfile_in = ovl_real_file(file_in);
+		if (IS_ERR(realfile_in))
+			return PTR_ERR(realfile_in);
+
+		with_ovl_creds(file_inode(file_in)->i_sb)
+			return vfs_copy_file_range(realfile_in, pos_in,
+						   file_out, pos_out, len,
+						   flags);
+	}
 
 	inode_lock(inode_out);
 	if (op != OVL_DEDUPE) {
-- 
2.54.0

