Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2782D77FF
	for <linux-unionfs@vger.kernel.org>; Thu,  9 Oct 2025 07:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996795; cv=none; b=TOfaMedolx6JYH+tw8ZD1L+Ak12bHEOh2pwB2EUD/ykMy30aoYqEwWf4DqAJF6yToiq0YN2n0XQs47fL2nQ/8wXao+3IFy8T9NzoGOAGb8UCcPIrQMpmwjehuPmGFMYln2I5MseqOqKfKuliRCyLbEyAnwjIrn7T5fcUzi7/ieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996795; c=relaxed/simple;
	bh=xlMZC6mRkrBvKfdW9aEiJ7hmUdu0jhNwT6sk3dKhWF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atMJW1ETOhDi9uECCMsCuUwq4SQJsIfl9sIFGhoB1gprs+ScNqkdBu0zCpAYD+VF44YE7StLVP0QHdv1alceMp8RC9ciqL3+9pEBWDG88YCuI9pxODLEqzyCb5thsPnjboLjeK87pBx+gKb8WVZo6k2bjjLd4yxKG+xmQA+JQhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kO81p+lx; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kO81p+lx"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3e9d633b78so2076866b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Oct 2025 00:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996790; x=1760601590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TW55q2BD5J3Xoi/y6lNGWsyXU6mmPNteHryX4kl4OTo=;
        b=kO81p+lxgFPhxMP0X3/LdyVOyCs64XBtcPFUwAsPIyUBMw6D0KPIVwOcT7bR/0M8g7
         JnBfSKiY0QIB1eBSw6dz8ijpJea5WgKLTs72tqSE7/ppO1QNnBtnK9WVb65IxURN6Um7
         L2beVoQ078EfQPOLJa5ZnZoEw8RT5Sa7iFx8xq2sYKz5np2rQmOvmU9XVVq5rJNCBA5k
         vNGK5j4QiMY8Z+wUvdD1Xt7C+yy+oA/Kcwv7NLOas4MCDZDjnMqetMaNxB/kF3Z/L4qW
         /pH7d93YL7JqN2prxrM4Jpud88fBY9ugK18KcWpHT3gmDQRKrDGUozgC7yIvOk0hko5X
         5/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996790; x=1760601590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TW55q2BD5J3Xoi/y6lNGWsyXU6mmPNteHryX4kl4OTo=;
        b=W0F8wdq50Spr5rD/uOZBlgcqKm14riv4XBDg5fwNu9FKwOB1FUKBlx9Sgnlfk1b/fB
         NZ8WihTlZdmfiObTBizlYTqi+BYoZlvZiWRseqST9snE3qrmBW1+u5TcOD2OQNvVw5qx
         nAtWH4EyeKSLiLCb1BEbrml1X5HhGC4BEWd6umLcYBMwSIy6rI94v+IUTb40momv2Wfl
         3WTIxDDpKYw2dNBzF7fED/YlGMtrTbHppMy1UFxRDS5RL0pAA+b+LSMMI6wWX+cf9kEX
         5WG0UYqksk/zoaokBwDLLSugC2olEovfZXYLsPhsAIzhIkZ3M6JKYBBonBXmsrmGqbsa
         V8gw==
X-Forwarded-Encrypted: i=1; AJvYcCVMChI7ZlNgxjwejw7Rl9HiVwtkhJimdKKdKkXoV0IK601arl5ndGQEzPnaePEZYfgA4JalAjf+uX0yaEG0@vger.kernel.org
X-Gm-Message-State: AOJu0YxN0hqKoAaDR8+DwOLy6PKDX2HSoqEYx8E7kyHBtpHI/8SLnQ4s
	q/LSD4gITuVpAH9ZlxUrGm7IZxwxovOTDnc8jUQPY2MZhahsYaEdfNkW
