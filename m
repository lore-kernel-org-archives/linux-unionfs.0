Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987066;
	b=qm/XAsc6B+ggKbkeuIntckPgpXC0fHuzDmllF112ldSbxEgSqPmqTSczSW8gp2LRq64C
	 3jDblm1SS/paPfE1ykIVIbQCClIPjbCTvkYKXFaqYS1HWSOlWZm+QD8l4YtMip31MB/IX
	 1K/irR05iRw0SvNqX4pXjObCAUTz1y9pQw5urROfc5fw2KciBx0jgrttWnzmnYUFGCm/h
	 fKCacgNOKXXwEhLJee0I7ipWmT9f39dev97NFNzUeSWJIHsCf/b/od/dtl+PeHEQ+lKjY
	 6FRZA+FvIIQjqLHUM4Upq/rFUT24UTIocOOibi5TD2AtPmgCZERZ8pCBJzUxaqxmRWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987066;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hrFB2xZ4uuzix/ci88TgH2/bUivuDdMzcB4EtRfyy94=;
	b=b3rXv8kwOvhlGSxjJ8h6P6DzFbRf6Y/FeZCkFz980Qj0l8w0E+/DjJ7CFLDlGBG2teoD
	 JsINJ62Ebwj3RQHEkoHOb3CIyUPkrRnXFggbha+xA8j6CRefzcrwiZpD2/MddWOe4LHKs
	 kF14bQUh00NXRcDepeE8aAjsOsLYqhwXmGKZgkp0rK83aqi5uDMcZ9Bo8uqysqzuepRfR
	 2RjafwuB/m06+oIutHbY4Lm+0UBQ3bHFr28BBiEQx2wmMMsiuOXLpFvR/DrQZSu9mdViF
	 OUTp3gaY5iVRyaNqmGSZ5MsYSzZde6rcoRrbESCpUQ2eIZrxYy2WwiJLfF1H5davosA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0AznghE3;
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D22606A333
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 07:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84D22606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0AznghE3
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b8784a3284so1123112a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2026 23:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987065; x=1795591865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hrFB2xZ4uuzix/ci88TgH2/bUivuDdMzcB4EtRfyy94=;
        b=0AznghE31q2J2d4m4f9VN1APtK4HiYCff0Ds2DS5NHQQJQIPBnZxH6NAWJRR7XwVtx
         US+FARmcaJm3ilA726ncQmRvCFlA+uspoe+hp1uVGPdmNaQBNqKMByCPEx/RtU/S6JkV
         EpicP2aB0x+sz1c8T4VdOppZyUkiJAXVBYRUZjsuoU5rLA9OtV0+Eib8aOSB5YalnnMa
         Qjian0w3tOvwfsComdh3xECmx6sEQE9aqbDW+jbBIjMvZMCv2wFt9w07OMrKoMuLp4g6
         SbDN+D96pLFLF4Vj5Orc/WuDpu6DxDl/BZIK/dOFV1uCsRdUy4nUlj+ZW1hNhHA/Uiyc
         OMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987065; x=1795591865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hrFB2xZ4uuzix/ci88TgH2/bUivuDdMzcB4EtRfyy94=;
        b=ky6cPvjntWEnhC7IQzQQ76cxIE64da0p6BhoWg5kCkaHIT/4NP7uAU5bTu1TG8q0wd
         3DUH2JDwsn+tiQwWyt49Ty6zJ6SKQo1P9Gjg19WfISyz+gEP13+le4Mp7ho0WgHcXUuj
         t5pPXaT4ULUieNLqGfFYjrUonyFSc+GgHiWs/noI6HII6R2xTBRJNYH0e1FGoYdX3foZ
         hsvGq4MWdH90rDpyEV69qx3NcCfRUVV4vqzo76M85C5TQ8gnRCA2jQc8geqrE9l7dnh0
         xXRIZt+wuHFDmXOCbdk0/UE6atXxQeJTxHg7JdSjfRom+A+ZvUKKOuI/AvyAFIv1yBW2
         lmIQ==
X-Forwarded-Encrypted: i=1; AL+hErEZmMBYGQTkiGY7ZPUbBnfHBU0Z1KWy329M+pJG5oOP5QBMXI3LJJCSp94ZUoGriwH/xDEKCp9wGqylbIiI@vger.kernel.org
X-Gm-Message-State: APuU4Z8RPBJVNgsTT77PeYusUpn29C9ESEkFekj6RQPUDVh7jDTjyWmt
	vIuxYi8Cy3q5/sUZENAYoDUCeddokdcb/Lv0pL6+dS1CPaWpGn6pjhB3
