Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86442D2489
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Oct 2025 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996787; cv=none; b=izGJdzAlJG27bID0moIkNXX/J0qS06j9SpfqDsnLzxS6IpW5gFj/IX1WX8j61tBl2fdXN+57KjbBNgC+qfC8zhFt3VLZP4hE29CtvyITCpPmCLOjL9iuV/CLQjPWta9ps6cYS1BW246qfaVFltsg3dFrGj8wokQNQk7DbNUTjKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996787; c=relaxed/simple;
	bh=ASNy7RmtSltSBzEynaqDPxE2iqjwE0ZPcjj4whWJ4kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtoNtp/BCg6ie/tQyaYTMrLWtaqSk4jPrsbTFdxIDcCSDVR4Jxxdrykyt8kpnB6hV+lY9q9Q368exH4U2kykmRWwLJ1Q2+eMRHrxrVYk5j4MLmnoCSSbXyo3ZivX0RZjp4J4MxkqYKvmqhXj8E8ip+iSmQEOAfla2a+aauiTlZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QK8TLnBV; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QK8TLnBV"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso105132066b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Oct 2025 00:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996783; x=1760601583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hnyVCyplzK+z1W2ORGsEbSjRDIE71IW/QrGYX9ePnTE=;
        b=QK8TLnBV8F6IPKH9b//mxMoquBU1AYrHverDd2jJnQIsgDXYysnPt+5qBsl4ki720U
         3ocIW7Jcipyxz+FB5i0HVbJvTq1bAwhiq0szN2RgKkAbWEjK59xK71mA/UXyiIHGLjks
         i8X1rXeYq/6eOyN9qk6y7SDbeKEfkeMPkSkycmy6w9cX4IbDACFodVHNf7ayS2tuQQzf
         IKbgSxng/5QEfd21nDFSwlasUSaPDixT4WIxVsZxCU8P/0dDBiGiYR4j/rTXKjR9ALI1
         mumT8GIbxFNYEvHLNz1UYKyV+o9ECQ3E/6bbvg2TYrcGqhvXosgo02hjcVjVX1duKbm9
         ES7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996783; x=1760601583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hnyVCyplzK+z1W2ORGsEbSjRDIE71IW/QrGYX9ePnTE=;
        b=PpWwKq2rxuc8nFNfIAvafj4tx5GDxTgDfjDceLot+3Jsx/aaZvaTpr/0wXt8phddOi
         CIvCVnFadmteomgDeVcrhReEQioGqcY1t59iAeHJUz95YZYbSNCZzjSlrqnI6gRKzJq1
         BfPpeNI1KVKC3PpAb2RlhS6sFeUVvq2M1/WDGvNb4s/Hh1Bv3r6YwEYOzdOQWyUWe3oM
         l5QRT/ypMklFQ/kip/dVAe7frHhu4XxKKDXesGxx28EPjmETtEmkWGDU5DD0q/E3bDJj
         jPAcESkoHS5b7ntOjfYKsoyOOGCTSGUqSqcBHaQV8ZxWmJfRY1smySxQpZSKpF8iVTN7
         Guog==
X-Forwarded-Encrypted: i=1; AJvYcCUrl0+3yzSW2Bm4jpDFPdj42fuexZmCfIazq+p7yte/fyT8boqkNj22xFwfl4bvVkck9Xa5ojSmICyPLIOC@vger.kernel.org
X-Gm-Message-State: AOJu0YwT7SThykDbKOnOR13STs7ahhuHJVum0k8t7umuhRCrAswxFgOJ
	HMvS9xW9P0y+l3GNzHJmyCUv3Q+1l6Ipr7gb18+tmngM/xKhXZXGOf8m
X-Gm-Gg: ASbGncthXwkhrQHHJ3FSNdh1x60XpkFWMfk2/xCzg1DeDRPbcdTi6Eeb3BmngLxipNh
	0H9epzj9gIUBVQKvF9Wv2QnIKx1SjhI8M2s07DPkPc0CDitjWXK40JgvwcAN3VsfjV0AOz9kg6m
	flp1SBzkLPo5DsKfNisr7RACkuFngNWumSHONQJrILMFZIAw/EreBW7f4MrEvc0cXdbxA3fXTb4
	sJxq4nOkwnwpsQ4lxRU1JFmi0n5hIK1scvulV4QWrfNOfHJbqVVqpTyqVe7sCytESawJjvJU1bG
	Prs4QnlJpGdJ+iag9BFzjr2LDoINufSIoidmsJCrdhSbbMhFEclNSNCZCxHbIWvSMwMQHmsgLDR
	KABWqi/KG8HMNiWcEdQXFvmD1LIwk/5tOCiceeWoeZJ/lhqPuidaZdioRGXP+Q99R5WuGAi057I
	nMckZyrX93jJoCwdkEHBR1oSHVqBw/DY5W
X-Google-Smtp-Source: AGHT+IHSi6VF6s0uOD+PumlBjGkMUoulpOekOEwVZLQpfCJd1Jc4jSCHGMuyuANtbvnedJ6DnWPu/g==
X-Received: by 2002:a17:907:7f0e:b0:b48:44bc:44f2 with SMTP id a640c23a62f3a-b50ac8e52b0mr657263766b.43.1759996782956;
        Thu, 09 Oct 2025 00:59:42 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:42 -0700 (PDT)
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
Subject: [PATCH v7 02/14] fs: spell out fenced ->i_state accesses with explicit smp_wmb/smp_rmb
Date: Thu,  9 Oct 2025 09:59:16 +0200
Message-ID: <20251009075929.1203950-3-mjguzik@gmail.com>
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

The incomming helpers don't ship with _release/_acquire variants, for
the time being anyway.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 fs/fs-writeback.c           | 5 +++--
 include/linux/backing-dev.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fe..9cda19a40ca2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -476,10 +476,11 @@ static bool inode_do_switch_wbs(struct inode *inode,
 	switched = true;
 skip_switch:
 	/*
-	 * Paired with load_acquire in unlocked_inode_to_wb_begin() and
+	 * Paired with an acquire fence in unlocked_inode_to_wb_begin() and
 	 * ensures that the new wb is visible if they see !I_WB_SWITCH.
 	 */
-	smp_store_release(&inode->i_state, inode->i_state & ~I_WB_SWITCH);
+	smp_wmb();
+	inode->i_state &= ~I_WB_SWITCH;
 
 	xa_unlock_irq(&mapping->i_pages);
 	spin_unlock(&inode->i_lock);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3e64f14739dd..065cba5dc111 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -277,10 +277,11 @@ unlocked_inode_to_wb_begin(struct inode *inode, struct wb_lock_cookie *cookie)
 	rcu_read_lock();
 
 	/*
-	 * Paired with store_release in inode_switch_wbs_work_fn() and
+	 * Paired with a release fence in inode_do_switch_wbs() and
 	 * ensures that we see the new wb if we see cleared I_WB_SWITCH.
 	 */
-	cookie->locked = smp_load_acquire(&inode->i_state) & I_WB_SWITCH;
+	cookie->locked = inode->i_state & I_WB_SWITCH;
+	smp_rmb();
 
 	if (unlikely(cookie->locked))
 		xa_lock_irqsave(&inode->i_mapping->i_pages, cookie->flags);
-- 
2.34.1

