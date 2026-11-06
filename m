Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793968471;
	b=VQixkXwXXpG9la2huB/4DBb3Opu03uSBp2IX9+QL1QOhnC0SwS9wcZOVllZu+qHxXGyK
	 I9IDq3nAOZegVejHbL6JdnePq3pPMRCPr2SSIXqhV30NbPYCAJ9N1ye3kn/v9I8CE5usu
	 22HIcyRAq+xlidmaVBJSI8WkqZP31ulp8WpF1HkDHVix1Qfq/Nzj9a6SxGIHWKxoJdX16
	 KIn8WDqbqPs7r+8O3pHq5YxfuqQgNUnf6uX++SgkG4kAvNI2aads/l+feBu9y6h2d9jGA
	 U5dDww13uvG0WrykrF4uDi8eCkRmNHdCvB2hI5xWOGQfEHr+Wu1635ErQm+4BcFQ6sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793968471;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=7iPFWmv91bwRmuYJusTGl3V1znrgoJ5UvO246yjWmxU=;
	b=NgEa1TMF8VCPOUjCDari+xxsBIk70KXKR28nSlsmQetYQ+efFmX51jXdOnyoQL6KRDlq
	 AwjReSZEdgqGwY+TBa8rN1iAIRVHgSuY7ptna18Q3qPkIav0d580Ntb+eF0hIcqx5kian
	 KbALP9ghWYzXvJT8HpMG9rD82FKXOYzB1kJrEOahsfjzBmYqwZfBBRdTkD0fpZIT71nnc
	 eRHH3eLy3WgrVa05qBOdrCY5R1kQY5SnlybqkJ+voJtTeAzWuSY9K+Alx5eWN82OyXJOD
	 XrYKKdgOdJpCIoZxz+6V3p5z9lEW1iXguiVzScEsnCAsQ00vXvL9YuD3mIaFcoYXCIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DwJidFVx;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95723606D80F
	for <linux-unionfs@vger.kernel.org>; Fri,  6 Nov 2026 12:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95723606D80F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DwJidFVx
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so641484a12.0
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Nov 2026 04:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793968469; x=1794573269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7iPFWmv91bwRmuYJusTGl3V1znrgoJ5UvO246yjWmxU=;
        b=DwJidFVx3Bx+rwF6E8M5LH3EX4vHlDVPpjI+u4fo/cve/HU9LPHUcZMUZn+s4Vr7Gb
         mHJInOVDlaUmC2ofE88AE5qudefc7X0piM+GB75qIdhC9rZRfPekyftExUYJimY4wHwb
         +d0oAl+VdbXptutQ4mb4MoEuq3KdIuQjXIyAkIEvt70yjEZV/57MrlvRHk8zxe93GcaN
         SE8z8Uoa2OT5vR3E+4mq6E2unGhi4ZKQYNEGqaZBuRFAheQwPKEOYzECw2KOjbJTfF6I
         UOd7q9EbiUBt6Zi3KRWcrEvPevsGAcZLaTF4Z4arG4iQ3MUsm/BW9u/YVDXNRpT7Snho
         NvYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793968469; x=1794573269;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7iPFWmv91bwRmuYJusTGl3V1znrgoJ5UvO246yjWmxU=;
        b=LAjuj/0dke50lazaSuNrne8aSPQXPt4h3280bCUaUFfaZpwXvoss39zMg4xgLMjOEW
         WFBx7db7p0e/pSTKpbg0d6WcF0OP560dkbjV3I44VMXKmc2w9c94mipCqVH++gUxJdea
         SbP5H9rLKwGSyZ+LMPS/Jdx42h7o1kE25HQP0eujmG9k1DZt8avtSBrj6lVpQ/Ue5kmB
         0c2mMbnV8a7bNhTJ6tYy1bVur1Ztxr1TYY8XTwTyPWj9VM8AERxI6i/sGDoev+BONSSL
         D+cE3/C9UhIvwoPGHXGJbkGJ8P7FvHrHEZf4P49uqvky7/CFWWN1MJHr5XZG1Q6mnAwJ
         9VWA==
