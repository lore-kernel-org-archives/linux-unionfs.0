Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.6
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793202035;
	b=2SCT/inv92uEKoNU0jIZTR0NA24QKyE4983BMSk4nw/RWjBRNSAaUW/3EDGHSjo4JKgO
	 9Sac+qbSwAgFRk1HhX4OO9rgNiadTaU4G3WMDSnje2aE12su2biOphtnpu/5S3gumc2ua
	 2NdEbrfhn2XOH253EWVLjXcSjKsqHG2lEff4LPSGSZDrbEEOal88zbvarzPc2fMLN4WJf
	 Ho/JLvgwC/72Wnbvg5hXFTy5LgAqtc41uZ0OKTH9gJ/1/6JRDK0rkd6ilbgCvKdG0AZ0f
	 r1dRlLt/BDBBEZXqlHeE8PPY9wFZEX9snTv+wtJWDT9lwxVi86F7pF33to8wGVFoScQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793202035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=niA4UwOGFOA4mms81CnxsMGO9J3yqXrymq+0Zzb3sR8=;
	b=mGdcc3d9+LaCuLbSWWNlEI+C7rmV4L4gRkzUNaCnGI6vcivIbcrqsAbsEzS9b22XeVlO
	 44+bhFjgyqZ/xVAJyeWGAYPkVBM7ErACR4Bf6IY6+240TELu3BQD7JXrTpeo6A5h1IROI
	 07N8uHaO8XtLfvdi0jcm6RiqiiF3RVNdGLD12S/CF4EmeGRRPZJ2R3b8jrpt6hFyftKfi
	 Q0qOOtgk2OHfGICIQ0D76GaQ3FtWi/AgP0lLUqhktfU/RVqStyjLi57H+53dLy1gfm+Af
	 9fms7SSLkHcoeSqxlO8o9UFGtVobWBUHyEt6DNQPqMBvdtihlpCqytl3TTKNqbrwD4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w1+8Ak8Z;
	arc=none smtp.remote-ip=74.125.229.6
Received: from mail-dy2-f6.google.com (mail-dy2-f6.google.com [74.125.229.6])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD088606A31C
	for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 15:40:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD088606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w1+8Ak8Z
Received: by mail-dy2-f6.google.com with SMTP id 5a478bee46e88-35adc681e1aso1907096eec.0
        for <linux-unionfs@vger.kernel.org>; Wed, 28 Oct 2026 08:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793202034; x=1793806834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=niA4UwOGFOA4mms81CnxsMGO9J3yqXrymq+0Zzb3sR8=;
        b=w1+8Ak8Zi6w+lNdL4lEsx4wFs4qd7BtSAE9I8Q2jgtDkMIwbe++yhLjWCBKgx60WTL
         Dl1s5NMPXeUJodvIw07ZBpeNlPxdKOY279Zc0+iH+92DW5UNb/71e/UNGuasDWV1hXd2
         YBZ8WojFNZKqLAmmMlBvkglHjQUb9kXIjVOoZIK3PJLzaJUFmEtnN+U/9HlDWGHVVJ/l
         grQDWcSRW9pa5lmZfRAjrv3s9lwkq4tnBK6aF5evtMReYFBXzFjVI+SlFSX/EW4lq8y5
         XniL9jNnYlY9OSTdnL8ozKyMriMqRHb9+SNK7pZhrn1i+nMrT/4KoSaEoFIimm2YXiaN
         sp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793202034; x=1793806834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=niA4UwOGFOA4mms81CnxsMGO9J3yqXrymq+0Zzb3sR8=;
        b=NoMWfSobfkNVH7g/3zQKB1DixxoH+W4QKxzA4fEA6HcvnvOY5e+yuFY1QIj33E0TMR
         NF4NJPi4k9uEfc49+Az8+fhcE4YXkOwU5Sbh7pserPg795g4qYk2t+CZGvgWxByLRMDT
         1D3vsC4SQuDSMCle5NTaKnsphLzLXjhnyFa09BP8rhYB+9XyQfb0rSxbogEyvfxOAgCO
         915LgOoCbYYNv1MgylptnzGwueu7pMkuiD48RDivTTcxnZm8vkFoggRH1V1GPTmKBYzh
         bn88a88lN0GxPIGaNjJ6UvE7o4Jzc32EYGllwn6T7KRQ0akfczq0hq1D/qXEAw6lfFp5
         qTBQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRTNalodxRlhaO3gqJMHycP5/rLUhYF/2PK6bGK8MdgLCcZ1RmM+HUi5JkAxkXthAFDGiH5cwDdlEfRAKQ@vger.kernel.org
