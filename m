Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135393;
	b=ixfTt4ddm+vSeWrn0vkOuTCo5/5s4sBV61zsOjU2f0nqVsQ0WuLfled+a5QW6S5TgZgN
	 COSFUV8s+F1H3isacxt54c31VHXSa5dCu3wZobxakgr6IQmPyC45PzZst8VAUHxdOfnIr
	 cbxDqyeyQzCyKv42EUyzb2G1yS1WwQlwZtMDY5l7Or+nIfGQgHBXCN5n08eSx2EOQ50te
	 tsQvrcDbuZyzbkLA3icoIyxCuNeOFIcNIjIrWtHdpkP/UwdjdWRpNcHjBFXpERA4ytPuK
	 6CcUoq6XBP+omMuui1wSLpe7DyZD+pHngEA41Md+UOESwn/u68aew2ZVxmQcH72QxxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135393;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
	b=BJ2nnLj4Qjq6M7D2yU9fk3vCqcLjJrPlQX8/ccXwt6WC/fBufuHpMsdl++zCrklbwiX0
	 uzXDj4d0MofaWrNpwgfDq3x9u+vsJfyiZ3gAFQW2Pqv2Yjj0KQBHjXMo+BtvBRy/9QUVP
	 DG8nmDrtbMqHq6eV0neB+4Ce9njNgDhIlxie3B3Orp8lpRGivMkUMZ7AF0Vchrqehv1p9
	 xjtBMsCKmE1wG2C6fuHbDZ86cIlFNuzPZJFGnl53qhpRBHUPhLgTWf8oeSaH61GTkSXo+
	 3Ctnk6ObeewdmRzwk+SCAehjNBRbZAcHkWQOj6za+0Jd3Wi/BFoHn2j/Sie1oU+Mzfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D70606A33C
	for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 21:09:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9D70606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=hOU79HFU
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5365b48238dso3570461cf.0
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Oct 2026 14:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135392; x=1793740192; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=hOU79HFUF5XVQIP1i0LutIU/umJRpfeIAGlIU85PQ+VvN8AhJ2xV/+Ckj7hUn0FiXT
         Vo7Bqt5A2O7gVi2FXZ7LR1GJBkC3682be/KrfbJUx3Oze79iZ02cF+nWdL8HAMH+TkA/
         RqJRdc529Hs/8A6MizbL1tlCPDHiaNo4rAfVeS4PCd+pYvNB8GiE3hhXUKHhQVK+xtN8
         JXcziCJ3xyZB8L1d8uSyg8o8tM/93MhtFnhO+nATDdlG/gpAAJwbl8XdWTjLI3geZAFt
         Fqe9NEA86+d0c+71frtm+HrDiotx5CzEsaAF6tQp+yTnBApEwLxl6fqpDPD3/OU7RekT
         j33Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135392; x=1793740192;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HAhPDfSNI1m9jMsgOVCEGKYJnC7ZRumB7Co5M2j8QiA=;
        b=wBWFbpSyPIBWV2+2TTzL2S9QecXnbZxut/bf5PyVRkxjCamc9fEDpgXXQWONKn/ooR
         u2X71dme3um0EtWya4D+odsBKMshQql7OauDxETXN93NNsSl/1fLzVfImkr5qNxbMaqe
         Ag90C/gav6Pf6mKh/hhWUiFZMCTI8qOlRpSEquEiOgXZ7/77QUijNwvNPGpvSMcW7q25
         on20yJbRRVvyR/p2Tv1ZZiVLXL51/u9MRNfNkP48BekXfZu88eLzlQ1lFSUQ0yrBBok2
         r+mmR1Ea69qNyvw3kF8zSIMJgpF+2VsskkDGQ2YTfSoOl+zy8eQRtPjSB0/O5jeF+jM9
         s6JA==
X-Forwarded-Encrypted: i=1; AKwUvBy1yrl+5HSsrTObJeFEZ3y4RgdRBHqUXo2gzRZwXRBiYCVskV8WaMQyVhlZr1SzvkB3Q4DLGWilai4zC5s6@vger.kernel.org
X-Gm-Message-State: AFq9FYISQ/zB6hTAjlzfasma/biM3Ildh7BH35mxP26mhvxJ2scqito8
	xvG4CA1srBzDyLIysL90UTxsHVD7drV44O8V74xew64LfqBVi/Q7ea0qcrEwL1SAcfQesVhGX1e
	8+R/F
X-Gm-Gg: AYBFou0r9oClHJuyhewDNqSqMh4sV5SOTwCtcGwlBu/l2NJSI5Kh/YRsce0kJkgXAcP
	Ip9L5sEf9mQD2d95H/gRxwqsBXVcNt6gk0QF7GFVjMPSptmzHXGJrsYMsohyHmNqkW4pmYxr1HT
	rSgcQhYmjUKxEsATu3Mw+t2YsROyRcMtp/hixkBCP6HJbYmuXo7plPxX9O7jp0/vJlaBWI8ZZYG
	VCBSmrKrYCA+u/yTDYH5gZxkcMP/wakWVbaGwoNV1B6IrKwRy23xEKMa3Ju83ehiiHBRIHunvT+
	BdJeGUen3XL1rzy6A9uz88/H5O3YJfhHtphJPICO7FAirHy4Yg9LJUtkpydUjglyJOuZDiNaADj
	s/XozsSFCNaWmo6EMgCw7/fDQHk768xL2qaz9SdpJeSInUu9pOBXQTPeZgeGyb7MPWxC5k3LS74
	UjHIH7zgZJmwu3nHzsfOPJEiJgzoBwCZn2zr1IAMLgA/ASXhGV26U6fWFeYXkS05zGr0cSxNRba
	Pw2FiGIFcj7L/upnQ7LyaSQWWJfKOXk8TZZ7EM9KYpvkziDYUrcbfVzkmjz2PJyJrM2ZWOctAp2
	fMKwhjopdiBtom5C3A==
X-Received: by 2002:a05:622a:8887:b0:535:92a6:22f2 with SMTP id d75a77b69052e-53fcb20dfd5mr9618051cf.15.1793135391683;
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c565esm88811961cf.6.2026.10.27.14.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:51 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:30 +0000
Subject: [PATCH 04/10] btrfs: set SB_I_OVL_USE_SYNC_FS
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
Message-Id: <20261027-b4-ovl-containerized-sync-v1-4-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=741;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=KS+Jdp4IcUSZ6tCav8kl7acTQpMUNvtXOKDv7b4wQHs=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QJlIHMWE4mD9Fg4D+/nCw/fqbncWcTX25kEPMy8XebnWW9mJFVsO6uNMHNrIavR2Gh6YLS/9QxQ
 cP8BX8zQgBQ0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

Metadata is changed in a transaction, and btrfs_sync_fs() waits for the
ordered extents and commits it.  There is no ->write_inode().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7fabb775d4e3..cdecf90bdae0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -981,7 +981,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
-	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM | SB_I_OVL_USE_SYNC_FS;
 
 	ret = super_setup_bdi(sb);
 	if (ret) {

-- 
2.55.0

