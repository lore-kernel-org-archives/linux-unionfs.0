Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793972229;
	b=Wh0yUDUrQ8yl/IHAPkA+lCZho0r8zKxZK5d5XgyhR/1huglvFYe9y+YGC9/kknGtSvHa
	 jBLV8x/YRdP4WYwtiduLgcdjzvCVZtI3OG1MrQC+hs/bZp4cm1Qx25cgihr3m/WdTdclV
	 fWRvybPsKdvFuQ03B1XJkevpkev7Zzvo5z2ifM/92YbRXPlHtJstb5O5ar3PSgd6xgC+Q
	 5ZtyyhirGyJVR0mYdXlB3YDaHZ3EDNnTtCK/lS7gDYrS5fKVoToBTukzp7bCZ6gSqylsj
	 sLqgMXBBJ7htXRE+SkgsSNaf1Z98KvFRKtRSoXuScOr7AO5H1tot5e/UU/kZQvR5gpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793972229;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=sLwuZPQ43zw7H/off7wRnGr3Z+fljgzkXkXA6hTWCoM=;
	b=jlJxXDXcLEli0VjA3CJQwFqThw4LyE0cqmZ/i+AIwz5aIqvIWUARURFzSJuAo8GjQfQx
	 K+B40BxcqhiWB4+UCU8WCPRz91F0CgnGltoGZZYwSOwfQBum6/+Kb5jiruQFC3GBCHp7n
	 zm1HloL+WZv8Q/TNkPdk+F4mIGYJlFkhIfVu2KwtXWhpYezWRBuRkzIB2NPTGakoWzo7l
	 GeXet+okYSX4Hf6/4Het2IjIN+wVs5jhYB3wexShOvlBgs+qUd9/ilVd9+hbNn1ncFaxY
	 45sQdG0jetmUActy/j614iQ01TgEPpfnWCbP1wWB3R/SK0XNuvHfo6KHUZzcD4X65Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IcFiOiBy;
	arc=none smtp.remote-ip=209.85.222.169
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A005606D815
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 13:37:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A005606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=IcFiOiBy
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f36c18b75so44997885a.1
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 05:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793972228; x=1794577028; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sLwuZPQ43zw7H/off7wRnGr3Z+fljgzkXkXA6hTWCoM=;
        b=IcFiOiByrCGAeW4r2kogNU/W4ccrovkv3PKCMl4VVNnN43ra7QhEYYKakZJXWvzF7u
         n6bKiAzP4nSh4471m49j1jM4w9r+4tWYwYDDpIDv69vGkfjrw+WgwGStZXCDQuVld77k
         j6d6/elZbz0o4a+xHhiqK+ztm9+xiUXmca+MAYL6sX8rOxPEKVvUX2JVJxOXAwN78U3b
         8MBHwZ4GovXnhT+JuY52/guoYUWezjL0MDVAvCsdO3hX6y/Blfhqs9gy/EtSgrg7MP/U
         VMG7YnmMd7aYiWepkzQFkXP0SpXMf6VWthfuGM9bkmjqSl0fzk3Osnop6rGgJo+rF+uD
         ZuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793972228; x=1794577028;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sLwuZPQ43zw7H/off7wRnGr3Z+fljgzkXkXA6hTWCoM=;
        b=Of9iNmw4VB7kV+BV8glolqtRz6MHGLNdBcVVsHDQXo1Q55NgunYS7ypP6wFSY4+TFm
         /s4jicu1dZLlczZc27cOGZPcrPNO6Gwan2p44Z1TbkJk7bfK+Fj8gmU3D9ew7QWilwaX
         pYScQ6nORAhMZ6rWfqsXOr7gp667w1HeSwQQv+Xf7xwBIPnjZ8MF9P2R8Gz+wV57kcd6
         yNrlNRnt7pp7Zh7tAIi4KzRIpxhRK2zbVhhqld/w/5VpRGuJWkTLHmyuQfHXXyuawlG3
         ZCH7Q3Ct9QqL1W4ljH/DsPQe3AA9uKCmfsLJruFD9LLAOkV/tN8aQyZomrQetE1Iiwnw
         e3iA==
X-Forwarded-Encrypted: i=1; AKwUvBzhIuJuMXa/Ay5iHn59R/LmaQ4PaogL3Nv0Wk+cy8/kb/WiExgY80dG+59lWyjx5zMnkCMVuI5O4DX8DMiv@vger.kernel.org
X-Gm-Message-State: APuU4Z84lj8h1xPpk73B+ixyYp+oouZNWL+22S822KCi/sd3pRZtYe4+
	oPG/dKgCEGllX1CWBuzOJfJBOmi6rAVuOUg5eZf0xUYstcbwMKpyA0wFRj+nJjpM0+0=
X-Gm-Gg: AYBFou194qSs542hSzUHNK+fSf5lMxB16EemvtlO/3yxjiWbcxsRywbvuDTXFZWI9iG
	3xbc8SBoR1GS44zQvHlZtMnNj6AWkC2IKRcz4sBM72vKXuoiZU1a+EPizMCmsx2gRMRZpZVzpN3
	5IQVwyHeUkov4rPrRpaXki3fccxgDv4R513JuEtJ/USunyfJl6Vk33xKoSZnn+72e9py060A5Lg
	Pjnmxsq4VvyzUsx5cJlXAGRqyGgy8gog1p7uLNyXeCXmFG5UfO6StfAe2yDdBXYlxMm+LtVahHA
	AkD+S9T/CaLTUG2+8Gi8YDWJ0sHH9UFYykUUVbHlA+cWHAF3BaTSiolrnOgHSXYQwm17nhDIfbG
	pk7K6Gq2uPTKjRD08fDSkWNE97y56kBZPwaXV9BZblifuwIAR0e9GhbUby8bSA0K0byn6CfNMPC
	4yPvENWPt4ehHxyzSyaGHZsIVEgFmczFv+/DQ6XkE17FDyKhtA3i1L8nSVNb4bPNC8DoVF1wNrD
	A1XsvcL3ZF959NKtT68rlb+X1H590BZNuho9O8yiDRIvOfEB/nTaYVUhCVRVM9+bs7EFk6RC0HX
	l2/OOPMNsS8HtQHfhflqwiJcFV3dTqke9aA2L2JJy2Nmow==
X-Received: by 2002:a05:620a:28c5:b0:93e:7ddb:5098 with SMTP id af79cd13be357-945f34af8b6mr355669585a.25.1793972227555;
        Fri, 06 Nov 2026 05:37:07 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.254])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945f5a95e82sm144243885a.12.2026.11.06.05.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 05:37:06 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 06 Nov 2026 13:36:48 +0000
Subject: [PATCH v4 6/8] ovl: cache dirty overlayfs' inode
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
Message-Id: <20261106-b4-ovl-containerized-sync-v4-6-6ddde0b7dd8a@toxicpanda.com>
References: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
In-Reply-To: <20261106-b4-ovl-containerized-sync-v4-0-6ddde0b7dd8a@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793972217; l=1773;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=8D/WsTmpQhuh8wOYjV18U8givpb6bYlz8XjxGqBtv7o=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QA9RmpaU30QmRGQWJMahS83ENZAdOVQF1bFKvrcIoJI82hjYmRv/lISjRXjFBS8IHeqXVpuFldu
 fYqirWgLzfQk=
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
index fe4ff5c6ce07..87773b73f228 100644
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

