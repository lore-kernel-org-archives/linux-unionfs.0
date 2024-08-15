Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78ABB74C1B;
	Thu, 15 Aug 2024 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723753833; cv=none; b=L4ve4wk5pXAkEVhsDVTXb7x63ccfuG6Dbf/bHrzUNvRddppEQAdZGEK1nHCpY99knJtbMyERcfuMGu+0OWTXwgOiGKLX7rKqYnb1TPKR1RoVmMz4owy9S53fLCrCjeKiLt0hGFXGWXPQMEyVVuhpdwWPtUzrQLCSRelKXoh5ies=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723753833; c=relaxed/simple;
	bh=APCgVBy9MLb5QK5n2vPT9y8WJmiBL9BR79HRRV1oXWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SewojAZYnTEUgry5Nvsq2qd+SbcpkdyDZXKgKbzQlPwMnnLUE6Xza6QsNTkE2dZmR7WNs8BBAyRtSdt51Egnq45CHlhXnLigu0ALUiUT8/Ctjx9Q6PzVAl6jI1/n8U5lQpKw7r+oXkSvsLOXgx4PThcy9vA0lQ3aBdTObQwAhzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGDTD6i6; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGDTD6i6"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-530e062217eso1712971e87.1;
        Thu, 15 Aug 2024 13:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723753829; x=1724358629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9j0FSM+GTdYHqY0PhLOA9XFRc+jePrCUwJsUTGlfTO0=;
        b=YGDTD6i6/EVGrikoFablVoDpZAC/QYDUS8RWUkyL4rLi0+eeMHkbysU02OJV0xyg0A
         5jTX/gNwVLhacNRPhfudf+yt8rLL+r5G6R1qymXbnF/TSTYoAroxjQGsUi4KtOMVcMQf
         kxyJ703dJRwZxqQvHskBlcecExK3o8zgwGojgeSXLn7Fx+x5XsBa/39a50gvOA808G7b
         dF7HbV8+PgDExJhv5MX7j1iVelysDhX+geKnP3gWYCOCqsz1BcKYuaDq5FeSQzJplNr+
         OF6juHms1vVx/IZDiWWt26jgOcTS836MnqGQacMfIph9G9h0867yPQePbP/YbaHjB6/2
         YHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723753829; x=1724358629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9j0FSM+GTdYHqY0PhLOA9XFRc+jePrCUwJsUTGlfTO0=;
        b=NTjK5kpJzqxE3giLzOcktIIPj871eXa8jzG/zeOQLAyt/nvYPvKaHSmb9FeNEYDpBp
         Qr6TYCMoPsJtvFugkPY8gZSk9NHMlzz3k1xZrHhvaGw9POG15wL9tL76gI00m847j9th
         LghEdA3GvKsoYf07mAJQpBcShkPOwm0R7YVkhtdvskJ2WjzHA4vjbCayaB7vCu0AFRHt
         3swf08hs4P1jQ5sJRinwMM2IeoirSY2xX+/qxGLKIN54DkfB5e9GxoowAatwtD0dwlne
         yyt1q4VBVUA+42C0/TNqrh+yDrsCDuN+PypHwUVQGteUAoE7VLT8w/ERwhZiMYyIVrwz
         Znng==
X-Forwarded-Encrypted: i=1; AJvYcCWPl5/WcRBKLddW0wVGiUGXeHfCKymzvSZj0vT3Hk3Yh7macOcSP1Vo5Y/tEGDppWn67h7muxYOHJDA6qmZ1dDTRU+eMYfrLUBOsDShQAw9ijG2KoTSDKdZTXO8kR4FSmW2UGCzM2l1t0nAGBu+A7YKusF839+CZ7W37e5/0eh9aOQtp7AfLw==
X-Gm-Message-State: AOJu0YzKfO6GqSq9eH2gXRBVTInK054zvlSsQjqWdRo9ZfZMAGyfNLL2
	DdJEAF/UniKkm10Oywv8kM6anZx8MigD0KHmdH/riEJEdTnussuw