X-Gm-Gg: AYBFou1Q3/IJpka4T0+K0SLBS+lAka8lpSIDYTQygYrDBl0JZDctwrTuBf52o2s2PCI
	utj4isWySXlP+y96ACr1Ty/fm8cCIxzWWAb4n9v/wI+3dzSdUbzyN8qNEh51Y40kRY7QbD8ar2H
	DOySeXZZvOZXkncFGftcXGtKQvWuXa1RwNvZlMETTenkila+/WlOAUMnKHpbNh/bGQY+6gQow2h
	/okEmzHwdLF802adlnm7KrehCc9kRlQPinhNDAsvuT/cupsfHC+H/OOOcyz/sb437WiuKSgBLWW
	Y00c8gxj6mesXvD3MzpGLBFLzTTRPr7lmhAmzN6c61znJlrvKkVuL50P7hwJy/CFdW+UzUwwbk6
	aqnNPSMH64bQytHHOx1mIkJiyoV6hOEA5dx5SXlAgzhcuceLqt9kYaWQr1Nyh948PeLZMRbp/Ww
	ZPC4PjhmcE4ORWBmJlHr7JEZCoQZIOgxu/bwFdHLywW6ErxucHVRlJH5/AskMoUfdZfS+QX6Stm
	po/izqOIktma1r/YEoNkFdrjfAhzvvNwny5bJjrScs350FtWLx4PSjRgNuAfvnhhWY38t7C+bp9
	a4lpK2O0Xk7sXxw3mo1Gx29aQPF0p0F0x2D3k0EvuMAicjpgT4D+M0gx/6a/lrTBvpitD6ZxmG8
	4VjR0o1LZERg=
X-Received: by 2002:a05:6402:42d4:b0:6b8:6f17:5a44 with SMTP id 4fb4d7f45d1cf-6b887f13cc0mr1134817a12.24.1794987064472;
        Tue, 17 Nov 2026 23:31:04 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b88a225b12sm683262a12.28.2026.11.17.23.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:31:04 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 1/6] ovl: do not change redirect_dir=follow to on in a non-upper mount
Date: Wed, 18 Nov 2026 08:30:57 +0100
Message-ID: <20261118073102.1216568-2-amir73il@gmail.com>
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

In a non-upper mount, redirect_dir=follow was changed to redirect_dir=on
to simplify the metacopy -> redirect_dir dependency check.

The two modes behave the same in a non-upper mount, because redirects
are only created in upper, but the resulting mode is visible to users
in mount options and to ovl_allow_offline_changes(), which treats
redirect_dir=on as one of the features that do not allow offline changes
to the lower layers.

Drop the conversion and let the metacopy dependency check accept
redirect_dir=follow in a non-upper mount, where metacopy only needs to
follow redirects.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/params.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index d1ca4a9094f28..0c7bfff7f06dc 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -936,14 +936,12 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->redirect_mode = follow_mode;
 
 	/*
-	 * This is to make the logic below simpler.  It doesn't make any other
-	 * difference, since redirect_dir=on is only used for upper.
+	 * metacopy -> redirect_dir dependency.
+	 * metacopy needs to create redirects in upper and to follow redirects
+	 * in a non-upper mount.
 	 */
-	if (!config->upperdir && config->redirect_mode == OVL_REDIRECT_FOLLOW)
-		config->redirect_mode = OVL_REDIRECT_ON;
-
-	/* metacopy -> redirect_dir dependency */
-	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
+	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON &&
+	    (config->upperdir || config->redirect_mode != OVL_REDIRECT_FOLLOW)) {
 		if (set.metacopy && set.redirect) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
 			       ovl_redirect_mode_name(redirect_opt));
@@ -959,7 +957,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			config->metacopy = false;
 		} else {
 			/* Automatically enable redirect otherwise. */
-			config->redirect_mode = OVL_REDIRECT_ON;
+			config->redirect_mode = config->upperdir ?
+						OVL_REDIRECT_ON :
+						OVL_REDIRECT_FOLLOW;
 		}
 	}
 
-- 
2.56.1

