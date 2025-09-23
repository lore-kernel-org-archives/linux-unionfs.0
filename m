Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE46332142D
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Sep 2025 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758624447; cv=none; b=QMx8RVae7A/8d6sdDKDvA4KrKq11Wmp76vk24kbYdbnckZkYCpGUu0VPvbgSNtim1BojwW9xtLBxVtRtzdvyfKh8BMXR9COqr8D7Aoc/wlE/pqI/1kd790QvWRfGWSXL6qY78IOaVqEMFLh6BdNFslXo/3jyt/SUWMPJR1QHxRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758624447; c=relaxed/simple;
	bh=l2+XRRMMlUv38cxkDkgsNP7PrYQqTHAOPnKjsX3NKpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cvz7viiStrdaThBpo8r0a8Wh+Md5gN9fH6/C7SRlnfLgbo9gETINpOtnBognIO3wE+WnfHrKvKMGmJsdvGOsWGWjgUOr4wdS9HymincTfueXDbPvDF40VEuEw5qnbCeFW1jTvyrhz34s5nW3DUhZDSiPJbJMS8uRjYnQMhhgDsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMiDhOih; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMiDhOih"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46dfd711172so15207735e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Sep 2025 03:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758624444; x=1759229244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wY/sdmBMIe7/evMOyoyNDBqGuIEYNCftZNVDhHEUu68=;
        b=FMiDhOiher0WYGTvi9mlL0UHvwCKsGGmjWkge3xsWfv/uDzLFpbP40NiXIRMUUP968
         xwfEckY67Oh/E1gCkApvZxxe7wm6INY2+PfRri4sRHZaVJf4VH4MFohjjbV1yLhbrQxa
         lCOhz4kRZejjx8sWCcm9SeekQG7H+5pEgj/QwQxYDKdtPvmq51GHckIGEYdxBvp+43N4
         TQXV12quwS3Y2e3xL1iAppawPO1vf2BbQCcO3YiNEbW9LzcTsFrws8GNCQQXtkGQxfNH
         wy+seOz/vpZ2cdR+r84jaFF8A3IuG+Id/1OnsEzN5y25ZVX/k6owrKNrmSUGyBAYdfLY
         zsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758624444; x=1759229244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wY/sdmBMIe7/evMOyoyNDBqGuIEYNCftZNVDhHEUu68=;
        b=Nt20K8oHfdM1SpWeriAlbraAOfxZavie+YzgHsBezfdu78amph9fQ/ETpKqH6mhQDP
         ZFZ0yU7uhPYBxxPA/r53MSXnIgYbS/x+lmGrycqLZEhrrM7gTzM6Wey87UAiYAYzU/aG
         x7LWgTuCxVKwGxJlHWWUT0UWfu0+GZdtHOuoY3ELSGl32q4s75jK8SULrSWd9M2oz4vf
         M3iBfULmHx45MBxRpIbdER9mMAgOD/KXaQKPmXKX51KhIi4mZrRsOznvfcpvfF6BCFEK
         gSD7vin2yflexbBNZGW7K3Hg7lsWxRdodQ/xCHQWZCO/oJzTQ+y20lCNK/CY/fiTc+KB
         +d1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxRJWSOgBWK6kyLAHGQWReGnQtEsMFKg0WzA1EqOYj7MZ9sSeXdGN1YuKQQGC5XWHeOPyxw1a7rrAQbUKz@vger.kernel.org
X-Gm-Message-State: AOJu0YzXvGYz9rOj8VerEMz7YfIPrbew4uj+zvqo588axS/EQ7g+y8PG
	hG8rqN38t4ryXec8kfUp5adRIO4gcBt8cqv+G9RCKXXlQ9nHF3cGhpo5
X-Gm-Gg: ASbGncuDMGAQpLzhbJ6HTDAcui7Zew715R8/VNzxp5OIfc9kj8UpYC5OxFfAoxv006S
	mNwDfQ2bSyObdkVq1x1SYAp916HOjbgIcs9ONziIAbbsZZNktCpWpvh6P0YrM6XCbjL42oEw/Nc
	Wv6u885Si30QzFSQuGZLPMON9+ZKYb+QNSVAFrJF69viOwIvI7+KtwTdpyQFaK/EjSfn6F6AHTI
	322mGxXFRpNlP+2vz0fovmZDvGxDuCAMjZRapz6gI6FMGN/Mun268G4Nx297pvju+5xSWrwyiPi
	+O+CBfXC6iAaY9haGi2Z2tG3U27i0mcmh0ticJXGmh2RfbTfuBaFDKngLruNLIjDJi9MRRPb4d3
	us4lI4/fFNHyP4ZH/CUi44aV9gS3MmvC14kIjKwgnwJ24faK4qfEIDe1uFQJBcmHfWwU2R9hdg1
	a79Cpu
X-Google-Smtp-Source: AGHT+IFG/viu/Q5UoxWFmn6MCDA3PwXtIt4JmmoJtRIj8itygK9JQbD92sFVJjS9mxr6/B7iPXdZCA==
X-Received: by 2002:a05:600c:c8a:b0:46e:978:e231 with SMTP id 5b1f17b1804b1-46e1e0aec9bmr23755185e9.17.1758624443810;
        Tue, 23 Sep 2025 03:47:23 -0700 (PDT)
Received: from f.. (cst-prg-21-74.cust.vodafone.cz. [46.135.21.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e23adce1bsm9710525e9.24.2025.09.23.03.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 03:47:23 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v6 1/4] fs: provide accessors for ->i_state
Date: Tue, 23 Sep 2025 12:47:07 +0200
Message-ID: <20250923104710.2973493-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250923104710.2973493-1-mjguzik@gmail.com>
References: <20250923104710.2973493-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

Given the late stage of the release cycle this patchset only aims to
hide access, it does not provide any of the checks.

Consumers can be trivially converted. Suppose flags I_A and I_B are to
be handled, then:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_assign(inode, I_A | I_B)

Note open-coded access compiles just fine until the last patch in the
series.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4fd010cf5bf..06bece8d1f18 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -756,7 +756,7 @@ enum inode_state_bits {
 	/* reserved wait address bit 3 */
 };
 
-enum inode_state_flags_t {
+enum inode_state_flags_enum {
 	I_NEW			= (1U << __I_NEW),
 	I_SYNC			= (1U << __I_SYNC),
 	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
@@ -840,7 +840,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_t	i_state;
+	enum inode_state_flags_enum i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -899,6 +899,35 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | flags);
+}
+
+static inline void inode_state_clear(struct inode *inode,
+				     enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
+
+}
+
+static inline void inode_state_assign(struct inode *inode,
+				      enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, flags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.43.0

