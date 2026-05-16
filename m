Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D72E414
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892746; cv=none; b=ZIC3ZuRU/FezIhPXnAdHn7JwMB7jJFCmcV/3IQMqL/lI5mVgxTGBjdAl+qKpUYplSXZoDS/CRwfLX8subz2CutT6AhFD4F5QqMvCQLFEL7KvfJHh0s0sdfLrfIT6U7+bmQgI3NZPfotojZL4ws4yayXIEgwBMKdd/VJr+LvfRls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892746; c=relaxed/simple;
	bh=vk/vgFQ6+2WpIg9UaWiUarVSqBBGF7EhKS1Qx76mHqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnSUQ6n7pvRTCGfVc5hFIMRuDEgcc1fThZJFZjFVVNfIr+n1vIA3zzHgR1YUCYmQFBgfamRrRVz7eLZsimxmJF+a2dNR9QzShazuFlm9d8vhxo2kKAvpQUEyWqXGEHLNG7SZjnO5N15pK9J0KM/Qw74uHd1+WrwRfp6XCNWEDI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZY+jKFPz; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZY+jKFPz"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7c307937816so527447b3.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892744; x=1779497544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCsp+ZYKwisIwS3s9YFG8yk7hCyMTUst+sbdjhxh9dI=;
        b=ZY+jKFPzvFR1Jeyz2iyFqNmqHBq26Y7P+gSQpHg68imTb5zSW1OjAbLoJ4rbvJqN//
         midDfDbXqoAX5XntgjJWRosi2XixJB4X47FaUbKS6KCofK5SuvPPLq5BnYa/jQyc0wIM
         7QBLtFi3F1T3ZISRV/fqAEMurVEBebNBYWLBT0ajRP430v9kY8zqtAdKiWvTnQCRIdPr
         6NlIV+NN/VxR6aVyK1kYUp+w2vDG6d3wd4PdY8JGWCrMe85tMmufwS0oyEjt42OHlkss
         OVXuC0Eh3SBI9Q00WQ6YwH9iTQahyz4HWJ5yLi4dFhJhwL/iaWge5sHxauDjdFrdKnPk
         K2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892744; x=1779497544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vCsp+ZYKwisIwS3s9YFG8yk7hCyMTUst+sbdjhxh9dI=;
        b=JUNbutFo6/R0pjYsJjIHImqVJdBbfmvdzlYmaHtpNlXGet6Wawv+jtTJbCop9vYmm2
         2EWRSqgPcrkSsInKduOouWSJAwLHnoASiFm9Yeza5rhvg5SndQ6S6eCDJhVD0kcu3oIO
         ycsaTKC5TbeF2VY7rC1kAcdLCFfW6LJPqB0bDGRt/sCgPmu/KqhTX+jFOHGuQ61HQy36
         IoiOiy+T7RyIqA4PpJTaFvrAQ0YwP/p61mYpUq5Z0aVKLRXLPMwAmw6z8DNjSweY9vLN
         bVNyDj7z8VzaXY3OJgnt5p2UDI3iP+c5sf83fupLAf4UgLFgKeX8WFemvK35XgYM4rS7
         wijA==
X-Forwarded-Encrypted: i=1; AFNElJ8twsq9nmgt8gGGvTRNmF0x6D06+MHkNKD928Tf1wYZzd5OZlkD9cF0yldtNMVQzsCOuQhgWDQYjkHFX7hs@vger.kernel.org
X-Gm-Message-State: AOJu0YzFr5si2/arowYmouvQlYdEeT4wKu9Qulh+yinNEQJyzWFnBKBm
	hFENeNx4pNaC/eDK+c4aNxtAc8tVQtxJT82XSxR5k/Hz9KgB37lSpNNHFLBB/Wot
