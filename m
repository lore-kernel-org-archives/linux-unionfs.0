Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780491;
	b=YVA1dprxscvFBuIVQCCMXLM3u3VFG96UJxZz8YpvHlLl4OlFp7Eq77Dz//drzMnKOoxV
	 T1npUj5xF3hceR/QG/iKZswzMXEEVSRe07R6LJiWghmCVGExSFpxDI1ec9y0lF/y7ZKxq
	 L8mxZK1yXtoXgwPR84g8dao9QjUEUiT53RNvxr/C1Ys0qRrfWQnVIY8Ho77uu8xuePLvO
	 kyDKohbUfyO9JlDenKqeJm5BGa77OSH7zf5T4gU/Wp5t2eAL6Q6ZC5ykEqYYWKcFcY8Ne
	 yHXouvr0X0v7o0JVeKD/hf588QdeNBxatsherGNe2iwzBbMsTcV1lZjneatXQwKT1uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780491;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2L8Phg4vAm8z6UFJHLXifD8svd0Kk4bbcZZ25kyGs7M=;
	b=RwJ5q4P9nVKT8Z6QAFz1CNZ9cItBcFGuN7iacAjj0NFvSgXdMecXmAkcuDX87Tz08iQ/
	 rZiHRFxD6cpgjmdQEx9sgrbVJPG/vQNbEf451fAOtB4b6PzJKpi9KoMQFKSGS/nLWP/mJ
	 U7O4tQWPlomuMzHSOjdOYdweBqxB/rHUl5XEg1IDzi9z7JJo0eRkk7UTu82lSJiktDQiW
	 MqTUgS2bhPtEu60Um45mme/TqxqRMqJMEUQSEi8lN/h0GznmeRns+0Rbfg5y1uANQF59N
	 P5s318N08Tz58dty2MoBhFl7HeULT2STsLt9XSIPRlicAWWL3vk1HjIrW1tMGqRZoqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d8lWT74G;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578FF606A31B
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 08:21:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 578FF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d8lWT74G
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e0d885929so304555f8f.3
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 00:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793780490; x=1794385290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2L8Phg4vAm8z6UFJHLXifD8svd0Kk4bbcZZ25kyGs7M=;
        b=d8lWT74G+yXWFlqGK8Bo4Tdcnvx0gGeCOXNOZ9hvAcn9Mnk6EPmrQ2cIwxDsCNRczn
         B8MmhbTG1GF8PnLdup/yJuHZA+v673ZG7cqmCYKELm34vpU7ONvPW/4n9hfSl8n8C9Fx
         24l1fernS6sYW8RQKkQiuEwgOWPgW4dwSkJsp2Xa61RvxLVVrO79WG0irFpzRmXVhAnP
         BYYO+Xmx8yrSRqVMr0LBFCISWGGUmUb7RTfWAXv8gyV9592UIQHQPjFiAVvz9grh37U2
         hokKw3BIWzPcJNNRWESawKpKIKF5nE6j2hzCQ6Kv4TG97G36A/ELCdjQw31mBQ6eRK2p
         zkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793780490; x=1794385290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2L8Phg4vAm8z6UFJHLXifD8svd0Kk4bbcZZ25kyGs7M=;
        b=z0+RZTduk7zI4Um/S7+gq9LI64XKgwnWXwIt+Tk86mKOOokwy6CROy58vfMsyLPKVb
         0PfWgpwGXJ1Pb10QUrhrIMPnjTqdzS3aQ14Al06rBxXQwBoszl20zir5osSilxYaW/Eu
         YnuW2g3DkdhRM/CxY5mwIaMJNiWcD8NYBW/qOgriwcJDO/Cq4WGAC4IN87fJCBmtxl3t
         wULVFk7HKw9htWCLkaEfyMn73zpzoeLU3d70LAequku9PklJgINLu2ULXZ/5Yz67Geed
         JVmmlHgo4tdLQZWWHEnC/zOco4zZg+WZHAfck66+6q37zhYQ/Xxskrglr+NFKWYWkEzd
         +BYA==
X-Forwarded-Encrypted: i=1; AKwUvBw2ZOh+WVgMlyf2FdbydV2Tnti92IU+vw2HurB559hLhWxIYdliZRvUQqvf3ihQLmWwrz+qONuSeul8vqSS@vger.kernel.org
X-Gm-Message-State: APuU4Z+pycr8MlTo9ZlUW6rCJrQEDDkRFjQ/L70x8Z7xUouyNEF7brdG
	JlT0Y87ZRYZ7ASkzvQz4ct5NRT/Ufu+OdM9swd3xBk+aCNMOPssnfZk1SJyyzsOD
