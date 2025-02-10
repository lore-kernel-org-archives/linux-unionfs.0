Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A3824C683
	for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 19:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739216720; cv=none; b=rnFMIMnKLTXK4MZ1kSKZC3Tb+RUD3pc/zsBO7DarZA8KB6kWuD2ZuBdxRguX3lenAkJC0IPoTU8N3cdSLw8SW9K84iy6wAbZRsYG44r3cA/LXD1iz1zZ1UubmLQgV+LOMZJ2/2WacMMnTjLwm6rgPUute02Xo7s0IQkcFgcis4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739216720; c=relaxed/simple;
	bh=uRat+cUyQajKEyuB4dBz6csHrUX7Fiqv34ihZIzWhBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6nFuJVujC2JR6qsRQ+ujhNxCGWoz8tg8jF1NM7kRR0RkfNB0K6n9gojodTZkpvaouC6iptMDFiJFhGfG8EOjWBC3cMzuAVKnRhwDIT55VNtZEf+wW00oA4vyamT7G/n/OBKPfSWQX6RM+zSrz9+q2wsWElKE3Nr6rb1yk7gGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=exTWMI3J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exTWMI3J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739216718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4UE9EuMWS8G/WY3PW4PUElfvLYYRRN8pOZXqxaL6Pog=;
	b=exTWMI3JfYNtDV3DNOpF3nsIlyjUI2Du9tv55ZzqRUTq/LF4fKRYnS7fbm7E+RIF3HgWHl
	UOHZGMVAJ12uO5Kf7jNELA2Ib1X1DRZy3xHqT5/TTm+h611z8ZQPxy7MDw3Uqy5JYVCkhL
	Cyzv170H3dri44G217cIu/SN6LaXYZQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509--Zna3yYSO8uYaUT34OJB8Q-1; Mon, 10 Feb 2025 14:45:17 -0500
X-MC-Unique: -Zna3yYSO8uYaUT34OJB8Q-1
X-Mimecast-MFC-AGG-ID: -Zna3yYSO8uYaUT34OJB8Q
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ab7912ce928so386214366b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Feb 2025 11:45:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739216715; x=1739821515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UE9EuMWS8G/WY3PW4PUElfvLYYRRN8pOZXqxaL6Pog=;
        b=EmBUvPOuqvoLsvFx/mWlXVXc/kyDpZfAx/wgOmYNenv9uyVvHnC8jTthIlMG3Vi67r
         SZDZuUhssJLsoa5+/bAJeNM2LHx+bxyX7PJtq2bCxahX/kcRKe7wZyW9o/rytUiff1+G
         O4D3uakkfsejZpx3Ni+cKaqcflruUSzDw++zwwlBqM3OQ0ZlbTB6vFgZdyy4eCGbvM62
         TUgEH4U7tvbviV2bUBeKXUS6mOZ6M5Xr34wX+u2dTsgIO+JVclgxM+LskG8FtF/fXYLP
         /60IgDGgQiEG8EPepfV/vZjtQgVuFLgYtXgcClFZ5IfmOSxqV4G2BlyHEAKagHFbiaK1
         VlCQ==
X-Gm-Message-State: AOJu0YzVYBa8BzdDADUZ185y/BLY8lCtC+0HpM6EAAIgiDIx0rODdFN6
	VkH001AbeRVN8RcP50cQ7L6mJTGSsKiMPNVUDFMfs91PY/2mFlawRmu8ESvR8YGpdPx8YhCxgln
	DPiNk6oymRqz19fPTskja7eluDRU6bHeKzfshPKX5ILrABi3u5PJo/3iwsJdhB70mOFwZ2VFv0+
	h112uI8+AWHYxoDmX2bI+gSCqXd4isebSARrLyAKnd8cvRiC6icg==
X-Gm-Gg: ASbGncvPCFyhH4DC+CkcOs51Or/NWpwNsBf3yE7V8FlnpEyUdiHRJabxORnmskKTffx
	4ah/ZSvN2BT6Hl3ej0UDm9wLlanjAz+WiSHvEn2VR/ri9aga/HRBaytxjABP99SC0nPa3HKcByC
	EwhW69UTy390yvnX4KAWEn15gVPvIJjT9lvjzDOftSm7xCoBcQnKdaOx9XgHXkZaFpxCfc9r094
	EeT3jEsd9ko1RRUOktey42RdijeM2LWCjW7ZlB1l0k8TCCBP4LVR+DklszFuaQ8unEkcy93XJCo
	0ZG95PUPTuvt2yD6kGapxKyDFMG5C1OJZi0KtvYgag6rI7HpiuOuhg==
X-Received: by 2002:a17:907:3f09:b0:ab2:f6e5:3f1 with SMTP id a640c23a62f3a-ab7daf31198mr53789766b.8.1739216715478;
        Mon, 10 Feb 2025 11:45:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrs+omVoA5InHSI5b+I9wMwwSULuAuTHHS9tgGKk5Q3H8nhwHvO0O/ryPvBgmiLaperNlrlQ==
X-Received: by 2002:a17:907:3f09:b0:ab2:f6e5:3f1 with SMTP id a640c23a62f3a-ab7daf31198mr53787766b.8.1739216715077;
        Mon, 10 Feb 2025 11:45:15 -0800 (PST)
Received: from maszat.piliscsaba.szeredi.hu (84-236-3-29.pool.digikabel.hu. [84.236.3.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7922efbb7sm702006666b.2.2025.02.10.11.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 11:45:14 -0800 (PST)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/5] ovl: remove unused forward declaration
Date: Mon, 10 Feb 2025 20:45:06 +0100
Message-ID: <20250210194512.417339-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210194512.417339-1-mszeredi@redhat.com>
References: <20250210194512.417339-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Giuseppe Scrivano <gscrivan@redhat.com>

The ovl_get_verity_xattr() function was never added only its declaration.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving lowerdata")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/overlayfs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0021e2025020..be86d2ed71d6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -540,8 +540,6 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d,
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int padding);
 int ovl_ensure_verity_loaded(struct path *path);
-int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
-			 u8 *digest_buf, int *buf_length);
 int ovl_validate_verity(struct ovl_fs *ofs,
 			struct path *metapath,
 			struct path *datapath);
-- 
2.48.1