X-Gm-Gg: Acq92OGZ0XuSd0S5RWDWaG0CNzjkZDO+PPZ58tYs6IyrQ0Je1tkmWZDp54jVX+yhtYT
	ZdwTcn8uBHEcvQfYgBB0EAz1C4q5M46aSpHNBYh3htFAInhduuI9Pzn70zb2Lt0NEHp3YXoAVb0
	GhMvZKeYmnPUoR87isCwTmQUQV/wzdwku/pboZi3xL5VEbZOcfoVUCY7fX6JOwf76SGGqFyM2MY
	t50Gu2qq//2DrCzb0j/8719iUrNFsFwBHzfTAwC4MUZswZlrm61gQn6zgMOkonXH6vcZIUYrD2u
	qA9qGG17k/WQ+bZbGsCVk9w4Cxrrd0tWEWH/wfY2EFHTqmo4f7aXkbhAH6Ibgfg/t2o4EbaHNJB
	u6LiJejJy8Te09SGCJoSKMyqagceuPQguRe+gSlgOQtQw1OrDotkWaTkVeGiPBl1XT27ceu8cAV
	jiWcKfSibfhMqO2kQTr2wX
X-Received: by 2002:a05:690c:e3c8:b0:7b8:bc4e:a4c with SMTP id 00721157ae682-7c95c7edf0bmr68435577b3.27.1778892744127;
        Fri, 15 May 2026 17:52:24 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:11::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f4ee635csm37152337b3.32.2026.05.15.17.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:23 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 03/21] fuse: prepare for readdir passthrough on directories
Date: Fri, 15 May 2026 17:39:46 -0700
Message-ID: <20260516004004.1455526-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260516004004.1455526-1-joannelkoong@gmail.com>
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

In preparation for readdir passthrough, allow the inode iomode state
to be applicable to directory inodes and prepare the helper
fuse_sync_release() for directories.

Directory inodes will support cached mode, "direct" uncached readdir
mode and readdir passthrough mode, but will not need to wait for
parallel dio like regular files.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/fuse/cuse.c   |  2 +-
 fs/fuse/dir.c    |  4 ++--
 fs/fuse/file.c   | 11 ++++++-----
 fs/fuse/fuse_i.h | 15 +++++++++------
 fs/fuse/inode.c  |  2 +-
 fs/fuse/iomode.c | 31 ++++++++++++++++++-------------
 6 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index bac327cfc7f1..9c4d7a1993e8 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -148,7 +148,7 @@ static int cuse_release(struct inode *inode, struct file *file)
 	struct fuse_file *ff = file->private_data;
 	struct fuse_mount *fm = ff->fm;
 
-	fuse_sync_release(NULL, ff, file->f_flags);
+	fuse_sync_release(NULL, ff, file->f_flags, false);
 	fuse_conn_put(fm->fc);
 
 	return 0;
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index be41c14ef329..937165788e79 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -893,7 +893,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 			  &outentry.attr, ATTR_TIMEOUT(&outentry), 0, 0);
 	if (!inode) {
 		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
-		fuse_sync_release(NULL, ff, flags);
+		fuse_sync_release(NULL, ff, flags, false);
 		fuse_chan_queue_forget(fm->fc->chan, forget, outentry.nodeid, 1);
 		err = -ENOMEM;
 		goto out_err;
@@ -910,7 +910,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	}
 	if (err) {
 		fi = get_fuse_inode(inode);
-		fuse_sync_release(fi, ff, flags);
+		fuse_sync_release(fi, ff, flags, false);
 	} else {
 		if (fm->fc->atomic_o_trunc && trunc)
 			truncate_pagecache(inode, 0);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 06dc8cfe3c7b..332032cd5622 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -285,7 +285,7 @@ static int fuse_open(struct inode *inode, struct file *file)
 		ff = file->private_data;
 		err = fuse_finish_open(inode, file);
 		if (err)
-			fuse_sync_release(fi, ff, file->f_flags);
+			fuse_sync_release(fi, ff, file->f_flags, false);
 		else if (is_truncate)
 			fuse_truncate_update_attr(inode, file);
 	}
