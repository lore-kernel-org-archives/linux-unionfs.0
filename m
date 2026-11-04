Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818299;
	b=lidwk9VLjGhpS27uAdSXHfzjWF1/d9wdAyt1GaFX8sQONuv2RT2nFxIasfM7q0ileN+W
	 0dgydjxsveUDU14DsaVTes3o9YBb3sYIQgg8KIB/ysMbIKoTTOXjqTB3asW9xRg624zx5
	 rJxOtR0lVb0rMvQnlm+JzUjeF7ZkpgUknKVPlXs4AWhzf7j9GI29Bkv6TWDPCYe0AI7JX
	 9/Rj5ygAjEf0seUzDI66TRTp9Hu0fra5mFv52BNpPkXyp9cqvrTRDKrllIqbkhwNnynwX
	 NjHBGIHE9kK0th3Cg/O3zD4bGSYdcqpa8p6W0dZ/7UXtD0qme/QYdlt8EAFqxB+72KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818299;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OZrD6W/cpe/3NMm1KlSdEpezLvbv7UoEEElV31ZkAFk=;
	b=hxvfWR5yOi15LileQpAD+LAKNR48TUSF/PDKGTEPZ2bHqSsRuYaWuyZ9QJLAYGtvE/1W
	 a4CS/1MwEaX/GyFOOHUWfxHjl2uWgUfKI64mE1g3UxB6Us0s/4OaKlpYAMvPZNNwDIdpp
	 2KSAVrybSlrkYiFROPmRjH3/dCnWdoxUqpw4DciczneiLqX+pF4VFrUiqiE0EKYvs2GBD
	 HUB3+QaxU/GgPQW7uYJICnhyorTSEUcGc1ImEJbTjDoK61mPHw4B4yNLgrhqBqlQ5KlvJ
	 n4RGH6fvCPWF8vNujC5mK5QVbYPwt4nFG+L1Dl5/YaUpw4FVHLkTNWzTV7X84UpNZBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=an13JAXF;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B6A606D801
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41B6A606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=an13JAXF
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49d05d51553so6825035e9.2
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818298; x=1794423098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OZrD6W/cpe/3NMm1KlSdEpezLvbv7UoEEElV31ZkAFk=;
        b=an13JAXFqWXgby22kGqHnVxHA2OiZZ52LePA5VrOH3duaVkGwtdNJlyHsDg2pZNlNt
         EP07ECnDWiPhaQD1a/r48VfztR3g6fKqnNJ0wCiRHs/ZFGeKl67CTWWAUAMvsVIf+GX+
         SKQDg+2l6EhvqVA2R5fZMgiV7REwndXOL9tmMJzMAZS3ipjjOgpd4fdK77C1ZJP1f4MN
         Ir86LE4N19gML1UX2IrS5dUlmu87j7yt6Lo99s3ZeM/RCufI+xS2y7wUiFL+glBpHbmY
         +qY/Qd/H1jaM4vDUUH1jAL4R51xi2Mulu8w93bHh7MKmQ4yjI1e6eNY4XsLLJWtihFbV
         8vVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818298; x=1794423098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OZrD6W/cpe/3NMm1KlSdEpezLvbv7UoEEElV31ZkAFk=;
        b=ljnj83vfPNajaufiLigZ3gPtyoILXvzF8Jvy8AcaDxZJUWkiBLrtgbhA61z3WOsFcT
         0SOre1kUD0pPzHAlpQ5/u/YDuAhzMqVE+9uV6Z9A2pWFgCAWUbB6JZuZNa1K79SvIT8H
         I7u8e1bucKUmdm68AHr04bAvbdlor4WfFvj3/+lKOCWcs/0KJ6t9tQ5X9G0v9O44Yt3F
         9fAEsLsm3nszKPrEJGzNtx6ih3NNpWldHeHKfshWBgh1jzIbIejXdTDIYMTWQo95nZos
         tapIRcFWdkAgGTey549yIQt5+3AkhdTYIng4BNv1E6+rTWsf5kDuHG2q4/XclBzVZduR
         +uuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxsz+gXBnATdkBkUPL1s2EM3Aag8f1Ippv+V2ujdREDEIcIM15zor8L65zb940PRvNMGXSE6ecgkizTYzCg@vger.kernel.org