X-Gm-Gg: AYBFou1OIX0ioTKi8I+3XZ1NSVQ/s33pFYbWYeptGPnezMw9AvHEPePDGRroH1euDBA
	xOHDE+Uiq2gj/VM8W8xMw1S6kXTY9iifTa6qr5X3ZQZmg9ldzLWXTjbXKQGSmIpDsj572IwClKl
	edt0VrEP8zslXGMZxjJ+MsiXBScFNTTK4c4zqhp8wGmOdhjNqjiHDDjtkUhTUtNuEArETvQTm9P
	H7NSgJZsg8ORsWsh40hxe3SlZ1Guz+W2/XQ/rQixrwAlgznKHdnqp9BBC2vnvsUbGHW4LUJwtys
	HKVvUxcgH4OPbbt6exv2h1XpCHRqf79/hu9aDE48qZijqBI52wgrX+QkHqp9ox0aeR2fL5B3HX0
	XS5FQgvOerMZgBcBnXv3PMOMoxqTI2VvN2wZxIvZTR7gC0gxKqWG2FSZwS2qzuBHVHy0Fp6Fam4
	/19SHE3itBOYUbBZKntaHJY/PDCDzPUXTIV4CFPxGvrU6avz3m7zVtC6oFifmvKvknFqdCtWfgJ
	sG2RarDX7MbuNpJaviMgyIxp6BLG2gkjnWl1FLy16nFjWOQ6V2iiR860NnrecPj0Erp2L8at4kV
	lIJfZpTwCZnFVM0QjMYLdkfII+HHwHrJhRNa+FOF3/rgCFVQRgWisux03nOYYojl67zI9/0zfQ3
	YtchTvDoElKw=
X-Received: by 2002:a05:600c:4f0f:b0:4b3:ad9d:e21 with SMTP id 5b1f17b1804b1-4b3ad9d0e48mr67987735e9.12.1793780489447;
        Wed, 04 Nov 2026 00:21:29 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b43cff3fcdsm35490905e9.11.2026.11.04.00.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 00:21:28 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] lsm: put the copy up creds when an LSM hook fails
Date: Wed,  4 Nov 2026 09:21:28 +0100
Message-ID: <20261104082128.3573690-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
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

security_inode_copy_up() leaks a struct cred when one LSM allocates new
creds for an overlayfs copy up and a later LSM then denies the copy up.
One such pair is SELinux and a BPF LSM program that denies
inode_copy_up. Enabling both LSMs and loading the program requires
root. After that, each denied copy up leaks one struct cred, no matter
which user triggers it.

The hook calls each enabled LSM in turn. SELinux or Smack allocates the
creds and returns them through a pointer argument of the hook. A later
LSM can still return an error, and the hook then returns that error with
the creds still allocated. Its kernel-doc does not say that the caller
owns them on error, and the only caller, overlayfs, does not put them.

Reproduced with SELinux and such a BPF LSM program: 36000 failed opens
and chmods by an unprivileged user on an overlayfs mount left 36000
struct cred objects allocated, which kmemleak reported.

Fix this by putting the creds in security_inode_copy_up() when the hook
fails, so the caller gets either creds that it owns or none.

Fixes: d8ad8b496184 ("security, overlayfs: provide copy up security hook for unioned files")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: put the creds in security_inode_copy_up() instead of in overlayfs]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Paul,

I think this LSM hook was introduced with confusing contact for chained
LSMs and this change makes the hook contract more sane in this case.

Thanks,
Amir.

 security/security.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/security.c b/security/security.c
index f6583d5073959..ad382afbff271 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2314,18 +2314,26 @@ void security_inode_getlsmprop(struct inode *inode, struct lsm_prop *prop)
 /**
  * security_inode_copy_up() - Create new creds for an overlayfs copy-up op
  * @src: union dentry of copy-up file
- * @new: newly created creds
+ * @new: newly created creds, must point to NULL on entry
  *
  * A file is about to be copied up from lower layer to upper layer of overlay
  * filesystem. Security module can prepare a set of new creds and modify as
  * need be and return new creds. Caller will switch to new creds temporarily to
  * create new file and release newly allocated creds.
  *
- * Return: Returns 0 on success or a negative error code on error.
+ * Return: Returns 0 on success or a negative error code on error, in which
+ *         case @new is left pointing to NULL.
  */
 int security_inode_copy_up(struct dentry *src, struct cred **new)
 {
-	return call_int_hook(inode_copy_up, src, new);
+	int rc = call_int_hook(inode_copy_up, src, new);
+
+	/* An earlier LSM may have prepared creds before a later one failed */
+	if (unlikely(rc < 0) && *new) {
+		put_cred(*new);
+		*new = NULL;
+	}
+	return rc;
 }
 EXPORT_SYMBOL(security_inode_copy_up);
 
-- 
2.55.0

