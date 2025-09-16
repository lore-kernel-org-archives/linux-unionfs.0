Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54D0353350
	for <linux-unionfs@vger.kernel.org>; Tue, 16 Sep 2025 13:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031201; cv=none; b=sK0rwz9moP77XelXkzQlB8og3ecE+eSpS7DnRaIayYA0MSVDdgfkStm89T1Rc8mRfkRo2W/ihkBsFaqq2/Wr/XN44u4efVMD7KRruQPkqOAQt/VObkEH3vatnd8KJEP9ixdsMAmWp8H8iSgTZe/igOS6AVxq7sCbc8+qqWf+pvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031201; c=relaxed/simple;
	bh=c+jscvVcjHEiu8psO35s6FUxxWLk6N1H5PVjaYHBuTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YM/5NydYGi0+bIf8/faorOZcbStpBFnEaxvPyF+68MlJcXOu6bdY6NV902RZtoP1tWCnsluhZ2THVjBQNjkEZn3ZnsGYTemKV/I8x7eSkojrxCDnfIwCocn6Ynfg4sAAjTBfJ5baTE2+t/JEp1ZvBrzA0EeCt5nJPFtvdJ6Kl8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C21u3d19; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C21u3d19"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45de56a042dso36881085e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Sep 2025 06:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031197; x=1758635997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vENfTvsqrFJ9tJyBfgLNz2mb8wc8do/WZvddYLx/2MM=;
        b=C21u3d19x1DjsYLGY77AgVuGFJpc7Ig4fo4Ohm8jKWcl7iOvflvcwoJ48taJ4+fHLm
         tIdGWj1Za+IZGy/XPSuZty/tFmcdO9gKYqRvPzDG4iT2AAFWgiYbCa6zQVL1QjjdchTX
         /dAhqFk775dJjUo5Dobt1zHOXXoUVZkJ6hLgIjZTBWg4ztB+8AewMjOpnzltJlilhwHl
         0gfsMylQ001Vy1z2qGg6/HapEPCjePhuPj9OUpeXne4xp/jB1hdJ5OPPtc1GkVR/1UT0
         tvLara7/TZ0N5t5aa12RyY3LEr0f/nlndfwk7+cSe1jJmoGd4KvUQAVdffshf5o07KGd
         CYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031197; x=1758635997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vENfTvsqrFJ9tJyBfgLNz2mb8wc8do/WZvddYLx/2MM=;
        b=vHXD/2NKkaMfsTGRcpZBj/kh1vpwO4dhGrr7AtmxcqmAKkiIRdrDjtE7mhXBZmMDkM
         Lu+Kn0kgHysYCUoLuoHMKfA2F5YuO/6yJDYcIgzWsjcm5jhIu8susrt0XgylTggYEvSZ
         G/LcblV1hbmpH+y7mymB/gehMKNwSLSVy5Pa8YB4wFzmTS9nHEI1oJQOKap2RGVbx9tm
         L6Xv/1khqvzGDyv7byb/vnS9gx25OZKjQ9OOWMwDbRKcO5ytXvLBz4Jg9UyrU5JEI2dr
         dUt8HipIbA+diHN5paILIO0bMbJNVMerbLJzR2QqWbeklH/jhX4mm7t2E3uz0uqK0dP9
         dzaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHXeo/zwQySEO56mRa6wOr3Cb/4jRYmVNKfb6mh2e5JbyhM36WKBbDFMBBQ5xduXUeDOgvfKmUqHyTv5Et@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7VNSh0dqq9NDe0ISObsEXF3kmAwrUwVhG10ENTrUA8BFM2WnY
	fuWl35Ei8p/HEnJxrjJxgVi07Aqp1FuXE+ftGBypIhyawilqUMofLeML
