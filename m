Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817964;
	b=vEb9UpczYt0rm+XEH/czBgA4RSwG2+zplAdN3p8OdNo/OCEz1NX7WEZ8uUF9hyaiD6gX
	 l8DLyF9tVOySvfNO395esuxodFy/uNVIfTKn4g41nHw6j8bF8WSMJ+FmMTf4zDHF21RW5
	 guRzswfGfBWc/UKD1Jj4ndb3idXEp4hXpMEtkNAn/ndNnQW2/IlZQqOCbZsascFmYy/Me
	 nsiV/6EHb0bXeXON7FN1PJhzxTGYoLVpst3/xT9a0GKaJZiLyTrne/Ovk2REzqvGEm6iQ
	 MgbFaPRw/Rf9ymiVeY6xT8X8FdiuoaGhjWY2KBTrIt1exuRsLGYZg+MZUabS9Xx0ZPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817964;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VArFlCtb9pCmnR4OIe6J/O/sKD9jy24HbcdjyBbUe4s=;
	b=ZkbrF8L1JSMeb2UZCK2zhmSY20ixBShtCJ45ZmJCyatW5sI4tz/wv1yONaEauPPAvN8L
	 57705uI3ZbGCCLMAXlfH41hgCao3Fzx7KMfTvFGgCY174Ivu6iYgw95kUDafzasGy9OO6
	 gIeSMnvT3nO8esiFNRCg0xphwkzH1I+NLF0EgxBPtnquJNUgpgsLtkYtQVbS4Czb7ew0P
	 bGp1dfshhfv1oZo1LEu6v8IE0mgMOQ4pJsXI+nfwv03VjCOKSpqFQUx2ovBgf6mwGAw1z
	 rpJh60SrDlz70LXeIirVioueYM37Oy1f/PqaSHzqnOsU/I97O0YS0Zuj4a/aq1WYihA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zkSDsf2i;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D85606A326
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:46:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6D85606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zkSDsf2i
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b060ec084so700309f8f.0
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817962; x=1794422762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VArFlCtb9pCmnR4OIe6J/O/sKD9jy24HbcdjyBbUe4s=;
        b=zkSDsf2izIok4I8cdnRpe0ERxo8+7t0ksu+R/SKshfMKzqM+Cfas3VEJ7ym4Q3+L++
         MGRvYkto56IXDiUx/P2np8cnR1eiC6soLAly3uiypeBsE9/kOR8U0/Cm+uZ/3mOSMb0Y
         vv8Twj5+DENLubl7ELAQJ7ZrWnzKvevGaaNpC0i9Z+RbMVsEPlGRtPMICCSPUbDuc2W8
         LgXKVLrU4ZkwjqQqNsmDW6KmOs62IoRxMXkXqLtNKUjp7a5L0uzswgZlmfpEi7J16UKa
         n9oPQ/zHS16MzoNQ4qIvl4sNsc/FtWn8K5xDsn+4fXMS81Lpe9jKadgEIumwBmzQSTwz
         FrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817962; x=1794422762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VArFlCtb9pCmnR4OIe6J/O/sKD9jy24HbcdjyBbUe4s=;
        b=0qph4sBsR4nBWSIVwnNocQJOJpdT1uMJfdheskyUVpPp4+MN5zR67jBLwsvFokZTn6
         u5Tqp9cmWXOmvgfSuxo9x9vbFRKDgquRYaXVzUGU1diTXIU1RtjUBcX338zwPMXu0cmJ
         t5B5Y158OVx0fIAsqEdwA0ZtL7586ShCAh2mLEFbA+FuhSQKHdcpsyGNaI0k0RF7Jjyo
         l7gLjUKtol8sfXJLov4YqVoZn82todt8SfLJuUsNd1XjNWXeggkfJ7gLbXxKnkdPDpco
         5yGZAKNOWnHGr9OPnbhKs4x2S/UgizztFQBGTJnRafF0q0l3GA4UMDfSYZrpNBjsUgYB
         VjuA==
X-Forwarded-Encrypted: i=1; AKwUvBwL/W3CUC6EZX++1RBV8341TBrom3EZbCaY1TinXcENTb6dvbRd3uoi5D2XK/jk9/LuuhBsQ05c+KcK2Ec9@vger.kernel.org
X-Gm-Message-State: APuU4Z8KQY84p/hz2GJJtaZrfzSlnwmfoudJqrVGNhb+Poz/+5CiHErR
	xfLv5MkT1DBrQMsagCqs3mlpB+R6JloHS4UHSy2YMLAaOBdLiXYtvrUlg3ZxPzYA