@@ -408,10 +408,12 @@ static int fuse_release(struct inode *inode, struct file *file)
 }
 
 void fuse_sync_release(struct fuse_inode *fi, struct fuse_file *ff,
-		       unsigned int flags)
+		       unsigned int flags, bool isdir)
 {
+	int opcode = isdir ? FUSE_RELEASEDIR : FUSE_RELEASE;
+
 	WARN_ON(refcount_read(&ff->count) > 1);
-	fuse_prepare_release(fi, ff, flags, FUSE_RELEASE, true);
+	fuse_prepare_release(fi, ff, flags, opcode, true);
 	fuse_file_put(ff, true);
 }
 EXPORT_SYMBOL_GPL(fuse_sync_release);
@@ -1454,13 +1456,12 @@ static void fuse_dio_lock(struct kiocb *iocb, struct iov_iter *from,
 static void fuse_dio_unlock(struct kiocb *iocb, bool exclusive)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	if (exclusive) {
 		inode_unlock(inode);
 	} else {
 		/* Allow opens in caching mode after last parallel dio end */
-		fuse_inode_uncached_io_end(fi);
+		fuse_inode_uncached_io_end(inode);
 		inode_unlock_shared(inode);
 	}
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 8e54dc7d56af..2436219338b3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -160,9 +160,6 @@ struct fuse_inode {
 			 */
 			int writectr;
 
-			/** @iocachectr: Number of files/maps using page cache */
-			int iocachectr;
-
 			/** @page_waitq: Waitq for writepage completion */
 			wait_queue_head_t page_waitq;
 
@@ -216,6 +213,12 @@ struct fuse_inode {
 	/** @lock: Lock to protect write-related fields */
 	spinlock_t lock;
 
+	/**
+	 * @iocachectr: Number of files/maps using page cache (negative for
+	 * passthrough)
+	 */
+	int iocachectr;
+
 #ifdef CONFIG_FUSE_DAX
 	/**
 	 * @dax: Dax specific inode data
@@ -248,7 +251,7 @@ enum {
 	FUSE_I_BAD,
 	/* Has btime */
 	FUSE_I_BTIME,
-	/* Wants or already has page cache IO */
+	/* Regular file wants or already has page cache IO */
 	FUSE_I_CACHE_IO_MODE,
 	/*
 	 * Client has exclusive access to the inode, either because fs is local
@@ -946,7 +949,7 @@ void fuse_file_free(struct fuse_file *ff);
 int fuse_finish_open(struct inode *inode, struct file *file);
 
 void fuse_sync_release(struct fuse_inode *fi, struct fuse_file *ff,
-		       unsigned int flags);
+		       unsigned int flags, bool isdir);
 
 /*
  * Send RELEASE or RELEASEDIR request
@@ -1244,7 +1247,7 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 /* iomode.c */
 int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff);
 int fuse_inode_uncached_io_start(struct inode *inode, struct fuse_backing *fb);
-void fuse_inode_uncached_io_end(struct fuse_inode *fi);
+void fuse_inode_uncached_io_end(struct inode *inode);
 
 int fuse_file_io_open(struct file *file, struct inode *inode);
 void fuse_file_io_release(struct fuse_file *ff, struct inode *inode);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b2a5892a4dc3..cef8b853b3d8 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -180,10 +180,10 @@ static void fuse_evict_inode(struct inode *inode)
 			atomic64_inc(&fc->evict_ctr);
 	}
 	if (S_ISREG(inode->i_mode) && !fuse_is_bad(inode)) {
-		WARN_ON(fi->iocachectr != 0);
 		WARN_ON(!list_empty(&fi->write_files));
 		WARN_ON(!list_empty(&fi->queued_writes));
 	}
+	WARN_ON(fi->iocachectr != 0);
 }
 
 static int fuse_reconfigure(struct fs_context *fsc)
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index 5517711a3eca..e2e7fbaac9af 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -15,9 +15,12 @@
 /*
  * Return true if need to wait for new opens in caching mode.
  */
