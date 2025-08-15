Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5E4086A;
	Fri, 15 Aug 2025 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755270410; cv=none; b=M/ZSeZFoV1HFt40qE1vEygGnahMgsaHeAeyuN/sW/Sy9LwXoDEot6i9UnXrSUWiYg5K9TpjeCP9JsLXnreLjsVx8J/B+WcIKkTerOsEo3HugVbVXQATTq8kPJ5KYlMCl3LpzDJSzdM1IJj7NNPo6z0sVrDaUM7wFBgg27iSYLOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755270410; c=relaxed/simple;
	bh=T6KwqsaBGhkzK+M6ECYKLfiJhhW3kIteqs0A7DuoIPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E5k/24nWJJQ7aB37Ahuk2126EzmJDs4V7bT31Tv4uUUX/f5AKswqBM0i01pfNc/InDVbwr7Loj7bHXRezefTzA1+oxFlzgqREL/jKSlGb/JiHl/Oh5ZZ8Ny4vfqlo5PMrgLGBdMl/NLIRBWX6t7GRo8l5U2tTAV5EacZanmXDpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hUAg+EiC; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hUAg+EiC"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-435de5d35d2so1347149b6e.0;
        Fri, 15 Aug 2025 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755270408; x=1755875208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6SYyyOtudmJtM/TGrOPLm5qSPOyMATqxxGd+QdrSHmQ=;
        b=hUAg+EiCHNfeLLJbEJe6IjxGb33HxOCpiYWAvpjxZH+5VzPUCH+I0iLd/AE0TGVSR5
         5wqvwva5+HUhogH0vqA+d3844Lp4heqH/hPockOhmTkfU90G3j4R1n41yTQ3nX16lYWz
         5WAIxX8Q8ziGqHPJXOYxc0w8VOym0KIKXER1/rN6hasiXvabf4NZ/VsS+kaB75MIR0sN
         qyY9w+MavyNr+uJLIWyFQAkIldv1sW3p2ZaldE3Bw07LxB+uZ9mhff6sEBlwzh+fMy/a
         TGrcilbHZBdfC6fYA27cWKEC1izXvpYVk2zLL/Zgvgv68Vw8317AOsoyp759Uy+3FR/Y
         6yDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270408; x=1755875208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6SYyyOtudmJtM/TGrOPLm5qSPOyMATqxxGd+QdrSHmQ=;
        b=g2IiTX+w+RK7en+G1rVUJ+v9lTP6N1Q+Gfula/9EmN4CZj59aYca/XOS/sILzx1Zj4
         kC+KDgyJdxRu5so2yBqWCa9njcs1ygazUscoiMNYevddOpAbwGlhTXAkFojwVLzReHpO
         q8KenwoNIvFEZOPuzBJfcxfaCQ+RnAJX4lCSoT6Hft6CeCHDGQEvMPUYmK01kDvyU+2b
         4ChIvT6DHZjPP5UnvKr79XFh27XO8KdDzjxGYcmWuYfqmCfU1i5nBhI8llb4HVxFapEZ
         ZsIEE64cT9u4K0vPStrOctFMOEV6Tmep96MJqM2rCaS/D/FPwhRBQpbbqcyiTdodgZO/
         FKcg==
X-Forwarded-Encrypted: i=1; AJvYcCXBEFBwB6Q73lHN0vXPsXVWC3HiWdGMDaxtWa2KBokqS0lcHYGq272g53yoFiYNf4WXlC4m0dK7V/eQ5V8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/5sxWs19UigBpx8ywmibq7JeU45PvChkD4/3Nfgq/T40pu4tK
	cYVBtm2ouyZkyjr5pIGXVM173KksJHQcYq/F8gjZqyYjwmJisNuvWx4cZAFFVpZhQxQ=
X-Gm-Gg: ASbGncuMaR6ISz7g9cHxjj7WD9AhHZrYayPT9XPKU3KALVWqqFLOzve/lIGsJ8ayDcT
	oBTFqyqDF+aNDUMbhM4Csk76oEGzWv/pB908WPnh2GtlyoL6UuP5VvuHtHa5rqOnDozP7JNISUu
	m70er48nQplnCUH+v0HGSPdYpuOzSYmaJAReaR3ZbQi+BHI2puWnYRUOAEtSwtbpCSh5DB5huM3
	wXo2b4k/9QPutHU25lRhzwyY8HcsfJTsvPfiU0L0E+qatJYPAJkQlSVz+gCdD/jZ9doaHWmNufy
	AgZL4NkKz3CapM9HSHuHnv3qhA2RcSZO1cuAZw28vNmie68YEtGAHDmyU2wlto/cgQSzMv6e6+z
	ZcN8Y5NG5JylPjz33sMtG6islH8L7Ac6STd5K50kaNJd8ZCFRPH5RUCUP840qfNPPomHViv3ckR
	Yn/PizN7yNd9RNtITZ2t0=
X-Google-Smtp-Source: AGHT+IFmAu5VbO1038+E2YA+m5VnqkoVm51fBmwgr9JqhuNy9op1Z3zMOSlAE+ETj72RBMOusEhJHg==
X-Received: by 2002:a05:6808:6c91:b0:40c:fe59:8405 with SMTP id 5614622812f47-435ec45db43mr1373355b6e.31.1755270407878;
        Fri, 15 Aug 2025 08:06:47 -0700 (PDT)
Received: from skunkerk-thinkpadp1gen4i.rdu.csb (syn-071-069-161-161.res.spectrum.com. [71.69.161.161])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e87e0224c1sm122738985a.6.2025.08.15.08.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:06:47 -0700 (PDT)
From: Sohan Kunkerkar <sohank2602@gmail.com>
To: miklos@szeredi.hu,
	amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sohan Kunkerkar <sohank2602@gmail.com>
Subject: [PATCH] overlayfs: add FS_ALLOW_IDMAP flag to enable idmapped mounts
Date: Fri, 15 Aug 2025 11:06:29 -0400
Message-ID: <20250815150629.2097562-1-sohank2602@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OverlayFS already has comprehensive support for idmapped mounts through
its ovl_copyattr() function and proper mnt_idmap() handling throughout
the codebase. The infrastructure correctly maps UIDs/GIDs from idmapped
upper and lower layers.

However, the filesystem was missing the FS_ALLOW_IDMAP flag, which
caused mount_setattr() calls with MOUNT_ATTR_IDMAP to fail with -EINVAL.

This change enables idmapped mount support by adding the FS_ALLOW_IDMAP
flag to the overlayfs file_system_type, allowing containers and other
applications to use idmapped mounts with overlay filesystems.

Signed-off-by: Sohan Kunkerkar <sohank2602@gmail.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e19940d64..c628f9179 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1516,7 +1516,7 @@ struct file_system_type ovl_fs_type = {
 	.name			= "overlay",
 	.init_fs_context	= ovl_init_fs_context,
 	.parameters		= ovl_parameter_spec,
-	.fs_flags		= FS_USERNS_MOUNT,
+	.fs_flags		= FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
 	.kill_sb		= kill_anon_super,
 };
 MODULE_ALIAS_FS("overlay");
-- 
2.50.1

