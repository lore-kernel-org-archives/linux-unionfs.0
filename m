Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794079197;
	b=as5WWWv1otbipSfmA0M1psrRm4mXyz5mgL6YKcufvL9Q5ZerSd06KcrR9M/hqQqWnBzT
	 GbSVZ6ykZSwZhA1SNiVeFfIka8wszqxMFK4WUI47V0fpeTMOLOiaPR5OLaKxWoZmvUkEW
	 gdlOMgNcFBn4YCMzJB7BueFCl8lunP4V+ovvo8Yn1DJ4uGE5mojuYTzmoPQOcOuVCP4oL
	 bh8HsbYDy2GuXUhfcRoPgdIqTkLhVUVgArJUqMtIbuipSNsaaY7Yr46X9mKxdCF5XvgXF
	 ADMOjxXQtB9+e4PKzJjDhem1YlQwm2IS6XhCJUofJDRYRLKy4ccVnRDcbjWDD1Z89bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794079197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=8zerBigyv9mmzg2Gjo9e2dqqPP6k5FgIy3HAg56oVSI=;
	b=l1JmtD7+GrEx+Stirzcwf+TH2kJg9C2v5BUlgccmjzZNLdawYD1uEjC/tBzgPUEKkk8/
	 8hZvwJGbtijnD9zRjUprIgPIwKC32UlnGIRlgPrxWB64PWq4cmfqeoxEz5Nter5HHKIld
	 APFT84sCGn+yNtTiXpJlTn0Hbn8/jHhJvq6GGWfJCg2j//1K8glynSzNDUUeXeMLu5gOj
	 6L4j+rTS+sQ0JMwOiK+/Pt7IQ1vgh25haANVRnHF+ZB343QIK6nUtJhdhT2qLwCNNZxR3
	 hG8BrDMXsdVbgLBdaR2HIxXMaAFbSTDpEAwwh1OTR6QEkig21xrNaTp7ple1WGkM5cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=AURhGvnE;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B041606EE82
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 19:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B041606EE82
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=AURhGvnE
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c11468b5fso17698986d6.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 11:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1794079195; x=1794683995; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8zerBigyv9mmzg2Gjo9e2dqqPP6k5FgIy3HAg56oVSI=;
        b=AURhGvnE8sFETK7RokAwv3quzHjXhBE30qWbkAq+wP6miAD+x6MkOmA/0kHToZBUu8
         t966u6k40pDVh4nfY1dgbvniGj6ktX2zMmyu2cUHwy+bbzhwAEO634XFVTbTDnh8veJA
         svlbhvYRnZV0CqMUUrz1L0BfALKnz2pvzb0Cv9h4JtE2oaDpDoLKDJRbUAtyUNS7hekM
         Tbq4tXg6VgIqtZKQl/pMUDFIlOHaVLtPvIhqTY0dUN8g/VKImdT/uBYTVDN6gQ1lhRS5
         LLBW/z/ZWQUg2seVaav7scOozI29kdsSye4+Lsoipeh5eaEuADj1kZQ0ngn8+gYXxYDZ
         Jq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794079195; x=1794683995;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zerBigyv9mmzg2Gjo9e2dqqPP6k5FgIy3HAg56oVSI=;
        b=Hso6Jswwb/VwKqk5h77eLnXxq+gXOc49K3asa74EzwzBcirPJeARqgZwRaiJ0bPSZ6
         6kcB1pPElo6YVKAFbfJPIaDnG2auYGcMSdYRnU6CpGKKlISAqafCm5tLKxZIQTQ0aWoG
         zeQ0k/uKLKVLp+qxV4Zx/F2S8bai6w6tpMLl6ivgGOWZ9ecOjGLveVe81LEdbDwa4BBl
         yigW9xIffbmqgnYxSdgZatda7NUJ58eW6BcydKrTkd6qvEwt4kRdCt1FZ9eS7IoJBB+G
         LKC1C3BnClVWKf5jS34sSJUdge+uLFeNaT1wxKvFWA2tBpwM/Zr6jxmGs8+qUvpC+R3f
         iwdA==
X-Forwarded-Encrypted: i=1; AL+hErETRXD5AX458eSU2onOYgMYQYXgbJvMaPa/KlqEhl1bJyREyiwEcUH2b8APLZTmpjkNO4AGEF1+qIIir8cq@vger.kernel.org
X-Gm-Message-State: APuU4Z+IizQMLoqW6AU3CCpwz4vUuow5zoXQb+PXyyTU+gMwS/nb/Nec
	FT0az5LYfA6Xbjycx2CbhqL39LokwbpZKPj2WbzT+E1RPeV3oN1vTvw0BiVbrqic6TU=
X-Gm-Gg: AYBFou1fCRORIWIF0d/zL/y8Mv6IlHh1MG2zOzII+CDPTVLp4inzjf3eLspuIUGXBPK
	KlXrIN36SnwE5YehouUpv6Be1OZzDZTDsyhxRBEHEzASzrDeoRKKyMg/jq3tTaXEhucH6SoF9G6
	CUlCk6+nRWs0dqco9Lbi10exvxlnKy4pbbTw/peVEOqH3SOLh/kFhZPtAOIE2crdcem8McQz/nA
	Hv7mrS15mip2aDte42432BOTTEcdkuXZ2GqGCtAPeHcDFae8Gxqy1DHvYeZSpsWY8jqoD+RPj5E
	qlT7IM0dDr5CJx96Db4h7tXpGmeBuY+DKk686dyWNJ91zPCT8WXqmGrJEw4y5iLXUYh5bLl4ZAs
	Y9BJv5XP6So/Cx0pDMrjMjdwtYjC9IvymEUjQeRdsLLI3KRkC29ZKqwwC6CnEv9kwfu3XJBKIMV
	088hCAbS+Y24FAlyTiDkHj6RYpOxwAT7Aw4E4/T8c2eTa9vBvg+TGUE+RcqUpX/FrwPh1LqEV4r
	dinYysfzKsTtG/jkVRwE6VR4cR+K/LYDQCkU2VaFOqFldI86WLKx9B/iRm80NiJ70SUxMMeTmLX
	QTrqZFxvfIhCHL4B0lj+XGHD+W4Zq5MlOwyHcE0tqqvbrw==
X-Received: by 2002:a05:6214:3308:b0:91e:b100:1523 with SMTP id 6a1803df08f44-91eb1001f9emr68146156d6.57.1794079195112;
        Sat, 07 Nov 2026 11:19:55 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91eceb56c90sm702666d6.3.2026.11.07.11.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 11:19:54 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Sat, 07 Nov 2026 19:19:35 +0000
Subject: [PATCH v5 6/8] ovl: cache dirty overlayfs' inode
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
Message-Id: <20261107-b4-ovl-containerized-sync-v5-6-d34b4ae57fdf@toxicpanda.com>
References: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
In-Reply-To: <20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1794079181; l=1773;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=4vtTge6/ThBXumR/B3MN7k2/gMZpZtKv00zfzARf7Uc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QE7kYqImzZByR9bEHLrMuC21KuaTdkAwi3r37N9KScAxvVGsqEgOJtwlmPwM2opRWHNScz0i8WU
 A7kMv3mM9zwU=
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
index 41d0d37accda..ccfbaf9d8797 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -388,11 +388,27 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
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

