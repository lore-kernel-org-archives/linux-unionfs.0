Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818298;
	b=JaLhLsDFb/Xf7e+g+MxL98rjWvHBQZsYDtto+/1p20dxmEcx1n4tDrHXoOABr1JqZmKx
	 egRGIODPTJOSA5Tkme5/kCkVrlTtPdkLHECV6t9fhuIbyEQPa+c/nc4Yk5dhXwN5RWlGI
	 d0PiyDFc4UPVty0yBjxBkhMKyiiR+1RKz7JdJUdo/BWMjEbs9AjW3W34XBz1au28cNLJa
	 DWGEqxxnI3FYlh5sx4jE+hgyO+O9po+u8CbEN/w91O64bRv2AIIeXHzWEDjN4ranLXNzY
	 J0dX/sB72UuupnuTXUluTaIS5IIXzPjXbl2X3PCqZtK96GxZKMwr1HWXeWYoh2hu1XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818298;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ixIf/O1rej4xwPAfsSS4PrVvK2W+4h7d7LIQubDg2yQ=;
	b=jrZwu9WOFPCMrrRdfG5/F1JJuNMHl49/fRyhUGkIGdZOOM8JqMXGYQbMz21+YkOEGw5U
	 JXUnp+7aBb/X9NsthcwIKxoBCoFshO+HRXH4lgIC02mXQQf0c58pWHyidSDEjUHdLzyop
	 y3KH1JpS4PoLhHkyt+I1u2VXRuehQ/8KBGVVf5K8Xt0Dca54Wnj9VeCtTlki8AwYCTcd0
	 iTfVVJGrzpWNyJYx0RXd1sSoAtOnnh8ICUVkhVt3759VNFRtgLH+MUSNI9hNxQsK5R8tD
	 U9dkNM/cDLftxJ+eUwaUvacaGMCjt5AaSOHUp+C32ihnfQDUahDm2Zijic61sR9LKKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tb+Z0H5f;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE2C606A330
	for <linux-unionfs@vger.kernel.org>; Wed,  4 Nov 2026 18:51:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FE2C606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tb+Z0H5f
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso859570f8f.0
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Nov 2026 10:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818296; x=1794423096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ixIf/O1rej4xwPAfsSS4PrVvK2W+4h7d7LIQubDg2yQ=;
        b=Tb+Z0H5f8Ujn95lpcrYX6Sd9IlolZJlKwRalnmZAREtJXke2ariHsWPEgRaS+cZuo3
         sW89k6nQgSNEh6VqH7HS1Gdr0P6V/MdS1A9/iIEjXB5yts4D7/MM8bdjyCjOdHV28k5i
         zIw4+2t3iD8gS88Z1sE4zKtiBnXaBdbNVbAS7zy2F5qq+pSEb9RlJdmk/8h2ZNYfcV4d
         JBdqN8ketxfyxbKUxxAFEt5Mmvkxbdi2z32JQv3POYjR2kjJJbw8qtlPO/LfoD8kc0OK
         FNjq3P1vPa7u+qdJQIAlRBtmX9997KWTXNCUNEFuB2m2UURwzWnQtHjYKfvdFINoRBjt
         lbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818296; x=1794423096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ixIf/O1rej4xwPAfsSS4PrVvK2W+4h7d7LIQubDg2yQ=;
        b=WSxGAk6MQtxu/bbZ2QgHlsaGrOgLk+qy7KAfN5MHj2ZdwjjQ5PCMSouTxIp22ptNnx
         Li0AWaD0Lq1qkJR++BsYMNYHg4tEjFomCnfJoS0NkMca5p3rUthccfAtu2Y7erdJnhrm
         V99cxDtFsLAOsl39h78Q3YTmNI/jWlExTAkg4P0QSy/eP7cQ0qFX4FvW4N9LLf+A2m/1
         nUDYDQE8Xa/XzPsV7PnyUs1AtMSTb9xN/2LoHXujyCCMiEWvb081Dc60wFx7RVNbiIWb
         2OxsjXN1g+9l5gbggZXvp2YcaCcr1EPbQckPJ93mAIhSFyC+/VSSF9HmdyFf5xDqe1HQ
         522w==
X-Forwarded-Encrypted: i=1; AKwUvBy035Bl28jgOfubIftkFXvGR3Aqobw8LuxzH5jqdu+XphzQEiFlTGAvC4LTGBPwNBMB8GyEKN3sfWpOpS3Q@vger.kernel.org
X-Gm-Message-State: APuU4Z9fUaLCbSJqS2GWsTrGGiSk9RK1eIM14GOcMD/uScTAktCT+epz
	GX1Cm/Tt/UT7iPFLgvtAziUQ8fs4Xz5tXo2g+47pj2i5fK4ouPP0KmFC
X-Gm-Gg: AYBFou0ne5ZvQyjf4FPWA80Q2cE4WdYXwUzNmGXfH3gKZIfXCgN5wzKEtOhpXmM/kDh
	PaYyeynfLKVLgdO92lHbGmkBo75zN8/2TEinmx8PTFTz/G27SDSGJYxTfd45e55S1hSCdrvZEfM
	mT/FR6v4UFH7yRd0bPC+KQ8B0DVJ005ajRZxNMnDwJUg6GGtF5LKsBM7N04qaL096t9CTON3kMX
	CSlXbfD5HyV8QWnkMxXdehjTwN0SqOi46NUSdhCB0JZKze3ZwcEVbiB4Obu0Qpr1DLbQqwzAMK5
	J+Vi/uJmZWHp92NmRLbERbG/Jr3u/CStCGs+9h33kUMhyNXpm91QizYwdPFsedPtvBFeSor5wqC
	E29Ohh63iIZns42qH762cAgXpoJ9bqjbwMMQtBwzmhbKYxrruEUMmQqLgEX2j5n7/bYy5QeyZFE
	UclH2Rfy7xlLTeP9KmOJJCD21P8z2LVTM4AbydSHAZlsTs4sGZYcxLCcxIKg39TLOa3Rl86NLAP
	hhuaQ4nqZorOfgmlE4YsHr0vJUnkrdDSUGEjLxdDCmbmQN5XwMiiE+i0O941+4iluXtLH43wq9N
	H03e3BmsP6Pc3IO+gbVbXDHWSdrNJd9Y3Erzr2Evhl57w5INxuRcuRbWHRg/dmMgNzFd9mFLdjA
	hjdKQ2u4UUrI=
X-Received: by 2002:a5d:6e88:0:b0:48d:ba3b:af36 with SMTP id ffacd0b85a97d-48e6e5016c5mr29006819f8f.37.1793818296326;
        Wed, 04 Nov 2026 10:51:36 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed551dc5sm5516390f8f.34.2026.11.04.10.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:51:35 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed,  4 Nov 2026 19:51:32 +0100
Message-ID: <20261104185133.3630642-2-amir73il@gmail.com>
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
@@ -843,8 +843,8 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 
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
@@ -961,7 +961,8 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
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
