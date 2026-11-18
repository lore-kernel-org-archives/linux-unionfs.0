Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987067;
	b=JllamMR2nKa46BO7J8BgWdjUhiy4fzi51BtGyrnymnDhA544PUlPZHlw7YodYzlkdsw5
	 op0wdr6IS+i1UsWxMJO9Tl2FHHnt0kaK16P+cOCwMLDuRauyv2Zj7N3IT8hlwBsnPINv2
	 UrGu+KbPQqEIkzQC+lqn8i2i7JUcJWJ6x3bhR83knQ/z+Wift6pna4u4IpWzPHucGAU6G
	 JTzel3eSv9tmnuXXy169u1ngWZd0vpk3Du8K6kXLVHZbDAxQUTt7dq4it5gSJuj4Ci31J
	 0DMi88H1pIpkxIrBaMkuuL3bfKOcnUH6FfnQ61dOie0YmPATZAIVAKXJ/Vx1oeQ7LOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987067;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R/VgZr4JT1tJlWk2SqtfdJVJtnjSBjwEeU2kVt1/gB8=;
	b=JFCJCV3eZECFTMwblZ8aldxbFMhlCkFXVCnI8jhbdjCeeKtEJ1TWVf7jQhFhTEH7diJy
	 YRVibe4o9IZ8CVB/wCj8+c/1icszr+tcdmPL0vzikb0387DNsYHl54k8uw+DT/YnjYmu7
	 LTDtqeeZxlyV/glXTAqQMI6eXg72+Z8vKUnmyfvOtFrHhQre+rRKU7PZqsxOPiLktNWzk
	 CJ2I5pQNFos1Z2MgoS1ADRjH19lnlUANPdDY2t/IBByMbTpViGYPjowJeA/LxqmktC7le
	 atgqYlbWTLkkozr91E5AslbYT7MLI0CXEI6uesSVnSYAOFsYIfsKCsR3qRgUVsBsD3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dcAwtWrQ;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121F2606A337
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2026 07:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 121F2606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dcAwtWrQ
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4cdc606b47so95492666b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Nov 2026 23:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987065; x=1795591865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/VgZr4JT1tJlWk2SqtfdJVJtnjSBjwEeU2kVt1/gB8=;
        b=dcAwtWrQYJGFqfEuuNJAGYjf1h8YZIuGphPGkkBr36zpcVecRjLrimqnEidmFe6OB8
         KdLh92jyQEfKLRCGQljrzarW/isowG+KI/OmrDhcX+IZ70PzGpdbmlvpLTENLI8lAw2b
         41oE3Kp6gwK8D+AA9fB1F2v4XxcaA3K5CiI3fW39NNuZcPfG4k0mpVa/MWQ/kZjnhv+2
         Av9Ip4/pIW8D3pROZSk4BodBQHktj/lNWNRLiF7GhTNNx3/B6SbEmvUoZ/uixfIPPfBM
         ayx2H2h0K/swwqnpMZL/wljk9lFBEGKWTHFTId59IfpQ/7FD1ZgVLuXQa5yeEdQNelYv
         AC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987065; x=1795591865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R/VgZr4JT1tJlWk2SqtfdJVJtnjSBjwEeU2kVt1/gB8=;
        b=xxw1d9mIUs3niSRvpqOrJY3czVrGnk2E/d6oOKfaucvUm2URcP/QniQv/9u03PgVEN
         9cvCpldGTE1w6jK92w+GFZuxD6NwCp6GDbpNWULoKJLAWi96+qkiDxg/XzWhkhfApQkH
         bKgQFAVh++bpOWbjQpPAzTG2N4VkbmWlkkyE7ACkiUqxIQsP/y6Lb3PrFd0nPHb3XD4k
         ay5WW8Ay2lEeR/9RXciweKs9aQPVDisAm7/wz2ccZhiedoPPj+5RlvGH7MsbOcapullp
         9qJV3SvPhItFXeCaXQYvhkN1yB2Y8cYMrsmTXeLp/th8IyW9wVlYh+MhMlLfJtrvNLPV
         Pw3Q==
X-Forwarded-Encrypted: i=1; AL+hErEznT+OSWYvE6oJ4NqiLfpQsUdy+H/MjHEqcgdtk4kuajU+0GSU/aK4Ph4QIzo+++oV3GdbCEM1K0WfsmJ+@vger.kernel.org
X-Gm-Message-State: APuU4Z8QYWLZEQPpCPiV5oyfALnTT3Vbk8Tz2R1Xer6KmMlfYoX7K08f
	t9kAhIYjNmycKv0zucy4drNopHUJtDtRjnW+I7Zjg1m+VqHRFQR0jvkg
