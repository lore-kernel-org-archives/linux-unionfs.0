Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7672D3728
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Oct 2025 07:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996789; cv=none; b=AToKql1NWJz9SIpiKKZM5pj8fks1wkWb1JadRNpZm9INVL9C9+HKVIuhKRAv4lPGi2FggIZP7w6jVwe97GA00cefhes/dTYTNmI4hDPuBowH0wKgv1YsfwXDrmq5RXfsKshpK31F5oDA52XLrM+JAHt6cODQYCHjpXYx+qnHDn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996789; c=relaxed/simple;
	bh=JAU4oetIKsiFFQoxD4BOLbL092tRs1Y5zrd0wB8hP3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcMHTIlzmT9+OD+NyQ1Dg5t1z7/+2iprwNICOzhcvkFpv1AUze//2jIU29OSfNcxEyog07gyV3FR5+xVlQ1h9U5r2UaKnYQTv0EJJWUeMcDzJgiHD1qy1FcW9ckc1FUYw+OYVxs4jsj1KA1QRRECn/v66V9pE8mL33UM7vOFpbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E55vTmMQ; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E55vTmMQ"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3c2db014easo131879266b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Oct 2025 00:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996785; x=1760601585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BImMKCDjo8UcgLF4QMJ2SKqY3V/e7t3G8DgvFQjtsv4=;
        b=E55vTmMQPuIsBWpR+wSLdHpUA7OJu+0uKgWLiQNF7rZ53zbtjoDnxV2lDTzB98VXPs
         PmpMv1T+jJCUb0JKHj88embadcVYrbbICu5CdZWG/sa7KKeeHGTw8i5qx1j0JVeq2w2k
         qP76iVEv3J5a8CzP1VQJzd7AoIHyt+hCzYdmXhyAIi9fkjVhuzdUm8qap8UGoiCY0YD/
         cMZk0Joo8VFVz1XRUEgMZaFVWsIf7+6olS82P7R8EsbLGiqrnfLbK4RYvy0ceXHBlOhv
         a5XRmPQcERwzNZ5AZTbprOCXLAa31uQhgT96YekXlD0932f7tL+XC7IQ/wLfR2ovJqyI
         8veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996785; x=1760601585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BImMKCDjo8UcgLF4QMJ2SKqY3V/e7t3G8DgvFQjtsv4=;
        b=AuothU2Lby1DdwbkH8A1bBw2DcSK0OH1chWJ/lFwA7RVBufxiSimohJuKiFrdOCNoM
         0C3rKkcnTWYJKdnRHVVEjdM4wXogMOVFMg94k86xE8KZlMsVixEhLc+hvfslTlrHYHTP
         XG8QnlGaka7mULOvfvWLCM/pKytrtLrSBRJrV4+e0sLZU31n7/XwIsg6hH1hLkGr7cDo
         S80H/7KWeJ5Wzyy8ISUP8gffNYa8RPKsgInIOpB93PxhwNtpGiwmtiEZDlqTVLJ9TLDW
         nebLiSMacS4NTQyLV17+8xYwbWRTifAC1R/dPFt1mUbujdOGYSLi95JwNqZzrJUvczQX
         58CA==
X-Forwarded-Encrypted: i=1; AJvYcCWlXhk7bLJEPxLhc+Xcrk8XBEIytM/lJ7IvTAdQ1mta1zLHZ9LhOks4ChZq+DTZj3QQVHUU2/Dvw4e+JsSV@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0u0MLau8mikVwnOovrJr5Tr2NIMp8Dh3w5+QtJs+dibx7/dy5
	oRikDUmivzqIO/3l26DCsVRFK4R3mEUtEr8Eu4fhZAZ7aqzRxfXjk98vtMOYLg==
X-Gm-Gg: ASbGnctYgTFfOVc1cydn2nzIghSPqk9Mmro73qE8Ufv0KnP2nGHF8RpgwcZs5xuh6ru
	JkYcO2+bdRSWcCTOzgwec5LNL+5aVvpyZX4XC7xj9YlCgIV16CC3fVUhF16owfza/vQUeNYoZen
	pgUrUYCJB5U+AF+WPvynWX+Mr0DMltMGXlW8iUeHSg01pTLNJZse28f0VLOUEGpXBH9RYXt5M9r
	008wE3lel36MeLN2WMAlFmpgfW7mvlGb5PfBTKbQ8XB66zqyNPEyAU7b3lktBNMFcmAoy2XKRWN
	AhDcpHIJ2e34w/zmiRJs4NZJEYwKO63gluxE7W6MdSjnrTHm/eMPqFXksBGOKZJ9ZofvwKt6EL1
	wH1gl70fEFlpPVMxJI05ugDXkSIwkf1UOwDibITvCCZ8zPk9GuFgnEiKUBMmfDB1UFpbxpk4i1O
	uD9jWUWqK7b1ogu4y7ey4R7Q==
