Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236181;
	b=Oq519tVBCZrcR2EN+dJHbXWF/6r2hZF/OFSeOeAXC7gN/Hlrq82hWBOmfYo3mzrHdw3M
	 t2ayvoatzMfLuEOWIY2gF6WRgZ5SOFQZR0jYDE7trbhr1jMUNq0kYSt9saKoXLA3+OFGo
	 c+NDlZIRvHxRVKa0hSE3vxytS2UGklqNQ927x55upfTadqZEv7ClHQ+Wa3Gp1bRKSSX5j
	 mg3WIA8hm5ES1TReqBpOuscsmArJ2nm8qVukDIke0lVY3elPNXS0DLXcuY2uaexm34LOm
	 gLLP/us0Ztn3vp9QO9QakMIlZ1f/McjmfQacJAIRZN307RG4RS1p63y2wXARJ31wM9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236181;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=VhnQvFMBWmQXRcs2LH7tdr4qlxDY+S3Z3dB60xAZW9Q=;
	b=yFqpWZkappnuOZOs1fpmreCjz4x0LaDJQqoc/SI2wAYGf0ciZWi7A53qsed9Yp8JEXSW
	 TQng5OLUhLj4kw8tDrRmeINW9xzhSmnQa9b3htZcuHV7jUZPabSfJDKJ15igbKLMJOcUt
	 HjYZ/uAFwvwfESExe9YKyrLLeeyuI3e+CYBNJ4Soa39P+VIKKNlX0kg74g8HEUkz0H0Qx
	 16zqEogHcJFIiFoyakZop3zDkbFoD2vZeDsjrntQelZqQVbxP/vOvhR0YXtRm8ubJuess
	 Clzs8HoNkkHeWnri2Xg7VcWT+OvVyQ0xAdlXuxuu0cbJbGaOYkUL/sbxTHZjmIgrLvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=ckpJhZ+q;
	arc=none smtp.remote-ip=209.85.222.173
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561560A263C
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1561560A263C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=ckpJhZ+q
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93f3c89594cso107510385a.2
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236180; x=1793840980; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VhnQvFMBWmQXRcs2LH7tdr4qlxDY+S3Z3dB60xAZW9Q=;
        b=ckpJhZ+qONPQQbYzD2UTq54ct6Sw3y7LCcmluW5900B5L5voVi9KsB4AHmsZpYPI54
         LHTPeu/IrIGaeQ1R+XHGW6ivWBs8Zcjm4pH0N0Ng5kPCHweLOT6Wo/elwz8Xx5ecq/oZ
         Si/F3wosx9CC6orZ6F3rgJSEzeoUNRNBJuLkQjtd9Wf1cVbjj+TYv8dDlP+zA4Ksu5qy
         v7qajcjZXJ8NGdcsK8FRBPx1QN8qNUbdr5qRlsCEiFQShQIphJQIQM8iFQfBtE/U161B
         +34HwT2hSt+umXfcd19pwwn0jMkLHqOwKnW5BTMD+VFIV3S0/X2zUpeezujgTLclcKye
         g3tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236180; x=1793840980;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VhnQvFMBWmQXRcs2LH7tdr4qlxDY+S3Z3dB60xAZW9Q=;
        b=qQg8oiZBszo7kk1zPYmnZfd4RXColpUQ7z7IC+uem9K5P6/nQkYF9qPpeTAa+BMBE+
         nQAE/rERMyciYUge/zJ3p4yEe7XNO2Or9ZVq9xcEeBjMzxXj5X9kMcMeSzacIbiezVO3
         LvTgG6jswz+8yr9u98KGDfRhiMaR9uV6dhqRPJYTyfCFhR2pS2n+orGatFLp3cbGeNaH
         POarWboTtv1xjY/d4T0k//LJ2X1l2R3K1n0WvjJHt3QLf2HvHWD4UN1ivVh3ga8nejrZ
         FviC6bFGWS0aYtYvOLEPj/SaOZYqPnFFFSU9TfTdrHs9pXtO3ES8Z/VCAespde24ky2K
         5FEg==
X-Forwarded-Encrypted: i=1; AKwUvBz9LoWXTqJZjlCuWba/r4PEOWlHAnJeqpzr0o0of/S46/wURoB2NKJwZDpvjZ++IsUEnnaeHc9t8UYVKxVH@vger.kernel.org
X-Gm-Message-State: AFq9FYL5CzmpwgxG6PzX1asgvRhWxEeMvsMt29z2fJAgspRaqYWFre1v
	MlWT+i/RKjD0lCWOd5ncPm25jtdpd47URSgVgs95Idff29wCRND37wCJkFRl+w+yBmo=
