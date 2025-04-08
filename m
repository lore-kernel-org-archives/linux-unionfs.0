Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F3EEEB3
	for <linux-unionfs@vger.kernel.org>; Tue,  8 Apr 2025 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126819; cv=none; b=ugBraM5PlTwSk4v5ORPWWePcpDNF2BWUzWNsEirz0Mh5eQol4vO/XFPUn7VE17hum+A7Ay9CpAGZMd9MU1CZ9VQQsxlPSr+RxE6f202BZ/9Gx0/RNpTaxTwagHtWvwqnLigM+FklJ3CA3uL5RP7vjOUb/YZWPeUPv93778P0K4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126819; c=relaxed/simple;
	bh=tr2GFQHLxDyISA7tcU6h5xEZDPA2OCE1VprXQc2sqNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DtXC8scb47VLFH9yeaGCoEAnGC1PodsGlJVfdnvd6DNaWhQvDLLOMLz5v6PiPE47p/aI8LYN2/wRV1aHsJgfaKL9QrYtG73tIRhEVV/CSW1IXJg9/TcyyGPGeHtpn4o5srblgNHqLim5zAqDT8gl9Rob2YWS6FMycbPAxfgpIco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iEKBOxAY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iEKBOxAY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744126815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g4gfSoeyD899RYUElUCd3qC68f8Y+7MAsXHlxR5UuBs=;
	b=iEKBOxAYWOVrVZs28YDrDCwyk967pQ5awTdgBGeWnEaxLlt7jELUij3IHZuRa26aGnKLq9
	eQScxWBZpPAAYsh2yZ+OKZl1rfpM0XbbcSppxhq7BfPIyHA7dm1ny2iPvXtVo9l6I6//m0
	WEqPUYjbe9L+SO1j6n+72cQMT+vR4o0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-GtEmrDeBN0SouE3SCd0YmQ-1; Tue, 08 Apr 2025 11:40:14 -0400
X-MC-Unique: GtEmrDeBN0SouE3SCd0YmQ-1
X-Mimecast-MFC-AGG-ID: GtEmrDeBN0SouE3SCd0YmQ_1744126813
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ac28a2c7c48so585050566b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Apr 2025 08:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744126813; x=1744731613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g4gfSoeyD899RYUElUCd3qC68f8Y+7MAsXHlxR5UuBs=;
        b=a0uWZVgviTTL1wwb6R6Q4gXsd5XkDPz1Bs9ICNtSdXquuvh3jXqSDXf1I/oGYMVwos
         D1aRZPGvTekifV/k/LKsI6c2Dm38eS2F9Ar7ebDlsCqVeGKC6Pppnj+9ATpyF9LYkY6D
         m9ojwUJCy7D3UqlEDUXO1eDEBZohN7kIJnEhsugCmqB9SlcYur9g+y8fhADlnpIJRr8v
         dl6zOrn/TikxlclZsGAA7HBkLTsX7mZmFn5rGTw/b5OTGTcOXBWR10B/Tpzx2fPS0Vmc
         pNwyeIjEloA7GbXlQJ+vjkGTYHrJAloumLkfyGtouu8WbOwpyIRfANfms3I7Np/F/WBB
         m/6Q==
X-Gm-Message-State: AOJu0Yzi/7wf8rrQNwP9iwSXWbzNtXReOcdaQq/MqTq2Ge/3EoodAR8U
	ZN1B5tUUqI38KOkN6cEJClgG/dI0VOPWxbMDTBZ+vRCSKzbT2cVrmPcsCPKY98KEkzrOGsf1zNz
	YCuslIVuiVzDi0GgTVXzf0dmSvV5WFct3CA4WcavlXnKwDQPgaczTZYuVuUz95gqFlUfg5HcWDm
	NfO7OOQOnwFMnWS1yDemPW0RI+Ngl7Zt321Hx2y0ZIornZT9k=
X-Gm-Gg: ASbGncsp8DB3Ab1lmzfJtMEc8wGfFVY41ur6feDGr6mpNendVdw3FBiQRREf9rU/Wn/
	45Bp2SKfZhwiXYoslomI4VWQu1Kjb8tDhQPfb2fK5ogcOCyNKri9vTw4tFIG+GaHhoP6W1RXGF4
	ZtXlXrmKQmPydOzUO1g4dzXDPLBJHyr/0RvxY3V6vmpOTHSLqdoBDl0OQI54Yn/wbLgB7bfu2VR
	5wH+9FSz+W8u6Y+THoMdFvaK0Lczoluf+vWLTwBxupfxYy1CunjzZi4oETqPdv43daxpxtCAuPN
	SlC+kUB95Z8dFchny8yI1Qkzil1nshMRqrIk/j+1II7OK1DNM7BhePbP93Cmp/Q2ZXLUtRH5
X-Received: by 2002:a17:907:2cc5:b0:ac6:fe85:9a45 with SMTP id a640c23a62f3a-ac7d1b9b63dmr1750174966b.51.1744126812996;
        Tue, 08 Apr 2025 08:40:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFislNdk+jIsGmhhkMWGpFlnXUgxPfIzHkFJjpV+b78lIuGyjHEMGyI7Dfk5MwGiI8Kt2yLNA==
X-Received: by 2002:a17:907:2cc5:b0:ac6:fe85:9a45 with SMTP id a640c23a62f3a-ac7d1b9b63dmr1750172966b.51.1744126812603;
        Tue, 08 Apr 2025 08:40:12 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-212-63.pool.digikabel.hu. [193.226.212.63])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01bb793sm927553766b.161.2025.04.08.08.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 08:40:12 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 0/3] ovl: metacopy/verity fixes and improvements
Date: Tue,  8 Apr 2025 17:40:01 +0200
Message-ID: <20250408154011.673891-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The main purpose of this patchset is allowing metadata/data-only layers to
be usable in user namespaces (without super user privs).  The main use case
is composefs in unprivileged containers.

Will post xfstests testcases shortly.

v3:
 - consistently refuse following redirect/metacopy for upper found through
   index (dropped RVB's due to this change)
 - move redirect/metacopy check into helper
 - remove verity -> metacopy dependency (Amir)
 - stable fixes moved to git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git#ovl-fixes

v2:
 - drop broken hunk in param.c (Amir)
 - patch header improvements (Amir)


---
Miklos Szeredi (3):
  ovl: make redirect/metacopy rejection consistent
  ovl: relax redirect/metacopy requirements for lower -> data redirect
  ovl: don't require "metacopy=on" for "verity"

 Documentation/filesystems/overlayfs.rst |  7 ++
 fs/overlayfs/namei.c                    | 89 +++++++++++++++++--------
 fs/overlayfs/params.c                   | 31 +--------
 3 files changed, 71 insertions(+), 56 deletions(-)

-- 
2.49.0

