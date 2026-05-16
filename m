Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E1933987
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892777; cv=none; b=lWBfZwe2ThVeP4bJYA+Q42dwBRzXHeo+36jGSNCU0elQAkvcc/R5KAd0ys2GaBl1Kctaf/5vJFGGl1KQYet5lrH3T6u1bGsRYvEfyAd9l1DwumQe+OZ701baTi1Mjmm1k/dLDW0qQRiAlTT1QqMaJTHrwQm8HobSismjdY+82l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892777; c=relaxed/simple;
	bh=jDX/PRY5UaIwdYXq+2UBvCz1YhR4ZFNUuwCxDfdDTTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbhsPB1lyr5ejutZ25LhJCXNVqGFMBdnAoCgj7UfRsAMHNWSA0w6XZaO/f+yvcAwK5qbrUeRNmTW4nJ23X9MqGgyAIOHsouH7QNPwtoCGQWFddqLlHVaCpgVDrwzQXZmHqTxTGasVFXBkoLqUy1htiPK1nKUjhZRP0SNrqx7ukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uw03ev5i; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uw03ev5i"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bdc947aa88so475377b3.3
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892775; x=1779497575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88Gw+C1h5VUj69/BTUVHHVf48OhDKUSM917eO0JsfBM=;
        b=Uw03ev5iojPk39gP7Pi9Y7yrn3nhIajUFORBv3E/Oj+rtinE1B0k25/HimGmxOArjP
         JftZawn05IXVEVcVTzHwo3BK4jIVWdkCJon01UpGNvBO3WKNW0oK5mm9xjK35EW7jhE9
         /SEEcKRRJ3uxKX95NEig2+uYlCGIy6NwB9BCq2lmxpUkyGzJkiDuhNm89CG8W4f/maY1
         ryOfggAntAsuS+/JDDzTttOKHt+uO86Rhvo+eqF8/eWM61xC7UzEhXjJOGF8SrRz7EY5
         rnxGnJ0vMB3N4nynB6NoBmJufJo164Eew4aPutZMcyM0BOTU7yxuARKJXlsOy9azdpn6
         xUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892775; x=1779497575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=88Gw+C1h5VUj69/BTUVHHVf48OhDKUSM917eO0JsfBM=;
        b=ZKfOZVV8wbSLAW7fC6LkINEdAf8BpY1WlXQfaHecf2I5Aiw7BAJkN+M4uHVqwDVxwg
         6ELC5hKOv19Xn42jbzSLdoIrA9iSlcb73NPMMSZRRVTvFXmH7O+TIVG2Ry+vxVCxAFj5
         fYwjYNWxGztzEInKFsmZUIrcGDeZZZvGLssBAs7V/k2vreP1DBzNQchONlLlER5yFx9O
         NVjRT7UO6GDurKxRIC0KoIaKHNKuSzhR9eznrkx6T5aY3SScwTJgaPg+Lz8PI4gBdVPz
         SSEJP43ZPBDafHxvmriMUM7O3ERIN5O4xDqkNjei61wP8ns+fy6BTeV8PGWylGpZtggx
         wnbg==
X-Forwarded-Encrypted: i=1; AFNElJ8Ks7p0mAqGV33krKDTJ8RVmF6gOg1OxwyK8dpmFnuX3hTOgNA6Xg1R7drUBVqQvX61VL4RY/KyaF7iTLVn@vger.kernel.org
X-Gm-Message-State: AOJu0YzJu6DJMj8wrZkaPwO4DPJUt2Ouu5uUajZGpYsfWXkFW8/ddthD
	DKdwbWYRSWOSfd9ebI68/muUfyH7Qv4t5XK4QkIR/N5LZlqU8Ls69nsB
X-Gm-Gg: Acq92OFWdgiXeuHclY+vqVmreb/NO4bE3W/5SQwEvEq2nfcratCGpgVj4+cdlrE8Ndp
	zFawZh81MLjl7L4WLOPYBscr8eyiPlwGZeuD3u/xPMXYdqQnMse+LSwlQLGFTaC9lacFfzI0sE6
	Hfe0LPniGWWkC1abXfwg5qY9VaMUUOxbaF6CHdDX+CLy2JHWR8KPfCObfxi8Oxqoh7wc/QJv2zZ
	eClakerGAidVyRei6a8XjmzoCT4PsTs4WTdIRt4MRMd/Sx1wcocK4Ji+W0RS6i1eImS8XRTHC0v
	VakWQSJvwSPvfp2wu6p41ztT8AM51UaoyUSxVJ09hvlzQyGsPvX3MA0MjA13h/LFsV+Ja9369m/
	YEVUkYBP1qvthrufanj08stlCU9kiXl+So/HLm5s948N0F9OiufCCOP1pobXdTMvOIw8WYB8k/+
	pioVvfJGzV735bbAL4lSALS7a8RCT45w==
