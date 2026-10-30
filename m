Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793359929;
	b=w3yxc4TMkKCfqMrIbU1ZI/RmdYwCGClWX60MCx/aXBAvmLdSE8YH9IEEi0ijgfWrqm9c
	 QX1bIKVSG5oPu4Jj15U5BBRytl+6VRYtWdR03tBodXZl7hqsXo9wQND4wh5LiEgMmB1v/
	 JM9HDBl88HzyLxBH4hBiXKsUC3g9HS/w/4y5wbCOP6LoBTMHn1jE+vrrOc88eseRBkvIx
	 8y6ym21vf1ouhalhAJaEYObhoIB34zxsELwYpOu7uIpHI9OKGhXaGcxQGgHcsj2O0u0G3
	 QVK6Ypk5N3yaLoCgKk+ibbKO2Awlz1cRBcjMYBy1hFIsNGxbeZz1reRfC546bZ5A9+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793359929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w3FaApfnQUxZe5+ZRP29Y8HIAbXxDwnr+eEOtHj97Eo=;
	b=3j7bPEWyZZcvT3wM8/W0sSfIgGQpoOMXAad2qO8wSYUSpgc32fHlezd9r/k+6N/t6S+A
	 TOhlpSQpnaY1DItHhzQcHfa7J0YTdUeQXERYIq9LWNmqALMVOparEfELiQSgPHT9MUuro
	 p5AHJYn41vEGN7TD7pWH1B6pi/nJnTQQv53YVkKQGwk3GqnIb8nLXa/oczJSaxHcg6a4n
	 CQGapgr+4AF3L+Gizvm3uHhm57lDIfKLlNW/mmv+Rv5r99j5QlHFXMbmP58nX5u8sRt94
	 0NtSmvKcvM5aagZWj5w3d/USEU/LHrA43HVoXbSDF2u1O1hdQNqJCbthPuPdvmCSr2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SUplMQnD;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C26606A31D
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 11:32:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28C26606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SUplMQnD
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so3400775e9.2
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 04:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793359927; x=1793964727; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w3FaApfnQUxZe5+ZRP29Y8HIAbXxDwnr+eEOtHj97Eo=;
        b=SUplMQnDzEqeppg3hHhQFvs5OuRXjXuWed2i+5MTMjGwl/3gAaIW/U5/ZacB7PdaXd
         03t0KHi9CkOTNWMDvutW3nQG02sB363cOcP7gCGsvkcuJcTXYqy2uv9QWNkalaA3DNzs
         X7RGh2Iiey+zubRsGIOKz9+7wykxQnT6Jo34GgvXqz8qJQAplDexPdvRaEHnhHxLfwL3
         ATbRa4rbbaB/XcmYCLoHodnOvo8SS3zAAJ/nJmoPSs1vYcztUjmABPCrKeben+6BFtMr
         Gsddn6J/dR3hh32edF1RwvA6bUBAkppWDTSklMrWtLbR3pAk9D/xWvNP/iInwh27+2rq
         zvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793359927; x=1793964727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w3FaApfnQUxZe5+ZRP29Y8HIAbXxDwnr+eEOtHj97Eo=;
        b=BMu+RUrB2uCgnSOUlRhOTVriqaxrYbeQE2TTSR8txHEiS1v1V6IHoZWEa3EiF7kRci
         MBlsRjFwzD5epSkfYmVkVymhyFvjxYtJksrxbhSSIqc0TCOhIkE0kUfZ337s/oz8+Nwg
         es9Wo2zmTDHBXRWQ/JZn6Ggx+2vB2IXhQBs1bKz8//8v3NaDRW744yMMYSwu4sBkVcde
         edsq16mkRogRE61PyDJjE+F2vWUMeXz0ONBOwkYivr1KBYAyZuoQWu1CvKDv43CFRPnw
         Y7QgBqRa6LvaujqKy08m9Yhq3zo2alo71foc84jBvrdQGDJxDftd2isY0xbBw2bPhV3I
         19Bg==
X-Forwarded-Encrypted: i=1; AKwUvBwEbg0oRd2skERpOYSO0YYEuTYvaVRmDQDBpMxHh2svVSe6lWjZBIg6L+LzOMVLuiG02Xd31G+0qGvbLmff@vger.kernel.org
X-Gm-Message-State: AFq9FYLABK6URV81vlqojNUAlsf5j8fyTtXOdrF0otOvlAnBv66F8yqD
	eUe06YSJVo4uVFT1yeagyV8oFu6yHOIejyEqfDqd0qxyWyJBfTD0gYrK