X-Gm-Gg: AYBFou0Fe7ZxnH64/DFK0orbbG4SAT3I5CXZyhg7lfMyUfWt5b9jjCIfCGLwGY6JuhJ
	+m/LL+paqkNrE1bebwUL/PjfOFv0yQ4pYxedhz3rdzEs0PJvYZbzssWc9/fX9MZs4n/iA24wk2l
	NcTv7BR76SfqQRxy2QXZyh6OozzhcCuL8WLllZRSZzsAa7lptd+HIl1iWYkS3MGiMpkj3lkfd7b
	4b7z2oZ7BBHy2xx/0OqC3Foku68X+ireOTuvlFK4beOkHeCY8I0pNFSMp0naac2kwyCbJyFxeP8
	iLvbn9vEd2LhUk9w36SmtBu5CdHEl8+aMw0Qic5w7b0BJJiftoFJn2HJpUYO5+n9LDI00raIkZc
	opc5DrKtJFnh83YKoFwIi6PJqAxwuB1z/tzgeh9d23OAlQMTxj8s6hpT4FuwfgP924FVnOttKcb
	yR5BrMOeHUw5zIwdP/TYqXNg86Y1kAawCaVFrerTgiQiGSOwgU34l3Hvl/b8Cj3d56RogJ09AQ/
	lR+wjqkd2yL/wJxEZgIKAaNExTIe5KL+iwdDL4UuV1YgeX9zdQrnD0peOFByb12iGTDhs1leoRJ
	xGF9tk9Dt8QV94sWj4pM+AYdI+lKMQPTxD9mQ+TRxdVpPa+4JNwy+9ZUNz02iDGg6TSVU3tOF9I
	wyNCQd0wcqO5UqJxwiBqZaewMOdoex7yw2Q==
X-Received: by 2002:a05:6000:41c8:b0:488:8437:b8b7 with SMTP id ffacd0b85a97d-48e6e2bc714mr37538611f8f.7.1793817962193;
        Wed, 04 Nov 2026 10:46:02 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed92a753sm6034141f8f.45.2026.11.04.10.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:46:01 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.6 1/2] ovl: take a snapshot of the name for copy up
Date: Wed,  4 Nov 2026 19:45:58 +0100
Message-ID: <20261104184559.3630145-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104184559.3630145-1-amir73il@gmail.com>
References: <20261104184559.3630145-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mason <mason@kernel.org>

commit 65bf000962a33ec9d2488e4e1797b6cf630abcbb upstream.

The copy up of a directory reads a freed dentry name when a lookup
moves the directory at the same time.

A pointer to the name of a dentry is only valid while something stops
a move of the dentry. ovl_do_copy_up() keeps a plain copy of
c->dentry->d_name in c->destname, and ovl_copy_up_start() only keeps
ovl_rename() away. When a lookup finds the same directory under another
name after a change to the lower layer, d_splice_alias() moves the
dentry and frees its external name.

With a delay in ovl_do_copy_up(), a chmod of a lower-only directory with
a 60 byte name raced with a rename of that directory in the lower layer
and a stat of the new name, and KASAN reported a use-after-free in
lookup_noperm_common().

Fix this by using take_dentry_name_snapshot() for c->destname.

Fixes: 829c28be9bb9 ("ovl: use d_splice_alias() in place of d_add() in lookup")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: destname is set in ovl_copy_up_one(), take the snapshot in
 the non-index branch of ovl_do_copy_up() instead]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -869,6 +869,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -897,13 +898,23 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		/* Disconnected dentry must be copied up to index dir */
 		return -EIO;
 	} else {
+		/*
+		 * ovl_copy_up_start() keeps ovl_rename() away from c->dentry,
+		 * because ovl_rename() calls ovl_copy_up() on source and target
+		 * dentry.  It does not stop d_splice_alias() from moving a
+		 * directory that a lookup found under another name after a
+		 * change to the lower layer.  That move frees an external name,
+		 * so take a snapshot.
+		 */
+		take_dentry_name_snapshot(&name, c->dentry);
+		c->destname = name.name;
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
 		 */
 		err = ovl_set_impure(c->parent, c->destdir);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -935,6 +946,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 	return err;
 }
 
@@ -1070,7 +1083,6 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-		ctx.destname = dentry->d_name;
 
 		err = vfs_getattr(&parentpath, &ctx.pstat,
 				  STATX_ATIME | STATX_MTIME,
-- 
backport