X-Received: by 2002:a05:690c:82:b0:7bf:ff7:ea6e with SMTP id 00721157ae682-7c959e88e5emr75469197b3.4.1778892775431;
        Fri, 15 May 2026 17:52:55 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:1::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f22d0290sm38505117b3.9.2026.05.15.17.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:54 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 15/21] fuse: add passthrough support for create+open
Date: Fri, 15 May 2026 17:39:58 -0700
Message-ID: <20260516004004.1455526-16-joannelkoong@gmail.com>
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

Use the extended fuse_entry2_out reply for FUSE_CREATE and FUSE_TMPFILE
when FUSE_PASSTHROUGH_INO is enabled. If the server returns a backing
id, the newly created inode is associated with the backing file for
passthrough operations before the dentry is instantiated.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dir.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index a11f9e4c1999..4c7e3e1604af 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -934,9 +934,12 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	struct fuse_create_in inarg;
 	struct fuse_open_out *outopenp;
 	struct fuse_entry_out outentry;
+	struct fuse_entry2_out outentry2;
+	struct fuse_statx *sx = NULL;
 	struct fuse_inode *fi;
 	struct fuse_file *ff;
 	int epoch, err;
+	int backing_id;
 	bool trunc = flags & O_TRUNC;
 
 	/* Userspace expects S_IFREG in create mode */
@@ -957,7 +960,6 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 
 	flags &= ~O_NOCTTY;
 	memset(&inarg, 0, sizeof(inarg));
-	memset(&outentry, 0, sizeof(outentry));
 	inarg.flags = flags;
 	inarg.mode = mode;
 	inarg.umask = current_umask();
@@ -975,8 +977,15 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
 	args.out_numargs = 2;
-	args.out_args[0].size = sizeof(outentry);
-	args.out_args[0].value = &outentry;
+	if (fuse_use_entry2(fm->fc)) {
+		memset(&outentry2, 0, sizeof(outentry2));
+		args.out_args[0].size = sizeof(outentry2);
+		args.out_args[0].value = &outentry2;
+	} else {
+		memset(&outentry, 0, sizeof(outentry));
+		args.out_args[0].size = sizeof(outentry);
+		args.out_args[0].value = &outentry;
+	}
 	/* Store outarg for fuse_finish_open() */
 	outopenp = &ff->args->open_outarg;
 	args.out_args[1].size = sizeof(*outopenp);
@@ -991,6 +1000,8 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	if (err)
 		goto out_free_ff;
 
+	backing_id = fuse_process_entry2(fm->fc, &outentry2, &outentry, &sx);
+
 	err = -EIO;
 	if (!S_ISREG(outentry.attr.mode) || invalid_nodeid(outentry.nodeid) ||
 	    fuse_invalid_attr(&outentry.attr))
@@ -999,16 +1010,26 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	ff->fh = outopenp->fh;
 	ff->nodeid = outentry.nodeid;
 	ff->open_flags = outopenp->open_flags;
+
+	if (backing_id < 0) {
+		err = backing_id;
+		goto out_queue_forget;
+	}
+
 	inode = fuse_iget(dir->i_sb, outentry.nodeid, outentry.generation,
-			  &outentry.attr, NULL, ATTR_TIMEOUT(&outentry), 0, 0);
+			  &outentry.attr, sx, ATTR_TIMEOUT(&outentry), 0, 0);
 	if (!inode) {
-		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
-		fuse_sync_release(NULL, ff, flags, false);
-		fuse_chan_queue_forget(fm->fc->chan, forget, outentry.nodeid, 1);
 		err = -ENOMEM;
-		goto out_err;
+		goto out_queue_forget;
 	}
 	kfree(forget);
+	if (backing_id) {
+		err = fuse_inode_set_passthrough(inode, backing_id);
+		if (err) {
+			iput(inode);
+			goto out_sync_release;
+		}
+	}
 	d_instantiate(entry, inode);
 	entry->d_time = epoch;
 	fuse_change_entry_timeout(entry, &outentry);
@@ -1035,6 +1056,12 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	kfree(forget);
 out_err:
 	return err;
+out_queue_forget:
+	fuse_chan_queue_forget(fm->fc->chan, forget, outentry.nodeid, 1);
+out_sync_release:
+	flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
+	fuse_sync_release(NULL, ff, flags, false);
+	return err;
 }
 
 static int fuse_mknod(struct mnt_idmap *, struct inode *, struct dentry *,
-- 
2.52.0

