Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858F11B0F2C;
	Tue,  3 Jun 2025 10:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748945282; cv=none; b=R6mojZuN7KrPDb9tiyLPrafJQ4x/Nc596K3unJuzgkn9q99dHCIVF9YzFZniBLLWb8fajs3c9NDHwa5BVP6VuTFq2vE3aFldnX0l8AULZRWLHXh9F7NhBQS3Jyc8DhBOVZwYEWcUar7o7RsI9l39Hoj64vFNagKrny5+DUzCdkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748945282; c=relaxed/simple;
	bh=WCLIpJWaM0k+1KD++wWwH+7OVKapdVNwV912RO5ISvk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eMn+Aw6eVO/o09ZG0EVWHwlWh4JZKIfx8NT6ruaxTowu1kf0EyE89gGmr3PNp9KqQJi3AnCWVef1WnS867Y7n+H8sqZKcPDvfObicazaef7mUrbQoCZOIl/RaqD9AAAHt1bD+9hH3cDIMqLzvyTJ/8lsdez9i9qERnj/Mj8YNao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dOEpRDw7; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOEpRDw7"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43edecbfb46so39966945e9.0;
        Tue, 03 Jun 2025 03:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748945278; x=1749550078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OXfac7FAkhysP6c6kOczkwQlpkEZ3PyuXloCtwF7cko=;
        b=dOEpRDw76oC+1TNOiq6mYTuVgemiiT+VwuoocdW1fnf28VNOAKbPaVRrljNTbQ6uBv
         AlzxT1Tawmpt1K4ncrbNy58xJrzCPgdbzCOip/3dEKkPhZxx4QyNBKzN4HPEb+4AkdCg
         MvCtwBmJ7tPsn0EsHUAWA2eNxdcj7zR0KHXQZi5tQEpdt+dax2gF9GF66KbevgUQnMru
         geAKdVXN6I4WJV3oOJqKsLiXH2Bd2Y5+q37evdhcmtlR1pJn3pgYMZW7n8oYx2ACWk2T
         ax2tqfrPfquwLu45RWF1EAGKe6s5ILjp35H1HPJszJc+HdZEL/UVMsOhZiYH/ws8u1YV
         c1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748945278; x=1749550078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OXfac7FAkhysP6c6kOczkwQlpkEZ3PyuXloCtwF7cko=;
        b=PYIPAeTs1EY9b2uAu9qNL0jZBBGQxnsmTcoEsDmoYv5liQu9TyOV7nyLvVFrjfvXxt
         U1BNahDyMjf5zZlAXfiJ6Jp/vpKvQm38xn3Hoxapj7vFGpigbSQMIPr/SAAR6hn03w0U
         tcN0nmxrSSKe3ZiWLPyrV9+F4xzsWdBPXC+v2imCx5bNZA17R+tZNOLBvfg06VL1hlU1
         Z0RPpuLlt7QtZJ1b/JACEmfzbFYlx2Kfju3KmdIRnkOEQPNn+CLYSQHaTj7SwUQ3QGdA
         hCyrjlzsrxVKq5CnNNBGpQgsXVfRzdkNDUqD4FgjXM3kJ2zZY1VjJgPPM2guSMtFm7XR
         L4bQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2G/L51ZXiDL6zJd4AaJMJwlVEonumHpk20hN7wigq57iGqRRgMha2zSVbq8+EB65NIrF8cM7u@vger.kernel.org, AJvYcCWaZ1YOe+iaZoSbsSdwy6i0/yT3LEWOR64wlWOs/l7QrP2aD6UyjdiBNhsIxUxT+fQr6KyCG2jNHHJSRo++Uw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiEyx9YHaTgq/BdnaIBYZ/l9ugOo6YwKE9IHCkfmXWm2LHXmLu
	u5Ohw/5PfNfeL7bAy8/KRS5Xqv0RTC8/5L/gBCoKk/FAFNBYBdSTl3NJ
