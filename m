Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65512264D6
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892775; cv=none; b=GFhjtFSKvJT9ZkyZofDjvPZEgmhW6ucgwL/agIX5P14LfO7GbAlzQPqKcXCtOOg4+pQe0Cbn0efyn44H7EcElfAo5+T/a/Ij0NOijW2ZqbbVG9TMHOrUc240C7OdFGfNCuD3IovY6Q54mR2A5HN+OQ4DAcCHdYD7AETvOwZDeGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892775; c=relaxed/simple;
	bh=GGev53AoP0vSmo+asSwZmTmpUDDkeHas2DNJDfhrCRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxzCaIUMG0qx+Af7FV0VZLaDLTh1PvGHrGfvVcZTUaL86L956zAS/6/QlODLpKUu3eD+QuY3XWu1Yj7N676OQuselcH1sRewkZm7rzopVAnJ5TSMOHQlEi9ALE9QQcT1InbVEah/E8s0IP7mYa1xgXvMpVS91UvGW3hferVpOnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfJOJihK; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfJOJihK"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-65c37eafcbeso960905d50.1
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892773; x=1779497573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4lcp0qd0RpdTlza4drBjjsOWYvBd8r8saxW3po4XlmQ=;
        b=LfJOJihKSxBl4+EmqTdQomMt/0rIvAvBBJ16IGzzEVrHDr7/FypwUg8WSa6HUx0Hk3
         jvCs+kMMmdN9+Gr4fUI8EPqhS8tbkD4edpKOFUV7IrfbRRGHFnkDWPIMIwZ4dKLRrCmf
         3eJu30opBuzSHI/x7KV1EQLhks4VM49bwQJd1dh9tXduOLoYlopZ/vMjN7NWPRW9zo4k
         hmebHwxnoKw5lUQUCF6l0QsIcC+BEfAsDk5XMzHzOpYYiMuVaGgi7C5n5mSO8m0okjQ8
         TeIFKEfFgzHKHSpFslh7XHWmW/MwzqNsoCnJopk7/WEb/4ltW1/NhBIGjIHAJJuSOZSc
         yhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892773; x=1779497573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4lcp0qd0RpdTlza4drBjjsOWYvBd8r8saxW3po4XlmQ=;
        b=dV5y86maP2o9y4PAnPmmJOF+iSYVnr9u3AvKNPTFs084hHwSoHOXhZWG56qW6gl911
         gnBr7xwUZjuN3TzYHWlzY8ISO40kkqEt+eB/C+sMiDFuRoDnvXyvBA38ZsLUzMfYokll
         dBMY7Thl/SpOH+M3vXg0fWRhfKPVYc3RU49SNSN874xfjN44j8A76+S3SRZ15mK4Duv3
         Sem576Z/e+dwDVB0pB3a6c9gUFdHcyloA1ljf2PvXxF9U/Ifwl83w3aYG7p1pYnOyKe0
         1bCZ3TGUK+c/mbsHHUqCVQTFuV1v958AvepGpdcnZZTApmCMXsRR0REfF2MF+CEJAfBu
         mBng==
X-Forwarded-Encrypted: i=1; AFNElJ9qubgGulAI+VXHIWHQ0rWlNjwJUwVLll9ajZXPTvjQSgvKyhK6AWFIG59OwFu3w1eDHmPxihUIIfUqmdPC@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlf0GJRC0e3ML4OpnSKEfr/3R3lMVV78O+YHKL2hvWmSh+Z4R1
	OLQqRVE3wUbGrqHf3URbZcqxoFfglIPaS0qTS9ejEz4LlSg2ye7bzeiXI5q9lfbS
X-Gm-Gg: Acq92OHMAZKjcZalICes9eMKFT0i1F3ksrELOPTTqyzzrbfT7CgWb5xXLHKyTUVm9SZ
	MQuIrpDJ4gjnEHJJhhqLdOLlQUbrhftmsWPA1KWow6ydqhcpFarhz04Jdu+NecliqhQCAMiimEE
	8Q52lZxK5fIThjf3aiacxlmPGMroehxbRgPq9a3FZFC+/+7OqjD7oa1/BPG3/8FAHW2+xop+vM8
	XnGtX4LpB6T/U2wfOlW5UrNF+j4HSyFaSTydZO0HZirtCEF4sUN88ezQtYkI9CSSg6LqVXLBCJh
	cNGUwc3YJS1JdxIMJS8W2jeIMjByulxtt9dxRi5Cn++C+oNVpGtO3PklALyvtuM87X28VrPcCqW
	oeGdypg9JctRnduiss4KenSR7ifPNZvHuifR/kwzOI1q8Ez6tftA89TldJmbMALaXX2JtOTKPfR
	oDRhawRNcGEBz3aj2YbBbv