X-Gm-Message-State: AFq9FYLIoasgwoVuyvg2iVsDQxN6ZxQ51qDNZs9a4cwI+dzLSzK9IuXE
	ghFQs0KEVKdjmgdJh4HSFO7UibcM3SbJY87cjjIaWJtJDLDPfzb4RwK2
X-Gm-Gg: AYBFou0EQEKbB02XnP0sW2I/AZFWFPHKlgF0fWUhXkGyogoUl5OUdfhh9C07Y3hhfI9
	Mdn78uDr8HJ4b/7Hvrc5TtM0VCZ9JA2WcVX/Fpyo9yalK2a40Qvwlq1CWNOZgHyFsBYdGl2xg0M
	mRb89Lu9aJaBM3dIq77lrqrSsm779437b4rOeD3fWC8LHX6Blwcd+T+GOPkSCEVSReGM77BEB6U
	LMyUbhmCAECmUiYxDVGoRvNPfDNt3sZLjglrKs1uVqX138iX7JzGluP15yeCW00zW3Sv4ycyCm5
	oCIF90TtUhhgjpC48fr6UnYEers+L6nqCddjsKIc1VzvD822o0dblX4AeHr1KAXBIqyd7ILRCHz
	VuYqpZWR1O8CSG7yykozxznyIzuBH0qOoql0v7OcdyY4Xbar0RD8JepWMVqbuIie5hNM8JgmhvC
	OGM3XZRPrcKg9YJegRY2upxl7IkcbsyB1AwvkqBwBiZVriev2Bbk5jX5JeLq8UF4+nMOxSzAEtH
	nM8qskD/twRydM24oed781zbz8c334al4AM6yagNX3t1i12FLXZ8qbbsVdscGkXDkwTGoL0SORP
	WC2tLWryIOka86J2BvGoPs1SdQZoOza5yjLPu+3gSN1IkevYKKIcEI4mYMaUxZriWIXWyXNRusc
	0aQ==
X-Received: by 2002:a05:693c:8946:10b0:369:f7d2:d7a0 with SMTP id 5a478bee46e88-36a20407ad2mr4331113eec.25.1793202033635;
        Wed, 28 Oct 2026 08:40:33 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a2392ebcesm7873678eec.16.2026.10.28.08.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:40:33 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: miklos@szeredi.hu
Cc: amir73il@gmail.com,
	andrealmeid@igalia.com,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] ovl: restrict casefold consistency checks to directories
Date: Wed, 28 Oct 2026 15:40:08 +0000
Message-ID: <20261028154008.67451-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

ovl_lookup_single() compares every positive child's casefold flag with
that of the overlay. On casefolded ext4, regular files do not inherit
the casefold flag from their parent directory. Looking up an existing
regular file on a casefolded overlay therefore fails with EREMOTE.
Symlinks, FIFOs and whiteouts are rejected by the same check.

Restrict the child consistency check to directories, along with the
corresponding assertion in ovl_get_inode(). This allows nondirectory
objects to be looked up without rejecting them or warning about their
flags, while directories with inconsistent casefold settings are still
rejected.

Fixes: 16754d61dc69 ("ovl: Support mounting case-insensitive enabled layers")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/overlayfs/inode.c | 2 +-
 fs/overlayfs/namei.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 63906b3dafcb..4428c50c3185 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1278,7 +1278,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 	ovl_inode_init(inode, oip, ino, fsid);
-	WARN_ON_ONCE(!!IS_CASEFOLDED(inode) != ofs->casefold);
+	WARN_ON_ONCE(is_dir && !!IS_CASEFOLDED(inode) != ofs->casefold);
 
 	if (upperdentry && ovl_is_impuredir(sb, upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ca899fdfaafd..023966d89f74 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -266,7 +266,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto out_err;
 	}
 
-	if (ofs->casefold != ovl_dentry_casefolded(this)) {
+	if (d_is_dir(this) && ofs->casefold != ovl_dentry_casefolded(this)) {
 		warn = "child wrong casefold";
 		err = -EREMOTE;
 		goto out_warn;
-- 
2.43.0