X-Gm-Gg: ASbGnctWR1ZEYYitMtZLjLZULouWYixpBwb9oIR97hjgRvqnkGJjQeFXDGvBdXICEvf
	R5LAniSiRONwRlYL84JFnmyGrbaqD2TiiglcKXZRU4BMLoKoRmRLO7bhxk1eAnqt6lEKZZ+zBDH
	bxM/SaleMVm/EEkgmOTW2XCIJiMI7ycuSxQsc4OsyiEURcGyRXc92ddRyBwWeavfjleJjJF7fyl
	ZaSVtNGLTveCJOhwMQ/L8q0CQ3HmCgCVhe90Kuc06CuWvDkjBDAxaZuoEKS5EXFHzCmVmibT6nk
	v/jF5KU4P4iVl5dCaS0+OCglx82TFRRX+lsXbPt0GW/urL0uVeb8rMmo/JzNC0y79hjYpFf29+P
	qegRFBuPwGeYHPHwxQ8U+vqGtjXbe/ngS639JEmEfD0h2h/UtlrJ4OrniAWF679p5FyFUFDjS
X-Google-Smtp-Source: AGHT+IGywKOeZnJ30E7Ud2DvguwBt7x+jM+ZimZarnO2UYCjYh4k81VYRu4VVnkSvPh9Eqb3iEJtqg==
X-Received: by 2002:a05:600c:5254:b0:45f:284b:1d89 with SMTP id 5b1f17b1804b1-45f2a4f8bafmr97604315e9.25.1758031196860;
        Tue, 16 Sep 2025 06:59:56 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.06.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:59:56 -0700 (PDT)
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
Subject: [PATCH v4 09/12] f2fs: use the new ->i_state accessors
Date: Tue, 16 Sep 2025 15:58:57 +0200
Message-ID: <20250916135900.2170346-10-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916135900.2170346-1-mjguzik@gmail.com>
References: <20250916135900.2170346-1-mjguzik@gmail.com>
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
 fs/f2fs/data.c  | 2 +-
 fs/f2fs/inode.c | 2 +-
 fs/f2fs/namei.c | 4 ++--
 fs/f2fs/super.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7961e0ddfca3..9cc22322ce7f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4241,7 +4241,7 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	if (map.m_flags & F2FS_MAP_NEW)
 		iomap->flags |= IOMAP_F_NEW;
-	if ((inode->i_state & I_DIRTY_DATASYNC) ||
+	if ((inode_state_read_once(inode) & I_DIRTY_DATASYNC) ||
 	    offset + length > i_size_read(inode))
 		iomap->flags |= IOMAP_F_DIRTY;
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 8c4eafe9ffac..f1cda1900658 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -569,7 +569,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW)) {
+	if (!(inode_state_read_once(inode) & I_NEW)) {
 		if (is_meta_ino(sbi, ino)) {
 			f2fs_err(sbi, "inaccessible inode: %lu, run fsck to repair", ino);
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index b882771e4699..7d977b80bae5 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -844,7 +844,7 @@ static int __f2fs_tmpfile(struct mnt_idmap *idmap, struct inode *dir,
 		f2fs_i_links_write(inode, false);
 
 		spin_lock(&inode->i_lock);
-		inode->i_state |= I_LINKABLE;
+		inode_state_add(inode, I_LINKABLE);
 		spin_unlock(&inode->i_lock);
 	} else {
 		if (file)
@@ -1057,7 +1057,7 @@ static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			goto put_out_dir;
 
 		spin_lock(&whiteout->i_lock);
-		whiteout->i_state &= ~I_LINKABLE;
+		inode_state_del(whiteout, I_LINKABLE);
 		spin_unlock(&whiteout->i_lock);
 
 		iput(whiteout);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 2045642cfe3b..d8db9a4084fa 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1747,7 +1747,7 @@ static int f2fs_drop_inode(struct inode *inode)
 	 *    - f2fs_gc -> iput -> evict
 	 *       - inode_wait_for_writeback(inode)
 	 */
-	if ((!inode_unhashed(inode) && inode->i_state & I_SYNC)) {
+	if ((!inode_unhashed(inode) && inode_state_read(inode) & I_SYNC)) {
 		if (!inode->i_nlink && !is_bad_inode(inode)) {
 			/* to avoid evict_inode call simultaneously */
 			__iget(inode);
-- 
2.43.0