X-Google-Smtp-Source: AGHT+IENbCwcvaxD9DGquoigQ8tdDndKKU4pj4q2EF42sPm/388Ywdvf1nQR/63uusvC/5TSS5tPxg==
X-Received: by 2002:a17:907:3daa:b0:b46:31be:e8f0 with SMTP id a640c23a62f3a-b50a9c5b3c8mr785496066b.3.1759996784546;
        Thu, 09 Oct 2025 00:59:44 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:43 -0700 (PDT)
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
Subject: [PATCH v7 03/14] fs: provide accessors for ->i_state
Date: Thu,  9 Oct 2025 09:59:17 +0200
Message-ID: <20251009075929.1203950-4-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009075929.1203950-1-mjguzik@gmail.com>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
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

In order to keep things manageable this patchset merely gets the thing
off the ground with only lockdep checks baked in.

Current consumers can be trivially converted.

Suppose flags I_A and I_B are to be handled.

If ->i_lock is held, then:

state = inode->i_state  	=> state = inode_state_read(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state  	=> state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B) 	=> inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B) 	=> inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B	=> inode_state_assign_raw(inode, I_A | I_B)

The "_once" vs "_raw" discrepancy stems from the read variant differing
by READ_ONCE as opposed to just lockdep checks.

Finally, if you want to atomically clear flags and set new ones, the
following:

state = inode->i_state;
state &= ~I_A;
state |= I_B;
inode->i_state = state;

turns into:

inode_state_replace(inode, I_A, I_B);

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/fs.h | 78 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b35014ba681b..909eb1e68637 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -759,7 +759,7 @@ enum inode_state_bits {
 	/* reserved wait address bit 3 */
 };
 
-enum inode_state_flags_t {
+enum inode_state_flags_enum {
 	I_NEW			= (1U << __I_NEW),
 	I_SYNC			= (1U << __I_SYNC),
 	I_LRU_ISOLATING         = (1U << __I_LRU_ISOLATING),
@@ -843,7 +843,7 @@ struct inode {
 #endif
 
 	/* Misc */
-	enum inode_state_flags_t	i_state;
+	enum inode_state_flags_enum i_state;
 	/* 32-bit hole */
 	struct rw_semaphore	i_rwsem;
 
@@ -902,6 +902,80 @@ struct inode {
 	void			*i_private; /* fs or device private pointer */
 } __randomize_layout;
 
+/*
+ * i_state handling
+ *
+ * We hide all of it behind helpers so that we can validate consumers.
+ */
+static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
+{
+	return READ_ONCE(inode->i_state);
+}
+
+static inline enum inode_state_flags_enum inode_state_read(struct inode *inode)
+{
+	lockdep_assert_held(&inode->i_lock);
+	return inode->i_state;
+}
+
+static inline void inode_state_set_raw(struct inode *inode,
+				       enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state | flags);
+}
+
+static inline void inode_state_set(struct inode *inode,
+				   enum inode_state_flags_enum flags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_set_raw(inode, flags);
+}
+
+static inline void inode_state_clear_raw(struct inode *inode,
+					 enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, inode->i_state & ~flags);
+}
+
+static inline void inode_state_clear(struct inode *inode,
+				     enum inode_state_flags_enum flags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_clear_raw(inode, flags);
+}
+
+static inline void inode_state_assign_raw(struct inode *inode,
+					  enum inode_state_flags_enum flags)
+{
+	WRITE_ONCE(inode->i_state, flags);
+}
+
+static inline void inode_state_assign(struct inode *inode,
+				      enum inode_state_flags_enum flags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_assign_raw(inode, flags);
+}
+
+static inline void inode_state_replace_raw(struct inode *inode,
+					   enum inode_state_flags_enum clearflags,
+					   enum inode_state_flags_enum setflags)
+{
+	enum inode_state_flags_enum flags;
+	flags = inode->i_state;
+	flags &= ~clearflags;
+	flags |= setflags;
+	inode_state_assign_raw(inode, flags);
+}
+
+static inline void inode_state_replace(struct inode *inode,
+				       enum inode_state_flags_enum clearflags,
+				       enum inode_state_flags_enum setflags)
+{
+	lockdep_assert_held(&inode->i_lock);
+	inode_state_replace_raw(inode, clearflags, setflags);
+}
+
 static inline void inode_set_cached_link(struct inode *inode, char *link, int linklen)
 {
 	VFS_WARN_ON_INODE(strlen(link) != linklen, inode);
-- 
2.34.1