X-Gm-Gg: AYBFou0vpFRvMNcwYLV42+kzmp+a21zbnF+aKubJNcJXb0GvH2Xo8TvdOclXHbE+YF3
	P+SKtg/3/7LkhUZg9xfyo9CLAH2v21Z6uhfFrzAY1MbKlfWwUUvbb5F1qg8OvpnH4CsYDDsNmGx
	Kzxl2qQG7FAgocxjt8HgGsz/ws162cBYCObqXTXhy/d4zwtFFZCLimY0YxnCmA/cWaip77lmUl8
	1KdAEO5WC6KOJdbzWZ6AE77gGXo8R0F+9gvMqQS4I/dqeDQwM7dqfcR9FQGTxDxolnUuYOSlBL8
	L+P+pWfFATKdBKabVKK20YX8U4aqkDeAu8+vriTfvh3tnk6B0nPrpESWnl+7Nwgy5G2FLVRWsMc
	GV/nrPu2Zuxy+IQhySbdZ2a1Uv3y2qgLPhxrjsAM4E+af/BCPupAwQdqlTJ5IebIPgBeoxdwUVg
	fdAW7JBS5sdtRoi7/oSm1vpo9FqHgi1KtXgWoY8v2wQydiJSvqevcYgSBF67Az1llitlFZ1qpM6
	37KmM++XQyDYdv0/RR7UIfgYI3I+TS2vFjspyYe/Ar8N5ol+fpPLktGbaZMRgwO++uYDZZNIIZk
	/i5xfBqAxtbX5qED2Mi4WajlRIWaU1GRCYMMsdXmbFtdyvbpsIVLXUsjerFvPvRKrOY=
X-Received: by 2002:a05:620a:2a04:b0:93e:6a4b:3ea6 with SMTP id af79cd13be357-94408a268famr627465885a.24.1793236179900;
        Wed, 28 Oct 2026 18:09:39 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a94a5csm1403038885a.41.2026.10.28.18.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:39 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Oct 2026 01:09:19 +0000
Subject: [PATCH v2 05/10] ovl: cache dirty overlayfs' inode
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-b4-ovl-containerized-sync-v2-5-4e9f08e4a052@toxicpanda.com>
References: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
In-Reply-To: <20261029-b4-ovl-containerized-sync-v2-0-4e9f08e4a052@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236166; l=1773;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=RBYClNWPOGPAjYFAlPxqB3P6LQQ7aE4KvOPd0H7s5Y8=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDEhXxDI+uaXyyjXjTHfF9WLGtv/7BLkXM7HaqSwKCJiz/3wVIQo8KKsXwdjocRmwTcWL6I9AoZ
 BOVS3S+YHtAI=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

From: Chengguang Xu <cgxu519@mykernel.net>

Now drop overlayfs' inode will sync dirty data,
so we change to only drop clean inode.

The purpose of doing this is to keep compatible
behavior with before because without this change
dropping overlayfs inode will not trigger syncing
of underlying dirty inode.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
[josef: also keep an inode that is under writeback, rebase]
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4e06b3c772fe..a68eb78a9061 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -392,11 +392,27 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 	return ret;
 }
 
+/*
+ * In iput_final(), clean inode will drop directly and dirty inode will
+ * keep in the cache until write back to sync dirty data then add to lru
+ * list to wait reclaim.
+ *
+ * An inode under writeback has had its dirty flags cleared, and only I_SYNC
+ * pins it.  Such an inode is not clean.  ovl_write_inode() may be about to mark
+ * it dirty again, and marking an inode dirty that is being freed has no effect.
+ */
+static int ovl_drop_inode(struct inode *inode)
+{
+	if (!(inode_state_read(inode) & (I_DIRTY_ALL | I_SYNC)))
+		return 1;
+	return inode_generic_drop(inode);
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.free_inode	= ovl_free_inode,
 	.destroy_inode	= ovl_destroy_inode,
-	.drop_inode	= inode_just_drop,
+	.drop_inode	= ovl_drop_inode,
 	.put_super	= ovl_put_super,
 	.write_inode	= ovl_write_inode,
 	.sync_fs	= ovl_sync_fs,

-- 
2.55.0

