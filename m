Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793236174;
	b=kB26ATk6BRfMqzKQX7QwgxqqudzcbBeMqUfoOoyo+mu/KLwuXdspRpJx8uPKPv6XWIZ5
	 Bbn4/Pt2G1bye2d38+TyxIYq+ePjtxFcuo2CXL5RI5nHD6sKvtN2ebown4pGiF6SYttlg
	 fTjnC5/T8FLzV5sfRoUCFU+ShYpQeai0c1ozjwuItVaVTmlaISs2o4/smhmEdRIh2tnWZ
	 MqWTmP0rdlMeQlmNGZ2uutMk94A0diwe7p9HMjonBzhZwiLLV7TtH4LcrSfCpaEPFl9kC
	 TNaQb5jMkcv8QW4qxLl0S644phS6Fucaw3OGFQX2FW6EGyBibjnFmdM/vCBkXAe79lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793236174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=gFCERTgb72WMlkM+VHwKAwEohFgnnSyuqaJzdLu0lwQ=;
	b=ICFVwnp7oalNngR/Jlhh0N0S32ipDS+NXtAKCR9vhjZD3uqSIZFyGXRPSktsWFkmlq98
	 E8ecRZyIRhaRZlufTL8IQefMnljZwH/OnzMmdV+Qxqq1Lv9nvMcv1UwBX34ptgd0jCNNk
	 Ec/ISFpyI3avIxqjbuV50R02TRw3EI/MfKpoH7coSLgRF8Ob7npbBghG6Fz5cpD+5jEKJ
	 jUTAub8C3iukg1h3AxHMFjb7QnJEz1QVYU41JTwaG8+iNGDT/Siiae9IsVcIqqA6JDPRx
	 6zOJcWzZHH9sQ9FI8tBCKzg48ITaqZarccEqmkoQYMS8qAi8ig6Y0uI5LIIkgAicqBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=kft7WEya;
	arc=none smtp.remote-ip=209.85.222.182
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B45060A2602
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 01:09:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B45060A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=kft7WEya
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93e515769d3so132126585a.3
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 18:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793236173; x=1793840973; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFCERTgb72WMlkM+VHwKAwEohFgnnSyuqaJzdLu0lwQ=;
        b=kft7WEyal6Mtxw+py+3vE2ga2X7efSjbN82dpR6rYuxiWISRg7jlrDj4zu2Km2aJkm
         wUhXSepEUX5xOhs1zLoqx0hQFYT62gKMKeGxiDTNrIBXF42uFk6F/SY4da6vtMNMg+VX
         zsnlx0oGDAmO0sgGAP+1KdvbrjNsWsemGGs16hg4WYGR7L/w/dlaclKV93GPTmUtFWEZ
         +hqe6GiIAOvxAYCdpule9LELf0KNPqh7KTp+L8mxUOi409x+4S5Fg+6FW8iGIdEo+JB/
         gIjBgIAEWI8lOpJHyOEWRp6uA7HIfiFeQED21Rl9Mo29P2C1IOvrSt8OROkNlJxc9YT+
         b91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793236173; x=1793840973;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gFCERTgb72WMlkM+VHwKAwEohFgnnSyuqaJzdLu0lwQ=;
        b=hh1Zf1ACI6eo55pjgcWG6kEPNPKNPsvEDVpxrst+R4I5KuS/tte5ytSrtDfMLKeD7n
         +kALlRSSSaFra6cP3V36THEDT7ask24+uD4+9VEjE0tlemxHCKfoOnbl3Rjzdmjtjdjx
         CASXnqDC0UBmT84oCzBPkF17Pc19BCmkUGuGt9X9wg+5K0vniQjGLNoV9sNbWLYS/Ns4
         nwthG0r6OTu5Cb4TWQ2EtAElbjEYgwvOFpMmth0+d7kyWgmVHOUEOUyBjd7Lj3WXAp3W
         xzWbncoSmsSV3thWYXgVD8elEs1CJG0NZSVCATyUx76FLVkBdHdVgZr8ZfHlVq6ilyP/
         wBCA==
X-Forwarded-Encrypted: i=1; AKwUvBwvN4rx7KNahu6KXbJTScd7MecffP9lny9hQDmDq4fXgjyypWpn3maNp1lZ2neFm0CNRJxXK3E+/BguU6MA@vger.kernel.org
X-Gm-Message-State: AFq9FYLuyjRUJHyDmZ7le6bxaHvz+TLYyICyttSlCRGdwEWbmI3oMb75
	nIrV84qIoF3FHDBBhJMaakRzgTOVn42jC1KaxEeYaf3tNvYUYm9Sz8/ITsgzxDcKzoY=
X-Gm-Gg: AYBFou2UQBEIM/PF31qVVLBvK2XiZj8TMn981d2DfhUeQfJ6JPK+8DW7Ma+u7118BS4
	VtjaouZR+L5uYrCZ55h2xRxsj0MrUiD5x/FkmPOdx4hZ5QPBjR5rlau+CHkt5a/8XSFYR2jGUn0
	G/2f6kOkub/ffQpsbJ6YEbnH2KSosCKKPeVkk3omCwBOPhY8o3jq578yb1qw918Q1ShH6cIao3p
	FZwSfSQMFEB+zIkh8ZnN5osRkRAO1u+o3G1g001bHd/sJfkCK/qCwdjPMP2sOdULuKoD09VjVNA
	UybFN9M1qQAmvwdsbnjew49a6xECkERN9otQJE/sRQxw8bBvJ3Yio0nKZvVJS51y46FpjoE5teL
	C70iz9eqsRc7fGfZtJRAl3SHULgWGkpNtGMH0LnR6EBpo37DnHtCjT9txEDxtV1oIq5JA4qmewO
	1VUphpmSPnQUhZpePUMKpiAhFuZj2fJagp7aRCPuCUrXUVd6r6StXs07ky3O8OKJolHWJ1SxYb/
	EhoeeRDp/G9g0xCIrErU48dijt0d4Wg1N5UAEmc6BvfpeUgltr87WImgLQNqnLruXfujy7I0ecq
	wgo2VcE5tjJX85MbfaNCtFWbXv5gm7bcQ8rr2LfD/uzT5w==
X-Received: by 2002:a05:620a:4008:b0:93c:6534:d04d with SMTP id af79cd13be357-94408c94a0dmr645547085a.35.1793236173151;
        Wed, 28 Oct 2026 18:09:33 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.243])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0669a0fsm1395885185a.8.2026.10.28.18.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:09:32 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Oct 2026 01:09:16 +0000
Subject: [PATCH v2 02/10] ovl: make the root inode appear hashed
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
Message-Id: <20261029-b4-ovl-containerized-sync-v2-2-4e9f08e4a052@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1793236165; l=1088;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=cstaBtDiRM3QOK1D9GwdkdQtwlI5aVSq+4eziFPxk50=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJHbrHkdY+awlgNdib/Omm+yfXK352B7NAqbwS7F/Xv1OBqEJSniNq3g9BuokhMUHW0pb/B+ByL
 ghELlNiv/twk=
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
index ce3e30235ae9..f0ca1539022d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1366,6 +1366,11 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
+	/*
+	 * Nobody looks the root up by its hash, but __mark_inode_dirty() only
+	 * puts hashed inodes on a dirty list.
+	 */
+	inode_fake_hash(d_inode(root));
 	WARN_ON(!!IS_CASEFOLDED(d_inode(root)) != ofs->casefold);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);
 	/* root keeps a reference of upperdentry */

-- 
2.55.0