X-Gm-Message-State: APuU4Z9cfxgjf2t61VDDi30yqygWZmdbw7eZARtrEYaTG0tAU2d354UI
	3Ukcz7wUIoe66oFwA9LI3LvueCUCHRe2xWgsG7Xl7E4zEafNspJpJdHY
X-Gm-Gg: AYBFou2iL//0Kh/EGOU849qQ1Hg3g4FaBI5150qmSS0bYKvJVc4or9dJ5JlpLaQmdD3
	xAZr7aAjPzrNC7H1io8xLgVgB32mY+ynkBzYygBIwVsomI9gD6wXEnVRiQkZknjXyneFmWlUB+u
	nvjKkEGK0rIKLgJI05z6eUhCxB6PAvBH9YrILcNw3zBMPt6Mn0gp6UA7zyuBrcyX930r9cS2k2J
	OZZPsvLS5VHmBQgOBKA74m8HfubMMxNAfRA26wfMVNvquAUty9ErAud8lQONEeeojRwI/8qIiXC
	z68JGvV2C6dNKSgXHxutquj8dVPbUC7+bWqlG0OBzzV5A9+VaeNE0qHNn6okrxCadVgzp52BVti
	FAiTJpAoJ5xLuf6ea7CtZ/9QDct4iGZVv1hLTyjvFj5YHvqbg9KU2HHmXhQ+wMY5j5uxicmZl9f
	JMv7uJMvm9zaX89yQ5d9bRfPSlapN6UTvSaRv79XgITL3Uclrn1hjQJqFh7renv/WkkqeyIqcR+
	MoivthZ0+zzDjcnUfi7pvQONKfQ26RXhInHXj6CW/SKsaD59zfCQVMH9CjCqGNqtYmXE2ktGF3S
	mCDKheGDrmr/akvXFekAF2S6PBgnTJTVh5e12P07SepdiWcsdHK/zTShtUbC6SrookPgudhr/SB
	R3xPeV7OiIIFjrw==
X-Received: by 2002:a17:907:3e18:b0:c29:3c97:c994 with SMTP id a640c23a62f3a-c4d354dea2bmr229915366b.35.1793968468443;
        Fri, 06 Nov 2026 04:34:28 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d35671585sm76518566b.39.2026.11.06.04.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 04:34:27 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] ovl: do not read the flags of a put upper dentry in lookup
Date: Fri,  6 Nov 2026 13:34:27 +0100
Message-ID: <20261106123427.3842634-1-amir73il@gmail.com>
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

ovl_lookup_layers() passes ctx->upperdentry to ovl_get_inode(), which
takes over the reference. If an overlay inode for the upper inode is
already cached, as for a second hard link, ovl_get_inode() puts the
dentry and returns the cached inode. ovl_lookup_layers() then passes
the put dentry to ovl_dentry_init_reval(), which reads its d_flags.

With a local upper fs the put dentry usually stays in the dcache, but
with a FUSE upper whose entry has timed out, dput() kills it, so this
is a use-after-free.

Fix this by taking the revalidate flags from the upper dentry of the
overlay inode, which is the one that ovl_dentry_revalidate_common()
revalidates.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-986db859-840c-479d-944c-b9c43b93377e
Fixes: bccece1ead36 ("ovl: allow remote upper")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 64d63b260709c..98e846b3846c4 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1382,9 +1382,17 @@ static int ovl_lookup_layers(struct ovl_lookup_ctx *ctx, struct ovl_lookup_data
 
 		if (metacopy_size > OVL_METACOPY_MIN_SIZE)
 			ovl_set_flag(OVL_HAS_DIGEST, ctx->inode);
-	}
 
-	ovl_dentry_init_reval(dentry, ctx->upperdentry, OVL_I_E(ctx->inode));
+		/*
+		 * ovl_get_inode() puts ctx->upperdentry if it finds a cached
+		 * inode, e.g. for another hard link, so use the upper dentry
+		 * of the inode.
+		 */
+		ovl_dentry_init_reval(dentry, ovl_i_dentry_upper(inode),
+				      OVL_I_E(inode));
+	} else {
+		ovl_dentry_init_reval(dentry, NULL, NULL);
+	}
 
 	return 0;
 }
-- 
2.55.0

