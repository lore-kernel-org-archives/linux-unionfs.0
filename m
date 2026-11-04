Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793825123;
	b=zPJytgnfYCQMej9FjOR3plUyg2g/d/50FP9aLCbUJRUnoRgOQ1UiMB+gTbdWReoYLUQN
	 qQYCWIMLvsbzLSN7xpZKIce3hHj1L/CHvYeSFvV0pgVhy2KL4E40h+Ogy0oCdmueUyqD9
	 uMN/TU8S8dQ5CPXZ6j6zNDfwlCbY2tTm9wqClDH6HAThOFVgb3Yxw4TZe8q1N8b8MYs7V
	 i1cv78Ai77vCCzyKzG7EUr4/4JxWnHNZIMxvcgs+JDKpiFN/NubheNvddTDrW5jG0kPY3
	 ZVjzRohDMVED/Rp9OqoE6B61QOiZhGydO5ipeYz8w065l+S0pK4ovKODbYwoSxqeLrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793825123;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=FFyElV0JGp89hQTPXMOgAiCtnc9VkWZMulp2A1EvBCw=;
	b=foqMS39hpJ3kTgPa2OQNxshUmrQzdI1lAiWAjGeF+kUY1/VykI1ts5+g/1/jF8ZSZ87l
	 Uyt9K1xcT9yl01wc3jMjCC5ghrwGfOs0laRE17gcmg8GSh5bAAWizge53LgTdKVM2BCsX
	 Hg30ixLWUCptjUJ4f6ObBKwJ/xomtyk9ALZqk9E0Zw1JQrMoSi3hbSli0sJadyxhom6g8
	 p/QLG/Vdf385lyJvSTLD1fa6Txg3hfp61KUb829exr8JABPEM326DLoj7IuY+4lapx/ey
	 PC495rmnrXImwxNEOAJWa8E5CqZ/s7wdIBFFQusbPdNxQNyofv+oBX2c+DsYwkrAV9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=fQ4rD7Ol;
	arc=none smtp.remote-ip=209.85.160.182
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28EF6077B55
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 20:45:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E28EF6077B55
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=fQ4rD7Ol
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5364648ae07so10434121cf.1
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 12:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793825121; x=1794429921; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FFyElV0JGp89hQTPXMOgAiCtnc9VkWZMulp2A1EvBCw=;
        b=fQ4rD7OlgZ1AHHMJIiqoY7rklz7cTMHvKZOCzhhFEN+Y4cBrK4y+ymWwQpmMR/v57q
         qzNB3cnm9BTN0I2DWpswNhTw+8lHIgS63B94aURnhDjmVHb3MDYbAc1KdxaoI4y6Ztai
         +ivorZNFvpAgZpDQq0S2xDYk4Pc54ttUwDTzHxsTrxsVNI6qFRAQfBkMP0fewHHDz3Sb
         qjKhrkVX/ioqmYQfn5hLa5niWTuOwalq8Bt/dtctMbNArNrOi9kA+dwwU2EDzpRbwq5/
         WHRnW9Kf3SV9VlIAl1VRtgmYe9be2K9RJf9mN0fyQDT18w2h3K5FDS23qJjXG4z1rfkm
         hugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793825121; x=1794429921;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FFyElV0JGp89hQTPXMOgAiCtnc9VkWZMulp2A1EvBCw=;
        b=fcOrrZs5GKDulJsjkVGFcRsgbTPFP+d6nQZJrmvbM+Q7SDxTySbeE6NWm1HvLcgpEk
         BtcDGdGkZOWLd2Ug+lHDDJS7P/829zp0HpFe+NGdm4NWxBhnlzBmmQyN+pXqf+R8PT6y
         gw5lC5/sG2+0b6wawD+Xya76tWMriHY5Ms06+2T0ghUx2Z98ExI3XUKP9G/43ImssJOL
         49RsVgwHZ7gq18C/FbE7Zpk8TiFHX7kfdO1/xdUy8oIVAC+Q6vGUEhwcjfrpCBaZpeQY
         /9rQG7NPSsBF9s0YuiUF2zRmkMREOK8Kc1mV/xDNmsubQaWQL0kgySFLS3aEns4XDnto
         N1Ng==