X-Received: by 2002:a05:690c:28b:b0:7ba:f3fb:2623 with SMTP id 00721157ae682-7c95c8f201dmr66807957b3.40.1778892772939;
        Fri, 15 May 2026 17:52:52 -0700 (PDT)
Received: from localhost ([2a03:2880:f806:44::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f55b85edsm37663907b3.35.2026.05.15.17.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:52:52 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 14/21] fuse: add passthrough support for entry creation
Date: Fri, 15 May 2026 17:39:57 -0700
Message-ID: <20260516004004.1455526-15-joannelkoong@gmail.com>
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

Use the new extended fuse_entry2_out reply for entry creation operations
(mknod, mkdir, symlink, link) when FUSE_PASSTHROUGH_INO is enabled.

If the server returns a backing id, the newly created inode will be
automatically associated with the backing file for passthrough
operations. If no backing id is returned (no passthrough), the statx
attributes are cached.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dir.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3a6adae530da..a11f9e4c1999 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1088,9 +1088,12 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
 				       struct dentry *entry, umode_t mode)
 {
 	struct fuse_entry_out outarg;
+	struct fuse_entry2_out outarg2;
 	struct inode *inode;
 	struct dentry *d;
 	struct fuse_forget_link *forget;
+	struct fuse_statx *sx = NULL;
+	int backing_id;
 	int epoch, err;
 
 	if (fuse_is_bad(dir))
@@ -1102,11 +1105,18 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
 	if (!forget)
 		return ERR_PTR(-ENOMEM);
 
-	memset(&outarg, 0, sizeof(outarg));
 	args->nodeid = get_node_id(dir);
 	args->out_numargs = 1;
-	args->out_args[0].size = sizeof(outarg);
-	args->out_args[0].value = &outarg;
+
+	if (fuse_use_entry2(fm->fc)) {
+		memset(&outarg2, 0, sizeof(outarg2));
+		args->out_args[0].size = sizeof(outarg2);
+		args->out_args[0].value = &outarg2;
+	} else {
+		memset(&outarg, 0, sizeof(outarg));
+		args->out_args[0].size = sizeof(outarg);
+		args->out_args[0].value = &outarg;
+	}
 
 	if (args->opcode != FUSE_LINK) {
 		err = get_create_ext(idmap, args, dir, entry, mode);
@@ -1119,21 +1129,35 @@ static struct dentry *create_new_entry(struct mnt_idmap *idmap, struct fuse_moun
 	if (err)
 		goto out_put_forget_req;
 
+	backing_id = fuse_process_entry2(fm->fc, &outarg2, &outarg, &sx);
+
 	err = -EIO;
 	if (invalid_nodeid(outarg.nodeid) || fuse_invalid_attr(&outarg.attr))
 		goto out_put_forget_req;
+	if (backing_id < 0) {
+		fuse_chan_queue_forget(fm->fc->chan, forget, outarg.nodeid, 1);
+		return ERR_PTR(backing_id);
+	}
 
 	if ((outarg.attr.mode ^ mode) & S_IFMT)
 		goto out_put_forget_req;
 
 	inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
-			  &outarg.attr, NULL, ATTR_TIMEOUT(&outarg), 0, 0);
+			  &outarg.attr, sx, ATTR_TIMEOUT(&outarg), 0, 0);
 	if (!inode) {
 		fuse_chan_queue_forget(fm->fc->chan, forget, outarg.nodeid, 1);
 		return ERR_PTR(-ENOMEM);
 	}
 	kfree(forget);
 
+	if (backing_id) {
+		err = fuse_inode_set_passthrough(inode, backing_id);
+		if (err) {
+			iput(inode);
+			return ERR_PTR(err);
+		}
+	}
+
 	d_drop(entry);
 	d = d_splice_alias(inode, entry);
 	if (IS_ERR(d))
-- 
2.52.0

