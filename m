Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1871EF0B4
	for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 10:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742899603; cv=none; b=WV4NgXRgkBvVLPssvbQoyR2FQAFYMqkqTJ4g3XVp42aRe3EDX9/JRGtci4nJjWcBwvz54WRR9OVw/qKh8VNKOyN8a79ggk9o/+ww4gpp7eeC6oRTg2w5py57VZf4qkmAn8eF8TZ5y5OPexzxBTaO10zM4yjQYBVOE/2dDhbvZLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742899603; c=relaxed/simple;
	bh=A2MAB2OVxVruIya4DNf3xEcT8dkPUjuHu37dCQmkK/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLJjl0Xm6SVhttNh9j7+nFCey+Fb2fBC6QzJd9uVXAd5BG+JQ6PvYbTv46SzE81YMGqVMmRNGXyFGO9RJJca9pq+ndENVR1oZErsULWIOY4bV7uGN8okRbKEL0Vpm0W2hgXJq721RtMax6V3M4shUTqG+TSCIM17KoJQhPJ0KII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDcJombd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDcJombd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742899601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmfiCZHWD0A3bKyst7i0VZyUuheFYdh0T7DksOUWd2k=;
	b=hDcJombdP50+89/PPJ4ksO3e/Dbj2qrgCdadCZgT2W1T6TnD4tvBOVIQWOfLBvjP65ozI3
	nnCxjABCgeBs/qPjQCaifpoM7SmPOtagWqV4Y75diA+Y7eO7h1eHDg4ijYXdhspKV+Pq8E
	cmvF3Sct/y3yEe970iL4HkRxrt+HmsU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-J831e7G2OfCc3_HECD6Hzg-1; Tue, 25 Mar 2025 06:46:39 -0400
X-MC-Unique: J831e7G2OfCc3_HECD6Hzg-1
X-Mimecast-MFC-AGG-ID: J831e7G2OfCc3_HECD6Hzg_1742899599
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-391315098b2so2132496f8f.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Mar 2025 03:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742899598; x=1743504398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmfiCZHWD0A3bKyst7i0VZyUuheFYdh0T7DksOUWd2k=;
        b=L5h44rzFaDATzPdIDeLlf/BG06tRrDcS5FwDJvLzPfImUZ+yjclO4ALlHahigGkNfZ
         awEdmwhj03UaMARKidp7Q0giN2x9HQlE5g+r+siGGfrjTeAXpBbSxYD5t2c+t2ddjs9n
         OcNXREbaFLgH9iEaN3v3mfszLehAEq1KwTvdToykiCNwd/0hR8bdSl3NQb2mJAotbeyA
         KzxN6dxFmaIVTFBSyzEqAxp4QVhLTvsCJAijtjFit7ll4H3A66RGnG63CG7uQautE8Hf
         shvXTybd9eAA2QH8IixYgXSFdM9+ktfUKOe/WZaiPyULrB0jYPm0/7snWaCNjpQOmXvI
         ppaw==
X-Gm-Message-State: AOJu0YyFQ9fwVFAVob+0S8dyF/Wd0Z26HlZrxoc4p541jvODEXHa//kB
	RjrIlT5f6WLB4Bw3Z4P1QIqmrJjnXJlCgBlKwkLDMvQydbmtZrjRKnNXgBRVLd01LuCpalwS13k
	Niqa/6TZIbHyDAlZhUsLGDTPwOsFYYEm3swxYQrUCYniil3TUfFgPuEyE22x+3NIvEGga8nUJvg
	y1vKJl+N3Mr6pmyiP6/sf6b04Hc/dbOOYn5LWeL5KjN/gR+c4=
X-Gm-Gg: ASbGncuwj7pJwa0vQQmd8ZBNkftr+eX6RI6Ew+E0owglE/uNhSJ94FE9Wxwybzgasvo
	sWccioDnb6YME/zQQ4HPbbW6nwpdAz9V7jUktcuf67mzt0GygLOwl+cPRYV6dOyjMJYV+wAax1M
	F2u3iyPbwR1SeDB2Z1cWMIjqapi9xwMbXZlmU9W+NMASOlH6ezdeSPY5pAqYjfqOUMCRbfKXQxA
	hoPqwbxVv3h79JXjP5RXLxEM8rjDk60D0VhrHxzMuqhfirbozg6B08O6IMhxFXjPoEavPiY+5if
	VDfB+zF1PUOHkSmE+y/9dGkuD6iJBg/8ekSjPTClaH8Hkh3xJ5WpTl5WyaKH4uawYKs=
X-Received: by 2002:a05:6000:1faf:b0:391:2f2f:836 with SMTP id ffacd0b85a97d-3997f8fa7f6mr13206190f8f.17.1742899598615;
        Tue, 25 Mar 2025 03:46:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIEw0CctFzZmufeUGJGyZuFijGYL4BzledWUp12aifF3ZxDHZPmWLvGl/HUY9yjW5VnNO+Rw==
X-Received: by 2002:a05:6000:1faf:b0:391:2f2f:836 with SMTP id ffacd0b85a97d-3997f8fa7f6mr13206161f8f.17.1742899598259;
        Tue, 25 Mar 2025 03:46:38 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (87-97-53-119.pool.digikabel.hu. [87.97.53.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a50c1sm13572203f8f.38.2025.03.25.03.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 03:46:37 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 2/5] ovl: remove unused forward declaration
Date: Tue, 25 Mar 2025 11:46:30 +0100
Message-ID: <20250325104634.162496-3-mszeredi@redhat.com>
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

From: Giuseppe Scrivano <gscrivan@redhat.com>

The ovl_get_verity_xattr() function was never added, only its declaration.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving lowerdata")
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
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
2.49.0

