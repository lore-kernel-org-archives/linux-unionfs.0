Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1539521C173;
	Thu, 10 Jul 2025 05:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752123976; cv=none; b=lAiTWW99bCVytv9pbfaoKfE1d2noEDbgfHApIn24osx1Rjna5E2n4nFQAFtp9sRnITHvDWgK1Ct8SgU1cU8CbyDL+p4FbmCz92b7BW5hz2jEoa8zhQq3FEsDZds5fEQC6oaRF0aYxyrosIkThF9I/N2qSU/IN5YWaqWvom2Vhx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752123976; c=relaxed/simple;
	bh=5+A/k+DXDPWqzIujSg+L8+cy6lC+c9TMkQJBbbJNpEE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aAtsyXknwYGPZW8xajGPE+2d/1OhGdRavwLnRPjb20E+sPs4ukdqlDx/t4b9J8Thjx/bCLjR4sGbBHMGUgG5fgqSQJhYm8ibIQeFuy9G16qaMgMfhjYFw1mlwXBXEm1UgVT1LBnJq3+8X0SPGKA4HWcymb2oJSXGVaybG/zg9zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ACLK+pJ5; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACLK+pJ5"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-235f9ea8d08so5918465ad.1;
        Wed, 09 Jul 2025 22:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752123974; x=1752728774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ufezQWuUmDdhETjzSA8kehCbZ0qaItdq5wj1opa808=;
        b=ACLK+pJ5NsrO/+qjy0C8cMgfeD6ZM5KvQAy+QzRsP65hbdXqxMZrqHz41wVBCaDiib
         R2fp/dGsC+4OzERj7LBA04GyieBm2HUyf27S9WkPqmobaveuAwd5H7vd3vT8EnnXfvCS
         iG5b1nY6FypAB2r49Kl5W+GhDP4CbsHoav6gssEDTNIEPifmpwXTTYVkzTLEjPF+l48J
         PEBEvzzUMkgE1sy6jI7WeH/YXgvcBpkZvWlrPjphHNBtxkmEAcJxJ5Ow6qNjrEuYyoU/
         q8Bsah7ERxbm/v4vRIkFmwQ4DQH0VYKZOVyC6uDS/MIgDi5pP9i9IxkOe9W72FQpic7q
         iMmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752123974; x=1752728774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ufezQWuUmDdhETjzSA8kehCbZ0qaItdq5wj1opa808=;
        b=CZOZanIdwqPYhQiXpzjE3N4azAzxjkXsijWfUwrxiDC9xl3bVYpWD/iHGOsG/Yf8KC
         MLy8qYUsmDBVv9UNiqT4ZtLFfRPjgyrojT23DNZIzDTGlwaSW+8QWqYoYgIz7kwoL+Aa
         X29uy2J9PslnzeS9IuMMbiWxf/ZAt9k1TSmhH96P1zqoxdFQBcS/4UxNMYGNh5LjP6o0
         j4Hzh6A+OIZFFR+XYT6/JaJEvXyS11pt1XTFmj0aPRkEBEeC7JGbN9qUivBgyFH8n0MK
         kZivgKhiK2Bbt7IjJ9TpW0bCeaIwqj3OCHENNoUz6wgOJDzdBZrJbRjgEJ62F8acQeK6
         uuiw==
X-Forwarded-Encrypted: i=1; AJvYcCUTp70SXGYG0OO+ovoUdpHbrwcIGMob3Sgf+uYyIrWXp6E4WEy236jUDse1IcfSYAOcgjsIAAzPS4w=@vger.kernel.org, AJvYcCX3kNghQV/Syw+sQrvXrtEldpbqD9+z+AVB3zWrNIeUvM0uvONgVbXmbf8Ze8BtmJU8/5Wv9KAfr9b8XZmXVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlEyzM50KKGkF7Uss0EIVM9xZALjns1Q+jVmmva7w9VNF6NR3+
	Kjtte8cV/NA0slaL5PettuX1qAbtDG//75HfmWs2Xa8eiWYSuWqRVv9dDks3mmRv
X-Gm-Gg: ASbGncvO/UXjkn4yTHiH/qqwSaMe5Wo6A0QHMjmt93dk+EsU/1wVhjNu8Z99k6OBASr
	b23Ijshm9bWJJnDinVBt5aJO4OxjaZCVIqlroeUtGkjOtAlADS3JZB/pvcki9Us9umQHocObpGU
	txoZ1JEDSJ4TDINrlVsyb36rvrrWPu+cWkt/2r54leqpB/6AMvYoy57BNNT+LQxej6T/1HlntFa
	Yso/JrK4M6LKilbSwIRW0dWeAuebevlsbTB7qG1JeHknCJlvrnBHDIzHTASScXY/Dikb6YIP8oG
	+uxS0+dH8oCfiltwxVTR9fNoewZEeMbteRMgLuVQHICfFaxj9zYCugpucrMRg1GZsuYFdpyfc5L
	eQmcOgaMw80pGOJLVZqvxoUynHIY=