X-Gm-Gg: AYBFou2JP7AcQCYa18NoztrcQiir2av7jgV0DiGs3RIhu32+TjNLs1PqkUlzaXwZ2dl
	RCyqXbemJA1hEPrJf3dHn+f4uYtR3TIBFajhABtykG12AYembOVwDWPYYPCWJtAPi6qdwF/DBMr
	Cy+gEOAW2NPnRxHXDHWzQ6fiQF10U7ou6I9PcHvmUMtI/0XbxZ9a/2gttmbxHkgC0t59+BV0z/j
	acQxYlWHz5zLcNeagtYT6lIIBv6KMCyPIsMJfWO06KQViJBHhk8v9lxhtmCsnHjPae3OiplntQC
	/42+AAZynto2+St0fnP1MfLYKql5lzpajyDnR95oxygMX1BxQdG/rQJfGafJA68LmmzlZP6Itua
	6lrHV4crstWh2OLpNo2Lz9ueZDDcIJv2+hDmfEkalzOX1kdjGRV3bNyfRSh0h+A+ORKLc5Tp4BY
	USSIOo4r24XVZJi28zGjcwfj3eE3ZQH51XESTJN2hy2eGX7QCZ5FXC3hsTO8gEQ/KKhYnwyW/wd
	NK8u9IEG6g1zTEQPgqX+P+mEkQZF6NqckanzH523AirR+knM5ffKLFFplFXrOdCNGT0BeyWgbbQ
	bRW98/+8y9qh4JIyrL2TTYgHcGahlaTjKzJ7tsYVAW9hmDpFiq/z7uIsJnaKcKli/UHWY3uHEmu
	w29N/FSMlK0dl
X-Received: by 2002:a17:906:4785:b0:c41:731c:534 with SMTP id a640c23a62f3a-c510e245d89mr129001066b.24.1794987065320;
        Tue, 17 Nov 2026 23:31:05 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c510cb14813sm64469466b.66.2026.11.17.23.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:31:04 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 2/6] ovl: do not allow offline lower changes with data-only layers
Date: Wed, 18 Nov 2026 08:30:58 +0100
Message-ID: <20261118073102.1216568-3-amir73il@gmail.com>
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

Offline changes to the lower layers are allowed only if none of the
features that depend on the lower layers being unchanged are used,
e.g. metacopy=on.

Commit 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for
lower -> data redirect") allowed data-only layers without metacopy=on.
Data-only layers imply lower metacopy files, but without metacopy=on,
ovl_allow_offline_changes() would still allow offline changes.

Use the presence of data-only layers as an indication that offline
changes are not allowed.

The only practical implication of this change is that an unprivileged
overlayfs mount with data-only layers and implicit metacopy will create
a new upper directory with user.overlay.opaque xattr to be consistent
with the behavior of privileged mounts with explicit metacopy=on.

Set ofs->numdatalayer before ovl_get_layers(), so that the check in
ovl_lower_uuid_ok() is done with the number of data-only layers.

Fixes: 5ef7bcdeecc9 ("ovl: relax redirect/metacopy requirements for lower -> data redirect")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 4 ++--
 fs/overlayfs/overlayfs.h                | 4 +++-
 fs/overlayfs/super.c                    | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index e01f7810c0271..688ab108f7478 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -679,8 +679,8 @@ a crash or deadlock.
 
 Offline changes, when the overlay is not mounted, are allowed to the
 upper tree.  Offline changes to the lower tree are only allowed if the
-"metacopy", "index", "xino" and "redirect_dir" features
-have not been used.  If the lower tree is modified and any of these
+"metacopy", "index", "xino", "redirect_dir" and data-only lower layers
+features have not been used.  If the lower tree is modified and any of these
 features has been used, the behavior of the overlay is undefined,
 though it will not result in a crash or deadlock.
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 646f8ffc40aef..943291da8b7fe 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -697,11 +697,13 @@ static inline bool ovl_is_volatile(struct ovl_config *config)
 /*
  * To avoid regressions in existing setups with overlay lower offline changes,
  * we allow lower changes only if none of the new features are used.
+ * Data-only layers imply lower metacopy files, even without metacopy=on.
  */
 static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
 {
 	return (!ofs->config.index && !ofs->config.metacopy &&
-		!ovl_redirect_dir(ofs) && !ovl_xino_warn(ofs));
+		!ofs->numdatalayer && !ovl_redirect_dir(ofs) &&
+		!ovl_xino_warn(ofs));
 }
 
 /* All layers on same fs? */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 990a470112c5c..58e4cc22d4de2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1255,6 +1255,8 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		return ERR_PTR(-EINVAL);
 	}
 
+	/* Needed by ovl_allow_offline_changes() */
+	ofs->numdatalayer = ctx->nr_data;
 	err = -EINVAL;
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];
@@ -1296,7 +1298,6 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		lowerstack[i].dentry = dget(l->path.dentry);
 		lowerstack[i].layer = &ofs->layers[i + 1];
 	}
-	ofs->numdatalayer = ctx->nr_data;
 
 	return oe;
 }
-- 
2.56.1