X-Gm-Gg: ASbGncu3ilzaC3UUScowIsAX8Obir1x1FDmWnb3VyYcOp5piFLwMkcCyFFoDZshnPSM
	CMV8sfFtv0UIWFBmKaQLkx2CPzuPJZCMprOEHn3gHNxrpKLzz8D+JLJ6vB1Pn7foUIeMgVQjfR1
	0HflDGlDR2LDZUrgsT0n0X2HBU6W2fu9lrfZ4D3iQABdKWhl1JJ2P9JOWFm8ZVs+ZH6DwpLhTe7
	c+KwxvA1DE3wycrJukls1+m4Oj2OiONNhEXGqcMDxx8XytiG3IISyXifXuc9T12QOQKJ9mE7Ogm
	NKOYJlM0bjo5TRnZ4R9QkDdTU8vjPYc662nn3jJmYFeIxJaYQXdpVv97Jb6aHmS/OIESHj8rF4I
	Fg2l4yAEPi0Q03bEKE5cOxtKTPbtasJUMMm7yOSET6QQaIJuof7357jctFl/WMWkAZH1R7s4WnP
	tSYGgRBMg/Ite1xgbJCXtvaGhGOMfuCvPnyMaLc3H+2y8=
X-Google-Smtp-Source: AGHT+IG8iDfDf6yR3N0dRnqDz6+DAj20GvNetdOlNJ4ULk45euX3/T1nyJA+A6Lbbc1K12QXDvop7Q==
X-Received: by 2002:a17:907:a4c4:b0:b2a:657:e733 with SMTP id a640c23a62f3a-b4f429f034cmr1144008766b.15.1759996789761;
        Thu, 09 Oct 2025 00:59:49 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:49 -0700 (PDT)
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
Subject: [PATCH v7 06/14] btrfs: use the new ->i_state accessors
Date: Thu,  9 Oct 2025 09:59:20 +0200
Message-ID: <20251009075929.1203950-7-mjguzik@gmail.com>
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

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

cheat sheet:

If ->i_lock is held, then:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign_raw(inode, I_A | I_B)

 fs/btrfs/inode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b1b3a0553ee..433ffe231546 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3884,7 +3884,7 @@ static int btrfs_add_inode_to_root(struct btrfs_inode *inode, bool prealloc)
 		ASSERT(ret != -ENOMEM);
 		return ret;
 	} else if (existing) {
-		WARN_ON(!(existing->vfs_inode.i_state & (I_WILL_FREE | I_FREEING)));
+		WARN_ON(!(inode_state_read_once(&existing->vfs_inode) & (I_WILL_FREE | I_FREEING)));
 	}
 
 	return 0;
@@ -5361,7 +5361,7 @@ static void evict_inode_truncate_pages(struct inode *inode)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct rb_node *node;
 
-	ASSERT(inode->i_state & I_FREEING);
+	ASSERT(inode_state_read_once(inode) & I_FREEING);
 	truncate_inode_pages_final(&inode->i_data);
 
 	btrfs_drop_extent_map_range(BTRFS_I(inode), 0, (u64)-1, false);
@@ -5799,7 +5799,7 @@ struct btrfs_inode *btrfs_iget_path(u64 ino, struct btrfs_root *root,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->vfs_inode.i_state & I_NEW))
+	if (!(inode_state_read_once(&inode->vfs_inode) & I_NEW))
 		return inode;
 
 	ret = btrfs_read_locked_inode(inode, path);
@@ -5823,7 +5823,7 @@ struct btrfs_inode *btrfs_iget(u64 ino, struct btrfs_root *root)
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->vfs_inode.i_state & I_NEW))
+	if (!(inode_state_read_once(&inode->vfs_inode) & I_NEW))
 		return inode;
 
 	path = btrfs_alloc_path();
@@ -7480,7 +7480,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	u64 page_start = folio_pos(folio);
 	u64 page_end = page_start + folio_size(folio) - 1;
 	u64 cur;
-	int inode_evicting = inode->vfs_inode.i_state & I_FREEING;
+	int inode_evicting = inode_state_read_once(&inode->vfs_inode) & I_FREEING;
 
 	/*
 	 * We have folio locked so no new ordered extent can be created on this
-- 
2.34.1

