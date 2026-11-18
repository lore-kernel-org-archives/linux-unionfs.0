Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987069;
	b=ujWrAJzeczDtfxZe4hPVs/2YSPydoWWPLQdyUBTdoIwNnWH1DOyaUYs6I0pyKCm4GhK4
	 TaOtQLH1e7Tl5ACBZtGgbkzcdipb2MzaVlTk+eLFMXb1b7nKu6ZvWI/ClbRRxdVDNBodh
	 bDbvra/gtSt9OJ7epXc5VY+1lfifQELhnGpn3ph+8hHKl4X7/dORwHClHbdlHVEEdgZ0w
	 M5uq6g20SmnyxWXjWuBiBcvTHpnFXQq/lMv7d0ocZTpXLaVlDdW1+BMNYf6pW+fPQZMqU
	 1qsNw7e2EcPkZj6vjcV7gIKrI+CrqRBeCjQvlRBhq51PmxpACC2CEEfMWOLMC+WdbjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987069;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XtmHI7XcbDeAaNo5IizU4KTkmxZv1I16DRko/T8lGmE=;
	b=Mm1M2EoOWC0M9j1eoHg674X+zwr1K9BdCWy89h+WeFYAxXH7JqwyEqmM9HPbWlx5jpgv
	 bWT9QwR7om/lAyoj+sGKnsoYHW8j5Z/NSrBZEKmyk90pNvz9V7IZwGmGOY+VJWzX629hY
	 iej7IWyfy1dJ6awZ1dKUUjYguVs/60Oi/IwSri33/I9pJguWxVB4IRR4weIQSICMSa+J7
	 XDYe3jaadCr/KDbU/szDOPHMLp8wee2TFLTn4Bu/N/AHpOzq+6LUjkzR+ZZQhMMW/tjIC
	 O7XJh+6tkXiP0fzJ1Sthg3dRw0PZWlEj6Z/8reXS4fLacsQvXSO3Y7f4h2z4jqVmWtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q5RSy3wE;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B146A606A333
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 07:31:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B146A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q5RSy3wE
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c50cc8e0f84so83375966b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2026 23:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987067; x=1795591867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XtmHI7XcbDeAaNo5IizU4KTkmxZv1I16DRko/T8lGmE=;
        b=Q5RSy3wEr9UpCOLyrTn4GEXVppUv02yUqLn7GM7ryQi83Q2g626PRJjkGNBsEypVg0
         rgZV9/ZComsFO1f3HSAzKiNLImt/h3BGwbn4ATI6Lc8QZVhMQXR4h+yFaswdF0Uxyjzz
         B26XGCOh5i2KcfyLFTk9yBImwy9K2IfJRd/VZf931ff20+wkW1pEsk4xd56sNLlqvOFY
         4LlQYYka0QAcbYEioSthCk7+Ld0iEgHNy00Wk0PUB9cH+b2AC0420Iv4Qc4VHLwegKN4
         n9yB0LJGnMg3/NwYjy4lzcBC6vPstcvzjhtzgv2vvYvKTkqz+JLSffLawEIF1YnWcNGR
         buMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987067; x=1795591867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XtmHI7XcbDeAaNo5IizU4KTkmxZv1I16DRko/T8lGmE=;
        b=E5S4b/DX8m5eJ9R0qOoAQ+UZUyXxCqBCoDuowPCqpWKBnpQJywju32vWuNtos1URwt
         7w5r5PR5XgpWg6VdpS47rw6iWx8l5+wpbPuvpm4uoXORXSK98mI1CXwivb1AK69+PsA1
         zHBDyV91YMLeLMQRv/evPrRub5gk7txa+hCGHoxorj+HLm2O5FBXhg3C2tM6WBDP7frF
         +t9VJ2eZk9m8XXb+4zFdZ2rswG6Y6+XO0Etxv3KJoMAHCThbAZOk6Oj7ZobwTVpZc24U
         vtoK/yYCz4Z8c9QEI1qqFXk8455ETBp53+lY9WgXyMSFPvsmoNgoKO964c4Lz+zHjUD7
         R9RA==
X-Forwarded-Encrypted: i=1; AL+hErG+6M7ETgLVbLSMEv+nTHyQi2yGy8hre9WjFV+rv2ZUBOoUrnbJONoElbw4OS5SILzA2fLyK0Uixna7y/Yc@vger.kernel.org
X-Gm-Message-State: APuU4Z8HDy/fLHb9tbj/az0itjIqz4LpSYoLSchrsX2QCjfTsi85R+/o
	Egeaj1IB7jNsftIUs8QmT2FWTYixbyiuznjYlTnUMdDimQFJiFZ7avH+