X-Google-Smtp-Source: AGHT+IEoqOfeTQFyCtDdNzvcIy28zHW/0xPaR7yp06ctqw9ooZhdD73oP1Lbxfk3o/SsZaJfhAlGSQ==
X-Received: by 2002:a17:903:4b2d:b0:235:2e0:ab8 with SMTP id d9443c01a7336-23ddb1a04e3mr90994295ad.6.1752123974069;
        Wed, 09 Jul 2025 22:06:14 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4100:9c80:f536:f2df:c2a8:8b69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de43228b3sm9985845ad.135.2025.07.09.22.06.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Jul 2025 22:06:13 -0700 (PDT)
From: Matthias Frank <frank.mt125@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	Matthias Frank <frank.mt125@gmail.com>
Subject: [PATCH] overlayfs.rst: fix typos
Date: Wed,  9 Jul 2025 22:06:07 -0700
Message-Id: <20250710050607.2891-1-frank.mt125@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Grammatical fixes

Signed-off-by: Matthias Frank <frank.mt125@gmail.com>
Acked-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4133a336486d..6e0c572d33dc 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -9,7 +9,7 @@ Overlay Filesystem
 This document describes a prototype for a new approach to providing
 overlay-filesystem functionality in Linux (sometimes referred to as
 union-filesystems).  An overlay-filesystem tries to present a
-filesystem which is the result over overlaying one filesystem on top
+filesystem which is the result of overlaying one filesystem on top
 of the other.
 
 
@@ -425,7 +425,7 @@ of information from up to three different layers:
 The "lower data" file can be on any lower layer, except from the top most
 lower layer.
 
-Below the top most lower layer, any number of lower most layers may be defined
+Below the topmost lower layer, any number of lowermost layers may be defined
 as "data-only" lower layers, using double colon ("::") separators.
 A normal lower layer is not allowed to be below a data-only layer, so single
 colon separators are not allowed to the right of double colon ("::") separators.
@@ -445,8 +445,8 @@ to the absolute path of the "lower data" file in the "data-only" lower layer.
 
 Instead of explicitly enabling "metacopy=on" it is sufficient to specify at
 least one data-only layer to enable redirection of data to a data-only layer.
-In this case other forms of metacopy are rejected.  Note: this way data-only
-layers may be used toghether with "userxattr", in which case careful attention
+In this case other forms of metacopy are rejected.  Note: this way, data-only
+layers may be used together with "userxattr", in which case careful attention
 must be given to privileges needed to change the "user.overlay.redirect" xattr
 to prevent misuse.
 
@@ -515,7 +515,7 @@ supports these values:
     The metacopy digest is never generated or used. This is the
     default if verity option is not specified.
 - "on":
-    Whenever a metacopy files specifies an expected digest, the
+    Whenever a metacopy file specifies an expected digest, the
     corresponding data file must match the specified digest. When
     generating a metacopy file the verity digest will be set in it
     based on the source file (if it has one).
@@ -537,7 +537,7 @@ Using an upper layer path and/or a workdir path that are already used by
 another overlay mount is not allowed and may fail with EBUSY.  Using
 partially overlapping paths is not allowed and may fail with EBUSY.
 If files are accessed from two overlayfs mounts which share or overlap the
-upper layer and/or workdir path the behavior of the overlay is undefined,
+upper layer and/or workdir path, the behavior of the overlay is undefined,
 though it will not result in a crash or deadlock.
 
 Mounting an overlay using an upper layer path, where the upper layer path
@@ -778,7 +778,7 @@ controlled by the "uuid" mount option, which supports these values:
 - "auto": (default)
     UUID is taken from xattr "trusted.overlay.uuid" if it exists.
     Upgrade to "uuid=on" on first time mount of new overlay filesystem that
-    meets the prerequites.
+    meets the prerequisites.
     Downgrade to "uuid=null" for existing overlay filesystems that were never
     mounted with "uuid=on".
 
@@ -794,20 +794,20 @@ without significant effort.
 The advantage of mounting with the "volatile" option is that all forms of
 sync calls to the upper filesystem are omitted.
 
-In order to avoid a giving a false sense of safety, the syncfs (and fsync)
+In order to avoid giving a false sense of safety, the syncfs (and fsync)
 semantics of volatile mounts are slightly different than that of the rest of
 VFS.  If any writeback error occurs on the upperdir's filesystem after a
 volatile mount takes place, all sync functions will return an error.  Once this
 condition is reached, the filesystem will not recover, and every subsequent sync
-call will return an error, even if the upperdir has not experience a new error
+call will return an error, even if the upperdir has not experienced a new error
 since the last sync call.
 
 When overlay is mounted with "volatile" option, the directory
 "$workdir/work/incompat/volatile" is created.  During next mount, overlay
 checks for this directory and refuses to mount if present. This is a strong
-indicator that user should throw away upper and work directories and create
-fresh one. In very limited cases where the user knows that the system has
-not crashed and contents of upperdir are intact, The "volatile" directory
+indicator that the user should discard upper and work directories and create
+fresh ones. In very limited cases where the user knows that the system has
+not crashed and contents of upperdir are intact, the "volatile" directory
 can be removed.
 
 
-- 
2.39.5 (Apple Git-154)