X-Google-Smtp-Source: AGHT+IGMiHWpoM0Kg6wRnxmQhgnXJAVUtI6uUN0bfec7vW2WzODJ47xPl/yL8ArDyapSDGAiTRgJzA==
X-Received: by 2002:a05:6512:1110:b0:52c:d819:517e with SMTP id 2adb3069b0e04-5331c6b050cmr423274e87.30.1723753828985;
        Thu, 15 Aug 2024 13:30:28 -0700 (PDT)
Received: from localhost.localdomain ([193.0.218.31])
        by smtp.googlemail.com with ESMTPSA id 2adb3069b0e04-5330d3af94esm315113e87.41.2024.08.15.13.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2024 13:30:28 -0700 (PDT)
From: Yuriy Belikov <yuriybelikov1@gmail.com>
To: 
Cc: yuriybelikov1@gmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Update redirect_dir and metacopy sections in overlayfs documentation
Date: Thu, 15 Aug 2024 23:30:04 +0300
Message-ID: <20240815203011.292977-1-yuriybelikov1@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch:
- Provides info about trusted.overlay.metacopy extended attribute.
- Extends the description of trusted.overlay.redirect
  with information about possible values of this xattr

Signed-off-by: Yuriy Belikov <yuriybelikov1@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 32 +++++++++++++++++++------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 165514401441..f4b68b8cd67d 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -207,11 +207,23 @@ handle it in two different ways:
    applications are usually prepared to handle this error (mv(1) for example
    recursively copies the directory tree).  This is the default behavior.
 
-2. If the "redirect_dir" feature is enabled, then the directory will be
-   copied up (but not the contents).  Then the "trusted.overlay.redirect"
-   extended attribute is set to the path of the original location from the
-   root of the overlay.  Finally the directory is moved to the new
-   location.
+2. If the "redirect_dir" feature is enabled, then the contents of the
+   directory will not be copied up after any name-modifying operations
+   (e.g. rename(2), or mv(1)). Instead of performing a copy-up operation,
+   an empty entry will be created in the upper layer with the same name
+   as the affected entry in the overlayfs directory. The 'trusted.overlay.redirect'
+   xattr will then be set to mark the upper-layer directory, indicating that
+   its contents weren't copied up due to the 'redirect_dir' feature.
+   This extended attribute holds the previous name of a directory as a value.
+   For directories that were simply renamed the attribute is just the old name
+   of the directory without preceding path. For directories whose locations
+   in the overlayfs directory were changed, the corresponding xattrs are set
+   to the paths to the original locations from the root of the overlay.
+   The value of the xattr in the second case starts with a UNIX path delimiter
+   (e.g. "/$PREVIOUS_PATH"). Finally the directory is moved
+   to the new location. The output of du "$UPPER_LAYTER_DIR/$RENAMED_DIR"
+   should be zero. Renamed directory subentries will be copied-up only
+   after operations that directly affect their contents.
 
 There are several ways to tune the "redirect_dir" feature.
 
@@ -367,8 +379,14 @@ Metadata only copy up
 
 When the "metacopy" feature is enabled, overlayfs will only copy
 up metadata (as opposed to whole file), when a metadata specific operation
-like chown/chmod is performed. Full file will be copied up later when
-file is opened for WRITE operation.
+like chown/chmod is performed. When file metadata are modified the
+corresponding empty file (with the same name as the modified one)
+appears in the upper layer, however such a file contains
+no allocated data (a sparse file); doing du "$UPPER_LAYER/$FILENAME"
+should yield zero. Such an upper-layer file is marked with
+"trusted.overlayfs.metacopy" xattr which indicates that this file contains
+no data and copy-up should be performed before the corresponding file
+in the overlayfs directory is opened for write.
 
 In other words, this is delayed data copy up operation and data is copied
 up when there is a need to actually modify data.
-- 
2.43.5