X-Gm-Gg: AYBFou0tnc2TdGvzU/n+5MTZabebjo/RErLVIO5EeKqbREG4wA/p55tjAy25xJRclnN
	7CIoa8uXe5G5t4k4R9Kov+snOK69xIp0n7gZQowFDBevgf01v7aF3P3Fz3KsFMzAAWlub9xf3M2
	MeREsArN6+/Z+RRwKKYOLn4vi8qASORop36lz6+2Rz1RFTulsPRAM2aD38P3Cx/VpzUv0eHavrD
	9RfvpB/HjA6iTXX+oiEQX4/V/PX7SZLBkMpKbZRAmQt4ayGkqsFb3REa1s3stbsSpAvpz1pmtyN
	Ta482DuPU6gE8lBGdwqyLydvSc+WeQq03+nLjwKKAFF/5gqm0WzPP9wEr5fQ5P+m8dAFf3VVFPs
	qMfxDrBqAamav7tbN14c2yJpSf6FHWUVAcMhoUk3k1Kzv3/8Cztai1HWYmQNzTLvoAmCCZQntr9
	Tc6zHc/kefwASTtu660rOVd/S0FF3PewpWNFk+Gv7Vpd6jdeR7tr9qxdGDNIixZhw34/cDsunhk
	artgeEbo7+m0IYlWso2SfDAM2gMWjcwrpzQ3hdl6PA+cBR4yv2nM+7UaK0/mPUQMBoI6y7UJKfS
	LgMmtNehbnpUalpX2BJsaKGgok2c2Qm2yk3XAtq/2uLnMNbbe+HAtowZ6AzskVDGYz5cv0Jp+sm
	ur8XUw8bX7Go=
X-Received: by 2002:a17:907:802:b0:c49:cfcd:69e5 with SMTP id a640c23a62f3a-c510e2f11afmr132556866b.32.1794987067013;
        Tue, 17 Nov 2026 23:31:07 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c510c83f31csm65407966b.10.2026.11.17.23.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:31:06 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 4/6] ovl: refuse pseudo lower layers unless offline lower changes are allowed
Date: Wed, 18 Nov 2026 08:31:00 +0100
Message-ID: <20261118073102.1216568-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118073102.1216568-1-amir73il@gmail.com>
References: <20261118073102.1216568-1-amir73il@gmail.com>
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

The content of pseudo filesystems is unstable by nature, so pseudo
filesystems cannot be expected to behave as stable lower layers.

Overlayfs features such as metacopy, index, redirect_dir=on, xino=on and
data-only layers do not allow offline changes to the lower layers.

Allow pseudo filesystems as lower layers only in legacy setups, where
offline changes to the lower layers are allowed, to avoid regressions
in existing setups, and refuse them along with any of the new features.

This generalizes the refusal of pseudo lower layers as data-only layers.

Link: https://lore.kernel.org/all/CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 3 +++
 fs/overlayfs/super.c                    | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 688ab108f7478..235dc06c83a3c 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -684,6 +684,9 @@ features have not been used.  If the lower tree is modified and any of these
 features has been used, the behavior of the overlay is undefined,
 though it will not result in a crash or deadlock.
 
+When offline changes to the lower tree are not allowed, the lower tree
+is also not allowed to be a pseudo kernel filesystem (e.g. sysfs).
+
 When the overlay NFS export feature is enabled, overlay filesystems
 behavior on offline changes of the underlying lower layer is different
 than the behavior when NFS export is disabled.
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 58e4cc22d4de2..cd4ad88ecaa06 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1261,10 +1261,10 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];
 
-		/* Pseudo filesystems don't hold data for metacopy files. */
-		if (i >= ctx->nr - ctx->nr_data &&
+		/* Pseudo filesystems don't mix with new overlayfs features */
+		if (!ovl_allow_offline_changes(ofs) &&
 		    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
-			pr_err("filesystem on %s not supported as data-only layer\n",
+			pr_err("pseudo filesystem on %s not supported with metacopy, index, redirect_dir=on, xino=on or data-only layers\n",
 			       l->name);
 			return ERR_PTR(-EINVAL);
 		}
-- 
2.56.1