X-Gm-Gg: ASbGncuUTub2E2vqmnJfMZV2lKY1hoQRDayeLVRiiHAfnfqZitFXkziIlT32whDsoYs
	1f5h/pWia8XqE0Y54TkYp3UnzPkjMrAJFqtRnDW0x58u3mUVNom0DtJpYievDnopP2jfoNLLnUX
	MwVE9Ajsq6VPeF845P3wIWz2iYbcdqJoXEeE7UkptvF2gMJyXx87XiZT5RBXe+Ls9+S7hD1KCu4
	FlzFsH/OOf08V5DkCGwWEyMuvHblyR287W8lBm/L6eMXMjOh3kQaCCna4Sn2JRrltHNbEMBNo3g
	XtUyR3uvHV0+lmWP7jBoDI2kJIdPxIXLbhnDLOxyYEiPYbYn+pEX/ZUJoh5TLyGxM62ydEAzgS+
	H4prctjzQUub5zFJre2R8DeU3R7HBmGAwqSTDQnEo6Z+ttbHRkNpNsasHLmyiJ1h/aHdurw==
X-Google-Smtp-Source: AGHT+IFplTaTcuBH8sJAS/1LYV5qNfo060iaS1w0B0QENMi0Uhuc1xDWl+rnvR0zqY+3uhmvWNuUUQ==
X-Received: by 2002:a05:600c:8206:b0:442:f4a3:9388 with SMTP id 5b1f17b1804b1-450d8874ca9mr122778795e9.19.1748945277447;
        Tue, 03 Jun 2025 03:07:57 -0700 (PDT)
Received: from amir-ThinkPad-T480.arnhem.chello.nl (92-109-99-123.cable.dynamic.v4.ziggo.nl. [92.109.99.123])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa24c6sm157191525e9.12.2025.06.03.03.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jun 2025 03:07:56 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH v2 6/6] generic/699: fix failure with MOUNT_OPTIONS
Date: Tue,  3 Jun 2025 12:07:45 +0200
Message-Id: <20250603100745.2022891-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250603100745.2022891-1-amir73il@gmail.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

generic/699 uses overalyfs helper _overlay_mount_dirs, which is meant to
be used by overlayfs tests, where MOUNT_OPTIONS refer to overalyfs mount
options.

Using this helper from a generic test when FSTYP is not overlay is
causing undesired results. For example, when MOUNT_OPTIONS is defined
and includes a mount option not supported by overalyfs (e.g. 'acl'),
the test is notrun because of:

mount: /vdc/ovl-merge: fsconfig() failed: overlay: Unknown parameter 'acl'.

There is no other generic test that includes the common/overlay helpers
and uses them, so remove this practice from generic/699 as well.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/699 | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/tests/generic/699 b/tests/generic/699
index 620a40aa..2a6f857d 100755
--- a/tests/generic/699
+++ b/tests/generic/699
@@ -8,7 +8,6 @@
 # mounts specifically.
 #
 . ./common/preamble
-. ./common/overlay
 _begin_fstest auto quick perms attr idmapped mount
 
 # Override the default cleanup function.
@@ -96,20 +95,24 @@ reset_ownership()
 	stat -c '%u:%g' $path
 }
 
+setup_overlayfs()
+{
+	mkdir -p $upper $work $merge
+	_mount -t overlay -o lowerdir=$lower,upperdir=$upper,workdir=$work \
+		overlay $merge $*
+}
+
 # Prepare overlayfs with metacopy turned off.
 setup_overlayfs_idmapped_lower_metacopy_off()
 {
-	mkdir -p $upper $work $merge
-	_overlay_mount_dirs $lower $upper $work \
-			    overlay $merge -ometacopy=off || \
-			    _notrun "overlayfs doesn't support idmappped layers"
+	setup_overlayfs -ometacopy=off || \
+	    _notrun "overlayfs doesn't support idmappped layers"
 }
 
 # Prepare overlayfs with metacopy turned on.
 setup_overlayfs_idmapped_lower_metacopy_on()
 {
-	mkdir -p $upper $work $merge
-	_overlay_mount_dirs $lower $upper $work overlay $merge -ometacopy=on
+	setup_overlayfs -ometacopy=on
 }
 
 reset_overlayfs()
-- 
2.34.1