X-Forwarded-Encrypted: i=1; AKwUvBw9aXWZvHs4AZIqeiewgwR99dceisX9m9aAMRNsTeTIj0dcwzjD8mYjgMjT7raHvqnpSPEFCTYuPrqg1Wxz@vger.kernel.org
X-Gm-Message-State: APuU4Z/TcGev8deF4RmuPsOGa4R1Z9sTTnTImAfT1396KAi7Sjf4Zm/k
	uPwMshGK+D0OWDjtJdy44RtWHEfMMqt7AEORrYVR2li568Ib7gr+7znap+xDlLzy1iY=
X-Gm-Gg: AYBFou06z5D6Pn3v4CWpFBLMvBc/7KZmsMUTD9J3OkOn1HXX5cqEayMjYQx9DRx26My
	XNneYOruc12MxhshKw2OFeC56BadLuM2nAmxbgF8jnX1mYNQLaHt09sXzXh6KNHPWS2PaOk3yoJ
	9xcDI8U4fQFmiHkZ4xbRQmVz5Ko37I09VSNm6ALgOrbto+7KzrAjenbpTqmc+iwD3Ap7dwCfpXK
	6YD4+b0QQDYjkAJ+iOAmtMsqB4qnz8kqvsmpiI/82HTVq99RYwJfN6TY0snoRvRsmUA0SmEpV+z
	HxHD14Dkhf5Bu7UY//p2sSGYQ/9Ea4H9Pw7sP9p03qV0w49I63Dg/4P1d/PAjy3FBGF2LoH1dRG
	CJEMOqe8QzKZukkbchxx48KhyyiqKddAnwmQp0SPBimNHkhIFg/o0PkCquiejMkt7wLUPn18KL+
	+K62g1N3TZTFIsSZ4jV7sciz7i4zp+M0x9DN4HRdIvc5F5cVANn+QOH5WEazDUOhCfv1t8A1qmN
	BXfNtW46/p/2KETr4e/skoSBDy/NzqUuHxEaK9xt7vbPuxA9p4ElULyMjdU0AveogbCIVBSW3cu
	6Ld67687SHWCrrzKqEwzb9zqzIjzNMVsNFJrfYjX0SPN0A==
X-Received: by 2002:a05:622a:38e:b0:536:3760:e6cb with SMTP id d75a77b69052e-542b6781aa8mr290505121cf.14.1793825120793;
        Wed, 04 Nov 2026 12:45:20 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b100ab8e4sm33768751cf.7.2026.11.04.12.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:45:19 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 04 Nov 2026 20:45:00 +0000
Subject: [PATCH v3 3/8] ovl: make the root inode appear hashed
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
Message-Id: <20261104-b4-ovl-containerized-sync-v3-3-8daa20144f53@toxicpanda.com>
References: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
In-Reply-To: <20261104-b4-ovl-containerized-sync-v3-0-8daa20144f53@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793825112; l=1088;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=ezVCiVHlXduEGN/JKqN233jz7I4B7cGFx2BULYbRDoA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QORkF2pQNIHUPSjD2pa1aC3HFV9lTWplFwhF2J5CN4s3vwCfVwe1XEffjfEYONUnvhSeIGOq7Kb
 LRgXuWs/4SgI=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

__mark_inode_dirty() does not put an unhashed inode on a dirty list, and
the root inode of an overlay is never hashed.  Use inode_fake_hash() on it,
so that the following patches can track it like any other overlay inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index efa4d862039c..55635648b3de 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1372,6 +1372,11 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
+	/*
+	 * Nobody looks the root up by its hash, but __mark_inode_dirty() only
+	 * puts hashed inodes on a dirty list.
+	 */
+	inode_fake_hash(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
 	WARN_ON(!!IS_CASEFOLDED(d_inode(root)) != ofs->casefold);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);

-- 
2.55.0