-static inline bool fuse_is_io_cache_wait(struct fuse_inode *fi)
+static inline bool fuse_is_io_cache_wait(struct inode *inode)
 {
-	return READ_ONCE(fi->iocachectr) < 0 && !fuse_inode_backing(fi);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	return S_ISREG(inode->i_mode) &&
+		READ_ONCE(fi->iocachectr) < 0 && !fuse_inode_backing(fi);
 }
 
 /*
@@ -40,10 +43,10 @@ int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
 	 * Setting the bit advises new direct-io writes to use an exclusive
 	 * lock - without it the wait below might be forever.
 	 */
-	while (fuse_is_io_cache_wait(fi)) {
+	while (fuse_is_io_cache_wait(inode)) {
 		set_bit(FUSE_I_CACHE_IO_MODE, &fi->state);
 		spin_unlock(&fi->lock);
-		wait_event(fi->direct_io_waitq, !fuse_is_io_cache_wait(fi));
+		wait_event(fi->direct_io_waitq, !fuse_is_io_cache_wait(inode));
 		spin_lock(&fi->lock);
 	}
 
@@ -69,8 +72,10 @@ int fuse_file_cached_io_open(struct inode *inode, struct fuse_file *ff)
 }
 
 static void fuse_file_cached_io_release(struct fuse_file *ff,
-					struct fuse_inode *fi)
+					struct inode *inode)
 {
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
 	spin_lock(&fi->lock);
 	WARN_ON(fi->iocachectr <= 0);
 	WARN_ON(ff->iomode != IOM_CACHED);
@@ -141,15 +146,17 @@ static int fuse_file_uncached_io_open(struct inode *inode,
 	return 0;
 }
 
-void fuse_inode_uncached_io_end(struct fuse_inode *fi)
+void fuse_inode_uncached_io_end(struct inode *inode)
 {
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_backing *oldfb = NULL;
 
 	spin_lock(&fi->lock);
 	WARN_ON(fi->iocachectr >= 0);
 	fi->iocachectr++;
 	if (!fi->iocachectr) {
-		wake_up(&fi->direct_io_waitq);
+		if (S_ISREG(inode->i_mode))
+			wake_up(&fi->direct_io_waitq);
 		oldfb = fuse_inode_backing_set(fi, NULL);
 	}
 	spin_unlock(&fi->lock);
@@ -159,11 +166,11 @@ void fuse_inode_uncached_io_end(struct fuse_inode *fi)
 
 /* Drop uncached_io reference from passthrough open */
 static void fuse_file_uncached_io_release(struct fuse_file *ff,
-					  struct fuse_inode *fi)
+					  struct inode *inode)
 {
 	WARN_ON(ff->iomode != IOM_UNCACHED);
 	ff->iomode = IOM_NONE;
-	fuse_inode_uncached_io_end(fi);
+	fuse_inode_uncached_io_end(inode);
 }
 
 /*
@@ -278,8 +285,6 @@ int fuse_file_io_open(struct file *file, struct inode *inode)
 /* No more pending io and no new io possible to inode via open/mmapped file */
 void fuse_file_io_release(struct fuse_file *ff, struct inode *inode)
 {
-	struct fuse_inode *fi = get_fuse_inode(inode);
-
 	/*
 	 * Last passthrough file close allows caching inode io mode.
 	 * Last caching file close exits caching inode io mode.
@@ -289,10 +294,10 @@ void fuse_file_io_release(struct fuse_file *ff, struct inode *inode)
 		/* Nothing to do */
 		break;
 	case IOM_UNCACHED:
-		fuse_file_uncached_io_release(ff, fi);
+		fuse_file_uncached_io_release(ff, inode);
 		break;
 	case IOM_CACHED:
-		fuse_file_cached_io_release(ff, fi);
+		fuse_file_cached_io_release(ff, inode);
 		break;
 	}
 }
-- 
2.52.0