X-Gm-Message-State: APuU4Z+MGZtk2+Hbq6TCrxld1hDNEvv07kH6kP61j46f+YX03X55e5hs
	FxN4XGGfKEuSwajrAPIrkMH1gZmVVigpSw9jdjVP75YifKKYFpEYXuM1
X-Gm-Gg: AYBFou1q13rzVGPZGgHfLf0vbl+KwZiunHzrcjv9qFvZITJ2+w2DbhKmwcYNZ5zAc29
	KPSDqJd7uj/cAA/+82qf87eunRrtM/LNFAmTfxNH4pY3h3ee9p/GB/+/xEE6Q0NclH91E5TZdEn
	v3u3wrxLrMffq30RpbjkMETnJskscNwza2XYhpsnkEGdfo9FDY4NcrBLS5dL7qxGKyRNQb52QF1
	uc8s71fSrd69XMfGBtkDmxuZ5MqRONJNmomzPUD97AB09P3RnC6oWftdBVJ3NH5QkZPm1GCmzMp
	g0/VmoEvISLowcTyWTe7W8s0yu7WKfaNt7d5rxgapZ4TBYsL13OKBUJhXd5+jJ3Ylys0pI3LC8V
	Yo90GuNogI3KPyZF7mLx8ifHTs28UFLEDadYBlS5JxLCplI7VBw5I3n69hD3VaPpseaWpiFJW7d
	082JN3FDODmXM2nKfWvnx4ycNKLtlZLy1dQ95cCif65kue6qzNbhVOB3Wi1zZs0r4xYw5cg469g
	gwANa2ZBX1S6EB/t/rLO1/U57AwfblAO2kn4Cpt1OILHXzPVLHDXKHFJ/KeHLQGP0LnNxB2eG9F
	VIVenx3DvLdagHM/75SA+3r+M34bNPRA23heoQ5c7hiNPKd9MnaIW9zNV4eE5leLwO6cynN9glk
	7a/ISVMqm+jc=
X-Received: by 2002:a05:600c:8b04:b0:4a1:fb01:13 with SMTP id 5b1f17b1804b1-4ac17a3683bmr388077125e9.18.1793818297737;
        Wed, 04 Nov 2026 10:51:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4104d600fsm71954645e9.0.2026.11.04.10.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:51:37 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.6] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed,  4 Nov 2026 19:51:33 +0100
Message-ID: <20261104185133.3630642-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261104185133.3630642-1-amir73il@gmail.com>
References: <20261104185133.3630642-1-amir73il@gmail.com>
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

commit cbec8610ec5aaf35df50094ff639febc23f20773 upstream.

Listing a directory while it is copied up causes a use-after-free of
the readdir cache.

A merge directory must never be iterated as a real upper directory:
that mode frees the cache in OVL_I(inode)->cache without looking at
its refcount, while files opened in merged mode still use it.
ovl_copy_up_workdir() publishes the upper dentry before it sets
OVL_WHITEOUTS, and ovl_dir_open() samples both without a lock, so an
open between the two stores finds the upper directory and takes it
for a real one.

With a delay between the two stores, an unprivileged process that
listed a directory during its copy-up saw only "." and "..", and its
next getdents freed the readdir cache of another descriptor.

Fix this by setting OVL_WHITEOUTS before ovl_inode_update(), so that
ovl_dir_reset() agrees with ovl_dir_open(), and by testing
OVL_TYPE_MERGE() of the path type in ovl_dir_open(), so that an open
that observes the upper dentry never iterates a merge dir as a real
dir, regardless of the order in which it observes the flag.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: test OVL_TYPE_MERGE() instead of smp_rmb() in ovl_dir_open()]
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
[ backport: context: the store is followed by the unlock: label ]

 fs/overlayfs/copy_up.c | 2 +-
 fs/overlayfs/readdir.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -774,8 +774,8 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 
 	if (!c->metacopy)
 		ovl_set_upperdata(inode);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -947,7 +947,8 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(inode);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
backport