X-Gm-Gg: AYBFou3n+m9efdUJpuTWZWtwNf169VohwK6zPa6Ohqm+pQlUYJ9ziZ1mwiZz3BnsK3K
	KJazlc4gzniJ7pJW1unWglmq7wgbhOkSNZGj4YoDCFY7fhuuYYcncnV9y1IGOuCCRtELb+Y0GDv
	KX9pdmwcK4oWNguTYuQGGKDa/8ESzL46nL1zPrtYQ5XB/MgvvY0LYdPdMikIEfkgTLDaOOHTpPg
	u7YoEYX8Mm2I9AOyw1fUqi3KObzCnozr0/XQLOQul1XIxgZX7evsw4ZLI0jURP4noDJjElfWO+y
	s8Vr/7S08E1cWTCxtNmqYIORphhHf6hoIgHm3epFJCXvUIv/dp8PoG+2rWsxrbTpmdguadTNJpw
	26RrI0bkvwpklS5TWaD9/DGNnTv4saGodzSFHT0qSuF2SeEuuqw+9E4ua5+LpXH2u09aWAGWGPI
	JOVB6uAxgjeQfXv5z53NWxPP2V5IqfwvDJIGlSCtvOCCW00rySCOZFYW6OlhWe9BSkNVQcWKhoY
	19F4QMMoE611PKUN2PEUbxhLKAknBZk6ZB9h1w7Li8kMuR80pNuAX/8B+hfrXGGwxtGjEFrxEnB
	SizFxSpRZsuwl6QMbxt7NbBjMO1v3k2RkoVH9fplS5PrRfjvAjCyY8E8Ag22e51P57RLb2b1jlE
	JVbKbpXKI/TNYEwaQzL996ceX1ywvAuJzAg==
X-Received: by 2002:a05:600c:a00d:b0:4a5:e6fd:65e5 with SMTP id 5b1f17b1804b1-4ac19705d57mr40416405e9.31.1793359927376;
        Fri, 30 Oct 2026 04:32:07 -0700 (PDT)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa813d2640sm129004595e9.6.2026.10.30.04.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 04:32:06 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/3] ovl: do not let chattr change the casefold flag
Date: Fri, 30 Oct 2026 12:32:00 +0100
Message-ID: <20261030113201.2921633-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261030113201.2921633-1-amir73il@gmail.com>
References: <20261030113201.2921633-1-amir73il@gmail.com>
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

chattr +F or -F on an overlay directory can make the directory, or the
whole mount, unusable. Lookups of the directory, and lookups in it, then
fail. From code inspection, the caller only needs to own the directory.
The upper filesystem must support casefolding: ext4 or f2fs with the
casefold feature, or tmpfs with the casefold option.

chattr +F and -F set and clear FS_CASEFOLD_FL, the casefold flag of a
directory. The flag enables casefolding (case-insensitive name lookup)
for the directory. All directories of an overlay must match the casefold
state that was recorded at mount time, and ovl_lookup_single() enforces
this:

- A lookup in a directory that does not match fails with -ESTALE.
- A lookup of the directory itself fails with -EREMOTE.

ovl_fileattr_set() copies the directory up, which creates it in the
upper layer if it only existed in a lower layer. It then passes
FS_CASEFOLD_FL on to the upper filesystem. The upper filesystem accepts
the change if the upper directory is empty, regardless of what the
merged directory contains. The merged directory is the one that the user
sees, with the names from the upper and the lower directories.

After the change the upper directory no longer matches the mount. If the
directory is the root of the overlay, the whole mount is affected.

The flag can also change without chattr +F or -F. chattr reads all flags
of a directory, changes one and writes all of them back. For a directory
that only exists in a lower layer, overlayfs reads the flags from the
lower filesystem. xfs with the ascii-ci feature reports FS_CASEFOLD_FL
on every inode, but never sets S_CASEFOLD, the inode flag that overlayfs
compares with the mount. So its directories count as not casefolded.
With a lower layer on such an xfs and an upper layer on ext4 with the
casefold feature, chattr +A on a lower-only directory therefore sets
FS_CASEFOLD_FL on the new, empty upper directory.

Reproduced as root on tmpfs and on ext4 with chattr +F or -F on an
overlay directory whose upper directory was empty. Afterwards lookups
below it failed with ESTALE, and lookups of the directory itself failed
with EREMOTE. The chattr +A case was seen once, on a kernel with an
earlier form of this patch that still passed the caller's flag on:
lookups of the directory failed with EREMOTE.

Fix this by returning -EOPNOTSUPP if FS_IOC_SETFLAGS, the only call that
can change the flag, asks for a casefold flag on a directory that does
not agree with the casefold state of the mount. This also refuses the
chattr +A case above.

Fixes: 083957f9614a ("ovl: support layers on case-folding capable filesystems")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[amir: check the flag against the casefold state of the mount instead of
 reading back the flags]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7e1ac70c5d97b..e3aa0931bea9f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -658,6 +658,14 @@ int ovl_fileattr_set(struct mnt_idmap *idmap,
 	unsigned int flags;
 	int err;
 
+	/*
+	 * Lookup refuses a directory that does not agree with the casefold
+	 * state of the mount. Only FS_IOC_SETFLAGS can ask for a change.
+	 */
+	if (S_ISDIR(inode->i_mode) && fa->flags_valid &&
+	    !!(fa->flags & FS_CASEFOLD_FL) != OVL_FS(inode->i_sb)->casefold)
+		return -EOPNOTSUPP;
+
 	err = ovl_copy_up(dentry);
 	if (!err) {
 		ovl_path_real(dentry, &upperpath);
-- 
2.55.0

